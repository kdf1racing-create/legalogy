import type {
  AnyAgentTool,
  LegalogyPluginApi,
  LegalogyPluginToolFactory,
} from "../../src/plugins/types.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default function register(api: LegalogyPluginApi) {
  api.registerTool(
    ((ctx) => {
      if (ctx.sandboxed) {
        return null;
      }
      return createLobsterTool(api) as AnyAgentTool;
    }) as LegalogyPluginToolFactory,
    { optional: true },
  );
}
