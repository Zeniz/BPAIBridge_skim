#pragma once

#include "CoreMinimal.h"

/**
 * AnimBlueprint Utility Library
 * =============================
 *
 * Reads Animation Blueprint structure:
 * - State Machines
 * - States and Transitions
 * - AnimGraph nodes (Slot, Blend, Sequence, etc.)
 */
class FAnimBlueprintUtils
{
public:
	/** Load AnimBlueprint from path */
	static UAnimBlueprint* LoadAnimBlueprint(const FString& AssetPath);

	/** Get AnimBlueprint structure as JSON. */
	static FString GetAnimBlueprintAsJSON(const FString& AssetPath);

	/** Create JSON error result */
	static FString MakeErrorResult(const FString& ErrorMessage);

	/** Create JSON success result */
	static FString MakeSuccessResult(const FString& Message, TSharedPtr<FJsonObject> AdditionalData = nullptr);
};
