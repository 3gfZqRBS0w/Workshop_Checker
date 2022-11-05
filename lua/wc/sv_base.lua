util.AddNetworkString("WC_GetAddons")
util.AddNetworkString("WC_ResearchAddon")



if (not file.Exists("data/workshopcheck", "GAME")) then
    file.CreateDir("workshopcheck")
    print("[WC] file created")
end





net.Receive("WC_ResearchAddon", function(len, pl)

    if (WC_ACCESS[pl:GetUserGroup()] == true) then
    local id = net.ReadString()
local file, folder = file.Find("workshopcheck/*", "DATA")
for k,v in pairs(file) do
    local suspectAddon = util.JSONToTable(file.Read( "workshopcheck/"..v, "DATA" ))
    for k, v in pairs(suspectAddon) do
        if (suspectAddon[k]["publishedfileid"] == id) then
            local compressed_message = util.Compress(util.TableToJSON(suspectAddon[k], false))
            local bytes_amount = #compressed_message
            net.Start("WC_ReSearchAddon")
            net.WriteUInt(bytes_amount, 16)
            net.WriteData(compressed_message, bytes_amount)
            net.Send(pl)
            return true
        end
    end
end
else
    print("[WC] You do not have the right ! ")
end


end)

net.Receive(
    "WC_GetAddons",
    function(len, pl)
        if (WC_ACCESS[pl:GetUserGroup()] == true) then
            local compressed_message = util.Compress(util.TableToJSON(WC_Response, false))
            local bytes_amount = #compressed_message
            net.Start("WC_GetAddons")
            net.WriteUInt(bytes_amount, 16)
            net.WriteData(compressed_message, bytes_amount)
            net.Send(pl)
        else
            print("[WC] You do not have the right !")
        end
    end
)

--[[
When a bad guy puts a backdoor in his addon to hide his actions, he either updates it, hides it or removes it. In the second case you have to keep track of what the addon has done
]]
hook.Add(
    "WC_AfterRequestAddon",
    "WC_LogsCollection",
    function()
        local menace = {}

        for k, v in pairs(WC_Response["response"]["publishedfiledetails"]) do
            if
                (WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]) ==
                    WC_CONFIG.LEVEL_OF_DANGEROUSNESS.unsafe or
                    WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]) ==
                        WC_CONFIG.LEVEL_OF_DANGEROUSNESS.exploit)
             then
                menace[WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"]] =
                    WC_Response["response"]["publishedfiledetails"][k]
            end
        end

        if (not table.IsEmpty(menace)) then
            file.Write(os.date("workshopcheck/%d%m%Y", os.time()) .. ".json", util.TableToJSON(menace))
            if (file.Exists(os.date("workshopcheck/%d%m%Y.json", os.time()), "DATA")) then
                print("[WC] The log file of" .. os.date("%H:%M:%S - %d/%m/%Y", os.time()) .. " has been updated")
            else
                print("[WC] The log file of" .. os.date("%H:%M:%S - %d/%m/%Y", os.time()) .. " has been written")
            end
        end
    end
)

--hook.Run("WC_AfterRequestAddon", "WC_LogsCollection")

hook.Add(
    "WC_AfterRequestAddon",
    "WC_CheckNewUpdate",
    function()
        for k, v in pairs(WC_Response["response"]["publishedfiledetails"]) do
            if (WorkshopCheck.GetValidation(v) == WC_CONFIG.LEVEL_OF_DANGEROUSNESS.unsafe) then
                print(
                    "[WC] UNSAFE ADDON IN COLLECTION " ..
                        WC_Response["response"]["publishedfiledetails"][k]["title"] .. "CHECK"
                )
            else
                if (WorkshopCheck.GetValidation(v) == WC_CONFIG.LEVEL_OF_DANGEROUSNESS.exploit) then
                    print(
                        "[WC] EXPLOIT ADDON IN COLLECTION " ..
                            WC_Response["response"]["publishedfiledetails"][k]["title"] .. "CHECK"
                    )
                end
            end
        end
    end
)


hook.Add("PlayerSay", "WC_OpenMenu", function( pl, text )
	if ( string.StartWith( string.lower( text ), "/workshopcheck" ) ) then 
		if (WC_ACCESS[pl:GetUserGroup()])  then
            local compressed_message = util.Compress(util.TableToJSON(WC_Response, false))
            local bytes_amount = #compressed_message
            net.Start("WC_GetAddons")
            net.WriteUInt(bytes_amount, 16)
            net.WriteData(compressed_message, bytes_amount)
            net.Send(pl)
			ServerLog( pl:Nick().."("..pl:SteamID()..") to consult the panel ")
		else
			timer.Simple( 0.5, function() ply:ChatPrint("Vous ne pouvez pas vous permettre de faire ça ! ") end )
		end

	end
end)

--[[
bad idea


util.AddNetworkString( "WORKSHOPCHECK_GetCollectionDetails" )






net.Receive("WORKSHOPCHECK_GetCollectionDetails", function(len, pl)
    if ( pl:IsSuperAdmin()) then
        local collecTable = GetCollectionDetails()
        local num = GetNumberOfAddons(collecTable)

        net.Start("WORKSHOPCHECK_GetCollectionDetails")
        net.WriteUInt(num, 9)

        for k, v in pairs(collecTable["response"]["collectiondetails"][1]["children"]) do
           net.WriteString(v.publishedfileid)
        end

        net.Send(pl)
    end
end)

]]
