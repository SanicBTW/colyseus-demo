# Welcome to Colyseus!

This project has been created using [⚔️ `create-colyseus-app`](https://github.com/colyseus/create-colyseus-app/) - an npm init template for kick starting a Colyseus project in TypeScript.

[Documentation](http://docs.colyseus.io/)

## ⚔️ Usage

```
npm start
```

## Structure

- `index.ts`: main entry point, register an empty room handler and attach [`@colyseus/monitor`](https://github.com/colyseus/colyseus-monitor)
- `src/DemoRoom.ts`: an empty room handler for you to implement your logic
- `src/schema/DemoRoomState.ts`: an empty schema used on your room's state.
- `package.json`:
    - `scripts`:
        - `npm start`: runs `ts-node-dev index.ts`
- `tsconfig.json`: TypeScript configuration file


## License

MIT
