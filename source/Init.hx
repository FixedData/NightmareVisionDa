package;

import funkin.scripting.ScriptManager;
import funkin.api.PolyClient;
import flixel.FlxState;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

/**
 * Initiation state that prepares backend classes and returns to menus when finished
 * 
 * There is no need to open this beyond the first time
 */
class Init extends FlxState
{
	/**
	 * Contains keys that mute the game volume
	 * 
	 * default is `0`
	 */
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	
	/**
	 * Contains keys that turn down the game volume
	 * 
	 * default is `-`
	 */
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	
	/**
	 * Contains keys that turn up the game volume
	 * 
	 * default is `+`
	 */
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
		
		#if VIDEOS_ALLOWED
		funkin.video.FunkinVideoSprite.init();
		#end
		
		PolyClient.init();
		
		ScriptManager.build();
		
		if (FlxG.save.data != null && FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;
		if (FlxG.save.data.weekCompleted != null) funkin.states.StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		
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
