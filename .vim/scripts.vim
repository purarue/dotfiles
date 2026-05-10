" custom filetype detection for when using /usr/bin/env bash shebangs
if did_filetype()
  finish
endif

let s:firstline = getline(1)
if s:firstline =~ '^#!.*/bin/env\s\+node\>'
  setfiletype javascript
elseif s:firstline =~ '^#!.*/bin/env\s\+python\>'
  setfiletype python
elseif s:firstline =~ '^#!.*/bin/env\s\+bash\>'
  setfiletype bash
elseif s:firstline =~ '^#!.*/bin/env\s\+sh\>'
  setfiletype sh
endif
