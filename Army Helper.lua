script_name('Army Helper')
script_author('VuTuV')
script_description('Хелпер для армии') 

require "lib.moonloader"
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 1
local script_vers_text = "1.00"

local update_url = "https://raw.githubusercontent.com/AVuTuVA/ArmyHelper/master/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini" 

local script_url = "https://raw.githubusercontent.com/AVuTuVA/ArmyHelper/master/Army%20Helper.lua"
local script_path = thisScript().path


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampAddChatMessage("{00FF00}[Army Helper] {FFFFFF}Данный скрипт успешно загружен!",-1)

    sampRegisterChatCommand("updatelist",cmd_updatelist)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("{00FF00}[Army Helper] {FFFFFF}Было найдено новое обновление! Посмотреть что нового: /updatelist. Версия:" ..  updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    
	while true do
        wait(0)
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{00FF00}[Army Helper] {FFFFFF}Скрипт был успешно обновлен! Посмотреть что нового /updatelist.", -1)
                    thisScript():reload()
                end
            end)
            break
        end
	end
end

function cmd_updatelist()   
    sampShowDialog(400,"обновление","система автообновления","соси","хуй",0)
end