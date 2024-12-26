package funkin.scripting;

import funkin.scripting.classes.ScriptedFunkinScript;

//based on base games implementation!!! love yall
class ScriptManager
{
	public static final loadedScripts:Map<String, FunkinScript> = [];
	
	public static function build()
	{
		clear();
		
		var scripts = ScriptedFunkinScript.listScriptClasses();
		for (id in scripts)
		{
			var newScript:ScriptedFunkinScript = ScriptedFunkinScript.init(id, id);
			if (newScript != null)
			{
				loadedScripts.set(newScript.name, newScript);
				newScript.onLoad(); //first time load 
			}
		}

		setSignals();
	}

	static function setSignals()
	{
		if (FlxG.signals.postStateSwitch.has(onStateChangePost)) FlxG.signals.postStateSwitch.remove(onStateChangePost);
		FlxG.signals.postStateSwitch.add(onStateChangePost);
	}
	
	public static function clear()
	{
		for (i in loadedScripts)
		{
			i.onDestroy();
		}
		loadedScripts.clear();
	}
	
	public static function dispatchEvent(event:FunkinScript->Void)
	{
		for (i in loadedScripts)
		{
			if (i != null) event(i);
		}
	}

	public static function onStateChangePost()
	{
		dispatchEvent(f->f.onStateChangePost());
	}

}
