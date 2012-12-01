# IcoHolder

## What does it?
**Windows only**: It lets you embed multiple ICO files into a single DLL file. <br />
That is useful when you want to assign many custom icons to folders under Windows. The many files really slow down the loading process, so embedding all these into one file could increase the performance.

## How to use

### Preparation (do this once)
1. Setup PowerShell Execution Policy
 
    1. Start PowerShell with administrator privileges. You can use Windows File Explorer: *File (menu) --> Open Windows PowerShell --> [...] as an administrator* under Windows 8.

    2. Type and run this command: `Set-ExecutionPolicy Unrestricted`.

### Regular usage
1. Place your ICO files in the *icons* directory. The script will fail if you do not place **any files** in this directory!
2. Right-click on *build.ps1* and select *Run with PowerShell*.
3. A file called *IcoHolder.dll* has been created which can be used in the options of a folder for setting its icon.


## Author & License
© 2012 [@ComFreek](http://www.twitter.com/ComFreek) and possibly other contributors.<br />
All files except these contained in 'MinGW' are licensed under the MIT license.