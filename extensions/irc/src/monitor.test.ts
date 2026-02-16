import { describe, expect, it } from "vitest";
import { resolveIrcInboundTarget } from "./monitor.js";

describe("irc monitor inbound target", () => {
  it("keeps channel target for group messages", () => {
    expect(
      resolveIrcInboundTarget({
        target: "#legalogy",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: true,
      target: "#legalogy",
      rawTarget: "#legalogy",
    });
  });

  it("maps DM target to sender nick and preserves raw target", () => {
    expect(
      resolveIrcInboundTarget({
        target: "legalogy-bot",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: false,
      target: "alice",
      rawTarget: "legalogy-bot",
    });
  });

  it("falls back to raw target when sender nick is empty", () => {
    expect(
      resolveIrcInboundTarget({
        target: "legalogy-bot",
        senderNick: " ",
      }),
    ).toEqual({
      isGroup: false,
      target: "legalogy-bot",
      rawTarget: "legalogy-bot",
    });
  });
});
