---@meta

--- All the data that gets saved by Kristal when the player saves their game
---
---@class SaveData
---@field chapter integer
---@field name string
---@field level integer
---@field playtime number
---@field light boolean
---@field room_name string
---@field room_id string
---@field money integer
---@field xp integer
---@field tension number
---@field max_tension number
---@field lw_money integer
---@field level_up_count integer
---@field border string
---@field temp_followers table<[string, number]|string>
---@field flags table<string, any>
---@field spawn_marker string
---@field spawn_position {x: number, y: number}
---@field party string[]
---@field inventory {storage_enabled: boolean, storages: table}
---@field dark_inventory {storage_enabled: boolean, storages: table}
---@field light_inventory {storage_enabled: boolean, storages: table}
---@field party_data PartyMemberSaveData[]
---@field recruits_data RecruitSaveData[]

--- Item data in the format it is saved to file
---
---@class ItemSaveData
---@field id string?
---@field flags table<string, any>
---@field dark_item ItemSaveData
---@field light_item ItemSaveData
---@field dark_location table
---@field light_location table

--- Recruit data in the format it is saved to file
---
---@class RecruitSaveData
---@field id string?
---@field recruited integer|boolean
---@field hidden boolean?

--- Party Member data in the format it is saved to file
---
---@class PartyMemberSaveData
---@field id string?
---@field title string
---@field level integer
---@field health integer
---@field stats {magic: integer, defense: integer, attack: integer, health: integer}
---@field lw_lv integer
---@field lw_exp integer
---@field lw_health integer
---@field lw_stats {attack: integer, defense: integer, health: integer}
---@field spells string[]
---@field equipped {weapon: ItemSaveData, armor: [ItemSaveData, ItemSaveData]}
---@field flags table<string, any>
