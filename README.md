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

This package is provided under the Apache License.
See `LICENSE.txt` for details.
