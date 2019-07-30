//
//  UIDevice+Logging.swift
//  BugSnap
//
//  Created by Héctor García Peña on 7/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
    The Fields proposed in https://docs.google.com/document/d/17FsNc5asHdvPlAHMflrWbfZGCLpwPGPQVomA0eNVk8E to be logged when submitting a bug to JIRA. These are some features of the device in which we're running the App.
*/
public struct DeviceLoggingFields {
    
    /// The manufacturer of the device. Currently only Apple uses iOS
    let manufacturer = "APPLE"
    
    /// The model of this device
    var model : String = ""
    
    /// The CPU for the device
    public var cpu : String = ""
    
    /// The total RAM for the device in GigaBytes
    var totalRAM : Double = 0
    
    /// The RAM used in GigaBytes
    var usedRAM : Double = 0
    
    /// The total storage for the device in GigaBytes
    var totalStorage : Double = 0
    
    /// The percentage of free storage
    var percentageFreeStorage : Double = 0.0
    
    /// The OS Version
    var osVersion : String = ""
    
    /// The current battery level percentage
    var batteryLevel : Double = 0.0
    
    /// The current state for the battery
    var batteryState : String = ""
    
    /// The current thermal state for the device
    var thermalState : String = ""
    
    /// The current screen resolution
    var resolution = CGSize.zero
    
    /// Screen density
    var dpi : UInt = 0
    
    /// Whether low power mode is enabled
    var lowPowerMode = false
    
    /// The screen scale
    var screenScale : Float = 0.0
}

/// The supported fields for a DeviceLoggingFields custom representation
public enum DeviceLoggingFieldsCustomRepresentation : String {
    
    case totalRAM
    case usedRAM
    case totalStorage
    case percentageFreeStorage
    case batteryLevel
}

public enum DeviceLoggingFieldsLabelsRepresentation : String {
    case manufacturer
    case model
    case cpu
    case totalRAM
    case usedRAM
    case totalStorage
    case percentageFreeStorage
    case osVersion
    case batteryLevel
    case batteryState
    case thermalState
    case resolution
    case dpi
    case lowPowerMode
    case screenScale
}

/**
    Creates the text presentation for a field in a DeviceLoggingFields
*/
public struct DeviceFeaturesTextPresenter {
    
    static func present( property : String, with value : Any ) -> String {
        
        guard let key = DeviceLoggingFieldsCustomRepresentation(rawValue: property) else {
            return "\(value)"
        }
        
        switch key {
            case .totalRAM,.usedRAM,.totalStorage:
                let formattedString = String(format: "%0.2f MegaBytes", locale: Locale.current, value as! Double)
                return formattedString
            case .percentageFreeStorage,.batteryLevel:
                return String(format: "%0.2f %%", locale: Locale.current, value as! Double)
        }
    }
    
    static func present( property : String ) -> String {
        guard let key = DeviceLoggingFieldsLabelsRepresentation(rawValue: property) else {
            return property
        }
        switch key {
        case .cpu,.dpi:
            return property.localizedUppercase
        case .totalRAM:
            return "Total RAM"
        case .usedRAM:
            return "Used RAM"
        case .totalStorage:
            return "Total Storage"
        case .percentageFreeStorage:
            return "Percentage of Storage Free"
        case .osVersion:
            return "OS Version"
        case .batteryLevel:
            return "Battery Percentage"
        case .batteryState:
            return "Battery Status"
        case .thermalState:
            return "Thermal State"
        case .resolution:
            return "Screen Resolution (pixels)"
        case .lowPowerMode:
            return "Low Power Mode Enabled"
        case .screenScale:
            return "Pixels per Point"
        default:
            return property.localizedCapitalized
        }
    }
}

/// Hard coded iOS Devices (model name, cpu and dpi) to map with model names returned by uname
public struct iOSDevice {
    
    /// The model name for the device , (e.g. iPhone X)
    var modelName : String
    
    /// The cpu model name for the device , (e.g. A12 Bionic)
    var cpuName : String
    
    /// The dpi for the device , (e.g 163 dpi)
    var dpi : Int
    
