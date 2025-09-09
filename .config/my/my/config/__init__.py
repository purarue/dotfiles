"""
Configuration file for
https://github.com/karlicoss/HPI/
https://github.com/purarue/HPI/
https://github.com/purarue/HPI-personal
[Human Programming Interface]
"""

import tempfile
from os import environ, path
from typing import Optional, Callable, List, Sequence, Union, Tuple, Set
from pathlib import Path
from datetime import datetime, date, timedelta

from my.core.common import PathIsh, Paths

from .common import repo

#############
#           #
#  HELPERS  #
#           #
#############


def if_exists(p: PathIsh) -> Optional[Path]:
    pp = Path(p)
    if pp.exists():
        return pp
    return None


def filter_exists(pths: List[PathIsh]) -> List[Path]:
    res: List[Path] = []
    for p in pths:
        r = if_exists(p)
        if r is not None:
            res.append(r)
    return res


# if the HPIDATA environment variable is set (which points to my data)
# use that. Else, just default to ~/data
PREFIX: Path = Path(environ.get("HPIDATA", path.expanduser("~/data")))


def data(p: PathIsh) -> Path:
    """prepend my data directory onto this path"""
    return PREFIX / p


#############
#           #
#  MODULES  #
#           #
#############

DISABLED_MODULES = [
    "my.body",
    "my.polar",
    "my.rtm",
    "my.media",
    # ignore legacy google takeout modules
    r"my.google\.takeout.html",
    r"my.google\.takeout.paths",
    r"^my.location.google$",
    "my.orgmode",
    "my.jawbone",
    "my.twitter.twint",
    "my.stackexchange.gdpr",
    "my.twitter.talon",
    "my.vk",
    "my.rss.all",
    "my.rss.common",
    "my.rss.feedbin",
    "my.rss.feedly",
    "my.calendar",
    "my.taplog",
    "my.runnerup",
    "my.rescuetime",
    "my.mail.mbox",
    "my.pocket",
    "my.lastfm",
    "my.kobo",
    "my.hackernews*",
    "my.instapaper",
    "my.hypothesis",
    "my.foursquare",
    "my.fbmessenger",
    "my.endomondo",
    "my.arbtt",
    "my.emfit",
    "my.bluemaestro",
    "my.bumble",
    "my.tinder.android",
    "my.instagram",
    "my.hackernews",
    "my.zotero",  # temporarily? till I start using it
]


class core:
    cache_dir: PathIsh = path.expanduser("~/.cache/cachew")
    tmp_dir: PathIsh = environ.get(
        "HPI_TEMPDIR", path.join(tempfile.gettempdir(), "HPI-tempdir")
    )
    enabled_modules: Sequence[str] = []
    disabled_modules: Sequence[str] = tuple(DISABLED_MODULES)


###################
#                 #
#  MODULE CONFIG  #
#                 #
###################


class github:
    """
    combines:
    periodic exports from: https://github.com/karlicoss/ghexport
    github GDPR export
    """

    gdpr_dir: PathIsh = data("github/gdpr")
    export_path: Paths = data("github/ghexport")


# if you want to override this, you can set in your ~/.bashrc or something:
# export MAILDIR='~/Documents/mail'
# or glob something:
# MAILDIR='~/.local/share/mail/*@gmail.com'
MAILDIR = environ.get("MAILDIR", "~/.local/share/mail")


# this is all custom, and may not work for you -- this
# is how I filter certain Junk/Trash paths from my mail

FILTER_PARTS: Set[str] = {".notmuch", "Trash", "Spam", "Junk"}


def filter_mail_path(p: Path) -> bool:
    pset = set(p.parts[1:])
    if any(f in pset for f in FILTER_PARTS):
        return False
    return True


