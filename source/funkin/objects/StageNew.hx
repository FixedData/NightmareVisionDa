package funkin.objects;

import flixel.group.FlxGroup.FlxTypedGroup;



class StageNew extends FlxTypedGroup<FlxBasic>
{

    public function onCreate() {}

    public function onCreatePost() {}

    public function onBeatHit() {}

    public function onStepHit() {}

    public function onSectionHit() {}

    public var game(get,never):PlayState;

    public var boyfriend(get,never):Character;

    public var dad(get,never):Character;

    public var gf(get,never):Character;

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