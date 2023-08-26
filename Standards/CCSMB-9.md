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
Compliant programs MUST allow disabling autoupdating through the `autoupdating.disableAutoupdating` setting. If the option is set to `true`, autoupdating must be disabled.

Programs running on operating systems which remove the `settings` API MAY be considered compliant if they choose not to implement the `autoupdating.disableAutoupdating` setting.

### Global variable

Compliant programs MUST allow disabling autoupdating through the `DISABLE_AUTOUPDATING` global variable. If the global is set to `true`, autoupdating must be disabled.

## Dependency installation specification
Programs implementing autoinstallation of dependencies MAY support the following options for disabling that function.

Programs which are specifically designed to install dependencies, namely installers and package managers, SHOULD NOT implement the following.

Programs implementing autoinstallation of dependencies MUST implement all options listed below in order to be considered compliant.

### `settings` API setting
Compliant programs MUST allow disabling autoupdating through the `dependencies.disableAutomaticDependencyInstallation` setting. If the option is set to `true`, autoinstallation of dependencies must be disabled.

Programs running on operating systems which remove the `settings` API MAY be considered compliant if they choose not to implement the `autoupdating.disableAutoupdating` setting.

### Global variable

Compliant programs MUST allow disabling autoinstallation of dependencies through the `DISABLE_DEPENDENCY_INSTALLATION` global variable. If the global is set to `true`, autoupdating must be disabled.
