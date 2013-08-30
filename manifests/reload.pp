# Reloads the OSX dock after modifications
class dockutil::reload {
  exec { 'Reload cfprefsd':
    command     => '/usr/bin/killall -HUP cfprefsd',
    refreshonly => true;
  } ->

  exec { 'Reload OSX dock':
    command     => '/usr/bin/killall -HUP Dock',
    refreshonly => true,
  }
}
