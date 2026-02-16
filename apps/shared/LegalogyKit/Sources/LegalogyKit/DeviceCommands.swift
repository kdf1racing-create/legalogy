import Foundation

public enum LegalogyDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum LegalogyBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum LegalogyThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum LegalogyNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum LegalogyNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct LegalogyBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: LegalogyBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: LegalogyBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct LegalogyThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: LegalogyThermalState

    public init(state: LegalogyThermalState) {
        self.state = state
    }
}

public struct LegalogyStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct LegalogyNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: LegalogyNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [LegalogyNetworkInterfaceType]

    public init(
        status: LegalogyNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [LegalogyNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct LegalogyDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: LegalogyBatteryStatusPayload
    public var thermal: LegalogyThermalStatusPayload
    public var storage: LegalogyStorageStatusPayload
    public var network: LegalogyNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: LegalogyBatteryStatusPayload,
        thermal: LegalogyThermalStatusPayload,
        storage: LegalogyStorageStatusPayload,
        network: LegalogyNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct LegalogyDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}
