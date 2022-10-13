ESX = nil
QBcore = nil
PlayerJob = nil
PlayerGrade = nil
local isLawEnforcement = false

CreateThread(function()
    if Config.UseESX then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Wait(0)
        end
    
        while not ESX.IsPlayerLoaded() do
            Wait(100)
        end
    
        local playerData = ESX.GetPlayerData()
        CreateThread(function()
            while true do
                if playerData ~= nil then
                    PlayerJob = playerData.job.name
                    PlayerGrade = playerData.job.grade
                    isLawEnforcement = LawEnforcement()
                    break
                end
                Wait(100)
            end
        end)
        RegisterNetEvent('esx:setJob', function(job)
            PlayerJob = job.name
            PlayerGrade = job.grade
            isLawEnforcement = LawEnforcement()
        end)

    elseif Config.UseQBCore then

        QBCore = exports['qb-core']:GetCoreObject()
        
        CreateThread(function ()
			while true do
                local playerData = QBCore.Functions.GetPlayerData()
				if playerData.citizenid ~= nil then
					PlayerJob = playerData.job.name
					PlayerGrade = playerData.job.grade.level
                    isLawEnforcement = LawEnforcement()
					break
				end
				Wait(100)
			end
		end)

        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
            PlayerJob = job.name
            PlayerGrade = job.grade.level
            isLawEnforcement = LawEnforcement()
        end)
    end
end)

RegisterNetEvent('angelicxs-policesearch:Notify', function(message, type)
	if Config.UseCustomNotify then
        TriggerEvent('angelicxs-policesearch:CustomNotify',message, type)
	elseif Config.UseESX then
		ESX.ShowNotification(message)
	elseif Config.UseQBCore then
		QBCore.Functions.Notify(message, type)
	end
end)

CreateThread(function()
    if Config.UseThirdEye then
        for location, terminal in pairs (Config.TerminalLocations) do
            exports[Config.ThirdEyeName]:AddBoxZone(location..'searchcomputer', terminal.location, 2, 2, {
                name = location..'searchcomputer',
                heading = 0,
                debugPoly = false,
                minZ = terminal.location.z - 1.5,
                maxZ = terminal.location.z + 1.5
            },
            {
                options = {
                    {
                        event = 'angelicxs-policesearch:OpenTerminal',
                        icon = "fas fa-sign-in-alt",
                        label = Config.Lang['access'],
                    },
                },
                job = terminal.job,
                distance = 1.5 
            })
        end
    end
    if Config.Use3DText then
        while true do
            local Sleep = 5000
            if isLawEnforcement then
                local Player = PlayerPedId()
                local Pos = GetEntityCoords(Player) 
                for location, terminal in pairs (Config.TerminalLocations) do
                    local Dist = #(Pos - terminal.location)
                    if Dist <= 50 then
                        Sleep = 1500
                        if Dist <= 20 then
                            Sleep = 500
                            if Dist <= 3 then
                                Sleep = 0
                                DrawText3Ds(terminal.location.x,terminal.location.y,terminal.location.z, Config.Lang['3d_access'])
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent('angelicxs-policesearch:OpenTerminal')
                                end
                            end
                        end
                    end
                end
            end
            Wait(Sleep)
        end
    end
end)

RegisterNetEvent("angelicxs-policesearch:OpenTerminal", function()
    local TerminalMenu1 = {}
    local SearchOptions = nil
    if Config.UseESX then
        SearchOptions = Config.SearchOptionsESX
    elseif Config.UseQBCore then
        SearchOptions = Config.SearchOptionsQBCore
    end
    if Config.NHMenu then
        table.insert(TerminalMenu1, {
            header = Config.Lang['terminal_menu_header'],
        })
    elseif Config.QBMenu then
        table.insert(TerminalMenu1, {
                header = Config.Lang['terminal_menu_header'],
                isMenuHeader = true
            })
    end
    for _, Options in pairs(SearchOptions) do
        local table = Options.tableid
        local search = Options.searchid
        local result = Options.resultid 
        if Config.NHMenu then
            TerminalMenu1[#TerminalMenu1+1] = {
                header = Config.Lang['terminal_menu_option']..table,
                context = Config.Lang['terminal_menu_search']..search..Config.Lang['terminal_menu_result']..result,
                event = 'angelicxs-policesearch:InputTerminal',
                args = { Options }
            }
        elseif Config.QBMenu then
            TerminalMenu1[#TerminalMenu1+1] = {
                header = Config.Lang['terminal_menu_option']..table,
                txt = Config.Lang['terminal_menu_search']..search..Config.Lang['terminal_menu_result']..result,
                params = {
                    event = 'angelicxs-policesearch:InputTerminal',
                    args = Options
            }}
        elseif Config.OXLib then
            TerminalMenu1[#TerminalMenu1+1] = {
                label = Config.Lang['terminal_menu_option']..table..' '..Config.Lang['terminal_menu_search']..search..Config.Lang['terminal_menu_result']..result,
                args = { Options = Options}
            }
        end
    end
    if Config.NHMenu then
        TriggerEvent("nh-context:createMenu", TerminalMenu1)
    elseif Config.QBMenu then
        TriggerEvent("qb-menu:client:openMenu", TerminalMenu1)
    elseif Config.OXLib then
        lib.registerMenu({
            id = 'policedatabaseterminal_ox',
            title = Config.Lang['terminal_menu_header'],
            options = TerminalMenu1,
            position = 'top-right',
        }, function(selected, scrollIndex, args)
                TriggerEvent('angelicxs-policesearch:InputTerminal', args.Options)
        end)
        lib.showMenu('policedatabaseterminal_ox')
    end
end)