    init( model : String , cpu : String , dpi : Int ) {
        modelName = model
        cpuName = cpu
        self.dpi = dpi
    }
    
    // MARK: - iPad
    
    static let iPad1stGen = iOSDevice(model: "iPad", cpu: "Apple A4 SoC", dpi: 132)
    static let iPad2ndGen = iOSDevice(model: "iPad 2", cpu: "Apple A5", dpi: 132)
    static let iPad3rdGen = iOSDevice(model: "iPad (3rd generation)", cpu: "Apple A5X", dpi: 264)
    static let iPad4thGen = iOSDevice(model: "iPad (4th generation)", cpu: "Apple A6X", dpi: 264)
    static let iPad5thGen = iOSDevice(model: "iPad (5th generation)", cpu: "Apple A9", dpi: 264)
    static let iPad6thGen = iOSDevice(model: "iPad (6th generation)", cpu: "Apple A10 Fusion", dpi: 264)
    
    // MARK: - iPad Air
    
    static let iPadAir = iOSDevice(model: "iPad Air", cpu: "Apple A7 Variant", dpi: 264)
    static let iPadAir2 = iOSDevice(model: "iPad Air 2", cpu: "Apple A8X", dpi: 264)
    static let iPadAir3rdGen = iOSDevice(model: "iPad Air (3rd Generation)", cpu: "Apple A12", dpi: 264)
    
    // MARK: - iPad Pro
    
    static let iPadPro12_9 = iOSDevice(model: "iPad Pro (12.9-inch)", cpu: "Apple A9X", dpi: 264)
    static let iPadPro12_9_2ndGen = iOSDevice(model: "iPad Pro (12.9-inch) (2nd Generation)", cpu: "Apple A10X", dpi: 264)
    static let iPadPro12_9_3rdGen = iOSDevice(model: "iPad Pro (12.9-inch) (3rd Generation)", cpu: "Apple A12X", dpi: 264)
    
    static let iPadPro9_7 = iOSDevice(model: "iPad Pro (9.7-inch)", cpu: "Apple A9X", dpi: 264)
    
    static let iPadPro10_5 = iOSDevice(model: "iPad Pro (10.5-inch)", cpu: "Apple A10X", dpi: 264)
    
    static let iPadPro11 = iOSDevice(model: "iPad Pro (11-inch)", cpu: "Apple A12X", dpi: 264)
    
    // MARK: - iPad Mini
    
    static let iPadMini = iOSDevice(model: "iPad mini", cpu: "Apple A5 Rev A", dpi: 163)
    static let iPadMini2 = iOSDevice(model: "iPad mini 2", cpu: "Apple A7 SoC", dpi: 326)
    static let iPadMini3 = iOSDevice(model: "iPad mini 3", cpu: "Apple A7", dpi: 326)
    static let iPadMini4 = iOSDevice(model: "iPad mini 4", cpu: "Apple A8", dpi: 326)
    static let iPadMini5thGen = iOSDevice(model: "iPad mini (5th Generation)", cpu: "Apple A12", dpi: 326)
    
    // MARK: - iPhone
    
