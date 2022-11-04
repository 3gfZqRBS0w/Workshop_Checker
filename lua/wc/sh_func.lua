WorkshopCheck = {}

function WorkshopCheck.GetValidation(addon)


    if ( addon["time_updated"] > os.time(os.date("!*t"))-(86400*3) ) then
        return WC_CONFIG.LEVEL_OF_DANGEROUSNESS.unsafe
    end

    if ( addon["banned"] == 0) then
        if (addon["subscriptions"] >= 5000) then
            return WC_CONFIG.LEVEL_OF_DANGEROUSNESS.trustworthy
        end
    else
        return WC_CONFIG.LEVEL_OF_DANGEROUSNESS.ban
    end

    return  WC_CONFIG.LEVEL_OF_DANGEROUSNESS.neutral
end