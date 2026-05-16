using Godot;

public partial class AudioDirector : Node
{
    [Export] public AudioStream MainMenuMusic { get; set; }
    [Export] public AudioStream BattleMusic { get; set; }
    [Export] public AudioStream VictoryMusic { get; set; }
    [Export] public AudioStream DefeatMusic { get; set; }

    private AudioStreamPlayer _player;

    public override void _Ready()
    {
        _player = new AudioStreamPlayer { Name = "MusicPlayer" };
        AddChild(_player);
    }

    public void PlayMenu()
    {
        Play(MainMenuMusic);
    }

    public void PlayBattle()
    {
        Play(BattleMusic);
    }

    public void PlayResult(bool victory)
    {
        Play(victory ? VictoryMusic : DefeatMusic);
    }

    private void Play(AudioStream stream)
    {
        if (_player == null || stream == null)
        {
            return;
        }

        _player.Stream = stream;
        _player.Play();
    }
}
