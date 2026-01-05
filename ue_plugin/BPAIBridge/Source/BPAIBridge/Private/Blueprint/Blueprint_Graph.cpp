/**
 * Blueprint Graph Reader Implementation
 * =====================================
 */

#include "Blueprint/Blueprint_Graph.h"
#include "Blueprint/BlueprintUtils.h"
#include "Engine/Blueprint.h"
#include "EdGraph/EdGraph.h"
#include "EdGraph/EdGraphNode.h"

FString FBlueprint_Graph::GetBlueprintGraphAsText(const FString& AssetPath)
{
	UBlueprint* Blueprint = FBlueprintUtils::LoadBlueprintFromPath(AssetPath);
	if (!Blueprint)
		return TEXT("Error: Could not load Blueprint");

	FString Result;
	Result += FString::Printf(TEXT("Blueprint: %s\n"), *Blueprint->GetName());

	// Get all graphs (EventGraph, Functions, etc.)
	TArray<UEdGraph*> AllGraphs;
	Blueprint->GetAllGraphs(AllGraphs);

	for (UEdGraph* Graph : AllGraphs)
	{
		if (!Graph) continue;

		// Skip internal graphs
		FString GraphName = Graph->GetName();
		if (GraphName.StartsWith(TEXT("TRASH_"))) continue;

		Result += FString::Printf(TEXT("\n=== %s ===\n"), *GraphName);

		// List nodes with their connections
		for (UEdGraphNode* Node : Graph->Nodes)
		{
			if (!Node) continue;
			Result += FString::Printf(TEXT("  [%s]\n"), *FBlueprintUtils::GetNodeDisplayName(Node));

			// ... output pin connections
			// ... output default values
		}
	}

	return Result;
}

FString FBlueprint_Graph::GetBlueprintGraphAsJSON(const FString& AssetPath)
{
	// Similar to GetBlueprintGraphAsText but outputs JSON
	// - "name", "path", "parentClass"
	// - "graphs" array with nodes and connections
	// ...
	return TEXT("{\"graphs\": []}");
}
