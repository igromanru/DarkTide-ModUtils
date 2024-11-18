
---@class ModUtils
local ModUtils = {}

---@return OutlineSystem?
function ModUtils.get_outline_system()
    if not Managers.state or not Managers.state.extension then return nil end

	if Managers.state.extension:has_system("outline_system") then
		return Managers.state.extension:system("outline_system")
	end
    return nil
end

---@return SideSystem?
function ModUtils.get_side_system()
    if not Managers.state or not Managers.state.extension then return nil end

	if Managers.state.extension:has_system("side_system") then
		return Managers.state.extension:system("side_system")
	end
    return nil
end

---@param unit Unit
---@return Side?
function ModUtils.get_side_by_unit(unit)
	local side_system = ModUtils.get_side_system() 
	return side_system and side_system.side_by_unit[unit]
end

---@param side_id integer? Default: 1 (players side aka. "heroes")
---@return Side?
function ModUtils.get_side(side_id)
	side_id = side_id or 1

	local side_system = ModUtils.get_side_system() 
	return side_system and side_system:get_side(side_id)
end

---@param side_name string
---@return Side?
function ModUtils.get_side_by_name(side_name)
	if type(side_name) ~= "string" then return nil end

	local side_system = ModUtils.get_side_system() 
	return side_system and side_system:get_side_from_name(side_name)
end

---Get players side
---@return Side?
function ModUtils.get_heroes_side()
	return ModUtils.get_side(1)
	-- return ModUtils.get_side_by_name("heroes")
end

---Get enemies side
---@return Side?
function ModUtils.get_villains_side()
	return ModUtils.get_side(2)
	-- return ModUtils.get_side_by_name("villains")
end

---@return Unit[]
function ModUtils.get_enemy_units()
    local player_side = ModUtils.get_heroes_side()
	return player_side and player_side:relation_units("enemy") or {}
end

---@return { Unit: unknown }
function ModUtils.get_enemy_units_lookup()
    local player_side = ModUtils.get_heroes_side()
	return player_side and player_side.enemy_units_lookup or {}
end

---@param index integer? Default: 1 (my player)
---@return HumanPlayer?
function ModUtils.get_local_player(index)
	if not Managers.player then return nil end
	index = index or 1

	return Managers.player:local_player(index)
end

---@param index integer? Default: 1 (my player)
---@return Unit?
function ModUtils.get_local_player_unit(index)
    local local_player = ModUtils.get_local_player(index)
    return local_player and local_player.player_unit
end

---@param unit Unit
---@return table?
function ModUtils.get_unit_breed_tags(unit)
	if not unit then return nil end

	local enemy_unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	if enemy_unit_data_extension then
		local breed = enemy_unit_data_extension:breed()
		return breed and breed.tags
	end
	return nil
end

---Returns true if enemy is a specialist, elite, captain or monster
---@param enemy_unit Unit
---@return boolean is_threat
function ModUtils.is_threat_enemy_unit(enemy_unit)
	if not enemy_unit then return false end

	local breed_tags = ModUtils.get_unit_breed_tags(enemy_unit)
    return (breed_tags and (breed_tags.special or breed_tags.elite or breed_tags.captain or breed_tags.monster)) == true
end


return ModUtils