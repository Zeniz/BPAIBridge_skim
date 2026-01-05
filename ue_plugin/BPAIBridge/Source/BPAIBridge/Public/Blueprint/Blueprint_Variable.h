#pragma once

#include "CoreMinimal.h"

/**
 * Blueprint Variable Reader
 * =========================
 *
 * Reads Blueprint member variables.
 */
class FBlueprint_Variable
{
public:
	/** List all variables in a Blueprint. Returns JSON. */
	static FString GetVariables(const FString& BlueprintPath);

	/** Get detailed info about a specific variable. */
	static FString GetVariableInfo(const FString& BlueprintPath, const FString& VariableName);
};
