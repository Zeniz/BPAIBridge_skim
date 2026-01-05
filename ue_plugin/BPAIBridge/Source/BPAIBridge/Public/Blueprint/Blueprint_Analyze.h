#pragma once

#include "CoreMinimal.h"

/**
 * Blueprint Analyzer
 * ==================
 *
 * Provides Blueprint overview and statistics.
 */
class FBlueprint_Analyze
{
public:
	/** Get Blueprint overview (parent class, interfaces, statistics). */
	static FString GetOverview(const FString& BlueprintPath);
};
