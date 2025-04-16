-- mod info
local mod = {
    ready = false,
	listener = nil,
	killsRequired = 1
}

function OnReady(event)
	-- get callback event data
    local questData = event:GetResource()
	-- find correct node #4
    for _, node in ipairs(questData.graph.nodes) do
		if node.id == 4 then
			-- Change the values of the correct nodes
			for _, phaseGraphNodes in ipairs(node.phaseGraph.nodes) do
				if phaseGraphNodes.id == 70 then
					phaseGraphNodes.condition.type.value = mod.killsRequired
				end
				if phaseGraphNodes.id == 71 then
					phaseGraphNodes.condition.conditions[1].type.value = mod.killsRequired
				end
			end
		end
    end
end

-- onHook event registration
registerForEvent("onHook", function() 
    
    -- set mod as ready if other mods need to know about this mod
    mod.ready = true
	
	mod.listener = NewProxy({
		OnQuestLoad = {
		-- Type is defined in the wiki of Codeware
		args = {"handle:ResourceEvent"},
		callback = function(event) OnReady(event) end
		}
	})

  -- Register our callback to listen for event "Resource/Load" and target specific quest.
	Game.GetCallbackSystem()
	:RegisterCallback("Resource/Load", mod.listener:Target(), mod.listener:Function("OnQuestLoad"))
	:AddTarget(ResourceTarget.Path(ResRef.FromString("base\\quest\\minor_quests\\mq007\\mq007.questphase")))
	:SetLifetime(CallbackLifetime.Forever)
end)



-- return mod info 
-- for communication between mods
return mod