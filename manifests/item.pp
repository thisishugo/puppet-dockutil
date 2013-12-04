# Add item to OSX dock
define dockutil::item (
  $ensure,
  $item,
  $folder_display = undef,
  $folder_view = undef,
  $folder_sort = undef,
  $pos_before = undef,
  $pos_after = undef,
  $pos_value = undef,
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

  if ($pos_before != undef) {
    Dockutil::Item[$pos_before] -> Dockutil::Item[$name]
  }

  if ($pos_after != undef) {
    Dockutil::Item[$pos_after] -> Dockutil::Item[$name]
  }

  case $ensure {
    'present': {
     $display = $folder_display? {
        undef   => '',
        default => "--display '${folder_display}'",
      } 

      $view = $folder_view? {
        undef   => '',
        default => "--view '${folder_view}'",
      }

      $sort = $folder_sort ? {
        undef   => '',
        default => "--sort '${folder_sort}'"
      }

      $before = $pos_before ? {
        undef   => '',
        default => "--before '${pos_before}'",
      }
      
      $after = $pos_after ? {
        undef   => '',
        default => "--after '${pos_after}'",
      }

      $position = $pos_value ? {
        undef   => '',
        default => "--position '${pos_value}'",
      }

      exec { "dockutil-add-${name}":
        command => "${boxen::config::cachedir}/dockutil/scripts/dockutil --add '${item}' --label '${name}' ${position} ${after} ${before} ${view} ${display} ${sort}  --no-restart",
        onlyif  => "${boxen::config::cachedir}/dockutil/scripts/dockutil --find '${name}' | grep -qx '${name} was not found in /Users/${::luser}/Library/Preferences/com.apple.dock.plist'";
      }
    }

    'absent':{
      exec { "dockutil-remove-${name}":
        command => "${boxen::config::cachedir}/dockutil/scripts/dockutil --remove '${name}' --no-restart",
        onlyif  => "${boxen::config::cachedir}/dockutil/scripts/dockutil --find '${name}' | grep -q '${name} was found'";
      }
    }
  }
}
