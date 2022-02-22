"""
Config file for https://github.com/seanbreckenridge/my_feed
"""

from .feed_secret import broken_tags  # noqa

ignore_mpv_prefixes: set[str] = {
    "/home/sean/Repos/",
    "/home/sean/Downloads",
}

allow_mpv_prefixes: set[str] = {
    "/home/sean/Music/",
    "/home/data/media/music/",
    "/home/sean/Downloads/Sort/",
    "/Users/sean/Music",
}
