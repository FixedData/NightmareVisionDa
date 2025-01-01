package extensions;

class FlxBGSpriteEx extends flixel.system.FlxBGSprite
{
    #if (flixel < "5.9.0")
	@:access(flixel.FlxCamera)
	override public function draw():Void
	{
		for (camera in getCamerasLegacy())
		{
			if (!camera.visible || !camera.exists)
			{
				continue;
			}
			
			_matrix.identity();
			_matrix.scale(camera.viewWidth, camera.viewHeight);
			_matrix.translate(camera.viewMarginLeft, camera.viewMarginTop);
			camera.drawPixels(frame, _matrix, colorTransform);
			
			#if FLX_DEBUG
			FlxBasic.visibleCount++;
			#end
		}
	}
    #end
}