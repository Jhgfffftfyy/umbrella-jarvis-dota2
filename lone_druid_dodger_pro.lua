local script = {}

-- Menu Configuration in Umbrella (under General -> Main -> Dodger (Lone Druid))
local tab = Menu.Create("General", "Main", "Dodger (Lone Druid)")
tab:Icon("\u{f06e}")

local sub_main = tab:Create("Main")
local group_gen = sub_main:Create("General")
local group_dodge = sub_main:Create("Dodge Settings")
local group_panel = sub_main:Create("HUD Panel")

local sub_hero = tab:Create("Lone Druid")
local group_ld = sub_hero:Create("Abilities & Save")

-- General Controls
local optEnabled = group_gen:Switch("Enable Dodger", true)
local optSound = group_gen:Switch("Sound Alert on Dodge", true)

-- Dodge Settings
local optSpells = group_dodge:Switch("Dodge Spells & Projectiles", true)
local optInstantDispel = group_dodge:Switch("Instant Dispel Stuns & Roots", true)

-- Lone Druid Controls
local optTrueForm = group_ld:Switch("Use True Form to Dodge / Dispel", true)
local optLowHp = group_ld:Switch("Auto-Save on Low HP (True Form)", true)
local optHpSlider = group_ld:Slider("Low HP Threshold", 10, 60, 30, "%d%%")
local optRoar = group_ld:Switch("Emergency Savage Roar (Hero & Bear)", true)
local optRoarHp = group_ld:Slider("Roar HP Threshold", 10, 45, 25, "%d%%")

-- HUD Panel Controls
local optShowPanel = group_panel:Switch("Show On-Screen Window", true)
local optLockPanel = group_panel:Switch("Lock Position", false)
local s_panelX = group_panel:Slider("Panel X", 0, 2560, 1400, "%d px")
local s_panelY = group_panel:Slider("Panel Y", 0, 1440, 250, "%d px")

