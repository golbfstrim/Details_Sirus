local dmgAtAbsorb = {
	name = "Dmg At Shields",
	icon = [[Interface\Icons\Spell_Holy_PowerWordShield]],
	source = false,
	attribute = false,
	spellid = false,
	target = false,
	author = "fxpw",
	desc = "Shows dmg at shields",
	script_version = 2,
	script = [[
		--get the parameters passed
		local Combat, CustomContainer, Instance = ...
		--declade the values to return
		local total, top, amount = 0, 0, 0

		--do the loop
		for index, actor in ipairs(Combat:GetActorList(1)) do
			if(actor:IsPlayer()) then
				
				--get the actor total damage absorbed
				local totalAbsorb = actor.totalabsorbed
				
				--get the damage absorbed by all the actor pets
				for petIndex, petName in ipairs(actor.pets) do
					local pet = Combat :GetActor(1, petName)
					if(pet) then
						totalAbsorb = totalAbsorb + pet.totalabsorbed
					end
				end
				
				--add the value to the actor on the custom container
				CustomContainer:AddValue(actor, totalAbsorb)
				
			end
		end
		--loop end

		--if not managed inside the loop, get the values of total, top and amount
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
		return string.format("%.2f",(value/total)*100)
	]],
	tooltip =[[			

		--get the parameters passed
		local actor, Combat, instance = ...

		--get the cooltip object(we dont use the convencional GameTooltip here)
		local GameCooltip = GameCooltip

		--Cooltip code
		--get the actor total damage absorbed
		local totalAbsorb = actor.totalabsorbed
		local format_func = Details:GetCurrentToKFunction()

		--get the damage absorbed by all the actor pets
		for petIndex, petName in ipairs(actor.pets) do
			local pet = Combat :GetActor(1, petName)
			if(pet) then
				totalAbsorb = totalAbsorb + pet.totalabsorbed
			end
		end

		GameCooltip:AddLine(actor:Name(), format_func(_, actor.totalabsorbed))
		Details:AddTooltipBackgroundStatusbar()

		for petIndex, petName in ipairs(actor.pets) do
			local pet = Combat :GetActor(1, petName)
			if(pet) then
				totalAbsorb = totalAbsorb + pet.totalabsorbed
				
				GameCooltip:AddLine(petName, format_func(_, pet.totalabsorbed))
				Details:AddTooltipBackgroundStatusbar()				
			end
		end	
		
	]]
}

Details:InstallCustomObject(dmgAtAbsorb)