# source file: dbgUtils.nim

##[
Module Template: **dbgUtils.nim**
=============================

Description
-----------
 
A Nim template used to output debug messages from the running program. 
It will not be used when a program is compiled as a '*release*' version, 
allowing automatic disabling of debug output for final application builds.

Any debug messages are directed to `stderr` when output. This allows 
the debug message to be easily re-directed from beng output to screen, and 
collected to a debug text file, when the program is run in debug mode.

.. code-block:: bash
   ./myProg --parm 123 2> ./debug_out.txt


Usage
-----
 
Place this file in the projects src code directory (normally ``src/`` for 
a Nimble project). Use it from any of the other projects source code files 
by adding it as a ``module`` as shown below, noting the file extension 
of `.nim` is **not included** for the import:

.. code-block:: nim
   import dbgUtils
 
To print out a debug message add the following as a new line of code to the 
source code file that is using the ``import dbgUtils``
 
.. code-block:: nim
   debug "a new debug message!"
 
When compiled and run, the debug output message from the example code above 
would display as:
 
.. code-block:: nim
   DEBUG in dbgUtils.nim:39 "a new debug message!".
 
The debug message will only be output with '*debug*' builds and will be
excluded from '*release*' builds. The source code file the debug message 
originates from (shown as ``dbgUtils.nim`` in above example) is also displayed. 
The line number of the debug message will also be provided (shown as ``39`` 
in the above example).
 
Other Usage Examples
--------------------
 
.. code-block:: nim
   let myString = "Test string 123"
   debug "string variable is: " & myString
   # DEBUG in dbgUtils.nim:12 "string variable is: Test string 123".`
 

License
-------
MIT License
Copyright (c) 2020 Simon Rowe
https://github.com/wiremoons/
]##

template debug*(data: untyped) =
  ##[
  **PROCEDURE:** debug
   
  **Input:** any debug message to include with a programs output
  
  **Returns:** nothing
  
  **Description:** a Nim template used to output debug messages
  from the program. Is not used when a program is compiled
  as a '*release*' version - allowing automatic disabling of
  debug output for final application builds. Output includes
  any message passed to the template, along with the source code
  To use, add this file '*dbgUtils.nim*' to a project, and then
  file name and line number the debug message originates from. 
  import it into any Nim source code where a debug message is
  required. ]##
  when not defined(release):
    let pos = instantiationInfo()
    write(stderr, "DEBUG in " & pos.filename & ":" & $pos.line &
        " \"" & data & "\".\n")

# Allow module to be run standalone for tests: `nim c -r dbgUtils.nim`
when isMainModule:
  echo "Module 'dbgUtils.nim' test outputs:"
  debug "This is a test debug message"
  let myString = "Test string 123"
  debug "string variable is: '" & myString & "'"
  echo "DONE."