    static let iPhone = iOSDevice(model: "iPhone", cpu: "Samsung 1176JZ(F)-S v1.0", dpi: 163)
    static let iPhone3G = iOSDevice(model: "iPhone 3G", cpu: "Samsung 1176JZ(F)-S v1.0", dpi: 163)
    static let iPhone3GS = iOSDevice(model: "iPhone 3Gs", cpu: "Samsung S5PC100", dpi: 163)
    static let iPhone4 = iOSDevice(model: "iPhone 4", cpu: "Apple A4", dpi: 326)
    static let iPhone4S = iOSDevice(model: "iPhone 4s", cpu: "Apple 5 SoC", dpi: 326)
    static let iPhone5 = iOSDevice(model: "iPhone 5", cpu: "Apple A6 SoC", dpi: 326)
    static let iPhone5C = iOSDevice(model: "iPhone 5c", cpu: "Apple A6 SoC", dpi: 326)
    static let iPhone5S = iOSDevice(model: "iPhone 5s", cpu: "Apple A7", dpi: 326)
    static let iPhone6 = iOSDevice(model: "iPhone 6", cpu: "Apple A8", dpi: 326)
    static let iPhone6Plus = iOSDevice(model: "iPhone 6 Plus", cpu: "Apple A8", dpi: 401)
    static let iPhone6S = iOSDevice(model: "iPhone 6s", cpu: "Apple A9 SoC", dpi: 326)
    static let iPhone6SPlus = iOSDevice(model: "iPhone 6s Plus", cpu: "Apple A9", dpi: 401)
    static let iPhoneSE = iOSDevice(model: "iPhone SE", cpu: "Apple A9 SoC", dpi: 326)
    static let iPhone7 = iOSDevice(model: "iPhone 7", cpu: "Apple A10 SoC", dpi: 326)
    static let iPhone7Plus = iOSDevice(model: "iPhone 7 Plus", cpu: "Apple A10", dpi: 401)
    static let iPhone8 = iOSDevice(model: "iPhone 8", cpu: "Apple A11 SoC", dpi: 326)
    static let iPhone8Plus = iOSDevice(model: "iPhone 8 Plus", cpu: "Apple A11", dpi: 401)
    static let iPhoneX = iOSDevice(model: "iPhone X", cpu: "Apple A11 SoC", dpi: 458)
    static let iPhoneXR = iOSDevice(model: "iPhone Xr", cpu: "Apple A12 Bionic SoC", dpi: 326)
    static let iPhoneXS = iOSDevice(model: "iPhone Xs", cpu: "Apple A12 Bionic", dpi: 458)
    static let iPhoneXSMax = iOSDevice(model: "iPhone Xs Max", cpu: "Apple A12 Bionic", dpi: 458)
    
    // MARK: - iPod touch
    
    static let iPodTouch = iOSDevice(model: "iPod touch", cpu: "Samsung S5L8900", dpi: 163)
    static let iPodTouch2ndGen = iOSDevice(model: "iPod touch (2nd Generation)", cpu: "Samsung S5L8720", dpi: 163)
    static let iPodTouch3rdGen = iOSDevice(model: "iPod touch (3rd Generation)", cpu: "Saumsung S5L8922", dpi: 163)
    static let iPodTouch4thGen = iOSDevice(model: "iPod touch (4th Generation)", cpu: "Apple A4 SoC", dpi: 326)
    static let iPodTouch5thGen = iOSDevice(model: "iPod touch (5th Generation)", cpu: "Apple A5 SoC", dpi: 326)
    static let iPodTouch6thGen = iOSDevice(model: "iPod touch (6th Generation)", cpu: "Apple A8 with M8", dpi: 326)
    static let iPodTouch7thGen = iOSDevice(model: "iPod touch (7th Generation)", cpu: "Apple A10 Fusion", dpi: 326)
    
    // MARK: - Models Map
    
