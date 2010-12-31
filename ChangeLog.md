### 1.0.0 / 2011-02-01

* Require open_namespace ~> 0.3.0.
* Require data_paths ~> 0.2.1.
* Require thor ~> 0.14.3.
* Require ronin-support ~> 0.1.0.
* Require ronin ~> 1.0.0.
* Require bundler ~> 1.0.0.
* Require yard ~> 0.6.4.
* Require rspec ~> 2.0.0.
* Switched from [Jeweler](https://github.com/technicalpickles/jeweler)
  to [Ore](http://github.com/ruby-ore/ore) and [Bundler](http://gembundler.com).
* {Ronin::Gen::FileGenerator} now spawns the default text-editor after
  completion.
* Renamed `Ronin::Gen::Generators::Overlay` to
  {Ronin::Gen::Generators::Repository}.
* Changed {Ronin::Gen::Generators::Library} to generate libraries managed
  by Ore and Bundler.
* {Ronin::Gen::Generators::Library} now initializes the new library as a
  Git repository.

### 0.2.0 / 2009-09-24

* Require ronin >= 0.3.0.
* Require rspec >= 1.2.8.
* Require yard >= 0.2.3.5.
* Updated the project summary and 3-point description of Ronin Gen.
* Moved to YARD based documentation.
* Refactored `Ronin::Generators::Generator` to inherit from Thor.
* Refactored `Ronin::Generators::DirGenerator`.
* Refactored `Ronin::Generators::Platform::Extension`.
* Refactored `Ronin::Generators::Platform::Overlay`.
* Rewrote the `Ronin::UI::CommandLine` generator commands to simply inherit
  from the new Thor based generator classes within Ronin::Generators.

### 0.1.1 / 2009-07-02

* Use hoe >= 2.0.0.
* Require ronin >= 0.2.4.
* Added `Ronin::Generators::Generator#touch`.
* Added `Ronin::UI::CommandLine::Commands::Gen` for listing and
  invoking generators.
* Added more defaults to `Ronin::Generators::Platform::Overlay`:
  * Default maintainer.
  * Default license.
  * Default description.
* Added the `--version` option to the `ronin-gen` command.
* Removed the `--list` option from the `ronin-gen` command.
* Make sure `Ronin::Generators::Platform::Overlay` creates an
  empty lib/init.rb file.
* Fixed a bug in the `ronin-gen` command, where generator names
  were not being sanitized.

### 0.1.0 / 2009-03-27

* Initial release.
  * Provides the `Ronin::Generators::Platform::Overlay` generator.
  * Provides the `Ronin::Generators::Platform::Extension` generator.
  * Provides sub-commands for invoking the Overlay and Extension generator.
  * Provides the `ronin-gen` sub-command to invoke other generator
    sub-commands.

