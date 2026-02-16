import CoreLocation
import Foundation
import LegalogyKit
import UIKit

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: LegalogyCameraSnapParams) async throws -> (format: String, base64: String, width: Int, height: Int)
    func clip(params: LegalogyCameraClipParams) async throws -> (format: String, base64: String, durationMs: Int, hasAudio: Bool)
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: LegalogyLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: LegalogyLocationGetParams,
        desiredAccuracy: LegalogyLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: LegalogyLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

protocol DeviceStatusServicing: Sendable {
    func status() async throws -> LegalogyDeviceStatusPayload
    func info() -> LegalogyDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: LegalogyPhotosLatestParams) async throws -> LegalogyPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: LegalogyContactsSearchParams) async throws -> LegalogyContactsSearchPayload
    func add(params: LegalogyContactsAddParams) async throws -> LegalogyContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: LegalogyCalendarEventsParams) async throws -> LegalogyCalendarEventsPayload
    func add(params: LegalogyCalendarAddParams) async throws -> LegalogyCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: LegalogyRemindersListParams) async throws -> LegalogyRemindersListPayload
    func add(params: LegalogyRemindersAddParams) async throws -> LegalogyRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: LegalogyMotionActivityParams) async throws -> LegalogyMotionActivityPayload
    func pedometer(params: LegalogyPedometerParams) async throws -> LegalogyPedometerPayload
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}
