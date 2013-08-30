# Pull the dockutil repo down to cache
class dockutil {
  repository { 'dockutil':
    source => 'kcrawford/dockutil',
    path   => "${boxen::config::cachedir}/dockutil",
  }
}
