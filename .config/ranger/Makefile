BOOKMARKS_FILE:=~/.local/share/ranger/bookmarks

all: hidden_filter.rc preview.rc $(BOOKMARKS_FILE)
$(BOOKMARKS_FILE): ./dir-aliases ~/.config/directories
	./dir-aliases
preview.rc: ./generate_image_preview
	./generate_image_preview
hidden_filter.rc: ./hidden_template.rc
	./generate_filter
clean:
	rm -f ./hidden_filter.rc ./preview.rc $(BOOKMARKS_FILE)
