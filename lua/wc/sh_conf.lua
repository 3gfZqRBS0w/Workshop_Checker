-- CONFIGURATION FILE





WC_CONFIG = {}






WC_WORKSHOP_TRUSTWORTHYCREATOR = {
    ["76561198012757646"] = true,
}


WC_ADDON_EXPLOIT = {
    --[[
        Possibility to exploit a net to make crash and take screens of other players without this one being beforehand superadmin. 
    ]]
    ["2114254167"] = true, 
}





WC_CONFIG.LEVEL_OF_DANGEROUSNESS = {
    trustedEditor = {
        color = Color(0, 0, 255),
        title ="Trusted Editor",
        description = "The editor is deemed not to have any malicious action in his work"
    },
    exploit = {
        color = Color(155,38,182),
        title = "Exploit",
        description = "When the addon has been checked and contains an uncorrected exploit"
    },
    backdoor = {
        color = Color(0,0,0),
        title = "Backdoor",
        description = "When the addon has been verified and contains or has contained a backdoor"

    },
    ban = {
        color = Color(0,0,0),
        title = "ban",
        description = "ban"
    },
    unsafe = {
        color = Color(100,0,0),
        title = "unsafe",
        description = "either the add-on has been updated very recently or there is little traffic"
    }, 
    neutral = {
        color = Color(255,127,80),
        title = "neutral",
        description = "Nothing to say"
    }, 
    trustworthy = {
        color = Color(0,128,0),
        title = "trustworthy",
        description = "When the addon is used by many people and is well rated "
    }
}