-- 205 ACTIVE DANGEROUS SPELLS FROM UMBRELLA DODGER DATABASE
local DANGEROUS_SPELLS = {
    ["abyssal_underlord_pit_of_malice"] = { type = "target", range = 950 },
    ["alchemist_unstable_concoction_throw"] = { type = "target", range = 950 },
    ["ancient_apparition_chilling_touch"] = { type = "target", range = 950 },
    ["ancient_apparition_cold_feet"] = { type = "target", range = 950 },
    ["ancient_apparition_ice_blast"] = { type = "target", range = 950 },
    ["antimage_blink"] = { type = "target", range = 950 },
    ["antimage_mana_void"] = { type = "target", range = 950 },
    ["arc_warden_spark_wraith"] = { type = "target", range = 950 },
    ["axe_berserkers_call"] = { type = "aoe", range = 550 },
    ["bane_brain_sap"] = { type = "target", range = 950 },
    ["bane_enfeeble"] = { type = "target", range = 950 },
    ["bane_fiends_grip"] = { type = "target", range = 950 },
    ["bane_nightmare"] = { type = "target", range = 950 },
    ["batrider_flamebreak"] = { type = "target", range = 950 },
    ["batrider_flaming_lasso"] = { type = "target", range = 950 },
    ["beastmaster_primal_roar"] = { type = "target", range = 950 },
    ["bloodseeker_rupture"] = { type = "target", range = 950 },
    ["bounty_hunter_shuriken_toss"] = { type = "target", range = 950 },
    ["brewmaster_cinder_brew"] = { type = "target", range = 950 },
    ["brewmaster_earth_hurl_boulder"] = { type = "target", range = 950 },
    ["brewmaster_storm_cyclone"] = { type = "target", range = 950 },
    ["brewmaster_thunder_clap"] = { type = "target", range = 950 },
    ["broodmother_spawn_spiderlings"] = { type = "target", range = 950 },
    ["centaur_double_edge"] = { type = "target", range = 950 },
    ["centaur_hoof_stomp"] = { type = "aoe", range = 550 },
    ["chaos_knight_chaos_bolt"] = { type = "target", range = 950 },
    ["chaos_knight_reality_rift"] = { type = "aoe", range = 550 },
    ["chen_penitence"] = { type = "target", range = 950 },
    ["crystal_maiden_crystal_nova"] = { type = "aoe", range = 550 },
    ["crystal_maiden_frostbite"] = { type = "target", range = 950 },
    ["dark_willow_cursed_crown"] = { type = "target", range = 950 },
    ["dark_willow_terrorize"] = { type = "target", range = 950 },
    ["dawnbreaker_fire_wreath"] = { type = "target", range = 950 },
    ["dawnbreaker_solar_guardian"] = { type = "target", range = 950 },
    ["dazzle_poison_touch"] = { type = "target", range = 950 },
    ["death_prophet_carrion_swarm"] = { type = "target", range = 950 },
    ["death_prophet_silence"] = { type = "target", range = 950 },
    ["death_prophet_spirit_siphon"] = { type = "target", range = 950 },
    ["disruptor_glimpse"] = { type = "target", range = 950 },
    ["disruptor_static_storm"] = { type = "target", range = 950 },
    ["disruptor_thunder_strike"] = { type = "target", range = 950 },
    ["doom_bringer_doom"] = { type = "target", range = 950 },
    ["dragon_knight_breathe_fire"] = { type = "target", range = 950 },
    ["dragon_knight_dragon_tail"] = { type = "target", range = 950 },
    ["drow_ranger_wave_of_silence"] = { type = "linear", range = 1050 },
    ["earth_spirit_boulder_smash"] = { type = "target", range = 950 },
    ["earth_spirit_geomagnetic_grip"] = { type = "target", range = 950 },
    ["earth_spirit_rolling_boulder"] = { type = "target", range = 950 },
    ["elder_titan_earth_splitter"] = { type = "target", range = 950 },
    ["ember_spirit_searing_chains"] = { type = "target", range = 950 },
    ["enchantress_enchant"] = { type = "target", range = 950 },
    ["enchantress_impetus"] = { type = "target", range = 950 },
    ["enigma_black_hole"] = { type = "aoe", range = 550 },
    ["enigma_malefice"] = { type = "target", range = 950 },
    ["faceless_void_chronosphere"] = { type = "aoe", range = 550 },
    ["frogmen_congregation_of_the_deep"] = { type = "target", range = 950 },
    ["grimstroke_ink_creature"] = { type = "target", range = 950 },
    ["grimstroke_soul_chain"] = { type = "target", range = 950 },
    ["grimstroke_spirit_walk"] = { type = "target", range = 950 },
    ["gyrocopter_call_down"] = { type = "aoe", range = 550 },
    ["gyrocopter_homing_missile"] = { type = "target", range = 950 },
    ["hoodwink_bushwhack"] = { type = "target", range = 950 },
    ["hoodwink_sharpshooter"] = { type = "target", range = 950 },
    ["huskar_inner_fire"] = { type = "target", range = 950 },
    ["huskar_life_break"] = { type = "target", range = 950 },
    ["invoker_cold_snap"] = { type = "target", range = 950 },
    ["invoker_deafening_blast"] = { type = "target", range = 950 },
    ["invoker_emp"] = { type = "target", range = 950 },
    ["item_blink"] = { type = "target", range = 950 },
    ["item_ethereal_blade"] = { type = "target", range = 950 },
    ["item_harpoon"] = { type = "target", range = 950 },
    ["item_heavens_halberd"] = { type = "target", range = 950 },
    ["item_meteor_hammer"] = { type = "target", range = 950 },
    ["item_nullifier"] = { type = "target", range = 950 },
    ["item_rod_of_atos"] = { type = "target", range = 950 },
    ["jakiro_ice_path"] = { type = "target", range = 950 },
    ["keeper_of_the_light_illuminate"] = { type = "target", range = 950 },
    ["keeper_of_the_light_radiant_bind"] = { type = "target", range = 950 },
    ["kez_grappling_claw"] = { type = "target", range = 950 },
    ["kez_kazurai_katana"] = { type = "target", range = 950 },
    ["kez_talon_toss"] = { type = "target", range = 950 },
    ["kunkka_ghostship"] = { type = "target", range = 950 },
    ["kunkka_x_marks_the_spot"] = { type = "target", range = 950 },
    ["largo_catchy_lick"] = { type = "target", range = 950 },
    ["legion_commander_duel"] = { type = "target", range = 950 },
    ["legion_commander_overwhelming_odds"] = { type = "target", range = 950 },
    ["leshrac_lightning_storm"] = { type = "target", range = 950 },
    ["leshrac_split_earth"] = { type = "target", range = 950 },
    ["lich_chain_frost"] = { type = "target", range = 950 },
    ["lich_frost_nova"] = { type = "aoe", range = 550 },
    ["life_stealer_infest"] = { type = "target", range = 950 },
    ["life_stealer_open_wounds"] = { type = "target", range = 950 },
    ["lina_dragon_slave"] = { type = "target", range = 950 },
    ["lina_laguna_blade"] = { type = "target", range = 950 },
    ["lina_light_strike_array"] = { type = "target", range = 950 },
    ["lion_finger_of_death"] = { type = "target", range = 950 },
    ["lion_impale"] = { type = "linear", range = 1050 },
    ["lone_druid_savage_roar"] = { type = "target", range = 950 },
    ["luna_lucent_beam"] = { type = "target", range = 950 },
    ["magnataur_horn_toss"] = { type = "target", range = 950 },
    ["magnataur_reverse_polarity"] = { type = "aoe", range = 550 },
    ["magnataur_skewer"] = { type = "target", range = 950 },
    ["marci_companion_run"] = { type = "target", range = 950 },
    ["marci_grapple"] = { type = "target", range = 950 },
    ["mars_gods_rebuke"] = { type = "target", range = 950 },
    ["mars_spear"] = { type = "target", range = 950 },
    ["medusa_mystic_snake"] = { type = "target", range = 950 },
    ["meepo_earthbind"] = { type = "target", range = 950 },
    ["meepo_poof"] = { type = "target", range = 950 },
    ["mirana_arrow"] = { type = "linear", range = 1050 },
    ["mirana_starfall"] = { type = "target", range = 950 },
    ["monkey_king_boundless_strike"] = { type = "target", range = 950 },
    ["morphling_adaptive_strike_agi"] = { type = "target", range = 950 },
    ["morphling_adaptive_strike_str"] = { type = "target", range = 950 },
    ["morphling_replicate"] = { type = "target", range = 950 },
    ["muerta_dead_shot"] = { type = "target", range = 950 },
    ["muerta_parting_shot"] = { type = "target", range = 950 },
    ["naga_siren_ensnare"] = { type = "target", range = 950 },
    ["necrolyte_reapers_scythe"] = { type = "target", range = 950 },
    ["nevermore_requiem"] = { type = "target", range = 950 },
    ["nevermore_shadowraze2"] = { type = "target", range = 950 },
    ["nevermore_shadowraze3"] = { type = "target", range = 950 },
    ["night_stalker_void"] = { type = "target", range = 950 },
    ["nyx_assassin_impale"] = { type = "linear", range = 1050 },
    ["nyx_assassin_vendetta"] = { type = "target", range = 950 },
    ["obsidian_destroyer_astral_imprisonment"] = { type = "target", range = 950 },
    ["obsidian_destroyer_sanity_eclipse"] = { type = "target", range = 950 },
    ["ogre_magi_fireblast"] = { type = "target", range = 950 },
    ["ogre_magi_ignite"] = { type = "target", range = 950 },
    ["ogre_magi_unrefined_fireblast"] = { type = "target", range = 950 },
    ["oracle_purifying_flames"] = { type = "target", range = 950 },
    ["pangolier_shield_crash"] = { type = "target", range = 950 },
    ["phantom_assassin_phantom_strike"] = { type = "target", range = 950 },
    ["phantom_lancer_spirit_lance"] = { type = "target", range = 950 },
    ["phoenix_supernova"] = { type = "aoe", range = 550 },
    ["primal_beast_pulverize"] = { type = "target", range = 950 },
    ["primal_beast_rock_throw"] = { type = "target", range = 950 },
    ["puck_dream_coil"] = { type = "target", range = 950 },
    ["puck_waning_rift"] = { type = "aoe", range = 550 },
    ["pudge_dismember"] = { type = "target", range = 950 },
    ["pudge_meat_hook"] = { type = "linear", range = 1050 },
    ["pugna_decrepify"] = { type = "target", range = 950 },
    ["pugna_life_drain"] = { type = "target", range = 950 },
    ["queenofpain_blink"] = { type = "target", range = 950 },
    ["queenofpain_scream_of_pain"] = { type = "target", range = 950 },
    ["queenofpain_shadow_strike"] = { type = "target", range = 950 },
    ["rattletrap_hookshot"] = { type = "linear", range = 1050 },
    ["razor_static_link"] = { type = "target", range = 950 },
    ["riki_blink_strike"] = { type = "target", range = 950 },
    ["riki_smoke_screen"] = { type = "target", range = 950 },
    ["ringmaster_tame_the_beasts"] = { type = "target", range = 950 },
    ["rubick_fade_bolt"] = { type = "target", range = 950 },
    ["rubick_telekinesis"] = { type = "target", range = 950 },
    ["sandking_scorpion_strike"] = { type = "target", range = 950 },
    ["shadow_demon_demonic_purge"] = { type = "target", range = 950 },
    ["shadow_demon_disruption"] = { type = "target", range = 950 },
    ["shadow_demon_disseminate"] = { type = "target", range = 950 },
    ["shadow_shaman_ether_shock"] = { type = "target", range = 950 },
    ["shadow_shaman_shackles"] = { type = "target", range = 950 },
    ["skeleton_king_hellfire_blast"] = { type = "target", range = 950 },
    ["slardar_slithereen_crush"] = { type = "aoe", range = 550 },
    ["slark_pounce"] = { type = "target", range = 950 },
    ["snapfire_firesnap_cookie"] = { type = "target", range = 950 },
    ["snapfire_scatterblast"] = { type = "target", range = 950 },
    ["sniper_assassinate"] = { type = "target", range = 950 },
    ["sniper_concussive_grenade"] = { type = "target", range = 950 },
    ["spectre_spectral_dagger"] = { type = "target", range = 950 },
    ["spirit_breaker_charge_of_darkness"] = { type = "target", range = 950 },
    ["spirit_breaker_nether_strike"] = { type = "target", range = 950 },
    ["storm_spirit_electric_vortex"] = { type = "target", range = 950 },
    ["sven_storm_bolt"] = { type = "target", range = 950 },
    ["techies_mutually_assured_destruction"] = { type = "target", range = 950 },
    ["techies_reactive_tazer"] = { type = "target", range = 950 },
    ["techies_sticky_bomb"] = { type = "target", range = 950 },
    ["techies_suicide"] = { type = "target", range = 950 },
    ["templar_assassin_meld"] = { type = "target", range = 950 },
    ["terrorblade_sunder"] = { type = "target", range = 950 },
    ["tidehunter_anchor_smash"] = { type = "target", range = 950 },
    ["tidehunter_dead_in_the_water"] = { type = "target", range = 950 },
    ["tidehunter_gush"] = { type = "target", range = 950 },
    ["tidehunter_ravage"] = { type = "aoe", range = 550 },
    ["tinker_laser"] = { type = "target", range = 950 },
    ["tinker_warp_grenade"] = { type = "target", range = 950 },
    ["tiny_avalanche"] = { type = "target", range = 950 },
    ["tiny_toss"] = { type = "target", range = 950 },
    ["tiny_toss_tree"] = { type = "target", range = 950 },
    ["treant_leech_seed"] = { type = "target", range = 950 },
    ["tusk_snowball"] = { type = "target", range = 950 },
    ["tusk_walrus_kick"] = { type = "target", range = 950 },
    ["tusk_walrus_punch"] = { type = "target", range = 950 },
    ["undying_decay"] = { type = "target", range = 950 },
    ["undying_soul_rip"] = { type = "target", range = 950 },
    ["vengefulspirit_magic_missile"] = { type = "target", range = 950 },
    ["vengefulspirit_nether_swap"] = { type = "target", range = 950 },
    ["venomancer_noxious_plague"] = { type = "target", range = 950 },
    ["venomancer_venomous_gale"] = { type = "target", range = 950 },
    ["visage_grave_chill"] = { type = "target", range = 950 },
    ["visage_soul_assumption"] = { type = "target", range = 950 },
    ["warlock_rain_of_chaos"] = { type = "target", range = 950 },
    ["warlock_shadow_word"] = { type = "target", range = 950 },
    ["windrunner_powershot"] = { type = "target", range = 950 },
    ["windrunner_shackleshot"] = { type = "target", range = 950 },
    ["winter_wyvern_winters_curse"] = { type = "target", range = 950 },
    ["zuus_arc_lightning"] = { type = "target", range = 950 },
    ["zuus_thundergods_wrath"] = { type = "target", range = 950 },
}

