const fs = require("fs-extra")

const pluginConfig = require("./config");
const COMPRESS_LUA = false;

module.exports = class remoteCommands {
	constructor(mergedConfig, messageInterface, extras){
		this.messageInterface = messageInterface;
		this.config = mergedConfig;
		this.socket = extras.socket;
		
		(async ()=>{
			let hotpatchInstallStatus = await this.checkHotpatchInstallation();
			this.hotpatchStatus = hotpatchInstallStatus;
			this.messageInterface("Hotpach installation status: "+hotpatchInstallStatus);

			if(hotpatchInstallStatus){
				let mainCode = await this.getSafeLua("sharedPlugins/Doomsday/control.lua");
				let attack_waves_manager = await this.getSafeLua("sharedPlugins/Doomsday/attack_waves_manager.lua");
				let attack_waves = await this.getSafeLua("sharedPlugins/Doomsday/attack_waves.lua");
				if(mainCode) var returnValue = await messageInterface(`/silent-command remote.call('hotpatch', 'update', '${pluginConfig.name}', '${pluginConfig.version}', '${mainCode}', \{attack_waves = '${attack_waves}', attack_waves_manager = '${attack_waves_manager}'\})`);
				if(returnValue) console.log(returnValue);
			}
			
		})().catch(e => console.log(e));		
	}
	async getSafeLua(filePath){
		return new Promise((resolve, reject) => {
			fs.readFile(filePath, "utf8", (err, contents) => {
				if(err){
					reject(err);
				} else {
                    // split content into lines
					contents = contents.split(/\r?\n/);

					// join those lines after making them safe again
					contents = contents.reduce((acc, val) => {
                        val = val.replace(/\\/g ,'\\\\');
                        // remove leading and trailing spaces
					    val = val.trim();
                        // escape single quotes
					    val = val.replace(/'/g ,'\\\'');

					    // remove single line comments
                        let singleLineCommentPosition = val.indexOf("--");
                        let multiLineCommentPosition = val.indexOf("--[[");

						if(multiLineCommentPosition === -1 && singleLineCommentPosition !== -1) {
							val = val.substr(0, singleLineCommentPosition);
						}

                        return acc + val + '\\n';
					}, ""); // need the "" or it will not process the first row, potentially leaving a single line comment in that disables the whole code
					if(COMPRESS_LUA) contents = require("luamin").minify(contents);
					
					resolve(contents);
				}
			});
		});
	}
	async checkHotpatchInstallation(){
		let yn = await this.messageInterface("/silent-command if remote.interfaces['hotpatch'] then rcon.print('true') else rcon.print('false') end");
		yn = yn.replace(/(\r\n\t|\n|\r\t)/gm, "");
		if(yn == "true"){
			return true;
		} else if(yn == "false"){
			return false;
		}
	}
}
