package funkin.scripting;

// workaround classes for some abstracted class
// please polymod allow some shit like "addDefaultAnonStruct" so i can addt his easier
class ScriptFlxColor
{
	public static final BLACK:Int = cast flixel.util.FlxColor.BLACK;
	public static final BLUE:Int = cast flixel.util.FlxColor.BLUE;
	public static final BROWN:Int = cast flixel.util.FlxColor.BROWN;
	public static final CYAN:Int = cast flixel.util.FlxColor.CYAN;
	public static final GRAY:Int = cast flixel.util.FlxColor.GRAY;
	public static final GREEN:Int = cast flixel.util.FlxColor.GREEN;
	public static final LIME:Int = cast flixel.util.FlxColor.LIME;
	public static final MAGENTA:Int = cast flixel.util.FlxColor.MAGENTA;
	public static final ORANGE:Int = cast flixel.util.FlxColor.ORANGE;
	public static final PINK:Int = cast flixel.util.FlxColor.PINK;
	public static final PURPLE:Int = cast flixel.util.FlxColor.PURPLE;
	public static final RED:Int = cast flixel.util.FlxColor.RED;
	public static final TRANSPARENT:Int = cast flixel.util.FlxColor.TRANSPARENT;
	public static final WHITE:Int = cast flixel.util.FlxColor.WHITE;
	public static final YELLOW:Int = cast flixel.util.FlxColor.YELLOW;
	
	public static function fromCMYK(c:Float, m:Float, y:Float, b:Float, a:Float = 1):Int return cast flixel.util.FlxColor.fromCMYK(c, m, y, b, a);
	
	public static function fromHSB(h:Float, s:Float, b:Float, a:Float = 1):Int return cast flixel.util.FlxColor.fromHSB(h, s, b, a);
	
	public static function fromInt(num:Int):Int return cast flixel.util.FlxColor.fromInt(num);
	
	public static function fromRGBFloat(r:Float, g:Float, b:Float, a:Float = 1):Int return cast flixel.util.FlxColor.fromRGBFloat(r, g, b, a);
	
	public static function fromRGB(r:Int, g:Int, b:Int, a:Int = 255):Int return cast flixel.util.FlxColor.fromRGB(r, g, b, a);
	
	public static function getHSBColorWheel(a:Int = 255):Array<Int> return cast flixel.util.FlxColor.getHSBColorWheel(a);
	
	public static function gradient(color1:flixel.util.FlxColor, color2:flixel.util.FlxColor, steps:Int,
			?ease:Float->Float):Array<Int> return cast flixel.util.FlxColor.gradient(color1, color2, steps, ease);
			
	public static function interpolate(color1:flixel.util.FlxColor, color2:flixel.util.FlxColor, factor:Float = 0.5):Int return cast flixel.util.FlxColor.interpolate(color1, color2, factor);
	
	public static function fromString(string:String):Int return cast flixel.util.FlxColor.fromString(string);
}

class ScriptFlxAxes
{
	public static final X:Int = cast flixel.util.FlxAxes.X;
	public static final Y:Int = cast flixel.util.FlxAxes.Y;
	public static final XY:Int = cast flixel.util.FlxAxes.XY;
}

class ScriptBlendMode
{
	public static final ADD:Int = cast openfl.display.BlendMode.ADD;
	public static final ALPHA:Int = cast openfl.display.BlendMode.ALPHA;
	public static final DARKEN:Int = cast openfl.display.BlendMode.DARKEN;
	public static final DIFFERENCE:Int = cast openfl.display.BlendMode.DIFFERENCE;
	public static final ERASE:Int = cast openfl.display.BlendMode.ERASE;
	public static final HARDLIGHT:Int = cast openfl.display.BlendMode.HARDLIGHT;
	public static final INVERT:Int = cast openfl.display.BlendMode.INVERT;
	public static final LAYER:Int = cast openfl.display.BlendMode.LAYER;
	public static final LIGHTEN:Int = cast openfl.display.BlendMode.LIGHTEN;
	public static final MULTIPLY:Int = cast openfl.display.BlendMode.MULTIPLY;
	public static final NORMAL:Int = cast openfl.display.BlendMode.NORMAL;
	public static final OVERLAY:Int = cast openfl.display.BlendMode.OVERLAY;
	public static final SCREEN:Int = cast openfl.display.BlendMode.SCREEN;
	public static final SHADER:Int = cast openfl.display.BlendMode.SHADER;
	public static final SUBTRACT:Int = cast openfl.display.BlendMode.SUBTRACT;
}

class ScriptFlxTextAlign
{
	public static final LEFT:String = cast flixel.text.FlxText.FlxTextAlign.LEFT;
	public static final JUSTIFY:String = cast flixel.text.FlxText.FlxTextAlign.JUSTIFY;
	public static final RIGHT:String = cast flixel.text.FlxText.FlxTextAlign.RIGHT;
	public static final CENTER:String = cast flixel.text.FlxText.FlxTextAlign.CENTER;
}
