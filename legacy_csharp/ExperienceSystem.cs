using Godot;

public partial class ExperienceSystem : Node
{
    [Signal] public delegate void ExperienceChangedEventHandler(int level, int experience, int requiredExperience);

    [Export] public int BaseRequiredExperience { get; set; } = 40;

    public int Level { get; private set; } = 1;
    public int Experience { get; private set; }
    public int RequiredExperience => BaseRequiredExperience + (Level - 1) * 30;

    public override void _Ready()
    {
        ResetProgress();
    }

    public void ResetProgress()
    {
        Level = 1;
        Experience = 0;
        EmitSignal(SignalName.ExperienceChanged, Level, Experience, RequiredExperience);
    }

    public void AddExperience(int amount)
    {
        if (amount <= 0)
        {
            return;
        }

        Experience += amount;

        while (Experience >= RequiredExperience)
        {
            Experience -= RequiredExperience;
            Level++;
        }

        EmitSignal(SignalName.ExperienceChanged, Level, Experience, RequiredExperience);
    }
}
