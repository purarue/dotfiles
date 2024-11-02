from datetime import datetime
from typing import NamedTuple, Optional


class Weight(NamedTuple):
    when: datetime
    pounds: float


class Food(NamedTuple):
    when: datetime
    calories: int
    food: str
    quantity: float
    water: int  # how much ml of water was in this

    # specify a special way to prompt for quantity
    @staticmethod
    def attr_validators() -> dict:
        # https://purarue.xyz/d/ttally_types.py?redirect
        from my.config.pura.ttally_types import prompt_float_default  # type: ignore

        # if I don't supply a quantity, default to 1
        return {"quantity": lambda: prompt_float_default("quantity")}


class Event(NamedTuple):
    """e.g. a concert or something"""

    event_type: str
    when: datetime
    description: str
    score: Optional[int]
    comments: Optional[str]

    @staticmethod
    def attr_validators() -> dict:
        from my.config.pura.ttally_types import edit_in_vim  # type: ignore

        return {"comments": edit_in_vim}


import os
from enum import Enum

# dynamically create an enum using each line of the file as an option
with open(os.path.join(os.environ["HPIDATA"], ".self_types.txt")) as f:
    SelfT = Enum("SelfT", [s.rstrip().upper() for s in f])


class Self(NamedTuple):
    when: datetime
    what: SelfT  # type: ignore
