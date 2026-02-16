import type { LegalogyConfig } from "../config/config.js";

export function applyOnboardingLocalWorkspaceConfig(
  baseConfig: LegalogyConfig,
  workspaceDir: string,
): LegalogyConfig {
  return {
    ...baseConfig,
    agents: {
      ...baseConfig.agents,
      defaults: {
        ...baseConfig.agents?.defaults,
        workspace: workspaceDir,
      },
    },
    gateway: {
      ...baseConfig.gateway,
      mode: "local",
    },
  };
}
