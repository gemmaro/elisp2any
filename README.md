# Elisp2any

## Installation

Install the gem and add to the application's `Gemfile` by executing `bundle add elisp2any`.
If Bundler is not being used to manage dependencies, install the gem by executing `gem install elisp2any`.

## Usage

Currently the command line tool only supports HTML rendering.

```shell
$ elisp2any --input /path/to/input/file --output /path/to/output/file
```

## Development

To run tests, run `test-unit`.

Two paragraph types:

```emacs-lisp
;; This is a major one.

;; This is another major one (1), and a minor one.
;;
;; This is still (1) but another minor one.
```

Heading levels:

```emacs-lisp
;;; Level 2
;;;; Level 3
```

## Contributing

Bug reports and pull requests are welcome.

## License

Copyright (C) 2025  gemmaro

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
