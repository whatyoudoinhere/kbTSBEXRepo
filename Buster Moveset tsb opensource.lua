--[[ __    __  _____   __     
/\ \  /\ \/\  __`\/\ \    
\ `\`\\/'/\ \ \/\ \ \ \   
 `\ `\ /'  \ \ \ \ \ \ \  
   `\ \ \   \ \ \_\ \ \_\ 
     \ \_\   \ \_____\/\_\
      \/_/    \/_____/\/_/]]
--[[If you're gonna use this script as a template, PLEASE, this is the LEAST you could do for US, please credit both Kabapa and SeaBlue for this script, thanks!
Also can anyone help me with the 'Unknown Token!' Error when obfuscating, i'd extremely appreciate any help. Also dm me on discord (oxak11321) if you need help]]
game.StarterGui:SetCore("SendNotification", {
    Title = "hey noob";
    Text = "This script is made by Kabapa, which uses a edited version of SB's TSB templ8";
    Duration = 7;
    Icon = "rbxassetid://105021792246024"; --Use IMAGE id, NOT decal id
    Button1 = "Do. You. Understand?";
    Callback = function(response)
        if response == "Do. You. Understand?" then
        end
    end
})

--[[Accessory and gear converte func]]  

local AccessorySettings = {
    RemoveOriginalAccessories = true --set true to remove accessories
}

local function DisableCollisions(object)
    if object:IsA("BasePart") then
        object.CanCollide = false
        object.CanTouch = false
        object.CanQuery = false
    end
end

local function AttachAccessories(accessoryTable)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if AccessorySettings.RemoveOriginalAccessories then
        for _, obj in pairs(character:GetChildren()) do
            if obj:IsA("Accessory") then
                obj:Destroy()
            end
        end
    end

    for _, accessoryData in pairs(accessoryTable) do
        local item = game:GetObjects("rbxassetid://" .. tostring(accessoryData.AssetID))[1]
        if not item then
            warn("Failed to load item with ID: " .. tostring(accessoryData.AssetID))
            return
        end

        --convert
        if item:IsA("Tool") then
            local newAccessory = Instance.new("Accessory")
            local handle = item:FindFirstChildWhichIsA("Part") or item:FindFirstChildWhichIsA("MeshPart")

            if handle then
                handle.Parent = newAccessory
                newAccessory.Parent = character
                newAccessory.Name = "ConvertedAccessory"

                DisableCollisions(handle)

                local targetPart = character:FindFirstChild(accessoryData.AttachTo)
                if targetPart then
                    local weld = Instance.new("Weld")
                    weld.Part0 = targetPart
                    weld.Part1 = handle
                    weld.C0 = CFrame.new(accessoryData.Position) * CFrame.Angles(
                        math.rad(accessoryData.Rotation.X),
                        math.rad(accessoryData.Rotation.Y),
                        math.rad(accessoryData.Rotation.Z)
                    )
                    weld.Parent = targetPart
                end
            end
        else
            item.Parent = character
            local targetPart = character:FindFirstChild(accessoryData.AttachTo)
            if targetPart then
                local attachPart = item:FindFirstChildWhichIsA("MeshPart") or item:FindFirstChildWhichIsA("Part")
                if attachPart then
                    DisableCollisions(attachPart)

                    local weld = Instance.new("Weld")
                    weld.Part0 = targetPart
                    weld.Part1 = attachPart
                    weld.C0 = CFrame.new(accessoryData.Position) * CFrame.Angles(
                        math.rad(accessoryData.Rotation.X),
                        math.rad(accessoryData.Rotation.Y),
                        math.rad(accessoryData.Rotation.Z)
                    )
                    weld.Parent = targetPart
                end
            end
        end
    end
end

--[[ACCESSORIES]]  
local Accessories = {
    {
        AssetID = 83704154,  --ex FAKE sword accessory
        AttachTo = "Right Arm",
        Position = Vector3.new(0, -1, -2.5),
        Rotation = Vector3.new(0, 90, -90)
    },
	{
		AssetID = 17399701670,  --ex hat accessory
        AttachTo = "Head",
        Position = Vector3.new(0, 0.265, -.6),
        Rotation = Vector3.new(0, 0, 0)
	}
}

AttachAccessories(Accessories)

--[[END OF ACCESSORY AND GEAR CONVERTER FUNC]]  

--[[doodoo customization system lool]]  
local PlayerCustomization = {
    EnableSkinToneChange = false, --set false to disable
    SkinTones = {
        Head = "Pastel brown",
        Torso = "Black",
        LeftArm = "Pastel brown",
        RightArm = "Pastel brown",
        LeftLeg = "Black",
        RightLeg = "Black"
    },
    RemoveMeshes = false, --NO char meshes (ex: man arm, leg etc)
    HeadSize = Vector3.new(1.25, 1.25, 1.25),
    Clothes = {
        Shirt = nil, --Set to nil to keep default Shirt
        Pants = nil, --Set to nil to keep default Pants
	
        --[[keep in mind you need a clothing (ShirtTemplate or PantsTemplate) to
	use this feature, (you can grab them via btroblox [click on clothing, search
	inside instances and search for respective template] or via roblox studio by
	inserting the clothing, clicking on the instance and copying the id from the
	respective template)]]
    }
}

--[[SKFUNC]]  
local function ApplySkinTone()
    if not PlayerCustomization.EnableSkinToneChange then return end
    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local bodyParts = {
        Head = "Head",
        Torso = "Torso",
        LeftArm = "Left Arm",
        RightArm = "Right Arm",
        LeftLeg = "Left Leg",
        RightLeg = "Right Leg"
    }

    for partName, skinColor in pairs(PlayerCustomization.SkinTones) do
        local bodyPart = character:FindFirstChild(bodyParts[partName])
        if bodyPart and skinColor then
            bodyPart.BrickColor = BrickColor.new(skinColor)
        end
    end
end

--[[doodoo anti character meshes no touchy pls]]  
local function ResetCharacterMesh()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if PlayerCustomization.RemoveMeshes then
        for _, obj in pairs(character:GetChildren()) do
            if obj:IsA("CharacterMesh") then
                obj:Destroy()
            end
        end

        local head = character:FindFirstChild("Head")
        if head then
            for _, obj in pairs(head:GetChildren()) do
                if obj:IsA("SpecialMesh") then
                    obj:Destroy()
                end
            end

            local headMesh = Instance.new("SpecialMesh")
            headMesh.MeshType = Enum.MeshType.Head
            headMesh.Scale = PlayerCustomization.HeadSize
            headMesh.Parent = head
        end
    end
end

--[[CLOTHES]]  
local function ApplyClothes()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if PlayerCustomization.Clothes.Shirt then
        local shirt = character:FindFirstChildOfClass("Shirt") or Instance.new("Shirt")
        shirt.ShirtTemplate = "rbxassetid://" .. tostring(PlayerCustomization.Clothes.Shirt)
        shirt.Parent = character
    end

    if PlayerCustomization.Clothes.Pants then
        local pants = character:FindFirstChildOfClass("Pants") or Instance.new("Pants")
        pants.PantsTemplate = "rbxassetid://" .. tostring(PlayerCustomization.Clothes.Pants)
        pants.Parent = character
    end
end

--[[APPLY WHEN SPAWN!!!!!!!!]]  
local function ApplyPlayerCustomization()
    ApplySkinTone()
    ResetCharacterMesh()
    ApplyClothes()
end

ApplyPlayerCustomization()
--[[end of doodoo customization system lool]]

local player = game.Players.LocalPlayer

local playerGui = player.PlayerGui

local hotbar = playerGui:FindFirstChild("Hotbar")

local backpack = hotbar:FindFirstChild("Backpack")

local hotbarFrame = backpack:FindFirstChild("Hotbar")

local baseButton = hotbarFrame:FindFirstChild("1").Base

local ToolName = baseButton.ToolName


ToolName.Text = "Bad Buster"


local player = game.Players.LocalPlayer

local playerGui = player.PlayerGui

local hotbar = playerGui:FindFirstChild("Hotbar")

local backpack = hotbar:FindFirstChild("Backpack")

local hotbarFrame = backpack:FindFirstChild("Hotbar")

local baseButton = hotbarFrame:FindFirstChild("2").Base

local ToolName = baseButton.ToolName


ToolName.Text = "Bucket Kicker"


local player = game.Players.LocalPlayer

local playerGui = player.PlayerGui

local hotbar = playerGui:FindFirstChild("Hotbar")

local backpack = hotbar:FindFirstChild("Backpack")

local hotbarFrame = backpack:FindFirstChild("Hotbar")

local baseButton = hotbarFrame:FindFirstChild("3").Base

local ToolName = baseButton.ToolName


ToolName.Text = "Splitter"


local player = game.Players.LocalPlayer

local playerGui = player.PlayerGui

local hotbar = playerGui:FindFirstChild("Hotbar")

local backpack = hotbar:FindFirstChild("Backpack")

local hotbarFrame = backpack:FindFirstChild("Hotbar")

local baseButton = hotbarFrame:FindFirstChild("4").Base

local ToolName = baseButton.ToolName


ToolName.Text = "Delayed Flash Of Realization"


local Players = game:GetService("Players")

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")


local function findGuiAndSetText()

    local screenGui = playerGui:FindFirstChild("ScreenGui")

    if screenGui then

        local magicHealthFrame = screenGui:FindFirstChild("MagicHealth")

        if magicHealthFrame then

            local textLabel = magicHealthFrame:FindFirstChild("TextLabel")

            if textLabel then

                textLabel.Text = "?"

            end

        end

    end

end


playerGui.DescendantAdded:Connect(findGuiAndSetText)

findGuiAndSetText()

--[[Animations]]

--[[Move 1]]

local animationId = 10468665991


local player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

local humanoid = character:WaitForChild("Humanoid")


local function onAnimationPlayed(animationTrack)

    if animationTrack.Animation.AnimationId == "rbxassetid://" .. animationId then


local p = game.Players.LocalPlayer

local Humanoid = p.Character:WaitForChild("Humanoid")


for _, animTrack in pairs(Humanoid:GetPlayingAnimationTracks()) do

    animTrack:Stop()

end


local AnimAnim = Instance.new("Animation")

AnimAnim.AnimationId = "rbxassetid://13639700348"

local Anim = Humanoid:LoadAnimation(AnimAnim)


local startTime = 0


Anim:Play()

Anim:AdjustSpeed(0.1)

Anim.TimePosition = startTime

Anim:AdjustSpeed(1)


    end

end

--[[END OF MOVE 1 ANIM]]

--[[barrage remover (tysm reap)]]
task.spawn(function()
    while task.wait() do
        local reap = character:FindFirstChild("BarrageBind")
        if reap then
            reap:Destroy()
        end
    end
end)
--[[end]]

--[[Move 2 (i cannot fathom the pain this caused me)]]

local animationId = 10466974800

local player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

local humanoid = character:WaitForChild("Humanoid")


local function onAnimationPlayedMove2(animationTrack)

    if animationTrack.Animation.AnimationId == "rbxassetid://" .. animationId then


local p = game.Players.LocalPlayer

local Humanoid = p.Character:WaitForChild("Humanoid")


for _, animTrack in pairs(Humanoid:GetPlayingAnimationTracks()) do

    animTrack:Stop()

end


local AnimAnim = Instance.new("Animation")

AnimAnim.AnimationId = "rbxassetid://15290930205"

local Anim = Humanoid:LoadAnimation(AnimAnim)


local startTime = 0


Anim:Play()

Anim:AdjustSpeed(1)

Anim.TimePosition = startTime

Anim:AdjustSpeed(1.35)

    end

end

humanoid.AnimationPlayed:Connect(onAnimationPlayedMove2) -- Updated connection to new function

--[[END OF MOVE 2 ANIM]]

--[[Move 3]]


humanoid.AnimationPlayed:Connect(onAnimationPlayed)


local animationId = 10471336737


local player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

local humanoid = character:WaitForChild("Humanoid")


local function onAnimationPlayed(animationTrack)

    if animationTrack.Animation.AnimationId == "rbxassetid://" .. animationId then


local p = game.Players.LocalPlayer

local Humanoid = p.Character:WaitForChild("Humanoid")


for _, animTrack in pairs(Humanoid:GetPlayingAnimationTracks()) do

    animTrack:Stop()

end


local AnimAnim = Instance.new("Animation")

AnimAnim.AnimationId = "rbxassetid://16057411888"

local Anim = Humanoid:LoadAnimation(AnimAnim)


local startTime = 0.3


Anim:Play()

Anim:AdjustSpeed(0)

Anim.TimePosition = startTime

Anim:AdjustSpeed(9.2)


delay(2.35, function()

    Anim:Stop()

end)


    end

end

--[[END OF MOVE 3 ANIM]]

--[[Move 4]]


humanoid.AnimationPlayed:Connect(onAnimationPlayed)


local animationId = 12510170988


local player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

local humanoid = character:WaitForChild("Humanoid")


local function onAnimationPlayed(animationTrack)

    if animationTrack.Animation.AnimationId == "rbxassetid://" .. animationId then

local p = game.Players.LocalPlayer

local Humanoid = p.Character:WaitForChild("Humanoid")


for _, animTrack in pairs(Humanoid:GetPlayingAnimationTracks()) do

    animTrack:Stop()

end


local AnimAnim = Instance.new("Animation")

AnimAnim.AnimationId = "rbxassetid://18896124320"

local Anim = Humanoid:LoadAnimation(AnimAnim)


local startTime = 0


Anim:Play()

Anim:AdjustSpeed(0)

Anim.TimePosition = startTime

Anim:AdjustSpeed(1)


    end

end

--[[END OF MOVE 4 ANIM]]

--[[Wall combo]]

humanoid.AnimationPlayed:Connect(onAnimationPlayed)

local animationId = 15955393872


local player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

local humanoid = character:WaitForChild("Humanoid")


local function onAnimationPlayed(animationTrack)

    if animationTrack.Animation.AnimationId == "rbxassetid://" .. animationId then

local p = game.Players.LocalPlayer

local Humanoid = p.Character:WaitForChild("Humanoid")


for _, animTrack in pairs(Humanoid:GetPlayingAnimationTracks()) do

    animTrack:Stop()

end


local AnimAnim = Instance.new("Animation")

AnimAnim.AnimationId = "rbxassetid://16023456135"

local Anim = Humanoid:LoadAnimation(AnimAnim)


local startTime = 0.05


Anim:Play()

Anim:AdjustSpeed(0)

Anim.TimePosition = startTime

Anim:AdjustSpeed(1)


    end

end

--[[END OF WALL COMBO ANIM]]

--[[Ult Activation Anim]]
local animationId = 12447707844 --Base Ult animation ID

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

local function stopAllAnimations()
    for _, animTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
        animTrack:Stop()
    end
end

local function onUltAnimationPlayed(animationTrack)
    if animationTrack.Animation.AnimationId == "rbxassetid://" .. tostring(animationId) then
        stopAllAnimations()

        local AnimAnim = Instance.new("Animation")
        AnimAnim.AnimationId = "rbxassetid://134775406437626" --Custom Ult animation

        local Anim = animator:LoadAnimation(AnimAnim)

        Anim.Priority = Enum.AnimationPriority.Action
        Anim.Looped = false
        
        Anim:Play()
        Anim.TimePosition = 0
        Anim:AdjustSpeed(.75)
    end
end

humanoid.AnimationPlayed:Connect(onUltAnimationPlayed)
--[[End of Ult Activation Anim]]

--[[Dash FIX (if sb wont fix this, i will)]]
local dashAnimationId = 10479335397 --NO TOUCHY

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

local function stopAllAnimations()
    for _, animTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
        animTrack:Stop()
    end
end

local function onDashAnimationPlayed(animationTrack)
    if animationTrack.Animation.AnimationId == "rbxassetid://" .. tostring(dashAnimationId) then
        stopAllAnimations()
        
        local AnimAnim = Instance.new("Animation")
        AnimAnim.AnimationId = "rbxassetid://15676072469" --CHANGE ANIM TO WHATEVER YOU LIKE
        local Anim = animator:LoadAnimation(AnimAnim)

        Anim.Priority = Enum.AnimationPriority.Action2
        Anim.Looped = false
        
        Anim:Play()
        Anim.TimePosition = 0
        Anim:AdjustSpeed(2)

        task.delay(1.8, function()
            if Anim.IsPlaying then
                Anim:Stop()
            end
        end)
    end
end

humanoid.AnimationPlayed:Connect(onDashAnimationPlayed)
--[[END OF DASH]

--[[Uppercut ANIM fix]]
local animationId = 10503381238 --NO TOUCHY

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

local function stopAllAnimations()
    for _, animTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
        animTrack:Stop()
    end
end

local function onAnimationPlayed(animationTrack)

    if animationTrack.Animation.AnimationId == "rbxassetid://" .. tostring(animationId) then

        stopAllAnimations()

        local AnimAnim = Instance.new("Animation")
        AnimAnim.AnimationId = "rbxassetid://14001963401" --CUSTOM ANIM

        local Anim = animator:LoadAnimation(AnimAnim)

        Anim.Priority = Enum.AnimationPriority.Action2
        Anim.Looped = false
        
        Anim:Play()
        Anim.TimePosition = .02
        Anim:AdjustSpeed(0.85)

        Anim.Stopped:Connect(function()
        end)
    end
end

humanoid.AnimationPlayed:Connect(onAnimationPlayed)
--[[End of Uppercut anim]]

--[[Downslam animation fix]]
local animationId = 10470104242 --no

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

local function stopAllAnimations()
    for _, animTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
        animTrack:Stop()
    end
end

local function onAnimationPlayed(animationTrack)
    if animationTrack.Animation.AnimationId == "rbxassetid://" .. tostring(animationId) then
        stopAllAnimations()

        local AnimAnim = Instance.new("Animation")
        AnimAnim.AnimationId = "rbxassetid://136138918498003" --custom anim

        local Anim = animator:LoadAnimation(AnimAnim)

        Anim.Priority = Enum.AnimationPriority.Action2
        Anim.Looped = false
        
        Anim:Play()
        Anim.TimePosition = .02
        Anim:AdjustSpeed(1.5)

        task.delay(1.1, function() --edit this value to change end delay of anim
		Anim:Stop() --editor note: replace Anim.Stopped:Connect(function() with these two lines if any other func uses those lines
        end)
    end
end

humanoid.AnimationPlayed:Connect(onAnimationPlayed)
--[[end of Downslam anim]]

--[[Punch anims edited (added a func to remove anim weight so if you're using roblox made anims, they don't look absolutely doodoo)]]
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animationIdsToStop = {
    [17859015788] = true, -- downslam finisher
    [10469493270] = true, -- punch1
    [10469630950] = true, -- punch2
    [10469639222] = true, -- punch3
    [10469643643] = true, -- punch4
}

local replacementAnimations = {
    ["10469493270"] = "rbxassetid://14001963401",   -- punch1
    ["10469630950"] = "rbxassetid://15240176873",   -- punch2
    ["10469639222"] = "rbxassetid://14136436157",   -- punch3
    ["10469643643"] = "rbxassetid://13556985475",   -- punch4
    ["17859015788"] = "rbxassetid://14875667895", -- downslam finisher
    ["11365563255"] = "rbxassetid://15676072469"  -- punch idk
}

local queue = {}
local isAnimating = false

local function playReplacementAnimation(animationId)
    if isAnimating then
        table.insert(queue, animationId)
        return
    end

    isAnimating = true
    local replacementAnimationId = replacementAnimations[tostring(animationId)]
    if replacementAnimationId then
        local AnimAnim = Instance.new("Animation")
        AnimAnim.AnimationId = replacementAnimationId
        local Anim = humanoid:LoadAnimation(AnimAnim)
        
        Anim.Priority = Enum.AnimationPriority.Action2

        Anim:Play()

        Anim.Stopped:Connect(function()
            isAnimating = false
            if #queue > 0 then
                local nextAnimationId = table.remove(queue, 1)
                playReplacementAnimation(nextAnimationId)
            end
        end)
    else
        isAnimating = false
    end
end

local function stopSpecificAnimations()
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        local animationId = tonumber(track.Animation.AnimationId:match("%d+"))
        if animationIdsToStop[animationId] then
            track:Stop()
        end
    end
end

local function onAnimationPlayed(animationTrack)
    local animationId = tonumber(animationTrack.Animation.AnimationId:match("%d+"))
    if animationIdsToStop[animationId] then
        stopSpecificAnimations()
        animationTrack:Stop()
        local replacementAnimationId = replacementAnimations[tostring(animationId)]
        if replacementAnimationId then
            playReplacementAnimation(animationId)
        end
    end
end

humanoid.AnimationPlayed:Connect(onAnimationPlayed)

local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function onBodyVelocityAdded(bodyVelocity)
    if bodyVelocity:IsA("BodyVelocity") then
        bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, 0, bodyVelocity.Velocity.Z)
    end
end

character.DescendantAdded:Connect(onBodyVelocityAdded)

for _, descendant in pairs(character:GetDescendants()) do
    onBodyVelocityAdded(descendant)
end

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    character.DescendantAdded:Connect(onBodyVelocityAdded)
    for _, descendant in pairs(character:GetDescendants()) do
        onBodyVelocityAdded(descendant)
    end
end)
--[[End of edited punch anims]]

--[[Simple Moveset SFX func]]
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local soundSettings = {
    [14001963401] = { --M1 1
        soundId = "rbxassetid://182707266", --change
        volume = 1.2,
        pitch = 1
    },
    [15240176873] = { --M1 2
        soundId = "rbxassetid://182707266",
        volume = 1.2,
        pitch = 1.2
    },
    [14136436157] = { --M1 3
        soundId = "rbxassetid://6429404046",
        volume = 1.4,
        pitch = 0.9
    },
    [13556985475] = { --M1 4
        soundId = "rbxassetid://6957736499",
        volume = 1.6,
        pitch = 1.1
    },
    [13556985475] = { --M1 4
        soundId = "rbxassetid://6957736499",
        volume = 1.6,
        pitch = 1.1
    }
}

local function playSound(animationId)
    local head = character:FindFirstChild("Head")
    local settings = soundSettings[animationId]
    if head and settings then
        local sound = Instance.new("Sound")
        sound.SoundId = settings.soundId
        sound.Volume = settings.volume
        sound.PlaybackSpeed = settings.pitch
        sound.Parent = head
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end

local function onM1AnimationPlayed(animationTrack)
    local animationId = tonumber(animationTrack.Animation.AnimationId:match("%d+"))
    if soundSettings[animationId] then
        playSound(animationId)
    end
end

humanoid.AnimationPlayed:Connect(onM1AnimationPlayed)
--[[end of sfx func]]

--[[Simple M1 vfx (i hate this, i MIGHT make this more customizable in the future)]]
task.spawn(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    --effect animations (flat, sideways, spinning block)
    local effectAnimations = {
        [10469493270] = "flat", --M1 1
        [10469630950] = "flat", --M1 2
        [14136436157] = "sideways", --M1 3
        [14875667895] = "sideways", --Downslam
        [13556985475] = "spinningBlock" --M1 4
    }

    local function spawnSpinningBlock()
        task.wait(0.2) --Spawn delay

        local despawnDelay = .65 --Despawn delay
        local blockSize = Vector3.new(1, 1, 1) --block size (not important)
        local meshSize = Vector3.new(2.5, 2.5, 2.5) --mesh size

        local block = Instance.new("Part")
        block.Size = blockSize
        block.Transparency = 0
        block.Anchored = true
        block.CanCollide = false
        block.CanTouch = false
        block.CanQuery = false
        block.Material = Enum.Material.SmoothPlastic
        block.Parent = workspace

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshId = "rbxassetid://1295793357"
        mesh.TextureId = "rbxassetid://1295794098"
        mesh.Scale = meshSize
        mesh.Parent = block

        block.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, 0)

        local targetPosition = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 7.5
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(block, tweenInfo, {Position = targetPosition})
        tween:Play()

        task.spawn(function()
            while block.Parent do
                block.CFrame = block.CFrame * CFrame.Angles(0, math.rad(-150), 0)
                task.wait(0.05)
            end
        end)

        task.spawn(function()
            task.wait(despawnDelay)
            for i = 0, 1, 0.05 do
                block.Transparency = i
                task.wait(0.05)
            end
            block:Destroy()
        end)
    end

    local function spawnEffectPlane(animationId, positionType)
        task.wait(0.5) --spawn delay

        local despawnDelay = 1.5 --Despawn delay
        local size = Vector3.new(15, 0.1, 15) --Plane size
        local fadeTime = despawnDelay
        local decalId = "rbxassetid://5726444189"

        local plane = Instance.new("Part")
        plane.Size = size
        plane.Transparency = 1
        plane.Anchored = true
        plane.CanCollide = false
        plane.CanTouch = false
        plane.CanQuery = false
        plane.Parent = workspace

        plane.Position = humanoidRootPart.Position

        if positionType == "sideways" then
            plane.CFrame = humanoidRootPart.CFrame * CFrame.Angles(math.rad(90), 0, math.rad(-90))
        else
            plane.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(90), 0)
        end              

        local decals = {}
        for _, face in ipairs({Enum.NormalId.Top, Enum.NormalId.Bottom}) do
            local decal = Instance.new("Decal")
            decal.Texture = decalId
            decal.Face = face
            decal.Transparency = 0
            decal.Parent = plane
            table.insert(decals, decal)
        end

        task.spawn(function()
            for i = 0, 1, 0.05 do
                for _, decal in ipairs(decals) do
                    decal.Transparency = i
                end
                task.wait(fadeTime / 20)
            end
            plane:Destroy()
        end)
    end

    humanoid.AnimationPlayed:Connect(function(animationTrack)
        local animationId = tonumber(animationTrack.Animation.AnimationId:match("%d+"))
        local positionType = effectAnimations[animationId]
        
        if positionType == "spinningBlock" then
            spawnSpinningBlock()
        elseif positionType then
            spawnEffectPlane(animationId, positionType)
        end
    end)
end)
--[[Simple M1 vfx end]]

