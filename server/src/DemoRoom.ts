import { Room, Client, SchemaSerializer, ClientArray } from "colyseus";
import { DemoRoomState, JoinOptions, MessageType, Player, UpdatePosData } from "./schema/DemoRoomState";

export class DemoRoom extends Room<DemoRoomState>
{
    onCreate(options: any): void | Promise<any>
    {
        this.setSerializer(new SchemaSerializer<DemoRoomState>());
        this.setState(new DemoRoomState());

        this.onMessage(MessageType.UPDATE_POS, (client, message:UpdatePosData) =>
        {
            var player:Player = this.state.players.get(client.sessionId);
            if (message.moveX)
            {
                player.x += (message.elapsed * 100) * message.mult;
            }

            if (message.moveY)
            {
                player.y += (message.elapsed * 100) * message.mult;
            }
        });
    }

    onJoin(client: Client<this["clients"] extends ClientArray<infer U, any> ? U : never, this["clients"] extends ClientArray<infer _, infer U> ? U : never>, options?:JoinOptions, auth?: this["clients"] extends ClientArray<infer _, infer U> ? U : never): void | Promise<any>
    {
        var newPlayer:Player = new Player();

        if ("h" in options)
        {
            console.log("Client is in HTML5");
            options = options["h"] as JoinOptions;
        }

        newPlayer.name = options.name;
        newPlayer.color = options.color;
        newPlayer.x = options.initX;
        newPlayer.y = options.initY;

        this.state.players.set(client.sessionId, newPlayer);

        console.log(`${options.name} joined the room`);
    }

    onLeave(client: Client<this["clients"] extends ClientArray<infer U, any> ? U : never, this["clients"] extends ClientArray<infer _, infer U> ? U : never>, consented?: boolean): void | Promise<any>
    {
        this.state.players.delete(client.sessionId);
        console.log(`${client.sessionId} left the room`);
    }

    onDispose(): void | Promise<any>
    {
        console.log(`Disposing room with ID of ${this.roomId}`);
    }
}