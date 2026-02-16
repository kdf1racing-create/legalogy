import Foundation

public enum LegalogyChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(LegalogyChatEventPayload)
    case agent(LegalogyAgentEventPayload)
    case seqGap
}

public protocol LegalogyChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> LegalogyChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [LegalogyChatAttachmentPayload]) async throws -> LegalogyChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> LegalogyChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<LegalogyChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension LegalogyChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "LegalogyChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> LegalogyChatSessionsListResponse {
        throw NSError(
            domain: "LegalogyChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}
