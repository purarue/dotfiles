import os

from promnesia.common import Source
from promnesia.sources import reddit, twitter, auto, github, smscalls, takeout, browser

from promnesia_pura.sources import (
    facebook,
    ipython,
    commits,
    todotxt,
    mal,
    albums,
    discord,
    mpv,
    newsboat,
    old_forums,
    twitch,
    mail,
    trakt,
    ttt,
    zsh,
    bash,
    grouvee,
)

SOURCES = [
    browser,
    takeout,
    twitter,
    Source(
        auto.index,
        "~/Repos/",
        name="Repos",
        ignored=[
            "*/dss-cruzhacks/data/*.csv",
            "*/albums/*",
            "*fixture/*",
            "*/vcr_cassettes/*",
            "*/search_index.json",
            "*/yarn.lock",
            "*/package.json",
            "*[plus1]*",
            "*/package-lock.json",
            "*/promnesia-fork/tests/*",
        ],
    ),
    Source(
        auto.index,
        "~/Documents/Education",
        name="School",
        ignored=["*Canvas*"],
    ),
    mal,
    grouvee,
    Source(auto.index, "~/GoogleDrive/", name="GoogleDrive"),
    bash,
    twitch,
    Source(discord, render_markdown=True),
    Source(reddit, render_markdown=True),
    Source(github, render_markdown=True),
    ipython,
    todotxt,
    albums,
    mail,
    commits,
    smscalls,
    facebook,
    newsboat,
    mpv,
    trakt,
    old_forums,
    ttt,
    zsh,
]

CACHE_DIR = os.path.join(os.environ["HOME"], ".cache", "promnesia")