-- PARTICLES MATCHING FLYING PROJECTILES & GROUND SPIKES
local DANGEROUS_PARTICLES = {
    "impale", "lion_spell_impale", "lion_spell_finger_of_death", "storm_hammer",
    "magic_missile", "chaos_bolt", "hellfireblast", "skeletonking_hellfireblast",
    "dragon_tail", "fireblast", "paralyzing_cask", "unstable_concoction",
    "assassinate", "chain_frost", "winters_curse", "dagon", "ethereal_blade",
    "finger_of_death", "laguna_blade", "reapers_scythe", "walrus_punch",
    "stifling_dagger", "phantom_strike", "viper_strike", "shadow_strike",
    "shackleshot", "dead_shot", "nether_strike", "primal_roar", "concussive_shot",
    "arcane_bolt", "laser", "shuriken_toss", "spirit_breaker_charge",
    "torrent", "burrowstrike", "ice_path", "meat_hook", "fissure"
}

local lastOrderTime = 0
local lastRoarTime = 0
local lastDodgedSpell = "None"
local lastDodgedTime = 0

-- UI Dragging State
local uiState = {
    dragging = false,
    dragOffset = Vec2(0, 0),
    panelSize = Vec2(270, 120)
}

local function now()
    return GameRules and GameRules.GetGameTime and GameRules.GetGameTime() or 0
