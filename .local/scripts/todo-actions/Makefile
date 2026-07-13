sync:
	mkdir -p ~/.local/share/todo-actions
	# find all items in this dir which are executable, and sync them to ~/.local/share/todo-actions
	find . -maxdepth 1 -type f -executable -exec cp -auv {} ~/.local/share/todo-actions \;
touch:
	find . -maxdepth 1 -type f -executable -exec touch {} \;
