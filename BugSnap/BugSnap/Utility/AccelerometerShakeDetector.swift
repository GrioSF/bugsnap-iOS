//
//  AccelerometerShakeDetector.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit
import CoreMotion

/// Possible values for the result of starting the accelerometer
public enum AccelerometerStartResult : String {
    
    /// There's no such sensor on the device
    case noAcelerometerAvailable
    
    /// The accelerometer was already active
    case accelerometerAlreadyActive
    
    /// The accelerometer was started
    case started
}

/// Notifications to be sent when the shake event has been detected
extension NSNotification.Name {
    
    /// Notification sent with NotificationCenter with no user info and object == nil
    static let shakeEventDetected = NSNotification.Name("shakeEventDetected")
}

/**
    Singleton class associated with UIApplication that will manage the accelerometer data filtering and will ultimately detect the generation of a shake event.
*/
public class AccelerometerShakeDetector: NSObject {
    
    // MARK: - Public Properties
    
    /// The time to wait until the devices settles after a shake is detected
    var timeToSettleAfterShake : TimeInterval = 1.0
    
    // MARK: - Private Properties
    
    /// The operation queue to capture acceleration data
    private var accelerometerUpdateQueue = OperationQueue()
    
    /// The motion manager associated with the shake detector
    private var motionManager = CMMotionManager()
    
    /// Value for implementing the high pass filter
    private var rollingAcceleration = CMAcceleration()
    
    /// Value for the previous acceleration
    private var previousAcceleration = CMAcceleration()
    
    /// Value for the previous slope
    private var previousSlope = CMAcceleration()
    
    /// The threshold for a peak
    private let thresholdPeak = 3.0
    
    /// The last time we detected a peak
    private var lastTimePeak : TimeInterval = 0
    
    /// The number of peaks
    private var numberOfPeaks : Int = 0
    
    /// The frequency for sampling the accelerometer data
    private let accelerometerFrequency : TimeInterval = 1.0 / 20.0
    
    /// The filtering factor to implement the high pass filter
    private let filteringFactor = 0.1
    
    /// Whether we detected a shake and waiting to estabilize so we can trigger the event
    private var waitingForStabilization = false
    
    // MARK: - Deinit
    
    deinit {
        stopAccelerometerUpdates()
    }
    
    // MARK: - Methods
    
    /**
        Starts the accelerometer for interpreting the accelerometer data and try to get a shake gesture
        - Returns: The result status for the operation.
    */
    func startAccelerometerUpdates() -> AccelerometerStartResult {
        
        if !motionManager.isAccelerometerAvailable {
            return .noAcelerometerAvailable
        }
        
        // Check if it's already active
        if motionManager.isAccelerometerActive {
            return .accelerometerAlreadyActive
        }
        
        motionManager.accelerometerUpdateInterval = accelerometerFrequency
        motionManager.startAccelerometerUpdates(to: accelerometerUpdateQueue) { [weak self] (data, error) in
            self?.processAccelerometerData(data: data, error: error)
        }
        return .started
    }
    
    /**
        Stops the accelerometer updates immediately if the sensor is available and the accelerometer is active
    */
    func stopAccelerometerUpdates() {
        guard motionManager.isAccelerometerAvailable && motionManager.isAccelerometerActive else { return }
        motionManager.stopAccelerometerUpdates()
    }
    
    // MARK: - Support
    
    /**
        Process the accelerometer data
        - Parameter data: The data provided by the sensor
        - Parameter error: A possible error given by the sensor
    */
    private func processAccelerometerData( data : CMAccelerometerData? , error : Error?) {
        guard error == nil,
              let acceleration = data?.acceleration else {
            NSLog("Error in accelerometer data: \(String(describing: error))")
            return
        }
        
        rollingAcceleration.x = acceleration.x * filteringFactor + rollingAcceleration.x * (1.0 - filteringFactor)
        rollingAcceleration.y = acceleration.y * filteringFactor + rollingAcceleration.y * (1.0 - filteringFactor)
        rollingAcceleration.z = acceleration.x * filteringFactor + rollingAcceleration.z * (1.0 - filteringFactor)
        
        let currentAcceleration = CMAcceleration(x: acceleration.x - rollingAcceleration.x,
                                                 y: acceleration.y - rollingAcceleration.y,
                                                 z: acceleration.z - rollingAcceleration.z)
        
        /// Just save the first sample captured
        guard previousAcceleration.x != 0.0 && previousAcceleration.y != 0.0 && previousAcceleration.z != 0.0 else {
            previousAcceleration = currentAcceleration
            return
        }
        
        
        // Basically the algorithm will count the slope sign changes altogether its magnitude. The graph for a shake
        // is basically like a signal with multiple peaks in some axis, so if we start into such movement it will
        // change the slope several times within a short time
        
        let slope = CMAcceleration(x: currentAcceleration.x - previousAcceleration.x,
                                   y: currentAcceleration.y - previousAcceleration.y,
                                   z: currentAcceleration.z - previousAcceleration.z)
    
        guard previousSlope.x != 0.0 && previousSlope.y != 0.0 && previousSlope.z != 0.0 else {
            previousSlope = slope
            return
        }
        
        /// This would be like the second difference, that basically will give us whether we have a significative movement at all
        let secondDifference = CMAcceleration(x: abs(slope.x-previousSlope.x),
                                              y: abs(slope.y-previousSlope.y),
                                              z: abs(slope.z-previousSlope.z))
        
        //print("Second difference x: \(round(secondDifference.x)) y: \(round(secondDifference.y)) z: \(round(secondDifference.z))")
        
        /// Check if we have peaks in any axis
        if round(secondDifference.x) >= thresholdPeak ||
           round(secondDifference.y) >= thresholdPeak ||
           round(secondDifference.z) >= thresholdPeak {
           waitingForStabilization = true
           lastTimePeak = data!.timestamp
           numberOfPeaks += 1
        // Check if we have stopped shaking the device (with a minimum number of peaks)
        } else if waitingForStabilization &&  (data!.timestamp - lastTimePeak) > timeToSettleAfterShake && numberOfPeaks >= 5 {
            waitingForStabilization = false
            numberOfPeaks = 0
            lastTimePeak = data!.timestamp
            
            // Notify in the main thread the event
            OperationQueue.main.addOperation {
                [weak self] in
                
                self?.notifyShake()
            }
        }
    }
    
    // MARK: - Main Thread notifying
    
    /**
        Notifies the shake event.
        This method notifies that a shake event has ocurred so interested consumers can opt to listen to the shakeEventDetected notification.
        Also it triggers the user interface that captures the top most view controller 
    */
    private func notifyShake() {
        NotificationCenter.default.post(name: .shakeEventDetected, object: nil)
    }
    
}
