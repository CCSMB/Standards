# CCSMB 9: Disabling Automatic Updating and Dependency Installation in Lua Programs

*Author: Tomodachi94 <@tomodachi94>*

## Rationale
This RFC allows users to programmatically disable autoupdating and dependency installation in programs.
Some users opt to use package managers when installing programs, which typically manage updates and dependencies on their own; additionally, some users would like to remain on a specific version for stability.

## Autoupdating specification
Programs implementing an autoupdater MAY support the following options for disabling that function.

Programs which are specifically designed to update programs, namely installers and package managers, SHOULD NOT implement the following.

Programs implementing an autoupdater MUST implement all options listed below in order to be considered compliant.

### `settings` API setting
Compliant programs MUST allow disabling autoupdating through the `ccsmb.autoupdate.enable` setting. If the option is set to `false`, autoupdating MUST be disabled. If the option is unset, compliant programs MAY choose to enable or disable autoupdating for itself.

Programs running on operating systems which remove the `settings` API MAY be considered compliant if they choose not to implement the `ccsmb.autoupdate.enable` setting. Such operating systems MAY implement equivalent functionality through other means appropriate for that system.

### Global variable

Compliant programs MUST allow disabling autoupdating through the `CCSMB_ENABLE_AUTOUPDATING` global variable. If the global is set to `false`, autoupdating MUST be disabled. If the variable is unset, compliant programs MAY choose to enable or disable autoupdating for itself.

## Dependency installation specification
Programs implementing autoinstallation of dependencies MAY support the following options for disabling that function.

Programs which are specifically designed to install dependencies, namely installers and package managers, SHOULD NOT implement the following.

Programs implementing autoinstallation of dependencies MUST implement all options listed below in order to be considered compliant.

### `settings` API setting
Compliant programs MUST allow disabling dependency installation through the `ccsmb.dependencyInstallation.enable` setting. If the option is set to `true`, autoinstallation of dependencies MUST be disabled. If the option is unset, compliant programs MAY choose to enable or disable dependency installation for itself.

Programs running on operating systems which remove the `settings` API MAY be considered compliant if they choose not to implement the `ccsmb.dependencyInstallation.enable` setting. Such operating systems MAY implement equivalent functionality through other means appropriate for that system.

### Global variable

Compliant programs MUST allow disabling autoinstallation of dependencies through the `CCSMB_ENABLE_DEPENDENCY_INSTALLATION` global variable. If the global is set to `false`, autoupdating MUST be disabled. If the option is unset, compliant programs MAY choose to enable or disable dependency installation for itself.
