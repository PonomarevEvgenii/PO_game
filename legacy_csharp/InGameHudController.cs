using Godot;

public partial class InGameHudController : Control
{
    [Signal] public delegate void ShopRequestedEventHandler();

    private Label _goldLabel;
    private Label _experienceLabel;
    private Label _healthLabel;
    private Label _heroLabel;

    private EconomySystem _economy;
    private ExperienceSystem _experience;
    private HeroController _hero;

    public override void _Ready()
    {
        SetAnchorsPreset(LayoutPreset.FullRect);
        MouseFilter = MouseFilterEnum.Ignore;

        var bar = new PanelContainer
        {
            AnchorRight = 1.0f,
            OffsetLeft = 12.0f,
            OffsetTop = 12.0f,
            OffsetRight = -12.0f,
            CustomMinimumSize = new Vector2(0.0f, 46.0f),
            MouseFilter = MouseFilterEnum.Stop
        };
        AddChild(bar);

        var row = new HBoxContainer
        {
            SizeFlagsHorizontal = SizeFlags.ExpandFill
        };
        row.AddThemeConstantOverride("separation", 18);
        bar.AddChild(row);

        _heroLabel = CreateHudLabel("Hero");
        _healthLabel = CreateHudLabel("HP");
        _goldLabel = CreateHudLabel("Gold");
        _experienceLabel = CreateHudLabel("Level");

        row.AddChild(_heroLabel);
        row.AddChild(_healthLabel);
        row.AddChild(_goldLabel);
        row.AddChild(_experienceLabel);

        var spacer = new Control { SizeFlagsHorizontal = SizeFlags.ExpandFill };
        row.AddChild(spacer);

        var shopButton = new Button
        {
            Text = "Shop",
            CustomMinimumSize = new Vector2(96.0f, 34.0f)
        };
        shopButton.Pressed += () => EmitSignal(SignalName.ShopRequested);
        row.AddChild(shopButton);
    }

    public void Bind(EconomySystem economy, ExperienceSystem experience, HeroController hero)
    {
        _economy = economy;
        _experience = experience;
        _hero = hero;

        if (_economy != null)
        {
            _economy.GoldChanged += OnGoldChanged;
            OnGoldChanged(_economy.Gold);
        }

        if (_experience != null)
        {
            _experience.ExperienceChanged += OnExperienceChanged;
            OnExperienceChanged(_experience.Level, _experience.Experience, _experience.RequiredExperience);
        }

        if (_hero != null)
        {
            _hero.HealthChanged += OnHeroHealthChanged;
            _heroLabel.Text = $"Hero: {_hero.HeroId}";
            OnHeroHealthChanged(_hero.Health, _hero.Stats.MaxHealth);
        }
    }

    private Label CreateHudLabel(string text)
    {
        var label = new Label
        {
            Text = text,
            CustomMinimumSize = new Vector2(130.0f, 32.0f),
            VerticalAlignment = VerticalAlignment.Center
        };
        label.AddThemeFontSizeOverride("font_size", 16);
        return label;
    }

    private void OnGoldChanged(int gold)
    {
        if (_goldLabel != null)
        {
            _goldLabel.Text = $"Gold: {gold}";
        }
    }

    private void OnExperienceChanged(int level, int experience, int requiredExperience)
    {
        if (_experienceLabel != null)
        {
            _experienceLabel.Text = $"Lv {level}: {experience}/{requiredExperience}";
        }
    }

    private void OnHeroHealthChanged(float current, float maximum)
    {
        if (_healthLabel != null)
        {
            _healthLabel.Text = $"HP: {Mathf.RoundToInt(current)}/{Mathf.RoundToInt(maximum)}";
        }
    }
}
