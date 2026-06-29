print("[Cream x 2011x] Now loading... Made by lil2kki <3")

local function updatePlayer(name)
    local player = workspace.Players:FindFirstChild(name)
    if not player then return end

    if player:GetAttribute("Character") ~= "2011x" then return end

    print("[Cream x 2011x] Updating model for " .. player.Name .. "...")

    if player:FindFirstChild("OverlayModel") then
        warn("[Cream x 2011x] Player already have OverlayModel, update cancelled")
        return
    end

    local cheese = player:FindFirstChild("cheese")
    if cheese then cheese.Parent = workspace end

    local isLocalPlayer = player.Name == game.Players.LocalPlayer.Name

    -- first prebuild setup
    if not player:FindFirstChild("BeingChased") then

        -- sometimes game spam errors without it lol
        local BeingChased = Instance.new("ObjectValue")
        BeingChased.Name = "BeingChased"
        BeingChased.Value = player
        BeingChased.Parent = player

        -- wait player server build..
        if isLocalPlayer then
            player:WaitForChild("cam")
            local lastCFrame = workspace.CurrentCamera.CFrame
            repeat task.wait(0.1)
            until workspace.CurrentCamera.CFrame ~= lastCFrame
        else
            task.wait(1)
        end

    end
    
    local ogHRP = player:FindFirstChild("HumanoidRootPart", true)
    if not ogHRP then return end

    for _, v in ipairs(player:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = 1
            v.LocalTransparencyModifier = 1
            v.Material = Enum.Material.Neon
            v.Color = Color3.new(0/255, 0/255, 0/255)
        end
        if v:IsA("SurfaceGui") then v.Enabled = false end
        if v:IsA("SurfaceAppearance") then v:Destroy() end
    end

    local OverlayModel = game:GetObjects("rbxassetid://79321850642715")[1]
    OverlayModel.Parent = player
    OverlayModel.Name = "OverlayModel"

    local myHRP = OverlayModel:FindFirstChild("HumanoidRootPart", true)
    if not myHRP then OverlayModel:Destroy() return end

    for _, v in ipairs(OverlayModel:GetDescendants()) do
        if v:IsA("Humanoid") then v:Destroy() end
        if v:IsA("Animator") then v:Destroy() end
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Anchored = false
            v.CanTouch = false
            v.CanQuery = false
            v.Massless = true
        end
    end

    coroutine.wrap(function()
        while true do
            if not player.Parent then
                warn("[Cream x 2011x] Player "..name.." got backrooms..")
                break
            end
            if not myHRP or not myHRP.Parent then 
                warn("[Cream x 2011x] Overlay model for "..name.." destroyed for unknown reason")
                break
            end -- ok then i restart overlay
            myHRP:PivotTo(ogHRP.CFrame * CFrame.new(0, -1.9, 0))
            task.wait() -- heartbeat mayb
        end
        warn("[Cream x 2011x] Trying to restart overlay")
        updatePlayer(name)
    end)()

    
    if cheese then cheese.Parent = player end

    local function rename(oldName, newName)
        local obj = player.OverlayModel:FindFirstChild(oldName, true)
        while obj do
            -- print("renaming: "..obj.Name.." -> "..newName.." //"..obj.ClassName)
            obj.Name = newName
            if not obj:GetAttribute("oldName") then 
                obj:SetAttribute("oldName", oldName)
                obj:SetAttribute("newName", newName)
            end
            obj = player.OverlayModel:FindFirstChild(oldName, true)
        end 
    end
    local function renameByAttribute(attrName)
        for _, obj in ipairs(player.OverlayModel:GetDescendants()) do
            local targetName = obj:GetAttribute(attrName)
            if targetName then obj.Name = targetName end
        end
    end

    --taills doll remap
    rename("waist", "Waist")
    rename("Body", "MainBody")
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

    renameByAttribute("oldName")

    if not player:FindFirstChild("CreamAnimate") then
        local cheese = game.ReplicatedStorage:FindFirstChild("Characters", true):FindFirstChild("Cream", true)
        :FindFirstChild("cheese", true):Clone()
        cheese.Parent = player

        local CreamAnimate = game.ReplicatedStorage:FindFirstChild("Characters", true):FindFirstChild("Cream", true)
        :FindFirstChild("Animate", true):Clone()

        CreamAnimate.Name = "CreamAnimate"
        CreamAnimate.Parent = player
        CreamAnimate.Enabled = true

        for _, v in ipairs(CreamAnimate:GetDescendants()) do
            pcall(function() v:SetAttribute("CreamAnimate", "yep") end)
        end
        
        local TailsDollSwing1 = CreamAnimate.Anims.Glide:Clone()
        TailsDollSwing1.AnimationId = "rbxassetid://101931899083669"
        TailsDollSwing1:SetAttribute("CreamAnimate", "yep")
        local AttackSwing1 = player.Humanoid.Animator:LoadAnimation(TailsDollSwing1)
        AttackSwing1.Name = "AttackSwing1"

        local TailsDollSwing2 = CreamAnimate.Anims.Glide:Clone()
        TailsDollSwing2.AnimationId = "rbxassetid://138468646867674"
        TailsDollSwing2:SetAttribute("CreamAnimate", "yep")
        local AttackSwing2 = player.Humanoid.Animator:LoadAnimation(TailsDollSwing2)
        AttackSwing2.Name = "AttackSwing2"
        
        local GRIDDYa = CreamAnimate.Anims.Glide:Clone()
        GRIDDYa.AnimationId = "rbxassetid://88275250559180"
        GRIDDYa:SetAttribute("CreamAnimate", "yep")
        local GRIDDY = player.Humanoid.Animator:LoadAnimation(GRIDDYa)
        GRIDDY.Name = "GRIDDY"

        player.Humanoid.Animator.AnimationPlayed:Connect(function(track)
            -- print("PLAYED: "..track.Name.." - "..track.Animation.AnimationId)
            local id = track.Animation.AnimationId
            if id == "rbxassetid://139392352153071" or id == "rbxassetid://96230691728678" or id == "rbxassetid://131225817305683" then
                renameByAttribute("newName")
                local anim = math.random(1, 2) == 1 and AttackSwing1 or AttackSwing2
                anim:Play(0.2)
                anim.Stopped:Once(function()
                    local tracks = player.Humanoid.Animator:GetPlayingAnimationTracks()
                    for i, a in ipairs(tracks) do 
                        a.Stopped:Once(function() tracks[i] = nil end) 
                    end
                    task.wait(0.1)
                    anim:Stop()
                    for i, a in ipairs(tracks) do
                        if (a.Name ~= anim.Name) and (a.Name ~= "Animation") then a:Stop() task.wait(0.03) a:Play(0.2) end
                    end
                    renameByAttribute("oldName")
                end)
            elseif id == "rbxassetid://78545771079470" then -- hype
                GRIDDY:Play(0.1)
                track.Stopped:Once(function() GRIDDY:Stop(0.1) end)
            elseif not track.Animation:GetAttribute("CreamAnimate") then
                if CreamAnimate.Anims:FindFirstChild(track.Name) then track:Stop() end
                if CreamAnimate.Anims.Default:FindFirstChild(track.Name) then track:Stop() end
            end
        end)

        warn("[Cream x TailsDoll] Cream animations added")
    end

end

-- all players
    local function walkPlayers()
        task.wait(1)
        for _, model in ipairs(workspace.Players:GetChildren()) do
            if not model:IsA("Model") then continue end
            if model.Name == game.Players.LocalPlayer.Name then continue end
            updatePlayer(model.Name)
        end
    end

    walkPlayers()

    _G.Cream2011xSkinGameStateConn = _G.Cream2011xSkinGameStateConn or nil
    if _G.Cream2011xSkinGameStateConn then
        _G.Cream2011xSkinGameStateConn:Disconnect()
        _G.Cream2011xSkinGameStateConn = nil
        print("[Cream x 2011x] Previous game state connection destroyed")
    end
    _G.Cream2011xSkinGameStateConn = workspace:WaitForChild("GameProperties"):WaitForChild("State").Changed:Connect(function(newState)
        if newState == "ING" then walkPlayers() end
    end)
--

-- my char
    _G.Cream2011xSkinCharacterConn = _G.Cream2011xSkinCharacterConn or nil
    if _G.Cream2011xSkinCharacterConn then
        _G.Cream2011xSkinCharacterConn:Disconnect()
        _G.Cream2011xSkinCharacterConn = nil
        print("[Cream x 2011x] Previous game сharacter added connection destroyed")
    end
    _G.Cream2011xSkinCharacterConn = game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
        updatePlayer(character.Name)
    end)

    updatePlayer(game.Players.LocalPlayer.Character.Name)
