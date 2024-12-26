package funkin;

import openfl.utils.AssetType;
import openfl.Assets;
import lime.utils.Assets as LimeAssets;

class PathsReal
{

    public static final SOUND_EXT:String = 'ogg';

	inline public static function font(key:String)
	{
		return 'assets/fonts/$key';
	}

    inline public static function image(key:String,?library:String)
    {
		
        return getPath('images/$key.png',IMAGE,library);
    }

    inline public static function sound(key:String,?library:String)
    {
        return getPath('sounds/$key.$SOUND_EXT',SOUND,library);
    }

    inline public static function music(key:String,?library:String)
    {
        return getPath('music/$key.$SOUND_EXT',MUSIC,library);
    }

	static public var currentLevel:String;
	
	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}
	
	public static function getPath(file:String, ?type:AssetType = TEXT, ?library:Null<String> = null)
	{
		if (library != null) return getLibraryPath(file, library);
		
		if (currentLevel != null)
		{
			var levelPath:String = '';
			if (currentLevel != 'shared')
			{
				levelPath = getLibraryPathForce(file, currentLevel);
				if (Assets.exists(levelPath, type)) return levelPath;
			}
			
			levelPath = getLibraryPathForce(file, "shared");
			if (Assets.exists(levelPath, type)) return levelPath;
		}
		
		return getSharedPath(file);
	}
	
	static public function getLibraryPath(file:String, library = "shared")
	{
		return if (library == "shared") getSharedPath(file); else getLibraryPathForce(file, library);
	}
	
	inline static function getLibraryPathForce(file:String, library:String)
	{
		var returnPath = '$library:assets/$library/$file';
		return returnPath;
	}
	
	inline public static function getSharedPath(file:String = '')
	{
		return 'assets/shared/$file';
	}
}
