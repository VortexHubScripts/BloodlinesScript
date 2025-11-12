-- Halloween Farm Module
-- Place this file on GitHub and load it remotely

local HalloweenFarm = {}

-- ============================================
-- HALLOWEEN FARM SETTINGS
-- ============================================

getgenv().HalloweenFarmSettings = {
    Enabled = false,
    FarmPumpkins = true,
    PumpkinFarmDistance = 8,
    ServerHopWhenComplete = true,
    PanicMode = false,
    SafetyMode = false
}

-- ============================================
-- PUMPKIN POINT ESP
-- ============================================

getgenv().PumpkinESPSettings = {
    Enabled = false,
    Show = {
        Name = true,
        Distance = true,
    },
    TextSize = 18,
    MaxDistance = 99999
}

getgenv().ActivePumpkinESP = {}

local function createPumpkinESP(pumpkin)
    local Drawing = Drawing
    local esp = {
        NameText = Drawing.new("Text")
    }
    
    esp.NameText.Color = Color3.fromRGB(255, 165, 0)
    esp.NameText.Size = getgenv().PumpkinESPSettings.TextSize
    esp.NameText.Outline = true
    esp.NameText.Center = true
    esp.NameText.Visible = false

    getgenv().ActivePumpkinESP[pumpkin] = esp
    return esp
end

-- ============================================
-- SERVICES & REFERENCES
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local remotes = ReplicatedStorage:WaitForChild("Events")
local dataEvent = remotes:WaitForChild("DataEvent")

-- ============================================
-- IN DANGER STATE MANAGEMENT
-- ============================================

local inDanger = false

dataEvent.OnClientEvent:Connect(function(eventType, ...)
    if eventType == 'InDanger' then
        inDanger = true
    elseif eventType == 'OutOfDanger' then
        inDanger = false
    end
end)

local function updatePumpkinESP(pumpkin, esp)
    local Camera = workspace.CurrentCamera
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local Settings = getgenv().PumpkinESPSettings
        if not Settings.Enabled or not pumpkin or not pumpkin.Parent then
            esp.NameText.Visible = false
            if not pumpkin or not pumpkin.Parent then
                connection:Disconnect()
            end
            return
        end

        local main = pumpkin:FindFirstChild("Main")
        if main and main:IsA("BasePart") then
            local vector, onScreen = Camera:WorldToViewportPoint(main.Position)
            if onScreen then
                local distance = (Camera.CFrame.Position - main.Position).Magnitude

                if distance <= Settings.MaxDistance then
                    local info = {}
                    if Settings.Show.Name then 
                        table.insert(info, "[Pumpkin Point]") 
                    end
                    if Settings.Show.Distance then
                        table.insert(info, string.format("[%dm]", math.floor(distance)))
                    end

                    esp.NameText.Text = table.concat(info, " ")
                    esp.NameText.Size = Settings.TextSize
                    esp.NameText.Position = Vector2.new(vector.X, vector.Y)
                    esp.NameText.Visible = true
                else
                    esp.NameText.Visible = false
                end
            else
                esp.NameText.Visible = false
            end
        else
            esp.NameText.Visible = false
        end
    end)
end

local function onPumpkinPointAdded(pumpkinPoint)
    if pumpkinPoint.Name == "PumpkinPoint" and pumpkinPoint:IsA("Model") then
        local main = pumpkinPoint:WaitForChild("Main", 10)
        if main then
            local pumpkinESP = createPumpkinESP(pumpkinPoint)
            updatePumpkinESP(pumpkinPoint, pumpkinESP)

            pumpkinPoint.Destroying:Connect(function()
                if getgenv().ActivePumpkinESP[pumpkinPoint] then
                    for _, item in pairs(getgenv().ActivePumpkinESP[pumpkinPoint]) do
                        if item.Remove then item:Remove() end
                    end
                    getgenv().ActivePumpkinESP[pumpkinPoint] = nil
                end
            end)
        end
    end
end

-- Scan existing pumpkin points
for _, child in pairs(workspace:GetChildren()) do
    if child.Name == "PumpkinPoint" then
        task.spawn(onPumpkinPointAdded, child)
    end
end

