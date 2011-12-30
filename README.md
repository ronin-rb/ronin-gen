# Ronin Gen

* [Source](http://github.com/ronin-ruby/ronin-gen)
* [Issues](http://github.com/ronin-ruby/ronin-gen/issues)
* [Documentation](http://rubydoc.info/github/ronin-ruby/ronin-gen/frames)
* [Mailing List](http://groups.google.com/group/ronin-ruby)
* [irc.freenode.net #ronin](http://webchat.freenode.net/?channels=ronin&uio=Mj10cnVldd)

## Description

Ronin Gen is a Ruby library for Ronin that provides various generators.

Ronin is a Ruby platform for exploit development and security research.
Ronin allows for the rapid development and distribution of code, exploits
or payloads over many common Source-Code-Management (SCM) systems.

## Features

* Provides {Ronin::Gen::FileGenerator}
* Provides {Ronin::Gen::DirGenerator}
* Provides {Ronin::Gen::SourceCodeGenerator}
* Provides {Ronin::Gen::RubyGenerator}
* Generators for creating new Ronin Repositories and Libraries.

## Synopsis

Generate a skeleton Ronin library:

    $ ronin-gen library PATH [options]

Generate a skeleton Overlay:

    $ ronin-gen repository PATH [options]

## Requirements

* [open_namespace](http://github.com/postmodern/open_namespace#readme)
  ~> 0.3
* [data_paths](http://github.com/postmodern/data_paths#readme)
  ~> 0.3
* [parameters](http://github.com/postmodern/parameters#readme)
  ~> 0.4
* [ronin-support](http://github.com/ronin-ruby/ronin-support#readme)
  ~> 0.3
* [ronin](http://github.com/ronin-ruby/ronin#readme)
  ~> 1.4

## Install

### Stable

    $ gem install ronin-gen

### Edge

    $ git clone git://github.com/ronin-ruby/ronin-gen.git
    $ cd ronin-gen/
    $ bundle install
    $ ./bin/ronin-gen --help

## License

Copyright (c) 2009-2011 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of Ronin Gen.

Ronin Gen is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin Gen is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ronin Gen.  If not, see <http://www.gnu.org/licenses/>.
