package funkin;

import openfl.media.Sound;
import openfl.utils.AssetType;
import openfl.Assets;
import lime.utils.Assets as LimeAssets;
import funkin.backend.Cache;
import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	public static final VIDEO_EXT:String = 'mp4';
	public static final SOUND_EXT:String = 'ogg';
	
	// images ==================
	
	inline public static function image(key:String, ?library:String)
	{
		return Cache.cacheGraphic(getPath('images/$key.png', IMAGE, library));
		// return getPath('images/$key.png', IMAGE, library);
	}
	
	inline public static function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), getPath('images/$key.xml', TEXT, library));
	}
	
	inline public static function getPackerAtlas(key:String, ?library:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), getPath('images/$key.txt', TEXT, library));
	}
	
	inline public static function getAseprite(key:String, ?library:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromAseprite(image(key, library), getPath('images/$key.json', TEXT, library));
	}
	
	inline public static function textureAtlas(key:String, ?library:String)
	{
		return getPath(key, BINARY, library);
	}
	
	public static function getMultiSparrow(keys:Array<String>, ?library:String)
	{
		final primaryFrames:FlxAtlasFrames = getSparrowAtlas(keys.shift().trim());
		if (keys.length != 0) {}
		// return FlxAtlasFrames.fromSparrow(image(key,library), getPath('images/$key.xml', TEXT, library));
	}
	
	// sounds ==================
	
	inline public static function sound(key:String, ?library:String):Sound
	{
		return Cache.cacheSound(getPath('sounds/$key.$SOUND_EXT', SOUND, library));
	}
	
	inline public static function music(key:String, ?library:String):Sound
	{
		return Cache.cacheSound(getPath('music/$key.$SOUND_EXT', MUSIC, library));
	}
	
	inline public static function inst(song:String):Sound
	{
		return Cache.cacheSound('songs:assets/songs/${formatToSongPath(song)}/Inst.$SOUND_EXT');
	}
	
	inline public static function voices(song:String, ?postFix:String):Sound
	{
		final voicePath = ('Voices' + (postFix != null ? '-$postFix' : ''));
		return Cache.cacheSound('songs:assets/songs/${formatToSongPath(song)}/$voicePath.$SOUND_EXT', false);
	}
	
	// data ==================
	
	inline public static function txt(key:String, ?library:String):String
	{
		return getPath('data/$key.txt', TEXT, library);
	}
	
	inline public static function xml(key:String, ?library:String):String
	{
		return getPath('data/$key.xml', TEXT, library);
	}
	
	inline public static function json(key:String, ?library:String):String
	{
		return getPath('data/$key.json', TEXT, library);
	}
	
	// misc ==================
	
	inline public static function font(key:String):String
	{
		return 'assets/fonts/$key';
	}
	
	inline public static function video(key:String):String
	{
		return 'assets/videos/$key.$VIDEO_EXT';
	}
	
	inline public static function frag(key:String, ?library:String):String
	{
		return getPath('shaders/$key.frag', TEXT, library);
	}
	
	inline public static function vert(key:String, ?library:String):String
	{
		return getPath('shaders/$key.vert', TEXT, library);
	}
	
	// backend ==================
	static public var currentLevel:String;
	
	static public function setCurrentLevel(newLevel:String):Void
	{
		currentLevel = newLevel.toLowerCase();
	}
	
	public static function getPath(file:String, ?type:AssetType = TEXT, ?library:String):String
	{
		if (library != null) return getLibraryPath(file, library);
		
		if (currentLevel != null)
		{
			var levelPath:String = '';
			if (currentLevel != 'shared')
			{
				levelPath = getLibraryPathForce(file, currentLevel);
				if (Assets.exists(levelPath, type)) return levelPath;
			}
			
			levelPath = getLibraryPathForce(file, "shared");
			if (Assets.exists(levelPath, type)) return levelPath;
		}
		
		return getSharedPath(file);
	}
	
	inline static public function getLibraryPath(file:String, library:String = "shared"):String
	{
		return if (library == "shared") getSharedPath(file); else getLibraryPathForce(file, library);
	}
	
	inline static function getLibraryPathForce(file:String, library:String):String
	{
		return '$library:assets/$library/$file';
	}
	
	inline public static function getSharedPath(file:String = ''):String
	{
		return 'assets/shared/$file';
	}
	
	inline public static function getContent(key:String):Null<String>
	{
		if (exists(key, TEXT)) return Assets.getText(key);
		return return null;
	}
	
	/**
	 * Checks if a given path exists
	 * 
	 * A redirect to `Assets.exists` 
	 * @param type the File type to look for. Default is `TEXT`
	 * @return If it exists
	 */
	inline public static function exists(path:String, ?type:AssetType):Bool
	{
		return Assets.exists(path, type);
	}
	
	inline static public function formatToSongPath(path:String)
	{
		return path.toLowerCase().replace(' ', '-');
	}
	
	// ======================================================================================= OLD SHIT NEEDS THAT NEEDS GO OR UPDATED===========
	#if MODS_ALLOWED
	public static var ignoreModFolders:Array<String> = [
		'characters',
		'custom_events',
		'custom_notetypes',
		'data',
		'songs',
		'music',
		'sounds',
		'shaders',
		'noteskins',
		'videos',
		'images',
		'stages',
		'weeks',
		'fonts',
		'scripts',
		'achievements'
	];
	#end
	
	static public var currentModDirectory:String = '';
	
	inline public static function strip(path:String) return path.indexOf(':') != -1 ? path.substr(path.indexOf(':') + 1, path.length) : path;
	
	inline static public function noteskin(key:String, ?library:String)
	{
		return getPath('noteskins/$key.json', TEXT, library);
	}
	
	inline static public function modsNoteskin(key:String)
	{
		return modFolders('noteskins/$key.json');
	}
	
	static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
	{
		#if sys
		#if MODS_ALLOWED
		if (!ignoreMods && FileSystem.exists(modFolders(key))) return File.getContent(modFolders(key));
		#end
		
		if (FileSystem.exists(getSharedPath(key))) return File.getContent(getSharedPath(key));
		
		if (currentLevel != null)
		{
			var levelPath:String = '';
			if (currentLevel != 'shared')
			{
				levelPath = getLibraryPathForce(key, currentLevel);
				if (FileSystem.exists(levelPath)) return File.getContent(levelPath);
			}
			
			levelPath = getLibraryPathForce(key, 'shared');
			if (FileSystem.exists(levelPath)) return File.getContent(levelPath);
		}
		#end
		return Assets.getText(getPath(key, TEXT));
	}
	
	
	#if MODS_ALLOWED
	inline static public function mods(key:String = '')
	{
		return 'content/' + key;
	}
	
	inline static public function modsJson(key:String)
	{
		return modFolders('songs/' + key + '.json');
	}
	
	inline static public function modsImages(key:String)
	{
		return modFolders('images/' + key + '.png');
	}
	
	inline static public function modsTxt(key:String)
	{
		return modFolders('images/' + key + '.txt');
	}
	
	static public function modFolders(key:String, global:Bool = true)
	{
		if (currentModDirectory != null && currentModDirectory.length > 0)
		{
			var fileToCheck:String = mods(currentModDirectory + '/' + key);
			if (FileSystem.exists(fileToCheck))
			{
				return fileToCheck;
			}
		}
		
		var lol = getModDirectories();
		if (global) lol = getGlobalMods();
		
		for (mod in lol)
		{
			var fileToCheck:String = mods(mod + '/' + key);
			if (FileSystem.exists(fileToCheck)) return fileToCheck;
		}
		return 'content/' + key;
	}
	
	public static var globalMods:Array<String> = [];
	
	static public function getGlobalMods() return globalMods;
	
	static public function pushGlobalMods()
	{ // prob a better way to do this but idc
		globalMods = [];
		if (FileSystem.exists("modsList.txt"))
		{
			var list:Array<String> = CoolUtil.listFromString(File.getContent("modsList.txt"));
			for (i in list)
			{
				var dat = i.split("|");
				if (dat[1] == "1")
				{
					var folder = dat[0];
					var path = Paths.mods(folder + '/pack.json');
					if (FileSystem.exists(path))
					{
						try
						{
							var rawJson:String = File.getContent(path);
							if (rawJson != null && rawJson.length > 0)
							{
								var stuff:Dynamic = haxe.Json.parse(rawJson);
								var global:Bool = Reflect.getProperty(stuff, "runsGlobally");
								if (global) globalMods.push(dat[0]);
							}
						}
					}
				}
			}
		}
		return globalMods;
	}
	
	static public function getModDirectories():Array<String>
	{
		var list:Array<String> = [];
		var modsFolder:String = mods();
		if (FileSystem.exists(modsFolder))
		{
			for (folder in FileSystem.readDirectory(modsFolder))
			{
				var path = haxe.io.Path.join([modsFolder, folder]);
				if (sys.FileSystem.isDirectory(path) && !ignoreModFolders.contains(folder) && !list.contains(folder))
				{
					list.push(folder);
				}
			}
		}
		return list;
	}
	#end
}