end

-- True Form can be cast during Stun, Root, Sleep, Taunt, Disarm!
-- Only Silence/Hex blocks it in Dota 2.
local function isTrueFormReady(hero, ability)
    if not ability or not hero then return false end
    if Ability.GetLevel(ability) == 0 then return false end
    if Ability.GetCooldown(ability) > 0 then return false end
    if NPC.GetMana(hero) < Ability.GetManaCost(ability) then return false end
    if NPC.HasModifier(hero, "modifier_lone_druid_true_form") then return false end
    if NPC.IsSilenced(hero) then return false end
    return true
end

local function getSpiritBear(hero)
    local ability = NPC.GetAbility(hero, "lone_druid_spirit_bear")
    if not ability then return nil end
    if CustomEntities and CustomEntities.GetSpiritBear then
        local b = CustomEntities.GetSpiritBear(ability)
        if b and NPCs.Contains(b) and Entity.IsAlive(b) then return b end
    end
    for _, u in ipairs(NPCs.GetAll()) do
        if u and Entity.IsAlive(u) and Entity.GetOwner(u) == hero then
            local name = NPC.GetUnitName(u)
            if name and name:find("lone_druid_bear") then
                return u
            end
        end
    end
    return nil
end

local function castTrueForm(ability, reason)
    local t = now()
    if t < lastOrderTime then return false end
    if not ability then return false end

    Ability.CastNoTarget(ability, false, false, true, "ld_dodger_true_form")
    lastOrderTime = t + 0.35
    lastDodgedSpell = reason or "Dangerous Action"
    lastDodgedTime = t
    if Log and Log.Write then
        Log.Write(string.format("[DODGER PRO] TRUE FORM CAST! Reason: %s", lastDodgedSpell))
    end
    return true
