import type { PluginRuntime } from "legalogy/plugin-sdk";
import os from "node:os";
import path from "node:path";

export const msteamsRuntimeStub = {
  state: {
    resolveStateDir: (env: NodeJS.ProcessEnv = process.env, homedir?: () => string) => {
      const override = env.LEGALOGY_STATE_DIR?.trim() || env.LEGALOGY_STATE_DIR?.trim();
      if (override) {
        return override;
      }
      const resolvedHome = homedir ? homedir() : os.homedir();
      return path.join(resolvedHome, ".legalogy");
    },
  },
} as unknown as PluginRuntime;
