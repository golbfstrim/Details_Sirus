local DmgAtSkull = {
	name = "Dmg At Skull",
	icon = [[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_8]],
	source = false,
	attribute = false,
	spellid = false,
	target = false,
	author = "fxpw",
	desc = "DmgAtSkull",
	script_version = 2,
	script = [[
		--get the parameters passed
		local Combat, CustomContainer, Instance = ...
		--declade the values to return
		local total, top, amount = 0, 0, 0

		--raid target flags:
		-- 134285864: skull
		-- 67177000: cross
		-- 33622568: square
		-- 16845352: moon
		-- 8456744: triangle
		-- 4262440: diamond
		-- 2165288: circle
		-- 1116712: star

		--do the loop
		for _, actor in ipairs(Combat:GetActorList(DETAILS_ATTRIBUTE_DAMAGE)) do
			if (actor:IsPlayer()) then
				for k,v in pairs (actor.raid_targets) do
					if k == "skull" then
						CustomContainer:AddValue(actor, v)
					end
					
				end        
			end
		end

		total, top = CustomContainer:GetTotalAndHighestValue()
		amount = CustomContainer:GetNumActors()

		--return the values
		return total, top, amount


	]],
	total_script = [[
		local value, top, total, combat, instance = ...
		return value
	]],
	percent_script = [[

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
		]],
	-- notooltip = false,
}

Details:InstallCustomObject(DmgAtSkull)