package funkin.states.transitions;

import funkin.utils.CameraUtil;
import funkin.backend.BaseTransitionState;
import flixel.util.FlxGradient;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxColor;

// the regular swipe transition used in fnf
class SwipeTransition extends BaseTransitionState
{
	var gradientFill:FlxSprite;
	var gradient:FlxSprite;
	
	public override function destroy():Void
	{
		super.destroy();
		
		gradient?.destroy();
		gradientFill?.destroy();
		gradient = null;
		gradientFill = null;
	}
	
	public override function update(elapsed:Float)
	{
		if (gradientFill != null && gradient != null)
		{
			switch (status)
			{
				case IN:
					gradientFill.y = gradient.y - gradient.height;
				case OUT:
					gradientFill.y = gradient.y + gradient.height;
				default:
			}
		}
		super.update(elapsed);
	}
	
	override function create()
	{
		final cam = CameraUtil.lastCamera;
		cameras = [cam];
		
		final duration:Float = status == OUT ? 0.6 : 0.48;
		final angle:Int = status == OUT ? 270 : 90;
		final zoom:Float = FlxMath.bound(cam.zoom, 0.001);
		final width:Int = Math.ceil(cam.width / zoom);
		final height:Int = Math.ceil(cam.height / zoom);
		
		final yStart:Float = -height;
		final yEnd:Float = height;
		
		gradient = FlxGradient.createGradientFlxSprite(1, height, [FlxColor.BLACK, FlxColor.TRANSPARENT], 1, angle);
		gradient.scale.x = width;
		gradient.scrollFactor.set();
		gradient.screenCenter(X);
		gradient.y = yStart;
		
		gradientFill = new FlxSprite().makeScaledGraphic(width, height, FlxColor.BLACK);
		gradientFill.screenCenter(X);
		gradientFill.scrollFactor.set();
		add(gradientFill);
		add(gradient);
		
		FlxTween.tween(gradient, {y: yEnd}, duration, {onComplete: Void -> dispatchFinish()});
		
		super.create();
	}
}
