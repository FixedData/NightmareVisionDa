package funkin.states.transitions;

import funkin.utils.CameraUtil;
import funkin.backend.BaseTransitionState;
import extensions.FlxBGSpriteEx;
// simple fade transition between states
class FadeTransition extends BaseTransitionState
{
	var sprite:FlxBGSpriteEx;
	
	override function create()
	{
		cameras = [CameraUtil.lastCamera];
		
		sprite = new FlxBGSpriteEx();
		sprite.color = FlxColor.BLACK;
		add(sprite);
		
		sprite.alpha = status == IN_TO ? 0 : 1;
		final desiredAlpha = status == IN_TO ? 1 : 0;
		final time = status == IN_TO ? 0.48 : 0.8;
		
		FlxTween.tween(sprite, {alpha: desiredAlpha}, time, {onComplete: Void -> dispatchFinish()});
		
		super.create();
	}
	
	override function destroy()
	{
		super.destroy();
		sprite?.destroy();
		sprite = null;
	}
}


