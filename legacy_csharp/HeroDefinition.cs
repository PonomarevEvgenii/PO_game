using Godot;

[GlobalClass]
public partial class HeroDefinition : Resource
{
    [Export] public string Id { get; set; } = "";
    [Export] public string DisplayName { get; set; } = "";
    [Export(PropertyHint.MultilineText)] public string Description { get; set; } = "";
    [Export] public ActorStats Stats { get; set; } = new ActorStats();
    [Export] public Godot.Collections.Array<AbilityDefinition> Abilities { get; set; } = new Godot.Collections.Array<AbilityDefinition>();
}
