# colyseus-demo

This repo is a demo for Colyseus and Schema Serializer

it is intended to be used as a template or for testing

## Server
- Made in Node.js (Haxe soon maybe)
- Uses TypeScript
- Exposes on port 6543 (check index.ts listen)
- Basic server for updating the positions of all players (may not be accurate across clients)
- Example of how to use the Schema Serializer
- Schemas and typedefs
- HTML5 Client detection
- Generated schemas for Haxe already
- Usage of Client join options

## Client
- Made in Haxe with HaxeFlixel 5.5.0
- Using the default template of Flixel projects
- Connects to the given address (uses my domain which exposes the server, you can change it)
- Support for C++ targets (connecting to secure sockets fails so you gotta connect to port 80 which is the unsecure port)
- Basic client that:
    - Updates the current player
    - Sends the current player data to the server
    - Gets the data broadcasted from the server and replicates it to the player sprites
- Example of how to receive state patches and listen to changes on state maps
- Usage of Client join options

I'm surely missing some stuff and more documentation is needed but since I made this while making a tutorial for Galo and I can't even hear my fucking voice then it's missing some good points 'n shit.

I made this purely without any tutorial and reading the [NodeAtlanta 2020 Presentation](https://docs.google.com/presentation/d/1MSZPDvVn1vxjtIAnCMJe-11RtqhQdcMv5V3j83hyBjk/edit?usp=sharing) Endel (creator of Colyseus) made but sadly got cancelled, even if it's outdated, it still helped me with some server code.
