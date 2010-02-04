# Ronin Gen

* http://ronin.rubyforge.org/gen/
* http://github.com/postmodern/ronin-gen
* http://github.com/postmodern/ronin-gen/issues
* http://groups.google.com/group/ronin-ruby
* irc.freenode.net #ronin

## DESCRIPTION:

Ronin Gen is a Ruby library for Ronin that provides various generators.

Ronin is a Ruby platform for exploit development and security research.
Ronin allows for the rapid development and distribution of code, exploits
or payloads over many common Source-Code-Management (SCM) systems.

### Ruby

Ronin's Ruby environment allows security researchers to leverage Ruby with
ease. The Ruby environment contains a multitude of convenience methods
for working with data in Ruby, a Ruby Object Database, a customized Ruby
Console and an extendable command-line interface.

### Extend

Ronin's more specialized features are provided by additional Ronin
libraries, which users can choose to install. These libraries can allow
one to write and run Exploits and Payloads, scan for PHP vulnerabilities,
perform Google Dorks  or run 3rd party scanners.

### Publish

Ronin allows users to publish and share code, exploits, payloads or other
data via Overlays. Overlays are directories of code and data that can be
hosted on any SVN, Hg, Git or Rsync server. Ronin makes it easy to create,
install or update Overlays.

## FEATURES:

* Provides {Ronin::Generators::Generator}, a Thor based generator class that
  can be used to create new generators.
* Provides {Ronin::Generators::DirGenerator}, a Thor based generator that
  can be used to create new directory generators.
* Generators for Overlays and Extensions.

## SYNOPSIS:

Generate a skeleton Overlay:

    $ ronin-gen overlay PATH [options]

Generate a skeleton Extension:

    $ ronin-gen extension PATH

## REQUIREMENTS:

* [ronin](http://ronin.rubyforge.org/) >= 0.3.0

## INSTALL:

    $ sudo gem install ronin-gen

## LICENSE:

Ronin Gen - A Ruby library for Ronin that provides various generators.

Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at gmail.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
