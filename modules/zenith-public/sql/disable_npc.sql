-- ------------------------------
-- Disable Specific NPCs
-- Public Module for ZenithXI
-- ------------------------------

-- List of NPCs to remove, status 3 is invisible and cannot be targetted by player,
-- widescan 0 means they won't show up on widescan
UPDATE `npc_list`
SET status = 3,
    widescan = 0
WHERE BINARY `name` IN
(
    'Arbitrix',
    'Bountibox',
    'Delivery_Crate',
    'Falgima',
    'Funtrox',
    'Habitox',
    'Hunt_Registry',
    'Magian_Moogle',
    'Magian_Moogle_Blue',
    'Magian_Moogle_Green',
    'Magian_Moogle_Orange',
    'MandragoraAssi',
    'Mapitoto',
    'Mystrix',
    'Priztrix',
    'Rewardox',
    'Specilox',
    'Splintery_Chest',
    'Survival_Guide',
    'Sweepstox',
    'Symphonic_Curator',
    'Syrillia',
    'Theraisie',
    'Winrix',
    'Wondrix'
)
-- Treasure Coffers associated with Gobbie Mystery NPCs
OR npcid IN (
    SELECT original_npc.npcid + 1
    FROM (
        SELECT npcid
        FROM `npc_list`
        WHERE BINARY `name` IN
        (
            'Arbitrix',
            'Bountibox',
            'Funtrox',
            'Habitox',
            'Mystrix',
            'Priztrix',
            'Rewardox',
            'Specilox',
            'Sweepstox',
            'Winrix',
            'Wondrix'
        )
    ) AS original_npc
);
