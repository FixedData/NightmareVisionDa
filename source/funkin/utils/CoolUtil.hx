package funkin.utils;

import flixel.util.FlxStringUtil;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxPoint;
import flixel.FlxG;
import openfl.utils.Assets;

/**
	General Utility class for more one off functions
**/
class CoolUtil
{
	/**
	 * Remaps a value from a range to a new range
	 * 
	 * Akin to `FlxMath.remapToRange`
	 * @param x Input value
	 * @param l1 Low bound of range 1
	 * @param h1 High bound of range 1
	 * @param l2 Low bound of range 2
	 * @param h2 High bound of range 2
	 * @return Input value remapped to range 2
	 */
	inline public static function scale(x:Float, l1:Float, h1:Float, l2:Float, h2:Float):Float return ((x - l1) * (h2 - l2) / (h1 - l1) + l2);
	
	/**
	 * Clamps/Bounds a value between a range that it cannot go below or over
	 * 
	 * Akin to `FlxMath.bound`
	 * @param n Input value
	 * @param l Low boundary
	 * @param h High Boundary
	 * @return Clamped value
	 */
	inline public static function clamp(n:Float, l:Float, h:Float)
	{
		if (n > h) n = h;
		if (n < l) n = l;
		return n;
	}
	
	/**
	 * Creates or uses a provided point and rotates it around a given `x` and `y` by radians
	 * 
	 * Akin to `new FlxPoint(x,y).radians += angle`
	 * @param x 
	 * @param y 
	 * @param angle 
	 * @param point 
	 * @return A rotated FlxPoint
	 */
	public static function rotate(x:Float, y:Float, angle:Float, ?point:FlxPoint):FlxPoint
	{
		var p = point ?? FlxPoint.weak();
		p.set((x * Math.cos(angle)) - (y * Math.sin(angle)), (x * Math.sin(angle)) + (y * Math.cos(angle)));
		return p;
	}
	
	inline public static function quantizeAlpha(f:Float, interval:Float)
	{
		return Std.int((f + interval / 2) / interval) * interval;
	}
	
	inline public static function quantize(f:Float, interval:Float)
	{
		return Std.int((f + interval / 2) / interval) * interval;
	}
	
	//-----------------------------------------------------------------//
	
	/**
		capitalizes the first letter of a given `String`
	**/
	inline public static function capitalize(text:String):String return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
	
	/**
		Helper Function to Fix Save Files for Flixel 5

		-- EDIT: [November 29, 2023] --

		this function is used to get the save path, period.
		since newer flixel versions are being enforced anyways.
		@crowplexus
	**/
	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String return '${FlxG.stage.application.meta.get('company')}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}';
	
	/**
	 * Parses a text files and splits it by line 
	 * @param path The path to the txt file
	 * @return An array of the parsed lines
	 */
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];

		if (Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		
		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}
		
		return daList;
	}
	
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');
		
		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}
		
		return daList;
	}
	
	/**
		Finds the most used Color on a given sprite 

		should be used lightly as its very performance heavy
	**/
	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0)
				{
					if (countByColor.exists(colorOfThisPixel))
					{
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					}
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
					{
						countByColor[colorOfThisPixel] = 1;
					}
				}
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
		for (key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}
	
	/**
	 * Opens a given url on your browser
	 */
	public static function browserLoad(url:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [url]);
		#else
		FlxG.openURL(url);
		#end
	}
	
	inline public static function openFolder(folder:String, absolute:Bool = false)
	{
		#if sys
		if (!absolute) folder = Sys.getCwd() + '$folder';
		
		folder = folder.replace('/', '\\');
		if (folder.endsWith('/')) folder.substr(0, folder.length - 1);
		
		#if linux
		var command:String = '/usr/bin/xdg-open';
		#else
		var command:String = 'explorer.exe';
		#end
		Sys.command(command, [folder]);
		trace('$command $folder');
		#else
		FlxG.error("Platform is not supported for CoolUtil.openFolder");
		#end
	}
	
	/**
		helper to quickly set transSkips
	**/
	public static inline function setTransSkip(into:Bool = true, outof:Bool = true)
	{
		FlxTransitionableState.skipNextTransIn = into;
		FlxTransitionableState.skipNextTransOut = outof;
	}
}
