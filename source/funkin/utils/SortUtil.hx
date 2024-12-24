package funkin.utils;

import flixel.util.FlxSort;


/**
    Utility class for sorting methods
**/
class SortUtil
{
	/**
		Sorts Notes by their time
	**/
	inline public static function sortByShit(Obj1:funkin.objects.Note, Obj2:funkin.objects.Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}
	
	/**
		Sorts by floats
	**/
	inline public static function laserSort(Obj1:Float, Obj2:Float):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1, Obj2);
	}
	
	/**
		Sorts Event notes by their time
	**/
	inline public static function sortByTime(Obj1:funkin.objects.Note.EventNote, Obj2:funkin.objects.Note.EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}
	
	/**
		Sorting method used for the modManagers speedEvents
	**/
	inline public static function svSort(Obj1:funkin.states.PlayState.SpeedEvent, Obj2:funkin.states.PlayState.SpeedEvent):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.startTime, Obj2.startTime);
	}
	
	/**
		Sorts by FlxBasic's z values
	**/
	inline public static function sortByZ(order:Int, a:flixel.FlxBasic, b:flixel.FlxBasic):Int
	{
		if (a == null || b == null) return 0;
		return FlxSort.byValues(order, a.zIndex, b.zIndex);
	}
}
