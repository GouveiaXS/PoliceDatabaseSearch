----------------------------------------------------------------------
-- Thanks for supporting AngelicXS Scripts!							--
-- Support can be found at: https://discord.gg/tQYmqm4xNb			--
-- More paid scripts at: https://angelicxs.tebex.io/ 				--
-- More FREE scripts at: https://github.com/GouveiaXS/ 				--
----------------------------------------------------------------------


Config = {}

Config.UseESX = false						-- Use ESX Framework
Config.UseQBCore = true					-- Use QBCore Framework (Ignored if Config.UseESX = true)

Config.UseCustomNotify = false				-- Use a custom notification script, must complete event below.
-- Only complete this event if Config.UseCustomNotify is true; mythic_notification provided as an example
RegisterNetEvent('angelicxs-policesearch:CustomNotify')
AddEventHandler('angelicxs-policesearch:CustomNotify', function(message, type)
    --exports.mythic_notify:SendAlert(type, message, 4000)
end)

-- Visual Preference
Config.Use3DText = false 					-- Use 3D text for terminal interactions; only turn to false if Config.UseThirdEye is turned on and IS working.
Config.UseThirdEye = true 					-- Enables using a third eye (third eye requires the following arguments debugPoly, useZ, options {event, icon, label}, distance)
Config.ThirdEyeName = 'qb-target' 			-- Name of third eye aplication

