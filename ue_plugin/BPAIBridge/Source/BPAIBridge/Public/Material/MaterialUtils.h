#pragma once

#include "CoreMinimal.h"

/**
 * Material Utility Library
 * ========================
 *
 * Reads Material asset structure.
 */
class FMaterialUtils
{
public:
	/** List all Material assets in the project. */
	static FString ListAllMaterials();

	/** Read Material graph nodes and connections. */
	static FString ReadMaterialGraph(const FString& AssetPath);
};