--[[Adding Quote or Message when Executed]]

--[[local player = game.Players.LocalPlayer
repeat wait() until player.Character
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Messages to send
local messages = {"MESSAGE x1", "MESSAGE x2", "MESSAGE x3", "MESSAGE x4"}

local function sendMessage(text)
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
end

for _, message in ipairs(messages) do
    sendMessage(message)
    wait(1.7)
end]] --de-comment-ify to enable

--[[END OF QUOTES]]

--[[Idle Animation]]

--[[local animationId = "rbxassetid://15099756132" --Replace with your animation ID
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator")

local animation = Instance.new("Animation")
animation.AnimationId = animationId
local animationTrack = animator:LoadAnimation(animation)

local function isMoving()
    local velocity = humanoid.MoveDirection.Magnitude
    return velocity > 0
end

while true do
    if not isMoving() then
        if not animationTrack.IsPlaying then
            animationTrack:Play()
        end
    else
        if animationTrack.IsPlaying then
            animationTrack:Stop()
        end
    end
    wait(0.1)
end]] --de-comment-ify to enable


--[[END OF IDLE ANIM]]

--[[Run Anim]]

--[[local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local animationId = "rbxassetid://15962326593" --Replace with your animation ID
local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack
local isMoving = false

local function playAnimation()
    if not animationTrack then
        animationTrack = animator:LoadAnimation(animation)
    end
    
    if not isMoving then
        isMoving = true
        animationTrack:Play()
    end
end

local function stopAnimation()
    if isMoving and animationTrack then
        isMoving = false
        animationTrack:Stop()
    end
end

local function onHumanoidChanged()
    if humanoid.MoveDirection.Magnitude > 0 then
        playAnimation()
    else
        stopAnimation()
    end
end

humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(onHumanoidChanged)

onHumanoidChanged()

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local animationId = "rbxassetid://15962326593" --Replace with your animation ID
local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack
local isMoving = false

local function playAnimation()
    if not animationTrack then
        animationTrack = animator:LoadAnimation(animation)
    end
    
    if not isMoving then
        isMoving = true
        animationTrack:Play()
    end
end

local function stopAnimation()
    if isMoving and animationTrack then
        isMoving = false
        animationTrack:Stop()
    end
end

local function onHumanoidChanged()
    if humanoid.MoveDirection.Magnitude > 0 then
        playAnimation()
    else
        stopAnimation()
    end
end

humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(onHumanoidChanged)

onHumanoidChanged()
humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(onHumanoidChanged)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local animationId = "rbxassetid://15962326593" --Replace with your animation ID
local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack
local isMoving = false

local function playAnimation()
    if not animationTrack then
        animationTrack = animator:LoadAnimation(animation)
    end
    
    if not isMoving then
        isMoving = true
        animationTrack:Play()
    end
end

local function stopAnimation()
    if isMoving and animationTrack then
        isMoving = false
        animationTrack:Stop()
    end
end

local function onHumanoidChanged()
    if humanoid.MoveDirection.Magnitude > 0 then
        playAnimation()
    else
        stopAnimation()
    end
end

humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(onHumanoidChanged)

onHumanoidChanged()

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local animationId = "rbxassetid://15962326593" --Replace with your animation ID
local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack
local isMoving = false

local function playAnimation()
    if not animationTrack then
        animationTrack = animator:LoadAnimation(animation)
    end
    
    if not isMoving then
        isMoving = true
        animationTrack:Play()
    end
end

local function stopAnimation()
    if isMoving and animationTrack then
        isMoving = false
        animationTrack:Stop()
    end
end

local function onHumanoidChanged()
    if humanoid.MoveDirection.Magnitude > 0 then
        playAnimation()
    else
        stopAnimation()
    end
end

humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(onHumanoidChanged)

onHumanoidChanged()

humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(onHumanoidChanged)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local animationId = "rbxassetid://15962326593" --Replace with your animation ID
local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack
local isMoving = false

local function playAnimation()
    if not animationTrack then
        animationTrack = animator:LoadAnimation(animation)
    end
    
    if not isMoving then
        isMoving = true
        animationTrack:Play()
    end
end

local function stopAnimation()
    if isMoving and animationTrack then
        isMoving = false
        animationTrack:Stop()
    end
end

local function onHumanoidChanged()
    if humanoid.MoveDirection.Magnitude > 0 then
        playAnimation()
    else
        stopAnimation()
    end
end

humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(onHumanoidChanged)

onHumanoidChanged()

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local animationId = "rbxassetid://15962326593" --Replace with your animation ID
local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack
local isMoving = false

local function playAnimation()
    if not animationTrack then
        animationTrack = animator:LoadAnimation(animation)
    end
    
    if not isMoving then
        isMoving = true
        animationTrack:Play()
    end
end

local function stopAnimation()
    if isMoving and animationTrack then
        isMoving = false
        animationTrack:Stop()
    end
end

local function onHumanoidChanged()
    if humanoid.MoveDirection.Magnitude > 0 then
        playAnimation()
    else
        stopAnimation()
    end
end

humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(onHumanoidChanged)

onHumanoidChanged()]] --de-comment-ify to enable

