using Godot;

public partial class HeroSelectController : Control
{
    [Signal] public delegate void HeroChosenEventHandler(string heroId);
    [Signal] public delegate void BackRequestedEventHandler();

    public override void _Ready()
    {
        SetAnchorsPreset(LayoutPreset.FullRect);

        var background = new ColorRect
        {
            Color = new Color(0.09f, 0.10f, 0.12f),
            AnchorRight = 1.0f,
            AnchorBottom = 1.0f
        };
        AddChild(background);

        var margin = new MarginContainer
        {
            AnchorRight = 1.0f,
            AnchorBottom = 1.0f
        };
        margin.AddThemeConstantOverride("margin_left", 42);
        margin.AddThemeConstantOverride("margin_right", 42);
        margin.AddThemeConstantOverride("margin_top", 36);
        margin.AddThemeConstantOverride("margin_bottom", 36);
        AddChild(margin);

        var root = new VBoxContainer
        {
            SizeFlagsHorizontal = SizeFlags.ExpandFill,
            SizeFlagsVertical = SizeFlags.ExpandFill
        };
        root.AddThemeConstantOverride("separation", 16);
        margin.AddChild(root);

        var title = new Label
        {
            Text = "Choose Hero",
            HorizontalAlignment = HorizontalAlignment.Center
        };
        title.AddThemeFontSizeOverride("font_size", 34);
        root.AddChild(title);

        var grid = new GridContainer
        {
            Columns = 2,
            SizeFlagsHorizontal = SizeFlags.ExpandFill,
            SizeFlagsVertical = SizeFlags.ExpandFill
        };
        grid.AddThemeConstantOverride("h_separation", 16);
        grid.AddThemeConstantOverride("v_separation", 16);
        root.AddChild(grid);

        foreach (var pair in GameCatalog.CreateHeroDefinitions())
        {
            var hero = pair.Value;
            var button = new Button
            {
                Text = $"{hero.DisplayName}\n{hero.Description}",
                CustomMinimumSize = new Vector2(360.0f, 96.0f),
                SizeFlagsHorizontal = SizeFlags.ExpandFill
            };

            var heroId = hero.Id;
            button.Pressed += () => EmitSignal(SignalName.HeroChosen, heroId);
            grid.AddChild(button);
        }

        var backButton = new Button
        {
            Text = "Back",
            CustomMinimumSize = new Vector2(160.0f, 42.0f)
        };
        backButton.Pressed += () => EmitSignal(SignalName.BackRequested);
        root.AddChild(backButton);
    }
}
