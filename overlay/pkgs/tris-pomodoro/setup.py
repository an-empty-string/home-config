#!/usr/bin/env python3

from setuptools import setup

setup(
    name="pomdoro",
    version="0.0.1",
    description="A pomodoro tool",
    author="Tris Emmy Wilson",
    author_email="tris@tris.fyi",
    py_modules=["pomodoro"],
    entry_points={
        "console_scripts": [
            "pomodoro-server = pomodoro:main",
        ],
    },
    install_requires=[
        "aiomqtt",
    ],
)
