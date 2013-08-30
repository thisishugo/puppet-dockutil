# Puppet-Dockutil Module for Boxen

This module allows you to mange your dock using Kyle Crawford's awesome [dockutil](https://github.com/kcrawford/dockutil).

## Usage

```puppet
  # Create Activity Monitor at the beginning
  dockutil::item { 'Activity Monitor':
    ensure    => present,
    item      => '/Applications/Utilities/Activity Monitor.app',
    pos_value => 'beginning';
  }

  # Create iTunes at the end
  dockutil::item { 'iTunes':
    ensure    => present,
    item      => '/Applications/iTunes.app',
    pos_value => 'end';
  }

  # Create iTerm at the 4th position
  dockutil::item { 'iTerm':
    ensure    => present,
    item      => "/Applications/iTerm.app",
    pos_value => 4,
  }

  # Create Calendar before iTunes
  dockutil::item { 'Calendar':
    ensure     => present,
    item       => '/Applications/Calendar.app',
    pos_before => 'iTunes';
  }

  # Create Notes after Activity Monitor
  dockutil::item { 'Notes':
    ensure    => present,
    item      => '/Applications/Notes.app',
    pos_after => 'Activity Monitor';
  }
```

## Required Puppet Modules

* `boxen`
* `repository`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
