package funkin.scripting;

// barebones but planned more
class FunkinScript
{
	public var name:String;
	
	public function new(name:String)
	{
		this.name = name;
	}
	
	public function onUpdate(e:Float) {}
	
	public function onLoad() {}
	
	public function onCreate() {}
	
	public function onCreatePost() {}
	
	public function onDestroy() {}
	
	public function onStepHit() {}
	
	public function onBeatHit() {}
	
	public function onSectionHit() {}
	
	public function onStateChangePost() {}
	
	public function add(basic:FlxBasic) return FlxG.state.add(basic);
	
	public function remove(basic:FlxBasic) return FlxG.state.remove(basic);
	
	public function insert(idx:Int, basic:FlxBasic) return FlxG.state.insert(idx, basic);
	
	public function toString() return 'FunkinScript - NAME[$name]';
}
