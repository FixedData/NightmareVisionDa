package extensions;

/**
 * A FlxSprite that is a solid color thats scaled to fit to its cameras
 * 
 * Modified to contain a fix for incorrect sizing when cameras are not equal to 1 before `flixel 5.9.0`
 * 
 * and to set the color in its constructor
 */
class FlxBGSpriteEx extends flixel.system.FlxBGSprite
{
	public function new(color:FlxColor = FlxColor.WHITE)
	{
		super();
		this.color = color;
	}

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