-- Monitor for new pumpkin points
workspace.ChildAdded:Connect(function(child)
    if child.Name == "PumpkinPoint" then
        onPumpkinPointAdded(child)
    end
end)

-- ============================================
-- ITEM DETECTION SYSTEM (100m radius)
-- ============================================

local pickupList = {}
local IsA = game.IsA

local function onItemAdded(obj)
    task.spawn(function()
        if not obj:IsA('BasePart') and not obj:IsA('Model') then return end

        local pickupable, id, positionPart
        
        if obj:IsA('Model') then
            task.wait(0.1)
            
            local mainPart = obj:FindFirstChild('Main', true)
            if mainPart and mainPart:IsA('BasePart') then
                pickupable = mainPart:FindFirstChild('Pickupable')
                id = mainPart:FindFirstChild('ID')
                positionPart = mainPart
            end
            
            if not pickupable or not id then
                for _, descendant in pairs(obj:GetDescendants()) do
                    if descendant:IsA('BoolValue') and descendant.Name == 'Pickupable' then
                        pickupable = descendant
                    end
                    if descendant:IsA('StringValue') and descendant.Name == 'ID' then
                        id = descendant
                    end
                    if pickupable and id then break end
                end
            end
            
            if not positionPart then
                positionPart = obj:FindFirstChild('Main', true) or obj:FindFirstChildWhichIsA('BasePart', true)
            end
        else
            pickupable = obj:WaitForChild('Pickupable', 10)
            if not pickupable then return end
            
            id = obj:WaitForChild('ID', 10)
            if not id then return end
            
            positionPart = obj
        end
        
        if not pickupable or not id or not positionPart then return end
        if not positionPart:IsA('BasePart') then return end
        
        local pos = positionPart.Position
        pickupList[pos] = {
            obj = obj,
            id = id,
            positionPart = positionPart,
            name = obj.Name
        }

        obj.Destroying:Connect(function()
            pickupList[pos] = nil
        end)
    end)
end

-- Scan for existing items
for _, child in pairs(workspace:GetChildren()) do
    task.spawn(onItemAdded, child)
end

-- Monitor for new items
workspace.ChildAdded:Connect(onItemAdded)

-- ============================================
-- PANIC MODE & SAFETY MODE (MODIFIED)
-- ============================================

local panicModeConnection
local safetyModeConnections = {}
local safeSpotTeleportConnection = nil -- Track active safe spot teleport

-- Safe spot position
local SAFE_SPOT = Vector3.new(-2950.580, 321.173, -275.704)

-- Forward declaration
local performServerHop

-- Helper function to continuously teleport to safe spot
local function startConstantSafeSpotTeleport()
    -- Stop any existing safe spot teleport
    if safeSpotTeleportConnection then
        safeSpotTeleportConnection:Disconnect()
        safeSpotTeleportConnection = nil
    end
    
    -- Start continuous teleport
    safeSpotTeleportConnection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = CFrame.new(SAFE_SPOT)
            end
        end
    end)
end

-- Helper function to stop safe spot teleport
local function stopConstantSafeSpotTeleport()
    if safeSpotTeleportConnection then
        safeSpotTeleportConnection:Disconnect()
        safeSpotTeleportConnection = nil
    end
end

-- Panic Mode: Server hop when spectated
local function setupPanicMode()
    if panicModeConnection then
        panicModeConnection:Disconnect()
    end
    
    if not getgenv().HalloweenFarmSettings.PanicMode then return end
    
    local settingsFolder = ReplicatedStorage:FindFirstChild("Settings")
    if not settingsFolder then return end
    
    local playerFolder = settingsFolder:FindFirstChild(LocalPlayer.Name)
    if not playerFolder then return end
    
    panicModeConnection = playerFolder.ChildAdded:Connect(function(child)
        if not getgenv().HalloweenFarmSettings.PanicMode then return end
        if not getgenv().HalloweenFarmSettings.Enabled then return end
        
        if child.Name == "BeingObservedBy" and child:IsA("StringValue") then
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm - Panic Mode",
                    Text = "Being observed! Server hopping NOW!",
                    Duration = 3
                })
            end
            
            -- Start constant teleport to safe spot
            startConstantSafeSpotTeleport()
            
            -- Server hop immediately (ignore danger status)
            task.wait(0.5)
            performServerHop()
        end
    end)
