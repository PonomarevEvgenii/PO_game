using Godot;
using System.Collections.Generic;

public partial class ShopSystem : Node
{
    [Signal] public delegate void UnitUpgradedEventHandler(string unitId, int level);

    private readonly Dictionary<string, int> _upgradeLevels = new Dictionary<string, int>();
    private EconomySystem _economy;

    public void Bind(EconomySystem economy)
    {
        _economy = economy;
    }

    public int GetUpgradeLevel(string unitId)
    {
        return _upgradeLevels.TryGetValue(unitId, out var level) ? level : 0;
    }

    public int GetNextUpgradeCost(UnitDefinition definition)
    {
        var nextLevel = GetUpgradeLevel(definition.Id) + 1;
        return definition.UpgradeCost * nextLevel;
    }

    public bool BuyUnitUpgrade(string unitId)
    {
        var definitions = GameCatalog.CreateUnitDefinitions();
        if (!definitions.TryGetValue(unitId, out var definition) || !definition.IsLaneUnit)
        {
            return false;
        }

        var cost = GetNextUpgradeCost(definition);
        if (_economy == null || !_economy.TrySpend(cost))
        {
            return false;
        }

        var level = GetUpgradeLevel(unitId) + 1;
        _upgradeLevels[unitId] = level;
        EmitSignal(SignalName.UnitUpgraded, unitId, level);
        return true;
    }
}
