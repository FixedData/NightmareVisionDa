package;

import funkin.scripting.ScriptManager;
import funkin.api.PolyClient;
import flixel.FlxState;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Init extends FlxState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	
	override public function create():Void
	{
		funkin.data.scripts.FunkinIris.InitLogger();
		
		Paths.pushGlobalMods();
		
		FlxG.fixedTimestep = false;
		
		funkin.data.WeekData.loadTheFirstEnabledMod();
		
		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];
		
		FlxG.mouse.visible = false;
		
		funkin.backend.PlayerSettings.init();
		
		FlxG.save.bind('funkin', CoolUtil.getSavePath());
		
		ClientPrefs.loadPrefs();
		
		funkin.data.Highscore.load();
		
		funkin.video.FunkinVideoSprite.init();
		
		PolyClient.init();
		
		ScriptManager.build();
		
		if (FlxG.save.data != null && FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;
		if (FlxG.save.data.weekCompleted != null) funkin.states.StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		
		FlxG.mouse.visible = false;
		
		// MusicBeatState.transitionInState = funkin.states.transitions.FadeTransition;
		// MusicBeatState.transitionOutState = funkin.states.transitions.FadeTransition;
		
		#if DISCORD_ALLOWED
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			lime.app.Application.Application.current.onExit.add((ec) -> DiscordClient.shutdown());
		}
		#end
		
		super.create();
		
		FlxG.switchState(new funkin.states.TitleState());
	}
}
