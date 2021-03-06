--[[
   Created By: Darkzy
--]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependencies {
	"externalsql",
	"drp_core",
	"drp_clothing",
	"drp_bank"
}

ui_page "ui/index.html"

files {
	"ui/index.html",
	"ui/libraries/axios.min.js",
	"ui/libraries/vue.min.js",
	"ui/libraries/vuetify.css",
	"ui/libraries/vuetify.js",
	"ui/script.js",
	"ui/style.css"
}


server_script "config.lua"
server_script "server.lua"

client_script "config.lua"
client_script "client.lua"

client_script "cameras/cameras.lua"
client_script "modifier/character_modifier.lua"

export "SpawnedInAndLoaded"

server_export "GetCharacterData"
server_export "GetCharacterName"
server_export "GetCharacterDataFromCharId"
