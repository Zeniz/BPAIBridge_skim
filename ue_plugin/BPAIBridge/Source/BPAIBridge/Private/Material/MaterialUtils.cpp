/**
 * Material Utility Implementation
 */

#include "Material/MaterialUtils.h"
#include "Materials/Material.h"
#include "AssetRegistry/AssetRegistryModule.h"
#include "Dom/JsonObject.h"
#include "Serialization/JsonWriter.h"
#include "Serialization/JsonSerializer.h"

FString FMaterialUtils::ListAllMaterials()
{
	// Query AssetRegistry for Material assets
	// Similar to FBlueprintUtils::ListAllBlueprints
	// ...
	return TEXT("[]");
}

FString FMaterialUtils::ReadMaterialGraph(const FString& AssetPath)
{
	// Load Material or MaterialInstance
	// For Material:
	//   - domain, blend_mode, two_sided
	//   - expressions (material nodes)
	// For MaterialInstance:
	//   - parent_material
	//   - scalar_parameters, vector_parameters, texture_parameters
	// ...
	return TEXT("{\"material\": {}}");
}
