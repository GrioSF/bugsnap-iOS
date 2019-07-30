//
//  VideoFileWriter.swift
//  BugSnap
//
//  Created by Héctor García Peña on 7/23/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit
import AVFoundation
import ReplayKit

/**
    This class allows to have the objects required to write the video file with the video and audio tracks.
    This implementation uses the basic AVAssetWriter with multiple tracks to assemble a single video file. The name of the video file is initiated with the constant BugSnap.mp4 and is stored on the caches directory. This file is to be deleted once is uploaded to JIRA. The implementation is for a single use, so if you need to capture several files it's recommended to instantiate other VideoFileWriter.
 */
class VideoFileWriter : NSObject {
    
    // MARK: - Private Properties
    
    /// The default video file name
    static let defaultVideoFileName = "BugSnap.mp4"

    // MARK: -
    
    /// The default path for storing the temporary file
    var videoOutputURL : URL {
        //Create the file path to write to
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString
        return  URL(fileURLWithPath: cachesPath.appendingPathComponent(videoFileName))
    }
    
    /// The video file name setup on initialization
    var videoFileName : String
    
    // MARK: - AVFoundation
    
    /// The asset writer for the video file
    var assetWriter : AVAssetWriter? = nil
    
    /// The asset writer input for the video
    var videoInput : AVAssetWriterInput? = nil
    
    /// The asset writer input for the app's audio
    var appAudioInput : AVAssetWriterInput? = nil
    
    /// The asset writer input for the mic's audio
    var micAudioInput : AVAssetWriterInput? = nil
    
    // MARK: - Private Properties
    
    /// A lock mechanism to synchronize the calls between append and finishWriting for the assetWriter
    private var streamSynchronization = NSLock()
    
    /// Whether the asset writer was initialized
    private var assetWriterInitialized = false
    
    // MARK: - Initialization
    
    /**
        Initializes the asset writer and the audio tracks for assembling the video file. Replay Kit sends the microphone input and App's audio in different samples, so the AVAssetWriterInput for each stream of samples is used to have different tracks (video, app audio and mic audio).
        - Parameter fileName: The desired name for the file that is ultimately stored in the caches directory in the App's sandbox
    */
    init( with fileName : String? = nil ) {
        videoFileName = fileName ?? FileManager.buildAppFileName(fileExtension: "mp4")
        
        super.init()
        
        //Check the file does not already exist by deleting it if it does, remove it
        _ = try? FileManager.default.removeItem(at: videoOutputURL)
        
        /// Try to create the asset writer
        do {
            assetWriter = nil
            try assetWriter = AVAssetWriter(outputURL: videoOutputURL, fileType: AVFileType.mp4)
        } catch {
            assetWriter = nil;
            print("Error creating the video file \(error)")
            return;
        }
        
        guard let assetWriter = self.assetWriter else {
            NSLog("Couldn't create the asset writer for \(videoFileName) in the caches directory")
            return
        }

        let videoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: [
            AVVideoCodecKey  : AVVideoCodecType.h264,
            AVVideoWidthKey  : UIScreen.main.bounds.width,
            AVVideoHeightKey : UIScreen.main.bounds.height
            ])
        videoInput.expectsMediaDataInRealTime = true
        self.videoInput = videoInput
        assetWriter.add(videoInput);
        
        
        let appAudioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: [
            AVFormatIDKey : kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey: 44100 ])
        appAudioInput.expectsMediaDataInRealTime = true
        self.appAudioInput = appAudioInput
        assetWriter.add(appAudioInput)
        
        let micAudioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: [
            AVFormatIDKey : kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey : 1,
            AVSampleRateKey: 44100 ])
        micAudioInput.expectsMediaDataInRealTime = true
        self.micAudioInput = micAudioInput
        assetWriter.add(micAudioInput)
        
        // Setup the asset writer, but don't mark it as initialzied
        assetWriter.startWriting()
    }
    
    // MARK: - Methods
    
    /**
        Appends a sample from ReplayKit
        This convenience method should be called from the startCapture handler in order to append the stream of data to the corresponding track to assemble the video file.
        - Parameter cmSampleBuffer: The buffer that may contain video or audio
        - Parameter sampleType: The type of sample passed in cmSampleBuffer.
    */
    func append( sample cmSampleBuffer : CMSampleBuffer, sampleType : RPSampleBufferType ) {
        guard let videoWriter = self.assetWriter else { return }
        
        streamSynchronization.lock()
        
        // Check again the status of the asset writer
        if videoWriter.status == .unknown {
            videoWriter.startWriting()
        }
        
        if videoWriter.status == .writing && !assetWriterInitialized {
            NSLog("Starting session for the asset writer with first sample buffer. File \(videoFileName)");
            videoWriter.startSession(atSourceTime:  CMSampleBufferGetPresentationTimeStamp(cmSampleBuffer))
            assetWriterInitialized = true
        }
        
        defer {
            streamSynchronization.unlock()
        }
        
        // Check the status for the asset writer and the assetWriterInput in order to append the sample
        guard videoWriter.status == AVAssetWriter.Status.writing,
              let writerInput = assetWriter(for: sampleType)
            else {
                NSLog("Dropped Frame! \(sampleType)")
                return
        }
        
        // Check if we can append another sample
        if writerInput.isReadyForMoreMediaData {
            if !writerInput.append(cmSampleBuffer) {
                logStreamError(with: sampleType)
            }
        } else {
            NSLog("Asset Writer Input not ready for \(sampleType)")
        }
    }
    
    /**
     Returns the asset writer input for the Replay Kit sample type
     - Parameter sampleType: The Replay Kit sample buffer type
     - Returns: The corresponding AVAssetWriterInput for the specified track
     */
    func assetWriter( for sampleType : RPSampleBufferType ) -> AVAssetWriterInput? {
        switch sampleType {
        case .video:
            return videoInput
        case .audioApp:
            return appAudioInput
        case .audioMic:
            return micAudioInput
        default :
            return nil
        }
    }
    
    /**
        Closes the asset writer and invokes the handler in the main queue
        When the completion method is called the file is saved in the filesystem and can be accessed to process. This method uses a lock to ensure all the calls to append have finished
        - Parameter completion: The handler when the asset writer actually finishes writing the file.
     */
    func endWriter( completion : @escaping(()->Void)) {
        streamSynchronization.lock()
        assetWriter?.finishWriting {
            [weak self] in
            self?.videoInput = nil
            self?.appAudioInput = nil
            self?.micAudioInput = nil
            self?.streamSynchronization.unlock()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // MARK: - Support methods
    
    private func logStreamError( with sampleType : RPSampleBufferType ) {
        if let assetWriter = self.assetWriter,
            assetWriter.status == .failed ,
            let error = assetWriter.error {
            NSLog("There was a problem writing sample \(sampleType): Error \(error)")
        } else {
            NSLog("Unknown problem writing sample \(sampleType)")
        }
    }
}
