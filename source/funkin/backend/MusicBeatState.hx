package funkin.backend;

import funkin.api.PolyClient;
import funkin.scripting.ScriptManager;
import funkin.utils.SortUtil;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.backend.BaseTransitionState;
import funkin.states.transitions.SwipeTransition;
import flixel.addons.ui.FlxUIState;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import funkin.data.*;
import funkin.data.scripts.*;
import funkin.states.PlayState;
import funkin.states.FreeplayState;

class MusicBeatState extends FlxUIState
{

	static final _defaultTransState:Class<BaseTransitionState> = SwipeTransition;
	
	// change these to change the transition
	public static var transitionInState:Class<BaseTransitionState> = null;
	public static var transitionOutState:Class<BaseTransitionState> = null;
	public static var scriptedTransClName:Null<String> = null;
	
	public function new() super();
	
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;
	
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	
	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls return PlayerSettings.player1.controls;
	
	override function create()
	{
		super.create();
		
		if (!FlxTransitionableState.skipNextTransOut)
		{
			#if !display
			if (scriptedTransClName != null && funkin.scripting.classes.ScriptedBaseTransitionState.listScriptClasses().contains(scriptedTransClName)) 
			{
				openSubState(funkin.scripting.classes.ScriptedBaseTransitionState.init(scriptedTransClName,OUT_OF));
			#end
			}
			else
			{
				openSubState(Type.createInstance(transitionOutState ?? _defaultTransState, [OUT_OF]));
			}

			

		}
	}
	
	public function refreshZ(?group:FlxTypedGroup<FlxBasic>)
	{
		group ??= FlxG.state;
		group.sort(SortUtil.sortByZ, flixel.util.FlxSort.ASCENDING);
	}
	
	override function update(elapsed:Float)
	{
		// everyStep();
		var oldStep:Int = curStep;
		
		updateCurStep();
		updateBeat();
		
		if (oldStep != curStep)
		{
			if (curStep > 0) stepHit();
			
			if (PlayState.SONG != null)
			{
				if (oldStep < curStep) updateSection();
				else rollbackSection();
			}
		}
		
		if (FlxG.keys.justPressed.F1) PolyClient.refresh();
		
		ScriptManager.dispatchEvent(f -> f.onUpdate(elapsed));
		
		if (FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;
		
		super.update(elapsed);
	}
	
	private function updateSection():Void
	{
		if (stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while (curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}
	
	private function rollbackSection():Void
	{
		if (curStep < 0) return;
		
		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if (stepsToDo > curStep) break;
				
				curSection++;
			}
		}
		
		if (curSection > lastSection) sectionHit();
	}
	
	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep / 4;
	}
	
	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);
		
		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrotchet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}
	
	public static function getState():MusicBeatState
	{
		return cast FlxG.state;
	}
	
	public function stepHit():Void
	{
		if (curStep % 4 == 0) beatHit();
		ScriptManager.dispatchEvent(script -> script.onStepHit());
	}
	
	public function beatHit():Void
	{
		ScriptManager.dispatchEvent(script -> script.onBeatHit());
	}
	
	public function sectionHit():Void
	{
		ScriptManager.dispatchEvent(script -> script.onSectionHit());
	}
	
	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if (PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
	
	@:access(funkin.states.FreeplayState)
	override function startOutro(onOutroComplete:() -> Void)
	{
		FlxG.sound?.music?.fadeTween?.cancel();
		FreeplayState.vocals?.fadeTween?.cancel();
		
		if (FlxG.sound != null && FlxG.sound.music != null) FlxG.sound.music.onComplete = null;
		
		if (!FlxTransitionableState.skipNextTransIn)
		{

			//i can clean this up later
			#if !display
			if (scriptedTransClName != null && funkin.scripting.classes.ScriptedBaseTransitionState.listScriptClasses().contains(scriptedTransClName)) 
			{
				openSubState(funkin.scripting.classes.ScriptedBaseTransitionState.init(scriptedTransClName,IN_TO,onOutroComplete));
			#end
			}
			else
			{
				openSubState(Type.createInstance(transitionInState ?? _defaultTransState, [IN_TO,onOutroComplete]));
			}
			return;
		}
		
		FlxTransitionableState.skipNextTransIn = false;
		
		super.startOutro(onOutroComplete);
	}
}
