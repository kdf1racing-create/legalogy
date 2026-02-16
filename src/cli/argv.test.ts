import { describe, expect, it } from "vitest";
import {
  buildParseArgv,
  getFlagValue,
  getCommandPath,
  getPrimaryCommand,
  getPositiveIntFlagValue,
  getVerboseFlag,
  hasHelpOrVersion,
  hasFlag,
  shouldMigrateState,
  shouldMigrateStateFromPath,
} from "./argv.js";

describe("argv helpers", () => {
  it("detects help/version flags", () => {
    expect(hasHelpOrVersion(["node", "legalogy", "--help"])).toBe(true);
    expect(hasHelpOrVersion(["node", "legalogy", "-V"])).toBe(true);
    expect(hasHelpOrVersion(["node", "legalogy", "status"])).toBe(false);
  });

  it("extracts command path ignoring flags and terminator", () => {
    expect(getCommandPath(["node", "legalogy", "status", "--json"], 2)).toEqual(["status"]);
    expect(getCommandPath(["node", "legalogy", "agents", "list"], 2)).toEqual(["agents", "list"]);
    expect(getCommandPath(["node", "legalogy", "status", "--", "ignored"], 2)).toEqual(["status"]);
  });

  it("returns primary command", () => {
    expect(getPrimaryCommand(["node", "legalogy", "agents", "list"])).toBe("agents");
    expect(getPrimaryCommand(["node", "legalogy"])).toBeNull();
  });

  it("parses boolean flags and ignores terminator", () => {
    expect(hasFlag(["node", "legalogy", "status", "--json"], "--json")).toBe(true);
    expect(hasFlag(["node", "legalogy", "--", "--json"], "--json")).toBe(false);
  });

  it("extracts flag values with equals and missing values", () => {
    expect(getFlagValue(["node", "legalogy", "status", "--timeout", "5000"], "--timeout")).toBe(
      "5000",
    );
    expect(getFlagValue(["node", "legalogy", "status", "--timeout=2500"], "--timeout")).toBe(
      "2500",
    );
    expect(getFlagValue(["node", "legalogy", "status", "--timeout"], "--timeout")).toBeNull();
    expect(getFlagValue(["node", "legalogy", "status", "--timeout", "--json"], "--timeout")).toBe(
      null,
    );
    expect(getFlagValue(["node", "legalogy", "--", "--timeout=99"], "--timeout")).toBeUndefined();
  });

  it("parses verbose flags", () => {
    expect(getVerboseFlag(["node", "legalogy", "status", "--verbose"])).toBe(true);
    expect(getVerboseFlag(["node", "legalogy", "status", "--debug"])).toBe(false);
    expect(getVerboseFlag(["node", "legalogy", "status", "--debug"], { includeDebug: true })).toBe(
      true,
    );
  });

  it("parses positive integer flag values", () => {
    expect(getPositiveIntFlagValue(["node", "legalogy", "status"], "--timeout")).toBeUndefined();
    expect(
      getPositiveIntFlagValue(["node", "legalogy", "status", "--timeout"], "--timeout"),
    ).toBeNull();
    expect(
      getPositiveIntFlagValue(["node", "legalogy", "status", "--timeout", "5000"], "--timeout"),
    ).toBe(5000);
    expect(
      getPositiveIntFlagValue(["node", "legalogy", "status", "--timeout", "nope"], "--timeout"),
    ).toBeUndefined();
  });

  it("builds parse argv from raw args", () => {
    const nodeArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["node", "legalogy", "status"],
    });
    expect(nodeArgv).toEqual(["node", "legalogy", "status"]);

    const versionedNodeArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["node-22", "legalogy", "status"],
    });
    expect(versionedNodeArgv).toEqual(["node-22", "legalogy", "status"]);

    const versionedNodeWindowsArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["node-22.2.0.exe", "legalogy", "status"],
    });
    expect(versionedNodeWindowsArgv).toEqual(["node-22.2.0.exe", "legalogy", "status"]);

    const versionedNodePatchlessArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["node-22.2", "legalogy", "status"],
    });
    expect(versionedNodePatchlessArgv).toEqual(["node-22.2", "legalogy", "status"]);

    const versionedNodeWindowsPatchlessArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["node-22.2.exe", "legalogy", "status"],
    });
    expect(versionedNodeWindowsPatchlessArgv).toEqual(["node-22.2.exe", "legalogy", "status"]);

    const versionedNodeWithPathArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["/usr/bin/node-22.2.0", "legalogy", "status"],
    });
    expect(versionedNodeWithPathArgv).toEqual(["/usr/bin/node-22.2.0", "legalogy", "status"]);

    const nodejsArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["nodejs", "legalogy", "status"],
    });
    expect(nodejsArgv).toEqual(["nodejs", "legalogy", "status"]);

    const nonVersionedNodeArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["node-dev", "legalogy", "status"],
    });
    expect(nonVersionedNodeArgv).toEqual(["node", "legalogy", "node-dev", "legalogy", "status"]);

    const directArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["legalogy", "status"],
    });
    expect(directArgv).toEqual(["node", "legalogy", "status"]);

    const bunArgv = buildParseArgv({
      programName: "legalogy",
      rawArgs: ["bun", "src/entry.ts", "status"],
    });
    expect(bunArgv).toEqual(["bun", "src/entry.ts", "status"]);
  });

  it("builds parse argv from fallback args", () => {
    const fallbackArgv = buildParseArgv({
      programName: "legalogy",
      fallbackArgv: ["status"],
    });
    expect(fallbackArgv).toEqual(["node", "legalogy", "status"]);
  });

  it("decides when to migrate state", () => {
    expect(shouldMigrateState(["node", "legalogy", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "legalogy", "health"])).toBe(false);
    expect(shouldMigrateState(["node", "legalogy", "sessions"])).toBe(false);
    expect(shouldMigrateState(["node", "legalogy", "config", "get", "update"])).toBe(false);
    expect(shouldMigrateState(["node", "legalogy", "config", "unset", "update"])).toBe(false);
    expect(shouldMigrateState(["node", "legalogy", "models", "list"])).toBe(false);
    expect(shouldMigrateState(["node", "legalogy", "models", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "legalogy", "memory", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "legalogy", "agent", "--message", "hi"])).toBe(false);
    expect(shouldMigrateState(["node", "legalogy", "agents", "list"])).toBe(true);
    expect(shouldMigrateState(["node", "legalogy", "message", "send"])).toBe(true);
  });

  it("reuses command path for migrate state decisions", () => {
    expect(shouldMigrateStateFromPath(["status"])).toBe(false);
    expect(shouldMigrateStateFromPath(["config", "get"])).toBe(false);
    expect(shouldMigrateStateFromPath(["models", "status"])).toBe(false);
    expect(shouldMigrateStateFromPath(["agents", "list"])).toBe(true);
  });
});
