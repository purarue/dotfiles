"""
Config file for https://github.com/purarue/my_feed
"""

from .feed_secret import broken_tags, ignore_mpv_prefixes, allow_mpv_prefixes
from .pura.feed_transform_secret import TRANSFORMS

from typing import Iterator, Callable, TYPE_CHECKING

if TYPE_CHECKING:
    from my_feed.sources.model import FeedItem


def sources() -> Iterator[Callable[[], Iterator["FeedItem"]]]:
    from my_feed.sources import games
    from my_feed.transform import transform

    yield games.steam
    yield games.osrs
    yield games.game_center
    yield games.grouvee
    yield games.chess

    from my_feed.sources import (
        trakt,
        # listens,
        nextalbums,
        mal,
        # mpv,
        # offline_listens,
        # facebook_spotify_listens,
    )

    # yield offline_listens.history
    yield transform(trakt.history)
    yield nextalbums.history
    yield mal.history
    yield mal.deleted_history
    # yield transform(listens.history)
    # yield transform(mpv.history)
    # yield transform(facebook_spotify_listens.history)


__all__ = [
    "sources",
    "broken_tags",
    "TRANSFORMS",
    "ignore_mpv_prefixes",
    "allow_mpv_prefixes",
    "FeedItem",
]
