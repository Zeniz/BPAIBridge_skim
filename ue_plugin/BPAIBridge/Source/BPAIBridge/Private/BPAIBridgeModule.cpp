
#include "BPAIBridgeModule.h"

#define LOCTEXT_NAMESPACE "FBPAIBridgeModule"

void FBPAIBridgeModule::StartupModule()
{
	// This code will execute after your module is loaded into memory
	UE_LOG(LogTemp, Log, TEXT("BPAIBridge module started"));
}

void FBPAIBridgeModule::ShutdownModule()
{
	// This function may be called during shutdown to clean up your module
	UE_LOG(LogTemp, Log, TEXT("BPAIBridge module shutdown"));
}

#undef LOCTEXT_NAMESPACE

IMPLEMENT_MODULE(FBPAIBridgeModule, BPAIBridge)