RegisterNetEvent('angelicxs-policesearch:InputTerminal', function(options)
    local table = options.tableid
    local search = options.searchid
    local result = options.resultid
    local criteria = nil 
    if Config.NHInput then
        local keyboard, amount = exports["nh-keyboard"]:Keyboard({
            header = Config.Lang['terminal_menu_option']..table,
            rows = {Config.Lang['terminal_menu_search']..search,}
        })
        if keyboard then
            criteria = tostring(amount[1])
        end
    elseif Config.QBInput then
        local QBSearch = exports['qb-input']:ShowInput({
            header = Config.Lang['terminal_menu_option']..table,
            submitText = Config.Lang['terminal_menu_search']..search,
            inputs = {
                {
                    type = 'text',
                    isRequired = true,
                    name = 'searching',
                    text = Config.Lang['terminal_menu_search']..search,
                },
            }
        })    
        if QBSearch then
            criteria = tostring(QBSearch.searching)
        end
    elseif Config.OXLib then
        local input = lib.inputDialog(Config.Lang['terminal_menu_option']..table, {Config.Lang['terminal_menu_search']..search})
        if not input then return end
        criteria = tostring(input[1])
    end
    TriggerServerEvent('angelicxs-policesearch:Server:SearchDatabase', options.tablename, options.searchcriteria, options.resultcriteria, criteria, options.tableset)
end)

RegisterNetEvent("angelicxs-policesearch:Client:DatabaseResult", function(table)
    local FinalResults = table
    local ReturnMenu = {}
    if FinalResults == nil then
        TriggerEvent('angelicxs-policesearch:Notify', Config.Lang['no_results'], Config.LangType['info'])
    else
        if Config.NHMenu then
            ReturnMenu[#ReturnMenu+1] = {
                header = Config.Lang['database_results_title'],
            }
        elseif Config.QBMenu then
            ReturnMenu[#ReturnMenu+1] = {
                header = Config.Lang['database_results_title'],
                isMenuHeader = true
            }
        end
        for k, data in pairs(FinalResults) do
            if Config.NHMenu then
                ReturnMenu[#ReturnMenu+1] = {
                    header = Config.Lang['database_results_header'],
                    context = data.finalresult,
                }
            elseif Config.QBMenu then
                ReturnMenu[#ReturnMenu+1] = {
                    header = Config.Lang['database_results_header'],
                    txt = data.finalresult,
                }
            elseif Config.OXLib then
                ReturnMenu[#ReturnMenu+1] = {
                    label = Config.Lang['database_results_header']..data.finalresult,
                }
            end
        end
        if Config.NHMenu then
            TriggerEvent("nh-context:createMenu", ReturnMenu)
        elseif Config.QBMenu then
            TriggerEvent("qb-menu:client:openMenu", ReturnMenu)
        elseif Config.OXLib then
            lib.registerMenu({
                id = 'databasemenu_ox',
                title = Config.Lang['database_results_title'],
                options = ReturnMenu,
                position = 'top-right',
            }, function(selected, scrollIndex, args)
            end)
            lib.showMenu('databasemenu_ox')
        end
    end
end)

function LawEnforcement()
    for i = 1, #Config.LEOJobName do
        if PlayerJob == Config.LEOJobName[i] then
            return true
        end
    end
    return false
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
