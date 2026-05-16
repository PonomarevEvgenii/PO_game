using Godot;
using System;

public partial class NeutralCampSpawner : Node
{
    public event Action<Actor> UnitSpawned = delegate { };

    private Node2D _actorParent;
    private PackedScene _neutralUnitScene;

    public void Configure(Node2D actorParent, PackedScene neutralUnitScene)
    {
        _actorParent = actorParent;
        _neutralUnitScene = neutralUnitScene;
    }

    public void SpawnInitialCamps()
    {
        if (_actorParent == null || _neutralUnitScene == null)
        {
            return;
        }

        SpawnNeutral("neutral_bruiser", new Vector2(-210.0f, -90.0f));
        SpawnNeutral("neutral_spitter", new Vector2(-130.0f, 105.0f));
        SpawnNeutral("neutral_thrower", new Vector2(145.0f, -115.0f));
        SpawnNeutral("neutral_claw", new Vector2(230.0f, 120.0f));
    }

    private void SpawnNeutral(string unitId, Vector2 position)
    {
        var definitions = GameCatalog.CreateUnitDefinitions();
        if (!definitions.TryGetValue(unitId, out var definition))
        {
            return;
        }

        var unit = _neutralUnitScene.Instantiate<NeutralUnit>();
        _actorParent.AddChild(unit);
        unit.ConfigureNeutral(unitId, position, definition.Stats.CloneStats());
        UnitSpawned(unit);
    }
}