end

local function castSavageRoar(hero, bear, reason)
    local t = now()
    if t < lastRoarTime then return false end

    if hero and not NPC.IsStunned(hero) and not NPC.IsSilenced(hero) then
        local roar = NPC.GetAbility(hero, "lone_druid_savage_roar")
        if roar and Ability.GetCooldown(roar) == 0 and NPC.GetMana(hero) >= Ability.GetManaCost(roar) then
            Ability.CastNoTarget(roar, false, false, true, "ld_roar_hero")
            lastRoarTime = t + 0.5
            lastDodgedSpell = "Savage Roar (Hero): " .. (reason or "")
            lastDodgedTime = t
            return true
        end
    end

    if bear and Entity.IsAlive(bear) and not NPC.IsStunned(bear) and not NPC.IsSilenced(bear) then
        local roar = NPC.GetAbility(bear, "lone_druid_savage_roar")
        if roar and Ability.GetCooldown(roar) == 0 and NPC.GetMana(bear) >= Ability.GetManaCost(roar) then
            Ability.CastNoTarget(roar, false, false, true, "ld_roar_bear")
            lastRoarTime = t + 0.5
            lastDodgedSpell = "Savage Roar (Bear): " .. (reason or "")
            lastDodgedTime = t
            return true
        end
    end

    return false
