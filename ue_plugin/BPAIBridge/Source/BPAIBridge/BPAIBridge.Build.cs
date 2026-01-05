using UnrealBuildTool;

public class BPAIBridge : ModuleRules
{
	public BPAIBridge(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

		PublicDependencyModuleNames.AddRange(new string[]
		{
			"Core",
			"CoreUObject",
			"Engine",
		});

		PrivateDependencyModuleNames.AddRange(new string[]
		{
			"UnrealEd",
			"BlueprintGraph",
			"Kismet",
			"KismetCompiler",
			"GraphEditor",
			"AssetRegistry",
			"Json",
			"JsonUtilities",
			"AssetTools",
			"Slate",
			"SlateCore",
			"EnhancedInput",
			// AnimBlueprint support
			"AnimGraph",
			"AnimGraphRuntime",
		});
	}
}