end

-- Safety Mode: Teleport to safe spot when Chakra Sense is actively being used
local function setupSafetyMode()
    for _, conn in pairs(safetyModeConnections) do
        conn:Disconnect()
    end
    safetyModeConnections = {}
    
    if not getgenv().HalloweenFarmSettings.SafetyMode then return end
    
    local cooldownsFolder = ReplicatedStorage:FindFirstChild("Cooldowns")
    if not cooldownsFolder then return end
    
    local function monitorPlayerCooldowns(playerFolder)
        if playerFolder.Name == LocalPlayer.Name then return end
        
        local conn = playerFolder.ChildAdded:Connect(function(child)
            if not getgenv().HalloweenFarmSettings.SafetyMode then return end
            if not getgenv().HalloweenFarmSettings.Enabled then return end
            
            if child:IsA("NumberValue") and child.Name == "Chakra Sense" then
                if _G.NotificationLib then
                    _G.NotificationLib:MakeNotification({
                        Title = "Halloween Farm - Safety Mode",
                        Text = playerFolder.Name .. " used Chakra Sense! Going safe...",
                        Duration = 3
                    })
                end
            end
        end)
        table.insert(safetyModeConnections, conn)
    end
    
    -- Monitor existing players
    for _, playerFolder in pairs(cooldownsFolder:GetChildren()) do
        monitorPlayerCooldowns(playerFolder)
    end
    
    -- Monitor new players
    local addedConn = cooldownsFolder.ChildAdded:Connect(function(playerFolder)
        monitorPlayerCooldowns(playerFolder)
    end)
    table.insert(safetyModeConnections, addedConn)
end

-- ============================================
-- HALLOWEEN FARM CORE LOGIC
-- ============================================

local halloweenFarmThread
local halloweenFarmRunning = false
local currentHalloweenTarget = nil
local halloweenFarmConnections = {}
local currentPumpkinPoint = nil
local blacklistedPumpkins = {}
local lastKnownPumpkinPosition = nil

-- Helper function to get inDanger state
local function getInDanger()
    return inDanger == true
end

-- Helper function to create position key for blacklist
local function getPumpkinPositionKey(pumpkin)
    local main = pumpkin:FindFirstChild("Main")
    if main then
        return string.format("%.1f_%.1f_%.1f", main.Position.X, main.Position.Y, main.Position.Z)
    end
    return nil
end

-- Helper function to get player data
local function getPlayerData()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    return {
        character = character,
        rootPart = character:FindFirstChild("HumanoidRootPart"),
        humanoid = character:FindFirstChildOfClass("Humanoid")
    }
end

-- Helper function to check if anyone is actively sensing (defined at module level)
local function isAnyoneActivelySensing()
    if not getgenv().activeSenseUsers then 
        return false 
    end
    
    local activeSensors = {}
    for playerName, isActive in pairs(getgenv().activeSenseUsers) do
        if isActive then
            table.insert(activeSensors, playerName)
        end
    end
    
    if #activeSensors > 0 then
        return true
    end
    
    return false
end

-- ============================================
-- SERVER HOP FUNCTION (MODIFIED)
-- ============================================