--

print("[Cream x 2011x] Players scanned, game state and your char being listened.")

local function loadCustomAsset(url, filename)
    if not isfile(filename) then writefile(filename, game:HttpGet(url)) end
    return getcustomasset(filename)
end
local assets = "https://github.com/thaLILNIKKI/Cream.LMS-Outcome-Memories/releases/download/assets/"

local themes = game:GetService("ReplicatedStorage"):FindFirstChild("ChaseThemes", true):FindFirstChild("2011x", true)
themes.RETRO.NormalChase.SoundId = loadCustomAsset(assets.."NormalChase_alt.mp3", "cache/cream-on-doll/NormalChase_alt.mp3")
themes.RETRO.LastLifeChase.SoundId = loadCustomAsset(assets.."LastLifeChase_alt.mp3", "cache/cream-on-doll/LastLifeChase_alt.mp3")
themes.miku.NormalChase.SoundId = loadCustomAsset(assets.."NormalChase_alt.mp3", "cache/cream-on-doll/NormalChase_alt.mp3")
themes.miku.LastLifeChase.SoundId = loadCustomAsset(assets.."LastLifeChase_alt.mp3", "cache/cream-on-doll/LastLifeChase_alt.mp3")
themes.Default.NormalChase.SoundId = loadCustomAsset(assets.."NormalChase_alt.mp3", "cache/cream-on-doll/NormalChase_alt.mp3")
themes.Default.LastLifeChase.SoundId = loadCustomAsset(assets.."LastLifeChase_alt.mp3", "cache/cream-on-doll/LastLifeChase_alt.mp3")
