package funkin.objects;

import flixel.group.FlxSpriteGroup;
import funkin.objects.Note.EventNote;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.states.PlayState;

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

	/**
	 * Sorts the groups members by its Z index
	 * @param group The group to sort. Default is the stage
	 */
	public function refreshZ(?group:FlxTypedGroup<FlxBasic>)
	{ 
		group ??= this;
		MusicBeatState.getState().refreshZ(group);
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
	
	public var boyfriendGroup(get, never):FlxSpriteGroup;
	
	public var dadGroup(get, never):FlxSpriteGroup;
	
	public var gfGroup(get, never):FlxSpriteGroup;
	
	public function new()
	{
		super();
	}
	
	function get_game():PlayState
	{
		return PlayState.instance;
	}
	
	function get_boyfriendGroup():FlxSpriteGroup
	{
		return PlayState.instance.boyfriendGroup;
	}
	
	function get_dadGroup():FlxSpriteGroup
	{
		return PlayState.instance.dadGroup;
	}
	
	function get_gfGroup():FlxSpriteGroup
	{
		return PlayState.instance.gfGroup;
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
