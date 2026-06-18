print("[Cream x TailsDoll] Now loading... Made by lil2kki <3")

local tar = game:GetService("ReplicatedStorage")
tar = tar:FindFirstChild("Characters", true)
tar = tar:FindFirstChild("TailsDoll", true)
tar = tar:FindFirstChild("Skins", true)

local OLD_THERE_ALR = tar:FindFirstChild("_OLD", true)
if OLD_THERE_ALR then
    warn("[Cream x TailsDoll] Restoring original skin")
    tar:FindFirstChild("Default", true):Destroy()
    OLD_THERE_ALR.Name = "Default"
end

tar = tar:FindFirstChild("Default", true)

local src = game:GetService("ReplicatedStorage")
src = src:FindFirstChild("Characters", true)
src = src:FindFirstChild("Cream", true)
src = src:FindFirstChild("Skins", true)
src = src:FindFirstChild("Default", true)

if not tar or not src then warn("[Cream x TailsDoll] Models not found!") return end

-- clone cream
local model = src:Clone()

model.Name = tar.Name
model.Parent = tar.Parent

tar.Name = "_OLD"

for _, v in ipairs(model:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.Slate
    end
end

local function find(name)
    return model:FindFirstChild(name, true)
end

-- red dots :3
local thatslikeevilandscary = game:GetObjects("rbxassetid://120086931957772")[1]
local eyeNames = {{"Eye1","eye1"}, {"Eye2","eye2"}}
for _, pair in ipairs(eyeNames) do
    local srcPart = thatslikeevilandscary:FindFirstChild(pair[1], true)
    local dstPart = model:FindFirstChild(pair[2], true)
    if srcPart and dstPart then
        dstPart.Material = Enum.Material.Neon
        dstPart.Color = Color3.fromRGB(0,0,0)
        dstPart.Transparency = 1
        dstPart.Size = dstPart.Size / 3
        for _, child in ipairs(srcPart:GetChildren()) do
            if child:IsA("ParticleEmitter") or child:IsA("Attachment") then
                child.Parent = dstPart
                if child.Name == "YiSang" then child:Destroy() end
            end
        end
        for _, child in ipairs(dstPart:GetDescendants()) do
            if child:IsA("ParticleEmitter") then
                child.LockedToPart = true
                if child.Name == "bubble" then 
                    child.LightEmission = 0.1
                    child.LightInfluence = 0.1
                end
            end
        end
    end
end
thatslikeevilandscary:Destroy()

-- eyes
local eyes = find("eyes")
if eyes and eyes:IsA("BasePart") then
    eyes.Material = Enum.Material.Neon
    eyes.Color = Color3.new(0, 0, 0)
end

-- rename parts
local function rename(oldName, newName)
	local obj = find(oldName)
	while obj do
		-- print("renaming: "..obj.Name.." -> "..newName.." //"..obj.ClassName)
		obj.Name = newName
        obj:SetAttribute("rename_oldName", oldName)
        obj:SetAttribute("rename_newName", newName)
		obj = find(oldName)
	end 
end

    rename("waist", "Waist")
    rename("Body", "MainBody")

    rename("eye1", "REye")
    rename("eye2", "LEye")

    rename("Right Sleeve", "RArm1")
    rename("Cylinder.013", "RArm2")
    rename("Cylinder.014", "RArm3")
    rename("Cylinder.017", "RArm4")
    rename("Right Hand", "RHand")

    rename("Left Sleeve", "LArm1")
    rename("Cylinder.023", "LArm2")
    rename("Cylinder.022", "LArm3")
    rename("Left Hand", "LHand")

    rename("Right Leg", "RLeg1")
    rename("Cylinder.001", "RLeg2")
    rename("Cylinder", "RLeg3")
    rename("Right Shoe", "RShoe")

    rename("Left Leg", "LLeg1")
    rename("Cylinder.034", "LLeg2")
    rename("Cylinder.035", "LLeg3")
    rename("Left Shoe", "LShoe")

    rename("tail", "RTail")
--

-- blood on muzzle :3
local muzzle = model:FindFirstChild("muzzle", true)
local drip = game:GetObjects("rbxassetid://84762690015926")[1]
drip.Parent = muzzle
drip.UVScale = Vector2.new(1.5, 1)

-- dress..
local dress = model:FindFirstChild("dress", true)
dress.Material = Enum.Material.Sandstone

print("[Cream x TailsDoll] Model setup done...")

-- FUCKING SERVER SIDED PLAYER BUILD HOLY HELL

local updatingModels = {}

local function makeWeakRef(obj)
    return setmetatable({obj = obj}, {__mode = "v"})
end

local function updatePlayerModel(playerName)
    if updatingModels[playerName] then return end
    updatingModels[playerName] = true

	local plrModel = workspace.Players:FindFirstChild(playerName)
	if not plrModel then updatingModels[playerName] = nil return end

	if plrModel:GetAttribute("Character") ~= "TailsDoll" then updatingModels[playerName] = nil return end

    print("[Cream x TailsDoll] Updating model for " .. plrModel.Name .. "...")

	local oldOverlayModel = plrModel:FindFirstChild("OverlayModel")
	if oldOverlayModel then 
        oldOverlayModel:Destroy()
        oldOverlayModel = nil
    end
    
	local hrp = plrModel:FindFirstChild("HumanoidRootPart", true)
	if not hrp then updatingModels[playerName] = nil return end

	local ogHead = plrModel:FindFirstChildOfClass("Motor6D", true)

    for _, v in ipairs(plrModel:GetDescendants()) do
        if v:IsA("Motor6D") and v.Name == "Head" then ogHead = v end
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            if string.find(v.Name, "Claw") then v:Destroy() end
            v.Transparency = 1
            v.LocalTransparencyModifier = 1
            
        end
        if v:IsA("ParticleEmitter") then v:Destroy() end -- soul diamond
        if v:IsA("PointLight") then v:Destroy() end -- soul diamond
    end
    
    local src = game:GetService("ReplicatedStorage")
    src = src:FindFirstChild("Characters", true)
    src = src:FindFirstChild("TailsDoll", true)
    src = src:FindFirstChild("Skins", true)
    src = src:FindFirstChild("Default", true)

    local mdl = src:Clone()
	mdl.Parent = plrModel
	mdl.Name = "OverlayModel"

	local newHrp = mdl:FindFirstChild("HumanoidRootPart", true)
	if not newHrp then mdl:Destroy() updatingModels[playerName] = nil return end

	local myHead = mdl:FindFirstChildOfClass("Motor6D", true)

	for _, v in ipairs(mdl:GetDescendants()) do
        if v:IsA("Motor6D") and v.Name == "Head" then myHead = v end
		if v:IsA("Humanoid") then v:Destroy() end
		if v:IsA("Animator") then v:Destroy() end
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
	end

    -- print(ogHead:GetFullName())
    -- print(myHead:GetFullName())

    -- local Mines = plrModel:FindFirstChild("Mines")
    -- local Dodges = plrModel:FindFirstChild("Dodges")

    _G.CreamOnTailsDollSkinHeartbeatConnections = _G.CreamOnTailsDollSkinHeartbeatConnections or {}
    if _G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name] then
        _G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name]:Disconnect()
        _G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name] = nil
        warn("[Cream x TailsDoll] Disconnecting old heartbeat connection...")
    end

    local isActive = true
    local mdlRef = makeWeakRef(mdl)
    local hrpRef = makeWeakRef(hrp)
    local newHrpRef = makeWeakRef(newHrp)
    local myHeadRef = makeWeakRef(myHead)
    local ogHeadRef = makeWeakRef(ogHead)
    local plrModelRef = makeWeakRef(plrModel)

	_G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name] = game:GetService("RunService").Heartbeat:Connect(function()
        local mdlCheck = mdlRef.obj
        local hrpCheck = hrpRef.obj
        local newHrpCheck = newHrpRef.obj
        local myHeadCheck = myHeadRef.obj
        local ogHeadCheck = ogHeadRef.obj
        local plrModelCheck = plrModelRef.obj

		if not mdlCheck or not mdlCheck.Parent then
            if not isActive then return end
            isActive = false
			warn("[Cream x TailsDoll] Model destroyed, restarting overlay")
            if _G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name] then
                _G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name]:Disconnect()
                _G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name] = nil
            end
            updatingModels[plrModel.Name] = nil
			updatePlayerModel(playerName)
			return
		end
		if plrModelCheck:GetAttribute("Character") ~= "TailsDoll" then
            if not isActive then return end
            isActive = false
            warn("[Cream x TailsDoll] Player ", plrModelCheck.Name, "isn't TailsDoll rn.")
            if _G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name] then
                _G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name]:Disconnect()
                _G.CreamOnTailsDollSkinHeartbeatConnections[plrModel.Name] = nil
                warn("[Cream x TailsDoll] Disconnecting old heartbeat connection...")
            end
            updatingModels[plrModel.Name] = nil
			if mdlCheck then mdlCheck:Destroy() end
			return
		end
		newHrpCheck:PivotTo(
            hrpCheck.CFrame *
            CFrame.new(0,-1,0)
        )
        myHeadCheck.C0 = CFrame.new(myHeadCheck.C0.Position) * (ogHeadCheck.C0 - ogHeadCheck.C0.Position)
        -- if Mines and Dodges then Dodges.Value = Mines.Value end
	end)

    local function renameByAttribute(attrName)
        local mdlCheck = mdlRef.obj
        if not mdlCheck then return end
        for _, obj in ipairs(mdlCheck:GetDescendants()) do
            local targetName = obj:GetAttribute(attrName)
            if targetName then obj.Name = targetName end
        end
    end

    local isGilding = false
    local CreamGlideTrack = plrModel.Humanoid.Animator:LoadAnimation(
        game:GetService("ReplicatedStorage"):FindFirstChild("Characters", true)
        :FindFirstChild("Cream", true):FindFirstChild("Glide", true)
    )
    CreamGlideTrack.Name = "CreamGlide"
    local CreamGlideTrackRef = makeWeakRef(CreamGlideTrack)

    _G.CreamOnTailsDollSkinAnimationPlayedConnections = _G.CreamOnTailsDollSkinAnimationPlayedConnections or {}
    if _G.CreamOnTailsDollSkinAnimationPlayedConnections[plrModel.Name] then
        _G.CreamOnTailsDollSkinAnimationPlayedConnections[plrModel.Name]:Disconnect()
        _G.CreamOnTailsDollSkinAnimationPlayedConnections[plrModel.Name] = nil
    end
	_G.CreamOnTailsDollSkinAnimationPlayedConnections[plrModel.Name] = plrModel.Humanoid.Animator.AnimationPlayed:Connect(function(track)
        local mdlCheck = mdlRef.obj
        local plrModelCheck = plrModelRef.obj
        local CreamGlideTrackCheck = CreamGlideTrackRef.obj

		if not mdlCheck or not mdlCheck.Parent or (plrModelCheck and plrModelCheck:GetAttribute("Character") ~= "TailsDoll") then
			warn("[Cream x TailsDoll] Disconnecting animatior...")
            if _G.CreamOnTailsDollSkinAnimationPlayedConnections[plrModel.Name] then
                _G.CreamOnTailsDollSkinAnimationPlayedConnections[plrModel.Name]:Disconnect()
                _G.CreamOnTailsDollSkinAnimationPlayedConnections[plrModel.Name] = nil
            end
            updatingModels[plrModel.Name] = nil
			return
		end

        -- print("PLAYED", track.Name, track.Animation.AnimationId)

        if track.Name ~= CreamGlideTrackCheck.Name then 
            if CreamGlideTrackCheck then CreamGlideTrackCheck:Stop() end
            renameByAttribute("rename_newName") 
            track.Stopped:Once(function() if isGilding and CreamGlideTrackCheck then
                renameByAttribute("rename_oldName")
                CreamGlideTrackCheck:Play(0.1)
            end end)
        end
        if track.Name == "Glide" then
            isGilding = true
            track.Stopped:Once(function()
                isGilding = false
                if CreamGlideTrackCheck then CreamGlideTrackCheck:Stop(0.1) end
                renameByAttribute("rename_newName")
            end)
            renameByAttribute("rename_oldName")
            if CreamGlideTrackCheck then CreamGlideTrackCheck:Play(0.1) end
        end
    end)

    updatingModels[plrModel.Name] = nil
    return plrModel