performServerHop = function()
    if getInDanger() then
        if _G.NotificationLib then
            _G.NotificationLib:MakeNotification({
                Title = "Halloween Farm",
                Text = "In combat! Going to safe spot...",
                Duration = 3
            })
        end
        
        -- Start constant teleport to safe spot
        startConstantSafeSpotTeleport()
        
        -- Wait until out of danger
        while getInDanger() do
            wait(0.5)
        end
        
        if _G.NotificationLib then
            _G.NotificationLib:MakeNotification({
                Title = "Halloween Farm",
                Text = "Out of combat! Server hopping now...",
                Duration = 3
            })
        end
        
        wait(1)
    end
    
    local maxAttempts = 5
    local currentAttempt = 0
    
    while currentAttempt < maxAttempts do
        currentAttempt = currentAttempt + 1
        
        local success = pcall(function()
            local playerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
            local clientGui = playerGui:WaitForChild("ClientGui", 5)
            
            local list
            local mainframe = clientGui:FindFirstChild("Mainframe")
            
            if mainframe then
                local rest = mainframe:FindFirstChild("Rest")
                if rest then
                    local serverList = rest:FindFirstChild("ServerList")
                    if serverList then
                        local backdrop = serverList:FindFirstChild("BackDrop")
                        if backdrop then
                            list = backdrop:FindFirstChild("List")
                        end
                    end
                end
            end
            
            if not list or #list:GetChildren() == 0 then
                local menuScreen = clientGui:FindFirstChild("MenuScreen")
                if menuScreen then
                    local serverList = menuScreen:FindFirstChild("ServerList")
                    if serverList then
                        local backdrop = serverList:FindFirstChild("BackDrop")
                        if backdrop then
                            list = backdrop:FindFirstChild("List")
                        end
                    end
                end
            end
            
            if not list then return end
            
            local validServers = {}
            
            for _, frame in ipairs(list:GetChildren()) do
                if frame:IsA("Frame") and frame.Name == "ServerTemplate" then
                    local playersLabel = frame:FindFirstChild("Players")
                    local joinButton = frame:FindFirstChild("JoinButton")
                    
                    if playersLabel and joinButton and joinButton:IsA("TextButton") then
                        local playerText = playersLabel.Text
                        local playerCount = tonumber(playerText:match("%d+"))
                        
                        if playerCount and playerCount >= 10 then
                            table.insert(validServers, {
                                frame = frame,
                                button = joinButton,
                                playerCount = playerCount
                            })
                        end
                    end
                end
            end
            
            if #validServers == 0 then 
                return 
            end
            
            local randomIndex = math.random(1, #validServers)
            local selectedServer = validServers[randomIndex]
            
            pcall(function()
                for _, connection in pairs(getconnections(selectedServer.button.MouseButton1Click)) do
                    connection:Fire()
                end
            end)
        end)
        
        wait(2)
        
        if currentAttempt < maxAttempts then
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm",
                    Text = string.format("Server full! Retry %d/%d", currentAttempt + 1, maxAttempts),
                    Duration = 2
                })
            end
        else
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm",
                    Text = "Failed to find available server after 5 attempts",
                    Duration = 3
                })
            end
        end
    end
end

-- Function to check if any player is within distance of pumpkin
local function isPlayerNearPumpkin(pumpkin, maxDistance)
    local main = pumpkin:FindFirstChild("Main")
    if not main then return false end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local distance = (rootPart.Position - main.Position).Magnitude
                    if distance <= maxDistance then
                        return true, player.Name, distance
                    end
                end
            end
        end
    end
    return false
end

-- Function to find nearest available pumpkin point
local function findNearestAvailablePumpkinPoint()
    local playerData = getPlayerData()
    local rootPart = playerData and playerData.rootPart
    if not rootPart then return nil end
    
    local nearestPumpkin = nil
    local nearestDistance = math.huge
    
    for _, child in pairs(workspace:GetChildren()) do
        if child.Name == "PumpkinPoint" and child:IsA("Model") then
            local main = child:FindFirstChild("Main")
            if main then
                local destroyed = child:FindFirstChild("Destroyed")
                if destroyed and destroyed:IsA("BoolValue") and destroyed.Value == true then
                    continue
                end
                
                local posKey = getPumpkinPositionKey(child)
                
                if not blacklistedPumpkins[posKey] then
                    local distance = (rootPart.Position - main.Position).Magnitude
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestPumpkin = child
                    end
                end
            end
        end
    end
    
    return nearestPumpkin
end

-- Function to check if pumpkin has been destroyed
local function isPumpkinDestroyed(pumpkin)
    local destroyed = pumpkin:FindFirstChild("Destroyed")
    if destroyed and destroyed:IsA("BoolValue") then
        return destroyed.Value == true
    end
    return false
end

-- Function to check for items near player (100m radius)
local function checkForItemsNearPlayer()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local searchRadius = 100
    local myPosition = humanoidRootPart.Position
    
    for pos, itemData in pairs(pickupList) do
        local distance = (myPosition - pos).Magnitude
        if distance <= searchRadius then
            return true
        end
    end
    
    return false
end

