@echo off
goto doStart

%~I         - expands %I removing any surrounding quotes (")
%~fI        - expands %I to a fully qualified path name
%~dI        - expands %I to a drive letter only
%~pI        - expands %I to a path only
%~nI        - expands %I to a file name only
%~xI        - expands %I to a file extension only
%~sI        - expanded path contains short names only
%~aI        - expands %I to file attributes of file
%~tI        - expands %I to date/time of file
%~zI        - expands %I to size of file
%~$PATH:I   - searches the directories listed in the PATH
               environment variable and expands %I to the
               fully qualified name of the first one found.
               If the environment variable name is not
               defined or the file is not found by the
               search, then this modifier expands to the
               empty string
               
The modifiers can be combined to get compound results:

%~dpI       - expands %I to a drive letter and path only
%~nxI       - expands %I to a file name and extension only
%~fsI       - expands %I to a full path name with short names only
%~dp$PATH:I - searches the directories listed in the PATH
               environment variable for %I and expands to the
               drive letter and path of the first one found.
%~ftzaI     - expands %I to a DIR like output line

In the above examples %I and PATH can be replaced by other valid values.
The %~ syntax is terminated by a valid FOR variable name. Picking upper
case variable names like %I makes it more readable and avoids confusion
with the modifiers, which are not case sensitive.


:doStart
SETLOCAL
if "%1"=="" (
    set startFolder=%CD%
) else (
    set startFolder=%~f1
)

set rootFolder=%startFolder%
if not exist %rootFolder%\.git\NUL (
:printUsage
    echo Open Engine solution in Microsoft Visual Studio
    echo Usage: %0 [engine-sense-fork repo]
    echo if [engine-sense-fork repo] is empty, the current directory is used.
    goto doExit
)

pushd %rootFolder%
if exist "src\qlikview.sln" (
    set SLN=src\qlikview.sln
) else if exist "prod\data\Engine\src\qlikview.sln" (
    set SLN=prod\data\Engine\src\qlikview.sln
)
start "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe" %SLN%
popd

:doExit
ENDLOCAL
exit /B