    /// This is the mapping of reported models agains the devices features
    static let map : [String:iOSDevice] = [
        
        "iPad1,1" : .iPad1stGen,
        "iPad2,1" : .iPad2ndGen,
        "iPad2,2" : .iPad2ndGen,
        "iPad2,3" : .iPad2ndGen,
        "iPad2,4" : .iPad2ndGen,
        "iPad3,1" : .iPad3rdGen,
        "iPad3,2" : .iPad3rdGen,
        "iPad3,3" : .iPad3rdGen,
        "iPad3,4" : .iPad4thGen,
        "iPad3,5" : .iPad4thGen,
        "iPad3,6" : .iPad4thGen,
        "iPad4,1" : .iPadAir,
        "iPad4,2" : .iPadAir,
        "iPad4,3" : .iPadAir,
        "iPad5,3" : .iPadAir2,
        "iPad5,4" : .iPadAir2,
        "iPad6,7" : .iPadPro12_9,
        "iPad6,8" : .iPadPro12_9,
        "iPad6,3" : .iPadPro9_7,
        "iPad6,4" : .iPadPro9_7,
        "iPad6,11": .iPad5thGen,
        "iPad6,12": .iPad5thGen,
        "iPad7,1" : .iPadPro12_9_2ndGen,
        "iPad7,2" : .iPadPro12_9_2ndGen,
        "iPad7,3" : .iPadPro10_5,
        "iPad7,4" : .iPadPro10_5,
        "iPad7,5" : .iPad6thGen,
        "iPad7,6" : .iPad6thGen,
        "iPad8,1" : .iPadPro11,
        "iPad8,2" : .iPadPro11,
        "iPad8,3" : .iPadPro11,
        "iPad8,4" : .iPadPro11,
        "iPad8,5" : .iPadPro12_9_3rdGen,
        "iPad8,6" : .iPadPro12_9_3rdGen,
        "iPad8,7" : .iPadPro12_9_3rdGen,
        "iPad8,8" : .iPadPro12_9_3rdGen,
        "iPad11,3": .iPadAir3rdGen,
        "iPad11,4": .iPadAir3rdGen,
        
        "iPad2,5" : .iPadMini,
        "iPad2,6" : .iPadMini,
        "iPad2,7" : .iPadMini,
        "iPad4,4" : .iPadMini2,
        "iPad4,5" : .iPadMini2,
        "iPad4,6" : .iPadMini2,
        "iPad4,7" : .iPadMini3,
        "iPad4,8" : .iPadMini3,
        "iPad4,9" : .iPadMini3,
        "iPad5,1" : .iPadMini4,
        "iPad5,2" : .iPadMini4,
        "iPad11,1": .iPadMini5thGen,
        "iPad11,2": .iPadMini5thGen,
        
        "iPhone1,1" : .iPhone,
        "iPhone1,2" : .iPhone3G,
        "iPhone2,1" : .iPhone3GS,
        "iPhone3,1" : .iPhone4,
        "iPhone3,2" : .iPhone4,
        "iPhone3,3" : .iPhone4,
        "iPhone4,1" : .iPhone4S,
        "iPhone5,1" : .iPhone5,
        "iPhone5,2" : .iPhone5,
        "iPhone5,3" : .iPhone5C,
        "iPhone5,4" : .iPhone5C,
        "iPhone6,1" : .iPhone5S,
        "iPhone6,2" : .iPhone5S,
        "iPhone7,2" : .iPhone6,
        "iPhone7,1" : .iPhone6Plus,
        "iPhone8,1" : .iPhone6S,
        "iPhone8,2" : .iPhone6SPlus,
        "iPhone8,4" : .iPhoneSE,
        "iPhone9,1" : .iPhone7,
        "iPhone9,3" : .iPhone7,
        "iPhone9,2" : .iPhone7Plus,
        "iPhone9,4" : .iPhone7Plus,
        "iPhone10,1" : .iPhone8,
        "iPhone10,4" : .iPhone8,
        "iPhone10,2" : .iPhone8Plus,
        "iPhone10,5" : .iPhone8Plus,
        "iPhone10,3" : .iPhoneX,
        "iPhone10,6" : .iPhoneX,
        "iPhone11,8" : .iPhoneXR,
        "iPhone11,2" : .iPhoneXS,
        "iPhone11,6" : .iPhoneXSMax,
        
        "iPod1,1" : .iPodTouch,
        "iPod2,1" : .iPodTouch2ndGen,
        "iPod3,1" : .iPodTouch3rdGen,
        "iPod4,1" : .iPodTouch4thGen,
        "iPod5,1" : .iPodTouch5thGen,
        "iPod7,1" : .iPodTouch6thGen,
        "iPod9,1" : .iPodTouch7thGen
    ]
}

/// Extension to retrieve the current battery state
public extension UIDevice.BatteryState {
    
    /// Returns a human readable description
    var string : String {
        var currentState = "Unknown"
        switch self {
        case .charging:
            currentState = "Charging"
        case .unplugged:
            currentState = "Unplugged"
        case .full:
            currentState = "Full"
        default:
            break
        }
        return currentState
    }
}

/// Extension to map the current thermal state to some human readable string
public extension ProcessInfo.ThermalState {
    
    /// Human readable string for the thermal state
    var string : String {
        var currentState = "Unknown"
        switch self {
        case .critical:
            currentState = "Critical"
        case .fair:
            currentState = "Fair"
        case .nominal:
            currentState = "Nominal"
        case .serious:
            currentState = "Serious"
        default:
            break
        }
        return currentState
    }
}

