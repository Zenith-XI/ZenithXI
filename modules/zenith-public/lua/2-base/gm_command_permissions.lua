-----------------------------------
-- GM Command Permission Configuration Module
-----------------------------------
-- This module provides centralized control of all GM command permission levels.
-- Modify the permission values below to change who can use each command.
--
-- PERMISSION LEVEL REFERENCE:
--   0 = Player      - All players can use (no GM level required)
--   1 = GM Level 1  - Basic GM commands (most commands)
--   2 = GM Level 2  - Slightly elevated
--   3 = GM Level 3  - Elevated (player/NPC modifications)
--   4 = GM Level 4  - Senior GM (execution, global operations)
--   5 = GM Level 5  - Admin only (dangerous/system commands)
--
-- HOW TO MODIFY PERMISSIONS:
--   1. Find the command in the appropriate category below
--   2. Change the number (0-5) to the desired permission level
--   3. Restart the server for changes to take effect
--
-- HOW TO ADD NEW COMMANDS:
--   1. Add the command name and permission level to the appropriate category
--   2. Follow the format: commandname = X,  -- Description of command
--   3. Restart the server
-----------------------------------

local m = Module:new('c_gmCmdPerms')
m:addOverride('xi.dummyFunc', function()
end)

-----------------------------------
-- Command Permission Definitions
-- Organized by functional category for easy navigation
-----------------------------------
local commandPermissions =
{
    ------------------------------------
    -- PLAYER COMMANDS (Permission 0)
    -- Available to all players
    ------------------------------------
    build                   = 0,  -- Create temporary game objects for testing
    geteffects              = 0,  -- Display all active status effects on player
    trustengage             = 0,  -- Force trusts to engage current target
    quest                   = 0,  -- List custom quest info and progress (Module: LQS)

    ------------------------------------
    -- TELEPORTATION & MOVEMENT
    ------------------------------------
    bring                   = 1,  -- Teleport target player to your location
    gmhome                  = 1,  -- Teleport to GM home location (Ru'Lude Gardens)
    ['goto']                = 1,  -- Teleport to specified coordinates or player
    gotoid                  = 1,  -- Teleport to entity by server ID
    gotoname                = 1,  -- Teleport to player by character name
    homepoint               = 1,  -- Set player's home point to current location
    pos                     = 1,  -- Teleport to exact X Y Z coordinates
    posfix                  = 1,  -- Fix player position if stuck in geometry
    speed                   = 1,  -- Set player movement speed multiplier
    wallhack                = 1,  -- Toggle collision detection (walk through walls)
    where                   = 1,  -- Display current position coordinates and zone
    zone                    = 1,  -- Teleport to specified zone by ID or name

    ------------------------------------
    -- ITEM MANAGEMENT
    ------------------------------------
    additem                 = 1,  -- Add item to your inventory with optional augments
    addtempitem             = 1,  -- Add temporary item (disappears on zone)
    addtreasure             = 1,  -- Spawn treasure chest/coffer at location
    delcontaineritems       = 1,  -- Delete all items from specific container
    delallinventory         = 1,  -- Delete all items from all inventory containers
    delitem                 = 1,  -- Delete specific item from inventory
    giveitem                = 1,  -- Give item directly to target player
    givemagianitem          = 1,  -- Give magian trial item with trial data
    hasitem                 = 1,  -- Check if player has specific item

    ------------------------------------
    -- KEY ITEMS & TITLES
    ------------------------------------
    addkeyitem              = 1,  -- Add key item to player by ID
    addtitle                = 1,  -- Add title to player by ID
    delkeyitem              = 1,  -- Remove key item from player
    haskeyitem              = 1,  -- Check if player has specific key item
    hastitle                = 1,  -- Check if player has specific title

    ------------------------------------
    -- CURRENCY
    ------------------------------------
    addcurrency             = 1,  -- Add specified currency type and amount
    delcurrency             = 1,  -- Remove specified currency type and amount
    givegil                 = 1,  -- Give gil to target player
    setgil                  = 1,  -- Set player's gil to exact amount
    takegil                 = 1,  -- Remove gil from player

    ------------------------------------
    -- SPELLS & ABILITIES
    ------------------------------------
    addallspells            = 1,  -- Learn all spells for current job
    addallweaponskills      = 1,  -- Unlock all weapon skills
    addspell                = 1,  -- Learn specific spell by ID
    addweaponskillpoints    = 1,  -- Add weapon skill points for unlock progress
    delallweaponskills      = 1,  -- Remove all unlocked weapon skills
    delspell                = 1,  -- Remove specific learned spell
    getwspoints             = 1,  -- Display current weapon skill points

    ------------------------------------
    -- JOB & SKILLS
    ------------------------------------
    capallskills            = 1,  -- Set all combat/magic skills to current cap
    capskill                = 1,  -- Set specific skill to current cap
    changejob               = 1,  -- Change player's main job
    changesjob              = 1,  -- Change player's support job
    getskill                = 1,  -- Display current skill level and cap
    masterjob               = 1,  -- Set job to level 99 with all abilities
    setskill                = 1,  -- Set specific skill to exact value

    ------------------------------------
    -- CRAFTING
    ------------------------------------
    getcraftrank            = 1,  -- Display crafting rank for specified craft
    setcraftrank            = 1,  -- Set crafting rank for specified craft

    ------------------------------------
    -- PLAYER STATS & STATUS
    ------------------------------------
    addeffect               = 1,  -- Apply status effect with duration and power
    deleffect               = 1,  -- Remove status effect by ID
    down                    = 1,  -- Force player into knocked down state
    getstats                = 1,  -- Display all player stats (STR, DEX, etc.)
    getta                   = 1,  -- Display total accuracy calculations
    godmode                 = 1,  -- Toggle invincibility and infinite resources
    hide                    = 1,  -- Toggle invisibility to other players
    hp                      = 1,  -- Set player HP to specified value
    immortal                = 1,  -- Toggle immortality (cannot die)
    mp                      = 1,  -- Set player MP to specified value
    raise                   = 1,  -- Raise player from KO state
    release                 = 1,  -- Release player from event/cutscene lock
    togglegm                = 1,  -- Toggle GM icon visibility to players
    tp                      = 1,  -- Set player TP to specified value
    up                      = 1,  -- Force player into standing state

    ------------------------------------
    -- PLAYER EXPERIENCE & PROGRESSION
    ------------------------------------
    givexp                  = 1,  -- Give experience points to player
    setcapacitypoints       = 1,  -- Set capacity points for job point system
    setjobpoints            = 1,  -- Set job points directly
    setmentor               = 1,  -- Toggle mentor status on player
    setmerits               = 1,  -- Set merit points directly
    setplayerlevel          = 1,  -- Set player's job level
    takexp                  = 1,  -- Remove experience points from player
    cp                      = 1,  -- Add conquest points to player

    ------------------------------------
    -- MISSIONS & QUESTS
    ------------------------------------
    addmission              = 1,  -- Add mission to player's mission log
    addquest                = 1,  -- Add quest to player's quest log
    checkmission            = 1,  -- Check player's current mission status
    checkmissionstatus      = 1,  -- Display detailed mission progress values
    checkquest              = 1,  -- Check player's current quest status
    completemission         = 1,  -- Mark mission as completed
    completequest           = 1,  -- Mark quest as completed
    completerecord          = 1,  -- Complete Records of Eminence objective
    delmission              = 1,  -- Remove mission from player's log
    delquest                = 1,  -- Remove quest from player's log
    getquestvar             = 1,  -- Display quest variable value
    mission                 = 1,  -- Set mission status directly
    setmissionstatus        = 1,  -- Set mission status bit flags
    setprogress             = 1,  -- Set generic progress value for content
    setquestvar             = 1,  -- Set quest variable value
    setstage                = 1,  -- Set quest/mission stage directly

    ------------------------------------
    -- PLAYER MANAGEMENT
    ------------------------------------
    afkcheck                = 1,  -- Send AFK check prompt to player
    cnation                 = 1,  -- Change player's allegiance nation
    costume                 = 1,  -- Set player's costume/model override
    costume2                = 1,  -- Set secondary costume layer
    jail                    = 1,  -- Teleport player to GM jail zone
    logoff                  = 1,  -- Force player to disconnect
    monstrosity             = 1,  -- Transform player into monster form
    pardon                  = 1,  -- Clear player's jail/penalty status
    rename                  = 1,  -- Change player's character name
    reset                   = 1,  -- Reset player state (position, status, etc.)
    setallegiance           = 1,  -- Set entity allegiance (friendly/enemy)
    setbag                  = 1,  -- Set inventory container size
    setplayermodel          = 1,  -- Change player's character model
    setplayernation         = 1,  -- Set player's home nation
    setplayervar            = 1,  -- Set character variable value
    setrank                 = 1,  -- Set player's nation rank

    ------------------------------------
    -- MOB & NPC MANAGEMENT
    ------------------------------------
    animatenpc              = 1,  -- Play animation on NPC
    animatesubnpc           = 1,  -- Play animation on NPC sub-entity
    animation               = 1,  -- Play animation on target entity
    despawnmob              = 1,  -- Force despawn mob by ID or target
    entityvisual            = 1,  -- Modify entity visual effects
    getmobaction            = 1,  -- Display mob's current action state
    getmobflags             = 1,  -- Display mob's behavior flags
    getmobmod               = 1,  -- Display mob modifier value
    mobhere                 = 1,  -- Spawn mob at your current location
    mobskill                = 1,  -- Force mob to use specific skill
    mobsub                  = 1,  -- Set mob's sub-animation/stance
    npchere                 = 1,  -- Spawn NPC at your current location
    provokeall              = 1,  -- Force all nearby mobs to aggro you
    setmobflags             = 1,  -- Set mob behavior flags
    setmoblevel             = 1,  -- Set mob's level
    spawnmob                = 1,  -- Spawn mob by pool ID

    ------------------------------------
    -- PET COMMANDS
    ------------------------------------
    petgodmode              = 1,  -- Toggle godmode for player's pet
    pettp                   = 1,  -- Set pet's TP value

    ------------------------------------
    -- MOUNTS & TRUSTS
    ------------------------------------
    addallmounts            = 1,  -- Unlock all mount types
    addalltrusts            = 1,  -- Unlock all trust NPCs
    chocobo                 = 1,  -- Spawn/manage chocobo mount
    chocoboraising          = 1,  -- Access chocobo raising interface
    mount                   = 1,  -- Mount specified creature type

    ------------------------------------
    -- SPECIAL CONTENT
    ------------------------------------
    addabytime              = 1,  -- Add time to Abyssea visitant status
    addallatma              = 1,  -- Unlock all Abyssea atma
    addallattachments       = 1,  -- Unlock all automaton attachments
    addallmaps              = 1,  -- Unlock all zone maps
    addallmonstrosity       = 1,  -- Unlock all monstrosity forms
    adddynatime             = 1,  -- Add time to Dynamis instance
    addlights               = 1,  -- Add Abyssea light values
    checkinstance           = 1,  -- Display current instance/battlefield info
    garrison                = 1,  -- Start garrison battle event
    instance                = 1,  -- Create/manage battlefield instances
    minigame                = 1,  -- Start/manage minigame events
    resetlights             = 1,  -- Reset Abyssea light values to zero
    updateconquest          = 1,  -- Force conquest update calculation

    ------------------------------------
    -- COMMUNICATION & MESSAGES
    ------------------------------------
    messagebasic            = 1,  -- Send basic system message by ID
    messagespecial          = 1,  -- Send special message with parameters
    messagestandard         = 1,  -- Send standard message by ID
    send                    = 1,  -- Send raw packet data to client
    yell                    = 1,  -- Broadcast message to entire zone

    ------------------------------------
    -- CUTSCENES & MENUS
    ------------------------------------
    cs                      = 1,  -- Play cutscene by ID
    cs2                     = 1,  -- Play cutscene with parameters
    menu                    = 1,  -- Display menu dialog to player
    menu_paginated          = 1,  -- Display paginated menu dialog

    ------------------------------------
    -- INFORMATION & DEBUGGING
    ------------------------------------
    ah                      = 1,  -- Open auction house interface anywhere
    checkinteraction        = 1,  -- Debug NPC interaction states
    checklocalvar           = 1,  -- Display local zone variable
    checkvar                = 1,  -- Display server variable value
    getfishers              = 1,  -- List all players currently fishing
    getid                   = 1,  -- Display target's entity ID
    getlocalvars            = 1,  -- Display all local variables for entity
    getprevzoneline         = 1,  -- Display previous zone line used
    inject                  = 1,  -- Inject packet for testing
    injectaction            = 1,  -- Inject action packet for testing
    posemannequin           = 1,  -- Set mannequin pose in mog house
    setmod                  = 1,  -- Set player modifier value
    setmusic                = 1,  -- Change zone background music
    setweather              = 1,  -- Change zone weather condition
    time                    = 1,  -- Display or set Vana'diel time
    uptime                  = 1,  -- Display server uptime

    ------------------------------------
    -- LINKSHELL
    ------------------------------------
    givels                  = 1,  -- Create and give linkshell to player
    promote                 = 1,  -- Promote player in linkshell rank

    ------------------------------------
    -- MODULE COMMANDS (Permission 1)
    ------------------------------------
   -- getfishmob              = 1,  -- Display fishing mob info for zone (Module: zenith-public)
   -- gmlink                  = 1,  -- Link GM to personal characters for zone restrictions (Module: zenith-public)

    ------------------------------------
    -- GM LEVEL 2 COMMANDS
    -- Slightly elevated access
    ------------------------------------
    getenmity               = 2,  -- Display detailed enmity values for target

    ------------------------------------
    -- GM LEVEL 3 COMMANDS
    -- Elevated access - player/NPC modifications
    ------------------------------------
    addfish                 = 3,  -- Add fish catch data to database
    getfame                 = 3,  -- Display player fame values by region
    getmod                  = 3,  -- Display player modifier value
    getpool                 = 3,  -- Display mob spawn pool information
    racechange              = 3,  -- Change player's race permanently
    setfamelevel            = 3,  -- Set player fame level by region
    setlocalvar             = 3,  -- Set local zone variable value
    setmobmod               = 3,  -- Set mob modifier value
    stun                    = 3,  -- Stun target for specified duration

    ------------------------------------
    -- GM LEVEL 4 COMMANDS
    -- Senior GM - execution and global operations
    ------------------------------------
    breaklinkshell          = 4,  -- Forcibly disband a linkshell
    exec                    = 4,  -- Execute Lua code string directly
    reloadglobal            = 4,  -- Reload global Lua scripts
    setbattlefieldtime      = 4,  -- Set battlefield time limit
    -- checkunlocks            = 4,  -- Check wardrobe/mog case unlocks (Module: zenith-public)

    ------------------------------------
    -- GM LEVEL 5 COMMANDS
    -- Admin only - dangerous/system commands
    ------------------------------------
    addtime                 = 5,  -- Add real time to server clock (DANGEROUS)
    crash                   = 5,  -- Intentionally crash the server (DANGEROUS)
    fafnir                  = 5,  -- Spawn Fafnir/Nidhogg (restricted NM)
    gc_full                 = 5,  -- Force full garbage collection
    gc_step                 = 5,  -- Force incremental garbage collection step
    givebonanzapearl        = 5,  -- Give Mog Bonanza pearl items
    packetmod               = 5,  -- Modify outgoing packets (DANGEROUS)
    reloadbattlefield       = 5,  -- Reload all battlefield data
    reloaddefaultactions    = 5,  -- Reload default action scripts
    reloadinteraction       = 5,  -- Reload NPC interaction scripts
    reloadnavmesh           = 5,  -- Reload zone navigation mesh
    reloadquest             = 5,  -- Reload quest scripts
    reloadrecipes           = 5,  -- Reload crafting recipe data
    sleep                   = 5,  -- Pause server execution (DANGEROUS)
}

-----------------------------------
-- Apply permissions: use our table if defined, otherwise default to 5 (admin only)
-- Commands are cached before modules load, so we iterate over xi.commands directly
-----------------------------------
for cmdName, cmd in pairs(xi.commands) do
    if cmd.cmdprops then
        local permission = commandPermissions[cmdName]
        if permission then
            cmd.cmdprops.permission = permission
        else
            cmd.cmdprops.permission = 5
        end
    end
end

return m