end

local function tryUpdatePlayerModel(model)
    if model:GetAttribute("Character") ~= "TailsDoll" then return end
    updatePlayerModel(model.Name)
end

local function walkPlayers()
    task.wait(1)
    for _, model in ipairs(workspace.Players:GetChildren()) do
    	if not model:IsA("Model") then continue end
    	if model.Name == game.Players.LocalPlayer.Name then continue end
        tryUpdatePlayerModel(model)
    end
end
    _G.CreamOnTailsDollSkinGameStateConn = _G.CreamOnTailsDollSkinGameStateConn or nil
    if _G.CreamOnTailsDollSkinGameStateConn then
        _G.CreamOnTailsDollSkinGameStateConn:Disconnect()
        _G.CreamOnTailsDollSkinGameStateConn = nil
        print("[Cream x TailsDoll] Previous game state connection destroyed")
    end
    _G.CreamOnTailsDollSkinGameStateConn = workspace:WaitForChild("GameProperties"):WaitForChild("State").Changed:Connect(function(newState)
        if newState ~= "ING" then return end
        walkPlayers()
    end)
    walkPlayers()
--

-- CharacterConn
    _G.CreamOnTailsDollSkinCharacterConn = _G.CreamOnTailsDollSkinCharacterConn or nil
    if _G.CreamOnTailsDollSkinCharacterConn then
        _G.CreamOnTailsDollSkinCharacterConn:Disconnect()
        _G.CreamOnTailsDollSkinCharacterConn = nil
        print("[Cream x TailsDoll] Previous game сharacter added connection destroyed")
    end
    _G.CreamOnTailsDollSkinCharacterConn = game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
	    if character:GetAttribute("Character") ~= "TailsDoll" then return end
        local healthxd = Instance.new("NumberValue")
        healthxd.Name = "Health"
        healthxd.Parent = character
        -- local Dodges = Instance.new("NumberValue")
        -- Dodges.Name = "Dodges"
        -- Dodges.Parent = character
        task.wait(3)
        healthxd.Value = 0/0
	    character:SetAttribute("Glide_anim_was_replaced", false)
        tryUpdatePlayerModel(character)
    end)
    tryUpdatePlayerModel(game.Players.LocalPlayer.Character)
