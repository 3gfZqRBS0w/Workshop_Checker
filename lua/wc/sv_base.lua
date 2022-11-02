util.AddNetworkString( "WORKSHOPCHECK_GetCollectionDetails" )



local function GetCollectionDetails()

    local args = {}
    args.collectioncount = "1"
    args["publishedfileids[0]"] =  WL_WORKSHOP_ID

    http.Post( "https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1/", args,function(body, length, headers, code) result = util.JSONToTable(body) end)
    
    return result 
end

local function GetNumberOfAddons(collecTable)
    return table.Count(collecTable["response"]["collectiondetails"][1]["children"])
end


PrintTable(GetCollectionDetails())


net.Receive("WORKSHOPCHECK_GetCollectionDetails", function(len, pl)
    if ( pl:IsSuperAdmin()) then
        local collecTable = GetCollectionDetails()
        local num = GetNumberOfAddons(collecTable)
        net.Start("WORKSHOPCHECK_GetCollectionDetails")
        net.WriteUInt(num, 9)
        for I=1, num do
           net.WriteString(collecTable["response"]["collectiondetails"][1]["children"][num]["publishedfileid"])
        end
        net.Send(pl)
    end
end)










local collect = GetCollectionDetails()


PrintTable(collect)
print("Le nombre d'addon dans votre collection est de "..GetNumberOfAddons(collect))

