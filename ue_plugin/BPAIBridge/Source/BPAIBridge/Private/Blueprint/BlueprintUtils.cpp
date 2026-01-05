/**
 * Blueprint Utility Implementation
 * =================================
 *
 * Core utilities for loading, discovering, and querying Blueprint assets.
 */

#include "Blueprint/BlueprintUtils.h"
#include "Engine/Blueprint.h"
#include "EdGraph/EdGraphNode.h"
#include "EdGraphSchema_K2.h"
#include "K2Node_Event.h"
#include "K2Node_CallFunction.h"
#include "K2Node_VariableGet.h"
#include "K2Node_VariableSet.h"
#include "AssetRegistry/AssetRegistryModule.h"
#include "Dom/JsonObject.h"
#include "Serialization/JsonWriter.h"
#include "Serialization/JsonSerializer.h"

// ============================================================================
// Loading & Discovery
// ============================================================================

UBlueprint* FBlueprintUtils::LoadBlueprintFromPath(const FString& AssetPath)
{
	// Use StaticLoadObject to load Blueprint from path
	// Handles both "/Game/..." paths and "_C" suffixed paths
	UObject* LoadedObject = StaticLoadObject(UBlueprint::StaticClass(), nullptr, *AssetPath);
	// ... additional path normalization
	return Cast<UBlueprint>(LoadedObject);
}

FString FBlueprintUtils::ListAllBlueprints()
{
	// Query AssetRegistry for all Blueprint assets
	IAssetRegistry& AssetRegistry = FModuleManager::LoadModuleChecked<FAssetRegistryModule>("AssetRegistry").Get();

	FARFilter Filter;
	Filter.ClassPaths.Add(UBlueprint::StaticClass()->GetClassPathName());
	Filter.bRecursiveClasses = true;
	Filter.bRecursivePaths = true;

	TArray<FAssetData> AssetDataList;
	AssetRegistry.GetAssets(Filter, AssetDataList);

	// Convert to JSON array
	TArray<TSharedPtr<FJsonValue>> JsonArray;
	for (const FAssetData& AssetData : AssetDataList)
	{
		TSharedPtr<FJsonObject> JsonObj = MakeShared<FJsonObject>();
		JsonObj->SetStringField(TEXT("name"), AssetData.AssetName.ToString());
		JsonObj->SetStringField(TEXT("path"), AssetData.GetSoftObjectPath().ToString());
		JsonArray.Add(MakeShared<FJsonValueObject>(JsonObj));
	}

	// Serialize to string
	FString OutputString;
	TSharedRef<TJsonWriter<>> Writer = TJsonWriterFactory<>::Create(&OutputString);
	FJsonSerializer::Serialize(JsonArray, Writer);

	return OutputString;
}

// ============================================================================
// Type Conversion
// ============================================================================

FEdGraphPinType FBlueprintUtils::StringToPinType(const FString& TypeString)
{
	FEdGraphPinType PinType;
	FString LowerType = TypeString.ToLower();

	// Map common type names to UE pin categories
	if (LowerType == TEXT("bool"))
		PinType.PinCategory = UEdGraphSchema_K2::PC_Boolean;
	else if (LowerType == TEXT("int"))
		PinType.PinCategory = UEdGraphSchema_K2::PC_Int;
	else if (LowerType == TEXT("float"))
		PinType.PinCategory = UEdGraphSchema_K2::PC_Float;
	else if (LowerType == TEXT("string"))
		PinType.PinCategory = UEdGraphSchema_K2::PC_String;
	else if (LowerType == TEXT("vector"))
	{
		PinType.PinCategory = UEdGraphSchema_K2::PC_Struct;
		PinType.PinSubCategoryObject = TBaseStructure<FVector>::Get();
	}
	// ... additional type mappings for Rotator, Transform, Object types, etc.

	return PinType;
}

UClass* FBlueprintUtils::FindClassByName(const FString& ClassName)
{
	// Try direct lookup
	UClass* FoundClass = FindFirstObject<UClass>(*ClassName, EFindFirstObjectOptions::None);
	if (FoundClass) return FoundClass;

	// Try with common prefixes (A, U, F)
	// ... prefix search logic

	// Try loading as Blueprint class
	// ... Blueprint path loading

	return nullptr;
}

// ============================================================================
// Display Helpers
// ============================================================================

FString FBlueprintUtils::GetNodeDisplayName(const UEdGraphNode* Node)
{
	if (!Node) return TEXT("(null)");

	// Handle specific node types
	if (const UK2Node_Event* EventNode = Cast<UK2Node_Event>(Node))
		return FString::Printf(TEXT("Event %s"), *EventNode->GetNodeTitle(ENodeTitleType::MenuTitle).ToString());

	if (const UK2Node_CallFunction* CallFunc = Cast<UK2Node_CallFunction>(Node))
	{
		FName FuncName = CallFunc->FunctionReference.GetMemberName();
		return FString::Printf(TEXT("Call %s"), *FuncName.ToString());
	}

	if (const UK2Node_VariableGet* VarGet = Cast<UK2Node_VariableGet>(Node))
		return FString::Printf(TEXT("Get %s"), *VarGet->GetVarName().ToString());

	if (const UK2Node_VariableSet* VarSet = Cast<UK2Node_VariableSet>(Node))
		return FString::Printf(TEXT("Set %s"), *VarSet->GetVarName().ToString());

	// ... additional node type handlers

	return Node->GetNodeTitle(ENodeTitleType::MenuTitle).ToString();
}

// ============================================================================
// JSON Helpers
// ============================================================================

FString FBlueprintUtils::MakeSuccessResult(const FString& Message)
{
	TSharedPtr<FJsonObject> Result = MakeShared<FJsonObject>();
	Result->SetBoolField(TEXT("success"), true);
	if (!Message.IsEmpty())
		Result->SetStringField(TEXT("message"), Message);

	FString OutputString;
	TSharedRef<TJsonWriter<>> Writer = TJsonWriterFactory<>::Create(&OutputString);
	FJsonSerializer::Serialize(Result.ToSharedRef(), Writer);
	return OutputString;
}

FString FBlueprintUtils::MakeErrorResult(const FString& Error)
{
	TSharedPtr<FJsonObject> Result = MakeShared<FJsonObject>();
	Result->SetBoolField(TEXT("success"), false);
	Result->SetStringField(TEXT("error"), Error);

	FString OutputString;
	TSharedRef<TJsonWriter<>> Writer = TJsonWriterFactory<>::Create(&OutputString);
	FJsonSerializer::Serialize(Result.ToSharedRef(), Writer);
	return OutputString;
}