--

print("[Cream x TailsDoll] Players scanned, game state and your char being listened.")

-- CUSTOM TEXT

    local updatingTextLabel = false
    local function replTextLabel(label)
        if updatingTextLabel then return end
        if label.Text:find("TailsDoll (2)") then return end
        updatingTextLabel = true
        if label.Text == "S.T.E.P." then label.Text = "FUN" end
        if label.Text == "Reach Out" then label.Text = " Tag ~" end
        if label.Text == "Brighter Day" then label.Text = "Laser thingy" end
        if label.Text == "Tripwire" then label.Text = " [CORRUPTED] " end
        if label.Text == "TailsDoll" then label.Text = "TailsDoll (2)" end
        if label.Text == "Can you feel the sunshine?" then 
            -- label.TextWrapped = false
            -- label.Font = Enum.Font.Code
            -- label.TextColor3 = Color3.new(0.98, 0.98, 0.98)
            -- label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = "[Info] Instance copied successfully.\n"
                    .."[WARN] ReplicatedStorage missmatch!\n"
                    .."[WARN] Unauthorized access!\n"
                    .."> dont worry, thats just a way i can play :>\n"
                    .."Syntax error."
        end
        updatingTextLabel = false
    end

    _G.CreamOnTailsDollGUIConns = _G.CreamOnTailsDollGUIConns or {}
    for _, conn in ipairs(_G.CreamOnTailsDollGUIConns) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(_G.CreamOnTailsDollGUIConns)

    local function hookLabel(desc)
        if desc:IsA("TextLabel") then
            local path = desc:GetFullName()
            if path:find("CoreGui.") or path:find("skibidi board") then return end
            task.wait(0.001)
            ---print(" '" .. desc.Text .. "' at " .. desc:GetFullName())
            replTextLabel(desc)
            local labelRef = makeWeakRef(desc)
            local conn = desc:GetPropertyChangedSignal("Text"):Connect(function()
                local label = labelRef.obj
                if not label or not label.Parent then conn:Disconnect() return end
                replTextLabel(label)
            end)
            table.insert(_G.CreamOnTailsDollGUIConns, conn)
        end
    end

    _G.CreamOnTailsDollGUIConn = _G.CreamOnTailsDollGUIConn or nil
    if _G.CreamOnTailsDollGUIConn then
        _G.CreamOnTailsDollGUIConn:Disconnect()
        _G.CreamOnTailsDollGUIConn = nil
        print("[Cream x TailsDoll] Previous gui desc conn destroyed")
    end
    _G.CreamOnTailsDollGUIConn = game:GetService("Players").LocalPlayer.PlayerGui.DescendantAdded:Connect(hookLabel)
    for _, desc in ipairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
        hookLabel(desc)
    end
    print("[Cream x TailsDoll] Listening for your GUI...")