-- Function to wait for items to spawn (with 2 second wait after detection)
local function waitForItemsNearPlayer()
    local itemDetected = checkForItemsNearPlayer()
    
    if itemDetected then
        if _G.NotificationLib then
            _G.NotificationLib:MakeNotification({
                Title = "Halloween Farm",
                Text = "Item found! Waiting 2 seconds...",
                Duration = 2
            })
        end
        task.wait(2)
        return true, true
    end
    
    local checkStartTime = tick()
    local maxWaitTime = 10
    
    while not itemDetected and (tick() - checkStartTime) < maxWaitTime do
        if not getgenv().HalloweenFarmSettings.Enabled then
            return false, false
        end
        
        itemDetected = checkForItemsNearPlayer()
        
        if itemDetected then
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm",
                    Text = "Item spawned! Waiting 2 seconds...",
                    Duration = 2
                })
            end
            task.wait(2)
            return true, true
        end
        
        wait(0.1)
    end
    
    if not itemDetected then
        if _G.NotificationLib then
            _G.NotificationLib:MakeNotification({
                Title = "Halloween Farm",
                Text = "No items, moving to next pumpkin...",
                Duration = 2
            })
        end
    end
    
    return true, itemDetected
end

-- Helper function to get visible candy count
local function getVisibleCandyCount()
    local playerBasket = workspace:FindFirstChild(LocalPlayer.Name)
    if not playerBasket then return 0 end
    
    local basket = playerBasket:FindFirstChild("Treat Basket")
    if not basket then return 0 end

    local count = 0
    for _, obj in pairs(basket:GetChildren()) do
        if obj:IsA("MeshPart") and obj.Name == "Candy" and obj.Transparency == 0 then
            count = count + 1
        end
    end
    return count
end

-- Helper function to auto fill basket
local function autoFillBasket()
    local function isValidNPC(model)
        if not model:IsA("Model") then
            return false
        end
        
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return false
        end
        
        local npcValue = model:FindFirstChild("NPC")
        if not npcValue or not npcValue:IsA("StringValue") then
            return false
        end
        
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return false
        end
        
        return true, hrp
    end
    
    local npcCount = 0
    for _, model in pairs(workspace:GetChildren()) do
        if getVisibleCandyCount() >= 8 then
            break
        end

        local isValid, hrp = isValidNPC(model)
        if isValid then
            local success = pcall(function()
                return ReplicatedStorage.Events.DataFunction:InvokeServer("trickOrTreat", hrp)
            end)
            
            if success then
                npcCount = npcCount + 1
            end
            
            task.wait(0.1)
        end
    end
end

-- ============================================
-- FARM PUMPKIN POINT (MODIFIED)
-- ============================================

