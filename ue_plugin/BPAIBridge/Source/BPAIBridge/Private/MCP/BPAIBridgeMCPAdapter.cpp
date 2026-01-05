/**
 * MCP Adapter Implementation
 * ==========================
 *
 * This file routes MCP calls to internal utility classes.
 * Each function delegates to specialized modules:
 *   - FBlueprintUtils: Blueprint discovery and loading
 *   - FBlueprint_Graph: Graph node reading
 *   - FBlueprint_Variable: Variable reading
 *   - FBlueprint_Function: Function reading
 *   - FAnimBlueprintUtils: AnimBlueprint reading
 *   - etc.
 */

#include "MCP/BPAIBridgeMCPAdapter.h"
#include "Blueprint/BlueprintUtils.h"
#include "Blueprint/Blueprint_Graph.h"
#include "Blueprint/Blueprint_Variable.h"
#include "Blueprint/Blueprint_Function.h"
#include "Blueprint/Blueprint_Analyze.h"
#include "AnimBlueprint/AnimBlueprintUtils.h"
#include "Material/MaterialUtils.h"

// ============================================================================
// Asset Discovery
// ============================================================================

FString UBPAIBridgeMCPAdapter::MCP_ListAllBlueprints()
{
	// Routes to BlueprintUtils which queries AssetRegistry
	return FBlueprintUtils::ListAllBlueprints();
}

FString UBPAIBridgeMCPAdapter::MCP_ListAllMaterials()
{
	// Routes to MaterialUtils which queries AssetRegistry
	return FMaterialUtils::ListAllMaterials();
}

// ============================================================================
// Blueprint - Read
// ============================================================================

FString UBPAIBridgeMCPAdapter::MCP_BP_GraphGetAsText(const FString& AssetPath)
{
	// Converts Blueprint graph to human-readable text
	// - Loads Blueprint from AssetPath
	// - Iterates through EventGraph and Function graphs
	// - Outputs node connections in text format
	return FBlueprint_Graph::GetBlueprintGraphAsText(AssetPath);
}

FString UBPAIBridgeMCPAdapter::MCP_BP_VariableList(const FString& BlueprintPath)
{
	// Lists all variables defined in the Blueprint
	// - Member variables, local variables
	// - Types, default values, property flags
	return FBlueprint_Variable::GetVariables(BlueprintPath);
}

FString UBPAIBridgeMCPAdapter::MCP_BP_FunctionList(const FString& BlueprintPath)
{
	// Lists all functions defined in the Blueprint
	// - User-defined functions
	// - Overridden parent functions
	// - Input/Output parameters
	return FBlueprint_Function::GetFunctions(BlueprintPath);
}

FString UBPAIBridgeMCPAdapter::MCP_BP_AnalyzeGetOverview(const FString& BlueprintPath)
{
	// Returns Blueprint overview information
	// - Parent class hierarchy
	// - Implemented interfaces
	// - Statistics (node count, variable count, etc.)
	return FBlueprint_Analyze::GetOverview(BlueprintPath);
}

// ============================================================================
// AnimBlueprint - Read
// ============================================================================

FString UBPAIBridgeMCPAdapter::MCP_AnimBP_Read(const FString& AssetPath)
{
	// Returns AnimBlueprint structure as JSON
	// - AnimGraph layers
	// - State Machines
	// - States and Transitions
	// - Blend nodes
	return FAnimBlueprintUtils::GetAnimBlueprintAsJSON(AssetPath);
}
