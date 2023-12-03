# *CCSMB 10:* Program and library install directories 

*Author: @Rainb0wSkeppy*  
*Version: vX.Y.Z*  
*Last updated: YYYY-MM-DD*  

## `settings` API settings
Compliant installers MUST install programs into the directory specified through the `path.programs` setting and MUST install libraries into the directory specified through the `path.libraries` setting.  
Compliant programs MUST store user data into the directory specified through the `path.data` setting.

If the program, library or user data is multiple files, the files MUST be put in a subdirectory.
