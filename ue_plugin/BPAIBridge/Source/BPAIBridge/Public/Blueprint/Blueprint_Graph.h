#pragma once

#include "CoreMinimal.h"

/**
 * Blueprint Graph Reader
 * ======================
 *
 * Reads Blueprint EventGraph and Function graphs.
 * Converts node connections to text/JSON for AI analysis.
 */
class FBlueprint_Graph
{
public:
	/** Get Blueprint graphs as human-readable text format. */
	static FString GetBlueprintGraphAsText(const FString& AssetPath);

	/** Get Blueprint graphs as JSON format. */
	static FString GetBlueprintGraphAsJSON(const FString& AssetPath);
};
