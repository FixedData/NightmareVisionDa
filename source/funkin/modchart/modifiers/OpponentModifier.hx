package funkin.modchart.modifiers;

import flixel.FlxSprite;
import funkin.modchart.*;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import math.Vector3;

class OpponentModifier extends NoteModifier
{
	override function getName() return 'opponentSwap';
	
	override function getPos(time:Float, diff:Float, tDiff:Float, beat:Float, pos:Vector3, data:Int, player:Int, obj:FlxSprite)
	{
		if (getValue(player) == 0) return pos;
		var nPlayer = Std.int(CoolUtil.scale(player, 0, 1, 1, 0));
		
		var oppX = modMgr.getBaseX(data, nPlayer);
		var plrX = modMgr.getBaseX(data, player);
		
		var distX = oppX - plrX;
		
		pos.x = pos.x + distX * getValue(player);
		
		return pos;
	}
}
