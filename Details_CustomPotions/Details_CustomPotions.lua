local potionUsed = {
	name = "Potion Used",
	icon = [[Interface\Icons\INV_Alchemy_Elixir_02]],
	source = false,
	attribute = false,
	spellid = false,
	target = false,
	author = "fxpw",
	desc = "Shows who uses potions",
	script_version = 7,
	script = [[
		--init:
		local combat, instance_container, instance = ...
		local total, top, amount = 0, 0, 0

		--get the misc actor container
		local misc_container = combat:GetActorList( DETAILS_ATTRIBUTE_MISC )

		--do the loop:
		for _, player in ipairs( misc_container ) do
			
			--only player in group
			if(player:IsGroupPlayer()) then
				
				local found_potion = false
				
				--get the spell debuff uptime container
				local debuff_uptime_container = player.debuff_uptime and player.debuff_uptime_spells and player.debuff_uptime_spells._ActorTable
				if(debuff_uptime_container) then
					--potion of focus(can't use as pre-potion, so, its amount is always 1
					local focus_potion = debuff_uptime_container[DETAILS_FOCUS_POTION_ID]
					
					if(focus_potion) then
						total = total + 1
						found_potion = true
						if(top < 1) then
							top = 1
						end
						--add amount to the player
						instance_container:AddValue(player, 1)
					end
				end
				
				--get the spell buff uptime container
				local buff_uptime_container = player.buff_uptime and player.buff_uptime_spells and player.buff_uptime_spells._ActorTable
				if(buff_uptime_container) then
					for spellId, _ in pairs(DetailsFramework.PotionIDs) do
						local potionUsed = buff_uptime_container[spellId]
						-- print(spellId)
						
						if(potionUsed) then
							-- print(GetSpellInfo(spellId))
							local used = potionUsed.activedamt
							if(used and used > 0) then
								total = total + used
								found_potion = true
								if(used > top) then
									top = used
								end
								
								--add amount to the player
								instance_container:AddValue(player, used)
							end
						end
					end
				end
				-- print('-------')
				
				if(found_potion) then
					amount = amount + 1
				end
			end
		end
		---------------
		local AllHealCharacters = combat:GetActorList(DETAILS_ATTRIBUTE_HEAL)
		for index, character in ipairs(AllHealCharacters) do
			local AllSpells = character:GetSpellList()
			local found = false
			for spellid, spell in pairs(AllSpells) do
				if(DETAILS_CUSTOM_POILO[spellid]) then
					instance_container:AddValue(character, 1)
					total = total + spell.total
					if(top < spell.total) then
						top = spell.total
					end
					found = true
				end
			end
			
			if(found) then
				amount = amount + 1
			end
		end


		--return:
		return total, top, amount

	]],
	total_script = [[
		local value, top, total, combat, instance = ...
		return math.floor (value)

	]],
	percent_script = [[
		local value, top, total, combat, instance = ...
		return string.format ("%.1f", value/total*100)

	]],
	tooltip =[[		
		--init:
		local player, combat, instance = ...

		--get the debuff container for potion of focus
		local debuff_uptime_container = player.debuff_uptime and player.debuff_uptime_spells and player.debuff_uptime_spells._ActorTable
		if(debuff_uptime_container) then
			local focus_potion = debuff_uptime_container[DETAILS_FOCUS_POTION_ID]
			if(focus_potion) then
				local name, _, icon = GetSpellInfo(DETAILS_FOCUS_POTION_ID)
				GameCooltip:AddLine(name, 1) --> can use only 1 focus potion(can't be pre-potion)
				_detalhes:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon(icon, 1, 1, _detalhes.tooltip.line_height, _detalhes.tooltip.line_height)
			end
		end

		--get the misc actor container
		local buff_uptime_container = player.buff_uptime and player.buff_uptime_spells and player.buff_uptime_spells._ActorTable
		if(buff_uptime_container) then
			for spellId, _ in pairs(DetailsFramework.PotionIDs) do
				local potionUsed = buff_uptime_container[spellId] 
				
				if(potionUsed) then
					
					local name, _, icon = GetSpellInfo(spellId)            
					GameCooltip:AddLine(name, potionUsed.activedamt)
					
					_detalhes:AddTooltipBackgroundStatusbar()
					GameCooltip:AddIcon(icon, 1, 1, _detalhes.tooltip.line_height, _detalhes.tooltip.line_height)
				end
			end
		end		
		local R, G, B, A = 0, 0, 0, 0.75


		local AllHealCharacters = combat:GetActorList(DETAILS_ATTRIBUTE_HEAL)
		for index, character in ipairs(AllHealCharacters) do
			local AllSpells = character:GetSpellList()
			local found = false
			for spellid, spell in pairs(AllSpells) do
				if(DETAILS_CUSTOM_POILO[spellid]) then
					GameCooltip:AddLine(select(1, GetSpellInfo(52697)),  _detalhes:ToK(spell.total+1))
					GameCooltip:AddIcon(select(3, GetSpellInfo(52697)), 1, 1, _detalhes.tooltip.line_height, _detalhes.tooltip.line_height)
					GameCooltip:AddStatusBar(100, 1, R, G, B, A)
				end
			end
		end
	]]
}

Details:InstallCustomObject(potionUsed)