local function farmPumpkinPoint(pumpkin)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    local main = pumpkin:FindFirstChild("Main")
    if not main then return false end
    
    currentHalloweenTarget = "Pumpkin Point"
    currentPumpkinPoint = pumpkin
    
    lastKnownPumpkinPosition = main.Position
    
    local pumpkinPosKey = getPumpkinPositionKey(pumpkin)
    
    if _G.NotificationLib then
        _G.NotificationLib:MakeNotification({
            Title = "Halloween Farm",
            Text = "Farming Pumpkin Point from below...",
            Duration = 3
        })
    end

    -- Attack thread
    local attackThread = task.spawn(function()
        while halloweenFarmRunning and currentHalloweenTarget == "Pumpkin Point" do
            wait(0.7)

            if halloweenFarmRunning and currentHalloweenTarget == "Pumpkin Point" then
                local atSafeSpot = (humanoidRootPart.Position - SAFE_SPOT).Magnitude < 10
                local someoneIsSensing = getgenv().HalloweenFarmSettings.SafetyMode and isAnyoneActivelySensing()
                
                if not atSafeSpot and not someoneIsSensing then
                    pcall(function()
                        dataEvent:FireServer("CheckMeleeHit", nil, "NormalAttack", false)
                    end)
                end
            end
        end
    end)
    
    -- Enable noclip
    local noclipConnection = RunService.Stepped:Connect(function()
        if halloweenFarmRunning and getgenv().HalloweenFarmSettings.Enabled then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA('BasePart') then
                    part.CanCollide = false
                end
            end
        end
    end)
    table.insert(halloweenFarmConnections, noclipConnection)
    
    -- Continuous teleport loop with Safety Mode check and safe spot timer
    local safeSpotStartTime = nil
    local teleportConnection = RunService.Heartbeat:Connect(function()
        if halloweenFarmRunning and getgenv().HalloweenFarmSettings.Enabled then
            if humanoidRootPart then
                if getgenv().HalloweenFarmSettings.SafetyMode and isAnyoneActivelySensing() then
                    humanoidRootPart.CFrame = CFrame.new(SAFE_SPOT)
                    
                    if not safeSpotStartTime then
                        safeSpotStartTime = tick()
                    elseif (tick() - safeSpotStartTime) >= 30 then
                        if _G.NotificationLib then
                            _G.NotificationLib:MakeNotification({
                                Title = "Halloween Farm - Safety Mode",
                                Text = "Hiding too long! Server hopping...",
                                Duration = 3
                            })
                        end
                        
                        task.spawn(function()
                            performServerHop()
                        end)
                    end
                else
                    safeSpotStartTime = nil
                    
                    if main and main.Parent then
                        lastKnownPumpkinPosition = main.Position
                    end
                    
                    local farmPosition = lastKnownPumpkinPosition - Vector3.new(0, getgenv().HalloweenFarmSettings.PumpkinFarmDistance, 0)
                    local lookAtPumpkin = CFrame.new(farmPosition, lastKnownPumpkinPosition)
                    humanoidRootPart.CFrame = lookAtPumpkin
                end
            end
        end
    end)
    table.insert(halloweenFarmConnections, teleportConnection)
    
    -- Main farming loop with two-tier health system
    local pumpkinDestroyed = false
    local lowHealthExit = false
    local criticalHealth = false
    
    while halloweenFarmRunning and currentHalloweenTarget == "Pumpkin Point" do
        -- First tier: Health at 50 or below - blacklist pumpkin and warn
        if humanoid.Health <= 50 and not lowHealthExit then
            lowHealthExit = true
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm",
                    Text = "HP at 50 or below! Watching health...",
                    Duration = 3
                })
            end
        end
        
        -- Second tier: Health at 25 or below (after first warning) - go to safe spot and server hop
        if lowHealthExit and humanoid.Health <= 25 and not criticalHealth then
            criticalHealth = true
            
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm",
                    Text = "Critical HP! Going to safe spot...",
                    Duration = 3
                })
            end
            
            -- Blacklist the pumpkin
            if pumpkinPosKey then
                blacklistedPumpkins[pumpkinPosKey] = true
            end
            
            -- Stop pumpkin teleporting
            if teleportConnection then
                teleportConnection:Disconnect()
                teleportConnection = nil
            end
            
            -- Start constant teleport to safe spot
            startConstantSafeSpotTeleport()
            
            -- Wait to be out of danger, then server hop
            local waitStartTime = tick()
            local maxSafeWaitTime = 30
            
            while (tick() - waitStartTime) < maxSafeWaitTime do
                if not getInDanger() then
                    if _G.NotificationLib then
                        _G.NotificationLib:MakeNotification({
                            Title = "Halloween Farm",
                            Text = "Out of danger! Server hopping...",
                            Duration = 3
                        })
                    end
                    break
                end
                wait(1)
            end
            
            -- Stop safe spot teleport before server hop
            stopConstantSafeSpotTeleport()
            
            if getgenv().HalloweenFarmSettings.ServerHopWhenComplete then
                performServerHop()
            end
            
            break
        end
        
        -- If low health but not critical, just move to next pumpkin
        if lowHealthExit and not criticalHealth and humanoid.Health > 25 then
            if pumpkinPosKey then
                blacklistedPumpkins[pumpkinPosKey] = true
            end
            
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm",
                    Text = "Low HP! Moving to next pumpkin...",
                    Duration = 3
                })
            end
            
            break
        end
        
        if not pumpkinDestroyed then
            if not pumpkin.Parent or not main.Parent then
                pumpkinDestroyed = true
            end
            
            if math.random(1, 10) == 1 then
                local playerNearby, playerName, distance = isPlayerNearPumpkin(pumpkin, 100)
                if playerNearby then
                    if pumpkinPosKey then
                        blacklistedPumpkins[pumpkinPosKey] = true
                    end
                    
                    if teleportConnection then
                        teleportConnection:Disconnect()
                        teleportConnection = nil
                    end
                    
                    -- Start constant safe spot teleport
                    startConstantSafeSpotTeleport()
                    wait(2)
                    stopConstantSafeSpotTeleport()
                    break
                end
            end
            
            if isPumpkinDestroyed(pumpkin) then
                if _G.NotificationLib then
                    _G.NotificationLib:MakeNotification({
                        Title = "Halloween Farm",
                        Text = "Pumpkin destroyed! Waiting for items...",
                        Duration = 3
                    })
                end
                pumpkinDestroyed = true
            end
        end
        
        if pumpkinDestroyed then
            if getgenv().HalloweenFarmSettings.Enabled then
                local itemsSpawned, itemDetected = waitForItemsNearPlayer()
                
                if itemsSpawned and itemDetected then
                    -- Stop pumpkin teleporting
                    if teleportConnection then
                        teleportConnection:Disconnect()
                        teleportConnection = nil
                    end
                    
                    -- Start constant safe spot teleport
                    startConstantSafeSpotTeleport()
                    wait(1)
                    stopConstantSafeSpotTeleport()
                    
                    -- [Rest of candy collection logic remains the same...]
                    
                    break
                else
                    break
                end
            else
                break
            end
        end
        
        RunService.Heartbeat:Wait()
    end
    
    if attackThread then
        task.cancel(attackThread)
    end
    
    return true
