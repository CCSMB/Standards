# *CCSMB 10:* Specifying where programs and libraries are installed and where user data is stored

*Author: @Rainb0wSkeppy*  
*Version: vX.Y.Z*  
*Last updated: YYYY-MM-DD*  

## `settings` API settings
Compliant installers MUST install programs into the directory specified through the `path.programs` setting and MUST install libraries into the directory specified through the `path.libraries` setting.
The installers SHOULD NOT run if the settings aren't set.  
If the program or library is multiple files, the files MUST be installed in a subdirectory.

Compliant programs MUST store user data into the directory specified through the `path.data` setting.
The programs SHOULD NOT run if the setting isn't set.
If the user data is stored in multiple files, the files MUST be stored in a subdirectory.
