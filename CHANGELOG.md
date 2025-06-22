# Change log of Elisp2any

## 0.0.6 - 2025-06-22

Removed previous parsers and added simple strscan base parser.

## 0.0.5 - 2025-02-10

* Upgrade required Ruby version to 3.1 or later.
* Add `--new` flag to the `elisp2any` command.  It uses new scanner (parser)
  written in pure Ruby with strscan gem.  The older ones which uses
  Tree-sitter as parser is deprecated and will be removed from the next
  version.

## 0.0.4 - 2025-02-08

* Improved shared object searching for Guix.

## 0.0.3 - 2024-11-16

### Added

* The `--css=PATH` option to the `elisp2any` program.

## 0.0.2 - 2023-11-25

### Fixed

* HTML renderer: commentary heading level
* tests: renderer file requirings

## 0.0.1 - 2023-10-27

- Initial release
