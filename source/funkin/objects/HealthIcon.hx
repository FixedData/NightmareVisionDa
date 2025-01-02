package funkin.objects;

import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (sprTracker != null) setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
	
	public function swapOldIcon()
	{
		if (isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}
	
	private var iconOffsets:Array<Float> = [0, 0];
	
	public function changeIcon(char:String)
	{
		if (this.char != char)
		{
			var name:String = 'icons/' + char;
			if (!Paths.exists(Paths.getPath('images/' + name + '.png', IMAGE), IMAGE)) name = 'icons/icon-' + char; // Older versions of psych engine's support
			if (!Paths.exists(Paths.getPath('images/' + name + '.png', IMAGE), IMAGE)) name = 'icons/icon-face'; // Prevents crash from missing icon
			var file:FlxGraphic = Paths.image(name);
			
			loadGraphic(file, true, Math.floor(file.width / 2), Math.floor(file.height)); // Then load it fr
			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (width - 150) / 2;
			updateHitbox();
			
			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;
			
			antialiasing = ClientPrefs.globalAntialiasing && !char.endsWith('-pixel');
		}
	}
	
	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}
	
	public function getCharacter():String
	{
		return char;
	}
}
