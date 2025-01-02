package funkin.objects;


class DebugText extends FlxText
{
    public var disableTime:Float = 6;
	
	public function new(text:String, color:FlxColor = FlxColor.WHITE)
	{
		super(10, 10, 0, text, 16);
		setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scrollFactor.set();
		this.color = color;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		disableTime -= elapsed;
		if (disableTime <= 0)
		{
			kill();
		}
		else if (disableTime < 1) alpha = disableTime;
	}
}