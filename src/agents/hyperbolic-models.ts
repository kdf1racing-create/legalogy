import type { ModelDefinition } from "../config/types.models.js";

export const HYPERBOLIC_BASE_URL = "https://api.hyperbolic.xyz/v1";
export const HYPERBOLIC_DEFAULT_MODEL_ID = "meta-llama/Meta-Llama-3.1-70B-Instruct";
export const HYPERBOLIC_DEFAULT_MODEL_REF = `hyperbolic/${HYPERBOLIC_DEFAULT_MODEL_ID}`;

export const HYPERBOLIC_MODEL_CATALOG: Array<{ id: string; name: string }> = [
  { id: "meta-llama/Meta-Llama-3.1-70B-Instruct", name: "Llama 3.1 70B" },
  { id: "meta-llama/Meta-Llama-3.1-405B-Instruct-FP8", name: "Llama 3.1 405B" },
  { id: "meta-llama/Meta-Llama-3-70B-Instruct", name: "Llama 3 70B" },
  { id: "Qwen/Qwen2.5-72B-Instruct", name: "Qwen 2.5 72B" },
  { id: "deepseek-ai/DeepSeek-V3", name: "DeepSeek V3" },
];

export function buildHyperbolicModelDefinition(params: {
  id: string;
  name?: string;
}): ModelDefinition {
  const { id, name } = params;
  return {
    id,
    name: name ?? id,
    contextWindow: 128000,
    maxTokens: 4096,
    input: ["text"],
    cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 }, // TODO: Update costs
    reasoning: false,
  };
}
