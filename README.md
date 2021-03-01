# Debug plugin for AttractMode front end

by [Matteo Cedroni](https://github.com/matteocedroni)

## DESCRIPTION:

Launch decorator plugin is for the [AttractMode](http://attractmode.org) front end. It automatically runs script before and/or after game execution.

## Install Files

1. Copy LaunchDecorator folder to `plugins`.

## Usage

You can enable the LaunchDecorator plugin by running Attract Mode and pressing the tab key to enter the configure menu. Navigate to `Plug-ins -> LaunchDecorator -> Enabled`. Enable the plugin.

* **ScriptRoot**, path to script hierarchy root;
* **ScriptExtensions**, comma separated script extensions. E.g. `.bat,.exe,.au3`

## Behavior

LaunchDecorator follows convention over configuration approach
```
📦ScriptRoot
 ┣ 📂emulator name
 ┃ ┗ 📜before.{script extension}
 ┃ ┗ 📜after.{script extension}
 ┃ ┗ 📜...
 ┃ ┗ 📜before.{game name}.{script extension}
 ┃ ┗ 📜after.{game name}.{script extension}
 ┃ ┗ 📜...
 ┃ 
 ┣ 📂another emulator name
 ┣ 📂...
```
Where
* `{script extension}` can be any of the configured extensions. The first script found with any of this extensions will be executed
* `{emulator name}` must match `Emulator` column in rom list
* `{game name}` must match `Name` column in rom list

All ScriptRoot child elements are optional and script extensions can be mixed

Whenever a game is launched, LaunchDecorator tries to find a suitable script with the follow priority order:
1.  game specific script `{emulator name}/before.{game name}.{script extension}`. E.g. `mame/before.1943.bat`
2.  emulator specific script `{emulator name}/before.{script extension}`. E.g. `mame/before.bat`

Same behavior after game execution, with `after` token instead of `before`

## Notes
LaunchDecorator can launch only files that are directly executable by OS command line shell. Depending of OS, you may need some action to make command line able to directly execute some scripts