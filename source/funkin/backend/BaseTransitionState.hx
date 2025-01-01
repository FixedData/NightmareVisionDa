package funkin.backend;

// incredibly basic. if you want to apply more to this feel free
class BaseTransitionState extends MusicBeatSubstate
{
	public var finishCallback:Void->Void = null;
	
	var status:TransStatus;
	
	public function new(status:TransStatus,?finishCallback:Void->Void)
	{
		this.status = status;
		if (finishCallback != null) this.finishCallback = finishCallback;
		super();
	}
	
	// ensure u call this to end!!
	public function dispatchFinish()
	{
		if (finishCallback != null) finishCallback();
		FlxTimer.wait(0,close);
	}
}

enum abstract TransStatus(Int)
{
	public var IN_TO = 0;
	public var OUT_OF = 1;
}
