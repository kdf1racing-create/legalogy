import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-legalogy writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.legalogy.mac"
let gatewayLaunchdLabel = "ai.legalogy.gateway"
let onboardingVersionKey = "legalogy.onboardingVersion"
let onboardingSeenKey = "legalogy.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "legalogy.pauseEnabled"
let iconAnimationsEnabledKey = "legalogy.iconAnimationsEnabled"
let swabbleEnabledKey = "legalogy.swabbleEnabled"
let swabbleTriggersKey = "legalogy.swabbleTriggers"
let voiceWakeTriggerChimeKey = "legalogy.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "legalogy.voiceWakeSendChime"
let showDockIconKey = "legalogy.showDockIcon"
let defaultVoiceWakeTriggers = ["legalogy"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "legalogy.voiceWakeMicID"
let voiceWakeMicNameKey = "legalogy.voiceWakeMicName"
let voiceWakeLocaleKey = "legalogy.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "legalogy.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "legalogy.voicePushToTalkEnabled"
let talkEnabledKey = "legalogy.talkEnabled"
let iconOverrideKey = "legalogy.iconOverride"
let connectionModeKey = "legalogy.connectionMode"
let remoteTargetKey = "legalogy.remoteTarget"
let remoteIdentityKey = "legalogy.remoteIdentity"
let remoteProjectRootKey = "legalogy.remoteProjectRoot"
let remoteCliPathKey = "legalogy.remoteCliPath"
let canvasEnabledKey = "legalogy.canvasEnabled"
let cameraEnabledKey = "legalogy.cameraEnabled"
let systemRunPolicyKey = "legalogy.systemRunPolicy"
let systemRunAllowlistKey = "legalogy.systemRunAllowlist"
let systemRunEnabledKey = "legalogy.systemRunEnabled"
let locationModeKey = "legalogy.locationMode"
let locationPreciseKey = "legalogy.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "legalogy.peekabooBridgeEnabled"
let deepLinkKeyKey = "legalogy.deepLinkKey"
let modelCatalogPathKey = "legalogy.modelCatalogPath"
let modelCatalogReloadKey = "legalogy.modelCatalogReload"
let cliInstallPromptedVersionKey = "legalogy.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "legalogy.heartbeatsEnabled"
let debugPaneEnabledKey = "legalogy.debugPaneEnabled"
let debugFileLogEnabledKey = "legalogy.debug.fileLogEnabled"
let appLogLevelKey = "legalogy.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26
