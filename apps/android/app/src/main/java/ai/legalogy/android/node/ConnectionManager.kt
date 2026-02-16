package ai.legalogy.android.node

import android.os.Build
import ai.legalogy.android.BuildConfig
import ai.legalogy.android.SecurePrefs
import ai.legalogy.android.gateway.GatewayClientInfo
import ai.legalogy.android.gateway.GatewayConnectOptions
import ai.legalogy.android.gateway.GatewayEndpoint
import ai.legalogy.android.gateway.GatewayTlsParams
import ai.legalogy.android.protocol.LegalogyCanvasA2UICommand
import ai.legalogy.android.protocol.LegalogyCanvasCommand
import ai.legalogy.android.protocol.LegalogyCameraCommand
import ai.legalogy.android.protocol.LegalogyLocationCommand
import ai.legalogy.android.protocol.LegalogyScreenCommand
import ai.legalogy.android.protocol.LegalogySmsCommand
import ai.legalogy.android.protocol.LegalogyCapability
import ai.legalogy.android.LocationMode
import ai.legalogy.android.VoiceWakeMode

class ConnectionManager(
  private val prefs: SecurePrefs,
  private val cameraEnabled: () -> Boolean,
  private val locationMode: () -> LocationMode,
  private val voiceWakeMode: () -> VoiceWakeMode,
  private val smsAvailable: () -> Boolean,
  private val hasRecordAudioPermission: () -> Boolean,
  private val manualTls: () -> Boolean,
) {
  companion object {
    internal fun resolveTlsParamsForEndpoint(
      endpoint: GatewayEndpoint,
      storedFingerprint: String?,
      manualTlsEnabled: Boolean,
    ): GatewayTlsParams? {
      val stableId = endpoint.stableId
      val stored = storedFingerprint?.trim().takeIf { !it.isNullOrEmpty() }
      val isManual = stableId.startsWith("manual|")

      if (isManual) {
        if (!manualTlsEnabled) return null
        if (!stored.isNullOrBlank()) {
          return GatewayTlsParams(
            required = true,
            expectedFingerprint = stored,
            allowTOFU = false,
            stableId = stableId,
          )
        }
        return GatewayTlsParams(
          required = true,
          expectedFingerprint = null,
          allowTOFU = false,
          stableId = stableId,
        )
      }

      // Prefer stored pins. Never let discovery-provided TXT override a stored fingerprint.
      if (!stored.isNullOrBlank()) {
        return GatewayTlsParams(
          required = true,
          expectedFingerprint = stored,
          allowTOFU = false,
          stableId = stableId,
        )
      }

      val hinted = endpoint.tlsEnabled || !endpoint.tlsFingerprintSha256.isNullOrBlank()
      if (hinted) {
        // TXT is unauthenticated. Do not treat the advertised fingerprint as authoritative.
        return GatewayTlsParams(
          required = true,
          expectedFingerprint = null,
          allowTOFU = false,
          stableId = stableId,
        )
      }

      return null
    }
  }

  fun buildInvokeCommands(): List<String> =
    buildList {
      add(LegalogyCanvasCommand.Present.rawValue)
      add(LegalogyCanvasCommand.Hide.rawValue)
      add(LegalogyCanvasCommand.Navigate.rawValue)
      add(LegalogyCanvasCommand.Eval.rawValue)
      add(LegalogyCanvasCommand.Snapshot.rawValue)
      add(LegalogyCanvasA2UICommand.Push.rawValue)
      add(LegalogyCanvasA2UICommand.PushJSONL.rawValue)
      add(LegalogyCanvasA2UICommand.Reset.rawValue)
      add(LegalogyScreenCommand.Record.rawValue)
      if (cameraEnabled()) {
        add(LegalogyCameraCommand.Snap.rawValue)
        add(LegalogyCameraCommand.Clip.rawValue)
      }
      if (locationMode() != LocationMode.Off) {
        add(LegalogyLocationCommand.Get.rawValue)
      }
      if (smsAvailable()) {
        add(LegalogySmsCommand.Send.rawValue)
      }
      if (BuildConfig.DEBUG) {
        add("debug.logs")
        add("debug.ed25519")
      }
      add("app.update")
    }

  fun buildCapabilities(): List<String> =
    buildList {
      add(LegalogyCapability.Canvas.rawValue)
      add(LegalogyCapability.Screen.rawValue)
      if (cameraEnabled()) add(LegalogyCapability.Camera.rawValue)
      if (smsAvailable()) add(LegalogyCapability.Sms.rawValue)
      if (voiceWakeMode() != VoiceWakeMode.Off && hasRecordAudioPermission()) {
        add(LegalogyCapability.VoiceWake.rawValue)
      }
      if (locationMode() != LocationMode.Off) {
        add(LegalogyCapability.Location.rawValue)
      }
    }

  fun resolvedVersionName(): String {
    val versionName = BuildConfig.VERSION_NAME.trim().ifEmpty { "dev" }
    return if (BuildConfig.DEBUG && !versionName.contains("dev", ignoreCase = true)) {
      "$versionName-dev"
    } else {
      versionName
    }
  }

  fun resolveModelIdentifier(): String? {
    return listOfNotNull(Build.MANUFACTURER, Build.MODEL)
      .joinToString(" ")
      .trim()
      .ifEmpty { null }
  }

  fun buildUserAgent(): String {
    val version = resolvedVersionName()
    val release = Build.VERSION.RELEASE?.trim().orEmpty()
    val releaseLabel = if (release.isEmpty()) "unknown" else release
    return "LegalogyAndroid/$version (Android $releaseLabel; SDK ${Build.VERSION.SDK_INT})"
  }

  fun buildClientInfo(clientId: String, clientMode: String): GatewayClientInfo {
    return GatewayClientInfo(
      id = clientId,
      displayName = prefs.displayName.value,
      version = resolvedVersionName(),
      platform = "android",
      mode = clientMode,
      instanceId = prefs.instanceId.value,
      deviceFamily = "Android",
      modelIdentifier = resolveModelIdentifier(),
    )
  }

  fun buildNodeConnectOptions(): GatewayConnectOptions {
    return GatewayConnectOptions(
      role = "node",
      scopes = emptyList(),
      caps = buildCapabilities(),
      commands = buildInvokeCommands(),
      permissions = emptyMap(),
      client = buildClientInfo(clientId = "legalogy-android", clientMode = "node"),
      userAgent = buildUserAgent(),
    )
  }

  fun buildOperatorConnectOptions(): GatewayConnectOptions {
    return GatewayConnectOptions(
      role = "operator",
      scopes = listOf("operator.read", "operator.write", "operator.talk.secrets"),
      caps = emptyList(),
      commands = emptyList(),
      permissions = emptyMap(),
      client = buildClientInfo(clientId = "legalogy-control-ui", clientMode = "ui"),
      userAgent = buildUserAgent(),
    )
  }

  fun resolveTlsParams(endpoint: GatewayEndpoint): GatewayTlsParams? {
    val stored = prefs.loadGatewayTlsFingerprint(endpoint.stableId)
    return resolveTlsParamsForEndpoint(endpoint, storedFingerprint = stored, manualTlsEnabled = manualTls())
  }
}
