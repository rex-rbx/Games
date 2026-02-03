local Old; Old = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local Method = getnamecallmethod()
    if Method == "SetAttribute" and ({...})[1] == "Ragdoll" then
        return
    elseif Method == "GetAttribute" and ({...})[1] == "Ragdoll" then
        return false
    end
    return Old(Self, ...)
end))
for i, v in getgc() do
	if typeof(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
		local Success, Constants = pcall(debug.getconstants, v)
		if Success and Constants then
			for j, Constant in Constants do
				if typeof(Constant) == "string" and (Constant == "Ragdoll" or Constant == "IsRagdoll" or Constant == "IsTazed") then
					local src = debug.info(v, "s")
					if src and src:find("BClient") then
						pcall(debug.setconstant, v, j, "no ragdoll 4 u")
						break
					end
				end
			end
		end
	end
end