end

-- 1. TRACKING PROJECTILE CALLBACK
function script.OnTrackingProjectileCreate(data)
    if not optEnabled:Get() or not optSpells:Get() then return end
    local hero = Heroes.GetLocal()
    if not hero or NPC.GetUnitName(hero) ~= "npc_dota_hero_lone_druid" then return end
    if not Entity.IsAlive(hero) or Entity.IsDormant(hero) then return end

    if data and data.target and data.target == hero then
        local trueForm = NPC.GetAbility(hero, "lone_druid_true_form")
        if optTrueForm:Get() and isTrueFormReady(hero, trueForm) then
            castTrueForm(trueForm, "Flying Tracking Projectile")
        end
    end
end

-- 2. PARTICLE CALLBACK (Ground waves, spells & flying particles)
function script.OnParticleCreate(data)
    if not optEnabled:Get() or not optSpells:Get() then return end
    local hero = Heroes.GetLocal()
    if not hero or NPC.GetUnitName(hero) ~= "npc_dota_hero_lone_druid" then return end
    if not Entity.IsAlive(hero) or Entity.IsDormant(hero) then return end

    local name = (data.fullName or data.name or ""):lower()
    if name == "" then return end

    local isDangerous = false
    for _, pattern in ipairs(DANGEROUS_PARTICLES) do
        if name:find(pattern) then
            isDangerous = true
            break
        end
    end
    if not isDangerous then return end

    local trueForm = NPC.GetAbility(hero, "lone_druid_true_form")
    if not optTrueForm:Get() or not isTrueFormReady(hero, trueForm) then return end

    local myPos = Entity.GetAbsOrigin(hero)
    local isTargetingMe = false

    if data.entity and data.entity == hero then
        isTargetingMe = true
    elseif data.target and data.target == hero then
        isTargetingMe = true
    elseif data.position and myPos:Distance2D(data.position) <= 850 then
        isTargetingMe = true
    else
        if data.entity and Entity.IsHero(data.entity) and Entity.GetTeamNum(data.entity) ~= Entity.GetTeamNum(hero) then
            local enemyPos = Entity.GetAbsOrigin(data.entity)
            if myPos:Distance2D(enemyPos) <= 1200 then
                isTargetingMe = true
            end
        end
    end

    if isTargetingMe then
        castTrueForm(trueForm, "Flying Particle: " .. name)
    end
end

-- 3. PARTICLE UPDATE ENTITY
function script.OnParticleUpdateEntity(data)
    if not optEnabled:Get() or not optSpells:Get() then return end
    local hero = Heroes.GetLocal()
    if not hero or NPC.GetUnitName(hero) ~= "npc_dota_hero_lone_druid" then return end
    if not Entity.IsAlive(hero) or Entity.IsDormant(hero) then return end

    if data.entity and data.entity == hero then
        local trueForm = NPC.GetAbility(hero, "lone_druid_true_form")
        if optTrueForm:Get() and isTrueFormReady(hero, trueForm) then
            castTrueForm(trueForm, "Particle Lock onto Hero")
        end
    end
end

