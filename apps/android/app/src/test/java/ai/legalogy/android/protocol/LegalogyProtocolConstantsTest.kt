package ai.legalogy.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class LegalogyProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", LegalogyCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", LegalogyCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", LegalogyCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", LegalogyCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", LegalogyCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", LegalogyCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", LegalogyCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", LegalogyCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", LegalogyCapability.Canvas.rawValue)
    assertEquals("camera", LegalogyCapability.Camera.rawValue)
    assertEquals("screen", LegalogyCapability.Screen.rawValue)
    assertEquals("voiceWake", LegalogyCapability.VoiceWake.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", LegalogyScreenCommand.Record.rawValue)
  }
}
