package funkin.utils;

/**
 * Utility class with alternatives to `FlxG.random` and `FlxRandom` as some functions are marked as generic making them unusable in scripts.
 */
class RandomUtil
{
	/**
	 * Shuffles the entries in an array in-place into a new pseudorandom order,
	 * using the standard Fisher-Yates shuffle algorithm.
	 *
	 * @param  array  The array to shuffle.
	 */
	public static function shuffle(array:Array<Dynamic>)
	{
		var maxValidIndex = array.length - 1;
		for (i in 0...maxValidIndex)
		{
			var j = FlxG.random.int(i, maxValidIndex);
			var tmp = array[i];
			array[i] = array[j];
			array[j] = tmp;
		}
	}
	
	/**
	 * Returns a random object from an array.
	 *
	 * @param   Objects        An array from which to return an object.
	 * @param   WeightsArray   Optional array of weights which will determine the likelihood of returning a given value from Objects.
	 * 						   If none is passed, all objects in the Objects array will have an equal likelihood of being returned.
	 *                         Values in WeightsArray will correspond to objects in Objects exactly.
	 * @param   StartIndex     Optional index from which to restrict selection. Default value is 0, or the beginning of the Objects array.
	 * @param   EndIndex       Optional index at which to restrict selection. Ignored if 0, which is the default value.
	 * @return  A pseudorandomly chosen object from Objects.
	 */
	public static function getObject(objects:Array<Dynamic>, ?weightsArray:Array<Float>, startIndex:Int = 0, ?endIndex:Null<Int>)
	{
		var selected:Null<Dynamic> = null;
		
		if (objects.length != 0)
		{
			weightsArray ??= [for (i in 0...objects.length) 1];
			
			endIndex ??= objects.length - 1;
			
			startIndex = Std.int(FlxMath.bound(startIndex, 0, objects.length - 1));
			endIndex = Std.int(FlxMath.bound(endIndex, 0, objects.length - 1));
			
			// Swap values if reversed
			if (endIndex < startIndex)
			{
				startIndex = startIndex + endIndex;
				endIndex = startIndex - endIndex;
				startIndex = startIndex - endIndex;
			}
			
			if (endIndex > weightsArray.length - 1)
			{
				endIndex = weightsArray.length - 1;
			}
			
			final arrayHelper = [for (i in startIndex...endIndex + 1) weightsArray[i]];
			
			selected = objects[startIndex + FlxG.random.weightedPick(arrayHelper)];
		}
		
		return selected;
	}
}
