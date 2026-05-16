using Godot;

public partial class MainMenuController : Control
{
    [Signal] public delegate void StartPressedEventHandler();
    [Signal] public delegate void QuitPressedEventHandler();

    public override void _Ready()
    {
        SetAnchorsPreset(LayoutPreset.FullRect);

        var background = new ColorRect
        {
            Color = new Color(0.08f, 0.11f, 0.10f),
            AnchorRight = 1.0f,
            AnchorBottom = 1.0f
        };
        AddChild(background);

        var margin = new MarginContainer
        {
            AnchorRight = 1.0f,
            AnchorBottom = 1.0f
        };
        margin.AddThemeConstantOverride("margin_left", 64);
        margin.AddThemeConstantOverride("margin_right", 64);
        margin.AddThemeConstantOverride("margin_top", 64);
        margin.AddThemeConstantOverride("margin_bottom", 64);
        AddChild(margin);

        var layout = new VBoxContainer
        {
            Alignment = BoxContainer.AlignmentMode.Center,
            SizeFlagsHorizontal = SizeFlags.ExpandFill,
            SizeFlagsVertical = SizeFlags.ExpandFill
        };
        layout.AddThemeConstantOverride("separation", 18);
        margin.AddChild(layout);

        var title = new Label
        {
            Text = "Last Stand: Three Fronts",
            HorizontalAlignment = HorizontalAlignment.Center
        };
        title.AddThemeFontSizeOverride("font_size", 42);
        layout.AddChild(title);

        var subtitle = new Label
        {
            Text = "RTS / RPG / Auto-battler prototype",
            HorizontalAlignment = HorizontalAlignment.Center
        };
        subtitle.AddThemeFontSizeOverride("font_size", 18);
        layout.AddChild(subtitle);

        var startButton = new Button
        {
            Text = "Start",
            CustomMinimumSize = new Vector2(220.0f, 48.0f)
        };
        startButton.Pressed += () => EmitSignal(SignalName.StartPressed);
        layout.AddChild(startButton);

        var quitButton = new Button
        {
            Text = "Quit",
            CustomMinimumSize = new Vector2(220.0f, 44.0f)
        };
        quitButton.Pressed += () => EmitSignal(SignalName.QuitPressed);
        layout.AddChild(quitButton);
    }
}
