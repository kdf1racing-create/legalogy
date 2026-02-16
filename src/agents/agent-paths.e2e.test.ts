import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { afterEach, describe, expect, it } from "vitest";
import { captureEnv } from "../test-utils/env.js";
import { resolveLegalogyAgentDir } from "./agent-paths.js";

describe("resolveLegalogyAgentDir", () => {
  const env = captureEnv(["LEGALOGY_STATE_DIR", "LEGALOGY_AGENT_DIR", "PI_CODING_AGENT_DIR"]);
  let tempStateDir: string | null = null;

  afterEach(async () => {
    if (tempStateDir) {
      await fs.rm(tempStateDir, { recursive: true, force: true });
      tempStateDir = null;
    }
    env.restore();
  });

  it("defaults to the multi-agent path when no overrides are set", async () => {
    tempStateDir = await fs.mkdtemp(path.join(os.tmpdir(), "legalogy-agent-"));
    process.env.LEGALOGY_STATE_DIR = tempStateDir;
    delete process.env.LEGALOGY_AGENT_DIR;
    delete process.env.PI_CODING_AGENT_DIR;

    const resolved = resolveLegalogyAgentDir();

    expect(resolved).toBe(path.join(tempStateDir, "agents", "main", "agent"));
  });

  it("honors LEGALOGY_AGENT_DIR overrides", async () => {
    tempStateDir = await fs.mkdtemp(path.join(os.tmpdir(), "legalogy-agent-"));
    const override = path.join(tempStateDir, "agent");
    process.env.LEGALOGY_AGENT_DIR = override;
    delete process.env.PI_CODING_AGENT_DIR;

    const resolved = resolveLegalogyAgentDir();

    expect(resolved).toBe(path.resolve(override));
  });
});
