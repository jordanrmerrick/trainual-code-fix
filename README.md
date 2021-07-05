# Trainual Code Fix

This is a very simple parser that will scan a file and replace all instances of ` with <.code style="font-size:14px;".> and <./code.>.
Doing it line by line in trainual is an arduous task and annoying, so this is an easy fix.

### Possible Changes
 - Currently the stack variable is local to each line, so there is a potential issue if the code styling is multi-line. 
    This can be fixed by changing the variable's scope to the page (string array list).

    