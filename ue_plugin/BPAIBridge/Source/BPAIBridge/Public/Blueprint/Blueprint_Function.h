#pragma once

#include "CoreMinimal.h"

/**
 * Blueprint Function Reader
 * =========================
 *
 * Reads Blueprint user-defined functions.
 */
class FBlueprint_Function
{
public:
	/** List all functions in a Blueprint. Returns JSON. */
	static FString GetFunctions(const FString& BlueprintPath);

	/** Get function signature and metadata. */
	static FString GetFunctionInfo(const FString& BlueprintPath, const FString& FunctionName);

	/** Get function graph nodes. */
	static FString GetFunctionGraph(const FString& BlueprintPath, const FString& FunctionName);
};
