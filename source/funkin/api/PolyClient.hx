package funkin.api;

import funkin.backend.Cache;
import funkin.scripting.ScriptClasses.ScriptFlxTextAlign;
import funkin.scripting.ScriptClasses.ScriptBlendMode;
import funkin.scripting.ScriptClasses.ScriptFlxColor;
import funkin.scripting.ScriptClasses.ScriptFlxAxes;
import funkin.scripting.ScriptManager;
import polymod.Polymod;

/**
 * Handles interactions with Polymod
 */
class PolyClient
{
	/**
	 * The set mod directory for polymod to search through
	 */
	public static final MOD_DIR:String = 'mods';
	
	public static var loadedModMetas:Array<ModMetadata> = [];
	
	public static var activeMods:Array<String> = [];
	
	/**
	 * List of the ids of all loaded mods
	 */
	public static final modDirectories:Array<String> = [];
	
	/**
	 * Prepares and starts polymod functionality
	 */
	public static function init()
	{
		setImports();
		
		refreshDirectories();
		
		initialize();
	}
	
	/**
	 * Resets the loaded state and re initializes Polymod //TODO add a fix related to doing this inside scriptedStates
	 */
	public static function refresh()
	{
		ScriptManager.clear();
		
		Polymod.clearScripts();
		refreshDirectories();
		// Polymod.clearCache();
		
		Polymod.reload();
		ScriptManager.build();
		
		Cache.resetSafeKeys();
		
		FlxG.resetState();
	}
	
	/**
	 * Checks and creates (if need be) a mod directory
	 */
	static function ensureModDirExists()
	{
		if (!FileSystem.exists(MOD_DIR))
		{
			FileSystem.createDirectory(MOD_DIR);
		}
	}
	
	static function refreshDirectories()
	{
		ensureModDirExists();
		
		modDirectories.splice(0, modDirectories.length);
		
		loadedModMetas = Polymod.scan({modRoot: MOD_DIR});
		
		for (i in loadedModMetas)
		{
			modDirectories.push(i.id);
		}

		//not gonna stay but did this fo fun
		FlxG.stage.window.setIcon(lime.graphics.Image.fromBytes(loadedModMetas[0].icon));
		
	}
	
	static function initialize()
	{
		Polymod.init(
			{
				dirs: modDirectories,
				modRoot: MOD_DIR,
				framework: OPENFL,
				frameworkParams: getFrameworkParams(),
				errorCallback: onError,
				useScriptedClasses: true
			});
	}
	
	/**
	 * Handles the action to take in case an error with Polymod had occured
	 * @param error Polymod Error holding information about the error
	 */
	static function onError(error:PolymodError)
	{
		switch (error.code)
		{
			case SCRIPT_CLASS_MODULE_NOT_FOUND:
				doPopUp('Script Import Failed.', error.message);
				
			case SCRIPT_CLASS_MODULE_ALREADY_IMPORTED: // this isnt much of a real warning stop.
			
			case SCRIPT_CLASS_ALREADY_REGISTERED: // u have 2 scripts with the same class name
				doPopUp('Two Registered Script Classes Contain The Same Name.', error.message);
				
			case SCRIPT_PARSE_ERROR:
				doPopUp('Script Parsing Failed.', error.message);
				
			case SCRIPT_RUNTIME_EXCEPTION:
				doPopUp('Script Exception Caught.', error.message);
				
			default:
				switch (error.severity)
				{
					case NOTICE:
					
					case WARNING:
						trace('WARNING: [${error.message}]');
					case ERROR:
						trace('ERROR: [${error.message}]');
				}
		}
	}
	
	/**
	 * Opens a windows alert
	 */
	public static function doPopUp(title:String, description:String)
	{
		FlxG.stage.window.alert(description, title);
		trace(description);
	}
	
	/**
	 * Sets Polymod Scripted Classes default imports
	 */
	static function setImports()
	{
		// flixel
		Polymod.addDefaultImport(flixel.FlxSprite);
		Polymod.addDefaultImport(flixel.FlxG);
		Polymod.addDefaultImport(flixel.group.FlxGroup);
		Polymod.addDefaultImport(flixel.group.FlxContainer);
		Polymod.addDefaultImport(flixel.group.FlxSpriteGroup);
		Polymod.addDefaultImport(flixel.group.FlxSpriteContainer);
		Polymod.addDefaultImport(flixel.sound.FlxSound);
		Polymod.addDefaultImport(flixel.math.FlxMath);
		Polymod.addDefaultImport(flixel.tweens.FlxEase);
		Polymod.addDefaultImport(flixel.tweens.FlxTween);
		Polymod.addDefaultImport(flixel.math.FlxPoint.FlxBasePoint, 'FlxPoint');
		Polymod.addDefaultImport(flixel.util.FlxTimer);
		
		// funkin specfic
		Polymod.addDefaultImport(funkin.Paths);
		Polymod.addDefaultImport(funkin.objects.BGSprite);
		Polymod.addDefaultImport(funkin.data.ClientPrefs);
		Polymod.addDefaultImport(funkin.states.PlayState);
		
		// alternatives to some abstracted shit
		Polymod.addDefaultImport(ScriptFlxAxes, 'FlxAxes');
		Polymod.addDefaultImport(ScriptFlxColor, 'FlxColor');
		Polymod.addDefaultImport(ScriptBlendMode, 'BlendMode');
		Polymod.addDefaultImport(ScriptFlxTextAlign, 'FlxTextAlign');


		// poly classes
		final scriptedClasses = CompileTime.getAllClasses('funkin.scripting.classes');
		for (i in scriptedClasses)
		{
			Polymod.addDefaultImport(i);
		}
	}
	
	static function getFrameworkParams():Null<FrameworkParams>
	{
		return {
			assetLibraryPaths: [
				"data" => "data",
				"images" => "images",
				"music" => "music",
				"songs" => "songs",
				"sounds" => "sounds",
				"videos" => "videos",
				"shared" => 'shared'
			]
		}
	}
}
