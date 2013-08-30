# Add item to OSX dock
define dockutil::item (
  $ensure,
  $item,
  $position = 'unset',
) {
  validate_re($ensure, '^(present|absent)$',
    "${ensure} is not supported for ensure.
    Allowed values are 'present' and 'absent'."
  )

  include ::dockutil
  include ::dockutil::reload

  Class['Dockutil'] ->
    Dockutil::Item[$name] ~>
    Class['Dockutil::Reload']

  case $ensure {
    'present': {
      $run = $position ? {
        'unset' => "${boxen::config::cachedir}/dockutil/scripts/dockutil --add \"${item}\" --label \"${name}\" --no-restart",
        default => "${boxen::config::cachedir}/dockutil/scripts/dockutil --add \"${item}\" --label \"${name}\" --position ${position} --no-restart",
      }
      exec {"dockutil-add-${name}":
        command => $run,
        onlyif  => "${boxen::config::cachedir}/dockutil/scripts/dockutil --find \"${name}\" | grep -qx \"${name} was not found in /Users/${::luser}/Library/Preferences/com.apple.dock.plist\"";
      }
    }

    'absent':{
      exec {"dockutil-remove-${name}":
        command => "${boxen::config::cachedir}/dockutil/scripts/dockutil --remove \"${name}\" --no-restart",
        onlyif  => "${boxen::config::cachedir}/dockutil/scripts/dockutil --find \"${name}\" | grep -q \"${name} was found\"";
      }
    }
  }
}
