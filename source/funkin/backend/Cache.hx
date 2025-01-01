package funkin.backend;

import flixel.system.FlxAssets;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import openfl.media.Sound;
import openfl.Assets;
import openfl.system.System;

/**
 * Utility class that manages loaded graphics and sounds
 * 
 * Handles the `Caching`, `Retrieving`, and `Purging` of Funkin assets
 */
@:access(openfl.display.BitmapData)
class Cache
{
	public static function resetSafeKeys()
	{
		safeKeys.resize(0);
		safeKeys.push('assets/music/freakyMenu.${Paths.SOUND_EXT}');
	}
	
	/**
	 * Adds a key to the safeKeys list to remain through dumping
	 * ```haxe
	 * usage: Cache.addSafeKey(Paths.getPath('images/bad.png',TEXT));
	 * ```
	 */
	public static function addSafeKey(key:String)
	{
		if (!safeKeys.contains(key)) safeKeys.push(key);
	}
	
	/**
	 * Keys that are safe from being dumped during cache clearing process
	 * 
	 * manage this with `Cache.addSafeKey`
	 *
	 */
	public static final safeKeys:Array<String> = [];
	
	/**
	 * List of recently used assets in the cache
	 */
	public static final localAssets:Array<String> = [];
	
	/**
	 * Map of all currently cached Sounds
	 */
	public static final loadedSounds:Map<String, Sound> = [];
	
	/**
	 * Map of all currently loaded Graphics
	 */
	public static final loadedGraphics:Map<String, FlxGraphic> = [];
	
	/**
	 * clears all graphics and sounds that are not actively mentioned in the cache and flags the cache as inactive
	 */
	public static function clearStoredMemory()
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			if (!loadedGraphics.exists(key))
			{
				disposeGraphic(FlxG.bitmap.get(key));
			}
		}
		
		// clear all sounds that are cached
		for (key in loadedSounds.keys())
		{
			if (!localAssets.contains(key) && !safeKeys.contains(key))
			{
				Assets.cache.clear(key);
				loadedSounds.remove(key);
			}
		}
		
		// Flags everything as ready to be purged
		localAssets.resize(0);
		Assets.cache.clear("songs");
	}
	
	/**
	 * Clears the graphics cache of any inactive graphics
	 */
	public static function clearUnusedMemory()
	{
		// clear non local assets in the tracked assets list
		for (key in loadedGraphics.keys())
		{
			// if it is not currently contained within the used local assets
			if (!localAssets.contains(key) && !safeKeys.contains(key))
			{
				disposeGraphic(loadedGraphics.get(key));
				loadedGraphics.remove(key);
			}
		}
		
		System.gc();
		#if cpp cpp.vm.Gc.compact(); #end
	}
	
	/**
	 * Disposes a FlxGraphic and its gpu texture (if it exists)
	 */
	public static function disposeGraphic(graphic:FlxGraphic)
	{
		graphic?.bitmap?.__texture?.dispose();
		FlxG.bitmap.remove(graphic);
	}
	
	/**
	 * Attempts to cache a graphic and returns it.
	 */
	public static function cacheGraphic(key:String):Null<FlxGraphic>
	{
		if (loadedGraphics.exists(key))
		{
			// was cached before return it and refresh its entry in the local list
			localAssets.push(key);
			return loadedGraphics.get(key);
		}
		
		if (!Assets.exists(key, IMAGE)) // couldnt find it
		{
			trace('Graphic "$key" was not found!');
			
			return null;
		}
		
		var bitmap = Assets.getBitmapData(key, true);
		
		if (ClientPrefs.gpuCaching)
		{
			var texture:openfl.display3D.textures.RectangleTexture = FlxG.stage.context3D.createRectangleTexture(bitmap.width, bitmap.height, BGRA, true);
			texture.uploadFromBitmapData(bitmap);
			bitmap.image.data = null;
			bitmap.dispose();
			bitmap.disposeImage();
			bitmap = BitmapData.fromTexture(texture);
		}
		
		var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, key);
		graphic.persist = true;
		graphic.destroyOnNoUse = false;
		
		loadedGraphics.set(key, graphic);
		localAssets.push(key);
		
		return graphic;
	}
	
	/**
	 * Attempts to cache a sound and returns it.
	 */
	public static function cacheSound(key:String, nullSafety:Bool = true)
	{
		if (loadedSounds.exists(key))
		{
			// was cached before return it and refresh its entry in the local list
			localAssets.push(key);
			return loadedSounds.get(key);
		}
		
		if (!Assets.exists(key, SOUND)) // couldnt find it
		{
			// trace('SOUND: [$key] is returning null');
			
			FlxG.log.warn('Sound "$key" was not found!');
			
			// flixel hates null sounds and instantly kills itself so we are gonna return a sound we know is there
			// temporarily toggleable until i finish some stuff
			return nullSafety ? FlxAssets.getSound(Paths.getPath('sounds/soundtray/VolMAX.${Paths.SOUND_EXT}', SOUND)) : null;
		}
		
		var sound:Sound = Assets.getSound(key);
		
		loadedSounds.set(key, sound);
		localAssets.push(key);
		return sound;
	}
}
