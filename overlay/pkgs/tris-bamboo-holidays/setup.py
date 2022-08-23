#!/usr/bin/env python3

from setuptools import setup

setup(
    name="bamboo-holidays",
    version="0.0.1",
    description="Update holidays from BambooHR",
    author="Tris Emmy Wilson",
    author_email="tris@tris.fyi",
    py_modules=["bamboo_holiday"],
    entry_points={
        "console_scripts": [
            "bamboo-holidays-update = bamboo_holiday:main",
        ],
    },
    install_requires=[
        "requests",
    ],
)
