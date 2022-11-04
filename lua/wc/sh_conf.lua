-- CONFIGURATION FILE


WC_CONFIG = {}

WL_WORKSHOP_ID = "2880893693"


WC_CONFIG.LEVEL_OF_DANGEROUSNESS = {
    
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