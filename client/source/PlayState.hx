package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.colyseus.Client;
import io.colyseus.Room;
import io.colyseus.serializer.SchemaSerializer;
import lime.app.Application;
import schema.DemoRoomState;

typedef ServerPosition =
{
	var x:Float;
	var y:Float;
}

class PlayState extends FlxState
{
	var playerGrp:FlxTypedSpriteGroup<PlayerSprite>;
	var playerMap:Map<String, PlayerSprite> = new Map();

	var curPlayer:PlayerSprite;
	var room:Room<DemoRoomState>;

	override public function create()
	{
		super.create();

		playerGrp = new FlxTypedSpriteGroup<PlayerSprite>();
		add(playerGrp);

		var name:String = "guest" + FlxG.random.int(1, 999);

		var client:Client = new Client("ws.sancopublic.com", #if html5 443 #else 80 #end, #if html5 true #else false #end);
		client.joinOrCreate("demo_room", [
			"name" => name,
			"color" => FlxColor.WHITE,
			"initX" => FlxG.random.int(10, 100),
			"initY" => FlxG.random.int(50, 150)
		], DemoRoomState, (err, room) ->
			{
				if (err != null)
				{
					Application.current.window.alert(err.message, "Failed to connect");
					return;
				}

				@:privateAccess
				room.serializer = new SchemaSerializer<DemoRoomState>(DemoRoomState);
				this.room = room;

				trace("Ready");

				try
				{
					room.state.players.onAdd((player:Player, sessionID:String) ->
					{
						trace('Player joined ${player.name}');

						if (room.sessionId == sessionID)
							playerMap.set(sessionID, playerGrp.add(curPlayer = new PlayerSprite()));
						else
							playerMap.set(sessionID, playerGrp.add(new PlayerSprite()));

						player.listen(PlayerProps.X, (pos:Float, _) ->
						{
							playerMap.get(sessionID).serverPos.x = pos;
						});

						player.listen(PlayerProps.Y, (pos:Float, _) ->
						{
							playerMap.get(sessionID).serverPos.y = pos;
						});

						player.listen(PlayerProps.COLOR, (newColor:Int, oldColor:Null<Int>) ->
						{
							if (oldColor == null || oldColor == 0)
							{
								trace('Player joined with color ${FlxColor.fromInt(newColor).toWebString()}');
								playerMap.get(sessionID).player.makeGraphic(50, 50, FlxColor.fromInt(newColor));
							}
							else
								FlxTween.color(playerMap.get(sessionID).player, 0.75, FlxColor.fromInt(oldColor), FlxColor.fromInt(newColor));
						});

						player.listen(PlayerProps.NAME, (newName:String, oldName:Null<String>) ->
						{
							if (oldName == null || oldName.length <= 0)
							{
								trace('Player joined with name $newName');
								playerMap.get(sessionID).name.text = newName;
							}
							else
							{
								playerMap.get(sessionID).name.text = newName;
								trace('$oldName -> $newName');
							}
						});
					});

					room.state.players.onRemove((player:Player, sessionID:String) ->
					{
						trace('${player.name} left the room');
						playerGrp.remove(playerMap.get(sessionID), true);
						playerMap.remove(sessionID);
					});
				}
				catch (ex)
				{
					Application.current.window.alert(Std.string(ex), "Failed to listen to state changes");
				}
			});
	}

	var speed:Float = 3;

	override public function update(elapsed:Float)
	{
		if (room == null)
			return;

		if (FlxG.keys.anyPressed([UP, W]))
		{
			room.send(MessageType.UPDATE_POS, {
				moveX: false,
				moveY: true,
				mult: -speed,
				elapsed: elapsed
			});
		}

		if (FlxG.keys.anyPressed([DOWN, S]))
		{
			room.send(MessageType.UPDATE_POS, {
				moveX: false,
				moveY: true,
				mult: speed,
				elapsed: elapsed
			});
		}

		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			room.send(MessageType.UPDATE_POS, {
				moveX: true,
				moveY: false,
				mult: -speed,
				elapsed: elapsed
			});
		}

		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			room.send(MessageType.UPDATE_POS, {
				moveX: true,
				moveY: false,
				mult: speed,
				elapsed: elapsed
			});
		}

		super.update(elapsed);
	}
}

class PlayerSprite extends FlxSpriteGroup
{
	public var player:FlxSprite;
	public var name:FlxText;
	public var serverPos:ServerPosition = {
		x: 0,
		y: 0
	};

	override public function new()
	{
		super();

		player = new FlxSprite();
		add(player);

		name = new FlxText();
		name.size = 16;
		add(name);
	}

	override public function update(elapsed:Float)
	{
		var lerp:Float = FlxMath.bound(elapsed * 9.6, 0, 1);

		player.x = FlxMath.lerp(player.x, serverPos.x, lerp);
		player.y = FlxMath.lerp(player.y, serverPos.y, lerp);

		if (name.text.length > 0)
		{
			name.setPosition(player.getGraphicMidpoint().x - (name.width) / 2, (player.getGraphicMidpoint().y + player.height));
		}

		super.update(elapsed);
	}
}
