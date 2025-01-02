package funkin.api;

import Sys.sleep;
import funkin.states.*;
#if LUA_ALLOWED
import llua.Lua;
import llua.State;
#end
#if DISCORD_ALLOWED
import discord_rpc.DiscordRpc;
#end

class DiscordClient
{
	public static var discordPresences:Array<String> = [];
	
	public static var isInitialized:Bool = false;
	
	public function new()
	{
		#if DISCORD_ALLOWED
		trace("Discord Client starting...");
		
		DiscordRpc.start(
			{
				clientID: "1252033037680513115",
				onReady: onReady,
				onError: onError,
				onDisconnected: onDisconnected
			});
		trace("Discord Client started.");
		
		while (true)
		{
			DiscordRpc.process();
			sleep(2);
		}
		
		DiscordRpc.shutdown();
		#end
	}
	
	public static function shutdown()
	{
		#if DISCORD_ALLOWED
		DiscordRpc.shutdown();
		#end
	}
	
	static function onReady()
	{
		#if DISCORD_ALLOWED
		DiscordRpc.presence(
			{
				details: "mod",
				state: null,
				largeImageKey: 'icon',
				largeImageText: "mod"
			});
		#end
	}
	
	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}
	
	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}
	
	public static function initialize()
	{
		#if DISCORD_ALLOWED
		sys.thread.Thread.create(() -> {
			new DiscordClient();
		});
		trace("Discord Client initialized");
		isInitialized = true;
		#end
	}
	
	public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
	{
		#if DISCORD_ALLOWED
		var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;
		
		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}
		
		DiscordRpc.presence(
			{
				details: details,
				state: state,
				largeImageKey: 'icon',
				largeImageText: "Engine Version: " + Main.NM_VERSION,
				smallImageKey: smallImageKey,
				// Obtained times are in milliseconds so they are divided so Discord can use it
				startTimestamp: Std.int(startTimestamp / 1000),
				endTimestamp: Std.int(endTimestamp / 1000)
			});
		#end
	}
	
	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State)
	{
		Lua_helper.add_callback(lua, "changePresence", function(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float) {
			changePresence(details, state, smallImageKey, hasStartTimestamp, endTimestamp);
		});
	}
	#end
}
