package funkin.api;

import funkin.scripting.ScriptManager;
import polymod.Polymod;

class PolyClient
{
	/**
	 * The set mod directory for polymod to search through
	 */
	public static final MOD_DIR:String = 'test';
	
	/**
	 * List of the ids of all loaded mods
	 */
	public static var modDirectories:Array<String> = [];
	
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
	 * Resets the loaded state and re initializes Polymod
	 */
	public static function refresh()
	{
		ScriptManager.clear();
		
		Polymod.clearScripts();
		refreshDirectories();
		
		Polymod.reload();
		ScriptManager.build();
		
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
	
		for (i in Polymod.scan({modRoot: MOD_DIR}))
		{
			modDirectories.push(i.id);
		}
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
	
	static function onError(error:PolymodError)
	{
		switch (error.severity)
		{
			case NOTICE:
			
			case WARNING:
				trace(error.message);
			case ERROR:
				trace(error.message);
		}
	}
	
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
		
		Polymod.addDefaultImport(funkin.states.PlayState);
		
		Polymod.addDefaultImport(PathsReal, 'Paths');
		Polymod.addDefaultImport(FlxAxes);
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

// test?
class FlxAxes
{
	public static var X:Int = cast flixel.util.FlxAxes.X;
	public static var Y:Int = cast flixel.util.FlxAxes.Y;
	public static var XY:Int = cast flixel.util.FlxAxes.XY;
}
