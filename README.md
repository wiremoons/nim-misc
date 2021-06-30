# GitHub Repository: `nim-misc`

## What is this repository for?

The repository contains miscellaneous programs and code written in the [Nim
programming language](https://nim-lang.org/) that don't belong elsewhere.

They are often just useful snippets of code, or small programs written to
complete a quick task, but have not been developed further, or turned into
a program that warrants its own separate repository.

Scripts include:

- [nim-build-install.sh](./nim-build-install.sh) : provides the ability to build 
Nim from official 'stable' source code archive. Useful if an install of the 
current Nim version is needed from source (ie non Intel arch). Used to build 
Nim 'stable' from the **Source archive** here: https://nim-lang.org/install_unix.html 
on a Raspberry Pi 4B - as package maintainers versions are often very out of date.

- [nim-install.sh](./nim-install.sh) : created to install Nim from official 
'stable' Linux x64 binary archive. This uses the pre-compiled Nim for Intel x64 bit archive 
from the **Pre-built binaries for Linux** archive here: https://nim-lang.org/install_unix.html
Useful if an install of the current Nim 'stable' version is needed.
Used to with *GitHub Actions* to build and test Nim source code when pushed in Nim code 
repositories.


## Licence

The source code stored here is provided under the MIT open source license. A 
copy of the MIT license file is [here](./LICENSE).

