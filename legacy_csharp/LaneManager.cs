using Godot;

public partial class LaneManager : Node2D
{
    [Export] public float PlayerBaseX { get; set; } = -540.0f;
    [Export] public float EnemyBaseX { get; set; } = 540.0f;
    [Export] public float TopLaneY { get; set; } = -180.0f;
    [Export] public float MiddleLaneY { get; set; } = 0.0f;
    [Export] public float BottomLaneY { get; set; } = 180.0f;
    [Export] public float SpawnOffsetFromBase { get; set; } = 80.0f;

    public override void _Ready()
    {
        QueueRedraw();
    }

    public Vector2 GetBasePosition(TeamId team)
    {
        return team == TeamId.Player ? new Vector2(PlayerBaseX, MiddleLaneY) : new Vector2(EnemyBaseX, MiddleLaneY);
    }

    public Vector2 GetHeroSpawn(TeamId team)
    {
        var basePosition = GetBasePosition(team);
        var direction = team == TeamId.Player ? 1.0f : -1.0f;
        return basePosition + new Vector2(direction * 120.0f, 0.0f);
    }

    public Vector2 GetSpawnPosition(TeamId team, LaneId lane)
    {
        var x = team == TeamId.Player ? PlayerBaseX + SpawnOffsetFromBase : EnemyBaseX - SpawnOffsetFromBase;
        return new Vector2(x, GetLaneY(lane));
    }

    public Vector2 GetLaneTarget(TeamId team, LaneId lane)
    {
        var x = team == TeamId.Player ? EnemyBaseX : PlayerBaseX;
        return new Vector2(x, GetLaneY(lane));
    }

    public float GetLaneY(LaneId lane)
    {
        return lane switch
        {
            LaneId.Top => TopLaneY,
            LaneId.Bottom => BottomLaneY,
            _ => MiddleLaneY
        };
    }

    public override void _Draw()
    {
        DrawLane(LaneId.Top);
        DrawLane(LaneId.Middle);
        DrawLane(LaneId.Bottom);
    }

    private void DrawLane(LaneId lane)
    {
        var y = GetLaneY(lane);
        var start = new Vector2(PlayerBaseX, y);
        var end = new Vector2(EnemyBaseX, y);
        DrawLine(start, end, new Color(0.42f, 0.46f, 0.38f, 0.55f), 5.0f);
        DrawLine(start + Vector2.Down * 18.0f, end + Vector2.Down * 18.0f, new Color(0.20f, 0.24f, 0.20f, 0.35f), 1.0f);
        DrawLine(start + Vector2.Up * 18.0f, end + Vector2.Up * 18.0f, new Color(0.20f, 0.24f, 0.20f, 0.35f), 1.0f);
    }
}