class mail:
    # locally synced IMAP mailboxes using mbsync
    class imap:
        # path[s]/glob to the mailboxes/IMAP files
        # you could also just do something like:
        # mailboxes = "~/Documents/mail/*@*"
        # to match any files in that directory with '@' in them
        #
        # to confirm this is matching your files, can do:
        # hpi query my.mail.imap.files -s
        mailboxes = MAILDIR

        # filter function which filters the input paths
        filter_path: Optional[Callable[[Path], bool]] = filter_mail_path

    class mbox:
        pass


# combines:
class reddit:
    class rexport:
        """periodic exports from: https://github.com/karlicoss/rexport/"""

        export_path: Paths = data("rexport")

    class pushshift:
        """
        comment export using
        https://github.com/purarue/pushshift_comment_export
        """

        export_path: Paths = data("pushshift")


# parses my zsh history and any backups
class zsh:
    export_path: Paths = (data("zsh_history"), data("zsh_history_old"))
    live_file: Optional[PathIsh] = if_exists(
        path.join(environ["ZDOTDIR"], ".zsh_history")
    )


# parses bash history
class bash:
    export_path: Paths = (data("bash_history"), data("bash"))


# parses current/done http://todotxt.org/
class todotxt:
    class git_history:
        export_path: Path = data("doc/todo_git_history")

    class active:
        export_path: Path = data("todo")


# parses the history of me adding/removing rss feeds
class rss:
    class newsboat:
        class git_history:
            export_path: Path = data("doc/newsboat_git")


# parses information from git repositories which match my emails
class commits:
    try:
        from .commits_secret import emails, names

        emails = emails
        names = names
    except ImportError:
        pass

    roots: Paths = filter_exists(
        [
            repo(""),
            path.expanduser("~/Files/OldRepos"),
            path.expanduser("~/.local/share/go/src/github.com/purarue/"),
        ]
    )


class mpv:
    class history_daemon:
        """https://github.com/purarue/mpv-history-daemon"""

        export_path: Paths = data("mpv")

        # amount of song I should have listened to to qualify it as a listen (e.g. 0.5, 0.75)
        require_percent = 0.5


live_dbs: List[Path] = []
try:
    from browserexport.browsers.firefox import Firefox

    live_dbs.append(Firefox.locate_database())
except Exception:
    pass


class browser:
    """
    uses browserexport https://github.com/purarue/browserexport
    """

    class export:
        export_path: Paths = data("browsing")

    class active_browser:
        export_path: Paths = tuple(live_dbs)


class league:
    class export:
        """https://github.com/purarue/lolexport"""

        export_path: Paths = data("league_of_legends/*.json.gz")
        username = "purplepinapples"


class chess:
    class export:
        """https://github.com/purarue/chess_export"""

        export_path: Paths = data("chess")


class listenbrainz:
    class export:
        """https://github.com/purarue/listenbrainz_export"""

        export_path: Paths = data("listenbrainz")


class trakt:
    class export:
        """https://github.com/purarue/traktexport"""

        export_path: Paths = data("trakt")


class mal:
    class export:
        """https://github.com/purarue/malexport"""

        export_path: PathIsh = data("malexport")
        zip_backup_path: PathIsh = data("malexport_backups")


class grouvee:
    class export:
        """https://github.com/purarue/grouvee_export"""

        export_path: Paths = data("grouvee")


class nextalbums:
    """
    uses my personal albums system
    https://github.com/purarue/albums
    """

    export_path: Paths = data("albums/*.json")


class steam:
    class scraper:
        """https://github.com/purarue/steamscraper"""

        export_path: Paths = data("steam/*.json")


class piazza:
    class scraper:
        """https://github.com/purarue/piazza-scraper"""

        export_path: Paths = data("piazza")


class blizzard:
    """https://github.com/purarue/blizzard_gdpr_parser"""

    class gdpr:
        export_path: Paths = data("gdpr/blizzard/parsed.json")


environ["OLD_FORUMS_SELECTORS"] = str(data("old_forum_selectors.json"))


