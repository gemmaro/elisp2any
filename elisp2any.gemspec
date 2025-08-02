# Copyright (C) 2025  gemmaro
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require_relative 'lib/elisp/version'

Gem::Specification.new do |spec|
  spec.name = name = 'elisp2any'
  spec.version = Elisp::VERSION
  spec.authors = ['gemmaro']
  spec.email = ['gemmaro.dev@gmail.com']

  spec.summary = 'Converter from Emacs Lisp to some document markup'
  spec.description = 'elisp2any is a command line tool and library for converting Emacs Lisp source to some document markup, such as HTML.'
  spec.license = "GPL-3.0-or-later"
  spec.required_ruby_version = '>= 3.1'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }

  spec.require_paths = ['lib']

  spec.homepage = homepage = "https://codeberg.org/gemmaro/elisp2any"
  spec.metadata = {
    'rubygems_mfa_required' => 'true',
    'bug_tracker_uri'       => "#{homepage}/issues",
    'changelog_uri'         => "#{homepage}/src/branch/main/CHANGELOG.md",
    'documentation_uri'     => "https://www.rubydoc.info/gems/#{name}",
    'homepage_uri'          => homepage,
    'source_code_uri'       => homepage,
    'wiki_uri'              => "#{homepage}/wiki",
  }

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'test-unit', '~> 3.0'
end
