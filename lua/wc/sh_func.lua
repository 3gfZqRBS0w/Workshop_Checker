
WC_FUNC = {}

WC_FUNC.GetCollectionDetails = function()

    --impossible to put it in local 

    HTTP({
        timeout = 60,
        url= "https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1/",
        headers= { 
            ['Content-Type']= 'application/json',
            ["Cache-Control"] = "max-age=0",
        },
        method= "POST",
        parameters = {
            ["collectioncount"] = "1",
            ["publishedfileids[0]"] =  WL_WORKSHOP_ID
        },
        headers = { 
            ['Content-Type']= 'application/json',
        },
        success= function( code, body, headers )
            WC_COLLEC = util.JSONToTable(body)

        end, 
        failed = function( err ) 
            print("error " .. err)
        end,
    })

    return WC_COLLEC
end

WC_FUNC.GetAddonParam = function()
    local parameters = {}
    local collec = WC_FUNC.GetCollectionDetails()["response"]["collectiondetails"][1]["children"]

    for k, v in pairs(collec) do
        parameters["publishedfileids["..(k-1).."]"] = v["publishedfileid"]
        parameters["itemcount"] = util.TypeToString(k)
    end

    return parameters
end


WC_FUNC.GetAddonDetails = function()
    HTTP({
        timeout=60,
        url= "https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/", 
        method= "POST",

        headers= { 
            ['Content-Type']= 'application/json'
        },
        parameters = WC_FUNC.GetAddonParam(),
        
        success = function( code, body, headers )
            
            WC_ADDON = util.JSONToTable(body)
          
        end, 
        failed = function( err ) 
            print("error " .. err)
        end,
      
    })
    return WC_ADDON
end
--get the evaluation of an addon 


--[[
    addon table example :

    favorited	=	4047
file_size	=	80185376
file_url	=	https://steamusercontent-a.akamaihd.net/ugc/228948663897951898/16E8695D80DEC765BA260EC75AD077688C28ECE9/
filename	=	addon_uploads/1477526894_4294098967.gma
hcontent_file	=	228948663897951898
hcontent_preview	=	228948663897962178
lifetime_favorited	=	4810
lifetime_subscriptions	=	339893
preview_url	=	https://steamuserimages-a.akamaihd.net/ugc/228948663897962178/D7331938364CD7253C1B46E0D34A0F591CD358D7/
publishedfileid	=	787790694
result	=	1
subscriptions	=	166700
tags:
		1:
				tag	=	Addon
		2:
				tag	=	map
		3:
				tag	=	Realism
time_created	=	1477527134
time_updated	=	1477527134
title	=	slash_highschool
views	=	120697
visibility	=	0
ban_reason	=	
banned	=	0
consumer_app_id	=	4000
creator	=	76561197992024267
creator_app_id	=	4000
description	=	Welcome to a night full of terror,

]]

WC_FUNC.GetEvaluationOfAnAddon = function(addon)



end





WC_FUNC.GetNumberOfAddons = function(tb)
    return table.Count(tb["response"]["collectiondetails"][1]["children"])
end


WC_FUNC.GetAddonNameByID = function(id)
    return GetAddonData(id)["response"]["publishedfiledetails"][1]["title"]
end



