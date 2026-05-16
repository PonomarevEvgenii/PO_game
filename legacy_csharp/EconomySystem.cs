using Godot;

public partial class EconomySystem : Node
{
    [Signal] public delegate void GoldChangedEventHandler(int gold);

    [Export] public int StartingGold { get; set; } = 160;

    public int Gold { get; private set; }

    public override void _Ready()
    {
        ResetEconomy();
    }

    public void ResetEconomy()
    {
        Gold = StartingGold;
        EmitSignal(SignalName.GoldChanged, Gold);
    }

    public void AddGold(int amount)
    {
        if (amount <= 0)
        {
            return;
        }

        Gold += amount;
        EmitSignal(SignalName.GoldChanged, Gold);
    }

    public bool TrySpend(int amount)
    {
        if (amount <= 0)
        {
            return true;
        }

        if (Gold < amount)
        {
            return false;
        }

        Gold -= amount;
        EmitSignal(SignalName.GoldChanged, Gold);
        return true;
    }
}
