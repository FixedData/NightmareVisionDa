package funkin.objects;

import funkin.objects.Note.EventNote;
import flixel.group.FlxGroup.FlxTypedGroup;

class Stage extends FlxTypedGroup<FlxBasic>
{
	public function addBehindGF(obj:FlxBasic)
	{
		insert(members.indexOf(game.gfGroup), obj);
	}
	
	public function addBehindBF(obj:FlxBasic)
	{
		insert(members.indexOf(game.boyfriendGroup), obj);
	}
	
	public function addBehindDad(obj:FlxBasic)
	{
		insert(members.indexOf(game.dadGroup), obj);
	}
	
	public function onCreate() {}
	
	public function onCreatePost() {}
	
	public function onBeatHit() {}
	
	public function onStepHit() {}
	
	public function onSectionHit() {}
	
	public function onCountdownTick(tick:Int) {}
	
	public function onEventPushed(ev:EventNote) {}
	
	public function onEventTrigger(eventName:String, value1:String, value2:String) {}
	
	public function onEventPushedUnique(ev:EventNote) {}
	
	public var game(get, never):PlayState;
	
	public var boyfriend(get, never):Character;
	
	public var dad(get, never):Character;
	
	public var gf(get, never):Character;
	
	public function new()
	{
		super();
	}
	
	function get_game():PlayState
	{
		return PlayState.instance;
	}
	
	function get_boyfriend():Character
	{
		return PlayState.instance.boyfriend;
	}
	
	function get_dad():Character
	{
		return PlayState.instance.dad;
	}
	
	function get_gf():Character
	{
		return PlayState.instance.gf;
	}
}
