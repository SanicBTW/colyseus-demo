//
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
//
// GENERATED USING @colyseus/schema 2.0.25
//
package schema;

import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

enum abstract MessageType(String) to String from String
{
	var UPDATE_POS = "update_position";
	var UPDATE_COLOR = "update_color";
}

enum abstract PlayerProps(String) to String from String
{
	var NAME = "name";
	var X = "x";
	var Y = "y";
	var COLOR = "color";
}

class Player extends Schema
{
	@:type("string")
	public var name:String = "";

	@:type("number")
	public var x:Dynamic = 0;

	@:type("number")
	public var y:Dynamic = 0;

	@:type("number")
	public var color:Dynamic = 0;
}

class DemoRoomState extends Schema
{
	@:type("map", Player)
	public var players:MapSchema<Player> = new MapSchema<Player>();
}
