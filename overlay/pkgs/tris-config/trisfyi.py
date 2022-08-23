import click
import inspect
import pickle
from redis import Redis


class Config(Redis):
    def __getitem__(self, key):
        return self.get(f"config/{key}").decode()

    def __setitem__(self, key, value):
        return self.set(f"config/{key}", value)


config = Config(host="hsv1")

class Proxy():
    def __init__(self, obj):
        self.obj = obj

    def save(self):
        self._persist_store.set(self._persist_key, pickle.dumps(self.obj))

    def reload(self):
        self.obj = pickle.loads(self._persist_store.get(self._persist_key))
        self._finalize()

    def _finalize(self):
        for name, value in inspect.getmembers(self.obj):
            if name not in {"__class__", "_finalize", "_persist_store",
                            "_persist_key", "_obj", "save", "reload"}:
                setattr(self, name, value)

    def __str__(self):
        return str(self.obj)

    def __repr__(self):
        return repr(self.obj)


class Store():
    def __init__(self, store):
        self.store = store

    def __contains__(self, attr):
        return bool(self.store.keys(f"store/{attr}"))

    def __getitem__(self, attr):
        if attr not in self:
            raise KeyError()

        obj = Proxy(pickle.loads(self.store.get(f"store/{attr}")))
        obj._persist_store = self.store
        obj._persist_key = f"store/{attr}"
        obj._finalize()

        return obj

    def __setitem__(self, attr, value):
        self.store.set(f"store/{attr}", pickle.dumps(value))

    def get(self, attr, constructor):
        if attr not in self:
            obj = constructor()
            self[attr] = obj

        return self[attr]


store = Store(config)


@click.group()
def main():
    pass


@click.argument("KEY")
@click.option("--value", prompt=True)
@main.command()
def set_config(key, value):
    config[key] = value
    click.echo(f"{key!r} set successfully.", err=True)


@click.argument("KEY")
@main.command()
def get_config(key):
    click.echo(config[key])


if __name__ == "__main__":
    main()