class old_forums:
    """https://github.com/purarue/old_forums"""

    # path[s]/glob to the folder which contains JSON/HTML files
    export_path: Paths = data("old_forums")


class scramble:
    class history:
        config_dir = None  # use the default


class project_euler:
    export_path: Paths = data("project_euler")


class skype:
    class gdpr:
        export_path: Paths = data("skype.json")


class facebook:
    class gdpr:
        gdpr_dir: PathIsh = data("gdpr/facebook")


class spotify:
    class gdpr:
        gdpr_dir: PathIsh = data("gdpr/spotify")


class twitch:
    class overrustle:
        """
        my chat logs from the overrustle_logs dump
        https://github.com/purarue/overrustle_parser
        """

        export_path: Paths = data("twitch/overrustle_logs.json")

    class gdpr:
        """parses the privacy request"""

        gdpr_dir: PathIsh = data("twitch/gdpr")


class ipython:
    """parses backups of my ipython history"""

    export_path: Paths = (
        data("ipython_default/*.sqlite"),
        data("ipython_calculator/*.sqlite"),
    )


class google:
    """
    parses https://takeout.google.com using
    https://github.com/purarue/google_takeout_parser
    """

    takeout_path: Paths = data("google_takeout/*.zip")


class ttt:
    """https://github.com/purarue/ttt"""

    export_path: Paths = data("ttt/*.csv")


class activitywatch:
    """https://github.com/purarue/aw-watcher-window"""

    class active_window:
        export_path: Paths = (
            data("window_watcher/*.csv*"),
            data("aw-window/phone/*.json*"),
            data("aw-window/windows/*.json*"),
        )
        error_policy = "raise"


class smscalls:
    export_path: Paths = data("SMSBackups")


class apple:
    class privacy_export:
        gdpr_dir: PathIsh = data("gdpr/apple")


class linkedin:
    class privacy_export:
        gdpr_dir: PathIsh = data("gdpr/linkedin")


class discord:
    class data_export:
        """https://github.com/purarue/discord_data"""

        export_path: Paths = data("discord/*.zip")

        _use_zippath = False


class runelite:
    class screenshots:
        export_path: Paths = data("runelite_screenshots")


class minecraft:
    class advancements:
        export_path: Paths = data("minecraft_advancements")


class pdfs:
    paths: Paths = [
        "~/Files/Books/",
        "~/Documents/Notes/",
    ]


class zulip:
    class organization:
        export_path: Paths = data("gdpr/zulip/organization")


class twitter_archive:
    export_path: Paths = data("gdpr/twitter/archive.zip")


class stackexchange:
    export_path: Paths = data("stackexchange")
    # stexport: Optional[PathIsh] = repo("stexport")


class offline:
    class listens:
        export_path: Paths = data("offline_listens/*.yaml")


DateIsh = Union[datetime, date, str]
LatLon = Tuple[float, float]


class location:
    try:
        from .locations_secret import home

        home = home
    except ImportError:
        pass

    class where_db:
        accuracy_filter = 300
        new_point_distance = 60
        accurate_date_cutoff = date(2020, 10, 15)
        previous_accurate_for_days = 7
        new_point_duration = timedelta(minutes=30)
        database_location = "~/data/.where_db.json"

    class gpslogger:
        """.gpx files from https://github.com/mendhak/gpslogger"""

        export_path: Paths = data("gpslogger")

    class google_takeout_semantic:
        # a value between 0 and 100, 100 being the most confident
        # set to 0 to include all locations
        semantic_require_confidence: int = 40
        # default accuracy for semantic locations
        accuracy: float = 100.0

    class via_ip:
        accuracy: float = 15_000.0


class time:
    class tz:
        # force_abbreviations = ("PST", "PDT")
        force_abbreviations: List[str] = []
        policy = "convert"

        class via_location:
            fast: bool = True
            require_accuracy: float = 5000.0
