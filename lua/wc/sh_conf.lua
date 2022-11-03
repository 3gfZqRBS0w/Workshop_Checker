-- CONFIGURATION FILE


WC_CONFIG = {}

WL_WORKSHOP_ID = "1092793021"


WC_CONFIG.LEVEL_OF_DANGEROUSNESS = {
    backdoor = {
        color = Color(0,0,0),
        title = "Backdoor",
        description = "When the addon has been verified and contains or has contained a backdoor"

    }, 
    unsafe = {
        color = Color(100,0,0),
        title = "unsafe",
        description = "update performed within 72 hours"
    }, 
    neutral = {
        color = Color(255,127,80),
        title = "neutral",
        description = "Nothing to say"
    }, 
    trustworthy = {
        color = Color(124,252,0),
        title = "trustworthy",
        description "When the addon is used by many people and is well rated "

    }

}