
util.AddNetworkString( "WC_GetAddons" )



net.Receive("WC_GetAddons", function(len, pl)
    if (pl:IsSuperAdmin()) then

        local compressed_message = util.Compress( util.TableToJSON( WC_Response, false ) )
        local bytes_amount = #compressed_message
        net.Start("WC_GetAddons")
        net.WriteUInt( bytes_amount, 16 ) 
        net.WriteData( compressed_message, bytes_amount ) 
        net.Send(pl)
    else
        print("You do not have the right !")
    end
end)


hook.Add("WC_AfterRequestAddon", "WC_LogsCollection", function()
    
end)


hook.Add( "WC_AfterRequestAddon", "WC_CheckNewUpdate", function()
    for k, v in pairs(WC_Response["response"]["publishedfiledetails"]) do
        if ( WorkshopCheck.GetValidation(v) == WC_CONFIG.LEVEL_OF_DANGEROUSNESS.unsafe ) then
            print("[WC] UNSAFE ADDON IN COLLECTION "..WC_Response["response"]["publishedfiledetails"][k]["title"].."CHECK" )
        else if(WorkshopCheck.GetValidation(v) == WC_CONFIG.LEVEL_OF_DANGEROUSNESS.exploit ) then
            print("[WC] EXPLOIT ADDON IN COLLECTION "..WC_Response["response"]["publishedfiledetails"][k]["title"].."CHECK" )
        end
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




















