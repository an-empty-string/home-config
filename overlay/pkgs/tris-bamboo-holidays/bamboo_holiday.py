from trisfyi import config

import os
import requests


def main():
    lines = []

    tenant = config["bamboohr/tenant"]
    name = config["bamboohr/name"]

    for feed in ("pto", "holiday"):
        key = config[f"bamboohr/feed/{feed}"]

        lines.extend(
            requests.get(
                f"https://{tenant}.bamboohr.com/feeds/feed.php?id={key}"
            ).text.splitlines()
        )

    state = {}
    seen = []

    n = 0

    with open(os.path.expanduser("~/.holidays"), "w") as f:
        for line in lines:
            # extremely lazy and bad ical parser
            if line.startswith(" "):
                continue

            k, v = line.strip().split(":")
            if k == "BEGIN:VEVENT":
                state.clear()

            if k == "SUMMARY":
                state["summary"] = v

            if k == "DTSTART;VALUE=DATE":
                state["start"] = int(v)

            if k == "DTEND;VALUE=DATE":
                state["end"] = int(v)

            if k == "END:VEVENT":
                if state in seen:
                    continue

                seen.append(state.copy())

                desc = state["summary"]
                if "Company Holiday" not in desc and name not in desc:
                    continue

                desc = desc.replace("Company Holiday - ", "")
                if name in desc:
                    desc = "PTO"

                n += 1

                print(f"holiday.bamboo{n}.name={desc}", file=f)
                if state["start"] == state["end"] - 1:
                    print(f"holiday.bamboo{n}.date={state['start']}", file=f)

                else:
                    print(f"holiday.bamboo{n}.start={state['start']}", file=f)
                    print(f"holiday.bamboo{n}.end={state['end'] - 1}", file=f)


if __name__ == "__main__":
    main()
