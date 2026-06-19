-----------------------------------
-- NPC: Jeuno Outpost Warper
-----------------------------------
-- Outpost teleporter NPC for Lower Jeuno using LQS framework.
-- Provides paginated outpost warp menu with Gil/CP payment options.
-- Features:
--   - Signet application before teleport (optional)
--   - Level and outpost unlock requirements
--   - Standard retail outpost costs
-----------------------------------

-- LQS v2.x: LQS.outpostTeleporter() now returns an onTrigger handler instead
-- of registering the NPC itself, so the NPC is declared via LQS.npc.
local m = Module:new('a-n_jeuno_outpost_warper')

LQS.npc(m, {
    ['Lower_Jeuno'] =
    {
        {
            name      = 'Outpost Warper',
            look      = 1415, -- Hume Uncle model
            pos       = { 24.1552, -1.0, 45.9046, 149 },
            onTrigger = LQS.outpostTeleporter({
                -- Apply Signet before teleport (uses rank-based duration)
                preTeleportEffects = { LQS.signetEffect() },

                -- Other defaults:
                -- greeting       = "Welcome to the Outpost Warp Service!"
                -- itemsPerPage   = 5
                -- teleportDelay  = 1250
                -- animation      = { actionID = 6, animID = 600 }
                -- outpostOverrides = {
                -- [xi.region.RONFAURE]    = { gil = 500, cp = 50 },  -- pricier
                -- [xi.region.QUFIMISLAND] = { gil = 0,   cp = 0  },  -- free
                -- [xi.region.VOLLBOW]     = { gil = 250, level = 40 }, -- cheaper + lower level req
                --},
            }),
        },
    },
})

return m
