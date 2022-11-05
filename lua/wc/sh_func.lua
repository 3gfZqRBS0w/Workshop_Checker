WorkshopCheck = {}

function WorkshopCheck.GetValidation(addon)

    if (WC_ADDON_BACKDOOR[addon["publishedfileid"]] == true) then
        return WC_CONFIG.LEVEL_OF_DANGEROUSNESS.backdoor
    end
 
    if (WC_ADDON_EXPLOIT[addon["publishedfileid"]] == true) then
        return WC_CONFIG.LEVEL_OF_DANGEROUSNESS.exploit
    end

    if ( WC_WORKSHOP_TRUSTWORTHYCREATOR[addon["creator"]] == true ) then
        return WC_CONFIG.LEVEL_OF_DANGEROUSNESS.trustedEditor
    end

    if ( addon["time_updated"] > os.time(os.date("!*t"))-(86400*3) ) then
        return WC_CONFIG.LEVEL_OF_DANGEROUSNESS.unsafe
    end

    if ( addon["banned"] == 0) then
        if (addon["subscriptions"] >= 5000 or addon["favorited"] >= 1000) then
            return WC_CONFIG.LEVEL_OF_DANGEROUSNESS.trustworthy
        end
    else
        return WC_CONFIG.LEVEL_OF_DANGEROUSNESS.ban
    end

    return  WC_CONFIG.LEVEL_OF_DANGEROUSNESS.neutral
end