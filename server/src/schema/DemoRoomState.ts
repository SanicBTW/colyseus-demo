import { Schema, type, MapSchema } from "@colyseus/schema";

export type UpdatePosData =
{
    moveX:boolean;
    moveY:boolean;
    mult:number;
    elapsed:number;
}

export enum MessageType
{
    UPDATE_POS = "update_position",
    UPDATE_COLOR = "update_color",
}

export type JoinOptions = 
{
    name:string;
    color:number;
    initX:number;
    initY:number;
}

export class Player extends Schema
{
    @type("string")
    name:string = "";

    @type("number")
    x:number = 0;

    @type("number")
    y:number = 0;

    @type("number")
    color:number = 0;
}

export class DemoRoomState extends Schema
{
    @type({map: Player})
    players:MapSchema<Player, string> = new MapSchema<Player>();
}