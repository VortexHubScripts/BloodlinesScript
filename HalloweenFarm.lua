-- Halloween Farm Module
-- Place this file on GitHub and load it remotely

local HalloweenFarm = {}

-- ============================================
-- HALLOWEEN FARM SETTINGS
-- ============================================

getgenv().HalloweenFarmSettings = {
    Enabled = false,
    FarmPumpkins = true,
    CollectCandy = true,
    PumpkinFarmDistance = 8,
    ServerHopWhenComplete = true
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
-- IN DANGER STATE MANAGEMENT (FIXED)
-- ============================================

-- Setup danger state listener
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local remotes = ReplicatedStorage:WaitForChild("Events")
local dataEvent = remotes:WaitForChild("DataEvent")

-- Local inDanger state
local inDanger = false

-- Listen for danger state changes and update local state
dataEvent.OnClientEvent:Connect(function(eventType, ...)
    if eventType == 'InDanger' then
        inDanger = true
        print("[Halloween Farm] DANGER STATE: IN DANGER")
    elseif eventType == 'OutOfDanger' then
        inDanger = false
        print("[Halloween Farm] DANGER STATE: OUT OF DANGER")
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
-- HALLOWEEN FARM CORE LOGIC
-- ============================================

local halloweenFarmThread
local halloweenFarmRunning = false
local currentHalloweenTarget = nil
local halloweenFarmConnections = {}
local currentPumpkinPoint = nil
local blacklistedPumpkins = {}
local lastKnownPumpkinPosition = nil

-- Safe spot position
local SAFE_SPOT = Vector3.new(-2950.580, 321.173, -275.704)

-- Helper function to get inDanger state (now reads from global)
local function getInDanger()
    return getgenv().inDanger == true
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

-- Function to constantly teleport player to safe spot
local function constantTeleportToSafeSpot()
    local playerData = getPlayerData()
    local rootPart = playerData and playerData.rootPart
    if not rootPart then return end
    
    print("[Halloween Farm] Starting constant teleport to safe spot...")
    if _G.NotificationLib then
        _G.NotificationLib:MakeNotification({
            Title = "Halloween Farm",
            Text = "Teleporting to safe spot...",
            Duration = 3
        })
    end
    
    local safeSpotConnection = RunService.Heartbeat:Connect(function()
        if rootPart and rootPart.Parent then
            rootPart.CFrame = CFrame.new(SAFE_SPOT)
        end
    end)
    
    return safeSpotConnection
end

-- Function to server hop with retry logic
local function performServerHop()
    print("[Halloween Farm] Initiating fast server hop...")
    
    -- IMPROVED: Check if player is in danger and wait until safe
    if getInDanger() then
        print("[Halloween Farm] Player is in combat! Teleporting to safe spot and waiting...")
        if _G.NotificationLib then
            _G.NotificationLib:MakeNotification({
                Title = "Halloween Farm",
                Text = "In combat! Going to safe spot...",
                Duration = 3
            })
        end
        
        -- Teleport to safe spot immediately
        local playerData = getPlayerData()
        local rootPart = playerData and playerData.rootPart
        if rootPart then
            rootPart.CFrame = CFrame.new(SAFE_SPOT)
        end
        
        -- Wait until out of danger
        while getInDanger() do
            wait(0.5)
            print("[Halloween Farm] Still in combat, waiting...")
        end
        
        print("[Halloween Farm] Out of combat! Proceeding with server hop...")
        if _G.NotificationLib then
            _G.NotificationLib:MakeNotification({
                Title = "Halloween Farm",
                Text = "Out of combat! Server hopping now...",
                Duration = 3
            })
        end
        
        -- Wait an additional 1 second to ensure we're fully safe
        wait(1)
    end
    
    local maxAttempts = 5
    local currentAttempt = 0
    
    while currentAttempt < maxAttempts do
        currentAttempt = currentAttempt + 1
        print(string.format("[Halloween Farm] Server hop attempt %d/%d", currentAttempt, maxAttempts))
        
        local success, err = pcall(function()
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
                print("[Halloween Farm] No valid servers found")
                return 
            end
            
            local randomIndex = math.random(1, #validServers)
            local selectedServer = validServers[randomIndex]
            
            print(string.format("[Halloween Farm] Attempting to join server with %d players...", selectedServer.playerCount))
            
            pcall(function()
                for _, connection in pairs(getconnections(selectedServer.button.MouseButton1Click)) do
                    connection:Fire()
                end
            end)
        end)
        
        if not success then
            warn("[Halloween Farm] Server hop attempt failed:", err)
        end
        
        -- Wait 2 seconds to see if teleport happens
        wait(2)
        
        -- If we're still here after 2 seconds, the server was likely full
        if currentAttempt < maxAttempts then
            print("[Halloween Farm] Server likely full, retrying with different server...")
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm",
                    Text = string.format("Server full! Retry %d/%d", currentAttempt + 1, maxAttempts),
                    Duration = 2
                })
            end
        else
            print("[Halloween Farm] Max server hop attempts reached")
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

-- Function to check for items near player (using ItemESP)
local function checkForItemsNearPlayer()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local searchRadius = 50
    
    if not getgenv().ActiveItemESP then return false end
    
    for item, esp in pairs(getgenv().ActiveItemESP) do
        if item and item.Parent and item:IsA("BasePart") then
            local distance = (item.Position - humanoidRootPart.Position).Magnitude
            if distance <= searchRadius then
                return true
            end
        end
    end
    
    return false
end

-- Function to wait for items to spawn
local function waitForItemsNearPlayer()
    print("[Halloween Farm] Waiting for items to spawn within 50m...")
    
    local itemDetected = checkForItemsNearPlayer()
    
    if itemDetected then
        print("[Halloween Farm] Item already exists! Moving to next pumpkin immediately...")
        if _G.NotificationLib then
            _G.NotificationLib:MakeNotification({
                Title = "Halloween Farm",
                Text = "Item found! Moving to next pumpkin...",
                Duration = 2
            })
        end
        return true, true
    end
    
    print("[Halloween Farm] No existing items. Monitoring ItemESP for new spawns...")
    
    local checkStartTime = tick()
    local maxWaitTime = 10
    
    while not itemDetected and (tick() - checkStartTime) < maxWaitTime do
        if not getgenv().HalloweenFarmSettings.Enabled then
            return false, false
        end
        
        itemDetected = checkForItemsNearPlayer()
        
        if itemDetected then
            print("[Halloween Farm] Item spawned! Moving to next pumpkin immediately...")
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm",
                    Text = "Item spawned! Moving to next pumpkin...",
                    Duration = 2
                })
            end
            return true, true
        end
        
        wait(0.1)
    end
    
    if not itemDetected then
        print("[Halloween Farm] No items detected after 6 seconds. Moving to next pumpkin immediately...")
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

