/**
 * AnimBlueprint Utility Implementation
 */

#include "AnimBlueprint/AnimBlueprintUtils.h"
#include "Animation/AnimBlueprint.h"
#include "Dom/JsonObject.h"
#include "Serialization/JsonWriter.h"
#include "Serialization/JsonSerializer.h"

UAnimBlueprint* FAnimBlueprintUtils::LoadAnimBlueprint(const FString& AssetPath)
{
	return LoadObject<UAnimBlueprint>(nullptr, *AssetPath);
}

FString FAnimBlueprintUtils::GetAnimBlueprintAsJSON(const FString& AssetPath)
{
	UAnimBlueprint* AnimBP = LoadAnimBlueprint(AssetPath);
	if (!AnimBP)
		return MakeErrorResult(TEXT("Failed to load AnimBlueprint"));

	// Build JSON structure:
	// - Basic Info (name, path, parentClass, targetSkeleton)
	// - Variables array
	// - Functions array
	// - State Machines with States and Transitions
	// - Linked Anim Layers
	// - All Graphs with nodes
	// ...
	return TEXT("{\"animBlueprint\": {}}");
}

FString FAnimBlueprintUtils::MakeErrorResult(const FString& ErrorMessage)
{
	TSharedPtr<FJsonObject> ResultObj = MakeShared<FJsonObject>();
	ResultObj->SetBoolField(TEXT("success"), false);
	ResultObj->SetStringField(TEXT("error"), ErrorMessage);

	FString OutputString;
	TSharedRef<TJsonWriter<>> Writer = TJsonWriterFactory<>::Create(&OutputString);
	FJsonSerializer::Serialize(ResultObj.ToSharedRef(), Writer);
	return OutputString;
}

FString FAnimBlueprintUtils::MakeSuccessResult(const FString& Message, TSharedPtr<FJsonObject> AdditionalData)
{
	TSharedPtr<FJsonObject> ResultObj = MakeShared<FJsonObject>();
	ResultObj->SetBoolField(TEXT("success"), true);
	ResultObj->SetStringField(TEXT("message"), Message);
	// ... merge additional data if provided

	FString OutputString;
	TSharedRef<TJsonWriter<>> Writer = TJsonWriterFactory<>::Create(&OutputString);
	FJsonSerializer::Serialize(ResultObj.ToSharedRef(), Writer);
	return OutputString;
}
