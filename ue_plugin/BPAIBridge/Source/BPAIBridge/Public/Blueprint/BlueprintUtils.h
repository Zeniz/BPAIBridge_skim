#pragma once

#include "CoreMinimal.h"
#include "EdGraph/EdGraphPin.h"

/**
 * Blueprint Utility Library
 * =========================
 *
 * Provides core utilities for Blueprint operations:
 * - Asset loading and discovery
 * - Type conversion for Blueprint pin types
 * - JSON result helpers for MCP responses
 */
class FBlueprintUtils
{
public:
	// ========================================================================
	// Loading & Discovery
	// ========================================================================

	/** Load Blueprint from asset path (e.g., "/Game/Blueprints/BP_Player") */
	static UBlueprint* LoadBlueprintFromPath(const FString& AssetPath);

	/** List all Blueprint assets in the project. Returns JSON array. */
	static FString ListAllBlueprints();

	// ========================================================================
	// Type Conversion
	// ========================================================================

	/** Convert type string (e.g., "Vector", "float") to FEdGraphPinType */
	static FEdGraphPinType StringToPinType(const FString& TypeString);

	/** Find class by name (supports A/U/F prefixes and Blueprint paths) */
	static UClass* FindClassByName(const FString& ClassName);

	// ========================================================================
	// Display Helpers
	// ========================================================================

	/** Get human-readable name for a Blueprint node */
	static FString GetNodeDisplayName(const UEdGraphNode* Node);

	// ========================================================================
	// JSON Helpers
	// ========================================================================

	/** Create JSON success result: {"success": true, "message": "..."} */
	static FString MakeSuccessResult(const FString& Message = TEXT(""));

	/** Create JSON error result: {"success": false, "error": "..."} */
	static FString MakeErrorResult(const FString& Error);
};
