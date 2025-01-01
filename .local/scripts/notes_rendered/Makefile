# this creates self-contained HTML files which include journal entries
# and whisper-generated subtitles for any of my video logs
#
# https://github.com/purarue/markdown_stew

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

JOURNAL_TARGET := $(shell echo "${XDG_DOCUMENTS_DIR}/NotesRendered/journal.html")
JOURNAL_FILES := $(shell find ${XDG_DOCUMENTS_DIR}/Notes/journal -name "*.md" | sort -r)

JOURNAL_IDEAS_TARGET := $(shell echo "${XDG_DOCUMENTS_DIR}/NotesRendered/journal-ideas.html")
JOURNAL_IDEAS_FILES := $(shell find ${XDG_DOCUMENTS_DIR}/Notes/journal_ideas -name "*.md" | sort -r)

VLOGS_TARGET := $(shell echo "${XDG_DOCUMENTS_DIR}/NotesRendered/vlogs.html")
VLOGS_FILES := $(shell find "${HOME}/Files/Vlogs/" -name '*.srt' | sort -r)

EVENTS := $(shell find "${HPIDATA}/ttally" -name 'event-*' | sort -r)
EVENTS_TARGET_SCORE := $(shell echo "${XDG_DOCUMENTS_DIR}/NotesRendered/events-score.html")
EVENTS_TARGET_DATE := $(shell echo "${XDG_DOCUMENTS_DIR}/NotesRendered/events.html")
EVENTS_COMMENTS := $(shell echo "${XDG_DOCUMENTS_DIR}/NotesRendered/events-comments.html")
EVENTS_PLAYS := $(shell echo "${XDG_DOCUMENTS_DIR}/NotesRendered/events-plays.html")

VLOG_TXT_FILES_DIR := $(shell echo "${XDG_CACHE_HOME}/vlog_txt_files")

all: $(JOURNAL_TARGET) $(VLOGS_TARGET) $(EVENTS_TARGET_SCORE) $(EVENTS_TARGET_DATE) $(JOURNAL_IDEAS_TARGET) $(EVENTS_COMMENTS) $(EVENTS_PLAYS)

$(JOURNAL_TARGET): $(JOURNAL_FILES)
	markdown_stew -dark-mode -title Journal $(JOURNAL_FILES) > $(JOURNAL_TARGET)

$(JOURNAL_IDEAS_TARGET): $(JOURNAL_IDEAS_FILES)
	markdown_stew -dark-mode -title 'Journal Ideas' $(JOURNAL_IDEAS_FILES) > $(JOURNAL_IDEAS_TARGET)

$(VLOGS_TARGET): $(VLOGS_FILES)
	mkdir -p $(VLOG_TXT_FILES_DIR)
	$(foreach file, $(VLOGS_FILES), bash "${ROOT_DIR}/cache-srt-to-text" $(file) $(VLOG_TXT_FILES_DIR)/$(shell basename $(file) .srt).txt;)
	FILES=$$(find $(VLOG_TXT_FILES_DIR) -name "*.txt" | sort -r); \
		markdown_stew -dark-mode -title Vlogs $$FILES > $(VLOGS_TARGET)

$(EVENTS_TARGET_SCORE): $(EVENTS)
	events-generate --sort-by score | pandoc | html-head --add css-pre-wrap | picofy > $(EVENTS_TARGET_SCORE)

$(EVENTS_TARGET_DATE): $(EVENTS)
	events-generate | pandoc | html-head --add css-pre-wrap | picofy > $(EVENTS_TARGET_DATE)

$(EVENTS_COMMENTS): $(EVENTS)
	events-generate --include-comments | pandoc | html-head --add css-pre-wrap | picofy > $(EVENTS_COMMENTS)

$(EVENTS_PLAYS): $(EVENTS)
	events-generate --filter-type play --include-comments | pandoc | html-head --add css-pre-wrap | picofy > $(EVENTS_PLAYS)

clean:
	rm -f $(JOURNAL_TARGET) $(VLOGS_TARGET) $(EVENTS_TARGET) $(EVENTS_TARGET_SCORE) $(JOURNAL_IDEAS_TARGET) $(EVENTS_COMMENTS) $(EVENTS_PLAYS)
	rm -rf $(VLOG_TXT_FILES_DIR)

.PHONY: all clean
