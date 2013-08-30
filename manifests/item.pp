# Add item to OSX dock
define dockutil::item (
  $ensure,
  $item,
  $label,
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
        'unset' => "${boxen::config::cachedir}/dockutil/scripts/dockutil --add \"${item}\" --label \"${label}\" --no-restart",
        default => "${boxen::config::cachedir}/dockutil/scripts/dockutil --add \"${item}\" --label \"${label}\" --position ${position} --no-restart",
      }
      exec {"dockutil-add-${label}":
        command => $run,
        onlyif  => "${boxen::config::cachedir}/dockutil/scripts/dockutil --find \"${label}\" | grep -qx \"${label} was not found in /Users/${::luser}/Library/Preferences/com.apple.dock.plist\"";
      }
    }

    'absent':{
      exec {"dockutil-remove-${label}":
        command => "${boxen::config::cachedir}/dockutil/scripts/dockutil --remove \"${label}\" --no-restart",
        onlyif  => "${boxen::config::cachedir}/dockutil/scripts/dockutil --find \"${label}\" | grep -q \"${label} was found\"";
      }
    }
  }
}
