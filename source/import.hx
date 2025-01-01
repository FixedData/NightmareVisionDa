#if !macro
// Flixel ========
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.FlxBasic;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
#if sys
import sys.io.*;
import sys.*;
#end
// Discord ========
#if DISCORD_ALLOWED
import funkin.api.DiscordClient;
#end
// Videos ========
#if VIDEOS_ALLOWED
import hxvlc.flixel.*;
#end
// Funkin ========
import Init;
import funkin.Paths;
import funkin.data.ClientPrefs;
import funkin.data.Conductor;
import funkin.utils.CoolUtil;
import funkin.data.Highscore;
import funkin.objects.BGSprite;
import funkin.backend.MusicBeatState;
import funkin.backend.Cache;
import funkin.objects.Alphabet;

using StringTools;
#end