end

-- Function to revisit blacklisted pumpkins
local function recheckBlacklistedPumpkins()
    local availablePumpkins = {}
    
    for posKey, _ in pairs(blacklistedPumpkins) do
        for _, child in pairs(workspace:GetChildren()) do
            if child.Name == "PumpkinPoint" and child:IsA("Model") then
                local currentPosKey = getPumpkinPositionKey(child)
                if currentPosKey == posKey then
                    local destroyed = child:FindFirstChild("Destroyed")
                    if not destroyed or not destroyed.Value then
                        local playerNearby = isPlayerNearPumpkin(child, 100)
                        if not playerNearby then
                            table.insert(availablePumpkins, child)
                            blacklistedPumpkins[posKey] = nil
                        end
                    else
                        blacklistedPumpkins[posKey] = nil
                    end
                    break
                end
            end
        end
    end
    
    return availablePumpkins
end

-- ============================================
-- MAIN HALLOWEEN FARM LOOP (MODIFIED RESET)
-- ============================================

local function startHalloweenFarm()
    if halloweenFarmRunning then return end
    
    halloweenFarmThread = task.spawn(function()
        halloweenFarmRunning = true
        
        -- Check if player needs to reset due to low HP
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health < 50 then
                if _G.NotificationLib then
                    _G.NotificationLib:MakeNotification({
                        Title = "Halloween Farm",
                        Text = "Low HP detected! Checking danger status...",
                        Duration = 3
                    })
                end
                
                -- Check if in danger - if so, wait until safe
                if getInDanger() then
                    if _G.NotificationLib then
                        _G.NotificationLib:MakeNotification({
                            Title = "Halloween Farm",
                            Text = "In combat! Waiting to be safe before reset...",
                            Duration = 3
                        })
                    end
                    
                    -- Start constant teleport to safe spot
                    startConstantSafeSpotTeleport()
                    
                    -- Wait until out of danger
                    while getInDanger() do
                        wait(0.5)
                    end
                    
                    -- Stop constant teleport
                    stopConstantSafeSpotTeleport()
                    
                    if _G.NotificationLib then
                        _G.NotificationLib:MakeNotification({
                            Title = "Halloween Farm",
                            Text = "Out of combat! Now resetting...",
                            Duration = 3
                        })
                    end
                    
                    wait(1)
                end
                
                -- Now safe to reset
                if _G.NotificationLib then
                    _G.NotificationLib:MakeNotification({
                        Title = "Halloween Farm",
                        Text = "Resetting character...",
                        Duration = 3
                    })
                end
                
                -- Reset character
                humanoid.Health = 0
                
                -- Wait for respawn
                character = LocalPlayer.CharacterAdded:Wait()
                humanoid = character:WaitForChild("Humanoid")
                character:WaitForChild("HumanoidRootPart")
                
                -- Wait for full health
                while humanoid.Health < humanoid.MaxHealth do
                    wait(0.5)
                end
                
                if _G.NotificationLib then
                    _G.NotificationLib:MakeNotification({
                        Title = "Halloween Farm",
                        Text = "Reset complete! Starting farm...",
                        Duration = 3
                    })
                end
                
                wait(1)
            end
        end
        
        -- [Rest of farm logic continues...]
    end)
