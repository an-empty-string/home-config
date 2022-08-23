#!/usr/bin/env python3

from setuptools import setup

setup(
    name="trisfyi",
    version="0.0.1",
    description="tris.fyi 'secrets' management and configuration",
    author="Tris Emmy Wilson",
    author_email="tris@tris.fyi",
    py_modules=["trisfyi"],
    entry_points={
        "console_scripts": [
            "trisfyi = trisfyi:main",
        ],
    },
    install_requires=[
        "click",
        "redis",
    ],
)
