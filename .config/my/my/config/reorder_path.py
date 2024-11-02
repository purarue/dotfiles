import sys

from .common import repo

##################
#                #
#  REORDER PATH  #
#                #
##################

# This section of my config is pretty personal, it deals with how
# I resolve imports for my multiple local HPI repositories
# You can do the same, but take a look at reorder_editable to
# make sure you're actually using this:
# https://github.com/purarue/reorder_editable


def purarue_reorder_path():
    try:
        # https://github.com/purarue/reorder_editable
        # if my easy-install.pth file was ordered wrong, fix it and exit!
        from reorder_editable.core import Editable, ReorderEditableError
    except Exception as ex:
        print(str(ex))
    else:
        try:
            if Editable().reorder(
                [repo("HPI-personal"), repo("HPI"), repo("HPI-karlicoss")]
            ):
                # this is true if we actually reordered the path
                # else path was already ordered
                print(
                    "easy-install.pth was ordered wrong! It has been reordered, "
                    "exiting to apply changes...",
                    file=sys.stderr,
                )
                sys.exit(0)
        except ReorderEditableError as re:
            if "Provided one or more value" in str(re):
                print(str(re), file=sys.stderr)
            else:
                raise re
