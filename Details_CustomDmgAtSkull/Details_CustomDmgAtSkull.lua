local DmgAtSkull = {
	name = "Dmg At Skull",
	icon = [[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_8]],
	source = false,
	attribute = false,
	spellid = false,
	target = false,
	author = "fxpw",
	desc = "DmgAtSkull",
	script_version = 3,
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
		local value, top, total, combat, instance = ...
		return string.format("%2.f",(value/total)*100)
	]],
	tooltip =[[	
		
		]],
	-- notooltip = false,
}

Details:InstallCustomObject(DmgAtSkull)