-- Helper function to check if player has Treat Basket equipped
local function hasTreatBasketEquipped()
    local character = LocalPlayer.Character
    if not character then return false end
    
    local treatBasket = character:FindFirstChild("Treat Basket")
    return treatBasket ~= nil
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
    print("[Halloween Farm] Starting Auto Fill Basket...")
    
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
            print("[Halloween Farm] Basket reached 8 visible candies")
            break
        end

        local isValid, hrp = isValidNPC(model)
        if isValid then
            local success, result = pcall(function()
                return ReplicatedStorage.Events.DataFunction:InvokeServer("trickOrTreat", hrp)
            end)
            
            if success then
                npcCount = npcCount + 1
                print("[Halloween Farm] Successfully ran trickOrTreat on:", model.Name)
            end
            
            task.wait(0.1)
        end
    end
    
    print("[Halloween Farm] Finished! Ran trickOrTreat on", npcCount, "NPCs")
end

-- Function to farm pumpkin point
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
    
    local healthThreshold = 50
    print(string.format("[Halloween Farm] Health threshold: 50 HP"))
    
    print("[Halloween Farm] Farming Pumpkin Point from below...")
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
                pcall(function()
                    dataEvent:FireServer("CheckMeleeHit", nil, "NormalAttack", false)
                end)
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
    
    -- Continuous teleport loop
    local teleportConnection = RunService.Heartbeat:Connect(function()
        if halloweenFarmRunning and getgenv().HalloweenFarmSettings.Enabled then
            if humanoidRootPart then
                if main and main.Parent then
                    lastKnownPumpkinPosition = main.Position
                end
                
                local farmPosition = lastKnownPumpkinPosition - Vector3.new(0, getgenv().HalloweenFarmSettings.PumpkinFarmDistance, 0)
                local lookAtPumpkin = CFrame.new(farmPosition, lastKnownPumpkinPosition)
                humanoidRootPart.CFrame = lookAtPumpkin
            end
        end
    end)
    table.insert(halloweenFarmConnections, teleportConnection)
    
    -- Main farming loop
    local pumpkinDestroyed = false
    local lowHealthExit = false
    
    while halloweenFarmRunning and currentHalloweenTarget == "Pumpkin Point" do
        -- Health check
        if humanoid.Health < healthThreshold and not lowHealthExit then
            print(string.format("[Halloween Farm] Health below 50 HP! (%.1f < %.1f)", humanoid.Health, healthThreshold))
            if _G.NotificationLib then
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Farm",
                    Text = "Low HP! Going to safe spot...",
                    Duration = 3
                })
            end
            
            -- Blacklist this pumpkin
            if pumpkinPosKey then
                blacklistedPumpkins[pumpkinPosKey] = true
                print("[Halloween Farm] Blacklisted pumpkin due to low HP")
            end
            
            lowHealthExit = true
            
            -- Stop the teleport to pumpkin
            if teleportConnection then
                teleportConnection:Disconnect()
                teleportConnection = nil
            end
            
            -- Teleport to safe spot
            print("[Halloween Farm] Teleporting to safe spot...")
            humanoidRootPart.CFrame = CFrame.new(SAFE_SPOT)
            
            -- Wait at safe spot while checking danger status
            local waitStartTime = tick()
            local maxSafeWaitTime = 30 -- Wait up to 30 seconds at safe spot
            
            while (tick() - waitStartTime) < maxSafeWaitTime do
                if not getInDanger() then
                    print("[Halloween Farm] Out of danger! Continuing to next pumpkin...")
                    if _G.NotificationLib then
                        _G.NotificationLib:MakeNotification({
                            Title = "Halloween Farm",
                            Text = "Safe! Moving to next pumpkin...",
                            Duration = 3
                        })
                    end
                    break
                end
                print("[Halloween Farm] Still in danger, waiting at safe spot...")
                wait(1)
            end
            
            -- If still in danger after 30 seconds, attempt server hop
            if getInDanger() then
                print("[Halloween Farm] Still in danger after 30s! Attempting server hop...")
                if _G.NotificationLib then
                    _G.NotificationLib:MakeNotification({
                        Title = "Halloween Farm",
                        Text = "Still in combat! Server hopping...",
                        Duration = 3
                    })
                end
                
                if getgenv().HalloweenFarmSettings.ServerHopWhenComplete then
                    performServerHop()
                end
            end
            
            break
        end
        
        if not pumpkinDestroyed then
            if not pumpkin.Parent or not main.Parent then
                print("[Halloween Farm] Pumpkin Point despawned")
                pumpkinDestroyed = true
            end
            
            if math.random(1, 10) == 1 then
                local playerNearby, playerName, distance = isPlayerNearPumpkin(pumpkin, 100)
                if playerNearby then
                    print(string.format("[Halloween Farm] Player %s detected within %.1fm!", playerName, distance))
                    
                    if pumpkinPosKey then
                        blacklistedPumpkins[pumpkinPosKey] = true
                    end
                    
                    if teleportConnection then
                        teleportConnection:Disconnect()
                        teleportConnection = nil
                    end
                    
                    local safeSpotConnection = constantTeleportToSafeSpot()
                    table.insert(halloweenFarmConnections, safeSpotConnection)
                    
                    wait(2)
                    break
                end
            end
            
            if isPumpkinDestroyed(pumpkin) then
                print("[Halloween Farm] Pumpkin Point destroyed! Staying in position and waiting for items...")
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
                    print("[Halloween Farm] Items collected! Starting Treat Basket sequence...")
                    
                    local wasAutoEquipEnabled = getgenv().AutoEquipSettings and getgenv().AutoEquipSettings.Enabled
                    if wasAutoEquipEnabled then
                        print("[Halloween Farm] Disabling Auto-Equip Weapon...")
                        getgenv().AutoEquipSettings.Enabled = false
                        if setupAutoEquip then
                            setupAutoEquip(false)
                        end
                    end
                    
                    print("[Halloween Farm] Equipping Treat Basket...")
                    pcall(function()
                        dataEvent:FireServer("Item", "Selected", "Treat Basket")
                    end)
                    
                    wait(1)
                    
                    local basketAppeared = false
                    local checkStartTime = tick()
                    local maxWaitTime = 5
                    
                    while not basketAppeared and (tick() - checkStartTime) < maxWaitTime do
                        if hasTreatBasketEquipped() then
                            basketAppeared = true
                            print("[Halloween Farm] Treat Basket equipped!")
                            break
                        end
                        wait(0.1)
                    end
                    
                    if basketAppeared then
                        print("[Halloween Farm] Treat Basket detected! Pausing farm and going to safe spot...")
                        if _G.NotificationLib then
                            _G.NotificationLib:MakeNotification({
                                Title = "Halloween Farm",
                                Text = "Treat Basket equipped! Collecting candy...",
                                Duration = 3
                            })
                        end
                        
                        humanoidRootPart.CFrame = CFrame.new(SAFE_SPOT)
                        wait(1)
                        
                        autoFillBasket()
                        
                        print("[Halloween Farm] Waiting for basket to fill...")
                        local fillStartTime = tick()
                        local maxFillTime = 15
                        
                        while (tick() - fillStartTime) < maxFillTime do
                            local candyCount = getVisibleCandyCount()
                            if candyCount >= 8 then
                                print("[Halloween Farm] Basket full! (" .. candyCount .. "/8 candy)")
                                break
                            end
                            wait(0.5)
                        end
                        
                        print("[Halloween Farm] Consuming Treat Basket...")
                        if _G.NotificationLib then
                            _G.NotificationLib:MakeNotification({
                                Title = "Halloween Farm",
                                Text = "Consuming Treat Basket...",
                                Duration = 3
                            })
                        end
                        
                        pcall(function()
                            dataEvent:FireServer("Consumed", "Treat Basket")
                        end)
                        
                        wait(1)
                        
                        if wasAutoEquipEnabled then
                            print("[Halloween Farm] Re-enabling Auto-Equip Weapon...")
                            getgenv().AutoEquipSettings.Enabled = true
                            if setupAutoEquip then
                                setupAutoEquip(true)
                            end
                        end
                        
                        print("[Halloween Farm] Treat Basket sequence complete!")
                        if _G.NotificationLib then
                            _G.NotificationLib:MakeNotification({
                                Title = "Halloween Farm",
                                Text = "Treat Basket consumed! Resuming farm...",
                                Duration = 3
                            })
                        end
                    else
                        print("[Halloween Farm] Treat Basket did not appear, skipping sequence...")
                        
                        if wasAutoEquipEnabled then
                            getgenv().AutoEquipSettings.Enabled = true
                            if setupAutoEquip then
                                setupAutoEquip(true)
                            end
                        end
                    end
