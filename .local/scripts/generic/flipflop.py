#!/usr/bin/env python3

"""
toggeable todos with the ability to flip back/forth easily

$ flipflop.py status
 What            | On
-----------------+-------
 refill_lotion   | False
 refill_vitamins | False

$ flipflop.py flip
'what' (str) > refill_vitamins

$ flipflop.py status
 What            | On
-----------------+-------
 refill_lotion   | False
 refill_vitamins | True
"""

import os
import json
from typing import NamedTuple, Dict
from enum import Enum
from datetime import datetime

import click

# disable default ttally config loading when ttally.__init__ is imported
os.environ["TTALLY_SKIP_DEFAULT_IMPORT"] = "1"
from ttally.core import Extension

with open(os.path.join(os.environ["SHARED_DIR"], ".flipflop.txt")) as f:
    flipflop_choices = f.read().strip().splitlines()


# create enum from environment variable
FlipT = Enum("FlipT", flipflop_choices)


class Flip(NamedTuple):
    when: datetime
    what: FlipT  # type: ignore
    on: bool


def extension() -> Extension:
    return Extension(
        name="flipflop",
        config_module_name="flipflop.config",
        # use this file as the config file - the Flip namedtuple
        config_file=__file__,
        cache_dir=os.path.expanduser("~/.cache/flipflop"),
        data_dir=os.path.join(os.environ["HPIDATA"], "flipflop"),
    )


def main() -> None:
    ext = extension()

    def compute_current_statuses() -> Dict[str, bool]:
        ext.cache_sorted_exports()
        return {f["what"]: f["on"] for f in ext.read_cache_json(model="flip")}

    # create CLI group so we can add additional commands
    cli_group = ext.wrap_cli(call=False)

    @cli_group.command(short_help="print current status")
    @click.option(
        "-f",
        "--filter-on",
        is_flag=True,
        default=False,
        help="only show items which are on",
    )
    @click.option(
        "-o",
        "--output",
        type=click.Choice(["table", "plain", "json"]),
        default="table",
        help="output format to print",
    )
    def status(output: str, filter_on: bool) -> None:
        statuses = compute_current_statuses()
        if filter_on:
            statuses = {k: v for k, v in statuses.items() if v}
        if output == "json":
            click.echo(json.dumps(statuses))
        elif output == "plain":
            if len(statuses) == 0:
                click.echo("No items are on.", err=True)
                exit(1)
            for k, v in statuses.items():
                print("{}\t{}".format(k, v))
        else:
            from tabulate import tabulate

            if len(statuses) == 0:
                click.echo("No items are on.", err=True)
                return

            click.echo(
                tabulate(
                    list(statuses.items()),
                    headers=["What", "On"],
                    tablefmt="presto",
                )
            )

    @cli_group.command(short_help="flip status on an item", name="flip")
    def _flip() -> None:
        from autotui.namedtuple_prompt import namedtuple_prompt_funcs
        from autotui.shortcuts import load_prompt_and_writeback
        from autotui.exceptions import AutoTUIException

        statuses = compute_current_statuses()

        try:
            # prompt for 'what'
            what = namedtuple_prompt_funcs(Flip)["what"]()
        except AutoTUIException:
            click.secho("Did not select anything", err=True, fg="red")
            exit(1)

        # flip the 'on' value and write back
        load_prompt_and_writeback(
            Flip,
            ext.datafile("flip"),
            attr_use_values={
                "when": datetime.now,
                "what": what,
                "on": not statuses.get(what.name, False),
            },
        )

    cli_group(prog_name="flipflop.py")


if __name__ == "__main__":
    main()
