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




















