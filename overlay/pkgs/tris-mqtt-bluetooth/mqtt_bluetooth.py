import asyncio
import re
import socket

from aiomqtt import Client


async def main():
    async with Client("hsv1") as mqtt:
        await mqtt.subscribe("bluetooth/all")
        await mqtt.subscribe(f"bluetooth/{socket.gethostname()}")

        async with mqtt.unfiltered_messages() as messages:
            async for message in messages:
                payload = message.payload.decode()

                if payload.count(" ") != 1:
                    continue

                command, mac = payload.split(" ", maxsplit=1)
                if command not in ("connect", "disconnect"):
                    continue

                if not re.match(r"^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$", mac):
                    continue

                await asyncio.create_subprocess_exec("bluetoothctl", command, mac)


def sync_main():
    asyncio.run(main())


if __name__ == "__main__":
    sync_main()