-- 4. TICK UPDATE
function script.OnUpdate()
    if not optEnabled:Get() then return end

    local hero = Heroes.GetLocal()
    if not hero or NPC.GetUnitName(hero) ~= "npc_dota_hero_lone_druid" then return end
    if not Entity.IsAlive(hero) or Entity.IsDormant(hero) then return end

    local t = now()
    if t < lastOrderTime then return end

    local myTeam = Entity.GetTeamNum(hero)
    local myPos = Entity.GetAbsOrigin(hero)
    local hpPct = (Entity.GetHealth(hero) / math.max(1, Entity.GetMaxHealth(hero))) * 100
    local trueForm = NPC.GetAbility(hero, "lone_druid_true_form")
    local bear = getSpiritBear(hero)
    local readyTrueForm = optTrueForm:Get() and isTrueFormReady(hero, trueForm)

    -- A. INSTANT DISPEL: When Stunned / Rooted -> True Form can be cast to Dispel!
    if optInstantDispel:Get() and readyTrueForm then
        if NPC.IsStunned(hero) or NPC.IsRooted(hero) then
            if castTrueForm(trueForm, "Instant Dispel on Stun/Root") then
                return
            end
        end
    end

    -- B. Emergency Savage Roar
    if optRoar:Get() then
        if hpPct <= optRoarHp:Get() or NPC.IsStunned(hero) or NPC.IsRooted(hero) then
            local enemyNear = false
            for _, enemy in ipairs(Heroes.GetAll()) do
                if Entity.IsHero(enemy) and Entity.IsAlive(enemy) and not Entity.IsDormant(enemy) 
                   and Entity.GetTeamNum(enemy) ~= myTeam and not NPC.IsIllusion(enemy) then
                    local ePos = Entity.GetAbsOrigin(enemy)
                    if myPos:Distance2D(ePos) <= 450 then
                        enemyNear = true
                        break
                    end
                end
            end
            if enemyNear then
                castSavageRoar(hero, bear, "Emergency Near Threat")
            end
        end
    end

    -- C. DODGE ENEMY CAST PHASE (BEFORE IT HITS!)
    if optSpells:Get() and readyTrueForm then
        for _, enemy in ipairs(Heroes.GetAll()) do
            if Entity.IsHero(enemy) and Entity.IsAlive(enemy) and not Entity.IsDormant(enemy)
               and Entity.GetTeamNum(enemy) ~= myTeam and not NPC.IsIllusion(enemy) then
                local ePos = Entity.GetAbsOrigin(enemy)
                local dist = myPos:Distance2D(ePos)

                if dist <= 1400 then
                    local rot = Entity.GetRotation(enemy)
                    local forward = rot and rot.GetForward and rot:GetForward()
                    local isFacingMe = false
                    if forward then
                        local toMe = (myPos - ePos)
                        local len = toMe:Length2D()
                        if len > 0 then
                            local dot = (forward.x * toMe.x + forward.y * toMe.y) / len
                            if dot > 0.55 then
                                isFacingMe = true
                            end
                        end
                    else
                        isFacingMe = true
                    end

                    for i = 0, 31 do
                        local ab = NPC.GetAbilityByIndex(enemy, i)
                        if ab and Ability.IsInAbilityPhase(ab) then
                            local abName = Ability.GetName(ab)
                            local spellInfo = DANGEROUS_SPELLS[abName]

                            if spellInfo then
                                if spellInfo.type == "target" or spellInfo.type == "linear" then
                                    if isFacingMe and dist <= (spellInfo.range + 150) then
                                        if castTrueForm(trueForm, "DODGE BEFORE HIT: " .. abName) then
                                            return
                                        end
                                    end
                                elseif spellInfo.type == "aoe" then
                                    if dist <= (spellInfo.radius + 150) then
                                        if castTrueForm(trueForm, "DODGE AOE BEFORE HIT: " .. abName) then
                                            return
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- D. LOW HP AUTO-SAVE
    if optLowHp:Get() and readyTrueForm and hpPct <= optHpSlider:Get() then
        local threatNearby = false
        for _, enemy in ipairs(Heroes.GetAll()) do
            if Entity.IsHero(enemy) and Entity.IsAlive(enemy) and not Entity.IsDormant(enemy) 
               and Entity.GetTeamNum(enemy) ~= myTeam and not NPC.IsIllusion(enemy) then
                if myPos:Distance2D(Entity.GetAbsOrigin(enemy)) <= 1200 then
                    threatNearby = true
                    break
                end
            end
        end
        if threatNearby then
            if castTrueForm(trueForm, string.format("Low HP Save (%.0f%%)", hpPct)) then
                return
            end
        end
    end
