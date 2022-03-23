from asyncio_mqtt import Client
import json
import asyncio
from collections import namedtuple
from pathlib import Path
from dataclasses import dataclass
from enum import Enum
from typing import NamedTuple


def seconds_to_hms(s: int):
    m = 0

    if s > 60:
        m = s // 60
        s -= m * 60

    return f"{m:02}m{s:02}s"


@dataclass
class Config():
    work_time: int
    break_time: int
    wait_for_break: bool
    use_emoji: bool


class State(NamedTuple):
    long_desc: str
    short_desc: str
    emoji: str


class States(Enum):
    WAITING_TO_WORK = State("stopped", "stopped", "\u23f9")
    WORKING = State("working", "working", "\u25b6")
    WORKING_PAUSED = State("working (paused)", "w pause", "\u23f8")

    WAITING_FOR_BREAK = State("waiting for break", "break w", "\u23f9")
    BREAK = State("break", "break", "\u25b6")
    BREAK_PAUSED = State("break (paused)", "b pause", "\u23f8")


STATE_TRIGGER_MAP = {
    States.WAITING_TO_WORK: States.WORKING,
    States.WORKING: States.WORKING_PAUSED,
    States.WORKING_PAUSED: States.WORKING,
    States.WAITING_FOR_BREAK: States.BREAK,
    States.BREAK: States.BREAK_PAUSED,
    States.BREAK_PAUSED: States.BREAK
}


class App():
    def __init__(self):
        self.load_config()
        self.mqtt = None

    def load_config(self):
        config_path = Path("~/.pomodoro.json").expanduser()

        if config_path.exists():
            with open(config_path) as f:
                config_json = json.load(f)

        else:
            config_json = {}

        self.config = Config(
            work_time=config_json.get("work_time", 25 * 60),
            break_time=config_json.get("break_time", 5 * 60),
            wait_for_break=config_json.get("wait_for_break", True),
            use_emoji=config_json.get("use_emoji", False),
        )

    async def announce(self):
        await self.mqtt.publish("pomodoro/state", self.state.value.long_desc.encode(), retain=True)
        await self.announce_time()

    async def announce_time(self):
        await self.mqtt.publish("pomodoro/time-remaining", str(self.time_remaining).encode(), retain=True)
        await self.mqtt.publish("pomodoro/statusline",
                                ((f"{self.state.value.emoji} " if self.config.use_emoji else "") + 
                                 (f"{self.state.value.short_desc} ({seconds_to_hms(self.time_remaining)})")
                                ).encode(),
                                 retain=True)

    async def transition(self, new_state):
        self.state = new_state

        if new_state == States.WAITING_TO_WORK:
            self.time_remaining = self.config.work_time

        elif new_state == States.WAITING_FOR_BREAK:
            self.time_remaining = self.config.break_time
            if not self.config.wait_for_break:
                await self.transition(States.BREAK)

        await self.announce()

    async def tick_time(self):
        if self.time_remaining == 0:
            if self.state == States.WORKING:
                await self.transition(States.WAITING_FOR_BREAK)

            elif self.state == States.BREAK:
                await self.transition(States.WAITING_TO_WORK)

            return

        if self.state in {States.WORKING, States.BREAK}:
            await asyncio.sleep(1)

            self.time_remaining -= 1
            await self.announce_time()

    async def handle_command(self, command: str):
        if command == "trigger":
            await self.transition(STATE_TRIGGER_MAP[self.state])
            return True

        elif command == "reset":
            await self.transition(States.WAITING_TO_WORK)
            return True

        elif command == "done":
            await self.transition(States.WAITING_FOR_BREAK)
            return True

        elif command == "reload":
            self.load_config()
            return False

        elif command.startswith("time") and command.count(" ") == 1:
            _, arg = command.split(" ", maxsplit=1)
            if "/" not in arg:
                return False

            work_time, break_time = arg.split("/")
            if not work_time.isnumeric() and break_time.isnumeric():
                return False

            self.config.work_time = int(work_time) * 60
            self.config.break_time = int(break_time) * 60

            if self.state == States.WAITING_TO_WORK:
                return await self.handle_command("reset")

    async def handle_internal(self):
        tick_task = None

        while True:
            command_task = asyncio.create_task(self.commands.get(), name="cmd")
            tick_task = None

            if self.state in {States.WORKING, States.BREAK}:
                tick_task = tick_task or asyncio.create_task(self.tick_time(), name="sleep")
                done, _ = await asyncio.wait([tick_task, command_task], return_when=asyncio.FIRST_COMPLETED)

            else:
                done, _ = await asyncio.wait([command_task])

            task = done.pop()

            if task.exception() is not None:
                raise task.exception()

            if task.get_name() == "cmd":
                command = task.result()

                cancel_tick = await self.handle_command(command)
                if cancel_tick and tick_task is not None:
                    tick_task.cancel()

            else:
                command_task.cancel()


    async def handle_messages(self):
        self.commands = asyncio.Queue()

        async with Client("127.0.0.1") as mqtt:
            self.mqtt = mqtt

            await mqtt.subscribe("pomodoro/command")
            await self.transition(States.WAITING_TO_WORK)

            async with mqtt.unfiltered_messages() as messages:
                task = asyncio.create_task(self.handle_internal())

                async for message in messages:
                    await self.commands.put(message.payload.decode())


def main():
    app = App()
    asyncio.run(app.handle_messages())


if __name__ == "__main__":
    main()
