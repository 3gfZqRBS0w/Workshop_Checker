

util.AddNetworkString( "WORKSHOPCHECK_GetCollectionDetails" )



local function GetCollectionDetails()
    HTTP({
        timeout = 60,
        url= "https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1/", 
        method= "POST",
        parameters = {
            ["collectioncount"] = "1",
            ["publishedfileids[0]"] =  WL_WORKSHOP_ID
        },
        headers = { 
            ['Content-Type']= 'application/json',
        },
        success= function( code, body, headers )
            WL_COLLECTION_DETAIL = util.JSONToTable(body)
            --print("success")
        end, 
        failed = function( err ) 
            print("error " .. err)
        end,
    })

    return WL_COLLECTION_DETAIL
end

local function GetAddonData(id)

    HTTP({
        timeout=5,
        url= "https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/", 
        method= "POST",
        parameters = {
            ["itemcount"] = "1",
            ["publishedfileids[0]"] = id
        },
        headers = { 
            ['Content-Type']= 'application/json',
        },
        success= function( code, body, headers )
            WL_ADDON_DETAIL = util.JSONToTable(body)
            --print("success")
        end, 
        failed = function( err ) 
            --print("error " .. err)
        end,
    })
    return WL_ADDON_DETAIL
end







local function GetNumberOfAddons(tb)
    return table.Count(tb["response"]["collectiondetails"][1]["children"])
end



local function GetAddonNameByID(id)
    return GetAddonData(id)["response"]["publishedfiledetails"][1]["title"]
end





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

















