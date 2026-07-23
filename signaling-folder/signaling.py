import asyncio
import websockets

connected_clients = set()

async def handler(websocket):
    connected_clients.add(websocket)
    #websocket is the connection channel
    print(f"client connected to the list: {len(connected_clients)}")
    try:
        async for message in websocket:
            for client in connected_clients:
            #check all the clients and in each one if it is the same person sending the message
            #if it's not send them the message
                if client != websocket:
                    await client.send(message)
    except websockets.exceptions.ConnectionClosed:
        pass
    finally:
        connected_clients.remove(websocket)
        print(f"Client disconnected. Total clients: {len(connected_clients)}")

async def main():
    async with websockets.serve(handler,"localhost",8765):
        print("Running")
        await asyncio.Future()

if __name__ == '__main__':
    asyncio.run(main())