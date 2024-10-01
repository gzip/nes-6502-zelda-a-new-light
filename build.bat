@ECHO OFF
SETLOCAL
SET SNARFBLASM=..\tools\snarfblasm
SET FLIPS=tools\flips
SET OUT_ROM=zelda.nes

IF NOT EXIST %OUT_ROM% (
  ECHO Expected to find the following ROM, exiting...
  ECHO %OUT_ROM% not found! (See build.bat to edit filename^)
  EXIT /B
)

WHERE /Q git
IF NOT ERRORLEVEL 1 (
  ECHO Checking out clean roms...
  git checkout %OUT_ROM%
)

cd src
%SNARFBLASM% columns.asm
%SNARFBLASM% replacements.asm
%SNARFBLASM% skeleton.asm
%SNARFBLASM% tree.asm
%SNARFBLASM% archway.asm
%SNARFBLASM% bombable.asm
%SNARFBLASM% hud.asm
%SNARFBLASM% scroll_timing.asm
cd ..
%FLIPS% src/columns.ips %OUT_ROM%
%FLIPS% src/skeleton.ips %OUT_ROM%
%FLIPS% src/replacements.ips %OUT_ROM%
%FLIPS% src/tree.ips %OUT_ROM%
%FLIPS% src/archway.ips %OUT_ROM%
%FLIPS% src/bombable.ips %OUT_ROM%
%FLIPS% src/hud.ips %OUT_ROM%
%FLIPS% src/scroll_timing.ips %OUT_ROM%
