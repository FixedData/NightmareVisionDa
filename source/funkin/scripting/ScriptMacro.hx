package funkin.scripting;

#if macro
import haxe.macro.Expr.Metadata;
import haxe.macro.Context;
import haxe.macro.Expr.Access;

// might not be final debating how i want to do this still

/**
 * Macros that includes functions into a given class by role
 * 
 * inspired by FPS Plus global scripting macro
 */
class ScriptMacro
{
	/**
	 * Adds a variety of functions for playstate usage
	 */
	public static macro function buildPlaystate():Array<haxe.macro.Expr.Field>
	{
		var fields:Array<haxe.macro.Expr.Field> = Context.getBuildFields();
		
		var position = Context.currentPos();
		
		// characters -------------
		fields.push(
			{
				doc: "Gets the active boyfriend in PlayState",
				name: "boyfriend",
				access: [Access.APublic],
				kind: FieldType.FProp("get", "never", (macro :Character)),
				pos: position,
			});
			
		fields.push(
			{
				name: "get_boyfriend",
				access: [Access.APrivate, Access.AInline],
				kind: FFun(
					{
						args: [],
						expr: macro return funkin.states.PlayState.instance.boyfriend,
						ret: (macro :Character)
					}),
				pos: position,
				meta: [{name: ':noCompletion', pos: position}]
			});
			
		fields.push(
			{
				doc: "Gets the active dad in PlayState",
				name: "dad",
				access: [Access.APublic],
				kind: FieldType.FProp("get", "never", (macro :Character)),
				pos: position,
			});
			
		fields.push(
			{
				name: "get_dad",
				access: [Access.APrivate, Access.AInline],
				kind: FFun(
					{
						args: [],
						expr: macro return funkin.states.PlayState.instance.dad,
						ret: (macro :Character)
					}),
				pos: position,
				meta: [{name: ':noCompletion', pos: position}]
			});
			
		fields.push(
			{
				doc: "Gets the active gf in PlayState",
				name: "gf",
				access: [Access.APublic],
				kind: FieldType.FProp("get", "never", (macro :Character)),
				pos: position,
			});
			
		fields.push(
			{
				name: "get_gf",
				access: [Access.APrivate, Access.AInline],
				kind: FFun(
					{
						args: [],
						expr: macro return funkin.states.PlayState.instance.gf,
						ret: (macro :Character)
					}),
				pos: position,
				meta: [{name: ':noCompletion', pos: position}]
			});
			
		// misc -------------
		
		fields.push(
			{
				doc: "shortcut to `PlayState.instance`",
				name: "gameState",
				access: [Access.APublic],
				kind: FieldType.FProp("get", "never", (macro :funkin.states.PlayState)),
				pos: position,
			});
			
		fields.push(
			{
				name: "get_gameState",
				access: [Access.APrivate, Access.AInline],
				kind: FFun(
					{
						args: [],
						expr: macro return funkin.states.PlayState.instance,
						ret: (macro :funkin.states.PlayState)
					}),
				pos: position,
				meta: [{name: ':noCompletion', pos: position}]
			});
			
		return fields;
	}
}
#end
