using Godot;

[GlobalClass]
public partial class UnitDefinition : Resource
{
    [Export] public string Id { get; set; } = "";
    [Export] public string DisplayName { get; set; } = "";
    [Export] public bool IsLaneUnit { get; set; } = true;
    [Export] public bool IsSiegeUnit { get; set; }
    [Export] public ActorStats Stats { get; set; } = new ActorStats();
    [Export] public int Cost { get; set; } = 30;
    [Export] public int UpgradeCost { get; set; } = 75;
}
