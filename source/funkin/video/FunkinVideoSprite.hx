package funkin.video;

import openfl.Assets;
import haxe.io.Bytes;
import hxvlc.flixel.FlxVideoSprite;
import funkin.states.PlayState;

class FunkinVideoSprite extends FlxVideoSprite
{
	public static function init()
	{
		hxvlc.util.Handle.init(#if (hxvlc >= "1.8.0") ['--no-lua'] #end);
	}
	
	public static final looping:String = ':input-repeat=65535';
	public static final muted:String = ':no-audio';
	
	public function new(x:Float = 0, y:Float = 0, oneTimeUse:Bool = true, dontAdd:Bool = false)
	{
		super(x, y);
		
		if (oneTimeUse) bitmap.onEndReached.add(this.destroy, true);
		
		if (!dontAdd) tryAddingToPlayState();
	}
	
	function tryAddingToPlayState()
	{
		if (Std.isOfType(FlxG.state, PlayState) && PlayState.instance != null)
		{
			PlayState.instance.onPauseSignal.add(this.pause);
			PlayState.instance.onResumeSignal.add(this.resume);
		}
	}
	
	// this was gonna be more elaborate but i decided not to
	function decipherLocation(local:Location)
	{
		if (local != null && !(local is Int) && !(local is Bytes) && (local is String))
		{
			var local:String = cast(local, String);
			
			var modPath:String = Paths.modFolders('videos/$local');
			var assetPath:String = 'assets/videos/$local';
			
			// found bytes. return em
			if (Assets.exists(modPath, BINARY)) return cast Assets.getBytes(modPath);
			else if (Assets.exists(assetPath, BINARY)) return cast Assets.getBytes(assetPath);
			
			if (FileSystem.exists(modPath)) return cast modPath;
			else if (FileSystem.exists(assetPath)) return cast assetPath;
		}
		
		return local;
	}
	
	override function load(location:Location, ?options:Array<String>):Bool
	{
		if (bitmap == null) return false;
		
		if (autoPause)
		{
			if (!FlxG.signals.focusGained.has(bitmap.resume)) FlxG.signals.focusGained.add(bitmap.resume);
			if (!FlxG.signals.focusLost.has(bitmap.pause)) FlxG.signals.focusLost.add(bitmap.pause);
		}
		
		final realLocal = decipherLocation(location);
		
		if (realLocal != null && !(realLocal is Int) && !(realLocal is Bytes) && (realLocal is String))
		{
			final realLocal:String = cast(realLocal, String);
			
			if (!realLocal.contains('://'))
			{
				final absolutePath:String = FileSystem.absolutePath(realLocal);
				
				if (FileSystem.exists(absolutePath)) return bitmap.load(absolutePath, options);
				else
				{
					FlxG.log.warn('Unable to find the video file at location "$absolutePath".');
					
					return false;
				}
			}
		}
		
		return bitmap.load(realLocal, options);
	}
	
	override function pause()
	{
		super.pause();
		
		if (autoPause)
		{
			if (FlxG.signals.focusGained.has(bitmap.resume)) FlxG.signals.focusGained.remove(bitmap.resume);
			if (FlxG.signals.focusLost.has(bitmap.pause)) FlxG.signals.focusLost.remove(bitmap.pause);
		}
	}
	
	override function resume()
	{
		super.resume();
		if (autoPause)
		{
			if (!FlxG.signals.focusGained.has(bitmap.resume)) FlxG.signals.focusGained.add(bitmap.resume);
			if (!FlxG.signals.focusLost.has(bitmap.pause)) FlxG.signals.focusLost.add(bitmap.pause);
		}
	}
	
	public function onEnd(func:Void->Void, once:Bool = false)
	{
		bitmap.onEndReached.add(func, once);
	}
	
	public function onStart(func:Void->Void, once:Bool = false)
	{
		bitmap.onOpening.add(func, once);
	}
	
	public function onFormat(func:Void->Void, once:Bool = false)
	{
		bitmap.onFormatSetup.add(func, once);
	}
	
	@:noCompletion
	public function addCallback(vidCallBack:VidCallbacks, func:Void->Void, once:Bool = false)
	{
		switch (vidCallBack)
		{
			case ONEND:
				if (func != null) bitmap.onEndReached.add(func, once);
			case ONSTART:
				if (func != null) bitmap.onOpening.add(func, once);
			case ONFORMAT:
				if (func != null) bitmap.onFormatSetup.add(func, once);
		}
	}
	
	public static function cacheVid(path:String)
	{
		var video = new FunkinVideoSprite(0, 0, false, true);
		video.load(path, [muted]);
		video.addCallback(ONFORMAT, () -> {
			video.destroy();
		});
		video.play();
	}
	
	override function destroy()
	{
		if (Std.isOfType(FlxG.state, PlayState) && PlayState.instance != null)
		{
			if (PlayState.instance.onPauseSignal.has(this.pause)) PlayState.instance.onPauseSignal.remove(this.pause);
			if (PlayState.instance.onResumeSignal.has(this.resume)) PlayState.instance.onResumeSignal.remove(this.resume);
		}
		
		if (bitmap != null)
		{
			bitmap.stop();
			
			if (FlxG.signals.focusGained.has(bitmap.resume)) FlxG.signals.focusGained.remove(bitmap.resume);
			if (FlxG.signals.focusLost.has(bitmap.pause)) FlxG.signals.focusLost.remove(bitmap.pause);
		}
		
		super.destroy();
	}
}

enum abstract VidCallbacks(String) from String
{
	public var ONEND:String = 'onEnd';
	public var ONSTART:String = 'onStart';
	public var ONFORMAT:String = 'onFormat';
}

typedef Location = #if (hxvlc <= "1.5.5") hxvlc.util.OneOfThree<String, Int, Bytes>; #else hxvlc.util.Location; #end
