#!/usr/bin/env python3

from setuptools import setup

setup(
    name="mqtt_bluetooth",
    version="0.0.1",
    description="MQTT to bluetoothctl bridge",
    author="Tris Emmy Wilson",
    author_email="tris@tris.fyi",
    py_modules=["mqtt_bluetooth"],
    entry_points={
        "console_scripts": [
            "mqtt-bluetooth = mqtt_bluetooth:sync_main",
        ],
    },
    install_requires=[
        "asyncio_mqtt",
    ],
)