--[[RUN ANIM END]]

--[[Spawn Anim]] 

local p = game.Players.LocalPlayer
local character = p.Character or p.CharacterAdded:Wait()
local Humanoid = character:WaitForChild("Humanoid")
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

for _, animTrack in pairs(Humanoid:GetPlayingAnimationTracks()) do
    animTrack:Stop()
end

local AnimAnim = Instance.new("Animation")
AnimAnim.AnimationId = "rbxassetid://15957376722" --Replace with your animation I

local Anim = Humanoid:LoadAnimation(AnimAnim)

Anim.Priority = Enum.AnimationPriority.Action4
Anim.Looped = false

HumanoidRootPart.Anchored = true

Anim:Play()
Anim.TimePosition = 0.05
Anim:AdjustSpeed(2)

Anim.Stopped:Connect(function()
    HumanoidRootPart.Anchored = false
end)

--[[END OF SPAWN ANIM]]  

--[[Garou Color Changer !DELETE IF NOT NEEDED!]]

--[[LEFT ARM COLORS]]

--[[local char = game.Players.LocalPlayer.Character
getgenv().LArmCol = char['Left Arm'].ChildAdded:Connect(function(pp)
if pp.Name == 'WaterPalm' then
for i,v in pairs(pp:WaitForChild('ConstantEmit'):GetChildren()) do
v.Color =
ColorSequence.new{ColorSequenceKeypoint.new(0.00, 
Color3.fromRGB(255, 0, 0)), --Change Color (Red, Green, Blue)
ColorSequenceKeypoint.new(1.00, 
Color3.fromRGB(0, 0, 255))} --Change Color (Red, Green, Blue)
end

pp:WaitForChild('WaterTrail').Color = 
ColorSequence.new{ColorSequenceKeypoint.new(0.00, 
Color3.fromRGB(255, 0, 0)), --Change Color (Red, Green, Blue)
ColorSequenceKeypoint.new(1.00, 
Color3.fromRGB(0, 0, 255))} --Change Color (Red, Green, Blue)

end end)]] --de-comment-ify to enable

--[[RIGHT ARM colors]]

--[[getgenv().RArmCol = char['Right Arm'].ChildAdded:Connect(function(pp)
if pp.Name == 'WaterPalm' then
for i,v in pairs(pp:WaitForChild('ConstantEmit'):GetChildren()) do
v.Color =
ColorSequence.new{ColorSequenceKeypoint.new(0.00, 
Color3.fromRGB(255, 0, 0)), --Change Color (Red, Green, Blue)
ColorSequenceKeypoint.new(1.00, 
Color3.fromRGB(0, 0, 255))} --Change Color (Red, Green, Blue)
end
pp:WaitForChild('WaterTrail').Color = 
ColorSequence.new{ColorSequenceKeypoint.new(0.00, 
Color3.fromRGB(255, 0, 0)), --Change Color (Red, Green, Blue) 
ColorSequenceKeypoint.new(1.00, 
Color3.fromRGB(0, 0, 255))} --Change Color (Red, Green, Blue)

end end)]] --de-comment-ify to enable

--[[END OF GAROU COLORS]]