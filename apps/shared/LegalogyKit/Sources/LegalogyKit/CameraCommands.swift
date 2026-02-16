import Foundation

public enum LegalogyCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum LegalogyCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum LegalogyCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum LegalogyCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct LegalogyCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: LegalogyCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: LegalogyCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: LegalogyCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: LegalogyCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct LegalogyCameraClipParams: Codable, Sendable, Equatable {
    public var facing: LegalogyCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: LegalogyCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: LegalogyCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: LegalogyCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
