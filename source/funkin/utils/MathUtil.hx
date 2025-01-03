package funkin.utils;

class MathUtil
{
	/**
		FlxMath.lerp but accounts for FPS.
	**/
	public static inline function fpsLerp(v1:Float, v2:Float, ratio:Float) return FlxMath.lerp(v1, v2, ratio * 60 * FlxG.elapsed);
	
	/**
		Alternative to `FlxMath.wrap`. key difference is it supports floats
		@param min lowest bound
		@param max highest bound
		@return The input bounded to the `min` and `max`
	**/
	public static function wrap(value:Float, min:Float, max:Float):Float
	{
		if (value < min) return max;
		else if (value > max) return min;
		else return value;
	}
	
	/**
	 * Alternative to `FlxMath.roundDecimal` but floors the value rather than rounding it
	 * @param value The number 
	 * @param precision The number of decimals
	 * @return The floored value
	 */
	public static function floorDecimal(value:Float, precision:Int):Float
	{
		if (precision < 1) return Math.floor(value);
		
		var tempMult:Float = 1;
		for (i in 0...precision)
			tempMult *= 10;
			
		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}
	
	/**
		Makes a number array
		* @param	min starting number. default is 0
		* @param	max ending number
		* @return the new array
	**/
	inline public static function numberArray(min:Int = 0, max:Int):Array<Int>
	{
		return [for (i in min...max) i];
	}
	
	/**
		Clamps/Bounds a value. for Ints though.
		* @param	input the value to clamp
		* @return The clamped Value
	**/
	public function intClamp(input:Int, min:Int, max:Int):Int
	{
		if (input < min) input = min;
		if (input > max) input = max;
		return input;
	}
}
