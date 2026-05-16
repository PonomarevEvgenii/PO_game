using Godot;

public partial class ShopController : Control
{
    private ShopSystem _shop;
    private EconomySystem _economy;
    private VBoxContainer _rows;
    private Label _goldLabel;

    public override void _Ready()
    {
        SetAnchorsPreset(LayoutPreset.FullRect);
        MouseFilter = MouseFilterEnum.Ignore;

        var panel = new PanelContainer
        {
            AnchorLeft = 1.0f,
            AnchorRight = 1.0f,
            AnchorTop = 0.0f,
            AnchorBottom = 1.0f,
            OffsetLeft = -330.0f,
            OffsetRight = -12.0f,
            OffsetTop = 70.0f,
            OffsetBottom = -24.0f,
            MouseFilter = MouseFilterEnum.Stop
        };
        AddChild(panel);

        var margin = new MarginContainer();
        margin.AddThemeConstantOverride("margin_left", 14);
        margin.AddThemeConstantOverride("margin_right", 14);
        margin.AddThemeConstantOverride("margin_top", 14);
        margin.AddThemeConstantOverride("margin_bottom", 14);
        panel.AddChild(margin);

        var root = new VBoxContainer();
        root.AddThemeConstantOverride("separation", 12);
        margin.AddChild(root);

        var header = new HBoxContainer();
        root.AddChild(header);

        var title = new Label
        {
            Text = "Shop",
            SizeFlagsHorizontal = SizeFlags.ExpandFill
        };
        title.AddThemeFontSizeOverride("font_size", 22);
        header.AddChild(title);

        var closeButton = new Button
        {
            Text = "X",
            CustomMinimumSize = new Vector2(34.0f, 30.0f)
        };
        closeButton.Pressed += Toggle;
        header.AddChild(closeButton);

        _goldLabel = new Label { Text = "Gold: 0" };
        root.AddChild(_goldLabel);

        _rows = new VBoxContainer();
        _rows.AddThemeConstantOverride("separation", 8);
        root.AddChild(_rows);

        Refresh();
    }

    public void Bind(ShopSystem shop, EconomySystem economy)
    {
        _shop = shop;
        _economy = economy;

        if (_economy != null)
        {
            _economy.GoldChanged += OnGoldChanged;
            OnGoldChanged(_economy.Gold);
        }

        if (_shop != null)
        {
            _shop.UnitUpgraded += (_, _) => Refresh();
        }

        Refresh();
    }

    public void Toggle()
    {
        Visible = !Visible;
        if (Visible)
        {
            Refresh();
        }
    }

    private void Refresh()
    {
        if (_rows == null)
        {
            return;
        }

        foreach (var child in _rows.GetChildren())
        {
            _rows.RemoveChild(child);
            child.QueueFree();
        }

        foreach (var pair in GameCatalog.CreateUnitDefinitions())
        {
            var definition = pair.Value;
            if (!definition.IsLaneUnit)
            {
                continue;
            }

            var unitId = definition.Id;
            var level = _shop != null ? _shop.GetUpgradeLevel(unitId) : 0;
            var cost = _shop != null ? _shop.GetNextUpgradeCost(definition) : definition.UpgradeCost;

            var button = new Button
            {
                Text = $"{definition.DisplayName}  Lv {level}  {cost}g",
                CustomMinimumSize = new Vector2(0.0f, 42.0f),
                SizeFlagsHorizontal = SizeFlags.ExpandFill,
                Disabled = _economy == null || _economy.Gold < cost
            };
            button.Pressed += () =>
            {
                _shop?.BuyUnitUpgrade(unitId);
                Refresh();
            };
            _rows.AddChild(button);
        }
    }

    private void OnGoldChanged(int gold)
    {
        if (_goldLabel != null)
        {
            _goldLabel.Text = $"Gold: {gold}";
        }

        Refresh();
    }
}
