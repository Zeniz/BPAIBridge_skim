#pragma once

#include "CoreMinimal.h"
#include "BPAIBridgeMCPAdapter.generated.h"

/**
 * MCP Adapter - Central entry point for AI-to-Unreal communication.
 * =================================================================
 *
 * This class exposes Unreal Engine data to MCP (Model Context Protocol) clients.
 * AI tools (Claude Code, Cursor, etc.) call these functions via Python Remote Execution.
 *
 * Architecture:
 *   AI Tool (Claude) -> MCP Server (Python) -> Python Remote Exec -> This Adapter -> UE Internals
 *
 * Each function returns JSON for easy parsing by MCP clients.
 */
UCLASS()
class BPAIBRIDGE_API UBPAIBridgeMCPAdapter : public UObject
{
	GENERATED_BODY()

public:
	// ============================================================================
	// Asset Discovery
	// ============================================================================

	/** List all Blueprint assets in the project. Returns JSON array. */
	UFUNCTION(BlueprintCallable, Category = "BPAIBridge|MCP|Asset")
	static FString MCP_ListAllBlueprints();

	/** List all Material assets in the project. Returns JSON array. */
	UFUNCTION(BlueprintCallable, Category = "BPAIBridge|MCP|Asset")
	static FString MCP_ListAllMaterials();

	// ============================================================================
	// Blueprint - Read
	// ============================================================================

	/** Get Blueprint graph as human-readable text format. */
	UFUNCTION(BlueprintCallable, Category = "BPAIBridge|MCP|Blueprint")
	static FString MCP_BP_GraphGetAsText(const FString& AssetPath);

	/** List all variables in a Blueprint. */
	UFUNCTION(BlueprintCallable, Category = "BPAIBridge|MCP|Blueprint")
	static FString MCP_BP_VariableList(const FString& BlueprintPath);

	/** List all functions in a Blueprint. */
	UFUNCTION(BlueprintCallable, Category = "BPAIBridge|MCP|Blueprint")
	static FString MCP_BP_FunctionList(const FString& BlueprintPath);

	/** Get Blueprint overview (parent class, statistics, interfaces). */
	UFUNCTION(BlueprintCallable, Category = "BPAIBridge|MCP|Blueprint")
	static FString MCP_BP_AnalyzeGetOverview(const FString& BlueprintPath);

	// ============================================================================
	// AnimBlueprint - Read
	// ============================================================================

	/** Get AnimBlueprint structure as JSON (State Machines, Transitions). */
	UFUNCTION(BlueprintCallable, Category = "BPAIBridge|MCP|AnimBlueprint")
	static FString MCP_AnimBP_Read(const FString& AssetPath);

	// ... Additional MCP functions can be added here
	//     (Events, Macros, Components, Interfaces, Convert to C++, etc.)
};
