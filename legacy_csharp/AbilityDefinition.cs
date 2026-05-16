using Godot;

[GlobalClass]
public partial class AbilityDefinition : Resource
{
    [Export] public string Id { get; set; } = "";
    [Export] public string DisplayName { get; set; } = "";
    [Export(PropertyHint.MultilineText)] public string Description { get; set; } = "";
    [Export] public AbilityTargeting Targeting { get; set; } = AbilityTargeting.Point;
    [Export] public float Cooldown { get; set; } = 4.0f;
    [Export] public float Range { get; set; } = 220.0f;
    [Export] public float Radius { get; set; } = 64.0f;
    [Export] public float Power { get; set; } = 20.0f;
}
