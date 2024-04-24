# Conway's game of life

This is a basic implementation of Conway's game of life in common lisp.  I wrote this while learning common lisp because I wanted a tiny project I could use to check out the ncurses bindings available in cl.  Thus, this little program uses cl-charms to output to the terminal.

There are a ton of interesting structures available for game of life.  While looking around I found [this glossary](http://www.radicaleye.com/lifepage/glossary.html).  I removed anything which isn't actually a pattern and saved the rest in the file `patterns`.  This program treats the glossary as data and we can instantiate any patterns in that list.

### Dennis may need to load the asdf first I guess but seems still not working

see https://stackoverflow.com/questions/65301060/how-do-i-compile-and-run-a-common-lisp-program-from-the-directory-of-the-asd-fi
and https://www.reddit.com/r/Common_Lisp/comments/lx6al4/loading_an_asdf_system_from_current_directory/

```
# better cursor handling using rlwrap
# brew install rlwrap 
$ curl -O https://beta.quicklisp.org/quicklisp.lisp

$ rlwrap sbcl
; - seems no need of quicklisp- but if ...
* (load "~/quicklisp/setup.lisp")
or
* (quicklisp-quickstart:install)
* (ql:add-to-init-file)
; * (ql:quickload "game-of-life")
; * (ql:system-apropos "term")

; - can just use asdf or has been installed - 
* (require "asdf")
* (asdf:load-asd (merge-pathnames "game-of-life.asd" (uiop:getcwd)))
* (asdf:load-system :game-of-life)
; still error

* (load "game-of-life" )

``` lisp

## Usage

Dennis: none of this work ... not sure why ...
; may need curses but based on this cl-charms should have installed cl-ncurses
; macos need ncurses but seems brew install ncurses is ok
; see https://gist.github.com/cnruby/960344
; see https://stackoverflow.com/questions/28888833/cl-ncurses-on-sbcl

* (ql:quickload :cl-ncurses)
* (in-package :cl-ncurses)
* (initscr)

; try cl-charms still the same issue and even worst with broken screen (terminate terminal needed)

; see https://github.com/40ants/lisp-project-of-the-day/issues/2
; see https://stackoverflow.com/questions/22213133/cffi-not-loading-dependent-libraries
; but no help



`; rlwrap sbcl --load "game-of-life.lisp" all 30`

`sbcl --load game-of-life.lisp <name-of-pattern> <simulation duration in seconds>`

Any spaces in the name of the pattern has to be replaced with a `-`.  The default duration for the simulation is 20s.

`sbcl --load game-of-life.lisp cis-boat-with-tail 30` will display the cis-boat with tail pattern for 30s.

By replacing the pattern name with the secret keyword `all` a loop is started which loops through all the available patterns.

### Dependencies

* SBCL
* [Quicklisp](www.quicklisp.org)

# nothing work under macos ARM ... need to try Intel later ...

# I suspect the p meant period

see https://web.archive.org/web/20160401062315/http://www.argentum.freeserve.co.uk/lex.htm

try `wget -p -k -r --no-parent https://web.archive.org/web/20160401062315/http://www.argentum.freeserve.co.uk/lex.htm`

