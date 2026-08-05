# this creates self-contained HTML files which include journal entries
# and whisper-generated subtitles for any of my video logs
#
# https://github.com/purarue/markdown_stew

ROOT_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

# Output targets
NOTES_RENDERED_DIR := $(SHARED_DIR)/NotesRendered
JOURNAL_TARGET := $(NOTES_RENDERED_DIR)/journal.html
JOURNAL_IDEAS_TARGET := $(NOTES_RENDERED_DIR)/journal-ideas.html
GALLERY_TARGET := $(NOTES_RENDERED_DIR)/gallery.html
VLOGS_TARGET := $(NOTES_RENDERED_DIR)/vlogs.html
VLOG_TXT_FILES_DIR := $(XDG_CACHE_HOME)/vlog_txt_files

# compute source files
JOURNAL_FILES := $(shell find $(SHARED_DIR)/Notes/journal -name "*.md" | sort -r)
JOURNAL_IDEAS_FILES := $(shell find $(SHARED_DIR)/Notes/journal_ideas -name "*.md" | sort -r)
VLOGS_FILES := $(shell find $(HOME)/Files/Vlogs/ -name '*.srt' | sort -r)

all: $(JOURNAL_TARGET) $(VLOGS_TARGET) $(JOURNAL_IDEAS_TARGET) $(GALLERY_TARGET)

.PHONY: all clean

$(NOTES_RENDERED_DIR):
	mkdir -p $@

$(GALLERY_TARGET): $(HOME)/Files/gallery/gallery/ $(NOTES_RENDERED_DIR)
	find $(HOME)/Files/gallery/gallery -maxdepth 1 -mindepth 1 -type d \
		-printf '- <https://purarue.xyz/gl/%f>\n' \
		| pandoc -s | html-head | picofy --theme dark | sponge $@

$(JOURNAL_TARGET): $(JOURNAL_FILES) $(NOTES_RENDERED_DIR)
	markdown_stew -dark-mode -title Journal $(JOURNAL_FILES) > $@

$(JOURNAL_IDEAS_TARGET): $(JOURNAL_IDEAS_FILES) $(NOTES_RENDERED_DIR)
	markdown_stew -dark-mode -title 'Journal Ideas' $(JOURNAL_IDEAS_FILES) > $@

$(VLOGS_TARGET): $(VLOGS_FILES) $(NOTES_RENDERED_DIR)
	mkdir -p $(VLOG_TXT_FILES_DIR)
	$(foreach file,$(VLOGS_FILES),\
		bash "$(ROOT_DIR)cache-srt-to-text" "$(file)" \
			"$(VLOG_TXT_FILES_DIR)/$(notdir $(basename $(file))).txt";)\
	FILES=$$(find $(VLOG_TXT_FILES_DIR) -name "*.txt" | sort -r); \
		markdown_stew -dark-mode -title Vlogs $$FILES > $@

clean:
	rm -f $(JOURNAL_TARGET) $(VLOGS_TARGET) $(JOURNAL_IDEAS_TARGET) $(GALLERY_TARGET)
	rm -rf $(VLOG_TXT_FILES_DIR)