--

-- CUSTOM SOUNDS
    local assigns = { ["rbxassetid://97101227703333"] = "rbxassetid://139116822099909" }
    local StunSounds = {}
    local DownedSounds = {}
    local AttackSounds = {}
    local lastBloodHitPlayerRef = nil

    _G.CreamOnTailsDollSkinSoundConn = _G.CreamOnTailsDollSkinSoundConn or nil
    if _G.CreamOnTailsDollSkinSoundConn then
        _G.CreamOnTailsDollSkinSoundConn:Disconnect()
        _G.CreamOnTailsDollSkinSoundConn = nil
        print("[Cream x TailsDoll] Previous sound desc conn destroyed")
    end
    _G.CreamOnTailsDollSkinSoundConn = workspace.DescendantAdded:Connect(function(desc)
        if desc:IsA("Sound") then

            if assigns[desc.SoundId] then desc.SoundId = assigns[desc.SoundId] end

            local path = desc:GetFullName()

            -- print(path) ---

            -- if path:find("asd") or path:find("asd") then return end

            if path:find("HumanoidRootPart.") then
                local player = desc.Parent.Parent
                local playerRef = makeWeakRef(player)
                local isTailsDoll = player:GetAttribute("Character") == "TailsDoll"

                if isTailsDoll and (desc.Name:find("Retract") or desc.Name:find("Unleashed")) then
                    desc.RollOffMaxDistance = desc.RollOffMaxDistance * 4
                    desc.RollOffMinDistance = desc.RollOffMinDistance * 2
                    desc.Volume = 1
                    for _, child in ipairs(player.Waist:GetChildren()) do
                        if child.Name:find("CreamSpeech") then 
                            desc.Volume = 0
                            desc:Stop()
                        end
                    end
                end

                if path:find(".Blood Hit") then lastBloodHitPlayerRef = playerRef end

                if isTailsDoll then

                    if desc.SoundId == "rbxassetid://77110140707717" then
                        local clone = desc:Clone()
                        clone.SoundId = AttackSounds[math.random(1, #AttackSounds)]
                        clone.Name = clone.SoundId
                        clone.Parent = desc.Parent
                        clone:Play()
                        clone.Loaded:Wait()
                        local len = clone.TimeLength or 5
                        local cloneRef = makeWeakRef(clone)
                        task.delay(len + 0.5, function()
                            local c = cloneRef.obj
                            if c then c:Destroy() end
                        end)
                    end

                    local isDefLine = (path:find(".Default") and path:find("Line")) -- .Default1Line wth

                    if isDefLine or path:find(".Downed") then desc.SoundId = DownedSounds[math.random(1, #DownedSounds)] end
                    if path:find(".Hurt") then desc.SoundId = StunSounds[math.random(1, #StunSounds)] end

                    if isDefLine or path:find(".Downed") or path:find(".Hurt") then
                        for _, child in ipairs(player.Waist:GetChildren()) do
                            if child.Name:find("CreamSpeech") then child:Stop() end
                        end
                        if isDefLine and lastBloodHitPlayerRef then
                            local lastPlayer = lastBloodHitPlayerRef.obj
                            if lastPlayer then
                                local c = lastPlayer:GetAttribute("Character")
                                if KillLines[c] then 
                                    desc.SoundId = KillLines[c][math.random(1, #KillLines[c])]
                                    lastBloodHitPlayerRef = nil
                                end
                            end
                        end
                        local sound = Instance.new("Sound")
                        sound.Name = "CreamSpeech - " .. desc.SoundId
                        sound.SoundId = desc.SoundId
                        sound.Volume = desc.Volume
                        sound.RollOffMaxDistance = desc.RollOffMaxDistance
                        sound.RollOffMinDistance = desc.RollOffMinDistance
                        sound.SoundGroup = desc.SoundGroup
                        sound.Parent = player.Waist
                        sound:Play()
                        sound.Loaded:Wait()
                        local len = sound.TimeLength or 5
                        local soundRef = makeWeakRef(sound)
                        task.delay(len + 0.5, function()
                            local s = soundRef.obj
                            if s then s:Destroy() end
                        end)
                        desc.Volume = 0
                    end
                end
            end
        end
    end)
    print("[Cream x TailsDoll] Listening for new dynamuc sounds in workspace...")

    print("[Cream x TailsDoll] Loading custom sounds...")
    local function myAsset(fileName)
        local cachePath = "cache/cream-on-doll/" .. fileName
        if isfile(cachePath) then return getcustomasset(cachePath) end
        local success, result = pcall(
            function()
                return game:HttpGet(
                    "https://github.com/thaLILNIKKI/Cream.LMS-for-TailsDoll-Outcome-Memories/releases/download/"
                    .. "assets/" .. fileName
                )
            end
        )
        if success and result then
            writefile(cachePath, result)
            return getcustomasset(cachePath)
        else
            warn("[Cream x TailsDoll] failed to load " .. fileName)
            return nil
        end
    end
    assigns = {
        ["rbxassetid://117478513053834"] = myAsset("WinScreen.mp3"),
	
        ["rbxassetid://80901931085615"] = myAsset("NormalChaseFix.mp3"),
        ["rbxassetid://129416111545242"] = myAsset("TerrorRadius.mp3"),
        ["rbxassetid://112879248941055"] = myAsset("LastLifeChase3.mp3"),
        
        ["rbxassetid://112976135484851"] = myAsset("Unleashed1.mp3"),
        ["rbxassetid://106071428647005"]  = myAsset("Unleashed2.mp3"),
        ["rbxassetid://87302988643016"]  = myAsset("Unleashed3.mp3"),
        ["rbxassetid://131820864449998"] = myAsset("Retract.mp3"), -- giggle or smth here ~

        ["rbxassetid://97101227703333"] = "rbxassetid://139116822099909",  -- .Hit1]  2011x Hit2
        ["rbxassetid://93465914238963"] = "rbxassetid://88164444698409",  -- Lilith.Hit2] 
        ["rbxassetid://113251186335660"] = "rbxassetid://5507830073",  -- Lilith.Hit3] 
        
        ["rbxassetid://73636680793269"] = "rbxassetid://77110140707717",  -- basic Swing
        ["rbxassetid://108753423324802"] = "rbxassetid://77110140707717",  -- basic Swing
        ["rbxassetid://134998846301914"] = "rbxassetid://77110140707717",  -- basic Swing
    }
    KillLines = {
        ["Sonic"] = { myAsset("Sonic.mp3"), myAsset("Sonic2.mp3") },
        ["Tails"] = { myAsset("Tails.mp3"),  myAsset("Tails2.mp3"),  myAsset("Tails3.mp3") },
        ["MetalSonic"] = { myAsset("MetalSonic.mp3"),  myAsset("MetalSonic2.mp3") },
        ["Amy"] = { myAsset("Amy.mp3"),  myAsset("Amy2.mp3"),  myAsset("Amy3.mp3"),  myAsset("Amy4.mp3") },
        ["Silver"] = { myAsset("Silver.mp3") },
        ["Blaze"] = { myAsset("Blaze.mp3") },
        ["Eggman"] = { myAsset("Eggman.mp3") },
        ["Cream"] = { myAsset("Cream.mp3"),  myAsset("Cream2.mp3") },
        ["Knuckles"] = { myAsset("Knuckles.mp3") }
    }
    for i = 1, 28 do table.insert(StunSounds, myAsset("Stun" .. i .. ".mp3")) end
    for i = 1, 14 do table.insert(DownedSounds, myAsset("Down" .. i .. ".mp3")) end
    for i = 1, 8 do table.insert(AttackSounds, myAsset("Attack" .. i .. ".mp3")) end
    print("[Cream x TailsDoll] Finished downloading custom sounds...")
-- 

print("[Cream x TailsDoll] Ready!")
