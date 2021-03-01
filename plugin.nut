///////////////////////////////////////////////////
//
// Attract-Mode Frontend - LaunchDecorator plugin
//
///////////////////////////////////////////////////

class UserConfig </ help="Runs script before/after game" /> {
	</ label="ScriptRoot", help="Root path for script files", order=1 />
	scriptRoot = "";
	</ label="ScriptExtensions", help="Comma separated script extensions", order=2 />
	scriptExtensions = "";
}

enum COMMANDTYPES {
    BEFORE="before",
    AFTER="after"
};

class LaunchDecorator {
	config = null;
	command = null;
	extensions = null;

	constructor() {
		config = fe.get_config();
		fe.add_transition_callback(this, "onTransition" );
		extensions = split(config["scriptExtensions"], ",");
	}

	function withApex(value){
		return "\"" + value + "\"";
	}

	function findScriptExtension(scriptName) {
		foreach (ext in extensions) {
			local script = fe.path_expand(scriptName + ext);
			if (fe.path_test(script, PathTest.IsFile)){
				return script;
			}
		}
		return null;
	}

	function findScript(type, emulator, romName) {
		// try game specific -> scriptRoot/{emulator}/{type}.{game}
		local script = findScriptExtension(config["scriptRoot"] + "/" + emulator + "/" + type + "." + romName);
		if (script==null){
			// try emulator specific -> scriptRoot/{emulator}/{type}
			script = findScriptExtension(config["scriptRoot"] + "/" + emulator + "/" + type);
		}

		return script;
	}

	function executeScript(script){
		command = withApex(script) +" "+ withApex(fe.game_info(Info.Name)) +" "+ withApex(fe.game_info(Info.Emulator));
		print("execute -> " + command + "\n");
		if ( OS == "Windows" ) fe.plugin_command( "cmd", "/c " + withApex(command));
		else fe.plugin_command( "/bin/sh", "-c " + withApex(command));
	}

	function onTransition( ttype, var, ttime ) {
		local script;
		
		if ( ScreenSaverActive )
			return false;

		switch ( ttype ){	
		case Transition.ToGame:
			script = findScript(COMMANDTYPES.BEFORE, fe.game_info(Info.Emulator), fe.game_info(Info.Name));
			if (script!=null) executeScript(script);
			break;

		case Transition.FromGame:
			script = findScript(COMMANDTYPES.AFTER, fe.game_info(Info.Emulator), fe.game_info(Info.Name));
			if (script!=null) executeScript(script);
			break;
		}

		return false; // must return false
	}
}
fe.plugin["LaunchDecorator"] <- LaunchDecorator();