/// The amount of bytes in a GigaByte
fileprivate let GigaByteBytes : Int64 = 1024 * 1024 * 1024

/// The amount of bytes in a MegaByte
fileprivate let MegaByteBytes : Int64 = 1024 * 1024


/// Extension to retrieve the required fields in DeviceLoggingFields filled up
public extension UIDevice {
    
    var deviceLoggingData : DeviceLoggingFields {
        var data = DeviceLoggingFields()
        isBatteryMonitoringEnabled = true
        data.batteryLevel = Double(batteryLevel * 100.0)
        data.batteryState = batteryState.string
        
        let model = readableModel
        if let deviceInfo = iOSDevice.map[model] {
            data.model = "\(deviceInfo.modelName) (\(model))"
            data.cpu = deviceInfo.cpuName
            data.dpi = UInt(deviceInfo.dpi)
        } else {
            data.model = "\(model)"
            data.cpu = "?"
        }
        
        // Screen features
        data.screenScale = Float(UIScreen.main.scale)
        data.resolution = CGSize(width: UIScreen.main.bounds.width*UIScreen.main.scale, height: UIScreen.main.bounds.height*UIScreen.main.scale)
        
        // Data from the process info
        let processInfo = ProcessInfo.processInfo
        data.thermalState = processInfo.thermalState.string
        data.lowPowerMode = processInfo.isLowPowerModeEnabled
        data.osVersion = "\(systemName) \(processInfo.operatingSystemVersionString)"
        
        // Memory
        data.totalRAM = floor(Double(processInfo.physicalMemory)/Double(MegaByteBytes))
        data.usedRAM = floor(Double(usedRAM)/Double(MegaByteBytes))
        
        // Storage
        data.totalStorage = floor(Double(storageSize)/Double(MegaByteBytes))
        data.percentageFreeStorage = Double(freeDiskSpace)/Double(storageSize)*100.0
        
        return data
    }
    
    /**
        Gets the amount of used RAM
        see: https://stackoverflow.com/questions/5012886/determining-the-available-amount-of-ram-on-an-ios-device
    */
    var usedRAM : Int64 {
        var pagesize: vm_size_t = 0
        
        let host_port: mach_port_t = mach_host_self()
        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        host_page_size(host_port, &pagesize)
        
        var vm_stat: vm_statistics = vm_statistics_data_t()
        withUnsafeMutablePointer(to: &vm_stat) { (vmStatPointer) -> Void in
            vmStatPointer.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                if (host_statistics(host_port, HOST_VM_INFO, $0, &host_size) != KERN_SUCCESS) {
                    NSLog("Error: Failed to fetch vm statistics")
                }
            }
        }
        
        /* Stats in bytes */
        let mem_used: Int64 = Int64(vm_stat.active_count +
            vm_stat.inactive_count +
            vm_stat.wire_count) * Int64(pagesize)
        return mem_used
    }
    
    /// Returns the amount of disk space in bytes for the device
    var storageSize : UInt64 {
        guard let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let size = attributes[.systemSize] as? NSNumber else {
            NSLog("Couldn't get the filesystem size")
                return 0
        }
        
        return size.uint64Value
    }

    /// Returns the free disk space in bytes for the device
    var freeDiskSpace : UInt64 {
        guard let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
            let size = attributes[.systemFreeSize] as? NSNumber else {
                NSLog("Couldn't get the filesystem size")
                return 0
        }
        return size.uint64Value
    }
    
    /// Returns the device model (iphone x... etc)
    var readableModel : String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let deviceModel = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { (ptr)  in
                return String(cString: ptr, encoding: .utf8)
            }
        }
        
        /*
        let version = withUnsafePointer(to: &systemInfo.version) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { (ptr)  in
                return String(cString: ptr, encoding: .utf8)
            }
        }
        
        let nodename = withUnsafePointer(to: &systemInfo.nodename) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { (ptr)  in
                return String(cString: ptr, encoding: .utf8)
            }
        }
        */
        
        return deviceModel!
    }

}
