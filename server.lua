ESX = nil
QBcore = nil

if Config.UseESX then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent('angelicxs-policesearch:Server:SearchDatabase', function(table, search, result, criteria, decode)
    local src = source
    local searchtable ={}
    local sqlinqury = tostring("SELECT "..result.." FROM "..table.." WHERE LOWER("..search..") LIKE LOWER(:"..search..") LIMIT 30") 
    exports.oxmysql:query(sqlinqury,
    {[search] = "%" .. criteria .. "%",}, function(results)
         for k, v in pairs(results) do
            if not decode then
                for i,p in pairs(v) do
                    searchtable[#searchtable+1] = {
                        finalresult = tostring(p)
                    }
                end
            elseif decode == 'QBFirstLast' then
                local item = json.decode(v.charinfo)
                searchtable[#searchtable+1] = {
                    finalresult = tostring(item.firstname..' '..item.lastname)
                }
            elseif decode == 'QBCIDFingerprint' then
                local item = json.decode(v.metadata)
                searchtable[#searchtable+1] = {
                    finalresult = tostring(item.fingerprint)
                }
            elseif decode == 'QBPhoneNumber' then
                local item = json.decode(v.charinfo)
                searchtable[#searchtable+1] = {
                    finalresult = tostring(item.phone)
                }
            end
        end
        TriggerClientEvent('angelicxs-policesearch:Client:DatabaseResult', src, searchtable, criteria)
    end)
end)