end

-- ============================================
-- STOP HALLOWEEN FARM (MODIFIED)
-- ============================================

local function stopHalloweenFarm()
    -- Only teleport to safe spot if farm was actually running
    local wasRunning = halloweenFarmRunning
    
    halloweenFarmRunning = false
    currentHalloweenTarget = nil
    currentPumpkinPoint = nil
    
    -- Stop any constant safe spot teleport
    stopConstantSafeSpotTeleport()
    
    -- Teleport player to safe spot only if farm was running (single teleport now)
    if wasRunning then
        local playerData = getPlayerData()
        local rootPart = playerData and playerData.rootPart
        if rootPart then
            rootPart.CFrame = CFrame.new(SAFE_SPOT)
        end
    end
    
    -- Clean up Panic Mode connection
    if panicModeConnection then
        panicModeConnection:Disconnect()
        panicModeConnection = nil
    end
    
    -- Clean up Safety Mode connections
    for _, conn in pairs(safetyModeConnections) do
        conn:Disconnect()
    end
    safetyModeConnections = {}
    
    for _, connection in pairs(halloweenFarmConnections) do
        if connection and connection.Connected then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    halloweenFarmConnections = {}
    
    if halloweenFarmThread then
        pcall(function()
            task.cancel(halloweenFarmThread)
        end)
        halloweenFarmThread = nil
    end
end

-- Function to reset blacklisted pumpkins
local function resetBlacklist()
    blacklistedPumpkins = {}
    if _G.NotificationLib then
        _G.NotificationLib:MakeNotification({
            Title = "Halloween Farm",
            Text = "Blacklist cleared!",
            Duration = 3
        })
    end
end

-- Function to get current farm status
local function getFarmStatus()
    return {
        running = halloweenFarmRunning,
        currentTarget = currentHalloweenTarget,
        blacklistedCount = (function()
            local count = 0
            for _ in pairs(blacklistedPumpkins) do
                count = count + 1
            end
            return count
        end)()
    }
end

-- ============================================
-- AUTO PICKUP CANDY FEATURE
-- ============================================

local AutoPickupCandyRunning = false
local candyConnections = {}

local function pickupCandy(candyObj)
    local clickDetector = candyObj:FindFirstChild("ItemDetector")
    if clickDetector and clickDetector:IsA("ClickDetector") then
        pcall(function()
            fireclickdetector(clickDetector)
        end)
    end
end

local function startAutoPickupCandy()
    AutoPickupCandyRunning = true
    
    task.spawn(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if AutoPickupCandyRunning and obj:IsA("MeshPart") and obj.Name == "Candy" then
                pickupCandy(obj)
            end
        end
    end)
    
    local connection = workspace.DescendantAdded:Connect(function(obj)
        if AutoPickupCandyRunning and obj:IsA("MeshPart") and obj.Name == "Candy" then
            task.wait(0.1)
            pickupCandy(obj)
        end
    end)
    
    table.insert(candyConnections, connection)
end

local function stopAutoPickupCandy()
    AutoPickupCandyRunning = false
    
    for _, connection in pairs(candyConnections) do
        connection:Disconnect()
    end
    candyConnections = {}
end

-- Export functions
HalloweenFarm.startFarm = startHalloweenFarm
HalloweenFarm.stopFarm = stopHalloweenFarm
HalloweenFarm.resetBlacklist = resetBlacklist
HalloweenFarm.getFarmStatus = getFarmStatus
HalloweenFarm.startAutoPickupCandy = startAutoPickupCandy
HalloweenFarm.stopAutoPickupCandy = stopAutoPickupCandy
HalloweenFarm.autoFillBasket = autoFillBasket
HalloweenFarm.updatePanicMode = updatePanicMode
HalloweenFarm.updateSafetyMode = updateSafetyMode

return HalloweenFarm