end

-- 5. FLOATING HUD PANEL (Render.FilledRect, Render.Text, Draggable)
function script.OnDraw()
    if not optEnabled:Get() or not optShowPanel:Get() then return end
    local hero = Heroes.GetLocal()
    if not hero or NPC.GetUnitName(hero) ~= "npc_dota_hero_lone_druid" then return end

    local pos = Vec2(s_panelX:Get(), s_panelY:Get())
    local size = uiState.panelSize

    -- Handle Dragging with Left Mouse Button
    if not optLockPanel:Get() and Input and Input.IsKeyDown and Input.GetCursorPos and Input.IsCursorInRect then
        if Input.IsKeyDown(Enum.ButtonCode.KEY_MOUSE1) then
            local cursor = Vec2(Input.GetCursorPos())
            if not uiState.dragging and Input.IsCursorInRect(pos.x, pos.y, size.x, size.y) then
                uiState.dragging = true
                uiState.dragOffset = cursor - pos
            elseif uiState.dragging then
                local newPos = cursor - uiState.dragOffset
                s_panelX:Set(math.floor(newPos.x))
                s_panelY:Set(math.floor(newPos.y))
                pos = newPos
            end
        else
            uiState.dragging = false
        end
    end

    -- Draw Main Panel Box (Dark sleek theme)
    local bgColor = Color(15, 17, 24, 235)
    local borderColor = Color(55, 65, 85, 255)
    local headerColor = Color(24, 28, 40, 255)

    if Render and Render.FilledRect then
        -- Background & Border
        Render.FilledRect(pos, pos + size, bgColor, 8, Enum.DrawFlags and Enum.DrawFlags.RoundCornersAll or 0)
        Render.FilledRect(pos, pos + Vec2(size.x, 26), headerColor, 8, Enum.DrawFlags and Enum.DrawFlags.RoundCornersTop or 0)

        -- Header Text
        Render.Text(nil, 13, "DODGER: LONE DRUID", pos + Vec2(12, 6), Color(255, 200, 80, 255))

        -- Status Indicator dot
        local trueForm = NPC.GetAbility(hero, "lone_druid_true_form")
        local ready = isTrueFormReady(hero, trueForm)
        local statusColor = ready and Color(80, 235, 120, 255) or Color(235, 80, 80, 255)
        local statusText = ready and "READY" or (NPC.HasModifier(hero, "modifier_lone_druid_true_form") and "BEAR" or "CD")
        Render.FilledRect(pos + Vec2(size.x - 65, 9), pos + Vec2(size.x - 57, 17), statusColor, 4, 0)
        Render.Text(nil, 11, statusText, pos + Vec2(size.x - 50, 7), statusColor)

        -- Body Lines
        local isBear = NPC.HasModifier(hero, "modifier_lone_druid_true_form")
        local formStr = isBear and "Form: Bear (True Form Active)" or "Form: Human (Ready to Dodge)"
        Render.Text(nil, 12, formStr, pos + Vec2(12, 34), Color(210, 220, 240, 255))

        local bear = getSpiritBear(hero)
        local bearStr = (bear and Entity.IsAlive(bear)) and "Bear: Alive (Roar Ready)" or "Bear: Not Summoned / Dead"
        Render.Text(nil, 12, bearStr, pos + Vec2(12, 54), Color(160, 180, 205, 255))

        local lastStr = "Last Dodge: " .. tostring(lastDodgedSpell)
        if #lastStr > 32 then lastStr = lastStr:sub(1, 32) .. ".." end
        Render.Text(nil, 11, lastStr, pos + Vec2(12, 76), Color(255, 170, 70, 255))

        local helpStr = "[Left Click & Drag to move]"
        Render.Text(nil, 10, helpStr, pos + Vec2(12, 98), Color(110, 125, 150, 200))
    end
end

return script