Config.NHInput = false						-- Use NH-Input [https://github.com/nerohiro/nh-keyboard]
Config.NHMenu = false						-- Use NH-Menu [https://github.com/whooith/nh-context]
Config.QBInput = true						-- Use QB-Input (Ignored if Config.NHInput = true) [https://github.com/qbcore-framework/qb-input]
Config.QBMenu = true						-- Use QB-Menu (Ignored if Config.NHMenu = true) [https://github.com/qbcore-framework/qb-menu]
Config.OXLib = false						-- Use the OX_lib (Ignored if Config.NHInput or Config.QBInput = true) [https://github.com/overextended/ox_lib]  !! must add shared_script '@ox_lib/init.lua' and lua54 'yes' to fxmanifest!!

Config.LEOJobName = {'police', 'sheriff'}  -- Name(s) of police job(s)

Config.TerminalLocations = {                -- Location of terminals and what LEOJobName is allowed to access it (specific access prevention disabled when Config.Use3DText = true)
    {location = vector3(447.53, -975.45, 30.69), job = 'police'},
}
--[[
    HOW TO ADD MORE CONFIG.SEARCHOPTIONS
    Step 1: 
        Add table to the appropriate config.search below:
        {tablename = 'xxx',                     -- Name of the database table
        tableid = 'xxx',                        -- How you want players to see the database name
        searchcriteria = 'xxx',                 -- What column in the database table will be searched **MUST BE A SINGLE VALUE - CANNOT BE A TABLE**
        searchid = 'xxx',                       -- How you want the players to see what column name they are searching
        resultcriteria = 'xxx',                 -- What column in the database table will be return information
        resultid = 'xxx',                       -- How you want the players to see what information they will be getting
        tableset = 'x[i]'},                     -- If the information in the column is a table in the database, create a unique ID for it (otherwise keep false)
    Step 2: (ONLY IF TABLESET = TRUE)
        You must go to the server side script and add the appropriate json.decode information (sorry couldnt figure out how to automate this part).
        Follow this format and put place with others:

        elseif decode == 'x[i]' then ------- change x[i] to match the unique tablset id
            local item = json.decode(XXXXXX) ------ change xxxxxx to v.COLUMNNAME
            searchtable[#searchtable+1] = {
                finalresult = tostring(item.XXXXXX..' '..item.XXXXXX) ---- change xxxxxx to the appropriate variable
            }
]]

Config.SearchOptionsESX = {
    {tablename = 'users', tableid = 'Citizen Information', searchcriteria = 'identifier', searchid = 'Citizen Serial Identification', resultcriteria = 'firstname', resultid = 'Citizen First Name', tableset = false},
    {tablename = 'users', tableid = 'Citizen Information', searchcriteria = 'identifier', searchid = 'Citizen Serial Identification', resultcriteria = 'lastname', resultid = 'Citizen Last Name', tableset = false},
    {tablename = 'users', tableid = 'Citizen Information', searchcriteria = 'firstname', searchid = 'Citizen First Name', resultcriteria = 'identifier', resultid = 'Citizen Serial Identification', tableset = false},
    {tablename = 'users', tableid = 'Citizen Information', searchcriteria = 'lastname', searchid = 'Citizen Last Name', resultcriteria = 'identifier', resultid = 'Citizen Serial Identification', tableset = false},
    {tablename = 'users', tableid = 'Citizen Information', searchcriteria = 'firstname', searchid = 'Citizen First Name', resultcriteria = 'lastname', resultid = 'Citizen Last Name', tableset = false},
    {tablename = 'users', tableid = 'Citizen Information', searchcriteria = 'lastname', searchid = 'Citizen Last Name', resultcriteria = 'firstname', resultid = 'Citizen First Name', tableset = false},
    {tablename = 'owned_vehicles', tableid = 'Citizen Vehicle Search', searchcriteria = 'owner', searchid = 'Citizen Serial Identification', resultcriteria = 'plate', resultid = 'Vehicle Plate', tableset = false},
    {tablename = 'owned_vehicles', tableid = 'Citizen Vehicle Search', searchcriteria = 'plate', searchid = 'Vehicle Plate', resultcriteria = 'owner', resultid = 'Citizen Serial Identification', tableset = false},

}

Config.SearchOptionsQBCore = {
    {tablename = 'players', tableid = 'Citizen Information Search', searchcriteria = 'citizenid', searchid = 'Citizen Identification', resultcriteria = 'charinfo', resultid = 'Citizen Name', tableset = 'QBFirstLast'},
    {tablename = 'players', tableid = 'Citizen Information Search', searchcriteria = 'citizenid', searchid = 'Citizen Identification', resultcriteria = 'charinfo', resultid = 'Citizen Phone Number', tableset = 'QBPhoneNumber'},
    {tablename = 'players', tableid = 'Citizen Information Search', searchcriteria = 'citizenid', searchid = 'Citizen Identification', resultcriteria = 'metadata', resultid = 'Citizen Fingerprint Serial', tableset = 'QBCIDFingerprint'},
    {tablename = 'apartments', tableid = 'Citizen Apartment Search', searchcriteria = 'citizenid', searchid = 'Citizen Identification', resultcriteria = 'label', resultid = 'Owned Property', tableset = false},
    {tablename = 'player_vehicles', tableid = 'Citizen Vehicle Search', searchcriteria = 'citizenid', searchid = 'Citizen Identification', resultcriteria = 'plate', resultid = 'Vehicle Plate', tableset = false},
    {tablename = 'player_vehicles', tableid = 'Citizen Vehicle Search', searchcriteria = 'plate', searchid = 'Vehicle Plate', resultcriteria = 'citizenid', resultid = 'Citizen Identification', tableset = false},
    {tablename = 'player_vehicles', tableid = 'Citizen Vehicle Search', searchcriteria = 'plate', searchid = 'Vehicle Plate', resultcriteria = 'vehicle', resultid = 'Vehicle Model', tableset = false},

}


Config.LangType = {
	['error'] = 'error',
	['success'] = 'success',
	['info'] = 'primary'
}

Config.Lang = {
	['3d_access'] = 'Press ~r~[E]~w~ to access Federal Database Terminal.',
	['access'] = 'Access Federal Database Terminal.',
    ['not_leo'] = 'Only law enforcement officers can access the database!',
    ['terminal_menu_header'] = 'Federal Database Terminal',
    ['terminal_menu_option'] = 'Access following database: ',
    ['terminal_menu_search'] = 'Search by: ',
    ['terminal_menu_result'] = ' to receive result of: ',
    ['no_results'] = 'Database Error: No matching results found.',
    ['database_results_title'] = 'Database Compilation Results for: ',
    ['database_results_header'] = 'Database Result:',

}
