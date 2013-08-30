# Add item to OSX dock
define dockutil::item (
  $item,
  $label,
  $action = 'add',
  $position = 'unset',
) {
  validate_re($action, '^(add|remove)$',
  "${action} is not supported for action.
  Allowed values are 'add' and 'remove'.")

  include ::dockutil
  include ::dockutil::reload

  Class['Dockutil'] ->
    Dockutil::Item[$name] ~>
    Class['Dockutil::Reload']

  case $action {
    'add':{
      $run = $position ? {
        'unset' => "${boxen::config::cachedir}/dockutil/scripts/dockutil --${action} \"${item}\" --label \"${label}\" --no-restart",
        default => "${boxen::config::cachedir}/dockutil/scripts/dockutil --${action} \"${item}\" --label \"${label}\" --position ${position} --no-restart",
      }
      exec {"dockutil-${action}-${label}-add":
        command => $run,
        onlyif  => "${boxen::config::cachedir}/dockutil/scripts/dockutil --find \"${label}\" | grep -qx \"${label} was not found in /Users/${::luser}/Library/Preferences/com.apple.dock.plist\"";
      }
    }

    'remove':{
      exec {"dockutil-${label}-${item}":
        command => "${boxen::config::cachedir}/dockutil/scripts/dockutil --remove \"${label}\" --no-restart",
        onlyif  => "${boxen::config::cachedir}/dockutil/scripts/dockutil --find \"${label}\" | grep -q \"${label} was found\"";
      }
    }
  }
}
