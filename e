local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

--[[ ============================================
-- SIMPLIFIED AUTO-LOAD SYSTEM
-- Bishop Hub - Bloodlines Integration
-- ============================================]]

-- Configuration
local LUARMOR_LOADER_URL = "https://api.luarmor.net/files/v3/loaders/d279815a96f67f22235a598658c8b59c.lua"

-- Storage for captured keys
local capturedKeys = {}
local currentScriptKey = nil

-- ============================================
-- KEY CAPTURE SYSTEM (Simplified)
-- ============================================

-- Monitor global script_key changes
task.spawn(function()
    while true do
        task.wait(0.5)
        
        if script_key and script_key ~= currentScriptKey then
            currentScriptKey = script_key
            print("[Key Captured] " .. script_key)
        end
    end
end)

function getLastKey()
    return currentScriptKey
end

-- ============================================
-- OPTIMIZED TELEPORT AUTO-LOAD
-- ============================================

local queue_on_teleport = queue_on_teleport 
    or syn and syn.queue_on_teleport 
    or fluxus and fluxus.queue_on_teleport 
    or function(code)
        warn("[Queue on Teleport] Not supported by executor")
        return code
    end

LocalPlayer.OnTeleport:Connect(function(state)
    if state ~= Enum.TeleportState.Started and state ~= Enum.TeleportState.InProgress then 
        return 
    end
    
    local keyToUse = getLastKey()
    
    -- OPTIMIZED: Much shorter auto-load script
    local autoLoadScript = string.format([[
        repeat task.wait() until game:IsLoaded()
        
        if game.PlaceId ~= %d then return end
        if getgenv().Executed then return end
        getgenv().Executed = true
        
        wait(2)
        
        script_key = "%s"
        loadstring(game:HttpGet("%s"))()
    ]], 
    REQUIRED_GAME_ID,
    keyToUse or "",
    LUARMOR_LOADER_URL)
    
    queue_on_teleport(autoLoadScript)
    
    print("[Auto-Load] Queued for next teleport")
    if keyToUse then
        print("[Auto-Load] Key captured: " .. keyToUse)
    end
end)

-- ============================================
-- MANUAL LOAD FUNCTIONS (Simplified)
-- ============================================

function loadWithKey(key)
    if game.PlaceId ~= REQUIRED_GAME_ID then
        warn("[Load Error] Wrong game!")
        return
    end
    
    script_key = key
    currentScriptKey = key
    
    print("[Manual Load] Loading Bishop Hub...")
    loadstring(game:HttpGet(LUARMOR_LOADER_URL))()
end

function quickLoad()
    local key = getLastKey()
    
    if not key then
        warn("[Quick Load] No key captured yet!")
        return
    end
    
    loadWithKey(key)
end

_G.loadWithKey = loadWithKey
_G.quickLoad = quickLoad

-- ============================================
-- ANTI-AFK
-- ============================================

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end
print("[Anti-AFK] Enabled")

-- ============================================
-- STATUS MESSAGE
-- ============================================

if game.PlaceId ~= REQUIRED_GAME_ID then
    warn("\n" .. string.rep("=", 50))
    warn("  WRONG GAME DETECTED!")
    warn("  This is for Bloodlines only")
    warn(string.rep("=", 50) .. "\n")
    return
end

print("\n" .. string.rep("=", 50))
print("  BISHOP HUB - AUTO-LOAD SYSTEM")
print("  Game: Bloodlines")
print("  Status: Active")
print(string.rep("=", 50) .. "\n")

if queue_on_teleport ~= function() end then
    print("[✓] Auto-load on teleport: Supported")
else
    warn("[✗] Auto-load on teleport: Not Supported")
end

task.spawn(function()
    task.wait(2)
    if currentScriptKey then
        print("\n[✓] Key Captured: " .. currentScriptKey)
        print("[✓] Auto-load configured")
    else
        print("\n[!] No key detected yet")
    end
end)

task.wait()

-- ============================================
-- LOAD UI LIBRARY
-- ============================================

local repo = 'https://raw.githubusercontent.com/VortexHubScripts/LinoriaUI/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/VortexHubScripts/LinoriaUI/refs/heads/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

if not _G.NotificationLib then
    _G.NotificationLib = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/VortexHubScripts/NotificationSystem/refs/heads/main/Main"))()
end

-- ============================================
-- SERVICES
-- ============================================

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = workspace.CurrentCamera

-- ============================================
-- GLOBAL SETTINGS INITIALIZATION
-- ============================================

getgenv().MovementSettings = {
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    WalkSpeed = 50,
    NoClip = false,
    NoFallDamage = false,
}

getgenv().VisualSettings = {
    TimeChanger = false,
    TimeOfDay = "Morning",
    NoFog = false,
    NoRain = false,
    FullBright = false,
    BrightnessLevel = 5
}

getgenv().AutoEquipSettings = {
    Enabled = false,
    SelectedWeapon = "Golden Resanagi"
}

getgenv().ESPSettings = {
    Enabled = true,
    Show = {
        Name = true,
        Health = true,
        Distance = true,
        Clan = true,
        FreshyChecker = false,
        JutsuPrediction = false,
    },
    TextSize = 18,
    TextPosition = -20,
    HealthBarWidth = 5,
    BoxSizeMultiplier = 0.1,
    MaxDistance = 100
}

getgenv().MobESPSettings = {
    Enabled = false,
    Show = {
        Name = true,
        Health = true,
        Distance = true,
    },
    TextSize = 18,
    MaxDistance = 100
}

getgenv().ItemESPSettings = {
    Enabled = false,
    Show = {
        Name = true,
        Distance = true,
    },
    TextSize = 18,
    MaxDistance = 100
}

getgenv().FruitESPSettings = {
    Enabled = true,
    Show = {
        Name = true,
        Distance = true,
    },
    TextSize = 18,
    MaxDistance = 99999
}

getgenv().MiscSettings = {
    AutoPickup = false,
    NoKillBricks = false,
    InfiniteJumpCounter = false,
    ChatLogger = false,
    ChakraSenseAlert = true,
    Spectate = false,
    ObserverAlert = true,
    NoBlindness = false,
    WarnIfMod = false,
    ChakraCharge = false,
    ChakraBoost = false,
    ChakraBoostAmount = 1
}

getgenv().HalloweenCandyFarmSettings = {
    Enabled = false,
    SelectedBosses = {"Barbarit The Hallowed"},
    ActiveSenseTimeout = 20,
    SafetyMode = false,
    CollectRewards = true,
    CustomSafeSpot = nil,
    BossSettings = {
        ["Barbarit The Hallowed"] = {
            FarmDistance = 16,
            DodgeSpinAttack = false
        },
        ["Hallowed Chakra Knight"] = {
            FarmDistance = 16,
            DodgeSpearAttack = false,
            DodgeJumpSlamAttack = false
        }
    }
}

getgenv().BossFarmSettings = {
    Enabled = false
}

getgenv().PumpkinESPSettings = {
    Enabled = false,
    Show = {
        Name = true,
        Distance = true
    },
    TextSize = 18,
    MaxDistance = 99999
}

getgenv().HalloweenFarmSettings = {
    Enabled = false,
    FarmPumpkins = true,
    ServerHopWhenComplete = true,
    PumpkinFarmDistance = 8,
    PanicMode = false,
    SafetyMode2 = false,
    AutoFillBasket = false,
    AutoUseBasket = false,
    FarmCandy = true
}

getgenv().InfiniteM1Settings = {
    Enabled = false
}

getgenv().AutoSellSettings = {
    Fruits = false,
    Trinkets = false,
    Gems = false
}

getgenv().AutoActivationsSettings = {
    Enabled = false,
    ItemName = "Exact Item Name"
}

-- ============================================
-- UTILITY VARIABLES
-- ============================================

local maid = {}
local IsA = game.IsA
local chakraPoints = {}
local chakraPointInstances = {}
local npcs = {}
local npcInstances = {}
local pickupList = {}
local killBricks = {}
local inDanger = false
local playerJutsuData = {}
local jutsuConnections = {}
local currentSpectating
local lastLabel
local spectateConnections = {}
local DEFAULT_COLOR = Color3.fromRGB(255, 255, 255)
local HIGHLIGHT_COLOR = Color3.fromRGB(255, 0, 0)
local chakraSenseCount = 0
local chakraSenseGui
local chakraSenseLabel
local activeChakraSenseUsers = {}
local ChatLoggerFrame
local ChatLoggerList
local activeSenseLabel
local activeSenseCount = 0
local activeSenseUsers = {}
getgenv().activeSenseUsers = activeSenseUsers
local animationConnections = {}
local playersWithChakraSense = {}
local observerConnections = {}
local chakraSenseSkillConnections = {}
local notifyEyesRunning = false
local notifyEyesConnections = {}
local selectedEyeTypes = {}
local visitedFruits = {}
local halloweenCandyFarmThread
local halloweenCandyFarmRunning = false
local activeSenseStartTime = nil
local bossCBuffing
local respawningBossChakra
local stoppingAnim
local stoppingBurn
local respawningAnimHide
local subCdConnection
local candyAttackLoop
local candyM1Loop
local gripAttempts = 0
local maxGripAttempts = 15
local infiniteM1Thread
local infiniteM1Running = false
local autoSellThreads = {Fruits = nil, Trinkets = nil, Gems = nil}
local autoActivationsThread
local autoActivationsRunning = false
local autoActivationsCount = 0
local autoActivationsLabel = nil
local buffing
local respawning
local chakrabuffamount = 1
local autoEquipConnection
local autoEquipLoop

-- ============================================
-- QUEST SYSTEM VARIABLES
-- ============================================

local plr = LocalPlayer
local user = LocalPlayer.Name
local RS = ReplicatedStorage
local TS = game:GetService("TeleportService")
local selectedquest = nil
local noclippingcrop = nil

-- Vector utility for quests
local vector = {}
vector.create = function(x, y, z)
    return Vector3.new(x, y, z)
end

local weaponDatabase = {
    "Onyx Resanagi", "Golden Resanagi", "Silver Resanagi",
    "Onyx Zabunagi", "Golden Zabunagi", "Silver Zabunagi",
    "Onyx Kunai", "Golden Kunai", "Silver Kunai",
    "Onyx Spear", "Golden Spear", "Silver Spear",
    "Onyx Asumai Knives", "Golden Asumai Knives", "Silver Asumai Knives",
    "Kusanagi", "Adamantine Staff", "Executioner Blade", 
    "Samehada", "Gunbai", "Raijin Kunai",
}

local allEyeTypes = {
    "Pain's Rinnegan", "Sasuke's Rinnegan",
    "Itachi's Mangekyo", "Itachi's Eternal Mangekyo",
    "Obito's Mangekyo", "Obito's Eternal Mangekyo",
    "Sasuke's Mangekyo", "Sasuke's Eternal Mangekyo",
    "Madara's Mangekyo", "Madara's Eternal Mangekyo",
    "Sharingan [Stage 1]", "Sharingan [Stage 2]", "Sharingan [Stage 3]",
    "Byakugan [Stage 1]", "Byakugan [Stage 2]", "Byakugan [Stage 3]", 
    "Byakugan [Stage 4]", "Byakugan [Stage 5]",
    "Ketsuryugan [Stage 1]", "Ketsuryugan [Stage 2]", "Ketsuryugan [Stage 3]",
    "Jinchuriki [Stage 1]", "Jinchuriki [Stage 2]", "Shukaku Cloak"
}

-- Boss Configuration
local BOSS_CONFIGS = {
    ["Barbarit The Hallowed"] = {
        spawnPosition1 = Vector3.new(-1029.673584, 260.756836, -1636.933105),
        spawnPosition2 = Vector3.new(-1030.258057, 260.756836, -1624.148682),
        defaultSafeSpot = Vector3.new(60.7, -158.6, -1317.7),
        collectionPosition = Vector3.new(-1032.6435546875, 260.7568359375, -1428.788330078125),
        farmDistance = 16,
        dodgeSpinAttack = false,
        spinAttackAnimId = "rbxassetid://9656290960",
        safeHeight = 19,
        hasRewardsFolder = true,
        rewardsFolderName = "BarbaritRewards",
        scanDistance = 300,
        scanDuration = 8,
        scanInterval = 0.75,
        collectScanDuration = 10
    },
    ["Hallowed Chakra Knight"] = {
        defaultSafeSpot = Vector3.new(60.7, -158.6, -1317.7),
        collectionPosition = Vector3.new(2831.338, -125.500, -1144.267),
        farmDistance = 16,
        dodgeSpearAttack = false,
        spearAttackAnimId = "rbxassetid://10141233349",
        dodgeJumpSlamAttack = false,
        jumpSlamAnimIds = {
            "rbxassetid://10229183096",
            "rbxassetid://180436148",
            "rbxassetid://10237409592",
            "rbxassetid://180435571"
        },
        safeHeight = 30,
        hasRewardsFolder = true,
        rewardsFolderName = "ChakraKnightRewards",
        collectScanDuration = 10
    }
}



-- ===== INSERTED FEATURES FROM loader-...lua START =====
local features = {}

--[[

   _____         .__         ___________            __                         .____    .__          __   
  /     \ _____  |__| ____   \_   _____/___ _____ _/  |_ __ _________   ____   |    |   |__| _______/  |_ 
 /  \ /  \\__  \ |  |/    \   |    __)/ __ \\__  \\   __\  |  \_  __ \_/ __ \  |    |   |  |/  ___/\   __\
/    Y    \/ __ \|  |   |  \  |     \\  ___/ / __ \|  | |  |  /|  | \/\  ___/  |    |___|  |\___ \  |  |  
\____|__  (____  /__|___|  /  \___  / \___  >____  /__| |____/ |__|    \___  > |_______ \__/____  > |__|  
        \/     \/        \/       \/      \/     \/                        \/          \/       \/        
--]]

local function Teleport(place, bypassStealth, noteleport)
    local safeDistance = stealthneardistance or 120
    local targetCFrame

    if typeof(place) == "CFrame" then
        targetCFrame = place
    elseif typeof(place) == "Vector3" then
        targetCFrame = CFrame.new(place)
    else
        return false
    end

    local function checkSafety(position)
        for _, otherPlr in ipairs(game.Players:GetPlayers()) do
            if otherPlr ~= plr and otherPlr.Character and otherPlr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (otherPlr.Character.HumanoidRootPart.Position - position).Magnitude
                if dist <= safeDistance then
                    return false
                end
            end
        end
        return true
    end

    if stealthmodeactive.Value == true and not bypassStealth then
        if not checkSafety(targetCFrame.Position) then
            if not noteleport then
                Notify("Danger!","Player is nearby.",2,"info")
            end

            return false
        end
    end
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        if not noteleport then
            plr.Character.HumanoidRootPart.CFrame = targetCFrame
        end
        return true
    end

    return false
end

features.LoadESP = function()
    local plrs = game:GetService("Players")
    local plr = plrs.LocalPlayer

    --//Esp Configuration//
    ESP_Enabled = false
    ESP_ShowStuds = true
    ESP_ShowHealth = true
    ESP_ShowHealthBar = false
    ESP_ShowChakra = true
    ESP_ShowChakraBar = false
    
    --//Mob ESP Configuration//
    MobESP_Enabled = false
    MobESP_ShowStuds = true
    MobESP_ShowHealth = true

    local Refresh = 0.1

    local function addESPController(chr)
        local chrHead = chr:FindFirstChild("Head")
        local hasESP = chr:FindFirstChild("ESP")

        if hasESP then
            return
        end
        
        if chr.Parent == nil then
            return
        end
        
        if chr:GetChildren()[1] == nil then
            return
        end

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.FillColor = Color3.fromRGB(255,0,0)
        highlight.FillTransparency = 0.9
        highlight.Enabled = false

        local sign = Instance.new("BillboardGui")
        sign.Name = "ESP"
        sign.AlwaysOnTop = true
        sign.Enabled = false
        sign.Adornee = chrHead
        sign.Size = UDim2.new(0,200,0,30)
        sign.SizeOffset = Vector2.new(0,0.5)
        sign.StudsOffset = Vector3.new(0,3,0)
        sign.LightInfluence = 0

        --//Show Name//

        local nameDisplay = Instance.new("TextLabel",sign)
        nameDisplay.Name =  "NameDisplay"
        nameDisplay.TextColor3 = Color3.fromRGB(255,0,0)
        nameDisplay.BackgroundTransparency = 1
        nameDisplay.TextScaled = 20
        nameDisplay.Size = UDim2.new(1,0,1,0)
        nameDisplay.TextWrapped = true
        nameDisplay.Position = UDim2.new(0, 0, 0, 0)
        nameDisplay.Text = chr.Name
        nameDisplay.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold)

        local nameDisplayOutline = Instance.new("UIStroke",nameDisplay)
        nameDisplayOutline.Thickness = 3

        --//Show HealthBar//

        local Bar = Instance.new("Frame")
        Bar.Name = "Bar"
        Bar.Parent = sign
        Bar.AnchorPoint = Vector2.new(0.5, 0)
        Bar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Bar.BorderSizePixel = 0
        Bar.Position = UDim2.new(0.5, 0, 0.999, 0)
        Bar.Size = UDim2.new(0.5, 0, 0.150000006, 0)

        local BarOutline = Instance.new("UIStroke",Bar)
        BarOutline.Name = "BarOutline"
        BarOutline.Thickness = 2

        local Shadow = Instance.new("Frame")
        Shadow.Name = "Shadow"
        Shadow.Parent = Bar
        Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Shadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Shadow.BorderSizePixel = 0
        Shadow.Size = UDim2.new(1, 0, 1, 0)
        Shadow.ZIndex = 2

        local ShadowCorner = Instance.new("UICorner")
        ShadowCorner.CornerRadius = UDim.new(1, 0)
        ShadowCorner.Name = "ShadowCorner"
        ShadowCorner.Parent = Shadow

        local ShadowE = Instance.new("UIGradient")
        ShadowE.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.52), NumberSequenceKeypoint.new(0.15, 0.74), NumberSequenceKeypoint.new(0.51, 1.00), NumberSequenceKeypoint.new(0.84, 0.76), NumberSequenceKeypoint.new(1.00, 0.48)}
        ShadowE.Name = "ShadowE"
        ShadowE.Parent = Shadow

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Name = "BarCorner"
        BarCorner.Parent = Bar

        local Fill = Instance.new("Frame")
        Fill.Name = "Fill"
        Fill.Parent = Bar
        Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        Fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Fill.BorderSizePixel = 0
        Fill.Size = UDim2.new(1, 0, 1, 0)

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Name = "FillCorner"
        FillCorner.Parent = Fill

        local espHumanoid = chr:FindFirstChildOfClass("Humanoid")
        local HealthBarController
        HealthBarController = espHumanoid.HealthChanged:Connect(function()
            local percentage = espHumanoid.Health/espHumanoid.MaxHealth
            Fill.Size = UDim2.new(percentage,0,1,0)
        end)
        

        --//Show Info

        local Info = Instance.new("TextLabel")
        Info.Name = "Info"
        Info.Parent = sign
        Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Info.BackgroundTransparency = 1.000
        Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Info.BorderSizePixel = 0
        Info.Position = UDim2.new(0.5, 0, -0.95, 0)
        Info.Size = UDim2.new(0.8, 0, 1, 0)
        Info.FontFace = Font.new("rbxasset://fonts/families/Jura.json",Enum.FontWeight.Bold)
        Info.Text = ""
        Info.TextColor3 = Color3.fromRGB(255, 255, 255)
        Info.TextScaled = true
        Info.TextSize = 30.000
        Info.TextWrapped = true
        Info.AnchorPoint = Vector2.new(0.5,0)

        local InfoOutline = Instance.new("UIStroke")
        InfoOutline.Name = "Outline"
        InfoOutline.Thickness = 3
        InfoOutline.Parent = Info

        highlight.Parent = chr
        sign.Parent = chr

        local function AutoRefresh()
            while wait(Refresh) do
                if highlight.Parent ~= chr then
                    warn("ESP Loop Broken.")
                    break
                end
                if sign.Parent ~= chr then
                    warn("ESP Loop broken.")
                    break
                end

                local autoassign = pcall(function()
                    local plrChr = plr.Character
                    local plrRoot = plrChr:FindFirstChild("HumanoidRootPart")
                    local plrHumanoid = plr:FindFirstChildOfClass("Humanoid")

                    local espHumanoid = chr:FindFirstChildOfClass("Humanoid")
                    local espRoot = chr:FindFirstChild("HumanoidRootPart")

                    local distance = (plrRoot.Position-espRoot.Position).Magnitude
                    local health = espHumanoid.Health

                    if ESP_Enabled then
                        espHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        
                        sign.Enabled = true
                        highlight.Enabled = true
                    else
                        espHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                        sign.Enabled = false
                        highlight.Enabled = false
                    end		

                    if ESP_ShowHealthBar then
                        Bar.Visible = true
                    else
                        Bar.Visible = false
                    end

                    if ESP_ShowStuds and not ESP_ShowHealth then
                        Info.Text = math.floor(distance) .. " studs"
                    elseif ESP_ShowHealth and not ESP_ShowStuds then
                        Info.Text = math.floor(health) .. " HP"
                    elseif ESP_ShowStuds and ESP_ShowHealth then
                        Info.Text = math.floor(distance) .. " studs | " .. math.floor(health) .. " HP"
                    else
                        Info.Text = ""
                    end
                end)

            end
        end

        task.spawn(AutoRefresh)
    end

    for _,xplayer in pairs(plrs:GetPlayers()) do
        if xplayer == plr then
            continue
        end

        local targetchr = xplayer.Character
        addESPController(targetchr)
        xplayer.CharacterAdded:Connect(function(xchr)
            local targetChrHumanoid
            local targetChrRoot
            targetChrHumanoid = xchr:WaitForChild("Humanoid")
            targetChrRoot = xchr:WaitForChild("HumanoidRootPart")

            addESPController(xchr)
        end)
    end

    plrs.PlayerAdded:Connect(function(xplayer)
        xplayer.CharacterAdded:Connect(function(xchr)
            local targetChrHumanoid
            local targetChrRoot
            targetChrHumanoid = xchr:WaitForChild("Humanoid")
            targetChrRoot = xchr:WaitForChild("HumanoidRootPart")

            addESPController(xchr)
        end)
    end)
    
    -- Mob ESP System
    local function addMobESP(mob)
        if not mob or not mob:FindFirstChild("Humanoid") or not mob:FindFirstChild("Head") then return end
        if mob:FindFirstChild("MobESP") then return end
        
        local mobHead = mob:FindFirstChild("Head")
        local mobHumanoid = mob:FindFirstChild("Humanoid")
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "MobESP"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.OutlineColor = Color3.fromRGB(255, 165, 0)
        highlight.FillColor = Color3.fromRGB(255, 165, 0)
        highlight.FillTransparency = 0.9
        highlight.Enabled = false
        
        local sign = Instance.new("BillboardGui")
        sign.Name = "MobESP"
        sign.AlwaysOnTop = true
        sign.Enabled = false
        sign.Adornee = mobHead
        sign.Size = UDim2.new(0, 200, 0, 30)
        sign.SizeOffset = Vector2.new(0, 0.5)
        sign.StudsOffset = Vector3.new(0, 3, 0)
        sign.LightInfluence = 0
        
        local nameDisplay = Instance.new("TextLabel", sign)
        nameDisplay.Name = "NameDisplay"
        nameDisplay.TextColor3 = Color3.fromRGB(255, 165, 0)
        nameDisplay.BackgroundTransparency = 1
        nameDisplay.TextScaled = true
        nameDisplay.Size = UDim2.new(1, 0, 1, 0)
        nameDisplay.TextWrapped = true
        nameDisplay.Position = UDim2.new(0, 0, 0, 0)
        nameDisplay.Text = mob.Name
        nameDisplay.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold)
        
        local nameDisplayOutline = Instance.new("UIStroke", nameDisplay)
        nameDisplayOutline.Thickness = 3
        
        local Info = Instance.new("TextLabel")
        Info.Name = "Info"
        Info.Parent = sign
        Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Info.BackgroundTransparency = 1.000
        Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Info.BorderSizePixel = 0
        Info.Position = UDim2.new(0.5, 0, -0.95, 0)
        Info.Size = UDim2.new(0.8, 0, 1, 0)
        Info.FontFace = Font.new("rbxasset://fonts/families/Jura.json", Enum.FontWeight.Bold)
        Info.Text = ""
        Info.TextColor3 = Color3.fromRGB(255, 165, 0)
        Info.TextScaled = true
        Info.TextSize = 30.000
        Info.TextWrapped = true
        Info.AnchorPoint = Vector2.new(0.5, 0)
        
        local InfoOutline = Instance.new("UIStroke")
        InfoOutline.Name = "Outline"
        InfoOutline.Thickness = 3
        InfoOutline.Parent = Info
        
        highlight.Parent = mob
        sign.Parent = mob
        
        local function AutoRefresh()
            while wait(Refresh) do
                if highlight.Parent ~= mob or sign.Parent ~= mob then
                    break
                end
                
                local autoassign = pcall(function()
                    local plrChr = plr.Character
                    if not plrChr then return end
                    local plrRoot = plrChr:FindFirstChild("HumanoidRootPart")
                    if not plrRoot then return end
                    
                    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                    if not mobRoot then return end
                    
                    local distance = (plrRoot.Position - mobRoot.Position).Magnitude
                    local health = mobHumanoid.Health
                    
                    if MobESP_Enabled then
                        sign.Enabled = true
                        highlight.Enabled = true
                    else
                        sign.Enabled = false
                        highlight.Enabled = false
                    end
                    
                    if MobESP_ShowStuds and not MobESP_ShowHealth then
                        Info.Text = math.floor(distance) .. " studs"
                    elseif MobESP_ShowHealth and not MobESP_ShowStuds then
                        Info.Text = math.floor(health) .. " HP"
                    elseif MobESP_ShowStuds and MobESP_ShowHealth then
                        Info.Text = math.floor(distance) .. " studs | " .. math.floor(health) .. " HP"
                    else
                        Info.Text = ""
                    end
                end)
            end
        end
        
        task.spawn(AutoRefresh)
    end
    
    -- Helper function to check if model is a valid combat mob
    local function isValidMob(model)
        -- Must have Humanoid and Head
        if not model:FindFirstChild("Humanoid") or not model:FindFirstChild("Head") then
            return false
        end

        -- Exclude players
        if game.Players:GetPlayerFromCharacter(model) then
            return false
        end

        -- Only include NPCs with "Combat" value (actual hostile mobs)
        local npcValue = model:FindFirstChild("NPC")
        if not npcValue or npcValue.Value ~= "Combat" then
            return false
        end

        return true
    end

    -- Add ESP to existing mobs
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and isValidMob(v) then
            addMobESP(v)
        end
    end

    -- Add ESP to new mobs
    workspace.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            task.wait(0.1)
            if isValidMob(child) then
                addMobESP(child)
            end
        end
    end)
end

features.StartTeleport = function()
    if busy then
        return
    end
    busy = true

   local MapFrame = Map:FindFirstChild("Map")
   local BG = MapFrame:FindFirstChild("BG")
   local Shadow = MapFrame:FindFirstChild("Shadow")

   local Locations = {}
    for _,location in pairs(MapFrame:GetChildren()) do
        if location:isA("ImageButton") then
            location.BackgroundTransparency = 1

            local Marker = location:FindFirstChild("Marker")
            local LocName = location:FindFirstChild("LocationName")

            Marker.ImageTransparency = 1
            LocName.TextTransparency = 1

            table.insert(Locations,location)
        end
    end

    BG.ImageTransparency = 1
    Shadow.ImageTransparency = 1

    if not Map.Enabled then
        task.wait(0.1)
        Map.Enabled = true
    end

    local blurTransition = Instance.new("BlurEffect",Lighting)
    blurTransition.Name = "Transition"
    blurTransition.Size = 24
    Tween(blurTransition,TweenInfo.new(0.4),{Size = 24})

    Notify("Select a waypoint","to teleport to...","2","map-pinned")

    local BaseSize = UDim2.new(0.61145997, 0, 0.711886287, 0)
    local AnimSize = UDim2.new(0.31145997, 0, 0.351886287, 0)

    MapFrame.Size = AnimSize
    Tween(MapFrame,TweenInfo.new(0.45),{Size = BaseSize})
    Tween(BG,TweenInfo.new(0.6),{ImageTransparency = 0})
    Tween(Shadow,TweenInfo.new(0.6),{ImageTransparency = 0.330})

    if firstTeleport then
        task.wait(0.6)
    else
        task.wait(0.15) 
    end

    for _,location in pairs(Locations) do
        location.Visible = true
        local Marker = location:FindFirstChild("Marker")
        local LocName = location:FindFirstChild("LocationName")

        Tween(Marker,TweenInfo.new(0.45),{ImageTransparency = 0})
        Tween(LocName,TweenInfo.new(0.45),{TextTransparency = 0})

        if firstTeleport then
            task.wait(0.1)
        end
    end

    busy = false
    firstTeleport = false
end

features.EndTeleport = function(Location)
    if teleporting or busy then
        return
    end

    teleporting = true
    Notify("Teleported","to your destination.","3","map-pinned")

    local MapFrame = Map:FindFirstChild("Map")
    local BG = MapFrame:FindFirstChild("BG")
    local Shadow = MapFrame:FindFirstChild("Shadow")

    local Locations = {}
    for _,location in pairs(MapFrame:GetChildren()) do
        if location:isA("ImageButton") then
            table.insert(Locations,location)
        end
    end
    
    local BaseSize = UDim2.new(0.61145997, 0, 0.711886287, 0)
    local AnimSize = UDim2.new(0.31145997, 0, 0.351886287, 0)

    local foundLocation = MapFrame:FindFirstChild(Location)
    local LocationMarker = foundLocation:FindFirstChild("Marker")

    Tween(BG,TweenInfo.new(0.4),{ImageTransparency = 1})
    Tween(Shadow,TweenInfo.new(0.4),{ImageTransparency = 1})
    Tween(MapFrame,TweenInfo.new(0.4),{Size = BaseSize})

    for _,location in pairs(Locations) do
        local Marker = location:FindFirstChild("Marker")
        local LocName = location:FindFirstChild("LocationName")

        Tween(Marker,TweenInfo.new(0.3),{ImageTransparency = 1})
        Tween(LocName,TweenInfo.new(0.3),{TextTransparency = 1})

        task.spawn(function()
            task.wait(0.3)
            location.Visible = false
        end)
    end
    
    local transitionBlur = Lighting:FindFirstChild("Transition")
    if transitionBlur then
        Tween(transitionBlur,TweenInfo.new(0.4),{Size = 0})
    end

    for i, v in pairs(workspace.ChakraPoints:GetDescendants()) do
        if v.Name == "PointName" then
            if v.Value == Location then
                Teleport(v.Parent.Main.CFrame * CFrame.new(0,0,4))
            end
        end
    end

    task.wait(0.4)
    if transitionBlur.Parent ~= nil then
        transitionBlur:Destroy()
    end
    
    --//Fallback Fusion Blur Removal//
    for _,v in pairs(game.Lighting:GetChildren()) do
        if v.Name == "Transition" then
            v:Destroy()
        end
    end
    teleporting = false
    busy = false
end

features.RenderMap = function()
    local Preloader = game:GetService("ContentProvider")
    Preloader:PreloadAsync(Map:GetDescendants())
    local MapFrame = Map:FindFirstChild("Map")
    for _,location in pairs(MapFrame:GetChildren()) do
        if location:IsA("ImageButton") then
            location.MouseButton1Click:Connect(function()
                features.EndTeleport(location.Name)
            end)
            location.Visible = false
        end
    end
end

features.CSA = function()
    local plr = game:GetService("Players").LocalPlayer
    local rs = game:GetService("ReplicatedStorage")

    local function BindCSA(Object)
        if ChakraSenseAlerter == false then
            return
        end

        if Object.Parent:GetAttribute("observed") == true then
            return
        end

        if Object.Name == "BeingObservedBy" then
            --Being Watched!
            local AlertPing = Instance.new("Sound",plr.PlayerGui)
            AlertPing.SoundId = "rbxassetid://644569388"
            AlertPing.PlayOnRemove = true
            AlertPing:Destroy()

            local totalsensers = {}
            for _,player in pairs(game.Players:GetPlayers()) do
                local plrCharacter = player.Character
                local inChakraSense = plrCharacter:FindFirstChild("ChakraSense",true)

                if inChakraSense then
                    table.insert(totalsensers,plrCharacter)
                end
            end

            if #totalsensers > 1 then
                Notify("You're being observed!","Someone is observing you.",5,"shield-alert")
                wait(0.8)
                Object.Parent:SetAttribute("observed", false)
            else
                local senserHumanoid = totalsensers[1]:FindFirstChildOfClass("Humanoid")
                local senserName = senserHumanoid.DisplayName

                Notify("You're being observed!",senserName.." is observing you.",5,"shield-alert")
                Object.Parent:SetAttribute("observed", true)
                wait(0.8)
                Object.Parent:SetAttribute("observed", false)
            end
        end
    end

    local Settings = RS:WaitForChild("Settings")
    Settings.ChildAdded:Connect(function(Object)
        if Object.Name == plr.Name then
            Object.ChildAdded:Connect(BindCSA)
        end
    end)

    local plrSettings = Settings:FindFirstChild(plr.Name)
    plrSettings.ChildAdded:Connect(BindCSA)
end

local flightSpeed
features.toggleFlight = function()

    local plr = game.Players.LocalPlayer
    local plrCharacter = plr.Character or plr.CharacterAdded:Wait()
    
    local plrRoot = plrCharacter:FindFirstChild("HumanoidRootPart")
    local plrHumanoid = plrCharacter:FindFirstChildOfClass("Humanoid")

    local foundVelocity = plrRoot:FindFirstChild("FlightV")
    local foundGyro = plrRoot:FindFirstChild("FlightG")

    if foundVelocity and foundGyro then
        foundVelocity:Destroy()
        foundGyro:Destroy()
        return
    end

    local V = Instance.new("BodyVelocity")
    local G = Instance.new("BodyGyro")

    V.Name = "FlightV"
    V.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    V.Velocity = Vector3.new(0, 0, 0)
    V.P = 10000
    V.Parent = plrRoot

    G.Name = "FlightG"
    G.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    G.CFrame = plrRoot.CFrame
    G.P = 10000
    G.Parent = plrRoot
    
    local userInputService = game:GetService("UserInputService")

    local FlightControl
    FlightControl = While.Heartbeat:Connect(function()
        local speed = flightSpeed or 100

        if V.Parent == nil or G.Parent == nil then
            FlightControl:Disconnect()
            return
        end

        local moveDirection = Vector3.new(0, 0, 0)
        local fast = false

        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            fast = true
        end
        if fast then
            V.Velocity = moveDirection * speed * 2.5
        else
            V.Velocity = moveDirection * speed
        end

        G.CFrame = CFrame.new(plrRoot.Position, plrRoot.Position + workspace.CurrentCamera.CFrame.LookVector)
    end)
end

features.SelectPlayer = function()

    if ActiveSelector then
       return
    end
 
    Notify("Select a Player...","","2","user-round")
 
    ActiveSelector = true
 
    for i,v in pairs(Selection:GetChildren()) do
       if v:IsA("TextButton") then
          v:Destroy()
       end
    end
 
    local lighting = game:GetService("Lighting")
 
    local blurtransition = Instance.new("BlurEffect")
    blurtransition.Name = "SelectionBlur"
    blurtransition.Size = 0
    blurtransition.Parent = lighting
 
    Tween(blurtransition,TweenInfo.new(0.4,Enum.EasingStyle.Back),{Size = 18})
    
    Selector.Enabled = true
 
    -- Refresh
    for i,v in pairs(game.Players:GetPlayers()) do
       local NewButton = RealTemplate:Clone()
       NewButton.Name = v.Name
       NewButton.Text = v.Name
 
       if v == game.Players.LocalPlayer then
          NewButton.Text = NewButton.Text.." ".."<font color='rgb(255, 215, 0)'>[You]</font>"
       end
 
       local vChr = v.Character
       if vChr ~= nil then
          local Root = vChr:FindFirstChild("HumanoidRootPart")
       end
 
       NewButton.MouseEnter:Connect(function()
         Tween(NewButton,TweenInfo.new(0.2,Enum.EasingStyle.Sine),{TextSize = 48})
         Tween(NewButton,TweenInfo.new(0.3,Enum.EasingStyle.Linear),{BackgroundTransparency = 0.9})
      end)

      NewButton.MouseLeave:Connect(function()
        task.wait(0.1)
         Tween(NewButton,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{TextSize = 30})
         Tween(NewButton,TweenInfo.new(0.3,Enum.EasingStyle.Linear),{BackgroundTransparency = 1})
      end)
 
       NewButton.MouseButton1Click:Connect(function()
         local Targetted = game.Players:FindFirstChild(NewButton.Name)
         if Targetted then
          TargetPlayer = Targetted
          warn(TargetPlayer)
         end
         Tween(blurtransition,TweenInfo.new(0.8,Enum.EasingStyle.Back),{Size = 0})
         Selector.Enabled = false
         ActiveSelector = false
         Shadow.BackgroundTransparency = 1
       end)
       NewButton.Parent = Selection
    end

    --//Transition Effect//--

    Selection.Size = TransitionSize
    local FlyIn = TweenService:Create(Selection,TweenInfo.new(0.6,Enum.EasingStyle.Back),{Size = ActualSize})
    FlyIn:Play()

    for _,Element in pairs(Selection:GetChildren()) do
        if Element:IsA("TextButton") then
            local FadeIn = TweenService:Create(Element,TweenInfo.new(0.6),{TextTransparency = 0})
            FadeIn:Play()

            Shadow.Size = TransitionSize
            local ShadowFadeIn = TweenService:Create(Shadow,TweenInfo.new(0.6),{BackgroundTransparency = 0.9})
            local ShadowFlyIn = TweenService:Create(Shadow,TweenInfo.new(0.6,Enum.EasingStyle.Back),{Size = ActualSize})
            ShadowFadeIn:Play()
            ShadowFlyIn:Play()

            local TextFadeIn = TweenService:Create(Element,TweenInfo.new(0.5,Enum.EasingStyle.Back),{TextSize = 30})
            TextFadeIn:Play()

        end
    end
 end

walkspeed_enabled = false
walkspeed_modified = 100
features.Walkspeed = function()
    While.Heartbeat:Connect(function()
        if walkspeed_enabled then
            local Character = plr.Character
            local Humanoid = Character:WaitForChild("Humanoid")

            Humanoid.WalkSpeed = walkspeed_modified
        end
    end)
end

local newplayerguiconn
features.ClickToView = function()
    local RSLoaded = RS.Loaded:FindFirstChild(user)

    if not RSLoaded then 
        repeat
            wait()
        until RS.Loaded:FindFirstChild(user)
    end

    local clientguis = game:GetService("Players").LocalPlayer.PlayerGui.ClientGui

    local function ResetCamera()
        local cam = workspace.Camera
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            cam.CameraSubject = plr.Character.Humanoid

            -- Chakra Point Viewing
            if game:GetService("Lighting"):FindFirstChild("PointBlur") then
                game:GetService("Lighting"):FindFirstChild("PointBlur").Enabled = false
                plr.PlayerGui.ClientGui.Mainframe.Rest.TitleImage.Visible = true
                plr.PlayerGui.ClientGui.Mainframe.Rest.BackDrop.Visible = true
                plr.PlayerGui.ClientGui.Mainframe.Rest.MainMenuFrame.Visible = true
            end
        end
    end

    local function View(Button)
        local cam = workspace.Camera
        local eplr = game.Players:FindFirstChild(Button.PlayerName.Text)
        if eplr then
            if eplr.Character and eplr.Character.Humanoid then
                cam.CameraSubject = eplr.Character.Humanoid
                
                -- Chakra Point Viewing
                if game:GetService("Lighting"):FindFirstChild("PointBlur") then
                    if eplr.Name ~= plr.Name then
                        game:GetService("Lighting"):FindFirstChild("PointBlur").Enabled = false
                        plr.PlayerGui.ClientGui.Mainframe.Rest.TitleImage.Visible = false
                        plr.PlayerGui.ClientGui.Mainframe.Rest.BackDrop.Visible = false
                        plr.PlayerGui.ClientGui.Mainframe.Rest.MainMenuFrame.Visible = false
                    else
                        game:GetService("Lighting"):FindFirstChild("PointBlur").Enabled = false
                        plr.PlayerGui.ClientGui.Mainframe.Rest.TitleImage.Visible = true
                        plr.PlayerGui.ClientGui.Mainframe.Rest.BackDrop.Visible = true
                        plr.PlayerGui.ClientGui.Mainframe.Rest.MainMenuFrame.Visible = true
                    end
                end
            end
        end
    end

    local function assignbutton()

        newplayerguiconn = plr.PlayerGui.ClientGui.Mainframe.PlayerList.List.ChildAdded:Connect(function(guichi)
            if guichi.Name == "PlayerTemplate" then
                guichi.MouseButton1Click:Connect(function()
                    View(guichi)
                end)
                guichi.MouseButton2Click:Connect(function()
                    ResetCamera()
                end)
            end
        end)
        for _,plrbutton in pairs(plr.PlayerGui.ClientGui.Mainframe.PlayerList.List:GetChildren()) do
            if plrbutton.Name == "PlayerTemplate" then
                plrbutton.MouseButton1Click:Connect(function()
                    View(plrbutton)
                end)
                plrbutton.MouseButton2Click:Connect(function()
                    ResetCamera()
                end)
            end
        end
    end

    plr.PlayerGui.ChildRemoved:Connect(function(removed)
        if removed.Name == "ClientGui" then
            plr:WaitForChild("PlayerGui")
            plr.PlayerGui:WaitForChild("ClientGui")
            plr.PlayerGui.ClientGui:WaitForChild("Mainframe")
            if newplayerguiconn then
                newplayerguiconn:Disconnect()
            end
            wait()
            assignbutton()
        end
    end)
    assignbutton()
end


local cheatcheckversions = {
    [745] = 14,
	[750] = 14,
	[757] = 18,
    [784] = 18,
    [788] = 18
}

features.TeleportRandomServer = function()
    local players = game:GetService("Players")
    local LocalPlayer = players.LocalPlayer
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")

    features.HandleNotLoadedIn()

    local triedServers = {}

    local function waitForNoCombat()
        local data = remote:InvokeServer("GetData")
        while data["InDanger"] == true do
            task.wait(0.5)
            data = remote:InvokeServer("GetData")
        end
    end

    local function getServerList()
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

        return list
    end

    local function forceClick(button)
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        if button.Activated then
            for _, c in ipairs(getconnections(button.Activated)) do c:Fire() end
        end
        if button.MouseButton1Click then
            for _, c in ipairs(getconnections(button.MouseButton1Click)) do c:Fire() end
        end
        if button.MouseButton1Down then
            for _, c in ipairs(getconnections(button.MouseButton1Down)) do c:Fire() end
        end
        if button.TouchTap then
            for _, c in ipairs(getconnections(button.TouchTap)) do c:Fire() end
        end
    end

    local function attemptServerHop()
        waitForNoCombat()

        local list = getServerList()
        if not list then return end

        local validServers = {}
        for _, frame in ipairs(list:GetChildren()) do
            if frame:IsA("Frame") and frame.Name == "ServerTemplate" then
                local playersLabel = frame:FindFirstChild("Players")
                local joinButton = frame:FindFirstChild("JoinButton")
                local regionLabel = frame:FindFirstChild("ServerRegion")
                local regionValue = "?"
                if regionLabel and regionLabel:IsA("TextLabel") then
                    regionValue = regionLabel.Text:match("Region%s*:%s*(.+)") or "?"
                end

                if playersLabel and joinButton and joinButton:IsA("TextButton") then
                    local playerCount = tonumber(playersLabel.Text:match("%d+")) or 0

                    local regionOk = true
                    if selectedregions and #selectedregions > 1 then
                        regionOk = false
                        for _, allowed in ipairs(selectedregions) do
                            if regionValue == allowed then
                                regionOk = true
                                break
                            end
                        end
                    end

                    if playerCount > 0 and regionOk and not triedServers[frame.Name] then
                        table.insert(validServers, {
                            frame = frame,
                            button = joinButton,
                            playerCount = playerCount,
                            region = regionValue
                        })
                    end
                end
            end
        end

        if #validServers == 0 then
            triedServers = {}
            return
        end

        local selectedServer = validServers[math.random(1, #validServers)]
        triedServers[selectedServer.frame.Name] = true

        task.wait(0.1)
        local success, err = pcall(function()
            forceClick(selectedServer.button)
        end)
        if not success then
            pcall(function()
                firesignal(selectedServer.button.MouseButton1Click)
            end)
        end
    end

    while true do
        attemptServerHop()
        task.wait(1)
    end
end


features.TeleportLeastActive = function()
    local players = game:GetService("Players")
    local LocalPlayer = players.LocalPlayer
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")

    features.HandleNotLoadedIn()

    local triedServers = {}

    local function waitForNoCombat()
        local data = remote:InvokeServer("GetData")
        while data["InDanger"] == true do
            task.wait(0.5)
            data = remote:InvokeServer("GetData")
        end
    end

    local function getServerList()
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

        return list
    end

    local function forceClick(button)
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        if button.Activated then
            for _, c in ipairs(getconnections(button.Activated)) do c:Fire() end
        end
        if button.MouseButton1Click then
            for _, c in ipairs(getconnections(button.MouseButton1Click)) do c:Fire() end
        end
        if button.MouseButton1Down then
            for _, c in ipairs(getconnections(button.MouseButton1Down)) do c:Fire() end
        end
        if button.TouchTap then
            for _, c in ipairs(getconnections(button.TouchTap)) do c:Fire() end
        end
    end

    local function attemptServerHop()
        waitForNoCombat()

        local list = getServerList()
        if not list then return end

        local validServers = {}
        for _, frame in ipairs(list:GetChildren()) do
            if frame:IsA("Frame") and frame.Name == "ServerTemplate" then
                local playersLabel = frame:FindFirstChild("Players")
                local joinButton = frame:FindFirstChild("JoinButton")
                local regionLabel = frame:FindFirstChild("ServerRegion")
                local regionValue = "?"
                if regionLabel and regionLabel:IsA("TextLabel") then
                    regionValue = regionLabel.Text:match("Region%s*:%s*(.+)") or "?"
                end

                if playersLabel and joinButton and joinButton:IsA("TextButton") then
                    local playerCount = tonumber(playersLabel.Text:match("%d+")) or 0

                    local regionOk = true
                    if selectedregions and #selectedregions > 1 then
                        regionOk = false
                        for _, allowed in ipairs(selectedregions) do
                            if regionValue == allowed then
                                regionOk = true
                                break
                            end
                        end
                    end

                    if playerCount > 8 and regionOk and not triedServers[frame.Name] then
                        table.insert(validServers, {
                            frame = frame,
                            button = joinButton,
                            playerCount = playerCount,
                            region = regionValue
                        })
                    end
                end
            end
        end

        if #validServers == 0 then
            triedServers = {}
            return
        end

        table.sort(validServers, function(a, b)
            return a.playerCount < b.playerCount
        end)

        local selectedServer = validServers[1]
        triedServers[selectedServer.frame.Name] = true

        task.wait(0.1)
        local success, err = pcall(function()
            forceClick(selectedServer.button)
        end)
        if not success then
            pcall(function()
                firesignal(selectedServer.button.MouseButton1Click)
            end)
        end
    end

    while true do
        attemptServerHop()
        task.wait(1)
    end
end



NoFog= false
features.NoFogPassive = function()
    local Lighting = game:GetService("Lighting")
    While.Heartbeat:Connect(function()
        if NoFog then
            Lighting.FogEnd = 50000
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            if workspace.Debris:FindFirstChild("InvertedSphere") then
                workspace.Debris.InvertedSphere.Transparency = 1
            end
            if RS:FindFirstChild("Raining") then
                RS:FindFirstChild("Raining").Value = ""
            end
        end
    end)
end

features.AntiAFK = function()
    local VirtualUser = game:GetService("VirtualUser")

    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end

features.AutoSellGems = function()
    if sellinggems then
        local function determinegemsamount()
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
            local playerdata,region,servername = remote:InvokeServer("GetData")
            local totalGemAmount = 0

            local function checkforgem(location)
                for _, itemData in pairs(location) do
                    if string.find(itemData.Item, "Gem") then
                        local quantity = itemData.Quantity or 1
                        totalGemAmount = totalGemAmount + quantity
                    end
                end
            end

            checkforgem(playerdata["Inventory"])
            checkforgem(playerdata["Loadout"])
            return totalGemAmount
        end     
        
        local function sellthegems(gemamount)
            local args = {
                [1] = "SellingBulk",
                [2] = gemamount * 10,
                [3] = "Gem",
                [5] = workspace:WaitForChild("TorchMesh")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
        end

        while sellinggems do
            local gemsamount = determinegemsamount()
            if gemsamount > 0 then
                sellthegems(gemsamount)
            end
            wait(5)
        end
    end
end


features.NoFallDamage = function()
    local antifalldmg
    antifalldmg = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if tostring(self) == "DataEvent" and method == "FireServer" then
            if args[1] == "TakeDamage" then
                if args[2] > 0.1 and NoFallDammage.Value == true and args[3] ~= "yes" and args[3] == nil then
                    return nil
                end
            end
        end

        return antifalldmg(self, unpack(args))
    end)
end

local noclipenabled = false

features.Noclip = function()
   if noclipenabled then
        local function nocliploop()
            for i, v in pairs(plr.Character:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
        noclipping = RunService.Stepped:Connect(nocliploop)
   else
        if noclipping then
            noclipping:Disconnect()
        end
        
        for i, v in pairs(plr.Character:GetChildren()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = true
            end
        end
    end
end

local infinitestamina = false
features.InfiniteStamina = function()
    local infjumps
    infjumps = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if tostring(self) == "DataEvent" and method == "FireServer" then
            if args[1] == "Jump" and infinitestamina == true then
                return nil
            end
        end

        return infjumps(self, unpack(args))
    end)

end

features.Reset = function()
    if plr.Character and plr.Character.Parent ~= nil and plr.Character.Humanoid then
        local char = plr.Character
        local hum = plr.Character.Humanoid
        local hrp = plr.Character.HumanoidRootPart
        hum:ChangeState(Enum.HumanoidStateType.Dead)
        if plr.Character:FindFirstChild("Head") then
            plr.Character.Head.Name = ""
        end
    end
end

features.infinitem1 = function()
    if infinitem1ing then
        local weapontoautoequip = nil
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
        local playerdata = remote:InvokeServer("GetData")
        weapontoautoequip = playerdata["CurrentWeapon"]

        while infinitem1ing do
            task.wait()

            if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("CombatCount") then
                if RS.Settings[user].CombatCount.Value > 3 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("Item", "Selected", weapontoautoequip)
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("Item", "Unselected", weapontoautoequip)
                end
            end
        end
    end
end


features.gotosafespot = function(dontteleport,shortloop)
    if safespotcf == nil then
        Notify("Missing Safe Spot CFrame", "Check Settings Tab", 3, "info")
        return false
    end

    if dontteleport then
        return true
    end

    if not shortloop then
        Teleport(safespotcf)
    else
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local startTime = tick()
            while tick() - startTime < 0.5 do
                hrp.CFrame = safespotcf
                task.wait()
            end
        end
    end
    return true
end

features.HandleNotLoadedIn = function()
    if not RS.Loaded:FindFirstChild(user) then
        if workspace.CurrentCamera.CameraType == Enum.CameraType.Custom then
            task.spawn(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("LoadedIn")
            end)

            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("LoadedIn")

            wait()
            plr.PlayerGui.ClientGui.MenuScreen.Visible = false
            plr.SoundPlaylist:FindFirstChild("MenuTrack").Playing = false

            local loadingFunction = nil
            local memory = getgc(true)

            for i,v in pairs(memory) do
                if type(v) == "function" and debug.getinfo(v).name == "LoadIntoGame" then
                    loadingFunction = v
                end
            end

            if loadingFunction then
                loadingFunction()
            end

            if plr.Character and plr.Character.HumanoidRootPart then
                features.gotosafespot()
            end
            wait(2)
        else
            local loadingFunction = nil
            local memory = getgc(true)

            for i,v in pairs(memory) do
                if type(v) == "function" and debug.getinfo(v).name == "LoadIntoGame" then
                    loadingFunction = v
                end
            end

            if loadingFunction then
                loadingFunction()
            end
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("LoadedIn")
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("LoadedIn")
            wait()
            if plr.Character and plr.Character.HumanoidRootPart then
                Teleport(CFrame.new(-2974.29443, 345.182709, 646.613159, -0.99941802, -2.79689978e-08, 0.0341118388, -2.78877685e-08, 1, 2.85709167e-09, -0.0341118388, 1.90412597e-09, -0.99941802))
            end
        end
    end
end

features.AntiBan = function()

    local antiban
    antiban = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if tostring(self) == "DataEvent" and method == "FireServer" then
            if args[1] == "BanMe" then
                return nil
            end
        end
        return antiban(self, unpack(args))
    end)
end

features.LockCamera = function()
    if lockingcamera then
        if TargetPlayer ~= nil then
            lockingcameraconn = game:GetService("RunService").RenderStepped:Connect(function()
                local cam = workspace.CurrentCamera
                local myChar = game.Players.LocalPlayer.Character
                local targetChar = TargetPlayer.Character

                if cam and myChar and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                    -- preserve current camera distance
                    local camPos = cam.CFrame.Position
                    local targetPos = targetChar.HumanoidRootPart.Position

                    -- only rotate camera to face target (don't overwrite offset/zoom)
                    cam.CFrame = CFrame.lookAt(camPos, targetPos)
                end
            end)
        end
    else
        if lockingcameraconn then
            lockingcameraconn:Disconnect()
            lockingcameraconn = nil
        end
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

features.FarmPlayer = function()
    if farmingplayer and TargetPlayer then
        if farmteleportconn then
            farmteleportconn:Disconnect()
        end

        farmteleportconn = RunService.RenderStepped:Connect(function()
            local myChar = plr.Character
            local targetChar = TargetPlayer.Character

            if myChar and targetChar then
                local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

                if myHRP and targetHRP then
                    local belowTarget = targetHRP.Position + Vector3.new(0, -9, 0)
                    local lookDirection = (targetHRP.Position - myHRP.Position).Unit
                    local cframeLook = CFrame.new(belowTarget, belowTarget + lookDirection)

                    myHRP.CFrame = cframeLook
                end
            end
        end)
    else
        if farmteleportconn then
            farmteleportconn:Disconnect()
            farmteleportconn = nil
        end
    end
end

features.AutoSealMatatabi = function()
    if not autosealingmatatabi then return end
    
    local RunService = game:GetService("RunService")
    local RS = game:GetService("ReplicatedStorage")
    
    local sealConnection
    sealConnection = RunService.Heartbeat:Connect(function()
        if not autosealingmatatabi then
            if sealConnection then
                sealConnection:Disconnect()
            end
            return
        end
        
        -- Find Matatabi in workspace
        local matatabi = workspace:FindFirstChild("Matatabi")
        if not matatabi then return end
        
        local matatabiHumanoid = matatabi:FindFirstChild("Humanoid")
        local matatabiHRP = matatabi:FindFirstChild("HumanoidRootPart")
        
        if not (matatabiHumanoid and matatabiHRP) then return end
        
        -- Check if health is 1 or less
        if matatabiHumanoid.Health <= 1 then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = matatabiHRP.Position
                
                -- Teleport to Matatabi's position with Y = -147
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.X, -147, targetPos.Z)
                
                -- Start the Binding Seal skill at the player's position
                local skillPos = Vector3.new(targetPos.X, -147, targetPos.Z)
                RS.Events.DataEvent:FireServer("startSkill", "Binding Seal", skillPos, true)
                
                -- Spam ReleaseSkill
                RS.Events.DataEvent:FireServer("ReleaseSkill")
            end
        end
    end)
end

features.StealthMode = function()

    local function takemeasurement(reason)
        if stealthmodeactive.Value == false then return end

        if reason == "[Radiant Hub]: Someone got near you." and stealthfeatures[givegrip] == true then return end
        if stealthmeasurement == "Kick" then
            for i, v in pairs(stealthfeatures) do
                if i.Value == true then
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                    plr:Kick(reason)
                    return
                end
            end
        elseif stealthmeasurement == "Stop Farm + Reset" then
            for bool, func in pairs(stealthfeatures) do
                if bool.Value == true then
                    bool.Value = false
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                    func()
                    features.Reset()
                end
            end
        elseif stealthmeasurement == "Stop Farm" then
            for bool, func in pairs(stealthfeatures) do
                if bool.Value == true then
                    bool.Value = false
                    func()
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                end
            end
        elseif stealthmeasurement == "Stop Farm + Safe Spot" then
            for bool, func in pairs(stealthfeatures) do
                if bool.Value == true then
                    bool.Value = false
                    func()
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                    spawn(function()
                        features.gotosafespot(false,true)
                    end)
                end
            end
        elseif stealthmeasurement == "Safe Spot + Serverhop" then
            for bool, func in pairs(stealthfeatures) do
                if bool.Value == true then
                    bool.Value = false
                    func()
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                    spawn(function()
                        features.gotosafespot(false,true)
                    end)
                    features.TeleportRandomServer()
                end
            end
        end
    end

    -- Someone new with Chakra uses

    local startedchakraamount = amount.Value


    spawn(function() 
        local startTime = tick()

        while tick() - startTime < 9 do
            if stealthshopifsensethere == true then
                if startedchakraamount > 0 then
                    if shopdelay ~= nil then
                        wait(shopdelay)
                    end

                    features.TeleportRandomServer()
                    return
                end
                return
            else
                task.wait()
            end
        end
    end)

    -- monitor surrounding people

    local lastCheck = 0
    local checkInterval = 0.2

    local function checkPeopleNear()
        if not plr.Character then return end
        local playerhrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if not playerhrp then return end
        local stealthneardistance = stealthneardistance or 200

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= plr then
                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (playerhrp.Position - hrp.Position).Magnitude
                        if distance <= stealthneardistance and table.find(WhitelistedUsers, player.Name) == nil then
                            -- exception for loopwipe and treehop
                            if not RS.Loaded:FindFirstChild(user) then
                                local wiperoomdistance = (playerhrp.Position - workspace:FindFirstChild("Arkoromo"):FindFirstChild("HumanoidRootPart").Position).Magnitude
                                if wiperoomdistance <= 250 then
                                    takemeasurement("[Radiant Hub]: Someone was in Wipe Room.")
                                end
                            elseif treehopping.Value == true or Ryofarming.Value == true then
                                return
                            else
                                -- for every other feature                      
                                takemeasurement("[Radiant Hub]: Someone got near you.")
                            end
                        end
                    end
                end
            end
        end
    end
        
    checkingnearpeople = RunService.Heartbeat:Connect(function(dt)
        lastCheck += dt
        if lastCheck >= checkInterval then
            checkPeopleNear()
            lastCheck = 0
        end
    end)

    -- monitoring people using sense

    local Players = game:GetService("Players")

    local function checkCharacter(char)
        local torso = char:WaitForChild("Torso", 5)
        if not torso then return end

        local function handleSense(part)
            if part.Name ~= "ChakraSense" then return end
            takemeasurement("[Radiant Hub]: Someone is using Sense")

            coroutine.wrap(function()
                while part:IsDescendantOf(workspace) do
                    wait(0.5)
                    takemeasurement("[Radiant Hub]: Someone is using Sense")
                end
            end)()
        end

        local existing = torso:FindFirstChild("ChakraSense")
        if existing then
            handleSense(existing)
        end

        torso.ChildAdded:Connect(handleSense)
    end

    local function onPlayerAdded(player)
        if player.Character then
            if table.find(WhitelistedUsers, player.Name) == nil then
                checkCharacter(player.Character)
            end
        end
        player.CharacterAdded:Connect(checkCharacter)
    end

    for _, player in pairs(Players:GetPlayers()) do
        if table.find(WhitelistedUsers, player.Name) == nil then
            onPlayerAdded(player)
        end
    end

    Players.PlayerAdded:Connect(onPlayerAdded)

    -- check for mods

    for _, player in ipairs(game.Players:GetPlayers()) do
        local suc, rank = pcall(function()
            return player:GetRankInGroup(7450839)
        end)

        if not suc then
            warn("Failed to get rank for", player.Name)
            continue
        end

        if rank ~= 0 then
            takemeasurement("[Radiant Hub]: A mod was in your server.")
        end
    end

end

features.Killboss = function()
    if bossfarmactive.Value then
        features.HandleNotLoadedIn()

        if selectedbosses == nil or features.gotosafespot(true,false) == false then
            return
        end

        if laststandactive == true then
            local playerdata = game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("DataFunction")
                :InvokeServer("GetData")
            
            local metreqs = false

            for i,v in pairs(playerdata["Traits"]) do
                if v == "Last Stand" then
                    metreqs = true
                end
            end

            if metreqs == false then
                Notify("Missing requirements..","You need to have Last Stand Trait", 2.5,"info")
                return
            end
        end

        NoFallDammage.Value = true

        local bosses = {
            ["Tairock"] = {
                rewards = "TairockRewards",
                rewardspos = CFrame.new(-121.222282, -215.594009, -1074.45251, 0.999605715, -4.95959385e-10, 0.0280780215, 7.73429029e-11, 1, 1.49101318e-08, -0.0280780215, -1.49020813e-08, 0.999605715),
                offset = 9
            },
            ["Chakra Knight"] = {
                rewards = "ChakraKnightRewards",
                rewardspos = CFrame.new(2831.09229, -123.500015, -1153.08569, -0.999299586, -1.25896638e-09, -0.0374205671, -1.16711085e-09, 1, -2.47652543e-09, 0.0374205671, -2.43111686e-09, -0.999299586),
                offset = 14,
                dangeranim = "rbxassetid://10141233349",
                seconddangeranim = "rbxassetid://10229183096",
                dangertime = 0.2
            },
            ["Lavarossa"] = {
                rewards = "LavarossaRewards",
                rewardspos = CFrame.new(-500.209869, -312.065948, -193.457336, -0.00906983018, 7.53408287e-08, 0.999958873, 7.59981873e-08, 1, -7.46546078e-08, -0.999958873, 7.53179563e-08, -0.00906983018),
                argument = "activateLavarossa",
                bosspos = CFrame.new(-536.194763, -314.055023, -201.574188, -0.159694523, 4.51376314e-09, 0.987166464, 4.54713767e-11, 1, -4.56508786e-09, -0.987166464, -6.84131751e-10, -0.159694523),
                offset = 11,
                dangeranim = "rbxassetid://6038040720",
                dangertime = 0.55
            },
            ["Barbarit The Rose"] = {
                rewards = "BarbaritRewards",
                rewardspos = CFrame.new(-1032.42004, 262.756836, -1413.35388, -0.999958932, 5.12125879e-08, -0.00906013697, 5.05472855e-08, 1, 7.36610488e-08, 0.00906013697, 7.32000629e-08, -0.999958932),
                argument = "activateBarbarit",
                bosspos = CFrame.new(-1031.22461, 260.756836, -1631.61987, 0.50503391, 2.51075054e-08, 0.863099515, -3.28260157e-08, 1, -9.88212268e-09, -0.863099515, -2.33413111e-08, 0.50503391),
                offset = 12.5,
                dangeranim = "rbxassetid://9656290960",
                dangertime = 0.5
            },
            ["Manda"] = {
                rewards = "MandaRewards",
                rewardspos = CFrame.new(1526.77515, -534.000061, 726.881836, -0.999981165, -1.28677238e-08, -0.00613576965, -1.29080728e-08, 1, 6.53631593e-09, 0.00613576965, 6.61539401e-09, -0.999981165),
                argument = "activateManda",
                bosspos = CFrame.new(1566.04309, -536.000488, 694.507812, -0.957136989, -9.88222837e-08, 0.289635658, -8.50688906e-08, 1, 6.00744414e-08, -0.289635658, 3.28604877e-08, -0.957136989),
                offset = 35,
                dangeranim = "rbxassetid://9954909571",
                dangertime = 0.4
            },
            ["Wooden Golem"] = {
                rewards = "WoodenGolemRewards",
                rewardspos = CFrame.new(-4705.57959, 336.919739, -2947.58691, -0.0247377306, -8.55055404e-09, 0.99969399, 5.33501918e-08, 1, 9.8733377e-09, -0.99969399, 5.35781126e-08, -0.0247377306),
                dangeranim = "rbxassetid://116907126244057",
                seconddangeranim = "rbxassetid://120758909308511",
                offset = 12,
                dangertime = 0.95
            },
            ["Shukaku"] = {
                rewards = "ShukakuRewards",
                rewardspos = CFrame.new(1947.83374, -125.386833, -1214.7688, 0.999622822, -1.17530725e-07, -0.0274633951, 1.18851858e-07, 1, 4.64730512e-08, 0.0274633951, -4.97195991e-08, 0.999622822),
                offset = 36,
                dangeranim = "rbxassetid://114433999627506",
                dangertime = 0.4
            },
            ["Matatabi"] = {
                rewards = "MatabiRewards",
                rewardspos = CFrame.new(1331.77, -536.00, 292.88, -0.999981165, -1.28677238e-08, -0.00613576965, -1.29080728e-08, 1, 6.53631593e-09, 0.00613576965, 6.61539401e-09, -0.999981165),
                offset = 35,
                dangeranim = "rbxassetid://9954909571",
                dangertime = 0.4
            },
            ["Hyuga Boss"] = {
                rewards = "Hyuga BossRewards",
                rewardspos = CFrame.new(-673.371765, -359.864746, -732.643982, 0.999200761, -7.67889397e-09, 0.0399733, 7.69931052e-09, 1, -3.56805974e-10, -0.0399733, 6.64287625e-10, 0.999200761),
                offset = 8,
                dangeranim = "rbxassetid://8580099842",
                seconddangeranim = "rbxassetid://8699113073",
                dangertime = 0.25
            },
        }

        local function bossguiconfig(action, name, health)
            if action == "disable" then
                BossFrame.Visible = false
            else
                BossFrame.Visible = true
            end

            if action == "killboss" then
                BossTitle.Text = "Current Boss: "..name
                BossHPLabel.Text = health
            else
                BossHPLabel.Text = ""
            end

            if action == "pickingup" then
                BossTitle.Text = "Picking Up Loot.."
            elseif action == "waiting" then
                BossTitle.Text = "Waiting for Bosses.."
            elseif action == "spawning" then
                BossTitle.Text = "Spawning Boss: "..name.. ".."
            end
        end

        local heavyweapon = nil
        
        local function renamehallowbosses()
            for _, hallow in pairs(game.workspace:GetChildren()) do
                if hallow.Name == "Hallowed Tairock" then
                    hallow.Name = "Tairock"
                    hallow:SetAttribute("hallow", true)
                elseif hallow.Name == "Hallowed Lavarossa" then
                    hallow.Name = "Lavarossa"
                    hallow:SetAttribute("hallow", true)
                    hallow:SetAttribute("hallow")
                elseif hallow.Name == "Barbarit The Hallowed" then
                    hallow.Name = "Barbarit The Rose"
                    hallow:SetAttribute("hallow", true)
                elseif hallow.Name == "Hallowed Chakra Knight" then
                    hallow.Name = "Chakra Knight"
                    hallow:SetAttribute("hallow", true)
                end
            end
        end
        
        -- determine weapon to autoequip
        local weapontoautoequip = nil
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
        local playerdata,region,servername = remote:InvokeServer("GetData")

        weapontoautoequip = playerdata["CurrentWeapon"]


        local function lookforweapon()
            local possibleweapons = {"Golden Zabunagi","Silver Zabunagi","Onyx Zabunagi", "Samehada", "Executioner's Blade"}
            if weapontoautoequip ~= nil then
                for _,name in pairs(possibleweapons) do
                    if weapontoautoequip == name then
                        return weapontoautoequip
                    end
                end
            end

            return nil
        end

        spawn(function()
            -- prevent chakra loss
            local DataEvent = RS:WaitForChild("Events"):WaitForChild("DataEvent")
            local subCooldownValue = RS.Settings[user]:FindFirstChild("SubCooldown")
            local cooldown = 8.5
            local lastSubChangeTime = tick()

            local subcdConnection = subCooldownValue.Changed:Connect(function(newVal)
                lastSubChangeTime = tick()
            end)

            local function bossbuffchakra()

                local chakra = plr.Backpack:FindFirstChild("chakra")
                local startval = chakra.Value
                            
                bosscbuffing = chakra.Changed:Connect(function(newval)

                    if newval < startval then
                        local lostamount = startval - newval                      
                        local newchakra = chakra.Value + lostamount
                        if newval + lostamount <= plr.Backpack.maxChakra.Value then
                            local args = {
                                [1] = "TakeChakra",
                                [2] = lostamount * -1
                            }
                                    
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                            chakra.Value = newchakra
                        end

                        startval = newval

                        if chakra.Value > plr.Backpack.maxChakra.Value then
                            chakra.Value = plr.Backpack.maxChakra.Value
                        end
                    else
                        startval = newval
                    end
                end)
            end

            bossbuffchakra()

            respawningbosschakra = plr.CharacterAdded:Connect(function()
                bosscbuffing:Disconnect()
                wait(1.3)
                bossbuffchakra()
            end)

            -- Hide Animations and Play Chakra Sense animation
            local track

            local function hideanim()
                local character = plr.Character or plr.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://9864206537"

                track = animator:LoadAnimation(anim)
                track.Priority = Enum.AnimationPriority.Core
                track.Looped = true
                track:Play()

                stoppinganim = animator.AnimationPlayed:Connect(function(newTrack)
                    if newTrack ~= track then
                        newTrack:Stop()
                    end
                end)

                stoppingburn = character.HumanoidRootPart.FireAilment.Played:Connect(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("RemoveFireAilment")
                end)
            end

            hideanim()

            respawninganimhide = plr.CharacterAdded:Connect(function()
                stoppinganim:Disconnect()
                wait(1.3)
                hideanim()
            end)

            task.spawn(function()
                while bossfarmactive.Value do 
                    task.wait()

                    local userSettings = RS.Settings:FindFirstChild(user)
                    if not userSettings then continue end

                    local meleeCooldown = userSettings:WaitForChild("MeleeCooldown")

                    if plr.Character and plr.Character:FindFirstChild("FakeHead") and plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI") and autoequipweapon and weapontoautoequip then
                        if plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI").skillName.Text ~= weapontoautoequip then
                            wait(0.4)
                            RS.Events.DataEvent:FireServer("Item", "Unselected", plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI").skillName.Text)
                            RS.Events.DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                        end
                    end

                    if meleeCooldown then
                        local args = { [1] = "CheckMeleeHit", [3] = "NormalAttack", [4] = false }
                        RS.Events.DataEvent:FireServer(unpack(args))
                        task.wait(0.15)
                    else
                        task.wait()
                    end
                end
            end)

            while bossfarmactive.Value == true do 
                wait(0.2)
                if tick() - lastSubChangeTime >= cooldown then
                    if plr.Character and plr.Character.HumanoidRootPart then
                        DataEvent:FireServer("TakeDamage", 0.000000001)
                        DataEvent:FireServer("Dash", "Sub", plr.Character.HumanoidRootPart.Position)
                    end
                end

                if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("Blocking") then
                    if RS.Settings[user]:FindFirstChild("Blocking").Value == false then
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack({"Block"}))
                    end
                end

                local args = {
                    "Charging"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            end


            -- clean up sub loop and respawn chakra apply and current chakra apply and animation hide

            if respawninganimhide then
                respawninganimhide:Disconnect()
            end

            if stoppinganim then
                stoppinganim:Disconnect()
            end

            if stoppingburn then
                stoppingburn:Disconnect()
            end

            if track then
                track:Stop() -- stop your animation when ending the loop
            end

            if subcdConnection then
                subcdConnection:Disconnect()
            end

            if bosscbuffing then
                bosscbuffing:Disconnect()
            end

            if respawningbosschakra then
                respawningbosschakra:Disconnect()
            end
        end)

        if nocooldownm1 then
            heavyweapon = lookforweapon()
            if heavyweapon == nil then
                Notify("Missing requirements.","You need a Heavy Weapon for inf M1.",2,"info")
                return
            else

                local DataEvent = RS:WaitForChild("Events"):WaitForChild("DataEvent")

                spawn(function()

                    while bossfarmactive.Value do
                        -- spam sub to reset stun and stack m1
                        wait()

                        if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("CombatCount") then
                            if RS.Settings[user]:FindFirstChild("CurrentWeapon") then
                                if RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Fist" and RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Tai" then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("Item","Unselected", weapontoautoequip)
                                end
                            end

                            if RS.Settings[user].CombatCount.Value > 3 then
                                DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                                DataEvent:FireServer("Item", "Unselected", weapontoautoequip)
                            end
                        end
                    end
                end)
            end
        end

        local function checkbossstatus(selectedboss)

            bossguiconfig("waiting")

            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == selectedboss then
                    if v:FindFirstChild("HumanoidRootPart") then
                        if not v:FindFirstChild("WorldEvent") and not v:FindFirstChild("npcImmuneTag") and Teleport(v:FindFirstChild("HumanoidRootPart").CFrame,false,true) == true then
                            return true, v:FindFirstChild("HumanoidRootPart")
                        end
                    end
                end
            end

            if selectedboss == "Lavarossa" or selectedboss == "Barbarit The Rose" or selectedboss == "Manda" then
                if workspace:FindFirstChild(bosses[selectedboss].rewards):FindFirstChild("Part").Transparency == 0 then
                    return false
                end
                
                if Teleport(bosses[selectedboss].bosspos) == false then return end
                    bossguiconfig("spawning", selectedboss)

                wait(0.25)

                local args = {
                    [1] = bosses[selectedboss].argument
                }
                    
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                plr.Character.Humanoid.Jump = true
                wait(0.3)
            end

            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == selectedboss then
                    if v:FindFirstChild("HumanoidRootPart") then
                        if not v:FindFirstChild("WorldEvent") and not v:FindFirstChild("npcImmuneTag") and Teleport(v:FindFirstChild("HumanoidRootPart").CFrame,false,true) == true then
                            return true, v:FindFirstChild("HumanoidRootPart")
                        end
                    end
                end
            end
        end

        local function finishboss(bosshrp, selectedboss)
            local killing = true
            local bossishallowed = false

            if bosshrp.Parent:GetAttribute("hallow") ~= nil then
                bossishallowed = true
            end
            
            local function tpandreacttoboss(bosshumanoidrootpart)
                local extraoffset = 0
                local firstdodge = false

                if sliderbossoffset ~= nil then
                    extraoffset = extraoffset + sliderbossoffset
                end

                if selectedboss ~= "Tairock" and selectedboss ~= "Lavarossa" then
                    local animator = bosshumanoidrootpart.Parent.Humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            if track.Animation.AnimationId == bosses[selectedboss].dangeranim then
                                if track.TimePosition > bosses[selectedboss].dangertime then
                                    if selectedboss == "Chakra Knight" then
                                        if track.TimePosition < 0.8 then
                                            extraoffset = 30
                                            firstdodge = true
                                        end
                                    elseif selectedboss == "Barbarit The Rose" then
                                        extraoffset = 2
                                        firstdodge = true
                                    elseif selectedboss == "Wooden Golem" then
                                        extraoffset = 200
                                        firstdodge = true
                                    elseif selectedboss == "Manda" then
                                        if track.TimePosition < 2.7 then
                                            extraoffset = 30
                                            firstdodge = true
                                        end
                                    elseif selectedboss == "Hyuga Boss" then
                                        extraoffset = 12
                                        firstdodge = true
                                    end
                                end
                            end
                        end
                        if firstdodge == false then
                            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                if track.Animation.AnimationId == bosses[selectedboss].seconddangeranim then
                                    if track.TimePosition > bosses[selectedboss].dangertime then
                                        if selectedboss == "Wooden Golem" then
                                            extraoffset = -137
                                        elseif selectedboss == "Chakra Knight" then
                                            extraoffset = 5
                                        elseif selectedboss == "Shukaku" then
                                            extraoffset = 2
                                        elseif selectedboss == "Hyuga Boss" then
                                            extraoffset = 20
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                local abovePos = bosshrp.Position + Vector3.new(0, bosses[selectedboss].offset + extraoffset, 0)
                local lookDown = CFrame.new(abovePos, bosshrp.Position)

                plr.Character.HumanoidRootPart.CFrame = lookDown
            end

            -- check safety
            local tweening = nil
            wait(0.5)

            tweening = game:GetService("RunService").Heartbeat:Connect(function()
                if bossfarmactive.Value == false then
                    warn("boss farm is disabled")
                    killing = false
                    return
                end

                if bosshrp and bosshrp.Parent ~= nil and bosshrp.Parent:FindFirstChild("Humanoid") then
                    -- goto boss
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("Knocked") then
                            if RS.Settings[user]:FindFirstChild("Knocked").Value == true then
                                if plr.Character.HumanoidRootPart then
                                    features.gotosafespot()
                                end
                            else
                                tpandreacttoboss(bosshrp)
                            end
                        end
                    end
                    
                    -- Damage Display for GUI
                        local hp = bosshrp.Parent.Humanoid.Health // 10 * 10
                        local maxhp = bosshrp.Parent.Humanoid.MaxHealth // 10 * 10

                        local tag = "HP: "..hp.."/"..maxhp
                        if tag ~= BossHPLabel.Text then
                            bossguiconfig("killboss", selectedboss, tag)
                        end

                    --grip boss/ dodge lava attack while grip
                    if selectedboss == "Lavarossa" or selectedboss == "Barbarit The Rose" or selectedboss == "Tairock" then
                        if bosshrp.Parent:FindFirstChild("Settings"):FindFirstChild("Knocked").Value == true then
                            if selectedboss == "Lavarossa" then
                                if bosshrp.Parent.LavaRightArm.Transparency == 1 and bosshrp.Parent.LavaLeftArm.Transparency == 1 and bosshrp.Parent.LavaRightLeg.Transparency == 1 and bosshrp.Parent.LavaLeftLeg.Transparency == 1 then
                                    plr.Character.HumanoidRootPart.CFrame = bosshrp.CFrame
                                    local args = {
                                        [1] = "Grip"
                                    }
                                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                                end
                            else
                                plr.Character.HumanoidRootPart.CFrame = bosshrp.CFrame
                                local args = {
                                    [1] = "Grip"
                                }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                            end
                        end
                    end
                else
                    warn("bosshrp or humanoid")
                    killing = false
                end
            end)
            
            -- Last Stand Trigger/keep function running
            if laststandactive == true then
                warn("start killing boss")
                local targethp = plr.Character.Humanoid.MaxHealth / 5
                local cooldown = false
                while killing == true do
                    wait()
                    if plr.Character then
                        if plr.Character.Humanoid then
                            if plr.Character.Humanoid.Health > targethp and cooldown == false then
                                local args = {
                                    [1] = "TakeDamage",
                                    [2] = plr.Character.Humanoid.Health - targethp + 2,
                                    [3] = "yes"
                                }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                                cooldown = true
                                spawn(function()
                                    wait(1)
                                    cooldown = false
                                end)
                            end
                        end
                    end
                end
            else
                warn("start killing boss")
                while killing == true do
                    wait()
                end
            end
            
            if tweening then             
                tweening:Disconnect()
                warn("tween disconnect")
            end
            warn("killing boss done")
            if bossfarmactive.Value == false then return end

            local rewardsplace = workspace:FindFirstChild(bosses[selectedboss].rewards)
            if rewardsplace:FindFirstChild("TrinketSpawn1") then
                if not rewardsplace["TrinketSpawn1"]:FindFirstChild("Occupied") then
                    features.gotosafespot()
                    wait()
                    return
                end
            end

            if bossfarmactive.Value == false then return end

            plr.Character.HumanoidRootPart.CFrame = bosses[selectedboss].rewardspos

            local bosspickuptable = {}
            local dropsthere = false

            bossguiconfig("pickingup")

            local lootdropwait
            lootdropwait = game.Workspace.ChildAdded:Connect(function(newthing)
                local idObject = newthing:FindFirstChild("ID") or newthing:FindFirstChildWhichIsA("StringValue", true)
                
                if not idObject then
                    for _, desc in pairs(newthing:GetDescendants()) do
                        if desc.Name == "ID" then
                            idObject = desc
                            break
                        end
                    end
                end

                if idObject then
                    table.insert(bosspickuptable, {object = newthing, id = idObject})
                    dropsthere = true
                    wait(0.125)
                end
            end)

            repeat
                task.wait()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.CFrame = bosses[selectedboss].rewardspos
                end
            until dropsthere or not bossfarmactive.Value

            task.wait(3)

            if dropsthere then
                for i = #bosspickuptable, 1, -1 do
                    local entry = bosspickuptable[i]
                    local v, idObject = entry.object, entry.id

                    if v and v:IsDescendantOf(workspace) and idObject then
                        local targetCFrame

                        if v:IsA("BasePart") then
                            targetCFrame = v.CFrame * CFrame.new(0, 1, 0)
                        else
                            for _, part in pairs(v:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    targetCFrame = part.CFrame * CFrame.new(0, 1, 0)
                                    break
                                end
                            end
                        end

                        if targetCFrame and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            plr.Character.HumanoidRootPart.CFrame = targetCFrame
                        end

                        local startTime = tick()
                        while v and v:IsDescendantOf(workspace) and (tick() - startTime < 2) do
                            game.ReplicatedStorage.Events.DataEvent:FireServer("PickUp", idObject.Value)
                            task.wait()
                        end

                        table.remove(bosspickuptable, i)
                    end
                end
            end

            task.wait(1)

            if lootdropwait then
                lootdropwait:Disconnect()
            end

            if bossishallowed == true then
                for _, values in pairs(workspace:GetChildren()) do
                    if values.Name == "Candy" and values:FindFirstChild(user) then
                        while values and values:IsDescendantOf(workspace) and bossfarmactive.Value do
                            wait()
                            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                plr.Character.HumanoidRootPart.CFrame = values.CFrame
                            end
                            task.spawn(function()
                                wait(0.1)
                                for _, children in pairs(values:GetChildren()) do
                                    if children:IsA("ClickDetector") then
                                        fireclickdetector(children)
                                    end
                                end
                            end)
                        end
                    end
                end
            end

            features.gotosafespot()
        end

        local bossthere = false
        local bosshrp

        local lookingforbosscounter = 0

        -- MAIN PART
        -- renaming the bosses

        renamechildconn = game.workspace.ChildAdded:Connect(function(chi)
            if chi.Name == "Hallowed Tairock"
            or chi.Name == "Hallowed Lavarossa"
            or chi.Name == "Barbarit The Hallowed"
            or chi.Name == "Hallowed Chakra Knight" then
                renamehallowbosses()
            end
        end)
        
        renamehallowbosses()

        while bossfarmactive.Value do
            for i, v in selectedbosses do
                if bossfarmactive.Value then
                    if plr.Character then
                        if plr.Character.HumanoidRootPart then
                            bossthere, bosshrp = checkbossstatus(v)
                        end
                    end
                end
                if bossthere then
                    if bossfarmactive.Value then
                        lookingforbosscounter = 0
                        finishboss(bosshrp, v)
                    end
                elseif serverhopnoboss == true then
                    lookingforbosscounter += 1
                    if lookingforbosscounter > 10 then
                        features.TeleportRandomServer()
                        return
                    end
                end
                wait()
                bossthere = false
                bosshrp = nil
            end
            wait()
        end


        -- DISABLING
    else

        NoFallDammage.Value = false
        BossFrame.Visible = false

        if renamechildconn then
            renamechildconn:Disconnect()
            renamechildconn = nil
        end

        if tweening then
            tweening:Disconnect()
            tweening = nil
        end

        if lootdropwait then
            lootdropwait:Disconnect()
            lootdropwait = nil
        end

        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack({"EndBlock"}))
        bossthere = false
        bosshrp = nil
        task.spawn(function()
            wait(0.1)
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack({"EndBlock"}))
        end)
    end
end

features.CheckNotiAndSend = function(reason, message)
    if selectednotis ~= nil and Webhook_URL ~= nil then
        for i, v in pairs(selectednotis) do
            if v == reason then
                sendmessage(message)
            end
        end
    end
end

features.Treehop = function()
    if treehopping.Value then
        features.HandleNotLoadedIn()
        local char = plr.Character
        local spawned = false
        local pickuptable = {}

        NoFallDammage.Value = true

        waiting = workspace.ChildAdded:Connect(function(newchild)
            if newchild:FindFirstChild("ID") then
                spawned = true
                print(newchild.Name)
                for i, v in selectedfruits do
                    if v == "All" then
                        if newchild.Name == "Chakra Fruit" or newchild.Name == "Life Up Fruit" or newchild.Name == "Fruit Of Forgetfulness" or newchild.Name == "Alluring Apple" or newchild.Name == "Apple" or newchild.Name == "Orange" or newchild.Name == "Banana" or newchild.Name == "Pear" or newchild.Name == "Mango" then
                            table.insert(pickuptable,newchild)
                        end
                    elseif v == "Life / Forgetfulness Fruit" then
                        if newchild.Name == "Life Up Fruit" or newchild.Name == "Fruit Of Forgetfulness" then
                            table.insert(pickuptable, newchild)
                        end
                    elseif newchild.Name == v then
                        table.insert(pickuptable, newchild)
                    end
                end
            end
        end)

        local function nocliploop()
            for i, v in pairs(plr.Character:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
        noclippinghop = RunService.Stepped:Connect(nocliploop)

        while treehopping.Value do
            wait()
            if selectedfruits[1] == nil then continue end
            for i ,v in pairs(workspace:GetDescendants()) do
                if v.Name == "FruitType" then
                    if treehopping.Value then
                        if onlyhopselectedfruittypes then
                            local found = false
                            for _, frtype in pairs(selectedfruits) do
                                if v.Value == frtype then
                                    found = true
                                    break
                                end
                            end
                            if not found then
                                continue
                            end
                        end

                        if v:GetAttribute("check") and v:GetAttribute("check") == true then
                        else


                            char.HumanoidRootPart.CFrame = v.Parent:FindFirstChild("MainBranch").CFrame

                            local startTime = os.clock()

                            while os.clock() - startTime < 12 and spawned == false and treehopping.Value == true do --timeout
                                wait()
                            end

                            if spawned == false then
                                continue
                            end
                            
                            if next(pickuptable) ~= nil and treehopping.Value == true then
                                local bv = Instance.new("BodyVelocity")
                                bv.Velocity = Vector3.new(0, 0, 0)
                                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                                bv.Parent = plr.Character:FindFirstChild("HumanoidRootPart")

                                for ind, val in pickuptable do
                                    if val:FindFirstChild("ID") then
                                        if val:FindFirstChild("ID").Value then
                                            plr.Character.HumanoidRootPart.CFrame = val.CFrame * CFrame.new(0,-6,0) -- go below fruit

                                            while val and val:IsDescendantOf(workspace) do
                                                local args = {
                                                    [1] = "PickUp",
                                                    [2] = val:FindFirstChild("ID").Value
                                                }
                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                                            wait()
                                            end
                                        end
                                    end
                                end
                                table.clear(pickuptable)
                                bv:Destroy()
                                wait()
                            end

                            v:SetAttribute("check",true)
                            spawned = false
                        end
                    else
                        break
                    end
                end
            end
            if treehopping.Value then
                for i,v in pairs(workspace:GetDescendants()) do
                    if v.Name == "FruitType" then
                        if v:GetAttribute("check") then
                            v:SetAttribute("check", false)
                        end
                    end
                end
            end
            wait()
        end
        noclippinghop:Disconnect()
        waiting:Disconnect()
        NoFallDammage.Value = false
    end
end

features.StealDroppedItems = function()
    if stealingitems then

        local function pickupitem(item)
            local startTime = tick()
            local duration = 30
            local tries = 0

            local function doTouch()
                if item:IsDescendantOf(workspace) then
                    firetouchinterest(plr.Character.HumanoidRootPart, item, true)
                end
                if item:IsDescendantOf(workspace) then
                    firetouchinterest(plr.Character.HumanoidRootPart, item, false)
                end
            end

            repeat
                wait()
            until item:FindFirstChild("ItemTouch")
            local itemcf = item.CFrame

            local heartbeatConnection
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                if not item or item.Parent ~= workspace or (tick() - startTime) >= duration then
                    if heartbeatConnection then
                        heartbeatConnection:Disconnect()
                    end
                    return
                end

                if stealingitemswithtp then
                    Teleport(item.CFrame + Vector3.new(0, 23, 0),true)
                    wait(0.18)
                    doTouch()
                    warn("touched")
                else
                    doTouch()
                    warn("2nd touched")
                end

                tries += 1
            end)
        end

        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ItemOwner" then
                local gui = v.Parent:FindFirstChild("GUI")
                local itemText = gui and gui:FindFirstChild("ItemName")
                local ryoText = gui and gui:FindFirstChild("Ryo")
                local itemname = itemText and itemText.Text ~= "" and itemText.Text or (ryoText and ryoText.Text .. " Ryo" or "Unknown")

                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and v.Parent:WaitForChild(user,1) then
                    pickupitem(v.Parent)
                    Notify(itemname, "was stolen.", 2, "venetian-mask")
                end

                wait()
            end
        end

        stealconnect = workspace.ChildAdded:Connect(function(chi)
            wait(0.15)
            if chi:FindFirstChild("ItemOwner") and chi:FindFirstChild("GUI") then
                local gui = chi:FindFirstChild("GUI")
                local itemText = gui:FindFirstChild("ItemName")
                local ryoText = gui:FindFirstChild("Ryo")
                local itemname = itemText and itemText.Text ~= "" and itemText.Text or (ryoText and ryoText.Text .. " Ryo" or "Unknown")
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and chi:WaitForChild(user,1) then
                    pickupitem(chi)
                    Notify(itemname, "was stolen.", 2, "venetian-mask")
                end
            end
        end)

    else
        if stealconnect and stealconnect.Connected then
            stealconnect:Disconnect()
        end
    end
end

local startrobcf = nil

features.StealDroppedItemsAdv = function()

    if stealingitemsadv then

        if TargetPlayer == nil then
            Notify("Missing requirements..", "Select Target in Main Tab", 3, "info")
            return
        end

        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            startrobcf = plr.Character.HumanoidRootPart.CFrame
        end

        targetstealconn = RunService.RenderStepped:Connect(function()
            local myChar = plr.Character
            local targetChar = TargetPlayer and TargetPlayer.Character

            if myChar and targetChar then
                local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

                if myHRP and targetHRP then
                    myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, -23.2, 0))
                end
            end
        end)

    else

        if targetstealconn and targetstealconn.Connected then
            targetstealconn:Disconnect()
        end

        if startrobcf then
            Teleport(startrobcf)
        end
    end
end

features.HitboxExtend = function()
    if not hitboxextending then return end

    local extendingMoves = {
        "Lion's Barrage",
        "Cleave Rush",
        "Dynamic Entry",
        "Rasengan",
        "Rasengan Barrage",
        "Fire Seal",
        "Thrusting Strike",
        "Water Prison",
        "Chidori",
        "Primary Lotus",
        "Wood Seal"
    }

    local heartbeatConn
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not hitboxextending then
            heartbeatConn:Disconnect()
            return
        end

        if not plr.Character then return end
        local plrHRP = plr.Character:FindFirstChild("HumanoidRootPart")
        if not plrHRP then return end

        local hitradius = hitboxstud or 8
        if RS.Settings and RS.Settings[user] and RS.Settings[user].CurrentSkill then
            local currentSkill = RS.Settings[user].CurrentSkill.Value

            local validMove = false
            for _, move in pairs(extendingMoves) do
                if move == currentSkill then
                    validMove = true
                    break
                end
            end
            if not validMove then return end
            local usedMove = currentSkill

            if usedMove == "Lion's Barrage" or usedMove == "Dynamic Entry" or usedMove == "Thrusting Strike" or usedMove == "Primary Lotus" or usedMove == "Cleave Rush" then
                for _, v in pairs(game.Workspace.Debris:GetChildren()) do
                    if usedMove ~= RS.Settings[user].CurrentSkill.Value then break end
                    if v.Name == "Hitbox" and v:FindFirstChild("TouchInterest") then
                        for _, otherplr in pairs(game.Players:GetPlayers()) do
                            if usedMove ~= RS.Settings[user].CurrentSkill.Value then break end
                            if otherplr ~= plr and otherplr.Character then
                                local otherHRP = otherplr.Character:FindFirstChild("HumanoidRootPart")
                                if otherHRP then
                                    local distance = (plrHRP.Position - otherHRP.Position).Magnitude
                                    if distance <= hitradius then
                                        firetouchinterest(v, otherHRP, true)
                                        firetouchinterest(v, otherHRP, false)
                                    end
                                end
                            end
                        end
                    end
                end
            else
                for _, xotherplr in pairs(game.Players:GetPlayers()) do
                    if usedMove ~= RS.Settings[user].CurrentSkill.Value then break end
                    if xotherplr ~= plr and xotherplr.Character then
                        local otherHRP = xotherplr.Character:FindFirstChild("HumanoidRootPart")
                        if otherHRP then
                            local distance = (plrHRP.Position - otherHRP.Position).Magnitude
                            if distance <= hitradius then
                                if usedMove ~= "Rasengan Barrage" then
                                    if plr.Character:FindFirstChild(usedMove) then
                                        firetouchinterest(plr.Character[usedMove], otherHRP, true)
                                        firetouchinterest(plr.Character[usedMove], otherHRP, false)
                                    end
                                else
                                    if plr.Character:FindFirstChild("RasenganLeft") then
                                        firetouchinterest(plr.Character.RasenganLeft, otherHRP, true)
                                        firetouchinterest(plr.Character.RasenganLeft, otherHRP, false)
                                    end
                                    if plr.Character:FindFirstChild("RasenganRight") then
                                        firetouchinterest(plr.Character.RasenganRight, otherHRP, true)
                                        firetouchinterest(plr.Character.RasenganRight, otherHRP, false)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

features.UseBasket = function()
    while AutoUsingBasket do
        local playerdata = game:GetService("ReplicatedStorage")
            :WaitForChild("Events")
            :WaitForChild("DataFunction")
            :InvokeServer("GetData")

        local foundbasket = false
        local candyamount = 0

        for _, entry in pairs(playerdata.Inventory or {}) do
            if entry.Item == "Treat Basket" then
                foundbasket = true
                candyamount = entry.Data and entry.Data.Candies or 0
                break
            end
        end

        for _, entry in pairs(playerdata.Loadout or {}) do
            if entry.Item == "Treat Basket" then
                foundbasket = true
                candyamount = entry.Data and entry.Data.Candies or 0
                break
            end
        end

        if foundbasket and candyamount < 8 then
            local ind = 1
            repeat
                if workspace:FindFirstChild(NPCs[ind]) and workspace:FindFirstChild(NPCs[ind]):FindFirstChild("HumanoidRootPart") then
                    local args = {
                        "trickOrTreat",
                        workspace:FindFirstChild(NPCs[ind]).HumanoidRootPart
                    }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Events")
                        :WaitForChild("DataFunction")
                        :InvokeServer(unpack(args))
                end

                ind += 1
                task.wait(0.2)

                local playerdata = game:GetService("ReplicatedStorage")
                    :WaitForChild("Events")
                    :WaitForChild("DataFunction")
                    :InvokeServer("GetData")

                for _, entry in pairs(playerdata.Inventory or {}) do
                    if entry.Item == "Treat Basket" then
                        candyamount = entry.Data and entry.Data.Candies or 0
                        break
                    end
                end

            until candyamount >= 8 or ind > #NPCs
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack({"Item","Selected","Treat Basket"}))
            wait(0.1)
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack({"Consumed","Treat Basket"}))
        elseif foundbasket and candyamount >= 8 then
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack({"Item","Selected","Treat Basket"}))
            wait(0.1)
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack({"Consumed","Treat Basket"}))
        end


        task.wait(5)
    end
end


features.FarmCandy = function()
    if farmingcandy.Value == false then return end

    features.HandleNotLoadedIn()

    if features.gotosafespot(true,false) == false then
        return
    end

    NoFallDammage.Value = true

    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local workspace = game:GetService("Workspace")
    local RS = ReplicatedStorage

    -- collect available pumpkin points
    local availablepumpkinpoints = {}
    for _, v in pairs(workspace:GetChildren()) do
        if v and v.Name == "PumpkinPoint" then
            local destroyed = v:FindFirstChild("Destroyed")
            if destroyed and destroyed.Value == false then
                table.insert(availablepumpkinpoints, v)
            end
        end
    end

    local lookfornewpointconn
    lookfornewpointconn = workspace.ChildAdded:Connect(function(newchild)
        if newchild and newchild.Name == "PumpkinPoint" then
            local destroyed = newchild:FindFirstChild("Destroyed")
            if not destroyed or destroyed.Value == false then
                table.insert(availablepumpkinpoints, newchild)
            end
        end
    end)

    -- collect available hallowed rifts (in Debris)
    local availablehallowedrifts = {}
    if workspace:FindFirstChild("Debris") then
        for _, v in pairs(workspace.Debris:GetChildren()) do
            if v and v.Name == "Infernal Sasuke Portal" then
                table.insert(availablehallowedrifts, v)
            end
        end
    end

    local lookfornewriftconn
    if workspace:FindFirstChild("Debris") then
        lookfornewriftconn = workspace.Debris.ChildAdded:Connect(function(newchild)
            if newchild and newchild.Name == "Infernal Sasuke Portal" then
                table.insert(availablehallowedrifts, newchild)
            end
        end)
    end

    -- collect available candy
    local availablecandy = {}
    for _, v in pairs(workspace:GetChildren()) do
        if v and v.Name == "Candy" then
            table.insert(availablecandy, v)
        end
    end

    local lookfornewcandyconn
    lookfornewcandyconn = workspace.ChildAdded:Connect(function(newchild)
        if newchild and newchild.Name == "Candy" then
            table.insert(availablecandy, newchild)
        end
    end)

    local heavyweapon = nil

    -- determine weapon to autoequip
    local weapontoautoequip = nil
    do
        local remote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
        local playerdata = nil
        local ok, a, b, c = pcall(function()
            return remote:InvokeServer("GetData")
        end)
        if ok and type(a) == "table" then
            playerdata = a
        end

        if playerdata then
            weapontoautoequip = playerdata["CurrentWeapon"]
        end
    end

    local function lookforweapon()
        local possibleweapons = {"Golden Zabunagi","Silver Zabunagi","Onyx Zabunagi", "Samehada", "Executioner's Blade"}
        if weapontoautoequip ~= nil then
            for _, name in pairs(possibleweapons) do
                if weapontoautoequip == name then
                    warn("Auto-equip weapon: ", weapontoautoequip)
                    return weapontoautoequip
                end
            end
        end
        return nil
    end

    -- Sub-loop, chakra handling, animation hide etc.
    spawn(function()
        local DataEvent = RS:WaitForChild("Events"):WaitForChild("DataEvent")
        local userSettings = RS.Settings:FindFirstChild(user)
        local subCooldownValue = userSettings and userSettings:FindFirstChild("SubCooldown")
        local cooldown = 8.5
        local lastSubChangeTime = tick()

        local subcdConnection
        if subCooldownValue then
            subcdConnection = subCooldownValue.Changed:Connect(function()
                lastSubChangeTime = tick()
            end)
        end

        local candycbuffing
        local respawningcandychakra

        local function candybuffchakra()
            local chakra = plr.Backpack:FindFirstChild("chakra")
            if not chakra then return end
            local startval = chakra.Value

            candycbuffing = chakra.Changed:Connect(function(newval)
                if not farmingcandy.Value then return end
                if newval < startval then
                    local lostamount = startval - newval
                    local newchakra = chakra.Value + lostamount
                    if newval + lostamount <= plr.Backpack.maxChakra.Value then
                        local args = { [1] = "TakeChakra", [2] = lostamount * -1 }
                        ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        chakra.Value = newchakra
                    end
                    startval = newval
                    if chakra.Value > plr.Backpack.maxChakra.Value then
                        chakra.Value = plr.Backpack.maxChakra.Value
                    end
                else
                    startval = newval
                end
            end)
        end

        candybuffchakra()

        respawningcandychakra = plr.CharacterAdded:Connect(function()
            if candycbuffing then
                candycbuffing:Disconnect()
            end
            wait(1.3)
            candybuffchakra()
        end)

        -- Hide Animations and Play Chakra Sense animation
        local candytrack
        local candystoppinganim
        local candystoppingburn

        local function hideanim()
            local character = plr.Character or plr.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://9864206537"

            candytrack = animator:LoadAnimation(anim)
            candytrack.Priority = Enum.AnimationPriority.Core
            candytrack.Looped = true
            candytrack:Play()

            candystoppinganim = animator.AnimationPlayed:Connect(function(newTrack)
                if newTrack ~= candytrack then
                    newTrack:Stop()
                end
            end)

            if character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart:FindFirstChild("FireAilment") then
                candystoppingburn = character.HumanoidRootPart.FireAilment.Played:Connect(function()
                    ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("RemoveFireAilment")
                end)
            end
        end

        hideanim()

        local candyrespawninganimhide
        candyrespawninganimhide = plr.CharacterAdded:Connect(function()
            if candystoppinganim then candystoppinganim:Disconnect() end
            if candystoppingburn then candystoppingburn:Disconnect() end
            if candytrack then candytrack:Stop() end
            wait(1.3)
            hideanim()
        end)

        task.spawn(function()
            while farmingcandy.Value do
                local userSettings = RS.Settings:FindFirstChild(user)
                if not userSettings then continue end

                local meleeCooldown = userSettings:WaitForChild("MeleeCooldown")

                if plr.Character and plr.Character:FindFirstChild("FakeHead") and plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI") and candyautoequipweapon and weapontoautoequip then
                    if plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI").skillName.Text ~= weapontoautoequip then
                        wait(0.4)
                        RS.Events.DataEvent:FireServer("Item", "Unselected", plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI").skillName.Text)
                        RS.Events.DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                    end
                end

                if meleeCooldown then
                    local args = { [1] = "CheckMeleeHit", [3] = "NormalAttack", [4] = false }
                    RS.Events.DataEvent:FireServer(unpack(args))
                    task.wait(0.15)
                else
                    task.wait()
                end
            end
        end)

        while farmingcandy.Value == true do
            wait(0.2)
            if tick() - lastSubChangeTime >= cooldown then
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    DataEvent:FireServer("TakeDamage", 0.000000001)
                    DataEvent:FireServer("Dash", "Sub", plr.Character.HumanoidRootPart.Position)
                end
            end

            if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("Blocking") then
                if RS.Settings[user]:FindFirstChild("Blocking").Value == false then
                    ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("Block")
                end
            end

            ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("Charging")
        end

        -- cleanup inside this spawn
        if candyrespawninganimhide then candyrespawninganimhide:Disconnect() end
        if candystoppinganim then candystoppinganim:Disconnect() end
        if candystoppingburn then candystoppingburn:Disconnect() end
        if candytrack then candytrack:Stop() end
        if subcdConnection then subcdConnection:Disconnect() end
        if candycbuffing then candycbuffing:Disconnect() end
        if respawningcandychakra then respawningcandychakra:Disconnect() end
    end)

    -- inf M1 heavy weapon logic
    if candynocooldownm1 then
        heavyweapon = lookforweapon()
        warn(heavyweapon)
        if heavyweapon == nil then
            Notify("Missing requirements.","You need a Heavy Weapon for inf M1.",2,"info")
            return
        else
            local DataEvent = RS:WaitForChild("Events"):WaitForChild("DataEvent")
            spawn(function()
                while farmingcandy.Value do
                    wait()
                    if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("CombatCount") then
                        if RS.Settings[user]:FindFirstChild("CurrentWeapon") then
                            if RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Fist" and RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Tai" then
                                ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("Item","Unselected", weapontoautoequip)
                            end
                        end

                        if RS.Settings[user].CombatCount.Value > 3 then
                            DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                            DataEvent:FireServer("Item", "Unselected", weapontoautoequip)
                        end
                    end
                end
            end)
        end
    end

    -- helper functions to check and teleport to targets safely
    local function checkpumpkinstatus()
        for i = #availablepumpkinpoints, 1, -1 do
            local v = availablepumpkinpoints[i]
            if v and v:IsDescendantOf(workspace) and v:FindFirstChild("Main") and v:FindFirstChild("Destroyed") and v.Destroyed.Value == false then
                if Teleport(v:FindFirstChild("Main").CFrame,false, true) == true then
                    return true, v
                end
            else
                table.remove(availablepumpkinpoints, i)
            end
        end
        return false
    end

    local function checkhalloweenriftstatus()
        for i = #availablehallowedrifts, 1, -1 do
            local v = availablehallowedrifts[i]
            if v and v:IsDescendantOf(workspace) then
                if Teleport(v.CFrame, false, true) == true then
                    return true, v
                end
            else
                table.remove(availablehallowedrifts, i)
            end
        end
        return false
    end

    local function checkcandystatus()
        for i = #availablecandy, 1, -1 do
            local v = availablecandy[i]
            if v and v:IsDescendantOf(workspace) and v:FindFirstChild(user) then
                if Teleport(v.CFrame, false, true) == true then
                    return true, v
                end
            else
                table.remove(availablecandy, i)
            end
        end
        return false
    end

    local function breakpumpkinpoint(Shard)
        if not Shard or not Shard.Parent then return end

        local TargetNames = {
            ["Hallowed Biyo Bay Guard"] = true,
            ["Hallowed Fort Mello Guard"] = true,
            ["Hallowed Bandit"] = true,
            ["Hallowed Cratos"] = true,
        }

        local candytpoffset = -9
        local breakingandpickingup = true
        local firstdrop = false
        local candypickuptable = {}
        local killingnearbynpc = false
        local nearbyNPCs = {}

        local myHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        local PointShard = Shard:FindFirstChild("Main")
        if not PointShard then return end

        local candypointhbconn
        candypointhbconn = RunService.Heartbeat:Connect(function()
            if not (PointShard and PointShard:IsDescendantOf(workspace) and farmingcandy.Value) then return end
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if RS.Settings:FindFirstChild(user) 
            and RS.Settings[user]:FindFirstChild("Knocked") 
            and RS.Settings[user].Knocked.Value == true then
                hrp.CFrame = CFrame.new(-2974.29, 326.18, 646.61)
                return
            end

            if killingnearbynpc then
                local npcHRP = nearbyNPCs[1]
                if npcHRP and npcHRP:IsDescendantOf(workspace) then
                    local targetPos = npcHRP.Position + Vector3.new(0, -9, 0)
                    hrp.CFrame = CFrame.new(targetPos, npcHRP.Position)
                else
                    table.remove(nearbyNPCs, 1)
                    if #nearbyNPCs == 0 then
                        killingnearbynpc = false
                    end
                end
                return
            end

            local belowTarget = PointShard.Position + Vector3.new(0, candytpoffset + (slidercandyoffset or 0), 0)
            hrp.CFrame = CFrame.new(belowTarget, PointShard.Position)
        end)

        local candypickupconnection
        candypickupconnection = workspace.ChildAdded:Connect(function(newthing)
            if not newthing then return end
            for _, desc in pairs(newthing:GetDescendants()) do
                if desc and desc.Name == "ID" then
                    table.insert(candypickuptable, newthing)
                    firstdrop = true
                    if Shard:FindFirstChild("Destroyed") and Shard.Destroyed.Value == true then
                        candytpoffset = -4.2
                    end
                    break
                end
            end
        end)

        while breakingandpickingup and farmingcandy.Value do
            task.wait()
            if firstdrop then
                wait(3)
                local startTime = tick()
                while (tick() - startTime < 3) or #candypickuptable > 0 do
                    for i = #candypickuptable, 1, -1 do
                        local v = candypickuptable[i]
                        local idObject
                        for _, desc in pairs(v:GetDescendants()) do
                            if desc.Name == "ID" then
                                idObject = desc
                                break
                            end
                        end

                        if idObject then
                            local pickuptime = tick()
                            while v and v:IsDescendantOf(workspace) and (tick() - pickuptime < 6) and farmingcandy.Value do
                                ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("PickUp", idObject.Value)
                                task.wait(0.1)
                            end
                            table.remove(candypickuptable, i)
                        else
                            table.remove(candypickuptable, i)
                        end
                    end
                    task.wait()
                end
                breakingandpickingup = false
            end
        end

        if pumpkinkillingnearby and farmingcandy.Value then
            for _, model in ipairs(workspace:GetChildren()) do
                if model:IsA("Model") then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local hrp = model:FindFirstChild("HumanoidRootPart")
                    if hum and hrp then
                        local baseName = model.Name:gsub("%d+$", "")
                        if TargetNames[baseName] and (hrp.Position - myHRP.Position).Magnitude <= 100 then
                            table.insert(nearbyNPCs, hrp)
                        end
                    end
                end
            end
            killingnearbynpc = (#nearbyNPCs > 0)
        end

        while killingnearbynpc and farmingcandy.Value do
            task.wait()
        end

        if candypickupconnection then candypickupconnection:Disconnect() end
        if candypointhbconn then candypointhbconn:Disconnect() end
        features.gotosafespot()
    end

    local function triggerrift(Portal)
        if not Portal or not Portal:IsDescendantOf(workspace) then return end
        while Portal and Portal:IsDescendantOf(workspace) and farmingcandy.Value do
            wait()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = Portal.CFrame
            end
        end
        features.gotosafespot()
    end

    local function gotocandyandpickup(Candy)
        if not Candy or not Candy:IsDescendantOf(workspace) then return end
        task.spawn(function()
            wait(0.5)
            for _, children in pairs(Candy:GetChildren()) do
                if children:IsA("ClickDetector") then
                    fireclickdetector(children)
                end
            end
        end)

        while Candy and Candy:IsDescendantOf(workspace) and farmingcandy.Value do
            wait()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = Candy.CFrame * CFrame.new(0, -5, 0)
            end
        end
        features.gotosafespot()
    end

    -- main loop
    local findingattempts = 0
    while farmingcandy.Value do
        wait()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            -- try pumpkin
            if table.find(selectedcandyways, "Pumpkin Points") and #availablepumpkinpoints > 0 then
                local foundpumpkinpoint, pointshard = checkpumpkinstatus()
                if foundpumpkinpoint and farmingcandy.Value then
                    breakpumpkinpoint(pointshard)

                    --pickup candy after point broken
                    for i, v in pairs(availablecandy) do
                        local foundcandy, candyinst = checkcandystatus()
                        if foundcandy and farmingcandy.Value then
                            gotocandyandpickup(candyinst)
                        end
                    end
                else
                    findingattempts += 1
                    if findingattempts >= 9 and candyserverhop then
                        features.TeleportRandomServer()
                    end
                end
            elseif #availablepumpkinpoints == 0 then
                warn("no pumpkin")
                findingattempts += 1
                warn(findingattempts)
                if findingattempts >= 9 and candyserverhop then
                    features.TeleportRandomServer()
                end
            -- try rift
            elseif table.find(selectedcandyways, "Hallowed Rifts") then
                local foundrift, rift = checkhalloweenriftstatus()
                if foundrift and farmingcandy.Value then
                    triggerrift(rift)

                    --pickupcandy after rift done

                    for i, v in pairs(availablecandy) do
                        local foundcandy, candyinst = checkcandystatus()
                        if foundcandy and farmingcandy.Value then
                            gotocandyandpickup(candyinst)
                        end
                    end
                else
                    
                    for i, v in pairs(availablecandy) do
                        local foundcandy, candyinst = checkcandystatus()
                        if foundcandy and farmingcandy.Value then
                            gotocandyandpickup(candyinst)
                        end
                    end
                end

            else
                -- fallback: check candy if no other selection
                local foundcandy, candyinst = checkcandystatus()
                if foundcandy and farmingcandy.Value then
                    gotocandyandpickup(candyinst)
                end
            end
            wait(0.1)
        end
    end

    -- disconnect search listeners
    if lookfornewpointconn then lookfornewpointconn:Disconnect() end
    if lookfornewriftconn then lookfornewriftconn:Disconnect() end
    if lookfornewcandyconn then lookfornewcandyconn:Disconnect() end

    ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("EndBlock")
    features.gotosafespot()
    task.spawn(function()
        wait(0.2)
        ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("EndBlock")
    end)
end

features.EventNotify = function()
    local workspacespawn

    if EventNotifyactive then
        local GameNotifyCooldown = false

        local function GameNotify(Message)
            local guitemplate = plr.PlayerGui.ClientGui.Mainframe.Notification.LongMessageTemplate:Clone()
            guitemplate.Name = "Radiant Event Notify"
            local guimessage = guitemplate:FindFirstChild("Message")

            guitemplate.Parent = plr.PlayerGui.ClientGui.Mainframe.Notification
            guimessage.TextColor3 = Color3.fromRGB(225, 225, 175)
            guimessage.Text = Message

            guimessage.TextTransparency = 0
            guitemplate.ImageTransparency = 0

            task.wait(4)

            guitemplate:Destroy()
            GameNotifyCooldown = false
        end

        local function GenerateMessage(object)
            local spawnlocations = {
                ["Permafrost Valley"]      = { Location = Vector3.new(-2984.0097, 12.5237, -2318.1809) },
                ["Sorythia"]               = { Location = Vector3.new(319.25, -22.1499, 64.5) },
                ["The Expanse"]            = { Location = Vector3.new(-273.3134, 27.3150, -1456.4433) },
                ["Windy Plains 1"]         = { Location = Vector3.new(-444.6890, -106.9384, -78.1904) },
                ["Permafrost Valley Gate"] = { Location = Vector3.new(-2938.8754, 45.9911, -3346.3627) },
                ["Artic Cove"]             = { Location = Vector3.new(-2369.5444, -141.2430, -2450.8283) },
                ["Fort Mello"]             = { Location = Vector3.new(-272.5840, 89.9466, -2252.1049) },
                ["Permafrost Valley Pit"]  = { Location = Vector3.new(-3693.1904, -11.8126, -2855.5026) },
                ["Chakra's Edge"]          = { Location = Vector3.new(2881.6650, -111.4496, -529.8105) },
                ["Durana Town"]            = { Location = Vector3.new(1689.4022, -130.8196, 963.8192) },
            }

            local nearestlocation = {Name = "", Magnitude = math.huge}

            if object.Name == "CorruptedPoint" then
                local innerPool = object:WaitForChild("InnerPool")
                for locationName, data in pairs(spawnlocations) do
                    local distance = (innerPool.Position - data.Location).Magnitude
                    if distance < nearestlocation.Magnitude then
                        nearestlocation.Name = locationName
                        nearestlocation.Magnitude = distance
                    end
                end
                return "A Corrupted Point spawned near " .. nearestlocation.Name

            else
                local npchrp = object:FindFirstChild("HumanoidRootPart")
                if not npchrp then 
                    return "An Event has started" 
                end

                for locationName, data in pairs(spawnlocations) do
                    local distance = (npchrp.Position - data.Location).Magnitude
                    if distance < nearestlocation.Magnitude then
                        nearestlocation.Name = locationName
                        nearestlocation.Magnitude = distance
                    end
                end
                return "An Event has started near " .. nearestlocation.Name
            end
        end

        workspacespawn = workspace.ChildAdded:Connect(function(obj)
            if obj.Name == "CorruptedPoint" then
                if ignorepoints then return end
                if GameNotifyCooldown then return end

                GameNotifyCooldown = true
                GameNotify(GenerateMessage(obj))

            else
                task.wait(1)
                if obj:FindFirstChild("WorldEvent") then
                    if obj:FindFirstChild("HumanoidRootPart") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "highlightevent"
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.OutlineColor = Color3.fromRGB(224, 57, 99)
                        highlight.FillColor = Color3.fromRGB(224, 57, 99)
                        highlight.FillTransparency = 0.7
                        highlight.Parent = obj
                    end

                    if GameNotifyCooldown then return end
                    GameNotifyCooldown = true
                    GameNotify(GenerateMessage(obj))
                end
            end
        end)
    else
        if workspacespawn then
            workspacespawn:Disconnect()
        end

        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "highlightevent" then
                v:Destroy()
            end
        end
    end
end

features.AutoParry = function()
    local RS = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Events = RS:WaitForChild("Events"):WaitForChild("DataFunction")

    local plr = Players.LocalPlayer
    local user = tostring(plr.UserId)
    local radius = 15
    local pingOffset = 0.1
    local globalParryCooldown = 0.25
    local lastParryTime = 0

    features._trackedCharacters = features._trackedCharacters or {}
    features._connections = features._connections or {}

    if autoparrying then

        local animationparrys = {
            ["rbxassetid://11330795390"] = {
                TimeLenghtDang = 0.47,
            },
        }

        local function triggerblock()
            local settingsplr = RS:WaitForChild("Settings"):FindFirstChild(user)
            local blockingValue = settingsplr:WaitForChild("Blocking")
            local canPerfectBlockValue = settingsplr:WaitForChild("canPerfectBlock")

            if settingsplr.MeleeCooldown.Value == false and settingsplr.Stunned.Value == false then
                Events:InvokeServer("Block")
                if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    plr.Character.Humanoid.WalkSpeed = 5
                end
            else
                return
            end

            while not blockingValue.Value do
                blockingValue.Changed:Wait()
            end

            while not canPerfectBlockValue.Value do
                canPerfectBlockValue.Changed:Wait()
            end

            while canPerfectBlockValue.Value do
                canPerfectBlockValue.Changed:Wait()
            end

            Events:InvokeServer("EndBlock")
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = 16
            end
        end

        local function trackCharacterAnimations(character)
            if features._trackedCharacters[character] then return end

            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end

            local connections = {}

            local function setupAnimator(animator)
                local animConn = animator.AnimationPlayed:Connect(function(track)
                    local animData = animationparrys[track.Animation.AnimationId]
                    if animData then
                        local triggered = false
                        local timeConn = track:GetPropertyChangedSignal("TimePosition"):Connect(function()
                            if not triggered and track.TimePosition >= animData.TimeLenghtDang - pingOffset then
                                if tick() - lastParryTime >= globalParryCooldown then
                                    triggered = true
                                    lastParryTime = tick()
                                    triggerblock()
                                end
                            end
                        end)

                        local stopConn = track.Stopped:Connect(function()
                            if timeConn then timeConn:Disconnect() end
                        end)

                        table.insert(connections, timeConn)
                        table.insert(connections, stopConn)
                    end
                end)

                table.insert(connections, animConn)
            end

            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                setupAnimator(animator)
            else
                local animatorConn = humanoid.ChildAdded:Connect(function(child)
                    if child:IsA("Animator") then
                        setupAnimator(child)
                    end
                end)
                table.insert(connections, animatorConn)
            end

            features._trackedCharacters[character] = {
                Connections = connections
            }
        end

        local function untrackCharacter(character)
            local info = features._trackedCharacters[character]
            if info then
                for _, conn in ipairs(info.Connections) do
                    if conn then conn:Disconnect() end
                end
                features._trackedCharacters[character] = nil
            end
        end

        local heartbeatConn = RunService.Heartbeat:Connect(function()
            if not autoparrying then return end

            local char = plr.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            local myPos = char.HumanoidRootPart.Position
            local currentlyInRadius = {}

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = player.Character.HumanoidRootPart.Position
                    local distance = (myPos - targetPos).Magnitude

                    if distance <= radius then
                        currentlyInRadius[player.Character] = true
                        trackCharacterAnimations(player.Character)
                    end
                end
            end

            for character in pairs(features._trackedCharacters) do
                if not currentlyInRadius[character] then
                    untrackCharacter(character)
                end
            end
        end)

        table.insert(features._connections, heartbeatConn)


    else

        for char, info in pairs(features._trackedCharacters) do
            for _, conn in ipairs(info.Connections or {}) do
                if conn then conn:Disconnect() end
            end
        end

        for _, conn in ipairs(features._connections) do
            if conn then conn:Disconnect() end
        end

        features._trackedCharacters = {}
        features._connections = {}

    end
end

features.Loopwipe = function()
    if not loopwiping.Value then 
        if plr.PlayerGui:FindFirstChild("NameDisplayUI") then
            plr.PlayerGui:FindFirstChild("NameDisplayUI").Enabled = false
        end

        local gui = plr:FindFirstChild("PlayerGui")
        if gui then
            local clientGui = gui:FindFirstChild("ClientGui")
            if clientGui then
                clientGui.Enabled = true
            end
        end

        local camera = workspace.CurrentCamera
        if camera then
            camera.CameraType = Enum.CameraType.Custom
            if plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    camera.CFrame = CFrame.new(hrp.Position, hrp.Position)
                end
            end
        end

        if wiperemoveloop then
            wiperemoveloop:Disconnect()
            wiperemoveloop = nil
        end

        return 
    end
    
    if Gender == nil then
        Notify("Incorrect Set Up.", "Select a Gender.", 2.5, "info")
        return
    end

    local RSLoaded = RS.Loaded:FindFirstChild(user)
    
    local function removeguiandfixcam()
        plr.PlayerGui:WaitForChild("ClientGui").Enabled = false
        local character = plr.Character or plr.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Scriptable
        local frontOffset = Vector3.new(0, 3, -5)
        wait(0.2)
        plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,20,0)
        for i = 1, 6 do
            wait(0.5)
            camera.CFrame = CFrame.new(hrp.Position + frontOffset, hrp.Position)
        end
        plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,20,0)
    end

    if not RSLoaded then
        if plr.PlayerGui:FindFirstChild("NameDisplayUI") then
            plr.PlayerGui:FindFirstChild("NameDisplayUI").Enabled = true
            plr.PlayerGui:FindFirstChild("NameDisplayUI"):FindFirstChild("BossFrame"):FindFirstChild("BossTitle").Text = "Current Name: "
        else
            local NameGui = plr.PlayerGui.BossNotifierUI:Clone()
            NameGui.Name = "NameDisplayUI"
            NameGui.Parent = plr.PlayerGui
            local NameFrame = NameGui:FindFirstChild("BossFrame")
            local NameText = NameFrame:FindFirstChild("BossTitle")

            NameFrame:FindFirstChild("BossHPLabel"):Destroy()

            NameFrame.AnchorPoint = Vector2.new(0.5, 1) 
            NameFrame.Position = UDim2.new(0.5, 0, 0.875, 0)

            NameText.TextColor3 = Color3.fromRGB(255, 188, 52)
            NameText.Text = "Current Name: "
            NameFrame.Visible = true
            NameGui.Enabled = true
        end

        wiperemoveloop = plr.PlayerGui.ChildAdded:Connect(function(addedgui)
            if  addedgui.Name == "ClientGui" then
                removeguiandfixcam()
            end
        end)
    end

    local function lookforcolor()
        local character = plr.Character
        if not character then return end
        for _, v in ipairs(character:GetChildren()) do
            if v.Name:sub(1, 4) == "Hair" then
                for _, color in pairs(selectedhaircolors) do
                    if tostring(v.BrickColor) == color then
                        gotcolor = true
                        return
                    end
                end
            end
        end
    end

    local function getFirstRealName(name)
        local ignore = {["chief"]=true, ["king"]=true, ["queen"]=true} 
        local words = {}

        if type(name) ~= "string" then
            return ""
        end

        for word in name:gmatch("%a+") do
            table.insert(words, word)
        end

        for _, w in ipairs(words) do
            if not ignore[w:lower()] then
                return w 
            end
        end

        return words[1] or ""
    end



    local function lookforname()
        local character = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local currentname = humanoid.DisplayName or ""
        local trimmedname = currentname:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")

        local pickedName = getFirstRealName(trimmedname)

        if not RSLoaded and pickedName ~= "" then
            local nameUI = plr.PlayerGui:FindFirstChild("NameDisplayUI")
            if nameUI then
                local bossFrame = nameUI:FindFirstChild("BossFrame")
                if bossFrame then
                    local bossTitle = bossFrame:FindFirstChild("BossTitle")
                    if bossTitle then
                        bossTitle.Text = "Current Name: " .. pickedName
                    end
                end
            end
        end

        if pickedName ~= "" then
            local lowerPicked = pickedName:lower()
            for _, name in pairs(selectednames) do
                if lowerPicked == name:lower() then
                    gotname = true
                    break
                end
            end
        end
    end

    while loopwiping.Value do
        task.wait()

        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("NewGame")
        task.wait(0.16)
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("RequestReincarnation", tostring(Gender))
        task.wait(0.3)

        lookforcolor()
        lookforname()

        if twodesires then
            if gotname and gotcolor then
                Notify("Wipe Finished", "Found matching Character.", 2, "info")
                loopwiping.Value = false
            end
        else
            if gotname then
                Notify("Wipe Finished", "Found matching Name.", 2, "info")
                loopwiping.Value = false
            elseif gotcolor then
                Notify("Wipe Finished", "Found matching Color.", 2, "info")
                loopwiping.Value = false
            end
        end

        gotname = false
        gotcolor = false
    end

    if wiperemoveloop then
        wiperemoveloop:Disconnect()
    end
end

features.Autopick = function()
    if autopickupenabled then
        
        local function pickupLoop()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local parts = workspace:GetPartBoundsInBox(
                hrp.CFrame,
                Vector3.new(50,50,50),
                params
            )

            for _, v in ipairs(parts) do
                local distance = (v.Position - hrp.Position).Magnitude
                if distance > 25 then
                    continue
                end

                if v:FindFirstChild("SpawnTime") and v:FindFirstChild("ItemDetector") then
                    fireclickdetector(v.ItemDetector)
                elseif v:FindFirstChild("Pickupable") and v:FindFirstChild("ID",true) then
                    if not v:FindFirstChild("ItemDetector") and distance > 15 then
                        continue
                    end
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("PickUp", v:FindFirstChild("ID",true).Value)
                end
            end
        end

        autopickup_connection = RunService.Heartbeat:Connect(pickupLoop)

    else
        if autopickup_connection then
            autopickup_connection:Disconnect()
            autopickup_connection = nil
        end
    end
end

features.Chakranotifi = function()
    if chakraguithere then
		CSNotifier_Enabled = false
        
        for i, v in pairs(folder:getDescendants()) do
            if v.Name == "Chakra Sense" then
                local sensePlayer = game.Players:FindFirstChild(v.Parent.Name)
                local sensePlayerCharacter = sensePlayer.Character
                local sensePlayerHumanoid = sensePlayerCharacter:FindFirstChildOfClass("Humanoid")

                local ingamename = sensePlayerHumanoid.DisplayName

                Notify(v.Parent.Name.." has chakra sense.","Ingame Name: "..ingamename,2.5,"eye")
            end
        end

	else
		CSNotifier_Enabled = true
	end
end

features.Disabledvoid = function()
    if voiddisabled then
        for i, v in pairs(game.workspace:GetDescendants()) do
            if v.Name == "LavarossaVoid" or v.Name == "Void" then
                if v:IsA("BasePart") then
                    if v.CanTouch then
                        v.CanTouch = false
                    end
                end
            end
        end
    else
        for i, v in pairs(game.workspace:GetDescendants()) do
            if v.Name == "LavarossaVoid" or v.Name == "Void" then
                if v:IsA("BasePart") then
                    if not v.CanTouch then
                        v.CanTouch = true
                    end
                end
            end
        end
    end
end

features.Disableblind = function()
    local RSLoaded = RS.Loaded:FindFirstChild(user)

    if not RSLoaded and plr.PlayerGui then
        repeat
            wait()
        until RS.Loaded:FindFirstChild(user) and plr:FindFirstChild("PlayerGui")
    end

    wait(1)

    if blindremoved == true then
        local function removeblind()
            for i, v in pairs(plr.PlayerGui.ClientGui:getChildren()) do
                if v.Name == "Blindness1" then
                    v.Visible = false
                end
                if v.Name == "Blindness2" then
                    v.Visible = false
                end
            end
        end
        removeloop = plr.PlayerGui.ChildRemoved:Connect(function(removed)
            if removed.Name == "ClientGui" then
                plr.PlayerGui:WaitForChild("ClientGui")
                plr.PlayerGui.ClientGui:WaitForChild("Mainframe")
                wait(1)
                removeblind()
            end
        end)
        removeblind()
    else
        if removeloop then
            removeloop:Disconnect()
        end

        for i, v in pairs(plr.PlayerGui.ClientGui:getChildren()) do
            if v.Name == "Blindness1" then
                v.Visible = true
            end
            if v.Name == "Blindness2" then
                v.Visible = true
            end
        end
    end
end

features.Nostun = function()
    if disabledstun then
        nostunloop = RunService.Heartbeat:Connect(function()
            local stunsetting = RS:WaitForChild("Settings"):FindFirstChild(user).Stunned
            stunsetting.Value = true
            stunsetting.Value = false
        end)
    else
        if nostunloop then
            nostunloop:Disconnect()
        end
    end
end

features.PurchaseItem = function()
    if itemtopurchase then
        local quantity = (purchasenumber and purchasenumber > 1) and purchasenumber or 1
        local args = {
            [1] = "Pay",
            [2] = 0,
            [3] = itemtopurchase,
            [4] = quantity,
            [5] = workspace:WaitForChild("TorchMesh")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
    else
        Notify("Missing Item Name", "", 1.5, "info")
    end
end

features.PickUpClickDetectors = function()
    for i, v in pairs(game.workspace:GetDescendants()) do
        if v:IsA("ClickDetector") then
            if v.Parent.Name ~= "Sealing Bells" and v.Parent.Name ~= "Training Bells" and v.Parent.Name ~= "Mission" and v.Parent.Name ~= "Wedge" and v.Parent.Name ~= "Seaweed" and v.Parent.Name ~= "Gloweed" then
                if Teleport(v.Parent.CFrame) == true then return end
            end
        end
    end
end

features.AutoDevilsDeal = function()
    if Devilactive.Value then
        features.HandleNotLoadedIn()

        local playerdata = game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("DataFunction")
                :InvokeServer("GetData")
        
        local metreqs = false

        for i,v in pairs(playerdata["Traits"]) do
            if v == "A Devil's Deal" then
                metreqs = true
            end
        end

        if metreqs == false then
            Notify("Missing requirements..","You need to have Devil's Deal Trait", 2.5,"info")
            return
        end

        local function waitforcarry()
            local character = plr.Character or plr.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            hrp.CFrame = CFrame.new(-2974.29443, 326.182709, 646.613159, -0.99941802, -2.79689978e-08, 0.0341118388, -2.78877685e-08, 1, 2.85709167e-09, -0.0341118388, 1.90412597e-09, -0.99941802)
            wait(0.5)
            settingsfolder = game:GetService("ReplicatedStorage").Settings:WaitForChild(user)

            if hrp then
                wait(0.2)
                while wait() do
                    if Devilactive.Value == false then return end
                    hrp.CFrame = CFrame.new(-2974.29443, 326.182709, 646.613159, -0.99941802, -2.79689978e-08, 0.0341118388, -2.78877685e-08, 1, 2.85709167e-09, -0.0341118388, 1.90412597e-09, -0.99941802)
                    local args = {"Carry"}
                    RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    wait(0.1)
                    if settingsfolder:FindFirstChild("Carrying") then
                        if settingsfolder:FindFirstChild("Carrying").Value ~= nil then
                            break
                        end
                    end
                end
            end
        end
        
        local function whitevoidincombat()
            if Devilactive.Value == false then return end

            local character = plr.Character or plr.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)

            local args = {"InflictFire"}
            RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
        
            repeat
                wait()
            until settingsfolder:FindFirstChild("RecentDamage").Value == 2.5

            local character = plr.Character or plr.CharacterAdded:Wait()
            hrp = character:WaitForChild("HumanoidRootPart", 2)
    
            if hrp then
                hrp.CFrame = CFrame.new(0, -698, 0)
            end
        end
        
        waitforcarry()
        whitevoidincombat()
        
        devilloop = plr.CharacterAdded:Connect(function(character)
            wait(0.5)
            waitforcarry()
            whitevoidincombat()
        end)

    else
        if devilloop then
            devilloop:Disconnect()
        end
    end
end

features.JoinNotification = function()
    if joinnotienabled then
        loopingjoin = game.Players.PlayerAdded:Connect(function(plr)
            Notify("A Player has joined.", plr.Name .. " has joined", 2, "info")
        end)
    else
        if loopingjoin then
            loopingjoin:Disconnect()
            loopingjoin = nil
        end
    end
end

features.AgileTrait = function()
    if agiletraitenabled then
        local function applyModifier(chr)
            local hrp = chr:WaitForChild("HumanoidRootPart")

            buffingdash = hrp.ChildAdded:Connect(function(origBV)
                if origBV.Name == "DashBV" and origBV:IsA("BodyPosition") then
                    print("Original DashBV detected, creating modified copy.")

                    -- Clone the original to preserve all properties
                    local modBV = origBV:Clone()
                    modBV.Name = "DashBV_Agile"

                    -- Apply multiplier
                    local SpeedDiff = 1.5
                    modBV.P = origBV.P * SpeedDiff
                    modBV.MaxForce = origBV.MaxForce * SpeedDiff
                    local dir = (origBV.Position - hrp.Position).Unit
                    local dist = (origBV.Position - hrp.Position).Magnitude
                    modBV.Position = hrp.Position + dir * (dist * SpeedDiff)

                    modBV.Parent = hrp

                    -- Disable original AFTER clone is active
                    origBV.MaxForce = Vector3.new(0,0,0)
                    origBV.P = 0

                    -- Remove copy when original is removed
                    local conn
                    conn = origBV.AncestryChanged:Connect(function(_, parent)
                        if not parent then
                            if modBV then
                                modBV:Destroy()
                                modBV = nil
                                print("Original DashBV removed, copy deleted.")
                            end
                            conn:Disconnect()
                        end
                    end)
                end
            end)
        end

        waitingforrespawn = plr.CharacterAdded:Connect(function(character)
            applyModifier(character)
        end)

        if plr.Character then
            applyModifier(plr.Character)
        end
    else
        -- Disable effect
        if waitingforrespawn then
            waitingforrespawn:Disconnect()
            waitingforrespawn = nil
        end
        if buffingdash then
            buffingdash:Disconnect()
            buffingdash = nil
        end
        print("AgileTrait disabled")
    end
end


features.ShowSkillTree = function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local gui = player:WaitForChild("PlayerGui"):WaitForChild("ClientGui").Mainframe.Rest
    local skillView = gui:WaitForChild("SkillView")
    local changeddescription = false

    local skillsFrame = gui:FindFirstChild("SkillsFrame")
    local buyButton = skillView:FindFirstChild("Unlock")
    local skillDesc = skillView:FindFirstChild("Back")
    local headerBack = skillView:FindFirstChild("HeaderBack")
    local header = headerBack and headerBack:FindFirstChild("Header")

    local gameManager = require(game.ReplicatedStorage:WaitForChild("GameManager"))
    local allSkills = gameManager.Skills
    local settings = gameManager:getSettings(character)
    local unlockedSkills = settings and settings:FindFirstChild("UnlockedSkills")

    if not skillsFrame then warn("SkillsFrame not found!") end
    if not buyButton then warn("Unlock button not found!") end
    if not skillDesc then warn("UnlockMsg not found!") end
    if not header then warn("Header label not found!") end

    local buyConn

    local function hasSkill(skillName)
        return gameManager:hasSkill(settings, skillName)
    end

    if skillDesc and skillDesc.Description then
        clickedbuttoncon = skillDesc.Description.Changed:Connect(function(property)
            if property == "Text" then
                changeddescription = true
            end
        end)
    end

    for skillName, skillInfo in pairs(allSkills) do
        if skillInfo.GUIName and skillInfo.GUIName ~= "" then
            local button = skillsFrame and skillsFrame:FindFirstChild(skillInfo.GUIName)
            if not button then
            else
                button.Visible = true
                button.SlotText.Text = skillName

                if skillInfo.ID and skillInfo.ID ~= "" then
                    button.Image = "rbxassetid://" .. skillInfo.ID
                    button.SlotText.TextTransparency = 1
                else
                    button.SlotText.TextTransparency = 0
                end

                button.SlotBorder.Image = "rbxassetid://" .. gameManager.UI.StandardBorder

                -- On click
                button.MouseButton1Click:Connect(function()
                    local function removeinfo()
                        if skillDesc then
                            local costText = "--"
                            skillDesc.Description.Text = costText
                            skillDesc.Required1.Text = ""
                            skillDesc.Required2.Text = ""
                            skillDesc.Required3.Text = ""
                            skillDesc.Required1Image.Image = ""
                            skillDesc.Required2Image.Image = ""
                            skillDesc.Required3Image.Image = ""
                        end
                    end

                    if header then
                        header.Text = skillName
                    end

                    if buyButton then

                        skillView.Visible = true
                        buyButton.Visible = true
                        skillDesc.Visible = true
                        headerBack.Visible = true

                        buyConn = buyButton.MouseButton1Click:Connect(function()
                            game.ReplicatedStorage.Events.DataEvent:FireServer("buySkill", skillName)
                        end)

                        wait(0.2)
                        if changeddescription == true then
                            changeddescription = false
                        else
                            removeinfo()
                        end
                    end
                end)
            end
        end
    end
end

features.Buffchakraregen = function()
    if buffingchakra then
        local function buffchakra()

            local cooldown = false
            local chakra = plr.Backpack:FindFirstChild("chakra")
            local startval = chakra.Value
            
            buffing = chakra.Changed:Connect(function(newval)
                if newval > startval then
                    
                    if cooldown == true then
                        return
                    end
                    
                    cooldown = true
                    
                    local newchakra = chakra.Value + chakrabuffamount
                
                    if newchakra < plr.Backpack.maxChakra.Value then
                        local args = {
                            [1] = "TakeChakra",
                            [2] = chakrabuffamount * -1
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        chakra.Value = chakra.Value + chakrabuffamount
                    end

                    startval = newval

                    wait(0.9)
                    cooldown = false

                elseif startval > newval then
                    startval = newval
                end
            end)
        end

        buffchakra()

        respawning = plr.CharacterAdded:Connect(function()
            buffing:Disconnect()
            wait(1.3)
            buffchakra()
        end)
    else
        if buffing then
            buffing:Disconnect()
        end
        if respawning then
            respawning:Disconnect()
        end
    end
end

features.SearchObj = function()
    if searchingforobj then
        wait(0.2)
        if selectedsearchobject ~= nil then
            if workspace:FindFirstChild(selectedsearchobject) then
                searchingforobj = false
                Notify(selectedsearchobject.. " has been found!", "Server Hopping stopped",3,"info")
                features.CheckNotiAndSend("Object/NPC found", "Object/NPC has been found: "..tostring(selectedsearchobject))
                return
            else
                Notify("Object/NPC not found", "Starting Server Hop..", 2, "info")

                if shopdelay ~= nil then
                    wait(shopdelay)
                end

                features.TeleportRandomServer()
                return
            end
        end
    end
end

features.GiveGripsFrags = function()
    if GiveKnock.Value then
        features.HandleNotLoadedIn()
        while GiveKnock.Value do
            local character = plr.Character or plr.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 2)
        
            if hrp then
                hrp.CFrame = CFrame.new(-2974.29443, 326.182709, 646.613159, -0.99941802, -2.79689978e-08, 0.0341118388, -2.78877685e-08, 1, 2.85709167e-09, -0.0341118388, 1.90412597e-09, -0.99941802)
        
                local args = {
                    [1] = "TakeDamage",
                    [2] = 10000,
                    [3] = "yes"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            end
            wait()
        end        
    end
end

features.InstantVoid = function()
    if not (plr.Character and TargetPlayer and TargetPlayer.Character) then return end

    local function hasChakraZone()
        for _, v in pairs(plr.PlayerGui.ClientGui.Mainframe.Loadout:GetDescendants()) do
            if v.Name == "SlotText" and v.Text == "Chakra Zone" then return true end
        end
        return false
    end

    if not hasChakraZone() then
        Notify("Missing requirements..", "You need to have Chakra Zone", 2.5, "info")
        return
    end

    local childFound = plr.Character:FindFirstChild("SasukeSusanoo") or plr.Character:FindFirstChild("SasukeArmouredSusanoo")

    if not childFound then
        RS.Events.DataEvent:FireServer("startSkill","Purple Susanoo Summon",Vector3.new(-727.0325927734375,-192,-457.90167236328125),true)
        RS.Events.DataEvent:FireServer("startSkill","Purple Armoured Susanoo Summon",Vector3.new(-727.0325927734375,-192,-457.90167236328125),true)
        
        local done = false
        local function onChildAdded(newChild)
            if newChild.Name=="SasukeSusanoo" or newChild.Name=="SasukeArmouredSusanoo" then
                childFound=newChild
                done=true
            end
        end
        local connection = plr.Character.ChildAdded:Connect(onChildAdded)
        task.delay(2,function() done=true end)
        while not done do task.wait() end
        connection:Disconnect()
    end

    if not childFound then
        Notify("Missing requirements..", "Missing Susanoo", 2.5, "info")
        return
    end

    local function unsummon(susanoo)
        if susanoo and susanoo.Parent then
            local skill = susanoo.Name == "SasukeSusanoo" and "Purple Susanoo Summon" or "Purple Armoured Susanoo Summon"
            local currentSkill = settingsfolder:WaitForChild("CurrentSkill")

            local startTime = tick()
            while currentSkill.Value ~= "" and tick() - startTime < 2 do
                task.wait(0.05)
            end

            RS.Events.DataEvent:FireServer("startSkill", skill, Vector3.new(-727.0325927734375,-192,-457.90167236328125), true)
        end
    end

    local hrp = plr.Character:WaitForChild("HumanoidRootPart")
    local startCF = hrp.CFrame
    local voidCF = CFrame.new(1144.74707,-270,-946.274597,0.0208230875,0,-0.999783158,0,1,0,0.999783158,0,-0.0208230875)

    for _,v in pairs(workspace:GetDescendants()) do
        if (v.Name=="LavarossaVoid" or v.Name=="Void") and v:IsA("BasePart") then v.CanTouch=false end
    end

    local noclip = true
    local noclipConn
    noclipConn = RunService.Heartbeat:Connect(function()
        if plr.Character and noclip then
            for _,v in pairs(plr.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide=false end
            end
        else noclipConn:Disconnect() end
    end)

    task.wait(0.1)
    hrp.CFrame = voidCF
    
    local settingsfolder = RS.Settings:FindFirstChild(user) or RS.Settings:WaitForChild(user)

    if settingsfolder:FindFirstChild("CurrentSkill").Value ~= "" then
        local currentSkill = settingsfolder:WaitForChild("CurrentSkill")
        local startTime = tick()

        while currentSkill.Value ~= "" and tick() - startTime < 2 do
            task.wait(0.05)
        end
    end

    RS.Events.DataEvent:FireServer("startSkill","Chakra Zone",Vector3.new(-684,-206.094,-512.374),true)
    RS.Events.DataEvent:FireServer("ReleaseSkill")

    local chakraZone = workspace:WaitForChild("ChakraZone"..plr.Name,2.5)
    if not chakraZone then
        noclip=false
        hrp.CFrame=startCF
        unsummon(childFound)
        return
    end

    RS.Events.DataEvent:FireServer("DeactivateSkill")
    task.wait(0.05)
    RS.Events.DataEvent:FireServer("startSkill","Purple Susanoo Grab",Vector3.new(-703.598,-209.78,-572),true)
    RS.Events.DataEvent:FireServer("ReleaseSkill")

    local targetHRP = TargetPlayer.Character:WaitForChild("HumanoidRootPart")
    local offset = CFrame.new(-10.5,0,11)
    local grabbed, timeout = false, false

    local grabConn
    grabConn = RunService.Heartbeat:Connect(function()
        if targetHRP and hrp and hrp.Parent and not grabbed and not timeout then
            hrp.CFrame=targetHRP.CFrame*offset
            if targetHRP:FindFirstChild("HasMass") then grabbed=true end
        else grabConn:Disconnect() end
    end)

    task.delay(1,function() if not grabbed then timeout=true end end)
    while not grabbed and not timeout do task.wait() end
    if grabConn then grabConn:Disconnect() end

    if grabbed then
        local tiltConn
        tiltConn = RunService.Heartbeat:Connect(function()
            if hrp and hrp.Parent and targetHRP:FindFirstChild("HasMass") then
                hrp.CFrame=voidCF*CFrame.new(0,-8.2,0)*CFrame.Angles(math.rad(160),0,0)
            end
        end)
        while targetHRP:FindFirstChild("HasMass") do task.wait() end
        if tiltConn then tiltConn:Disconnect() end
    end

    noclip=false
    hrp.CFrame=startCF
    unsummon(childFound)
end

features.TPChakraFruit = function()
    for i, v in pairs(workspace:GetChildren()) do
        if v.Name == "Chakra Fruit" then
            Teleport(v.CFrame)
            return
        end
    end
    for i, v in pairs(RS:GetChildren()) do
        if v.Name == "Chakra Fruit" then
            if table.find(teleportedfruitIDs, v.ID.Value) then
                continue
            else
                if Teleport(v.CFrame) == false then continue end
                table.insert(teleportedfruitIDs,v.ID.Value)
                return
            end
        end
    end
    Notify("No Chakra Fruit found.","",1.5,"info")
end

features.TPFruit = function()
    for i, v in pairs(workspace:GetChildren()) do
        if v.Name == "Life Up Fruit" or v.Name == "Fruit Of Forgetfulness" then
            Teleport(v.CFrame)
            return
        end
    end
    for i, v in pairs(RS:GetChildren()) do
        if v.Name == "Life Up Fruit" or v.Name == "Fruit Of Forgetfulness" then
            if table.find(teleportedfruitIDs, v.ID.Value) then
                continue
            else
                if Teleport(v.CFrame) == false then continue end
                table.insert(teleportedfruitIDs,v.ID.Value)
                return
            end
        end
    end
    Notify("No LF/FOF Found.","",1.5,"info")
end

features.FarmGrips = function()
    if farminggrips.Value == false then return end
    features.HandleNotLoadedIn()

    if features.gotosafespot(true,false) == false then
        return
    end

    local function updateGrips(action)
        if action == "enable" then
            MainUI.Enabled = true
        elseif action == "grips" then
            local playerdata = game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("DataFunction")
                :InvokeServer("GetData")
            local gripamount = playerdata["Grips"] or 0
            GripLabel.Text = "[Radiant Hub] \n Grips: "..gripamount
        elseif action == "disable" then
            MainUI.Enabled = false
        end
    end

    if farminggrips.Value then
        updateGrips("enable")
        while farminggrips.Value do
            local userSettings = RS:WaitForChild("Settings"):FindFirstChild(user)
            if userSettings and userSettings:FindFirstChild("Gripping").Value == "None" then
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    features.gotosafespot()
                    local args = {"Grip"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    wait(0.2)
                    updateGrips("grips")
                end
            else
                updateGrips("grips")
                wait()
            end
            wait()
        end
        updateGrips("disable")
    else
        updateGrips("disable")
        wait(0.2)
        updateGrips("disable")
    end
end

features.GiveGrips = function()
    if not givegrip.Value then return end
    features.HandleNotLoadedIn()

    if features.gotosafespot(true,false) == false then
        return
    end

    local function updateGrips(action)
        if action == "enable" then
            MainUI.Enabled = true
        elseif action == "grips" then
            GripLabel.Text = "[Radiant Hub] \n Giving Grips"
        elseif action == "disable" then
            MainUI.Enabled = false
        end
    end

    if givegrip.Value then
        updateGrips("enable")
        updateGrips("grips")

        while givegrip.Value do
            local character = plr.Character or plr.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 2)
            
            if hrp and givegrip.Value then

                local playerdata = game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("DataFunction")
                :InvokeServer("GetData")

                if playerdata["Village"] ~= "Rogue" then
                    game:GetService("ReplicatedStorage").Events.DataFunction:InvokeServer("JoinVillage", "Rogue")
                end

                if playerdata["LifeForce"] == 0 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("NewGame")
                    task.wait(0.16)
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("RequestReincarnation", "Male")
                end

                features.gotosafespot()
                
                local args = {
                    [1] = "TakeDamage",
                    [2] = 10000,
                    [3] = "yes"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            end
            wait()
        end
        updateGrips("disable")  
    else
        updateGrips("disable")
        wait(0.2)
        updateGrips("disable")
    end
end

features.TPPoints = function()
    local CFrame = nil
    for i, v in pairs(game.workspace.ChakraPoints:GetDescendants()) do
        if v.Name == "Unlocked" then
            if v.Value == false then
                if v.Parent.Main.Transparency == 0 then
                    TPing = true
                    CFrame = v.Parent.Main.CFrame 
                    if Teleport(CFrame) == false then 
                        continue 
                    else
                        break
                    end
                end
            end
        end
    end
end

features.TPPumpkinPoints = function()
    for i, v in pairs(game.workspace:GetChildren()) do
        if v.Name == "PumpkinPoint" then
            if v:FindFirstChild("Destroyed").Value == false then
                if Teleport((v:FindFirstChild("Main").CFrame * CFrame.new(0,6,0))) == false then 
                    continue 
                else
                    return
                end
            end
        end
    end
    Notify("Try again later", "No Pumpkin Point detected.",2.5,"info")
end

features.TPHallowedPortal = function()
    for i, v in pairs(workspace.Debris:GetChildren()) do
        if v.Name == "Infernal Sasuke Portal" then
            if Teleport(workspace.Debris:FindFirstChild("Infernal Sasuke Portal").CFrame) == false then
                continue
            else
                return
            end
        end
    end
    Notify("Try again later", "No Hallowed Portal detected.",2.5,"info")
end

features.TPCandy = function()
    for i, v in pairs(game.workspace:GetChildren()) do
        if v.Name == "Candy" then
            if Teleport(v.CFrame) == false then 
                continue 
            else
                return
            end
        end
    end
    Notify("Try again later", "No Candy detected.",2.5,"info")
end

features.RyoFarm = function()
	if not Ryofarming.Value then return end
    features.HandleNotLoadedIn()
	local char = plr.Character or plr.CharacterAdded:Wait()
	local RunService = game:GetService("RunService")
    local isWatering = false

	local function checkforcrops()
		for _, v in ipairs(workspace:GetChildren()) do
			if v.Name == "Crops" then
				return true
			end
		end
		return false
	end

    
	task.spawn(function()
		while Ryofarming.Value do
			local orangethere, bowlthere = false, false

			for _, v in pairs(plr.PlayerGui.ClientGui.Mainframe.Loadout:GetDescendants()) do
				if v.Name == "SlotText" and v.Text == "Orange" then
					local numStr = v.Parent.ItemNumber.Number.Text
					local num = tonumber(string.sub(numStr, 2))
					if num and num > 2 then
						orangethere = true
						break
					end
				end
			end

			for _, v in pairs(plr.PlayerGui.ClientGui.Mainframe.Loadout:GetDescendants()) do
				if v.Name == "SlotText" and v.Text == "Bowl" then
					bowlthere = true
				end
			end

			wait()

			if not orangethere then
				game.ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", "Tangerina Fruit Bowl")
				game.ReplicatedStorage.Events.DataFunction:InvokeServer("SellFood", "Tangerina Fruit Bowl", 15)
			else
				if not bowlthere then
					if checkforcrops() then
                        for i, v in pairs(workspace:GetChildren()) do
                            if v.Name == "Crops" and v.Transparency == 0 then
                                isWatering = true
                                watercrops(v,100)
                                wait(0.2)
                                isWatering = false
                                break
                            end
                        end
					else
						game.ReplicatedStorage.Events.DataFunction:InvokeServer("Pay", nil, "Bowl", 1)
					end
				end

				local BowlHolder = workspace:WaitForChild("BowlHolderHallow")
				game.ReplicatedStorage.Events.DataEvent:FireServer("PlaceBowl", BowlHolder)
				game.ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", "Tangerina Fruit Bowl")

				local Cooker = workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater")
				for _ = 1, 3 do
					wait(0.1)
					game.ReplicatedStorage.Events.DataEvent:FireServer("AddFruit", Cooker, "Orange")
				end

				game.ReplicatedStorage.Events.DataFunction:InvokeServer("SellFood", "Tangerina Fruit Bowl", 15)
				wait(0.1)
				game.ReplicatedStorage.Events.DataEvent:FireServer("BowlFinish", BowlHolder:WaitForChild("BowlFinish"))
			end
		end
	end)

	-- Check for crops once
	if not checkforcrops() then
		local ryoAmount = tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text)
		if ryoAmount and ryoAmount < 3 then
			spawn(function()
				wait(13)
				for _ = 1, 2 do
					game.ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", "Orange")
					game.ReplicatedStorage.Events.DataFunction:InvokeServer("SellFood", "Orange", 2)
					wait(0.2)
				end
			end)
		end
	end

	local spawned = false
	local pickuptable = {}

	NoFallDammage.Value = true

	waiting = workspace.ChildAdded:Connect(function(newchild)
		if newchild:FindFirstChild("ID") then
			spawned = true
			if newchild.Name == "Orange" then
				table.insert(pickuptable, newchild)
			end
		end
	end)

	local function nocliploop()
		for _, v in pairs(plr.Character:GetChildren()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end

	noclippinghop = RunService.Stepped:Connect(nocliploop)

	task.spawn(function()
        while Ryofarming.Value do
            task.wait()

            for _, v in pairs(workspace:GetDescendants()) do
                if not Ryofarming.Value then break end

                -- Wait here until watering is done
                if isWatering then
                    while isWatering do
                        if not Ryofarming.Value then break end
                        wait()
                    end
                end

                if not Ryofarming.Value then break end

                if v.Name == "FruitType" and v.Value == "Orange" and not v:GetAttribute("orange") then
                    char.HumanoidRootPart.CFrame = v.Parent:FindFirstChild("MainBranch").CFrame

                    local timeout = os.clock() + 12
                    while os.clock() < timeout and not spawned do
                        if not Ryofarming.Value then break end
                        wait()
                    end

                    if not spawned then
                        -- Just wait and retry next iteration
                        wait()
                    else
                        if #pickuptable > 0 then
                            local bv = Instance.new("BodyVelocity")
                            bv.Velocity = Vector3.new(0, 0, 0)
                            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                            bv.Parent = char:FindFirstChild("HumanoidRootPart")

                            for _, fruit in ipairs(pickuptable) do
                                if not Ryofarming.Value then break end
                                if fruit:FindFirstChild("ID") then
                                    char.HumanoidRootPart.CFrame = fruit.CFrame * CFrame.new(0, -6, 0)
                                    while fruit and fruit:IsDescendantOf(workspace) do
                                        if not Ryofarming.Value then break end
                                        game.ReplicatedStorage.Events.DataEvent:FireServer("PickUp", fruit.ID.Value)
                                        wait()
                                    end
                                end
                            end

                            table.clear(pickuptable)
                            bv:Destroy()
                            wait()
                            v:SetAttribute("orange", true)
                            spawned = false
                        end

                        -- RYO check
                        if desiredRyoamount and type(desiredRyoamount) == "number" then
                            local currentRyo = tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text)
                            if currentRyo and currentRyo >= desiredRyoamount then
                                Ryofarming.Value = false
                                Notify("Farming complete.", "You reached the Ryo Amount.", 2.5, "info")
                            end
                        end
                    end
                end
            end

            for _, v in pairs(workspace:GetDescendants()) do
                if not Ryofarming.Value then break end
                if v.Name == "FruitType" and v.Value == "Orange" and v:GetAttribute("orange") then
                    v:SetAttribute("orange", false)
                end
            end
        end

        if noclippinghop then noclippinghop:Disconnect() end
        if waiting then waiting:Disconnect() end
        NoFallDammage.Value = false
    end)
end

local toolbarnamechange
local cornernamechange
local removenameloop

features.HideName = function()

    local function removename()
        if not plr or not plr.Parent then return end
        local pg = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui", 10)
        if not pg then return end

        local clientgui = pg:FindFirstChild("ClientGui")
        local topbar = pg:FindFirstChild("TopbarStandard")
        if not clientgui or not topbar then return end
        if not clientgui:FindFirstChild("Mainframe") then return end
        if not clientgui.Mainframe:FindFirstChild("Loadout") then return end
        if not clientgui.Mainframe.Loadout:FindFirstChild("HUD") then return end

        local nametoolbar = clientgui.Mainframe.Loadout.HUD:FindFirstChild("PlayerName")
        if not nametoolbar then return end

        local top = topbar.Holders
        if not top or not top.Left or not top.Left.Widget then return end
        local btn = top.Left.Widget.IconButton
        if not btn or not btn.Menu or not btn.Menu.IconSpot then return end
        local contents = btn.Menu.IconSpot.Contents
        if not contents or not contents.IconLabelContainer then return end
        local nametopleftcorner = contents.IconLabelContainer:FindFirstChild("IconLabel")
        if not nametopleftcorner then return end

        nametoolbar.Text = "You"
        nametopleftcorner.Text = ""

        toolbarnamechange = nametoolbar.Changed:Connect(function(property)
            if property == "Text" and nametoolbar then
                nametoolbar.Text = "You"
            end
        end)

        cornernamechange = nametopleftcorner.Changed:Connect(function(property)
            if property == "Text" and nametopleftcorner then
                nametopleftcorner.Text = ""
            end
        end)
    end

    if hidingname == true then
        removenameloop = plr.CharacterAdded:Connect(function()
            task.wait(1)
            removename()
        end)
        removename()
    else
        if removenameloop then
            removenameloop:Disconnect()
        end
        if cornernamechange then
            cornernamechange:Disconnect()
        end
        if toolbarnamechange then
            toolbarnamechange:Disconnect()
        end

        local pg = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui", 10)
        if not pg then return end

        local clientgui = pg:FindFirstChild("ClientGui")
        local topbar = pg:FindFirstChild("TopbarStandard")
        if not clientgui or not topbar then return end
        if not clientgui:FindFirstChild("Mainframe") then return end
        if not clientgui.Mainframe:FindFirstChild("Loadout") then return end
        if not clientgui.Mainframe.Loadout:FindFirstChild("HUD") then return end

        local nametoolbar = clientgui.Mainframe.Loadout.HUD:FindFirstChild("PlayerName")
        local top = topbar.Holders
        if not top or not top.Left or not top.Left.Widget then return end
        local btn = top.Left.Widget.IconButton
        if not btn or not btn.Menu or not btn.Menu.IconSpot then return end
        local contents = btn.Menu.IconSpot.Contents
        if not contents or not contents.IconLabelContainer then return end
        local nametopleftcorner = contents.IconLabelContainer:FindFirstChild("IconLabel")
        if not nametoolbar or not nametopleftcorner then return end

        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            nametoolbar.Text = plr.Character.Humanoid.DisplayName
        end
        nametopleftcorner.Text = plr.Name .. " | " .. plr.UserId
    end
end

features.Activationsfarm = function()
    if Activationfarm.Value then
        features.HandleNotLoadedIn()
        local modes = {"Sharingan [Stage 1]","Sharingan [Stage 2]","Sharingan [Stage 3]","Obito's Mangekyo","Obito's Eternal Mangekyo",
        "Itachi's Mangekyo","Itachi's Eternal Mangekyo","Sasuke's Mangekyo","Sasuke's Eternal Mangekyo","Pain's Rinnegan","Byakugan [Stage 1]"
        ,"Byakugan [Stage 2]","Byakugan [Stage 3]","Byakugan [Stage 4]","Adamantine Sealing Chains", "Hundred Healings", "Green Gates",
        "Ketsuryugan [Stage 3]","Ketsuryugan [Stage 2]","Ketsuryugan [Stage 1]", "Blue Gates"}
        local mode = false

        for i,v in modes do
            if insertedjutsumode == v then
                mode = true
            end
        end

        if mode == true then
            if AutoModeNoReset == false then

                if features.gotosafespot(true,false) == false then
                    return
                end

                local function usemodeandwhitevoid()
                    task.wait(0.1)
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart", 10)
                    if not hrp then return end
                    
                    if Activationfarm.Value == false then
                        return
                    end

                    repeat 
                        task.wait() 
                        features.gotosafespot()
                    until not char:FindFirstChild("ForceField") or char.Parent == nil or Activationfarm.Value == false

                    if Activationfarm.Value == false then
                        return
                    end

                    if char and char.Parent and hrp and hrp.Parent then
                        local args = {
                            "Awaken",
                            insertedjutsumode
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                        plr.Character.Head:Destroy()
                    end
                end

                modeloop = plr.CharacterAdded:Connect(function(character)
                    task.spawn(usemodeandwhitevoid)
                end)

                if plr.Character then
                    task.spawn(usemodeandwhitevoid)
                end
            else
                while Activationfarm.Value do
                    local args = {
                        "Awaken",
                        insertedjutsumode
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                    
                    wait(1.5)
                end
            end
        else
            while Activationfarm.Value do
                local args = {
                    "startSkill",
                    insertedjutsumode,
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                
                wait()

                local args = {
                    "ReleaseSkill"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                
                wait()
            end
        end
    else
        if modeloop then
            modeloop:Disconnect()
        end
    end

end

features.AutoSpawnArticNPC = function()
    if spawningarticnpc.Value then
        features.HandleNotLoadedIn()
        local activationfloors = {workspace.SnowActivationFloor4,workspace.SnowActivationFloor6,workspace.SnowActivationFloor7}
        local spawncooldown = false
        local waitingspot = CFrame.new(-2268.02148, 81.1951981, -3024.97119)

        local function bodyforceconf(boolean)
            if boolean == true then
                if not plr.Character.HumanoidRootPart:FindFirstChild("SpawnerVel") then
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    bv.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
                    bv.Name = "SpawnerVel"
                end
            else
                for i, v in pairs(plr.Character.HumanoidRootPart:GetChildren()) do
                    if v.Name == "SpawnerVel" then
                        v:Destroy()
                    end
                end
            end
        end

        local function spawntheNPCs()
            for i, v in pairs(activationfloors) do
                if spawningarticnpc.Value == false then return end
                bodyforceconf(false)

                Teleport(v.CFrame)
                        
                wait(0.25)

                local args = {
                    "ActivateSecretStepPlate",
                    v
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                plr.Character.Humanoid.Jump = true
                wait(0.2)
                Teleport(waitingspot)
                wait(0.3)
            end
            spawncooldown = true
        end

        while spawningarticnpc.Value == true do
            wait()
            if spawncooldown == false then
                spawntheNPCs()
                task.spawn(function()
                    for i = 60, 1, -1 do
                        print("Time remaining:", i)
                        task.wait(1)
                    end
                    spawncooldown = false
                end)
                wait(0.1)
                Teleport(waitingspot)
                bodyforceconf(true)
            end
            if workspace:FindFirstChild("Frozen Relic") and workspace:FindFirstChild("Frozen Relic").Transparency == 0 then
                Teleport(workspace["Frozen Relic"].CFrame)
                local timeout = 1.5
                local startTime = tick()
                local relic = workspace:FindFirstChild("Frozen Relic")

                while relic and relic.Parent and tick() - startTime < timeout do
                    task.wait()
                    if relic.Transparency ~= 0 then
                        break
                    end
                    local args = {
                        "Relic",
                        "Frozen Relic"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                end
            end
            Teleport(waitingspot)
            bodyforceconf(true)
        end
        if plr.Character.HumanoidRootPart:FindFirstChild("SpawnerVel") then
            plr.Character.HumanoidRootPart:FindFirstChild("SpawnerVel"):Destroy()
        end
    end
end

features.DoQuest = function()
    if selectedquest ~= nil and plr.Character then
        local startpos = plr.Character.HumanoidRootPart.CFrame
        if selectedquest == "Passageway" then
            local args = {
                "StartQuest",
                "Hostage Retrieval"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Hostage" then
                    if v:FindFirstChild("Settings"):FindFirstChild("BeingCarried").Value == "None" then
                        repeat 
                            plr.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,1.5)
                            wait()

                            local args = {"Carry"}
                            RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                            wait(0.1)
                        until RS:WaitForChild("Settings"):FindFirstChild(user):FindFirstChild("Carrying").Value ~= nil
                        local args = {
                                "GetQuestProgress",
                                "Hostage Retrieval",
                                "DontComplete"
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                        wait(0.2)
                        local args = {"Carry"}
                        RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        
                        wait(0.1)
                        plr.Character.HumanoidRootPart.CFrame = startpos
                        return
                    end
                end
            end

            wait()
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
            
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(2142.51807, -207.585144, -773.712219, 0.00978908874, 0.036685016, -0.999278903, -4.71484007e-08, 0.999326825, 0.0366867706, 0.999952078, -0.000359082944, 0.00978250057)

            local args = {
                "ActivateSecretStepPlate",
                workspace:WaitForChild("BanditActivationFloor")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            local objectname = "Hostage"
            local timeout = 0.8
            local startTime = tick()
            local hostage = nil

            repeat
                hostage = workspace:FindFirstChild(objectname)
                task.wait()
            until hostage or (tick() - startTime) >= timeout

            wait(0.2)

            bv:Destroy()
            
            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Hostage" then
                    if v:FindFirstChild("Settings"):FindFirstChild("BeingCarried").Value == "None" then
                        repeat 
                            plr.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
                            wait()

                            local args = {"Carry"}
                            RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                            wait(0.5)
                        until RS:WaitForChild("Settings"):FindFirstChild(user):FindFirstChild("Carrying").Value ~= nil

                        local args = {
                                "GetQuestProgress",
                                "Hostage Retrieval",
                                "DontComplete"
                            }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                        wait(0.2)
                        local args = {"Carry"}
                        RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        
                        wait(0.1)
                        plr.Character.HumanoidRootPart.CFrame = startpos
                        return
                    end
                end
            end
            Notify("No Hostage found.","",1.5,"info")
            plr.Character.HumanoidRootPart.CFrame = startpos
        
        elseif selectedquest == "Flower Bouquet" then
            local args = {
                "GetQuestProgress",
                "Flower Bouquet"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                "StartQuest",
                "Flower Bouquet"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.2)
            local args = {
                "PlaceFlowerBouquet",
                workspace:WaitForChild("Blue Stone")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            wait(0.2)

            local args = {
                "GetQuestProgress",
                "Flower Bouquet"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

        elseif selectedquest == "Crate Delivery" then
            
            local hascrate = false

            for _, child in ipairs(plr.Character:GetChildren()) do
                if string.match(child.Name, "^Crate") then
                    hascrate = true
                    break
                end
            end

            if hascrate == false then
                Notify("Missing Crate", "You need to accept a Crate Mission", 2.5, "info")
                return
            end

            for i, v in pairs(workspace.Debris["Mission Locations"]:GetDescendants()) do
                if v:IsA("StringValue") then
                    for _, npcs in pairs(workspace:GetChildren()) do
                        if npcs.Name == v.Name then
                            if npcs:FindFirstChild("MissionMarker") and npcs:FindFirstChild("MissionMarker").Enabled == true then
                                Teleport(npcs.HumanoidRootPart.CFrame)
                                return
                            end
                        end
                    end
                end
            end

        elseif selectedquest == "Bells" then
            if workspace:FindFirstChild("Training Bells") then
                Teleport(workspace:FindFirstChild("Training Bells").CFrame)

                wait(0.1)

                local args = {
                    "StartQuest",
                    "Parkour Training"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                wait(0.1)

                local args = {
                    "GetQuestProgress",
                    "Parkour Training",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            else
                local args = {
                    "GetQuestProgress",
                    "Parkour Training",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                Notify("Not possible", "No Training Bells found.",2.5,"info")
            end
        elseif selectedquest == "Shark Girl" then

            local args = {
                [1] = "StartQuest",
                [2] = "A Run For Your Life"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            if workspace:FindFirstChild("The Scarlet Slowcoach") then
                if plr.Character.HumanoidRootPart then
                    for i, v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("BasePart") and v.CanCollide == true then
                            v.CanCollide = false
                        end
                    end

                    wait(0.05)
                    if workspace.RiverGearsActivation.Activated.Value == true then
                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(212.77771, -53.8684158, -814.37439, -0.99941355, 5.63199869e-08, -0.0342424773, 5.71334766e-08, 1, -2.27783321e-08, 0.0342424773, -2.47213645e-08, -0.99941355)

                        wait(0.05)

                        local args = {
                            [1] = "PlayerEvent",
                            [2] = "TheDeadRunner"
                        }

                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                        wait(0.5)

                        local args = {
                            [1] = "PlayerEvent",
                            [2] = "TheDeadRunner"
                        }

                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    else
                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(372.524658, 27.1627274, -1027.24524, -0.0282121263, -6.83527546e-08, 0.99960196, 7.51098881e-08, 1, 7.04998229e-08, -0.99960196, 7.70689397e-08, -0.0282121263)

                        wait(0.2)

                        local args = {
                            "ActivateButton",
                            workspace:WaitForChild("RiverGearsActivation")
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        wait(0.4)
                    end

                    plr.Character.HumanoidRootPart.CFrame = startpos
                end
            else
                Notify("The Quest", "has already been completed.", 2, "info")
            end


        elseif selectedquest == "Golem" then
            if tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text) < 120 then
                Notify("Requirements not met.", "You need to have at least 120 Ryo",2.5,"info")
                return
            end

            local args = {
                "StartQuest",
                "Search For A Flaming Heart"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)

            local args = {
                [1] = "Pay",
                [2] = 0,
                [3] = "Flaming Heart",
                [4] = 1,
                [5] = workspace:WaitForChild("Medic"):WaitForChild("HumanoidRootPart")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)
            
            local args = {
                "GetQuestProgress",
                "Search For A Flaming Heart"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))


        elseif selectedquest == "Oasis" then

            local mangothere = false

            if tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text) < 15 then
                Notify("Requirements not met.", "You need to have at least 15 Ryo",2.5,"info")
                return
            end

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Mango" then
                    local mangostr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    local mangoint =  tonumber(string.sub(mangostr, 2))
                    if mangoint then
                        if  mangoint > 2 then
                            mangothere = true
                            break
                        end
                    end
                end
            end

            if mangothere == false then
                Notify("Requirements not met.", "You need to have at least 3 Mangos",2.5,"info")
                return
            end

            
            local args = {
                [1] = "Pay",
                [3] = "Chicken",
                [4] = 2
            }
                        
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))


            local args = {
                "StartQuest",
                "An Extravagant Dish"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                [1] = "Pay",
                [3] = "Bowl",
                [4] = 1
            }
                        
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            wait(0.1)

            local args = {
                "PlaceBowl",
                workspace:WaitForChild("BowlHolderHallow")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Mango"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            wait(0.1)

            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Mango"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            wait(0.1)
            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Mango"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            wait(0.1)
            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Chicken"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            wait(0.1)
            
            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Chicken"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            wait(0.1)

            local args = {
                "BowlFinish",
                workspace:WaitForChild("BowlHolderHallow"):WaitForChild("BowlFinish")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            local args = {
                "GetQuestProgress",
                "An Extravagant Dish",
                "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
        elseif selectedquest == "Pickpocket" then
            -- Incase player already has mask in inventory

            local args = {
                "StartQuest",
                "Relic Retrieval"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                "GetQuestProgress",
                "Relic Retrieval",
                "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            if plr.Character.HumanoidRootPart then
                if workspace["Biyo Relic"] and workspace["Biyo Relic"].Transparency == 0 then
                    startpos = plr.Character.HumanoidRootPart.CFrame
                    local args = {
                        "StartQuest",
                        "Relic Retrieval"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                    
                    plr.Character.HumanoidRootPart.CFrame = CFrame.new(-607.182617, -188.449982, -549.910706, 0.99977237, 1.22664998e-08, -0.0213369261, -1.12036309e-08, 1, 4.9933135e-08, 0.0213369261, -4.96827148e-08, 0.99977237)
                    
                    local args = {
                        "Relic",
                        "Biyo Relic"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                    local mask = workspace["Biyo Relic"]
                    local timeout = 1.5
                    local startTime = tick()

                    while mask and mask.Transparency == 0 and tick() - startTime < timeout do
                        task.wait()
                        local args = {
                            "Relic",
                            "Biyo Relic"
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        
                    end

                    plr.Character.HumanoidRootPart.CFrame = startpos

                    local args = {
                        "GetQuestProgress",
                        "Relic Retrieval",
                        "DontComplete"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                    plr.Character.HumanoidRootPart.CFrame = startpos
                else
                    Notify("Mask not found","",1.5,"info")
                end
            end

        elseif selectedquest == "Lavarossa" then
            -- if the player already has the horns
            local args = {
                "StartQuest",
                "Humbling Lavarossa"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                "GetQuestProgress",
                "Humbling Lavarossa",
                "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local pickpocketinventory = false

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Pickpocket" then
                    pickpocketinventory = true
                    break
                end
            end

            local function TakeHorns()
                for i, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Lavarossa" and v:FindFirstChild("Horns").Transparency == 0 and v:FindFirstChild("Head") then
                        while workspace.Lavarossa.Horns.Transparency == 0 and plr.Character do
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Lavarossa.Head.CFrame

                            local args = {
                                "startSkill",
                                "Pickpocket",
                                vector.create(-730.5443115234375, -210.14356994628906, -553),
                                true
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                            local args = {
                                "ReleaseSkill"
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                            wait()
                        end
                        break
                    end
                end

                local args = {
                    "GetQuestProgress",
                    "Humbling Lavarossa",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                plr.Character.HumanoidRootPart.CFrame = startpos
            end

            if pickpocketinventory == true then
                if workspace:FindFirstChild("Lavarossa") and workspace.Lavarossa:FindFirstChild("Head") then
                    if workspace.Lavarossa.Horns.Transparency == 1 then
                        Notify("Boss doesn't have any horns.","",1.5,"info")
                        return
                    else
                        TakeHorns()
                    end
                else
                    -- Spawning the Boss
                    if workspace.LavarossaRewards.Part.Transparency == 1 then
                        if Teleport(CFrame.new(-536.194763, -314.055023, -201.574188, -0.159694523, 4.51376314e-09, 0.987166464, 4.54713767e-11, 1, -4.56508786e-09, -0.987166464, -6.84131751e-10, -0.159694523)) == false then return end
                        
                        wait(0.25)

                        local args = {
                            [1] = "activateLavarossa"
                        }
                            
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                        plr.Character.Humanoid.Jump = true

                        wait(0.5)

                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(-18.8846588, -278.715057, -482.883179, 0.000202000956, 1.24929542e-07, 1, 4.71037964e-09, 1, -1.24930494e-07, -1, 4.73561546e-09, 0.000202000956)
                        
                        wait(1.5)

                        TakeHorns()

                        plr.Character.HumanoidRootPart.CFrame = startpos
                    else
                        Notify("Boss has already been killed.", "Try again later.",2,"info")
                    end
                end
            else 
                Notify("Missing Requirements.", "You need to have Pickpocket.",2,"info")
            end

        elseif selectedquest == "Bolive Crops" then
            local args = {
                "StartQuest",
                "Bolive Retrieval"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)


            -- Check if 5 crops in inventory
            local bolivethere = false
            local orangeint = 0

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Bolive Crops" then
                    local orangestr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    orangeint = tonumber(string.sub(orangestr, 2))
                    if orangeint > 4 then
                        bolivethere = true
                        break
                    end
                end
            end

            if bolivethere then
                local args = {
                    "GetQuestProgress",
                    "Bolive Retrieval",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                return
            end

            -- Check for available crops
            local bolivecropscounter = 0

            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Bolive Crops" and v.Transparency == 0 then
                    bolivecropscounter += 1
                end
            end

            local neededcrops = 5 - orangeint
            if bolivecropscounter < neededcrops then
                Notify("Missing requirements", "No Bolive Crops Available.", 2.5, "info")
                return
            end

            local function nocliploop()
                for i, v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                    end
                end
            end

            noclippingcrop = RunService.Stepped:Connect(nocliploop)

            local pickedCropsCount = 0


            -- Water crops until enough obtained
            for i, v in pairs(workspace:GetChildren()) do
                if neededcrops <= 0 then break end
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Bolive Crops" and v.Transparency == 0 then
                    watercrops(v, 1)
                    neededcrops -= 1
                    wait()
                end
            end

            -- Disconnect noclip loop immediately after watering
            if noclippingcrop then
                noclippingcrop:Disconnect()
            end

            -- Wait until picked enough crops or timeout after 20 seconds
            local timeout = tick() + 20
            repeat
                wait(0.5)
            until pickedCropsCount >= (5 - orangeint) or tick() > timeout

            -- Final quest progress update
            wait(0.2)

            game:GetService("ReplicatedStorage").Events.DataFunction:InvokeServer("GetQuestProgress", "Bolive Retrieval", "DontComplete")


        elseif selectedquest == "Chakra Crops" then

            local args = {
                "StartQuest",
                "Search For The Chakra Crops"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)

            -- Check if 5 crops in inventory
            local chakrathere = false
            local chakraint = 0

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Chakra Crops" then
                    local chakrastr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    chakraint = tonumber(string.sub(chakrastr, 2))
                    if chakraint > 4 then
                        chakrathere = true
                        break
                    end
                end
            end

            if chakrathere then
                local args = {
                    "GetQuestProgress",
                    "Search For The Chakra Crops",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                return
            end

            -- Check available crops
            local chakracropscounter = 0

            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Chakra Crops" and v.Transparency == 0 then
                    chakracropscounter += 1
                end
            end

            local neededcrops = 5 - chakraint
            if chakracropscounter < neededcrops then
                Notify("Missing requirements", "No Chakra Crops Available.", 2.5, "info")
                return
            end

            local function nocliploop()
                for i, v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                    end
                end
            end

            noclippingcrop = RunService.Stepped:Connect(nocliploop)

            local pickedCropsCount = 0


            -- Water crops until enough obtained
            for i, v in pairs(workspace:GetChildren()) do
                if neededcrops <= 0 then break end
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Chakra Crops" and v.Transparency == 0 then
                    watercrops(v, 1)
                    neededcrops -= 1
                    wait()
                end
            end

            -- Disconnect noclip loop after watering
            if noclippingcrop then
                noclippingcrop:Disconnect()
                noclippingcrop = nil
            end

            -- Wait until picked enough crops or timeout after 20 seconds
            local timeout = tick() + 20
            repeat
                wait(0.5)
            until pickedCropsCount >= (5 - chakraint) or tick() > timeout
            -- Final quest progress update
            game:GetService("ReplicatedStorage").Events.DataFunction:InvokeServer("GetQuestProgress", "Search For The Chakra Crops", "DontComplete")


        elseif selectedquest == "Thirsty Hoshi" then
            local waterbowlthere = false
            local orangeint = 0
            
            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Freshwater Bowl" then
                    local orangestr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    orangeint =  tonumber(string.sub(orangestr, 2))
                    if orangeint > 0 then
                        waterbowlthere = true
                        break
                    end
                end
            end

            if waterbowlthere then
                    local args = {
                    [1] = "StartQuest",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                local args = {
                    [1] = "GetQuestProgress",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                return
            end

            local bowlthere = false
            local orangeint = 0
            
            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Bowl" then
                    local orangestr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    orangeint =  tonumber(string.sub(orangestr, 2))
                    if orangeint > 0 then
                        bowlthere = true
                        break
                    end
                end
            end
            
            local function usebowl()
                local args = {
                    "Item",
                    "Selected",
                    "Bowl"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    
                wait(0.2)
                
                local args = {
                    "FreshwaterBowl"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                
                wait(0.2)

                local args = {
                    [1] = "StartQuest",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                local args = {
                    [1] = "GetQuestProgress",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            end
            
            if bowlthere then
                usebowl()
            else
                if tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text) < 3 then
                    Notify("Missing requirements", "Missing 3 Ryo",2,"info")
                    return
                else
                    local args = {
                        [1] = "Pay",
                        [2] = 0,
                        [3] = "Bowl",
                        [4] = 1,
                        [5] = workspace:WaitForChild("TorchMesh")
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                    wait(0.3)

                    usebowl()
                end
            end
        elseif selectedquest == "Mail" then
            Teleport(CFrame.new(-668.973816, -194.109985, -268.560547, 0.0070860046, 2.33984299e-08, -0.999974906, -2.25259669e-08, 1, 2.32393944e-08, 0.999974906, 2.23607266e-08, 0.0070860046), true)

            local args = {
                [1] = "StartQuest",
                [2] = "InnKeeper's Reunion"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                [1] = "GetQuestProgress",
                [2] = "InnKeeper's Reunion",
                [3] = "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            wait(0.5)

            Teleport(CFrame.new(-36.1317406, -189.715057, -206.712875, 0.030850267, 9.54886659e-08, -0.999523997, 3.90593513e-08, 1, 9.67396971e-08, 0.999523997, -4.20252029e-08, 0.030850267), true)

            local args = {
                [1] = "StartQuest",
                [2] = "InnKeeper's Reunion"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                [1] = "GetQuestProgress",
                [2] = "InnKeeper's Reunion",
                [3] = "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            wait(0.5)

            Teleport(startpos, true)
        end
    end
end

features.ReturnMenu = function()
    TS:Teleport(5571328985)
end




--[[

__________                 _____.__       .__       .___   ________                 ____ 
\______   \_____  ___.__._/ ____\__| ____ |  |    __| _/  /  _____/  ____   ____   /_   |
 |       _/\__  \<   |  |\   __\|  |/ __ \|  |   / __ |  /   \  ____/ __ \ /    \   |   |
 |    |   \ / __ \\___  | |  |  |  \  ___/|  |__/ /_/ |  \    \_\  \  ___/|   |  \  |   |
 |____|_  /(____  / ____| |__|  |__|\___  >____/\____ |   \______  /\___  >___|  /  |___|
        \/      \/\/                    \/           \/          \/     \/     \/        

--]]


-- ===== INSERTED FEATURES FROM loader-...lua END =====

-- ============================================
-- CREATE WINDOW
-- ============================================

local Window = Library:CreateWindow({
    Title = 'Bishop Hub | Bloodlines',
    Center = true,
    AutoShow = true,
    BackgroundImage = 'https://static.wikia.nocookie.net/near_pure_evil/images/f/f5/Regulus_Corneas_Season_3_Design_V2.png/revision/latest?cb=20250603022807',
    BackgroundTransparency = 0,
    BackgroundScaleType = Enum.ScaleType.Crop
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ESP = Window:AddTab('ESP'),
    AutoFarm = Window:AddTab('Auto Farm'),
    HalloweenFarm = Window:AddTab('Halloween'),
    --Quests = Window:AddTab('Quests'),
    Teleport = Window:AddTab('Teleports'),
    Music = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

_G.NotificationLib:MakeNotification({
    Title = "Bishop Hub",
    Text = "Initializing GUI...",
    Duration = 3
})

-- ============================================
-- CORE UTILITY FUNCTIONS
-- ============================================

local function getPlayerData(player)
    player = player or LocalPlayer
    local character = player.Character
    if not character then return nil end
    
    return {
        character = character,
        rootPart = character:FindFirstChild("HumanoidRootPart"),
        humanoid = character:FindFirstChildOfClass("Humanoid")
    }
end

local function getMoveVector()
    local moveVector = Vector3.new(0, 0, 0)
    local UserInputService = game:GetService("UserInputService")
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveVector = moveVector + Vector3.new(0, 0, -1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveVector = moveVector + Vector3.new(0, 0, 1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveVector = moveVector + Vector3.new(-1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveVector = moveVector + Vector3.new(1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
        moveVector = moveVector + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
        moveVector = moveVector + Vector3.new(0, -1, 0)
    end
    
    return moveVector
end

local function getPositionKey(position)
    return string.format("%.1f_%.1f_%.1f", position.X, position.Y, position.Z)
end

-- ============================================
-- CORE SYSTEMS SETUP
-- ============================================

local autoContinueThread

local function startAutoContinue()
    if autoContinueThread then
        task.cancel(autoContinueThread)
    end
    
    autoContinueThread = task.spawn(function()
        while true do
            task.wait(3)
            
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if not playerGui then return end
                
                local clientGui = playerGui:FindFirstChild("ClientGui")
                if not clientGui then return end
                
                local menuScreen = clientGui:FindFirstChild("MenuScreen")
                if not menuScreen then return end
                
                local menu = menuScreen:FindFirstChild("Menu")
                if not menu then return end
                
                local continueButton = menu:FindFirstChild("Continue")
                if not continueButton then return end
                
                if continueButton.Visible then
                    if getconnections then
                        for i,v in pairs(getconnections(continueButton.MouseButton1Down)) do
                            v:Fire()
                        end
                    else
                        if firesignal then
                            firesignal(continueButton.MouseButton1Down)
                        end
                    end
                end
            end)
        end
    end)
end

startAutoContinue()

local remotes = ReplicatedStorage:WaitForChild("Events")
local dataEvent = remotes:WaitForChild("DataEvent")

dataEvent.OnClientEvent:Connect(function(eventType, ...)
    if eventType == 'InDanger' then
        inDanger = true
    elseif eventType == 'OutOfDanger' then
        inDanger = false
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "FireServer" or method == "fireServer") and self == dataEvent then
        local action = args[1]
        
        if type(action) == "string" and action:lower() == "banme" then
            return
        end
        
        if type(action) == "string" and action == "TakeDamage" then
            if getgenv().MovementSettings and getgenv().MovementSettings.NoFallDamage then
                --warn("[No Fall Damage] Blocked TakeDamage call")
                return
            end
        end
    end
    
    return oldNamecall(self, ...)
end))

local function createChatLogger()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ChatLogger"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Size = UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    Frame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.BorderSizePixel = 0
    Title.Text = "Chat Logger"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = Title

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ChatList"
    ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
    ScrollFrame.Position = UDim2.new(0, 5, 0, 35)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.Parent = ScrollFrame

    ChatLoggerFrame = Frame
    ChatLoggerList = ScrollFrame

    return ScreenGui
end

createChatLogger()

local function addChatMessage(message)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -10, 0, 20)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = message
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextWrapped = true
    TextLabel.Parent = ChatLoggerList

    ChatLoggerList.CanvasSize = UDim2.new(0, 0, 0, ChatLoggerList.UIListLayout.AbsoluteContentSize.Y)
end

local function createChakraSenseCounter()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ChakraSenseCounter"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local ActiveLabel = Instance.new("TextLabel")
    ActiveLabel.Name = "ActiveSenseLabel"
    ActiveLabel.Size = UDim2.new(0, 200, 0, 40)
    ActiveLabel.Position = UDim2.new(0.5, -100, 0, 10)
    ActiveLabel.BackgroundTransparency = 1
    ActiveLabel.Text = "Active Sense: 0"
    ActiveLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActiveLabel.TextSize = 20
    ActiveLabel.Font = Enum.Font.GothamBold
    ActiveLabel.TextStrokeTransparency = 0.5
    ActiveLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    ActiveLabel.Visible = getgenv().MiscSettings.ChakraSenseAlert
    ActiveLabel.Parent = ScreenGui

    local Label = Instance.new("TextLabel")
    Label.Name = "CounterLabel"
    Label.Size = UDim2.new(0, 200, 0, 40)
    Label.Position = UDim2.new(0.5, -100, 0, 50)
    Label.BackgroundTransparency = 1
    Label.Text = "Chakra Sense: 0"
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 20
    Label.Font = Enum.Font.GothamBold
    Label.TextStrokeTransparency = 0.5
    Label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Label.Visible = getgenv().MiscSettings.ChakraSenseAlert
    Label.Parent = ScreenGui

    chakraSenseGui = ScreenGui
    chakraSenseLabel = Label
    activeSenseLabel = ActiveLabel

    return ScreenGui
end

createChakraSenseCounter()

local function updateChakraSenseCounter()
    local count = 0
    for _, active in pairs(activeChakraSenseUsers) do
        if active then
            count = count + 1
        end
    end
    chakraSenseCount = count
    
    if chakraSenseLabel then
        chakraSenseLabel.Text = string.format("Chakra Sense: %d", chakraSenseCount)
    end
end

local function updateActiveSenseCounter()
    local count = 0
    for _, active in pairs(activeSenseUsers) do
        if active then
            count = count + 1
        end
    end
    activeSenseCount = count
    
    if activeSenseLabel then
        activeSenseLabel.Text = string.format("Active Sense: %d", activeSenseCount)
        
        if activeSenseCount == 0 then
            activeSenseLabel.TextTransparency = 1
            activeSenseLabel.TextStrokeTransparency = 1
        else
            activeSenseLabel.TextTransparency = 0
            activeSenseLabel.TextStrokeTransparency = 0.5
        end
    end
end

local function monitorPlayerAnimations(player)
    if player == LocalPlayer then return end
    
    local playerName = player.Name
    
    if not playersWithChakraSense[playerName] then return end
    
    if animationConnections[playerName] then
        for _, connection in pairs(animationConnections[playerName]) do
            connection:Disconnect()
        end
    end
    animationConnections[playerName] = {}
    
    local function setupCharacter(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoid then return end
        
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then return end
        
        local function checkAnimations()
            local hasTargetAnimation = false
            
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                local animId = track.Animation.AnimationId
                if string.find(animId, "9864206537") then
                    hasTargetAnimation = true
                    break
                end
            end
            
            local previousStatus = activeSenseUsers[playerName]
            activeSenseUsers[playerName] = hasTargetAnimation
            
            if previousStatus ~= hasTargetAnimation then
                updateActiveSenseCounter()
            end
        end
        
        local connection = RunService.Heartbeat:Connect(function()
            checkAnimations()
        end)
        table.insert(animationConnections[playerName], connection)
    end
    
    if player.Character then
        setupCharacter(player.Character)
    end
    
    local charAddedConnection = player.CharacterAdded:Connect(function(character)
        setupCharacter(character)
    end)
    table.insert(animationConnections[playerName], charAddedConnection)
end

local function setupChakraSenseTracking()
    local cooldownsFolder = ReplicatedStorage:FindFirstChild("Cooldowns")
    if not cooldownsFolder then return end
    
    local function monitorPlayerAbilities(playerFolder)
        local playerName = playerFolder.Name
        if playerName == LocalPlayer.Name then return end
        
        playerFolder.ChildAdded:Connect(function(child)
            if child:IsA("NumberValue") and child.Name == "Chakra Sense" then
                playersWithChakraSense[playerName] = true
                
                local player = Players:FindFirstChild(playerName)
                if player then
                    monitorPlayerAnimations(player)
                end
            end
        end)
        
        local chakraSense = playerFolder:FindFirstChild("Chakra Sense")
        if chakraSense and chakraSense:IsA("NumberValue") then
            playersWithChakraSense[playerName] = true
            
            local player = Players:FindFirstChild(playerName)
            if player then
                monitorPlayerAnimations(player)
            end
        end
    end
    
    for _, playerFolder in pairs(cooldownsFolder:GetChildren()) do
        if playerFolder:IsA("Folder") then
            monitorPlayerAbilities(playerFolder)
        end
    end
    
    cooldownsFolder.ChildAdded:Connect(function(playerFolder)
        if playerFolder:IsA("Folder") then
            task.wait(0.1)
            monitorPlayerAbilities(playerFolder)
        end
    end)
end

setupChakraSenseTracking()

Players.PlayerRemoving:Connect(function(player)
    local playerName = player.Name
    
    if animationConnections[playerName] then
        for _, connection in pairs(animationConnections[playerName]) do
            connection:Disconnect()
        end
        animationConnections[playerName] = nil
    end
    
    if activeSenseUsers[playerName] then
        activeSenseUsers[playerName] = nil
        updateActiveSenseCounter()
    end
    
    if playersWithChakraSense[playerName] then
        playersWithChakraSense[playerName] = nil
    end
end)

local function setupJutsuPrediction(playerName)
    if not playerJutsuData[playerName] then
        playerJutsuData[playerName] = {
            activeJutsu = nil,
            lastUpdate = 0
        }
    end
    
    local cooldownsFolder = ReplicatedStorage:FindFirstChild("Cooldowns")
    if not cooldownsFolder then return end
    
    local playerFolder = cooldownsFolder:FindFirstChild(playerName)
    if not playerFolder then return end
    
    if jutsuConnections[playerName] then
        for _, connection in pairs(jutsuConnections[playerName]) do
            connection:Disconnect()
        end
    end
    jutsuConnections[playerName] = {}
    
    for _, child in pairs(playerFolder:GetChildren()) do
        if child:IsA("NumberValue") then
            local connection = child:GetPropertyChangedSignal("Value"):Connect(function()
                if child.Value > 0 then
                    playerJutsuData[playerName].activeJutsu = child.Name
                    playerJutsuData[playerName].lastUpdate = tick()
                end
            end)
            table.insert(jutsuConnections[playerName], connection)
        end
    end
    
    local childAddedConnection = playerFolder.ChildAdded:Connect(function(child)
        if child:IsA("NumberValue") then
            playerJutsuData[playerName].activeJutsu = child.Name
            playerJutsuData[playerName].lastUpdate = tick()
            
            local connection = child:GetPropertyChangedSignal("Value"):Connect(function()
                if child.Value > 0 then
                    playerJutsuData[playerName].activeJutsu = child.Name
                    playerJutsuData[playerName].lastUpdate = tick()
                end
            end)
            table.insert(jutsuConnections[playerName], connection)
        end
    end)
    table.insert(jutsuConnections[playerName], childAddedConnection)
end

local cooldownsFolder = ReplicatedStorage:FindFirstChild("Cooldowns")
if cooldownsFolder then
    for _, playerFolder in pairs(cooldownsFolder:GetChildren()) do
        setupJutsuPrediction(playerFolder.Name)
    end
    
    cooldownsFolder.ChildAdded:Connect(function(playerFolder)
        setupJutsuPrediction(playerFolder.Name)
    end)
    
    cooldownsFolder.ChildRemoved:Connect(function(playerFolder)
        local playerName = playerFolder.Name
        if jutsuConnections[playerName] then
            for _, connection in pairs(jutsuConnections[playerName]) do
                connection:Disconnect()
            end
            jutsuConnections[playerName] = nil
        end
        playerJutsuData[playerName] = nil
    end)
end

if not _G.ESPModule then
    _G.ESPModule = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/VortexHubScripts/BloodlinesScript/refs/heads/main/Esp"))()
end

_G.ESPModule.InitPlayerESP()
_G.ESPModule.InitMobESP()
_G.ESPModule.InitItemESP()
_G.ESPModule.InitFruitESP()
_G.ESPModule.InitPumpkinESP()

getgenv().ActiveESP = _G.ESPModule.ActivePlayerESP
getgenv().ActiveMobESP = _G.ESPModule.ActiveMobESP
getgenv().ActiveItemESP = _G.ESPModule.ActiveItemESP
getgenv().ActiveFruitESP = _G.ESPModule.ActiveFruitESP
getgenv().ActivePumpkinESP = _G.ESPModule.ActivePumpkinESP

print("ESP Module loaded successfully from GitHub!")

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

for _, child in pairs(workspace:GetChildren()) do
    task.spawn(onItemAdded, child)
end

workspace.ChildAdded:Connect(onItemAdded)

local KILL_BRICKS_NAMES = {'LavarossaVoid', 'Void'}

local function deleteKillBrick(object)
    if table.find(KILL_BRICKS_NAMES, object.Name) then
        table.insert(killBricks, object)
        
        if getgenv().MiscSettings.NoKillBricks then
            object:Destroy()
        end
    end
end

for _, v in pairs(workspace:GetDescendants()) do
    if table.find(KILL_BRICKS_NAMES, v.Name) then
        table.insert(killBricks, v)
    end
end

workspace.DescendantAdded:Connect(deleteKillBrick)

local function setupChatLogger()
    local DefaultChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if not DefaultChat then return end

    local OnMessageDoneFiltering = DefaultChat:FindFirstChild("OnMessageDoneFiltering")
    if not OnMessageDoneFiltering then return end

    OnMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
        if not getgenv().MiscSettings.ChatLogger then return end

        local player = Players:FindFirstChild(messageData.FromSpeaker)
        local message = messageData.Message
        if not player or not message then return end

        local timeText = DateTime.now():FormatLocalTime('H:mm:ss', 'en-us')
        local playerName = player.Name
        local fullMessage = string.format('[%s] [%s] %s', timeText, playerName, message)

        addChatMessage(fullMessage)
    end)
end

setupChatLogger()

local Cooldowns = ReplicatedStorage:WaitForChild("Cooldowns")
local lastValues = {}
local activeChakraSenseUsers = {}
local chakraSenseLabel = nil

local function findChakraSenseLabel()
    local coreGui = game:GetService("CoreGui")
    local counterGui = coreGui:FindFirstChild("ChakraSenseCounter")
    if counterGui then
        chakraSenseLabel = counterGui:FindFirstChild("CounterLabel")
    end
end

findChakraSenseLabel()

local function updateChakraSenseCounter()
    local count = 0
    for playerName, isActive in pairs(activeChakraSenseUsers) do
        if isActive then
            count = count + 1
        end
    end
    
    if chakraSenseLabel then
        chakraSenseLabel.Text = string.format("Chakra Sense: %d", count)
    end
end

local function initializePlayer(playerFolder)
    local playerName = playerFolder.Name
    
    if playerName == LocalPlayer.Name then return end
    
    if not lastValues[playerName] then
        lastValues[playerName] = {}
    end
    
    for _, abilityValue in pairs(playerFolder:GetChildren()) do
        if abilityValue:IsA("NumberValue") then
            local abilityName = abilityValue.Name
            lastValues[playerName][abilityName] = abilityValue.Value
            
            if abilityName == "Chakra Sense" and abilityValue.Value > 0 then
                activeChakraSenseUsers[playerName] = true
                updateChakraSenseCounter()
            end
            
            abilityValue:GetPropertyChangedSignal("Value"):Connect(function()
                local newValue = abilityValue.Value
                local oldValue = lastValues[playerName][abilityName]
                
                if newValue ~= oldValue then
                    if abilityName == "Chakra Sense" and newValue > oldValue then
                        activeChakraSenseUsers[playerName] = true
                        updateChakraSenseCounter()
                        
                        if getgenv().MiscSettings and getgenv().MiscSettings.ChakraSenseAlert then
                            _G.NotificationLib:MakeNotification({
                                Title = "Chakra Sense Alert",
                                Text = string.format('%s used Chakra Sense', playerName),
                                Duration = 3
                            })
                        end
                    end
                    
                    lastValues[playerName][abilityName] = newValue
                end
            end)
        end
    end
end

local function onAbilityAdded(playerFolder, ability)
    if ability:IsA("NumberValue") then
        local playerName = playerFolder.Name
        local abilityName = ability.Name
        
        if playerName == LocalPlayer.Name then return end
        
        if not lastValues[playerName] then
            lastValues[playerName] = {}
        end
        
        lastValues[playerName][abilityName] = ability.Value
        
        if abilityName == "Chakra Sense" then
            activeChakraSenseUsers[playerName] = true
            updateChakraSenseCounter()
        end
        
        ability:GetPropertyChangedSignal("Value"):Connect(function()
            local newValue = ability.Value
            local oldValue = lastValues[playerName][abilityName]
            
            if newValue ~= oldValue then
                if abilityName == "Chakra Sense" and newValue > oldValue then
                    if getgenv().MiscSettings and getgenv().MiscSettings.ChakraSenseAlert then
                        _G.NotificationLib:MakeNotification({
                            Title = "Chakra Sense Alert",
                            Text = string.format('%s used Chakra Sense', playerName),
                            Duration = 3
                        })
                    end
                end
                
                lastValues[playerName][abilityName] = newValue
            end
        end)
    end
end

for _, playerFolder in pairs(Cooldowns:GetChildren()) do
    if playerFolder:IsA("Folder") then
        task.spawn(initializePlayer, playerFolder)
        
        playerFolder.ChildAdded:Connect(function(ability)
            onAbilityAdded(playerFolder, ability)
        end)
    end
end

Cooldowns.ChildAdded:Connect(function(playerFolder)
    if playerFolder:IsA("Folder") then
        task.wait(0.1)
        initializePlayer(playerFolder)
        
        playerFolder.ChildAdded:Connect(function(ability)
            onAbilityAdded(playerFolder, ability)
        end)
    end
end)

Cooldowns.ChildRemoved:Connect(function(playerFolder)
    if playerFolder:IsA("Folder") then
        local playerName = playerFolder.Name
        
        if lastValues[playerName] then
            lastValues[playerName] = nil
        end
        
        if activeChakraSenseUsers[playerName] then
            activeChakraSenseUsers[playerName] = nil
            updateChakraSenseCounter()
        end
    end
end)

task.delay(2, findChakraSenseLabel)

local function setupObserverAlert()
    for _, connection in pairs(observerConnections) do
        connection:Disconnect()
    end
    observerConnections = {}
    
    local settingsFolder = ReplicatedStorage:FindFirstChild("Settings")
    if not settingsFolder then 
        warn("[Observer Alert] Settings folder not found!")
        return 
    end
    
    local playerFolder = settingsFolder:FindFirstChild(LocalPlayer.Name)
    if not playerFolder then
        warn("[Observer Alert] Player folder not found!")
        return
    end
    
    local childAddedConnection = playerFolder.ChildAdded:Connect(function(child)
        if not getgenv().MiscSettings.ObserverAlert then return end
        
        if child.Name == "BeingObservedBy" and child:IsA("StringValue") then
            _G.NotificationLib:MakeNotification({
                Title = "Observer Alert",
                Text = "You are being observed!",
                Duration = 5
            })
        end
    end)
    table.insert(observerConnections, childAddedConnection)
end

setupObserverAlert()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    setupObserverAlert()
end)

local function setupChakraSenseSkillNotification(playerName)
    local cooldownsFolder = ReplicatedStorage:FindFirstChild("Cooldowns")
    if not cooldownsFolder then return end
    
    local playerFolder = cooldownsFolder:FindFirstChild(playerName)
    if not playerFolder then return end
    
    if chakraSenseSkillConnections[playerName] then
        for _, connection in pairs(chakraSenseSkillConnections[playerName]) do
            connection:Disconnect()
        end
    end
    chakraSenseSkillConnections[playerName] = {}
    
    local childAddedConnection = playerFolder.ChildAdded:Connect(function(child)
        if child:IsA("NumberValue") and child.Name == "Chakra Sense" then
            _G.NotificationLib:MakeNotification({
                Title = "Chakra Sense Used",
                Text = string.format("%s used Chakra Sense!", playerName),
                Duration = 3
            })
        end
    end)
    table.insert(chakraSenseSkillConnections[playerName], childAddedConnection)
end

local cooldownsFolder2 = ReplicatedStorage:FindFirstChild("Cooldowns")
if cooldownsFolder2 then
    for _, playerFolder in pairs(cooldownsFolder2:GetChildren()) do
        setupChakraSenseSkillNotification(playerFolder.Name)
    end
    
    cooldownsFolder2.ChildAdded:Connect(function(playerFolder)
        setupChakraSenseSkillNotification(playerFolder.Name)
    end)
    
    cooldownsFolder2.ChildRemoved:Connect(function(playerFolder)
        local playerName = playerFolder.Name
        if chakraSenseSkillConnections[playerName] then
            for _, connection in pairs(chakraSenseSkillConnections[playerName]) do
                connection:Disconnect()
            end
            chakraSenseSkillConnections[playerName] = nil
        end
    end)
end

for _, chakraPoint in pairs(workspace:WaitForChild("ChakraPoints"):GetChildren()) do
    local pointName = chakraPoint:FindFirstChild("PointName")
    if pointName then
        table.insert(chakraPoints, pointName.Value)
        local main = chakraPoint:FindFirstChild("Main")
        if main then
            chakraPointInstances[pointName.Value] = main.Position
        end
    end
end

local function onNPCAdded(object)
    if not IsA(object, 'Model') then return end

    local npcValue = object:WaitForChild('NPC', 10)
    if not npcValue then return end

    if npcValue.Value == 'Dialog' then
        table.insert(npcs, object.Name)
        npcInstances[object.Name] = object

        object.Destroying:Connect(function()
            local index = table.find(npcs, object.Name)
            if index then
                table.remove(npcs, index)
            end
            npcInstances[object.Name] = nil
        end)
    end
end

for _, v in pairs(workspace:GetChildren()) do
    task.spawn(onNPCAdded, v)
end

workspace.ChildAdded:Connect(onNPCAdded)

table.sort(chakraPoints, function(a, b)
    return string.lower(a) < string.lower(b)
end)

table.sort(npcs, function(a, b)
    return string.lower(a) < string.lower(b)
end)

-- ============================================
-- PART 2: ALL FEATURE FUNCTIONS
-- ============================================

-- ============================================
-- QUEST HELPER FUNCTIONS
-- ============================================

local function Teleport(cframe, ignoreCheck)
    local playerData = getPlayerData()
    local rootPart = playerData and playerData.rootPart
    if not rootPart then return false end
    
    rootPart.CFrame = cframe
    return true
end

local function Notify(title, text, duration, type)
    _G.NotificationLib:MakeNotification({
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

local function watercrops(crop, amount)
    if not crop then return end
    
    local player = LocalPlayer
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Teleport to crop
    hrp.CFrame = crop.CFrame * CFrame.new(0, 5, 0)
    
    task.wait(0.2)
    
    -- Water the crop
    pcall(function()
        local args = {
            "WaterCrop",
            crop,
            amount
        }
        RS.Events.DataEvent:FireServer(unpack(args))
    end)
    
    task.wait(0.5)
end

-- ============================================
-- QUEST FEATURES MODULE
-- ============================================

local features = {}

features.DoQuest = function()
    if selectedquest ~= nil and plr.Character then
        local startpos = plr.Character.HumanoidRootPart.CFrame
        if selectedquest == "Passageway" then
            local args = {
                "StartQuest",
                "Hostage Retrieval"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Hostage" then
                    if v:FindFirstChild("Settings"):FindFirstChild("BeingCarried").Value == "None" then
                        repeat 
                            plr.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,1.5)
                            wait()

                            local args = {"Carry"}
                            RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                            wait(0.1)
                        until RS:WaitForChild("Settings"):FindFirstChild(user):FindFirstChild("Carrying").Value ~= nil
                        local args = {
                                "GetQuestProgress",
                                "Hostage Retrieval",
                                "DontComplete"
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                        wait(0.2)
                        local args = {"Carry"}
                        RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        
                        wait(0.1)
                        plr.Character.HumanoidRootPart.CFrame = startpos
                        return
                    end
                end
            end

            wait()
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
            
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(2142.51807, -207.585144, -773.712219, 0.00978908874, 0.036685016, -0.999278903, -4.71484007e-08, 0.999326825, 0.0366867706, 0.999952078, -0.000359082944, 0.00978250057)

            local args = {
                "ActivateSecretStepPlate",
                workspace:WaitForChild("BanditActivationFloor")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            local objectname = "Hostage"
            local timeout = 0.8
            local startTime = tick()
            local hostage = nil

            repeat
                hostage = workspace:FindFirstChild(objectname)
                task.wait()
            until hostage or (tick() - startTime) >= timeout

            wait(0.2)

            bv:Destroy()
            
            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Hostage" then
                    if v:FindFirstChild("Settings"):FindFirstChild("BeingCarried").Value == "None" then
                        repeat 
                            plr.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
                            wait()

                            local args = {"Carry"}
                            RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                            wait(0.5)
                        until RS:WaitForChild("Settings"):FindFirstChild(user):FindFirstChild("Carrying").Value ~= nil

                        local args = {
                                "GetQuestProgress",
                                "Hostage Retrieval",
                                "DontComplete"
                            }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                        wait(0.2)
                        local args = {"Carry"}
                        RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        
                        wait(0.1)
                        plr.Character.HumanoidRootPart.CFrame = startpos
                        return
                    end
                end
            end
            Notify("No Hostage found.","",1.5,"info")
            plr.Character.HumanoidRootPart.CFrame = startpos
        
        elseif selectedquest == "Flower Bouquet" then
            local args = {
                "GetQuestProgress",
                "Flower Bouquet"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                "StartQuest",
                "Flower Bouquet"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.2)
            local args = {
                "PlaceFlowerBouquet",
                workspace:WaitForChild("Blue Stone")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            wait(0.2)

            local args = {
                "GetQuestProgress",
                "Flower Bouquet"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

        elseif selectedquest == "Crate Delivery" then
            
            local hascrate = false

            for _, child in ipairs(plr.Character:GetChildren()) do
                if string.match(child.Name, "^Crate") then
                    hascrate = true
                    break
                end
            end

            if hascrate == false then
                Notify("Missing Crate", "You need to accept a Crate Mission", 2.5, "info")
                return
            end

            for i, v in pairs(workspace.Debris["Mission Locations"]:GetDescendants()) do
                if v:IsA("StringValue") then
                    for _, npcs in pairs(workspace:GetChildren()) do
                        if npcs.Name == v.Name then
                            if npcs:FindFirstChild("MissionMarker") and npcs:FindFirstChild("MissionMarker").Enabled == true then
                                Teleport(npcs.HumanoidRootPart.CFrame)
                                return
                            end
                        end
                    end
                end
            end

        elseif selectedquest == "Bells" then
            if workspace:FindFirstChild("Training Bells") then
                Teleport(workspace:FindFirstChild("Training Bells").CFrame)

                wait(0.1)

                local args = {
                    "StartQuest",
                    "Parkour Training"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                wait(0.1)

                local args = {
                    "GetQuestProgress",
                    "Parkour Training",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            else
                local args = {
                    "GetQuestProgress",
                    "Parkour Training",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                Notify("Not possible", "No Training Bells found.",2.5,"info")
            end
        elseif selectedquest == "Shark Girl" then

            local args = {
                [1] = "StartQuest",
                [2] = "A Run For Your Life"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            if workspace:FindFirstChild("The Scarlet Slowcoach") then
                if plr.Character.HumanoidRootPart then
                    for i, v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("BasePart") and v.CanCollide == true then
                            v.CanCollide = false
                        end
                    end

                    wait(0.05)
                    if workspace.RiverGearsActivation.Activated.Value == true then
                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(212.77771, -53.8684158, -814.37439, -0.99941355, 5.63199869e-08, -0.0342424773, 5.71334766e-08, 1, -2.27783321e-08, 0.0342424773, -2.47213645e-08, -0.99941355)

                        wait(0.05)

                        local args = {
                            [1] = "PlayerEvent",
                            [2] = "TheDeadRunner"
                        }

                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                        wait(0.5)

                        local args = {
                            [1] = "PlayerEvent",
                            [2] = "TheDeadRunner"
                        }

                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    else
                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(372.524658, 27.1627274, -1027.24524, -0.0282121263, -6.83527546e-08, 0.99960196, 7.51098881e-08, 1, 7.04998229e-08, -0.99960196, 7.70689397e-08, -0.0282121263)

                        wait(0.2)

                        local args = {
                            "ActivateButton",
                            workspace:WaitForChild("RiverGearsActivation")
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        wait(0.4)
                    end

                    plr.Character.HumanoidRootPart.CFrame = startpos
                end
            else
                Notify("The Quest", "has already been completed.", 2, "info")
            end


        elseif selectedquest == "Golem" then
            if tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text) < 120 then
                Notify("Requirements not met.", "You need to have at least 120 Ryo",2.5,"info")
                return
            end

            local args = {
                "StartQuest",
                "Search For A Flaming Heart"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)

            local args = {
                [1] = "Pay",
                [2] = 0,
                [3] = "Flaming Heart",
                [4] = 1,
                [5] = workspace:WaitForChild("Medic"):WaitForChild("HumanoidRootPart")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)
            
            local args = {
                "GetQuestProgress",
                "Search For A Flaming Heart"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))


        elseif selectedquest == "Oasis" then

            local mangothere = false

            if tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text) < 15 then
                Notify("Requirements not met.", "You need to have at least 15 Ryo",2.5,"info")
                return
            end

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Mango" then
                    local mangostr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    local mangoint =  tonumber(string.sub(mangostr, 2))
                    if mangoint then
                        if  mangoint > 2 then
                            mangothere = true
                            break
                        end
                    end
                end
            end

            if mangothere == false then
                Notify("Requirements not met.", "You need to have at least 3 Mangos",2.5,"info")
                return
            end

            
            local args = {
                [1] = "Pay",
                [3] = "Chicken",
                [4] = 2
            }
                        
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))


            local args = {
                "StartQuest",
                "An Extravagant Dish"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                [1] = "Pay",
                [3] = "Bowl",
                [4] = 1
            }
                        
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            wait(0.1)

            local args = {
                "PlaceBowl",
                workspace:WaitForChild("BowlHolderHallow")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Mango"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            wait(0.1)

            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Mango"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            wait(0.1)
            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Mango"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            wait(0.1)
            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Chicken"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            wait(0.1)
            
            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Chicken"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            wait(0.1)

            local args = {
                "BowlFinish",
                workspace:WaitForChild("BowlHolderHallow"):WaitForChild("BowlFinish")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            local args = {
                "GetQuestProgress",
                "An Extravagant Dish",
                "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
        elseif selectedquest == "Pickpocket" then
            -- Incase player already has mask in inventory

            local args = {
                "StartQuest",
                "Relic Retrieval"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                "GetQuestProgress",
                "Relic Retrieval",
                "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            if plr.Character.HumanoidRootPart then
                if workspace["Biyo Relic"] and workspace["Biyo Relic"].Transparency == 0 then
                    startpos = plr.Character.HumanoidRootPart.CFrame
                    local args = {
                        "StartQuest",
                        "Relic Retrieval"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                    
                    plr.Character.HumanoidRootPart.CFrame = CFrame.new(-607.182617, -188.449982, -549.910706, 0.99977237, 1.22664998e-08, -0.0213369261, -1.12036309e-08, 1, 4.9933135e-08, 0.0213369261, -4.96827148e-08, 0.99977237)
                    
                    local args = {
                        "Relic",
                        "Biyo Relic"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                    local mask = workspace["Biyo Relic"]
                    local timeout = 1.5
                    local startTime = tick()

                    while mask and mask.Transparency == 0 and tick() - startTime < timeout do
                        task.wait()
                        local args = {
                            "Relic",
                            "Biyo Relic"
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        
                    end

                    plr.Character.HumanoidRootPart.CFrame = startpos

                    local args = {
                        "GetQuestProgress",
                        "Relic Retrieval",
                        "DontComplete"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                    plr.Character.HumanoidRootPart.CFrame = startpos
                else
                    Notify("Mask not found","",1.5,"info")
                end
            end

        elseif selectedquest == "Lavarossa" then
            -- if the player already has the horns
            local args = {
                "StartQuest",
                "Humbling Lavarossa"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                "GetQuestProgress",
                "Humbling Lavarossa",
                "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local pickpocketinventory = false

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Pickpocket" then
                    pickpocketinventory = true
                    break
                end
            end

            local function TakeHorns()
                for i, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Lavarossa" and v:FindFirstChild("Horns").Transparency == 0 and v:FindFirstChild("Head") then
                        while workspace.Lavarossa.Horns.Transparency == 0 and plr.Character do
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Lavarossa.Head.CFrame

                            local args = {
                                "startSkill",
                                "Pickpocket",
                                vector.create(-730.5443115234375, -210.14356994628906, -553),
                                true
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                            local args = {
                                "ReleaseSkill"
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                            wait()
                        end
                        break
                    end
                end

                local args = {
                    "GetQuestProgress",
                    "Humbling Lavarossa",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                plr.Character.HumanoidRootPart.CFrame = startpos
            end

            if pickpocketinventory == true then
                if workspace:FindFirstChild("Lavarossa") and workspace.Lavarossa:FindFirstChild("Head") then
                    if workspace.Lavarossa.Horns.Transparency == 1 then
                        Notify("Boss doesn't have any horns.","",1.5,"info")
                        return
                    else
                        TakeHorns()
                    end
                else
                    -- Spawning the Boss
                    if workspace.LavarossaRewards.Part.Transparency == 1 then
                        if Teleport(CFrame.new(-536.194763, -314.055023, -201.574188, -0.159694523, 4.51376314e-09, 0.987166464, 4.54713767e-11, 1, -4.56508786e-09, -0.987166464, -6.84131751e-10, -0.159694523)) == false then return end
                        
                        wait(0.25)

                        local args = {
                            [1] = "activateLavarossa"
                        }
                            
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                        plr.Character.Humanoid.Jump = true

                        wait(0.5)

                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(-18.8846588, -278.715057, -482.883179, 0.000202000956, 1.24929542e-07, 1, 4.71037964e-09, 1, -1.24930494e-07, -1, 4.73561546e-09, 0.000202000956)
                        
                        wait(1.5)

                        TakeHorns()

                        plr.Character.HumanoidRootPart.CFrame = startpos
                    else
                        Notify("Boss has already been killed.", "Try again later.",2,"info")
                    end
                end
            else 
                Notify("Missing Requirements.", "You need to have Pickpocket.",2,"info")
            end

        elseif selectedquest == "Bolive Crops" then
            local args = {
                "StartQuest",
                "Bolive Retrieval"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)


            -- Check if 5 crops in inventory
            local bolivethere = false
            local orangeint = 0

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Bolive Crops" then
                    local orangestr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    orangeint = tonumber(string.sub(orangestr, 2))
                    if orangeint > 4 then
                        bolivethere = true
                        break
                    end
                end
            end

            if bolivethere then
                local args = {
                    "GetQuestProgress",
                    "Bolive Retrieval",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                return
            end

            -- Check for available crops
            local bolivecropscounter = 0

            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Bolive Crops" and v.Transparency == 0 then
                    bolivecropscounter += 1
                end
            end

            local neededcrops = 5 - orangeint
            if bolivecropscounter < neededcrops then
                Notify("Missing requirements", "No Bolive Crops Available.", 2.5, "info")
                return
            end

            local function nocliploop()
                for i, v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                    end
                end
            end

            noclippingcrop = RunService.Stepped:Connect(nocliploop)

            local pickedCropsCount = 0


            -- Water crops until enough obtained
            for i, v in pairs(workspace:GetChildren()) do
                if neededcrops <= 0 then break end
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Bolive Crops" and v.Transparency == 0 then
                    watercrops(v, 1)
                    neededcrops -= 1
                    wait()
                end
            end

            -- Disconnect noclip loop immediately after watering
            if noclippingcrop then
                noclippingcrop:Disconnect()
            end

            -- Wait until picked enough crops or timeout after 20 seconds
            local timeout = tick() + 20
            repeat
                wait(0.5)
            until pickedCropsCount >= (5 - orangeint) or tick() > timeout

            -- Final quest progress update
            wait(0.2)

            game:GetService("ReplicatedStorage").Events.DataFunction:InvokeServer("GetQuestProgress", "Bolive Retrieval", "DontComplete")


        elseif selectedquest == "Chakra Crops" then

            local args = {
                "StartQuest",
                "Search For The Chakra Crops"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)

            -- Check if 5 crops in inventory
            local chakrathere = false
            local chakraint = 0

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Chakra Crops" then
                    local chakrastr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    chakraint = tonumber(string.sub(chakrastr, 2))
                    if chakraint > 4 then
                        chakrathere = true
                        break
                    end
                end
            end

            if chakrathere then
                local args = {
                    "GetQuestProgress",
                    "Search For The Chakra Crops",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                return
            end

            -- Check available crops
            local chakracropscounter = 0

            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Chakra Crops" and v.Transparency == 0 then
                    chakracropscounter += 1
                end
            end

            local neededcrops = 5 - chakraint
            if chakracropscounter < neededcrops then
                Notify("Missing requirements", "No Chakra Crops Available.", 2.5, "info")
                return
            end

            local function nocliploop()
                for i, v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                    end
                end
            end

            noclippingcrop = RunService.Stepped:Connect(nocliploop)

            local pickedCropsCount = 0


            -- Water crops until enough obtained
            for i, v in pairs(workspace:GetChildren()) do
                if neededcrops <= 0 then break end
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Chakra Crops" and v.Transparency == 0 then
                    watercrops(v, 1)
                    neededcrops -= 1
                    wait()
                end
            end

            -- Disconnect noclip loop after watering
            if noclippingcrop then
                noclippingcrop:Disconnect()
                noclippingcrop = nil
            end

            -- Wait until picked enough crops or timeout after 20 seconds
            local timeout = tick() + 20
            repeat
                wait(0.5)
            until pickedCropsCount >= (5 - chakraint) or tick() > timeout
            -- Final quest progress update
            game:GetService("ReplicatedStorage").Events.DataFunction:InvokeServer("GetQuestProgress", "Search For The Chakra Crops", "DontComplete")


        elseif selectedquest == "Thirsty Hoshi" then
            local waterbowlthere = false
            local orangeint = 0
            
            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Freshwater Bowl" then
                    local orangestr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    orangeint =  tonumber(string.sub(orangestr, 2))
                    if orangeint > 0 then
                        waterbowlthere = true
                        break
                    end
                end
            end

            if waterbowlthere then
                    local args = {
                    [1] = "StartQuest",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                local args = {
                    [1] = "GetQuestProgress",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                return
            end

            local bowlthere = false
            local orangeint = 0
            
            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Bowl" then
                    local orangestr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    orangeint =  tonumber(string.sub(orangestr, 2))
                    if orangeint > 0 then
                        bowlthere = true
                        break
                    end
                end
            end
            
            local function usebowl()
                local args = {
                    "Item",
                    "Selected",
                    "Bowl"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    
                wait(0.2)
                
                local args = {
                    "FreshwaterBowl"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                
                wait(0.2)

                local args = {
                    [1] = "StartQuest",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                local args = {
                    [1] = "GetQuestProgress",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            end
            
            if bowlthere then
                usebowl()
            else
                if tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text) < 3 then
                    Notify("Missing requirements", "Missing 3 Ryo",2,"info")
                    return
                else
                    local args = {
                        [1] = "Pay",
                        [2] = 0,
                        [3] = "Bowl",
                        [4] = 1,
                        [5] = workspace:WaitForChild("TorchMesh")
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                    wait(0.3)

                    usebowl()
                end
            end
        elseif selectedquest == "Mail" then
            Teleport(CFrame.new(-668.973816, -194.109985, -268.560547, 0.0070860046, 2.33984299e-08, -0.999974906, -2.25259669e-08, 1, 2.32393944e-08, 0.999974906, 2.23607266e-08, 0.0070860046), true)

            local args = {
                [1] = "StartQuest",
                [2] = "InnKeeper's Reunion"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                [1] = "GetQuestProgress",
                [2] = "InnKeeper's Reunion",
                [3] = "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            wait(0.5)

            Teleport(CFrame.new(-36.1317406, -189.715057, -206.712875, 0.030850267, 9.54886659e-08, -0.999523997, 3.90593513e-08, 1, 9.67396971e-08, 0.999523997, -4.20252029e-08, 0.030850267), true)

            local args = {
                [1] = "StartQuest",
                [2] = "InnKeeper's Reunion"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                [1] = "GetQuestProgress",
                [2] = "InnKeeper's Reunion",
                [3] = "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            wait(0.5)

            Teleport(startpos, true)
        end
    end
end

features.ReturnMenu = function()
    TS:Teleport(5571328985)
end

-- MOVEMENT FEATURES

local function flyHack(state)
    if not state then
        if maid.flyBodyVelocity then
            maid.flyBodyVelocity:Destroy()
            maid.flyBodyVelocity = nil
        end
        if maid.flyStepped then
            maid.flyStepped:Disconnect()
            maid.flyStepped = nil
        end
        return
    end

    maid.flyBodyVelocity = Instance.new('BodyVelocity')
    maid.flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    maid.flyStepped = RunService.Stepped:Connect(function()
        if not Camera then return end

        local playerData = getPlayerData()
        local rootPart = playerData and playerData.rootPart
        if not rootPart then return end

        local moveVector = Vector3.new(0, 0, 0)
        local UserInputService = game:GetService("UserInputService")

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector += Vector3.new(0, 0, -1)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector += Vector3.new(0, 0, 1)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector += Vector3.new(-1, 0, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector += Vector3.new(1, 0, 0)
        end

        local cameraMoveVector = Camera.CFrame:VectorToWorldSpace(moveVector)
        maid.flyBodyVelocity.Parent = rootPart
        maid.flyBodyVelocity.Velocity = cameraMoveVector * getgenv().MovementSettings.FlySpeed
    end)
end

local defaultWalkSpeed = 16

local function speed(state)
    if not state then
        if maid.speedLoop then
            maid.speedLoop:Disconnect()
            maid.speedLoop = nil
        end
        
        local playerData = getPlayerData()
        local humanoid = playerData and playerData.humanoid
        if humanoid then
            humanoid.WalkSpeed = defaultWalkSpeed
        end
        return
    end

    maid.speedLoop = RunService.Stepped:Connect(function()
        local playerData = getPlayerData()
        local humanoid = playerData and playerData.humanoid
        if not humanoid then return end

        humanoid.WalkSpeed = getgenv().MovementSettings.WalkSpeed
    end)
end

local function noClip(state)
    if not state then
        if maid.noClipStep then
            maid.noClipStep:Disconnect()
            maid.noClipStep = nil
        end
        return
    end

    maid.noClipStep = RunService.Stepped:Connect(function()
        local playerData = getPlayerData()
        local character = playerData and playerData.character
        if not character then return end

        for _, part in pairs(character:GetDescendants()) do
            if part:IsA('BasePart') then
                part.CanCollide = false
            end
        end
    end)
end

-- VISUAL FEATURES

local function timeChanger(state)
    if not state then
        if maid.timeChanger then
            maid.timeChanger:Disconnect()
            maid.timeChanger = nil
        end
        return
    end

    local clockTimes = {
        Morning = 6.3,
        Afternoon = 14,
        Evening = 18,
        Night = 0
    }

    maid.timeChanger = RunService.RenderStepped:Connect(function()
        Lighting.ClockTime = clockTimes[getgenv().VisualSettings.TimeOfDay]
    end)
end

local oldFogEnd = Lighting.FogEnd

local function noFog(state)
    if not state then
        Lighting.FogEnd = oldFogEnd
        
        local invertedSphere = workspace:FindFirstChild("Debris") and workspace.Debris:FindFirstChild("InvertedSphere")
        if invertedSphere then
            invertedSphere.Transparency = 0
        end
        
        if maid.noFog then
            maid.noFog:Disconnect()
            maid.noFog = nil
        end
        return
    end

    local invertedSphere = workspace:FindFirstChild("Debris") and workspace.Debris:FindFirstChild("InvertedSphere")
    if invertedSphere then
        invertedSphere.Transparency = 1
    end

    maid.noFog = RunService.RenderStepped:Connect(function()
        Lighting.FogEnd = 9999999999
        
        local sphere = workspace:FindFirstChild("Debris") and workspace.Debris:FindFirstChild("InvertedSphere")
        if sphere then
            sphere.Transparency = 1
        end
    end)
end

local function noRain(state)
    if not state then
        if maid.noRainLoop then
            maid.noRainLoop = nil
        end
        return
    end

    maid.noRainLoop = task.spawn(function()
        while getgenv().VisualSettings.NoRain do
            local rainingValue = ReplicatedStorage:FindFirstChild("Raining")
            if rainingValue then
                rainingValue.Value = ''
            end
            task.wait()
        end
    end)
end

local oldBrightness = Lighting.Brightness

local function fullBright(state)
    if not state then
        Lighting.Brightness = oldBrightness
        if maid.fullBright then
            maid.fullBright:Disconnect()
            maid.fullBright = nil
        end
        return
    end

    maid.fullBright = RunService.RenderStepped:Connect(function()
        Lighting.Brightness = getgenv().VisualSettings.BrightnessLevel
    end)
end

-- AUTO-EQUIP WEAPON

local function equipWeapon(weaponName)
    pcall(function()
        dataEvent:FireServer("Item", "Selected", weaponName)
    end)
end

local function setupAutoEquip(state)
    if not state then
        if autoEquipConnection then
            autoEquipConnection:Disconnect()
            autoEquipConnection = nil
        end
        if autoEquipLoop then
            autoEquipLoop = nil
        end
        return
    end
    
    equipWeapon(getgenv().AutoEquipSettings.SelectedWeapon)
    
    autoEquipLoop = task.spawn(function()
        while getgenv().AutoEquipSettings.Enabled do
            equipWeapon(getgenv().AutoEquipSettings.SelectedWeapon)
            task.wait(2)
        end
    end)
    
    autoEquipConnection = dataEvent.OnClientEvent:Connect(function(eventType, ...)
        if not getgenv().AutoEquipSettings.Enabled then return end
        
        local args = {...}
        
        if eventType == "Item" and args[1] == "Unselected" then
            local unselectedWeapon = args[2]
            
            for _, weaponName in ipairs(weaponDatabase) do
                if unselectedWeapon == weaponName then
                    equipWeapon(getgenv().AutoEquipSettings.SelectedWeapon)
                    break
                end
            end
        end
    end)
end

getgenv().setupAutoEquip = setupAutoEquip

-- MISC FEATURES

local function autoPickup(state)
    if not state then
        if maid.autoPickup then
            maid.autoPickup:Disconnect()
            maid.autoPickup = nil
        end
        return
    end

    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}

    maid.autoPickup = RunService.Heartbeat:Connect(function()
        local player = LocalPlayer
        local char = player.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local parts = workspace:GetPartBoundsInBox(
            hrp.CFrame,
            Vector3.new(50, 50, 50),
            params
        )

        for _, v in ipairs(parts) do
            local distance = (v.Position - hrp.Position).Magnitude
            if distance > 25 then
                continue
            end

            -- Handle items with SpawnTime and ItemDetector (clickable items)
            if v:FindFirstChild("SpawnTime") and v:FindFirstChild("ItemDetector") then
                pcall(function()
                    fireclickdetector(v.ItemDetector)
                end)
            -- Handle regular pickupable items
            elseif v:FindFirstChild("Pickupable") and v:FindFirstChild("ID", true) then
                -- Skip distant items without ItemDetector
                if not v:FindFirstChild("ItemDetector") and distance > 15 then
                    continue
                end
                
                pcall(function()
                    local idValue = v:FindFirstChild("ID", true)
                    if idValue then
                        ReplicatedStorage.Events.DataEvent:FireServer("PickUp", idValue.Value)
                    end
                end)
            end
        end
    end)
end

local function noKillBricks(state)
    if state then
        for _, brick in pairs(killBricks) do
            if brick and brick.Parent then
                brick:Destroy()
            end
        end
    end
end

local function infiniteJumpCounter(state)
    if not state then
        if maid.infiniteJumpLoop then
            maid.infiniteJumpLoop = nil
        end
        return
    end

    maid.infiniteJumpLoop = task.spawn(function()
        while getgenv().MiscSettings.InfiniteJumpCounter do
            local playerFolder = ReplicatedStorage:FindFirstChild("Settings")
            if playerFolder then
                playerFolder = playerFolder:FindFirstChild(LocalPlayer.Name)
                if playerFolder then
                    local jumpCounters = playerFolder:FindFirstChild("JumpCounters")
                    if jumpCounters then
                        jumpCounters.Value = 5
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

local function chatLogger(state)
    if ChatLoggerFrame then
        ChatLoggerFrame.Visible = state
    end
end

local function noBlindness(state)
    if not state then
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local clientGui = playerGui:FindFirstChild("ClientGui")
            if clientGui then
                for _, child in pairs(clientGui:GetChildren()) do
                    if child:IsA("ImageLabel") and string.find(child.Name, "Blindness") then
                        child.Visible = true
                    end
                end
                
                for _, descendant in pairs(clientGui:GetDescendants()) do
                    if descendant:IsA("ImageLabel") and string.find(descendant.Name, "Blindness") then
                        descendant.Visible = true
                    end
                end
            end
        end
        
        if maid.noBlindnessLoop then
            maid.noBlindnessLoop = nil
        end
        return
    end

    maid.noBlindnessLoop = task.spawn(function()
        while getgenv().MiscSettings.NoBlindness do
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local clientGui = playerGui:FindFirstChild("ClientGui")
                if clientGui then
                    for _, child in pairs(clientGui:GetChildren()) do
                        if child:IsA("ImageLabel") and string.find(child.Name, "Blindness") then
                            child.Visible = false
                        end
                    end
                    
                    for _, descendant in pairs(clientGui:GetDescendants()) do
                        if descendant:IsA("ImageLabel") and string.find(descendant.Name, "Blindness") then
                            descendant.Visible = false
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

local function chakraCharge(state)
    if not state then
        pcall(function()
            ReplicatedStorage.Events.DataEvent:FireServer("StopCharging")
        end)
        
        if maid.chakraChargeLoop then
            maid.chakraChargeLoop = nil
        end
        return
    end

    maid.chakraChargeLoop = task.spawn(function()
        while getgenv().MiscSettings.ChakraCharge do
            pcall(function()
                ReplicatedStorage.Events.DataEvent:FireServer("Charging")
            end)
            task.wait(1.5)
        end
    end)
end

local function chakraBoost(state)
    if not state then
        if buffing then
            buffing:Disconnect()
            buffing = nil
        end
        if respawning then
            respawning:Disconnect()
            respawning = nil
        end
        return
    end

    local function buffchakra()
        local plr = game:GetService("Players").LocalPlayer
        local cooldown = false
        local chakra = plr.Backpack:FindFirstChild("chakra")
        if not chakra then return end
        
        local startval = chakra.Value
        
        buffing = chakra.Changed:Connect(function(newval)
            if newval > startval then
                if cooldown == true then
                    return
                end
                
                cooldown = true
                
                local newchakra = chakra.Value + chakrabuffamount
            
                if newchakra < plr.Backpack.maxChakra.Value then
                    local args = {
                        [1] = "TakeChakra",
                        [2] = chakrabuffamount * -1
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    chakra.Value = chakra.Value + chakrabuffamount
                end

                startval = newval

                task.wait(0.9)
                cooldown = false

            elseif startval > newval then
                startval = newval
            end
        end)
    end

    buffchakra()

    respawning = LocalPlayer.CharacterAdded:Connect(function()
        if buffing then
            buffing:Disconnect()
        end
        task.wait(1.3)
        buffchakra()
    end)
end

-- SPECTATE FEATURE

-- ============================================
-- SAFE SPOT SYSTEM (Add near the top with other utility variables)
-- ============================================

local safespotcf = nil

local function goToSafeSpot(dontteleport, shortloop)
    if safespotcf == nil then
        _G.NotificationLib:MakeNotification({
            Title = "Missing Safe Spot",
            Text = "Please set a safe spot first!",
            Duration = 3
        })
        return false
    end

    if dontteleport then
        return true
    end

    local playerData = getPlayerData()
    local hrp = playerData and playerData.rootPart
    if not hrp then return false end

    if not shortloop then
        hrp.CFrame = safespotcf
    else
        local startTime = tick()
        while tick() - startTime < 0.5 do
            hrp.CFrame = safespotcf
            task.wait()
        end
    end
    return true
end

-- ============================================
-- MODIFIED getSafeSpot FUNCTION
-- ============================================

local function getSafeSpot(config)
    -- Use global safe spot if set
    if safespotcf then
        return safespotcf.Position
    end
    
    -- Otherwise use default from config
    return config.defaultSafeSpot
end

local function getHumanoid(player)
    local character = player.Character or player.CharacterAdded:Wait()
    return character:WaitForChild("Humanoid", 5)
end

local function spectatePlayer(name)
    local targetPlayer = Players:FindFirstChild(name)
    if not targetPlayer then
        warn("Player not found:", name)
        return
    end
    
    local targetHumanoid = getHumanoid(targetPlayer)
    if not targetHumanoid then
        warn("Could not find humanoid for:", name)
        return
    end
    
    workspace.CurrentCamera.CameraSubject = targetHumanoid
    _G.NotificationLib:MakeNotification({
        Title = "Spectate",
        Text = string.format('Now spectating: %s', name),
        Duration = 2
    })
end

local function stopSpectating()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        workspace.CurrentCamera.CameraSubject = humanoid
    end
    
    currentSpectating = nil
    if lastLabel then
        lastLabel.TextColor3 = DEFAULT_COLOR
        lastLabel = nil
    end
end

local function connectTemplateClick(template)
    local connection = template.MouseButton1Click:Connect(function()
        local nameLabel = template:FindFirstChild("PlayerName")
        if nameLabel then
            local clickedName = nameLabel.Text
            
            if currentSpectating == clickedName then
                stopSpectating()
                _G.NotificationLib:MakeNotification({
                    Title = "Spectate",
                    Text = 'Stopped spectating',
                    Duration = 2
                })
                return
            end
            
            if lastLabel then
                lastLabel.TextColor3 = DEFAULT_COLOR
            end
            
            spectatePlayer(clickedName)
            currentSpectating = clickedName
            
            nameLabel.TextColor3 = HIGHLIGHT_COLOR
            lastLabel = nameLabel
        end
    end)
    
    table.insert(spectateConnections, connection)
end

local function setupSpectate()
    -- Clear existing connections
    for _, connection in pairs(spectateConnections) do
        connection:Disconnect()
    end
    spectateConnections = {}
    
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local clientGui = playerGui:WaitForChild("ClientGui")
    local mainframe = clientGui:WaitForChild("Mainframe")
    local list = mainframe:WaitForChild("PlayerList"):WaitForChild("List")
    
    for _, template in ipairs(list:GetChildren()) do
        if template:IsA("ImageButton") and template.Name == "PlayerTemplate" then
            connectTemplateClick(template)
        end
    end
    
    local childAddedConnection = list.ChildAdded:Connect(function(child)
        if child:IsA("ImageButton") and child.Name == "PlayerTemplate" then
            connectTemplateClick(child)
        end
    end)
    
    table.insert(spectateConnections, childAddedConnection)
end

-- Initialize spectate system automatically
setupSpectate()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    
    -- Always re-setup spectate on respawn
    setupSpectate()
    
    if currentSpectating then
        local savedTarget = currentSpectating
        currentSpectating = nil
        
        task.wait(0.5)
        spectatePlayer(savedTarget)
        currentSpectating = savedTarget
        
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local clientGui = playerGui:FindFirstChild("ClientGui")
            if clientGui then
                local mainframe = clientGui:FindFirstChild("Mainframe")
                if mainframe then
                    local list = mainframe:FindFirstChild("PlayerList") and mainframe.PlayerList:FindFirstChild("List")
                    if list then
                        for _, template in ipairs(list:GetChildren()) do
                            if template:IsA("ImageButton") and template.Name == "PlayerTemplate" then
                                local nameLabel = template:FindFirstChild("PlayerName")
                                if nameLabel and nameLabel.Text == savedTarget then
                                    nameLabel.TextColor3 = HIGHLIGHT_COLOR
                                    lastLabel = nameLabel
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- UTILITY FUNCTIONS

local function resetCharacter()
    local playerData = getPlayerData()
    local character = playerData and playerData.character
    if not character then return end

    character:BreakJoints()
end

local function instantLog()
    if inDanger then 
        _G.NotificationLib:MakeNotification({
            Title = "Cannot Log",
            Text = "You cannot do this right now. You are in danger.",
            Duration = 3
        })
        return 
    end

    LocalPlayer:Kick('')
    task.wait(2.5)
    game:Shutdown()
end

-- TELEPORT FUNCTIONS

local function teleportToChakraPoint()
    local selectedPoint = Options.ChakraPointDropdown.Value
    if not selectedPoint then return end

    local pos = chakraPointInstances[selectedPoint]
    if not pos then return end

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local distance = (rootPart.Position - pos).Magnitude
                    if distance <= 30 then
                        _G.NotificationLib:MakeNotification({
                            Title = "Teleport Blocked",
                            Text = string.format("%s is within 30m of this chakra point!", player.Name),
                            Duration = 3
                        })
                        return
                    end
                end
            end
        end
    end

    local playerData = getPlayerData()
    local rootPart = playerData and playerData.rootPart
    if not rootPart then return end

    rootPart.CFrame = CFrame.new(pos - Vector3.new(0, 0, 5), pos)
    
    _G.NotificationLib:MakeNotification({
        Title = "Teleported",
        Text = string.format("Teleported to %s", selectedPoint),
        Duration = 2
    })
end

local function forceteleportToChakraPoint()
    local selectedPoint = Options.ChakraPointDropdown.Value
    if not selectedPoint then return end

    local pos = chakraPointInstances[selectedPoint]
    if not pos then return end

    local playerData = getPlayerData()
    local rootPart = playerData and playerData.rootPart
    if not rootPart then return end

    rootPart.CFrame = CFrame.new(pos - Vector3.new(0, 0, 5), pos)
    
    _G.NotificationLib:MakeNotification({
        Title = "Teleported",
        Text = string.format("Teleported to %s", selectedPoint),
        Duration = 2
    })
end

local function teleportToNPC()
    local selectedNPC = Options.NPCDropdown.Value
    if not selectedNPC then return end

    local npc = npcInstances[selectedNPC]
    if not npc then return end

    local playerData = getPlayerData()
    local rootPart = playerData and playerData.rootPart
    if not rootPart then return end

    local main = npc.PrimaryPart or npc:FindFirstChild('Main') or npc:FindFirstChildWhichIsA('BasePart', true)
    if not main then return end

    rootPart.CFrame = CFrame.new(main.Position + Vector3.new(0, 0, -5), main.Position)
end

local function teleportToPlayer()
    local selectedPlayer = Options.PlayerDropdown.Value
    if not selectedPlayer then return end

    local player = Players:FindFirstChild(selectedPlayer)
    if not player then return end

    local targetData = getPlayerData(player)
    if not targetData or not targetData.rootPart then return end

    local playerData = getPlayerData()
    local rootPart = playerData and playerData.rootPart
    if not rootPart then return end

    rootPart.CFrame = targetData.rootPart.CFrame
end

-- FRUIT TELEPORT FUNCTIONS

local function countFruits()
    local lifeFruitPositions = {}
    local chakraFruitPositions = {}
    
    for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local posKey = getPositionKey(descendant.Position)
            
            if descendant.Name == "Life Up Fruit" then
                lifeFruitPositions[posKey] = true
            elseif descendant.Name == "Chakra Fruit" then
                chakraFruitPositions[posKey] = true
            end
        end
    end
    
    local lifeFruitCount = 0
    for _ in pairs(lifeFruitPositions) do
        lifeFruitCount = lifeFruitCount + 1
    end
    
    local chakraFruitCount = 0
    for _ in pairs(chakraFruitPositions) do
        chakraFruitCount = chakraFruitCount + 1
    end
    
    return lifeFruitCount, chakraFruitCount
end

local function isPlayerNearPosition(position, maxDistance)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local distance = (rootPart.Position - position).Magnitude
                    if distance <= maxDistance then
                        return true, player.Name, distance
                    end
                end
            end
        end
    end
    return false
end

local function findFruitInReplicatedStorage(fruitName)
    local availableFruits = {}
    
    for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Name == fruitName then
            local posKey = getPositionKey(descendant.Position)
            if not visitedFruits[posKey] then
                local playerNearby, playerName, distance = isPlayerNearPosition(descendant.Position, 100)
                if not playerNearby then
                    table.insert(availableFruits, descendant)
                end
            end
        end
    end
    
    if #availableFruits > 0 then
        return availableFruits[math.random(1, #availableFruits)]
    end
    
    return nil
end

local function teleportToFruit(fruitName)
    local fruit = findFruitInReplicatedStorage(fruitName)
    
    if not fruit then
        local totalFruits = 0
        local fruitsWithPlayers = 0
        
        for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Name == fruitName then
                local posKey = getPositionKey(descendant.Position)
                if not visitedFruits[posKey] then
                    totalFruits = totalFruits + 1
                    local playerNearby = isPlayerNearPosition(descendant.Position, 100)
                    if playerNearby then
                        fruitsWithPlayers = fruitsWithPlayers + 1
                    end
                end
            end
        end
        
        if fruitsWithPlayers > 0 then
            _G.NotificationLib:MakeNotification({
                Title = "Fruit Teleport Blocked",
                Text = string.format("All %s have players within 100m", fruitName),
                Duration = 3
            })
        else
            _G.NotificationLib:MakeNotification({
                Title = "Fruit Not Found",
                Text = string.format("No unvisited %s available", fruitName),
                Duration = 3
            })
        end
        return
    end
    
    local playerData = getPlayerData()
    local rootPart = playerData and playerData.rootPart
    if not rootPart then return end
    
    local posKey = getPositionKey(fruit.Position)
    visitedFruits[posKey] = true
    
    rootPart.CFrame = CFrame.new(fruit.Position + Vector3.new(0, 5, 0))
    
    _G.NotificationLib:MakeNotification({
        Title = "Teleported",
        Text = string.format("Teleported to %s", fruitName),
        Duration = 2
    })
end

local function teleportToLifeUpFruit()
    teleportToFruit("Life Up Fruit")
end

local function teleportToChakraFruit()
    teleportToFruit("Chakra Fruit")
end

local function showFruitCount()
    local lifeFruits, chakraFruits = countFruits()
    
    _G.NotificationLib:MakeNotification({
        Title = "Fruit Count",
        Text = string.format("Life Up Fruits: %d | Chakra Fruits: %d", lifeFruits, chakraFruits),
        Duration = 5
    })
end

-- BULK SELLER FUNCTIONS

local function sellAllFruits()
    task.spawn(function()
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local initialAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
        
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local DataFunction = ReplicatedStorage.Events.DataFunction
        local Merchant = workspace["Food Merchant"].HumanoidRootPart
        
        for i = 1, 2000 do
            local currentAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
            if currentAmount ~= initialAmount then
                break
            end
            
            task.spawn(function()
                DataFunction:InvokeServer("SellingBulk", i, "Fruit", "Fish", Merchant)
            end)
        end
    end)
end

local function sellAllTrinkets()
    task.spawn(function()
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local initialAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
        
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local DataFunction = ReplicatedStorage.Events.DataFunction
        local Merchant = workspace.Merchant.HumanoidRootPart
        
        for i = 1, 2000 do
            local currentAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
            if currentAmount ~= initialAmount then
                break
            end
            
            task.spawn(function()
                DataFunction:InvokeServer("SellingBulk", i, "Trinket", Merchant)
            end)
        end
    end)
end

local function sellAllGems()
    task.spawn(function()
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local initialAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
        
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local DataFunction = ReplicatedStorage.Events.DataFunction
        local Merchant = workspace.Merchant.HumanoidRootPart
        
        for i = 1, 2000 do
            local currentAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
            if currentAmount ~= initialAmount then
                break
            end
            
            task.spawn(function()
                DataFunction:InvokeServer("SellingBulk", i, "Gem", Merchant)
            end)
        end
    end)
end

-- AUTO SELL FUNCTIONS

local function autoSellFruits(state)
    if not state then
        if autoSellThreads.Fruits then
            task.cancel(autoSellThreads.Fruits)
            autoSellThreads.Fruits = nil
        end
        return
    end

    autoSellThreads.Fruits = task.spawn(function()
        while getgenv().AutoSellSettings.Fruits do
            task.spawn(function()
                pcall(function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local DataFunction = ReplicatedStorage.Events.DataFunction
                    local Merchant = workspace:FindFirstChild("Food Merchant")
                    
                    if Merchant then
                        local MerchantRoot = Merchant:FindFirstChild("HumanoidRootPart")
                        if MerchantRoot then
                            local LocalPlayer = game:GetService("Players").LocalPlayer
                            local initialAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
                            
                            for i = 1, 2000 do
                                local currentAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
                                if currentAmount ~= initialAmount then
                                    break
                                end
                                
                                DataFunction:InvokeServer("SellingBulk", i, "Fruit", "Fish", MerchantRoot)
                                task.wait(0.01)
                            end
                        end
                    end
                end)
            end)
            task.wait(20)
        end
    end)
end

local function autoSellTrinkets(state)
    if not state then
        if autoSellThreads.Trinkets then
            task.cancel(autoSellThreads.Trinkets)
            autoSellThreads.Trinkets = nil
        end
        return
    end

    autoSellThreads.Trinkets = task.spawn(function()
        while getgenv().AutoSellSettings.Trinkets do
            task.spawn(function()
                pcall(function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local DataFunction = ReplicatedStorage.Events.DataFunction
                    local Merchant = workspace:FindFirstChild("Merchant")
                    
                    if Merchant then
                        local MerchantRoot = Merchant:FindFirstChild("HumanoidRootPart")
                        if MerchantRoot then
                            local LocalPlayer = game:GetService("Players").LocalPlayer
                            local initialAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
                            
                            for i = 1, 2000 do
                                local currentAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
                                if currentAmount ~= initialAmount then
                                    break
                                end
                                
                                DataFunction:InvokeServer("SellingBulk", i, "Trinket", MerchantRoot)
                                task.wait(0.01)
                            end
                        end
                    end
                end)
            end)
            task.wait(20)
        end
    end)
end

local function autoSellGems(state)
    if not state then
        if autoSellThreads.Gems then
            task.cancel(autoSellThreads.Gems)
            autoSellThreads.Gems = nil
        end
        return
    end

    autoSellThreads.Gems = task.spawn(function()
        while getgenv().AutoSellSettings.Gems do
            task.spawn(function()
                pcall(function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local DataFunction = ReplicatedStorage.Events.DataFunction
                    local Merchant = workspace:FindFirstChild("Merchant")
                    
                    if Merchant then
                        local MerchantRoot = Merchant:FindFirstChild("HumanoidRootPart")
                        if MerchantRoot then
                            local LocalPlayer = game:GetService("Players").LocalPlayer
                            local initialAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
                            
                            for i = 1, 2000 do
                                local currentAmount = LocalPlayer.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text
                                if currentAmount ~= initialAmount then
                                    break
                                end
                                
                                DataFunction:InvokeServer("SellingBulk", i, "Gem", MerchantRoot)
                                task.wait(0.01)
                            end
                        end
                    end
                end)
            end)
            task.wait(20)
        end
    end)
end

-- INFINITE M1 SYSTEM

local function startInfiniteM1()
    if infiniteM1Running then return end
    
    infiniteM1Running = true
    
    local DataEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataEvent")
    local user = LocalPlayer.Name
    
    local weapontoautoequip = nil
    local success, playerdata = pcall(function()
        local remote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
        return remote:InvokeServer("GetData")
    end)
    
    if success and playerdata then
        weapontoautoequip = playerdata["CurrentWeapon"]
    end
    
    infiniteM1Thread = task.spawn(function()
        while getgenv().InfiniteM1Settings.Enabled do
            task.wait()
            
            local settingsFolder = ReplicatedStorage.Settings:FindFirstChild(user)
            if settingsFolder then
                local combatCount = settingsFolder:FindFirstChild("CombatCount")
                local currentWeapon = settingsFolder:FindFirstChild("CurrentWeapon")
                
                if combatCount and currentWeapon then
                    if currentWeapon.Value ~= "Fist" and currentWeapon.Value ~= "Tai" then
                        pcall(function()
                            DataEvent:FireServer("Item", "Unselected", weapontoautoequip)
                        end)
                    end
                    
                    if combatCount.Value > 3 then
                        if weapontoautoequip then
                            pcall(function()
                                DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                                DataEvent:FireServer("Item", "Unselected", weapontoautoequip)
                            end)
                        end
                    end
                end
            end
        end
    end)
    
    _G.NotificationLib:MakeNotification({
        Title = "Infinite M1",
        Text = "Enabled! (Only works with Tai/Fist)",
        Duration = 3
    })
end

local function stopInfiniteM1()
    infiniteM1Running = false
    
    if infiniteM1Thread then
        task.cancel(infiniteM1Thread)
        infiniteM1Thread = nil
    end
end

-- AUTO ACTIVATIONS SYSTEM

local function waitForHealthReset()
    print("[Auto Activations] Waiting for respawn...")
    LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
    
    local newCharacter = LocalPlayer.Character
    if newCharacter then
        local newHumanoid = newCharacter:WaitForChild("Humanoid", 5)
        if newHumanoid then
            local maxHealth = newHumanoid.MaxHealth
            
            repeat
                task.wait(0.1)
            until newHumanoid.Health >= maxHealth * 0.95
            
            task.wait(0.5)
        end
    end
end

local function runAutoActivation()
    local itemName = getgenv().AutoActivationsSettings.ItemName
    
    local playerData = getPlayerData()
    local rootPart = playerData and playerData.rootPart
    if not rootPart then 
        warn("[Auto Activations] Could not find HumanoidRootPart!")
        return 
    end
    
    rootPart.CFrame = CFrame.new(-2952, 321, -268)
    
    task.wait(0.1)
    
    pcall(function()
        ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", itemName)
    end)
    
    local character = LocalPlayer.Character
    if character then
        local forceField = character:FindFirstChild("ForceField")
        if forceField then
            forceField.Destroying:Wait()
        else
            print("[Auto Activations] No force field found, continuing...")
        end
    end
    
    pcall(function()
        ReplicatedStorage.Events.DataFunction:InvokeServer("Awaken", itemName)
    end)
    
    task.wait(0.5)
    
    character = LocalPlayer.Character
    if character then
        character:BreakJoints()
    end
    
    autoActivationsCount = autoActivationsCount + 1
    if autoActivationsLabel then
        autoActivationsLabel:SetText(string.format("Activations: %d", autoActivationsCount))
    end
    
    waitForHealthReset()
end

local function startAutoActivations()
    if autoActivationsRunning then return end
    
    autoActivationsRunning = true
    
    autoActivationsThread = task.spawn(function()
        while getgenv().AutoActivationsSettings.Enabled do
            runAutoActivation()
            task.wait(1)
        end
    end)
end

local function stopAutoActivations()
    autoActivationsRunning = false
    
    if autoActivationsThread then
        task.cancel(autoActivationsThread)
        autoActivationsThread = nil
    end
end

-- ============================================
-- PART 3: IMPROVED HALLOWEEN CANDY FARM SYSTEM
-- ============================================

-- LOAD HALLOWEEN FARM MODULE
if not _G.HalloweenFarmLib then
    _G.HalloweenFarmLib = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/VortexHubScripts/BloodlinesScript/refs/heads/main/HalloweenFarm.lua"))()
end

getgenv().inDanger = inDanger

-- HALLOWEEN CANDY FARM HELPER FUNCTIONS

local function getSafeSpot(config)
    local customSafeSpot = getgenv().HalloweenCandyFarmSettings.CustomSafeSpot
    
    if customSafeSpot then
        if type(customSafeSpot) == "table" then
            return Vector3.new(customSafeSpot.X or customSafeSpot.x, 
                             customSafeSpot.Y or customSafeSpot.y, 
                             customSafeSpot.Z or customSafeSpot.z)
        else
            return customSafeSpot
        end
    end
    
    return config.defaultSafeSpot
end

local function getCurrentBossConfig(bossName)
    local config = BOSS_CONFIGS[bossName]
    if not config then return nil end
    
    local configCopy = {}
    for k, v in pairs(config) do
        configCopy[k] = v
    end
    
    local bossSettings = getgenv().HalloweenCandyFarmSettings.BossSettings[bossName]
    if bossSettings then
        configCopy.farmDistance = bossSettings.FarmDistance
        if bossSettings.DodgeSpinAttack ~= nil then
            configCopy.dodgeSpinAttack = bossSettings.DodgeSpinAttack
        end
        if bossSettings.DodgeSpearAttack ~= nil then
            configCopy.dodgeSpearAttack = bossSettings.DodgeSpearAttack
        end
        if bossSettings.DodgeJumpSlamAttack ~= nil then
            configCopy.dodgeJumpSlamAttack = bossSettings.DodgeJumpSlamAttack
        end
    end
    
    return configCopy
end

local function isAnyoneActivelySensing()
    if not getgenv().activeSenseUsers then return false end
    
    for _, isActive in pairs(getgenv().activeSenseUsers) do
        if isActive then return true end
    end
    return false
end

local function checkNearbyPlayers(position, maxDistance)
    local player = Players.LocalPlayer
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local otherCharacter = otherPlayer.Character
            if otherCharacter then
                local otherRoot = otherCharacter:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local distance = (otherRoot.Position - position).Magnitude
                    if distance <= maxDistance then
                        return true, otherPlayer.Name
                    end
                end
            end
        end
    end
    return false, nil
end

local function serverHopSafely()
    local player = Players.LocalPlayer
    
    while inDanger do
        print("[Halloween Candy Farm] In danger, waiting before server hop...")
        wait(1)
    end
    
    print("[Halloween Candy Farm] Out of danger, initiating server hop...")
    
    local success, err = pcall(function()
        local playerGui = player:WaitForChild("PlayerGui", 5)
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
        
        if not list then return false end
        
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
                            button = joinButton,
                            playerCount = playerCount
                        })
                    end
                end
            end
        end
        
        if #validServers == 0 then return false end
        
        local randomServer = validServers[math.random(1, #validServers)]
        task.wait(0.1)
        
        pcall(function()
            for _, connection in pairs(getconnections(randomServer.button.MouseButton1Click)) do
                connection:Fire()
            end
        end)
        
        print("[Halloween Candy Farm] Joining server with " .. randomServer.playerCount .. " players...")
        return true
    end)
    
    return success
end

local function teleportToSafeSpotConstantly(config)
    return task.spawn(function()
        while getgenv().HalloweenCandyFarmSettings.Enabled do
            local player = Players.LocalPlayer
            local character = player.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(getSafeSpot(config))
                end
            end
            task.wait(0.1)
        end
    end)
end

local function monitorActiveSenseDuration()
    task.spawn(function()
        while getgenv().HalloweenCandyFarmSettings.Enabled do
            local currentlyActive = isAnyoneActivelySensing()
            
            if currentlyActive then
                if not activeSenseStartTime then
                    activeSenseStartTime = tick()
                    print(string.format("[Halloween Candy Farm] Active Sense detected, starting %d second timer...", 
                        getgenv().HalloweenCandyFarmSettings.ActiveSenseTimeout or 20))
                end
                
                if activeSenseStartTime then
                    local duration = tick() - activeSenseStartTime
                    local timeout = getgenv().HalloweenCandyFarmSettings.ActiveSenseTimeout or 20
                    
                    if duration >= timeout then
                        print(string.format("[Halloween Candy Farm] Active Sense exceeded %d seconds, initiating server hop...", timeout))
                        
                        activeSenseStartTime = nil
                        halloweenCandyFarmRunning = false
                        
                        local safeSpotTask = teleportToSafeSpotConstantly(BOSS_CONFIGS["Barbarit The Hallowed"])
                        
                        while getgenv().HalloweenCandyFarmSettings.Enabled do
                            serverHopSafely()
                            task.wait(2)
                        end
                        
                        if safeSpotTask then
                            task.cancel(safeSpotTask)
                        end
                        return
                    end
                end
            else
                if activeSenseStartTime then
                    print("[Halloween Candy Farm] Active Sense ended, resetting timer")
                    activeSenseStartTime = nil
                end
            end
            
            task.wait(1)
        end
    end)
end

local function setupChakraBuffing()
    local function bossBuffChakra()
        local chakra = LocalPlayer.Backpack:FindFirstChild("chakra")
        if not chakra then return end
        
        local startval = chakra.Value
                    
        bossCBuffing = chakra.Changed:Connect(function(newval)
            if newval < startval then
                local lostamount = startval - newval                      
                local newchakra = chakra.Value + lostamount
                if newval + lostamount <= LocalPlayer.Backpack.maxChakra.Value then
                    local args = {
                        [1] = "TakeChakra",
                        [2] = lostamount * -1
                    }
                            
                    ReplicatedStorage.Events.DataEvent:FireServer(unpack(args))
                    chakra.Value = newchakra
                end

                startval = newval

                if chakra.Value > LocalPlayer.Backpack.maxChakra.Value then
                    chakra.Value = LocalPlayer.Backpack.maxChakra.Value
                end
            else
                startval = newval
            end
        end)
    end

    bossBuffChakra()

    respawningBossChakra = LocalPlayer.CharacterAdded:Connect(function()
        if bossCBuffing then
            bossCBuffing:Disconnect()
        end
        wait(1.3)
        bossBuffChakra()
    end)
end

local function setupAnimationHiding()
    local track

    local function hideAnim()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://9864206537"

        track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Core
        track.Looped = true
        track:Play()

        stoppingAnim = animator.AnimationPlayed:Connect(function(newTrack)
            if newTrack ~= track then
                newTrack:Stop()
            end
        end)

        stoppingBurn = character.HumanoidRootPart.FireAilment.Played:Connect(function()
            ReplicatedStorage.Events.DataEvent:FireServer("RemoveFireAilment")
        end)
    end

    hideAnim()

    respawningAnimHide = LocalPlayer.CharacterAdded:Connect(function()
        if stoppingAnim then
            stoppingAnim:Disconnect()
        end
        wait(1.3)
        hideAnim()
    end)
    
    return track
end

local function setupSubSpamming()
    local DataEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataEvent")
    local subCooldownValue = ReplicatedStorage.Settings[LocalPlayer.Name]:FindFirstChild("SubCooldown")
    local cooldown = 8.5
    local lastSubChangeTime = tick()

    subCdConnection = subCooldownValue.Changed:Connect(function(newVal)
        lastSubChangeTime = tick()
    end)
    
    task.spawn(function()
        while halloweenCandyFarmRunning do 
            wait(0.2)
            if tick() - lastSubChangeTime >= cooldown then
                if LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
                    DataEvent:FireServer("TakeDamage", 0.000000001)
                    DataEvent:FireServer("Dash", "Sub", LocalPlayer.Character.HumanoidRootPart.Position)
                end
            end

            -- Auto block
            if ReplicatedStorage.Settings:FindFirstChild(LocalPlayer.Name) and 
               ReplicatedStorage.Settings[LocalPlayer.Name]:FindFirstChild("Blocking") then
                if ReplicatedStorage.Settings[LocalPlayer.Name].Blocking.Value == false then
                    ReplicatedStorage.Events.DataFunction:InvokeServer("Block")
                end
            end

            -- Auto charge
            local args = {"Charging"}
            ReplicatedStorage.Events.DataEvent:FireServer(unpack(args))
        end
    end)
end

local function cleanupCandyFarmSystems()
    print("[Halloween Candy Farm] Cleaning up systems...")
    
    if respawningAnimHide then
        respawningAnimHide:Disconnect()
        respawningAnimHide = nil
    end

    if stoppingAnim then
        stoppingAnim:Disconnect()
        stoppingAnim = nil
    end

    if stoppingBurn then
        stoppingBurn:Disconnect()
        stoppingBurn = nil
    end

    if subCdConnection then
        subCdConnection:Disconnect()
        subCdConnection = nil
    end

    if bossCBuffing then
        bossCBuffing:Disconnect()
        bossCBuffing = nil
    end

    if respawningBossChakra then
        respawningBossChakra:Disconnect()
        respawningBossChakra = nil
    end
    
    -- ADDED: Cancel attack loops
    if candyAttackLoop then
        task.cancel(candyAttackLoop)
        candyAttackLoop = nil
    end
    
    if candyM1Loop then
        task.cancel(candyM1Loop)
        candyM1Loop = nil
    end
    
    -- End block
    pcall(function()
        ReplicatedStorage.Events.DataFunction:InvokeServer("EndBlock")
    end)
    
    task.spawn(function()
        task.wait(0.1)
        pcall(function()
            ReplicatedStorage.Events.DataFunction:InvokeServer("EndBlock")
        end)
    end)
    
    print("[Halloween Candy Farm] Cleanup complete")
end

-- IMPROVED REWARD COLLECTION
local function collectRewards(config)
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    print("[Halloween Candy Farm] Teleporting to collection position...")
    hrp.CFrame = CFrame.new(config.collectionPosition)
    
    local bosspickuptable = {}
    local dropsthere = false
    
    local lootdropwait
    lootdropwait = workspace.ChildAdded:Connect(function(newthing)
        local idObject = newthing:FindFirstChild("ID") or newthing:FindFirstChildWhichIsA("StringValue", true)
        
        if not idObject then
            for _, desc in pairs(newthing:GetDescendants()) do
                if desc.Name == "ID" then
                    idObject = desc
                    break
                end
            end
        end

        if idObject then
            table.insert(bosspickuptable, {object = newthing, id = idObject})
            dropsthere = true
            wait(0.125)
        end
    end)

    -- Wait for drops
    repeat
        task.wait()
        if character and hrp then
            hrp.CFrame = CFrame.new(config.collectionPosition)
        end
    until dropsthere or not halloweenCandyFarmRunning

    task.wait(3)

    if dropsthere then
        for i = #bosspickuptable, 1, -1 do
            local entry = bosspickuptable[i]
            local v, idObject = entry.object, entry.id

            if v and v:IsDescendantOf(workspace) and idObject then
                local targetCFrame

                if v:IsA("BasePart") then
                    targetCFrame = v.CFrame * CFrame.new(0, 1, 0)
                else
                    for _, part in pairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            targetCFrame = part.CFrame * CFrame.new(0, 1, 0)
                            break
                        end
                    end
                end

                if targetCFrame and character and hrp then
                    hrp.CFrame = targetCFrame
                end

                local startTime = tick()
                while v and v:IsDescendantOf(workspace) and (tick() - startTime < 2) do
                    ReplicatedStorage.Events.DataEvent:FireServer("PickUp", idObject.Value)
                    task.wait()
                end

                table.remove(bosspickuptable, i)
            end
        end
    end

    task.wait(1)

    if lootdropwait then
        lootdropwait:Disconnect()
    end
    
    -- Collect candy drops
    for _, values in pairs(workspace:GetChildren()) do
        if values.Name == "Candy" and values:FindFirstChild(LocalPlayer.Name) then
            while values and values:IsDescendantOf(workspace) and halloweenCandyFarmRunning do
                wait()
                if character and hrp then
                    hrp.CFrame = values.CFrame
                end
                task.spawn(function()
                    wait(0.1)
                    for _, children in pairs(values:GetChildren()) do
                        if children:IsA("ClickDetector") then
                            fireclickdetector(children)
                        end
                    end
                end)
            end
        end
    end
end

-- IMPROVED ATTACK LOOP
local function startAttackLoop()
    task.spawn(function()
        while halloweenCandyFarmRunning do 
            task.wait(0.1)
            
            local userSettings = ReplicatedStorage.Settings:FindFirstChild(LocalPlayer.Name)
            if not userSettings then continue end

            local meleeCooldown = userSettings:WaitForChild("MeleeCooldown")

            -- Auto-equip weapon
            if getgenv().AutoEquipSettings and getgenv().AutoEquipSettings.Enabled and getgenv().AutoEquipSettings.SelectedWeapon then
                local weapontoautoequip = getgenv().AutoEquipSettings.SelectedWeapon
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("FakeHead") and 
                   LocalPlayer.Character.FakeHead:FindFirstChild("skillGUI") then
                    if LocalPlayer.Character.FakeHead.skillGUI.skillName.Text ~= weapontoautoequip then
                        wait(0.4)
                        ReplicatedStorage.Events.DataEvent:FireServer("Item", "Unselected", LocalPlayer.Character.FakeHead.skillGUI.skillName.Text)
                        ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                    end
                end
            end

            if meleeCooldown then
                local args = { [1] = "CheckMeleeHit", [3] = "NormalAttack", [4] = false }
                ReplicatedStorage.Events.DataEvent:FireServer(unpack(args))
                task.wait(0.15)
            else
                task.wait()
            end
        end
    end)
end

-- ============================================
-- IMPROVED CHAKRA BUFFING SYSTEM
-- ============================================

local function setupCandyChakraBuffing()
    local function candyBuffChakra()
        local chakra = LocalPlayer.Backpack:FindFirstChild("chakra")
        if not chakra then return end
        
        local startval = chakra.Value
                    
        bossCBuffing = chakra.Changed:Connect(function(newval)
            if not halloweenCandyFarmRunning then return end
            
            if newval < startval then
                local lostamount = startval - newval                      
                local newchakra = chakra.Value + lostamount
                if newval + lostamount <= LocalPlayer.Backpack.maxChakra.Value then
                    pcall(function()
                        ReplicatedStorage.Events.DataEvent:FireServer("TakeChakra", lostamount * -1)
                    end)
                    chakra.Value = newchakra
                end

                startval = newval

                if chakra.Value > LocalPlayer.Backpack.maxChakra.Value then
                    chakra.Value = LocalPlayer.Backpack.maxChakra.Value
                end
            else
                startval = newval
            end
        end)
    end

    candyBuffChakra()

    respawningBossChakra = LocalPlayer.CharacterAdded:Connect(function()
        if bossCBuffing then
            bossCBuffing:Disconnect()
        end
        task.wait(1.3)
        if halloweenCandyFarmRunning then
            candyBuffChakra()
        end
    end)
end

-- ============================================
-- IMPROVED ANIMATION HIDING SYSTEM
-- ============================================

local function setupCandyAnimationHiding()
    local track

    local function hideAnim()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://9864206537"

        track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Core
        track.Looped = true
        track:Play()

        stoppingAnim = animator.AnimationPlayed:Connect(function(newTrack)
            if halloweenCandyFarmRunning and newTrack ~= track then
                newTrack:Stop()
            end
        end)

        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("FireAilment") then
            stoppingBurn = hrp.FireAilment.Played:Connect(function()
                if halloweenCandyFarmRunning then
                    pcall(function()
                        ReplicatedStorage.Events.DataEvent:FireServer("RemoveFireAilment")
                    end)
                end
            end)
        end
    end

    hideAnim()

    respawningAnimHide = LocalPlayer.CharacterAdded:Connect(function()
        if stoppingAnim then
            stoppingAnim:Disconnect()
        end
        if stoppingBurn then
            stoppingBurn:Disconnect()
        end
        task.wait(1.3)
        if halloweenCandyFarmRunning then
            hideAnim()
        end
    end)
    
    return track
end

-- ============================================
-- IMPROVED SUB SPAMMING SYSTEM
-- ============================================

local function setupCandySubSpamming()
    local DataEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataEvent")
    local subCooldownValue = ReplicatedStorage.Settings[LocalPlayer.Name]:FindFirstChild("SubCooldown")
    local cooldown = 8.5
    local lastSubChangeTime = tick()

    if subCooldownValue then
        subCdConnection = subCooldownValue.Changed:Connect(function(newVal)
            lastSubChangeTime = tick()
        end)
    end
    
    task.spawn(function()
        while halloweenCandyFarmRunning do 
            task.wait(0.2)
            
            -- Sub spam
            if tick() - lastSubChangeTime >= cooldown then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        DataEvent:FireServer("TakeDamage", 0.000000001)
                        DataEvent:FireServer("Dash", "Sub", LocalPlayer.Character.HumanoidRootPart.Position)
                    end)
                end
            end

            -- Auto block
            local userSettings = ReplicatedStorage.Settings:FindFirstChild(LocalPlayer.Name)
            if userSettings and userSettings:FindFirstChild("Blocking") then
                if userSettings.Blocking.Value == false then
                    pcall(function()
                        ReplicatedStorage.Events.DataFunction:InvokeServer("Block")
                    end)
                end
            end

            -- Auto charge
            pcall(function()
                ReplicatedStorage.Events.DataEvent:FireServer("Charging")
            end)
        end
    end)
end

-- ============================================
-- IMPROVED ATTACK LOOP WITH AUTO-EQUIP
-- ============================================

local function startCandyAttackLoop()
    candyAttackLoop = task.spawn(function()
        while halloweenCandyFarmRunning do 
            task.wait(0.1)
            
            local userSettings = ReplicatedStorage.Settings:FindFirstChild(LocalPlayer.Name)
            if not userSettings then continue end

            local meleeCooldown = userSettings:FindFirstChild("MeleeCooldown")

            -- Auto-equip weapon
            if getgenv().AutoEquipSettings and getgenv().AutoEquipSettings.Enabled and getgenv().AutoEquipSettings.SelectedWeapon then
                local weapontoautoequip = getgenv().AutoEquipSettings.SelectedWeapon
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("FakeHead") then
                    local skillGUI = LocalPlayer.Character.FakeHead:FindFirstChild("skillGUI")
                    if skillGUI and skillGUI.skillName.Text ~= weapontoautoequip then
                        task.wait(0.4)
                        pcall(function()
                            ReplicatedStorage.Events.DataEvent:FireServer("Item", "Unselected", skillGUI.skillName.Text)
                            ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                        end)
                    end
                end
            end

            -- M1 attack
            if meleeCooldown then
                pcall(function()
                    ReplicatedStorage.Events.DataEvent:FireServer("CheckMeleeHit", nil, "NormalAttack", false)
                end)
                task.wait(0.15)
            end
        end
    end)
end

-- ============================================
-- IMPROVED INFINITE M1 FOR HEAVY WEAPONS
-- ============================================

local function startCandyInfiniteM1()
    if not getgenv().AutoEquipSettings or not getgenv().AutoEquipSettings.SelectedWeapon then
        return
    end

    local heavyWeapons = {
        "Golden Zabunagi", "Silver Zabunagi", "Onyx Zabunagi",
        "Samehada", "Executioner's Blade"
    }
    
    local weapontoautoequip = getgenv().AutoEquipSettings.SelectedWeapon
    local isHeavyWeapon = false
    
    for _, weapon in ipairs(heavyWeapons) do
        if weapontoautoequip == weapon then
            isHeavyWeapon = true
            break
        end
    end
    
    if not isHeavyWeapon then return end

    candyM1Loop = task.spawn(function()
        while halloweenCandyFarmRunning do
            task.wait()
            
            local userSettings = ReplicatedStorage.Settings:FindFirstChild(LocalPlayer.Name)
            if userSettings then
                local combatCount = userSettings:FindFirstChild("CombatCount")
                local currentWeapon = userSettings:FindFirstChild("CurrentWeapon")
                
                if combatCount and currentWeapon then
                    if currentWeapon.Value ~= "Fist" and currentWeapon.Value ~= "Tai" then
                        pcall(function()
                            ReplicatedStorage.Events.DataEvent:FireServer("Item", "Unselected", weapontoautoequip)
                        end)
                    end
                    
                    if combatCount.Value > 3 then
                        pcall(function()
                            ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                            ReplicatedStorage.Events.DataEvent:FireServer("Item", "Unselected", weapontoautoequip)
                        end)
                    end
                end
            end
        end
    end)
end

-- ============================================
-- ENHANCED REWARD COLLECTION
-- ============================================

local function collectCandyRewards(config)
    local player = LocalPlayer
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    print("[Halloween Candy Farm] Teleporting to collection position...")
    hrp.CFrame = CFrame.new(config.collectionPosition)
    
    local bosspickuptable = {}
    local dropsthere = false
    
    local lootdropwait = workspace.ChildAdded:Connect(function(newthing)
        local idObject = newthing:FindFirstChild("ID") or newthing:FindFirstChildWhichIsA("StringValue", true)
        
        if not idObject then
            for _, desc in pairs(newthing:GetDescendants()) do
                if desc.Name == "ID" then
                    idObject = desc
                    break
                end
            end
        end

        if idObject then
            table.insert(bosspickuptable, {object = newthing, id = idObject})
            dropsthere = true
            task.wait(0.125)
        end
    end)

    -- Wait for drops with timeout
    local waitStart = tick()
    repeat
        task.wait()
        if character and hrp then
            hrp.CFrame = CFrame.new(config.collectionPosition)
        end
    until dropsthere or not halloweenCandyFarmRunning or (tick() - waitStart) > config.collectScanDuration

    task.wait(3)

    -- Pickup all drops
    if dropsthere then
        for i = #bosspickuptable, 1, -1 do
            local entry = bosspickuptable[i]
            local v, idObject = entry.object, entry.id

            if v and v:IsDescendantOf(workspace) and idObject then
                local targetCFrame

                if v:IsA("BasePart") then
                    targetCFrame = v.CFrame * CFrame.new(0, 1, 0)
                else
                    for _, part in pairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            targetCFrame = part.CFrame * CFrame.new(0, 1, 0)
                            break
                        end
                    end
                end

                if targetCFrame and character and hrp then
                    hrp.CFrame = targetCFrame
                end

                local startTime = tick()
                while v and v:IsDescendantOf(workspace) and (tick() - startTime < 2) do
                    pcall(function()
                        ReplicatedStorage.Events.DataEvent:FireServer("PickUp", idObject.Value)
                    end)
                    task.wait()
                end

                table.remove(bosspickuptable, i)
            end
        end
    end

    task.wait(1)

    if lootdropwait then
        lootdropwait:Disconnect()
    end
    
    -- Enhanced candy collection
    for _, values in pairs(workspace:GetChildren()) do
        if values.Name == "Candy" and values:FindFirstChild(LocalPlayer.Name) then
            while values and values:IsDescendantOf(workspace) and halloweenCandyFarmRunning do
                task.wait()
                if character and hrp then
                    hrp.CFrame = values.CFrame
                end
                task.spawn(function()
                    task.wait(0.1)
                    for _, children in pairs(values:GetChildren()) do
                        if children:IsA("ClickDetector") then
                            pcall(function()
                                fireclickdetector(children)
                            end)
                        end
                    end
                end)
            end
        end
    end
end

-- ============================================
-- ENHANCED BOSS GRIP SYSTEM
-- ============================================

local function gripBoss(boss, bossHRP, bossHumanoid)
    if not boss or not bossHRP or not bossHumanoid then return end
    
    print("[Halloween Candy Farm] Boss health at 1, starting grip sequence...")
    task.wait(0.3)
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    gripAttempts = 0
    
    while gripAttempts < maxGripAttempts and boss and boss.Parent and halloweenCandyFarmRunning do
        hrp.CFrame = CFrame.new(bossHRP.Position)
        pcall(function()
            ReplicatedStorage.Events.DataEvent:FireServer("Grip")
        end)
        gripAttempts = gripAttempts + 1
        task.wait(0.25)
    end
    
    print("[Halloween Candy Farm] Grip attempts completed:", gripAttempts)
end

-- ============================================
-- CLEANUP FUNCTION
-- ============================================

local function cleanupCandyFarmSystems()
    print("[Halloween Candy Farm] Cleaning up systems...")
    
    if respawningAnimHide then
        respawningAnimHide:Disconnect()
        respawningAnimHide = nil
    end

    if stoppingAnim then
        stoppingAnim:Disconnect()
        stoppingAnim = nil
    end

    if stoppingBurn then
        stoppingBurn:Disconnect()
        stoppingBurn = nil
    end

    if subCdConnection then
        subCdConnection:Disconnect()
        subCdConnection = nil
    end

    if bossCBuffing then
        bossCBuffing:Disconnect()
        bossCBuffing = nil
    end

    if respawningBossChakra then
        respawningBossChakra:Disconnect()
        respawningBossChakra = nil
    end
    
    if candyAttackLoop then
        task.cancel(candyAttackLoop)
        candyAttackLoop = nil
    end
    
    if candyM1Loop then
        task.cancel(candyM1Loop)
        candyM1Loop = nil
    end
    
    -- End block
    pcall(function()
        ReplicatedStorage.Events.DataFunction:InvokeServer("EndBlock")
    end)
    
    task.spawn(function()
        task.wait(0.1)
        pcall(function()
            ReplicatedStorage.Events.DataFunction:InvokeServer("EndBlock")
        end)
    end)
    
    print("[Halloween Candy Farm] Cleanup complete")
end

-- IMPROVED BOSS FARMING FUNCTIONS

local function farmBarbarit()
    local config = getCurrentBossConfig("Barbarit The Hallowed")
    if not config then return false end
    
    local player = LocalPlayer
    local character = player.Character
    if not character then return false end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    print("[Halloween Candy Farm] Teleporting to Position 1...")
    hrp.CFrame = CFrame.new(config.spawnPosition1)
    task.wait(0.5)
    
    local playerNearby, playerName = checkNearbyPlayers(config.spawnPosition1, 100)
    if playerNearby then
        print(string.format("[Halloween Candy Farm] Player %s detected within 100m of Position 1, server hopping...", playerName))
        return "serverhop"
    end
    
    print("[Halloween Candy Farm] Teleporting to Position 2...")
    hrp.CFrame = CFrame.new(config.spawnPosition2)
    task.wait(0.5)
    
    playerNearby, playerName = checkNearbyPlayers(config.spawnPosition2, 100)
    if playerNearby then
        print(string.format("[Halloween Candy Farm] Player %s detected within 100m of Position 2, server hopping...", playerName))
        return "serverhop"
    end
    
    print(string.format("[Halloween Candy Farm] Scanning for boss (%dm range, %ds window)...", config.scanDistance, config.scanDuration))
    local scanStartTime = tick()
    local boss = nil
    local scanAttempts = 0
    local maxScanAttempts = math.ceil(config.scanDuration / config.scanInterval)
    
    while (tick() - scanStartTime) < config.scanDuration and scanAttempts < maxScanAttempts do
        scanAttempts = scanAttempts + 1
        
        pcall(function()
            for _, mob in pairs(workspace:GetChildren()) do
                if not halloweenCandyFarmRunning or not getgenv().HalloweenCandyFarmSettings.Enabled then
                    return
                end
                
                if mob.Name == "Barbarit The Hallowed" then
                    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                    local mobHumanoid = mob:FindFirstChild("Humanoid")
                    
                    if mobRoot and mobHumanoid then
                        local distance = (hrp.Position - mobRoot.Position).Magnitude
                        print(string.format("[Halloween Candy Farm] Found Barbarit The Hallowed at %dm (attempt %d/%d)", 
                            math.floor(distance), scanAttempts, maxScanAttempts))
                        
                        if distance <= config.scanDistance then
                            boss = mob
                            return
                        else
                            print(string.format("[Halloween Candy Farm] Boss too far away (%dm > %dm), continuing scan...", 
                                math.floor(distance), config.scanDistance))
                        end
                    else
                        print("[Halloween Candy Farm] Found Barbarit The Hallowed but missing components, waiting for model to load...")
                    end
                elseif mob.Name == "Barbarit The Rose" then
                    print("[Halloween Candy Farm] Found Barbarit The Rose (boss already defeated), skipping to safe spot...")
                    boss = "skip"
                    return
                end
            end
        end)
        
        if boss then break end
        task.wait(config.scanInterval)
    end
    
    if boss == "skip" then
        return "skip"
    elseif not boss then
        print(string.format("[Halloween Candy Farm] Boss not found after %d scan attempts, server hopping...", scanAttempts))
        return "serverhop"
    end
    
    local bossHRP = boss:FindFirstChild("HumanoidRootPart")
    local bossHumanoid = boss:FindFirstChild("Humanoid")
    if not bossHRP or not bossHumanoid then
        print("[Halloween Candy Farm] Boss missing components...")
        return "serverhop"
    end
    
    local bossAnimator = bossHumanoid:FindFirstChildOfClass("Animator")
    local isEvading = false
    
    print("[Halloween Candy Farm] Starting boss farm...")
    
    -- Setup enhanced systems
    setupCandyChakraBuffing()
    setupCandyAnimationHiding()
    setupCandySubSpamming()
    startCandyAttackLoop()
    startCandyInfiniteM1()
    
    -- FIXED: Dodge spin attack - check live settings
    task.spawn(function()
        while halloweenCandyFarmRunning and boss and boss.Parent and bossHumanoid.Health > 1 do
            -- CHANGED: Get fresh config each loop iteration
            local freshConfig = getCurrentBossConfig("Barbarit The Hallowed")
            
            if bossAnimator and freshConfig.dodgeSpinAttack and freshConfig.spinAttackAnimId then
                for _, track in pairs(bossAnimator:GetPlayingAnimationTracks()) do
                    if track.Animation.AnimationId == freshConfig.spinAttackAnimId then
                        isEvading = true
                        local safePos = bossHRP.Position + Vector3.new(0, freshConfig.safeHeight, 0)
                        hrp.CFrame = CFrame.new(safePos)
                        print("[Halloween Candy Farm] Dodging spin attack!")
                        track.Stopped:Wait()
                        task.wait(0.6)
                        isEvading = false
                    end
                end
            end
            task.wait(0.1)
        end
    end)
    
    local wasActivelySensing = false
    local safetySystemsActive = false
    local userSettings = ReplicatedStorage.Settings:FindFirstChild(LocalPlayer.Name)
    
    -- Main positioning loop
    while halloweenCandyFarmRunning and getgenv().HalloweenCandyFarmSettings.Enabled and boss and boss.Parent and bossHumanoid.Health > 1 do
        RunService.Heartbeat:Wait()
        
        if halloweenCandyFarmRunning and getgenv().HalloweenCandyFarmSettings.Enabled then
            local freshConfig = getCurrentBossConfig("Barbarit The Hallowed")
            local safetyModeActive = getgenv().HalloweenCandyFarmSettings.SafetyMode
            local currentlyActivelySensing = isAnyoneActivelySensing()
            
            -- Handle active sense detection
            if safetyModeActive and currentlyActivelySensing then
                if not wasActivelySensing then
                    print("[Halloween Candy Farm] Active sense detected, enabling safety systems...")
                    wasActivelySensing = true
                    safetySystemsActive = true
                    cleanupCandyFarmSystems()
                end
                
                hrp.CFrame = CFrame.new(getSafeSpot(freshConfig))
            elseif wasActivelySensing and not currentlyActivelySensing then
                print("[Halloween Candy Farm] Active sense ended, disabling safety systems...")
                wasActivelySensing = false
                safetySystemsActive = false
                
                -- Re-setup systems
                setupCandyChakraBuffing()
                setupCandyAnimationHiding()
                setupCandySubSpamming()
                startCandyAttackLoop()
                startCandyInfiniteM1()
            elseif userSettings and userSettings:FindFirstChild("Knocked") and userSettings.Knocked.Value == true then
                hrp.CFrame = CFrame.new(getSafeSpot(freshConfig))
            elseif isEvading then
                local safePos = bossHRP.Position + Vector3.new(0, freshConfig.safeHeight, 0)
                hrp.CFrame = CFrame.new(safePos)
            else
                local farmPos = bossHRP.Position + Vector3.new(0, freshConfig.farmDistance, 0)
                hrp.CFrame = CFrame.new(farmPos, bossHRP.Position)
            end
        end
    end
    
    -- Grip boss when health is low
    if boss and bossHRP and bossHumanoid and bossHumanoid.Health <= 1 then
        gripBoss(boss, bossHRP, bossHumanoid)
    end
    
    print("[Halloween Candy Farm] Waiting for boss to despawn...")
    while boss and boss.Parent do
        task.wait(0.1)
    end
    print("[Halloween Candy Farm] Boss defeated!")
    
    -- Collect rewards
    if getgenv().HalloweenCandyFarmSettings.CollectRewards then
        collectCandyRewards(config)
    end
    
    return "continue"
end


local function farmChakraKnight()
    local config = getCurrentBossConfig("Hallowed Chakra Knight")
    if not config then return false end
    
    local player = LocalPlayer
    local character = player.Character
    if not character then return false end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    print("[Halloween Candy Farm] Searching for Hallowed Chakra Knight in workspace...")
    local boss = workspace:FindFirstChild("Hallowed Chakra Knight")
    
    if not boss then
        print("[Halloween Candy Farm] Hallowed Chakra Knight not found in workspace")
        return "skip"
    end
    
    local bossHRP = boss:FindFirstChild("HumanoidRootPart")
    if not bossHRP then
        print("[Halloween Candy Farm] Boss missing HumanoidRootPart")
        return "skip"
    end
    
    -- Check for nearby rewards
    local rewardsFolder = workspace:FindFirstChild("ChakraKnightRewards")
    if rewardsFolder then
        local hasNearbyRewards = false
        
        for _, part in pairs(rewardsFolder:GetChildren()) do
            if part:IsA("BasePart") then
                local distance = (part.Position - bossHRP.Position).Magnitude
                if distance <= 300 then
                    hasNearbyRewards = true
                    print(string.format("[Halloween Candy Farm] Found reward part '%s' within %dm of knight", 
                        part.Name, math.floor(distance)))
                    break
                end
            end
        end
        
        if not hasNearbyRewards then
            print("[Halloween Candy Farm] No ChakraKnightRewards within 300m of knight, skipping")
            return "skip"
        end
    else
        print("[Halloween Candy Farm] ChakraKnightRewards folder not found in workspace, skipping")
        return "skip"
    end
    
    local bossHumanoid = boss:FindFirstChild("Humanoid")
    if not bossHumanoid then
        print("[Halloween Candy Farm] Boss missing Humanoid...")
        return "skip"
    end
    
    local bossAnimator = bossHumanoid:FindFirstChildOfClass("Animator")
    local isEvading = false
    
    print("[Halloween Candy Farm] Starting Chakra Knight farm...")
    
    -- Setup enhanced systems
    setupCandyChakraBuffing()
    setupCandyAnimationHiding()
    setupCandySubSpamming()
    startCandyAttackLoop()
    startCandyInfiniteM1()
    
    -- FIXED: Dodge spear and jump slam attacks - check live settings
    task.spawn(function()
        while halloweenCandyFarmRunning and boss and boss.Parent do
            -- CHANGED: Get fresh config each loop iteration
            local freshConfig = getCurrentBossConfig("Hallowed Chakra Knight")
            
            if bossAnimator then
                for _, track in pairs(bossAnimator:GetPlayingAnimationTracks()) do
                    local animId = track.Animation.AnimationId
                    
                    -- Check spear attack
                    if freshConfig.dodgeSpearAttack and animId == freshConfig.spearAttackAnimId then
                        isEvading = true
                        local safePos = bossHRP.Position + Vector3.new(0, freshConfig.safeHeight, 0)
                        hrp.CFrame = CFrame.new(safePos)
                        print("[Halloween Candy Farm] Dodging spear attack!")
                        track.Stopped:Wait()
                        task.wait(0.6)
                        isEvading = false
                    end
                    
                    -- Check jump slam attacks
                    if freshConfig.dodgeJumpSlamAttack then
                        for _, jumpSlamId in pairs(freshConfig.jumpSlamAnimIds) do
                            if animId == jumpSlamId then
                                isEvading = true
                                local safePos = bossHRP.Position + Vector3.new(0, freshConfig.safeHeight, 0)
                                hrp.CFrame = CFrame.new(safePos)
                                print("[Halloween Candy Farm] Dodging jump slam attack!")
                                track.Stopped:Wait()
                                task.wait(0.6)
                                isEvading = false
                                break
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
    
    -- Player proximity check
    local playerProximityCheck = task.spawn(function()
        while halloweenCandyFarmRunning and boss and boss.Parent do
            task.wait(0.5)
            
            local playerNearby, playerName, distance = checkNearbyPlayers(hrp.Position, 100)
            
            if playerNearby then
                print(string.format("[Halloween Candy Farm] Player %s detected at %dm during Chakra Knight farm, initiating server hop...", 
                    playerName, math.floor(distance)))
                
                halloweenCandyFarmRunning = false
                
                local safeSpotTask = teleportToSafeSpotConstantly(config)
                
                task.spawn(function()
                    task.wait(1)
                    while getgenv().HalloweenCandyFarmSettings.Enabled do
                        serverHopSafely()
                        task.wait(2)
                    end
                    
                    if safeSpotTask then
                        task.cancel(safeSpotTask)
                    end
                end)
                
                return
            end
        end
    end)
    
    local wasActivelySensing = false
    local safetySystemsActive = false
    local userSettings = ReplicatedStorage.Settings:FindFirstChild(LocalPlayer.Name)
    
    -- Main positioning loop
    while halloweenCandyFarmRunning and getgenv().HalloweenCandyFarmSettings.Enabled and boss and boss.Parent do
        RunService.Heartbeat:Wait()
        
        if halloweenCandyFarmRunning and getgenv().HalloweenCandyFarmSettings.Enabled then
            local freshConfig = getCurrentBossConfig("Hallowed Chakra Knight")
            local safetyModeActive = getgenv().HalloweenCandyFarmSettings.SafetyMode
            local currentlyActivelySensing = isAnyoneActivelySensing()
            
            -- Handle active sense detection
            if safetyModeActive and currentlyActivelySensing then
                if not wasActivelySensing then
                    print("[Halloween Candy Farm] Active sense detected, enabling safety systems...")
                    wasActivelySensing = true
                    safetySystemsActive = true
                    cleanupCandyFarmSystems()
                end
                
                hrp.CFrame = CFrame.new(getSafeSpot(freshConfig))
            elseif wasActivelySensing and not currentlyActivelySensing then
                print("[Halloween Candy Farm] Active sense ended, disabling safety systems...")
                wasActivelySensing = false
                safetySystemsActive = false
                
                -- Re-setup systems
                setupCandyChakraBuffing()
                setupCandyAnimationHiding()
                setupCandySubSpamming()
                startCandyAttackLoop()
                startCandyInfiniteM1()
            elseif userSettings and userSettings:FindFirstChild("Knocked") and userSettings.Knocked.Value == true then
                hrp.CFrame = CFrame.new(getSafeSpot(freshConfig))
            elseif isEvading then
                local safePos = bossHRP.Position + Vector3.new(0, freshConfig.safeHeight, 0)
                hrp.CFrame = CFrame.new(safePos)
            else
                local farmPos = bossHRP.Position + Vector3.new(0, freshConfig.farmDistance, 0)
                hrp.CFrame = CFrame.new(farmPos, bossHRP.Position)
            end
        end
    end
    
    if playerProximityCheck then
        task.cancel(playerProximityCheck)
    end
    
    print("[Halloween Candy Farm] Waiting for Chakra Knight to despawn...")
    while boss and boss.Parent do
        task.wait(0.1)
    end
    print("[Halloween Candy Farm] Chakra Knight defeated!")
    
    -- Collect rewards
    if getgenv().HalloweenCandyFarmSettings.CollectRewards then
        collectCandyRewards(config)
    end
    
    return "continue"
end



local function startHalloweenCandyFarm()
    if halloweenCandyFarmRunning then return end
    
    halloweenCandyFarmRunning = true
    
    -- Setup improved systems
    setupChakraBuffing()
    setupAnimationHiding()
    setupSubSpamming()
    
    monitorActiveSenseDuration()
    
    halloweenCandyFarmThread = task.spawn(function()
        while halloweenCandyFarmRunning and getgenv().HalloweenCandyFarmSettings.Enabled do  -- CHANGED: Added both checks
            local selectedBosses = getgenv().HalloweenCandyFarmSettings.SelectedBosses
            
            if table.find(selectedBosses, "Barbarit The Hallowed") then
                local result = farmBarbarit()
                
                -- ADDED: Check if farm was disabled during boss fight
                if not halloweenCandyFarmRunning or not getgenv().HalloweenCandyFarmSettings.Enabled then
                    print("[Halloween Candy Farm] Farm disabled, stopping...")
                    break
                end
                
                if result == "serverhop" then
                    local config = getCurrentBossConfig("Barbarit The Hallowed")
                    local player = Players.LocalPlayer
                    local character = player.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = CFrame.new(getSafeSpot(config))
                        end
                    end
                    
                    if not table.find(selectedBosses, "Hallowed Chakra Knight") then
                        local safeSpotTask = teleportToSafeSpotConstantly(config)
                        while halloweenCandyFarmRunning and getgenv().HalloweenCandyFarmSettings.Enabled do  -- CHANGED
                            serverHopSafely()
                            task.wait(2)
                        end
                        if safeSpotTask then task.cancel(safeSpotTask) end
                        break  -- CHANGED: from return to break
                    end
                elseif result == "skip" then
                    local config = getCurrentBossConfig("Barbarit The Hallowed")
                    local player = Players.LocalPlayer
                    local character = player.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = CFrame.new(getSafeSpot(config))
                        end
                    end
                    
                    if not table.find(selectedBosses, "Hallowed Chakra Knight") then
                        local safeSpotTask = teleportToSafeSpotConstantly(config)
                        while halloweenCandyFarmRunning and getgenv().HalloweenCandyFarmSettings.Enabled do  -- CHANGED
                            serverHopSafely()
                            task.wait(2)
                        end
                        if safeSpotTask then task.cancel(safeSpotTask) end
                        break  -- CHANGED: from return to break
                    end
                end
            end
            
            if table.find(selectedBosses, "Hallowed Chakra Knight") then
                local result = farmChakraKnight()
                
                -- ADDED: Check if farm was disabled during boss fight
                if not halloweenCandyFarmRunning or not getgenv().HalloweenCandyFarmSettings.Enabled then
                    print("[Halloween Candy Farm] Farm disabled, stopping...")
                    break
                end
                
                if result == "skip" or result == "continue" then
                    local config = getCurrentBossConfig("Hallowed Chakra Knight")
                    local player = Players.LocalPlayer
                    local character = player.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = CFrame.new(getSafeSpot(config))
                        end
                    end
                    
                    local safeSpotTask = teleportToSafeSpotConstantly(config)
                    while halloweenCandyFarmRunning and getgenv().HalloweenCandyFarmSettings.Enabled do  -- CHANGED
                        serverHopSafely()
                        task.wait(2)
                    end
                    if safeSpotTask then task.cancel(safeSpotTask) end
                    break  -- CHANGED: from return to break
                end
            end
            
            wait(1)
        end
        
        -- ADDED: Ensure cleanup happens
        print("[Halloween Candy Farm] Main loop ended, cleaning up...")
        cleanupBossFarmSystems()
    end)
end

local function stopHalloweenCandyFarm()
    halloweenCandyFarmRunning = false
    activeSenseStartTime = nil
    
    cleanupCandyFarmSystems()
    
    if halloweenCandyFarmThread then
        task.cancel(halloweenCandyFarmThread)
        halloweenCandyFarmThread = nil
    end
end

-- ============================================
-- PART 4: SEQUENTIAL TAB LOADING SYSTEM
-- ============================================

local loadingNotification

local function updateLoadingProgress(tabName, status)
    if loadingNotification then
        loadingNotification:Remove()
    end
    
    loadingNotification = _G.NotificationLib:MakeNotification({
        Title = "Loading Bishop Hub",
        Text = string.format("Loading %s... %s", tabName, status or ""),
        Duration = 999999
    })
end

-- ============================================
-- MAIN TAB LOADER
-- ============================================

local function loadMainTab()
    updateLoadingProgress("Main Tab", "Initializing...")
    
    local UtilityBox = Tabs.Main:AddRightGroupbox('Utility')
    local MiscBox = Tabs.Main:AddRightGroupbox('Misc Features')
    local VisualsBox = Tabs.Main:AddLeftGroupbox('Visual Features')
    local BulkSellerBox = Tabs.Main:AddLeftGroupbox('Bulk Seller')
    
    -- Visual Features
    VisualsBox:AddDropdown('TimeOfDay', {
        Values = { 'Morning', 'Afternoon', 'Evening', 'Night' },
        Default = 1,
        Multi = false,
        Text = 'Time Of Day',
        Callback = function(Value)
            getgenv().VisualSettings.TimeOfDay = Value
        end
    })

    VisualsBox:AddToggle('TimeChangerToggle', {
        Text = 'Time Changer',
        Default = false,
        Callback = function(Value)
            getgenv().VisualSettings.TimeChanger = Value
            timeChanger(Value)
        end
    })

    VisualsBox:AddToggle('NoFogToggle', {
        Text = 'No Fog',
        Default = false,
        Callback = function(Value)
            getgenv().VisualSettings.NoFog = Value
            noFog(Value)
        end
    })

    VisualsBox:AddToggle('NoRainToggle', {
        Text = 'No Rain',
        Default = false,
        Callback = function(Value)
            getgenv().VisualSettings.NoRain = Value
            noRain(Value)
        end
    })

    VisualsBox:AddToggle('FullBrightToggle', {
        Text = 'Full Bright',
        Default = false,
        Callback = function(Value)
            getgenv().VisualSettings.FullBright = Value
            fullBright(Value)
        end
    })

    VisualsBox:AddSlider('BrightnessLevel', {
        Text = 'Brightness Level',
        Default = 5,
        Min = 1,
        Max = 10,
        Rounding = 1,
        Callback = function(Value)
            getgenv().VisualSettings.BrightnessLevel = Value
        end
    })
    
    -- Bulk Seller
    BulkSellerBox:AddButton({
        Text = 'Sell All Fruits',
        Func = sellAllFruits,
        Tooltip = 'Runs sell command from 1 to 2000 for fruits'
    })

    BulkSellerBox:AddButton({
        Text = 'Sell All Trinkets',
        Func = sellAllTrinkets,
        Tooltip = 'Runs sell command from 1 to 2000 for trinkets'
    })

    BulkSellerBox:AddButton({
        Text = 'Sell All Gems',
        Func = sellAllGems,
        Tooltip = 'Runs sell command from 1 to 2000 for gems'
    })
    
    BulkSellerBox:AddDivider()
    BulkSellerBox:AddLabel('Auto Sell')

    BulkSellerBox:AddToggle('AutoSellFruits', {
        Text = 'Auto Sell Fruits',
        Default = false,
        Tooltip = 'Automatically sells fruits every 30 seconds',
        Callback = function(Value)
            getgenv().AutoSellSettings.Fruits = Value
            autoSellFruits(Value)
        end
    })

    BulkSellerBox:AddToggle('AutoSellTrinkets', {
        Text = 'Auto Sell Trinkets',
        Default = false,
        Tooltip = 'Automatically sells trinkets every 30 seconds',
        Callback = function(Value)
            getgenv().AutoSellSettings.Trinkets = Value
            autoSellTrinkets(Value)
        end
    })

    BulkSellerBox:AddToggle('AutoSellGems', {
        Text = 'Auto Sell Gems',
        Default = false,
        Tooltip = 'Automatically sells gems every 30 seconds',
        Callback = function(Value)
            getgenv().AutoSellSettings.Gems = Value
            autoSellGems(Value)
        end
    })
    
    -- Utility Box
    UtilityBox:AddButton({
        Text = 'Reset Character',
        Func = resetCharacter
    })

    UtilityBox:AddButton({
        Text = 'Auto Join Server',
        Func = function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            
            local success, err = pcall(function()
                local playerGui = player:WaitForChild("PlayerGui", 5)
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
                    print("First location empty or not found, trying MenuScreen location...")
                    
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
                
                if not list then
                    _G.NotificationLib:MakeNotification({
                        Title = "Auto Join Error",
                        Text = "Could not find server list!",
                        Duration = 3
                    })
                    return
                end
                
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
                                print("Found valid server with", playerCount, "players")
                            else
                                print("Skipped server with", playerCount or "unknown", "players")
                            end
                        end
                    end
                end
                
                if #validServers == 0 then
                    _G.NotificationLib:MakeNotification({
                        Title = "Auto Join",
                        Text = "No servers with 10+ players found!",
                        Duration = 3
                    })
                    return
                end
                
                local randomIndex = math.random(1, #validServers)
                local selectedServer = validServers[randomIndex]
                
                print("Attempting to join server with", selectedServer.playerCount, "players")
                
                task.wait(0.1)
                
                local clickSuccess = pcall(function()
                    for _, connection in pairs(getconnections(selectedServer.button.MouseButton1Click)) do
                        connection:Fire()
                    end
                end)
                
                if not clickSuccess then
                    pcall(function()
                        firesignal(selectedServer.button.MouseButton1Click)
                    end)
                end
                
                _G.NotificationLib:MakeNotification({
                    Title = "Auto Join",
                    Text = string.format("Joining server with %d players...", selectedServer.playerCount),
                    Duration = 3
                })
            end)
            
            if not success then
                warn("Auto Join Server failed:", err)
                _G.NotificationLib:MakeNotification({
                    Title = "Auto Join Error",
                    Text = "Failed to find server list!",
                    Duration = 3
                })
            end
        end
    })

    UtilityBox:AddButton({
        Text = 'Join Main Menu',
        Func = function(noclip)
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")

            local PLACE_ID = 5571328985

            local player = Players.LocalPlayer

            TeleportService:Teleport(PLACE_ID, player)
        end,
        DoubleClick = false,
    })

    local rebindingInstantLog = false

    UtilityBox:AddLabel('Instant Log'):AddKeyPicker('InstantLogKeybind', {
        Default = 'None',
        Text = 'Instant Log',
        NoUI = false,
        Mode = 'Toggle'
    })
    --[[
    UtilityBox:AddDivider()

    UtilityBox:AddToggle('GiveGripsFrags', {
        Text = 'Give Grips Frags',
        Default = false,
        Tooltip = 'Automatically teleports and takes damage for grips/frags',
        Callback = function(Value)
            if Value then
                task.spawn(function()
                    while Toggles.GiveGripsFrags and Toggles.GiveGripsFrags.Value do
                        local player = LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 2)

                        if hrp then
                            hrp.CFrame = CFrame.new(-2974.29443, 326.182709, 646.613159, -0.99941802, -2.79689978E-8, 0.0341118388, -2.78877685E-8, 1, 2.85709167e-09, -0.0341118388, 1.90412597e-09, -0.99941802)

                            local args = {"TakeDamage", 10000, "yes"}
                            local events = ReplicatedStorage:WaitForChild("Events")
                            events:WaitForChild("DataEvent"):FireServer(unpack(args))
                        end

                        task.wait()
                    end
                end)
            end
        end
    })]]

    local keybindObject = Options.InstantLogKeybind

    keybindObject:OnChanged(function()
        if keybindObject.Value ~= nil and keybindObject.Value ~= "None" then
            rebindingInstantLog = true
            task.delay(0.5, function()
                rebindingInstantLog = false
            end)
        end
    end)

    keybindObject:OnClick(function()
        if rebindingInstantLog then
            return
        end
        instantLog()
    end)
    
    -- Misc Features
    MiscBox:AddToggle('ChakraSenseAlert', {
        Text = 'Chakra Sense Alert',
        Default = true,
        Callback = function(Value)
            getgenv().MiscSettings.ChakraSenseAlert = Value
            
            if chakraSenseLabel then
                chakraSenseLabel.Visible = Value
            end
            if activeSenseLabel then
                activeSenseLabel.Visible = Value
            end
        end
    })

    MiscBox:AddToggle('ObserverAlert', {
        Text = 'Observer Alert',
        Default = true,
        Tooltip = 'Get notified when someone observes you',
        Callback = function(Value)
            getgenv().MiscSettings.ObserverAlert = Value
        end
    })
    --[[
    MiscBox:AddToggle('SpectateToggle', {
        Text = 'Spectate Mode',
        Default = false,
        Tooltip = 'Click on players in the player list to spectate them',
        Callback = function(Value)
            getgenv().MiscSettings.Spectate = Value
            setupSpectate(Value)
        end
    })]]

    MiscBox:AddToggle('AutoPickupToggle', {
        Text = 'Auto Pickup',
        Default = false,
        Callback = function(Value)
            getgenv().MiscSettings.AutoPickup = Value
            autoPickup(Value)
        end
    })

    MiscBox:AddToggle('NoKillBricksToggle', {
        Text = 'No Kill Bricks',
        Default = false,
        Callback = function(Value)
            getgenv().MiscSettings.NoKillBricks = Value
            noKillBricks(Value)
        end
    })

    MiscBox:AddToggle('InfiniteJumpCounterToggle', {
        Text = 'Infinite Jump Counter',
        Default = false,
        Callback = function(Value)
            getgenv().MiscSettings.InfiniteJumpCounter = Value
            infiniteJumpCounter(Value)
        end
    })
    
    MiscBox:AddToggle('NoBlindnessToggle', {
        Text = 'No Blindness',
        Default = false,
        Callback = function(Value)
            getgenv().MiscSettings.NoBlindness = Value
            noBlindness(Value)
        end
    })

    MiscBox:AddToggle('ChakraChargeToggle', {
        Text = 'Auto Chakra Charge',
        Default = false,
        Tooltip = 'Automatically charges chakra',
        Callback = function(Value)
            getgenv().MiscSettings.ChakraCharge = Value
            chakraCharge(Value)
        end
    })
    
    MiscBox:AddToggle('ChakraBoostToggle', {
        Text = 'Chakra Regen Boost',
        Default = false,
        Tooltip = 'Boosts chakra regeneration by selected amount',
        Callback = function(Value)
            getgenv().MiscSettings.ChakraBoost = Value
            chakraBoost(Value)
        end
    })

    MiscBox:AddSlider('ChakraBoostAmount', {
        Text = 'Select Buff Stage',
        Default = 1,
        Min = 1,
        Max = 6,
        Rounding = 0,
        Tooltip = 'Amount of chakra to boost per regeneration tick',
        Callback = function(Value)
            getgenv().MiscSettings.ChakraBoostAmount = Value
            chakrabuffamount = Value
        end
    })
    
    MiscBox:AddDropdown('EyeNotifyFilter', {
        Text = 'Eye Notification Filter',
        Values = allEyeTypes,
        Default = {},
        Multi = true,
        Callback = function(selected)
            selectedEyeTypes = selected
        end
    })

    MiscBox:AddToggle('NotifyWhenEyes', {
        Text = 'Notify When Eyes',
        Default = false,
        Callback = function(Value)
            notifyEyesRunning = Value

            for _, conn in pairs(notifyEyesConnections) do
                conn:Disconnect()
            end
            table.clear(notifyEyesConnections)

            if Value then
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local settingsFolder = ReplicatedStorage:WaitForChild("Settings")

                local function watchPlayerAwakened(playerFolder)
                    local awakenedValue = playerFolder:FindFirstChild("Awakened")
                    if awakenedValue and awakenedValue:IsA("StringValue") then
                        local lastValue = awakenedValue.Value

                        local conn = awakenedValue:GetPropertyChangedSignal("Value"):Connect(function()
                            local newValue = awakenedValue.Value
                            if newValue ~= lastValue then
                                lastValue = newValue

                                if selectedEyeTypes[newValue] then
                                    _G.NotificationLib:MakeNotification({
                                        Title = "Eyes Awakened",
                                        Text = string.format("%s awakened: %s", playerFolder.Name, newValue),
                                        Duration = 4
                                    })
                                end
                            end
                        end)
                        table.insert(notifyEyesConnections, conn)
                    end
                end

                for _, folder in ipairs(settingsFolder:GetChildren()) do
                    if folder:IsA("Folder") then
                        watchPlayerAwakened(folder)
                    end
                end

                local addedConn = settingsFolder.ChildAdded:Connect(function(child)
                    if child:IsA("Folder") then
                        watchPlayerAwakened(child)
                    end
                end)
                table.insert(notifyEyesConnections, addedConn)
            end
        end
    })
    
    updateLoadingProgress("Main Tab", "✓ Complete")
    return true
end

-- ============================================
-- ESP TAB LOADER
-- ============================================

local function loadESPTab()
    updateLoadingProgress("ESP Tab", "Initializing...")
    
    local PlayerESPBox = Tabs.ESP:AddLeftGroupbox('Player ESP')
    local ItemESPBox = Tabs.ESP:AddRightGroupbox('Item ESP')
    local FruitESPBox = Tabs.ESP:AddLeftGroupbox('Fruit ESP')
    local MobESPBox = Tabs.ESP:AddRightGroupbox('Mob ESP')
    
    -- Player ESP
    PlayerESPBox:AddToggle('ESPEnabled', {
        Text = 'Enable Player ESP',
        Default = getgenv().ESPSettings.Enabled,
        Callback = function(Value)
            getgenv().ESPSettings.Enabled = Value
        end
    })

    PlayerESPBox:AddDropdown('ESPShowDropdown', {
        Values = { 'Name', 'Health', 'Distance', 'Clan', 'FreshyChecker', 'JutsuPrediction' },
        Default = { 'Name', 'Health', 'Distance', 'Clan' },
        Multi = true,
        Text = 'Show Information',
        Callback = function(Value)
            getgenv().ESPSettings.Show = Value
        end
    })

    PlayerESPBox:AddSlider('ESPTextSize', {
        Text = 'Text Size',
        Default = getgenv().ESPSettings.TextSize,
        Min = 10,
        Max = 30,
        Rounding = 0,
        Callback = function(Value)
            getgenv().ESPSettings.TextSize = Value
        end
    })

    PlayerESPBox:AddSlider('ESPTextPos', {
        Text = 'Text Position',
        Default = getgenv().ESPSettings.TextPosition,
        Min = -50,
        Max = 50,
        Rounding = 0,
        Callback = function(Value)
            getgenv().ESPSettings.TextPosition = Value
        end
    })

    PlayerESPBox:AddSlider('ESPHealthBarWidth', {
        Text = 'Health Bar Width',
        Default = getgenv().ESPSettings.HealthBarWidth,
        Min = 2,
        Max = 10,
        Rounding = 0,
        Callback = function(Value)
            getgenv().ESPSettings.HealthBarWidth = Value
        end
    })

    PlayerESPBox:AddSlider('ESPBoxSize', {
        Text = 'Box Size Multiplier',
        Default = getgenv().ESPSettings.BoxSizeMultiplier,
        Min = 0.05,
        Max = 0.3,
        Rounding = 2,
        Callback = function(Value)
            getgenv().ESPSettings.BoxSizeMultiplier = Value
        end
    })

    PlayerESPBox:AddSlider('ESPMaxDistance', {
        Text = 'Max Distance',
        Default = getgenv().ESPSettings.MaxDistance,
        Min = 50,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            getgenv().ESPSettings.MaxDistance = Value
        end
    })
    
    -- Mob ESP
    MobESPBox:AddToggle('MobESPEnabled', {
        Text = 'Enable Mob ESP',
        Default = false,
        Callback = function(Value)
            getgenv().MobESPSettings.Enabled = Value
        end
    })

    MobESPBox:AddDropdown('MobESPShowDropdown', {
        Values = { 'Name', 'Health', 'Distance' },
        Default = { 'Name', 'Health', 'Distance' },
        Multi = true,
        Text = 'Show Information',
        Callback = function(Value)
            getgenv().MobESPSettings.Show = Value
        end
    })

    MobESPBox:AddSlider('MobESPTextSize', {
        Text = 'Text Size',
        Default = getgenv().MobESPSettings.TextSize,
        Min = 10,
        Max = 30,
        Rounding = 0,
        Callback = function(Value)
            getgenv().MobESPSettings.TextSize = Value
        end
    })

    MobESPBox:AddSlider('MobMaxDistance', {
        Text = 'Max Distance',
        Default = getgenv().MobESPSettings.MaxDistance,
        Min = 50,
        Max = 90000,
        Rounding = 0,
        Callback = function(Value)
            getgenv().MobESPSettings.MaxDistance = Value
        end
    })
    
    -- Item ESP
    ItemESPBox:AddToggle('ItemESPEnabled', {
        Text = 'Enable Item ESP',
        Default = false,
        Callback = function(Value)
            getgenv().ItemESPSettings.Enabled = Value
        end
    })

    ItemESPBox:AddDropdown('ItemESPShowDropdown', {
        Values = { 'Name', 'Distance' },
        Default = { 'Name', 'Distance' },
        Multi = true,
        Text = 'Show Information',
        Callback = function(Value)
            getgenv().ItemESPSettings.Show = Value
        end
    })

    ItemESPBox:AddSlider('ItemESPTextSize', {
        Text = 'Text Size',
        Default = getgenv().ItemESPSettings.TextSize,
        Min = 10,
        Max = 30,
        Rounding = 0,
        Callback = function(Value)
            getgenv().ItemESPSettings.TextSize = Value
        end
    })

    ItemESPBox:AddSlider('ItemMaxDistance', {
        Text = 'Max Distance',
        Default = getgenv().ItemESPSettings.MaxDistance,
        Min = 50,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            getgenv().ItemESPSettings.MaxDistance = Value
        end
    })
    
    -- Fruit ESP
    FruitESPBox:AddToggle('FruitESPEnabled', {
        Text = 'Enable Fruit ESP',
        Default = true,
        Callback = function(Value)
            getgenv().FruitESPSettings.Enabled = Value
        end
    })

    FruitESPBox:AddDropdown('FruitESPShowDropdown', {
        Values = { 'Name', 'Distance' },
        Default = { 'Name', 'Distance' },
        Multi = true,
        Text = 'Show Information',
        Callback = function(Value)
            getgenv().FruitESPSettings.Show = Value
        end
    })

    FruitESPBox:AddSlider('FruitESPTextSize', {
        Text = 'Text Size',
        Default = getgenv().FruitESPSettings.TextSize,
        Min = 10,
        Max = 30,
        Rounding = 0,
        Callback = function(Value)
            getgenv().FruitESPSettings.TextSize = Value
        end
    })

    FruitESPBox:AddSlider('FruitMaxDistance', {
        Text = 'Max Distance',
        Default = getgenv().FruitESPSettings.MaxDistance,
        Min = 50,
        Max = 99999,
        Rounding = 0,
        Callback = function(Value)
            getgenv().FruitESPSettings.MaxDistance = Value
        end
    })
    
    updateLoadingProgress("ESP Tab", "✓ Complete")
    return true
end

-- ============================================
-- AUTO FARM TAB LOADER
-- ============================================

local function loadAutoFarmTab()
    --[[ Add Ryo Farm section
    local RyoFarmBox = Tabs.AutoFarm:AddRightGroupbox('Ryo Farm')
    
    -- Initialize global Ryo farming state
    if not getgenv().Ryofarming then
        getgenv().Ryofarming = {Value = false}
    end
    
    if not getgenv().desiredRyoamount then
        getgenv().desiredRyoamount = nil
    end
    
    -- Helper function to check for crops
    local function checkForCrops()
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == "Crops" then
                return true
            end
        end
        return false
    end
    
    -- Helper function to water crops (placeholder - implement if you have the logic)
    local function waterCrops(crop, amount)
        -- TODO: Implement crop watering logic
        -- This function should handle watering the crop
        pcall(function()
            ReplicatedStorage.Events.DataEvent:FireServer("WaterCrop", crop, amount)
        end)
    end
    
    RyoFarmBox:AddToggle('RyoFarmToggle', {
        Text = 'Enable Ryo Farm',
        Default = false,
        Tooltip = 'Automatically farms oranges, cooks and sells Tangerina Fruit Bowls',
        Callback = function(Value)
            getgenv().Ryofarming.Value = Value
            
            if Value then
                task.spawn(function()
                    local player = LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local RunService = game:GetService("RunService")
                    
                    local isPickingUp = false
                    local hasOrangeDropped = false
                    local orangeDrops = {}
                    
                    -- Enable no fall damage
                    getgenv().MovementSettings.NoFallDamage = true
                    
                    -- No-clip function
                    local function noclipLoop()
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                    
                    -- Connect no-clip
                    local noclipConnection = RunService.Stepped:Connect(noclipLoop)
                    
                    -- Monitor for orange drops
                    local orangeDropConnection = workspace.ChildAdded:Connect(function(child)
                        if child:FindFirstChild("ID") then
                            hasOrangeDropped = true
                            if child.Name == "Orange" then
                                table.insert(orangeDrops, child)
                            end
                        end
                    end)
                    
                    -- Main farming loop
                    while getgenv().Ryofarming.Value do
                        local hasEnoughOranges = false
                        local hasBowl = false
                        
                        -- Check inventory
                        for _, descendant in pairs(player.PlayerGui.ClientGui.Mainframe.Loadout:GetDescendants()) do
                            if descendant.Name == "SlotText" and descendant.Text == "Orange" then
                                local numberText = descendant.Parent.ItemNumber.Number.Text
                                local count = tonumber(string.sub(numberText, 2))
                                if count and count > 2 then
                                    hasEnoughOranges = true
                                    break
                                end
                            end
                            if descendant.Name == "SlotText" and descendant.Text == "Bowl" then
                                hasBowl = true
                            end
                        end
                        
                        task.wait()
                        
                        if not hasEnoughOranges then
                            -- Sell what we have and continue farming
                            pcall(function()
                                ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", "Tangerina Fruit Bowl")
                                ReplicatedStorage.Events.DataFunction:InvokeServer("SellFood", "Tangerina Fruit Bowl", 15)
                            end)
                        else
                            -- Get bowl if we don't have one
                            if not hasBowl then
                                if checkForCrops() then
                                    -- Water crops
                                    for _, obj in pairs(workspace:GetChildren()) do
                                        if obj.Name == "Crops" and obj.Transparency == 0 then
                                            isPickingUp = true
                                            waterCrops(obj, 100)
                                            task.wait(0.2)
                                            isPickingUp = false
                                            break
                                        end
                                    end
                                else
                                    -- Buy bowl
                                    pcall(function()
                                        ReplicatedStorage.Events.DataFunction:InvokeServer("Pay", nil, "Bowl", 1)
                                    end)
                                end
                            end
                            
                            -- Place bowl and cook
                            local bowlHolder = workspace:WaitForChild("BowlHolderHallow", 5)
                            if bowlHolder then
                                pcall(function()
                                    ReplicatedStorage.Events.DataEvent:FireServer("PlaceBowl", bowlHolder)
                                    ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", "Tangerina Fruit Bowl")
                                    
                                    local cooker = workspace:WaitForChild("FruitCookerHallow", 5)
                                    if cooker then
                                        local cookingWater = cooker:WaitForChild("CookingWater", 5)
                                        if cookingWater then
                                            -- Add 3 oranges
                                            for i = 1, 3 do
                                                task.wait(0.1)
                                                ReplicatedStorage.Events.DataEvent:FireServer("AddFruit", cookingWater, "Orange")
                                            end
                                            
                                            -- Sell the bowl
                                            ReplicatedStorage.Events.DataFunction:InvokeServer("SellFood", "Tangerina Fruit Bowl", 15)
                                            task.wait(0.1)
                                            
                                            local bowlFinish = bowlHolder:WaitForChild("BowlFinish", 5)
                                            if bowlFinish then
                                                ReplicatedStorage.Events.DataEvent:FireServer("BowlFinish", bowlFinish)
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                        
                        -- Farm orange trees
                        for _, descendant in pairs(workspace:GetDescendants()) do
                            if descendant.Name == "FruitType" and descendant.Value == "Orange" and not descendant:GetAttribute("orange") then
                                local mainBranch = descendant.Parent:FindFirstChild("MainBranch")
                                if mainBranch then
                                    character.HumanoidRootPart.CFrame = mainBranch.CFrame
                                    
                                    -- Wait for oranges to drop
                                    local startTime = os.clock() + 12
                                    while os.clock() < startTime and not hasOrangeDropped do
                                        task.wait()
                                    end
                                    
                                    -- Pick up dropped oranges
                                    if hasOrangeDropped and #orangeDrops > 0 then
                                        local bodyVel = Instance.new("BodyVelocity")
                                        bodyVel.Velocity = Vector3.new(0, 0, 0)
                                        bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                                        bodyVel.Parent = character:FindFirstChild("HumanoidRootPart")
                                        
                                        for _, orange in ipairs(orangeDrops) do
                                            if orange:FindFirstChild("ID") then
                                                character.HumanoidRootPart.CFrame = orange.CFrame * CFrame.new(0, -6, 0)
                                                
                                                while orange and orange:IsDescendantOf(workspace) do
                                                    pcall(function()
                                                        ReplicatedStorage.Events.DataEvent:FireServer("PickUp", orange.ID.Value)
                                                    end)
                                                    task.wait()
                                                end
                                            end
                                        end
                                        
                                        table.clear(orangeDrops)
                                        bodyVel:Destroy()
                                        descendant:SetAttribute("orange", true)
                                        hasOrangeDropped = false
                                    end
                                end
                            end
                        end
                        
                        -- Reset orange attributes
                        for _, descendant in pairs(workspace:GetDescendants()) do
                            if descendant.Name == "FruitType" and descendant.Value == "Orange" and descendant:GetAttribute("orange") then
                                descendant:SetAttribute("orange", false)
                            end
                        end
                        
                        -- Check if desired Ryo amount is reached
                        if getgenv().desiredRyoamount then
                            local currentRyo = tonumber(player.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text:gsub(",", ""))
                            if currentRyo and currentRyo >= getgenv().desiredRyoamount then
                                getgenv().Ryofarming.Value = false
                                Toggles.RyoFarmToggle:SetValue(false)
                                
                                _G.NotificationLib:MakeNotification({
                                    Title = "Ryo Farm Complete",
                                    Text = string.format("Reached %d Ryo!", getgenv().desiredRyoamount),
                                    Duration = 5
                                })
                            end
                        end
                    end
                    
                    -- Cleanup
                    if noclipConnection then
                        noclipConnection:Disconnect()
                    end
                    if orangeDropConnection then
                        orangeDropConnection:Disconnect()
                    end
                    getgenv().MovementSettings.NoFallDamage = false
                    
                    _G.NotificationLib:MakeNotification({
                        Title = "Ryo Farm",
                        Text = "Farming stopped",
                        Duration = 2
                    })
                end)
            else
                getgenv().Ryofarming.Value = false
            end
        end
    })
    
    RyoFarmBox:AddInput('DesiredRyoInput', {
        Default = '10',
        Numeric = true,
        Text = 'Desired Ryo Amount',
        Placeholder = 'Enter number',
        Tooltip = 'Farm will stop automatically when this amount is reached',
        Callback = function(Value)
            local amount = tonumber(Value)
            if amount then
                getgenv().desiredRyoamount = amount
                _G.NotificationLib:MakeNotification({
                    Title = "Ryo Farm",
                    Text = string.format("Target set to %d Ryo", amount),
                    Duration = 2
                })
            else
                getgenv().desiredRyoamount = nil
            end
        end
    })
    
    RyoFarmBox:AddButton({
        Text = 'Sell All Tangerina Fruit Bowls',
        Func = function()
            pcall(function()
                ReplicatedStorage.Events.DataFunction:InvokeServer("SellFood", "Tangerina Fruit Bowl", 15)
            end)
            
            _G.NotificationLib:MakeNotification({
                Title = "Ryo",
                Text = "Sold all Tangerina Fruit Bowls",
                Duration = 3
            })
        end,
        Tooltip = 'Instantly sells all Tangerina Fruit Bowls in inventory'
    })]]
    updateLoadingProgress("Auto Farm Tab", "Initializing...")
    
    local MainBox = Tabs.AutoFarm:AddLeftGroupbox('Main Features')
    local SafeSpotBox = Tabs.AutoFarm:AddRightGroupbox('Safe Spot Settings')
    
    -- Main Features
    MainBox:AddDropdown('WeaponSelection', {
        Values = weaponDatabase,
        Default = 1,
        Multi = false,
        Text = 'Select Weapon',
        Tooltip = 'Choose which weapon to auto-equip',
        Callback = function(Value)
            getgenv().AutoEquipSettings.SelectedWeapon = Value
            
            if getgenv().AutoEquipSettings.Enabled then
                equipWeapon(Value)
            end
        end
    })

    MainBox:AddToggle('AutoEquipWeapon', {
        Text = 'Auto-Equip Weapon',
        Default = false,
        Tooltip = 'Automatically re-equips your selected weapon when unequipped',
        Callback = function(Value)
            getgenv().AutoEquipSettings.Enabled = Value
            setupAutoEquip(Value)
        end
    })

    MainBox:AddToggle('InfiniteM1Toggle', {
        Text = 'Infinite M1s (only Tai/Fist)',
        Default = false,
        Tooltip = 'Automatically resets combat counter for infinite M1 combos',
        Callback = function(Value)
            getgenv().InfiniteM1Settings.Enabled = Value
            
            if Value then
                startInfiniteM1()
            else
                stopInfiniteM1()
            end
        end
    })
    
    SafeSpotBox:AddButton({
        Text = 'Get Current Location',
        Func = function()
            local playerData = getPlayerData()
            local rootPart = playerData and playerData.rootPart
            if not rootPart then
                _G.NotificationLib:MakeNotification({
                    Title = "Position Error",
                    Text = "Could not get your current position!",
                    Duration = 3
                })
                return
            end

            local pos = rootPart.Position
            local coordString = string.format("%d,%d,%d", 
                math.floor(pos.X), 
                math.floor(pos.Y), 
                math.floor(pos.Z))

            if Options.SafeSpotInput then
                Options.SafeSpotInput:SetValue(coordString)
            end

            if setclipboard then
                setclipboard(coordString)
                _G.NotificationLib:MakeNotification({
                    Title = "Position Copied",
                    Text = "Copied to clipboard and input field!",
                    Duration = 2
                })
            else
                _G.NotificationLib:MakeNotification({
                    Title = "Position Copied",
                    Text = "Copied to input field!",
                    Duration = 2
                })
            end
        end,
        Tooltip = 'Copies your current position to clipboard and input field'
    })

    SafeSpotBox:AddInput('SafeSpotInput', {
        Default = "",
        Text = 'Safe Spot Coordinates',
        Placeholder = 'X,Y,Z (e.g., -2950,321,-275)',
        Callback = function(Text)
            if Text == "" then
                safespotcf = nil
                return
            end

            local unformattedText = Text
            local xStr, yStr, zStr = unformattedText:gsub("%s+", ""):match("([^,]+),([^,]+),([^,]+)")
            local x, y, z = tonumber(xStr), tonumber(yStr), tonumber(zStr)

            if x and y and z then
                safespotcf = CFrame.new(x, y, z)

                -- Save to config
                getgenv().HalloweenCandyFarmSettings.CustomSafeSpot = {
                    X = x,
                    Y = y,
                    Z = z
                }

                if SaveManager then
                    SaveManager:Save()
                end

                _G.NotificationLib:MakeNotification({
                    Title = "Safe Spot Set",
                    Text = string.format("Set to: %.0f, %.0f, %.0f", x, y, z),
                    Duration = 2
                })
            else
                safespotcf = nil
                _G.NotificationLib:MakeNotification({
                    Title = "Invalid Format",
                    Text = "Use format: X,Y,Z",
                    Duration = 2
                })
            end
        end
    })

    SafeSpotBox:AddButton({
        Text = 'Teleport to Safe Spot',
        Func = function()
            goToSafeSpot(false, false)
        end,
        Tooltip = 'Teleports you to the safe spot'
    })

    SafeSpotBox:AddButton({
        Text = 'Reset Safe Spot',
        Func = function()
            safespotcf = nil
            getgenv().HalloweenCandyFarmSettings.CustomSafeSpot = nil

            if Options.SafeSpotInput then
                Options.SafeSpotInput:SetValue("")
            end

            if SaveManager then
                SaveManager:Save()
            end

            _G.NotificationLib:MakeNotification({
                Title = "Safe Spot Reset",
                Text = "Cleared safe spot",
                Duration = 2
            })
        end,
        Tooltip = 'Clears the safe spot'
    })

    task.spawn(function()
        task.wait(1)
        local savedSpot = getgenv().HalloweenCandyFarmSettings.CustomSafeSpot
        if savedSpot and type(savedSpot) == "table" then
            local x, y, z = savedSpot.X or savedSpot.x, savedSpot.Y or savedSpot.y, savedSpot.Z or savedSpot.z
            if x and y and z then
                safespotcf = CFrame.new(x, y, z)
                if Options.SafeSpotInput then
                    Options.SafeSpotInput:SetValue(string.format("%d,%d,%d", 
                        math.floor(x), math.floor(y), math.floor(z)))
                end
                print("[Safe Spot] Loaded from config:", x, y, z)
            end
        end
    end)
    
    updateLoadingProgress("Auto Farm Tab", "✓ Complete")
    return true
end

-- ============================================
-- HALLOWEEN TAB LOADER
-- ============================================

local function loadHalloweenTab()
    updateLoadingProgress("Halloween Tab", "Initializing...")
    
    local PumpkinESPBox = Tabs.HalloweenFarm:AddLeftGroupbox('Pumpkin ESP')
    local PumpkinFarmBox = Tabs.HalloweenFarm:AddRightGroupbox('Pumpkin Point Farm')
    local HalloweenCandyBox = Tabs.HalloweenFarm:AddLeftGroupbox('Barbarit Farm')
    
    -- Pumpkin ESP
    PumpkinESPBox:AddToggle('PumpkinESPEnabled', {
        Text = 'Enable Pumpkin ESP',
        Default = false,
        Callback = function(Value)
            getgenv().PumpkinESPSettings.Enabled = Value
        end
    })

    PumpkinESPBox:AddDropdown('PumpkinESPShowDropdown', {
        Values = { 'Name', 'Distance' },
        Default = { 'Name', 'Distance' },
        Multi = true,
        Text = 'Show Information',
        Callback = function(Value)
            getgenv().PumpkinESPSettings.Show = Value
        end
    })

    PumpkinESPBox:AddSlider('PumpkinESPTextSize', {
        Text = 'Text Size',
        Default = getgenv().PumpkinESPSettings.TextSize,
        Min = 10,
        Max = 30,
        Rounding = 0,
        Callback = function(Value)
            getgenv().PumpkinESPSettings.TextSize = Value
        end
    })

    PumpkinESPBox:AddSlider('PumpkinMaxDistance', {
        Text = 'Max Distance',
        Default = getgenv().PumpkinESPSettings.MaxDistance,
        Min = 50,
        Max = 99999,
        Rounding = 0,
        Callback = function(Value)
            getgenv().PumpkinESPSettings.MaxDistance = Value
        end
    })
    
    -- Pumpkin Farm
    PumpkinFarmBox:AddToggle('HalloweenFarmToggle', {
        Text = 'Enable Halloween Farm',
        Default = false,
        Tooltip = 'Automatically farms Pumpkin Points with safety features',
        Callback = function(Value)
            getgenv().HalloweenFarmSettings.Enabled = Value

            if Value then
                local player = game:GetService("Players").LocalPlayer
                local playerGui = player:WaitForChild("PlayerGui", 5)
                local clientGui = playerGui:WaitForChild("ClientGui", 5)
                local menuScreen = clientGui:WaitForChild("MenuScreen", 5)
                local loadingScreen = menuScreen:WaitForChild("LoadingScreen", 5)
                
                while loadingScreen.BackgroundTransparency < 1 do
                    task.wait(0.1)
                end
                
                pcall(function()
                    local menu = menuScreen:FindFirstChild("Menu")
                    if menu then
                        local continueButton = menu:FindFirstChild("Continue")
                        if continueButton then
                            if getconnections then
                                for i,v in pairs(getconnections(continueButton.MouseButton1Down)) do
                                    v:Fire()
                                end
                            else
                                if firesignal then
                                    firesignal(continueButton.MouseButton1Down)
                                end
                            end
                        end
                    end
                end)
                
                task.wait(3)
                
                _G.HalloweenFarmLib.startFarm()
            else
                _G.HalloweenFarmLib.stopFarm()
            end
        end
    })

    PumpkinFarmBox:AddToggle('ServerHopWhenComplete', {
        Text = 'Server Hop When Complete',
        Default = true,
        Tooltip = 'Automatically server hop after all pumpkins are destroyed',
        Callback = function(Value)
            getgenv().HalloweenFarmSettings.ServerHopWhenComplete = Value
        end
    })

    PumpkinFarmBox:AddToggle('AutoPickupCandy', { 
        Text = 'Auto Pickup Candy', 
        Default = false,
        Tooltip = 'Automatically picks up candy drops from defeated mobs',
        Callback = function(Value)
            if Value then
                _G.HalloweenFarmLib.startAutoPickupCandy()
            else
                _G.HalloweenFarmLib.stopAutoPickupCandy()
            end
        end
    })

    PumpkinFarmBox:AddButton({
        Text = 'Auto Fill Basket',
        Func = function()
            _G.HalloweenFarmLib.autoFillBasket()
        end,
        Tooltip = 'Automatically runs trickOrTreat on all valid NPCs until basket has 8 visible candies'
    })

    PumpkinFarmBox:AddButton({
        Text = 'Reset Blacklisted Pumpkins',
        Func = function()
            _G.HalloweenFarmLib.resetBlacklist()
        end,
        Tooltip = 'Clears the blacklist of pumpkins'
    })

    PumpkinFarmBox:AddSlider('PumpkinFarmDistance', {
        Text = 'Pumpkin Farm Distance',
        Default = 7,
        Min = 3,
        Max = 20,
        Rounding = 1,
        Tooltip = 'Distance (in studs) to farm below the Pumpkin Point',
        Callback = function(Value)
            getgenv().HalloweenFarmSettings.PumpkinFarmDistance = Value
        end
    })

    PumpkinFarmBox:AddDivider()
    PumpkinFarmBox:AddLabel('Safety Features')

    PumpkinFarmBox:AddToggle('PanicMode', {
        Text = 'Panic Mode',
        Default = false,
        Tooltip = 'Server hops immediately when being observed (ignores danger status)',
        Callback = function(Value)
            getgenv().HalloweenFarmSettings.PanicMode = Value
            
            if _G.HalloweenFarmLib and _G.HalloweenFarmLib.updatePanicMode then
                _G.HalloweenFarmLib.updatePanicMode(Value)
            end
        end
    })

    PumpkinFarmBox:AddToggle('SafetyMode', {
        Text = 'Safety Mode',
        Default = false,
        Tooltip = 'Teleports to safe spot when any player uses Chakra Sense',
        Callback = function(Value)
            getgenv().HalloweenFarmSettings.SafetyMode = Value
            
            if _G.HalloweenFarmLib and _G.HalloweenFarmLib.updateSafetyMode then
                _G.HalloweenFarmLib.updateSafetyMode(Value)
            end
        end
    })

    PumpkinFarmBox:AddDivider()
    local targetLabel = PumpkinFarmBox:AddLabel('Current Target: None')
    local blacklistLabel = PumpkinFarmBox:AddLabel('Blacklisted Pumpkins: 0')

    task.spawn(function()
        while true do
            wait(0.5)
            
            local status = _G.HalloweenFarmLib.getFarmStatus()
            
            if targetLabel then
                if status.currentTarget then
                    targetLabel:SetText('Current Target: ' .. status.currentTarget)
                else
                    targetLabel:SetText('Current Target: None')
                end
            end
            
            if blacklistLabel then
                blacklistLabel:SetText('Blacklisted Pumpkins: ' .. status.blacklistedCount)
            end
        end
    end)
    
    -- Halloween Candy Farm (Barbarit)
    HalloweenCandyBox:AddDropdown('BossSelection', {
        Text = 'Select Bosses',
        Values = {'Barbarit The Hallowed', 'Hallowed Chakra Knight'},
        Default = 1,
        Multi = true,
        Callback = function(Value)
            local selectedArray = {}
            for bossName, isSelected in pairs(Value) do
                if isSelected then
                    table.insert(selectedArray, bossName)
                end
            end
            getgenv().HalloweenCandyFarmSettings.SelectedBosses = selectedArray
            
            if SaveManager then
                SaveManager:Save()
            end
            
            print("[Halloween Candy Farm] Selected bosses:", table.concat(selectedArray, ", "))
        end
    })

    HalloweenCandyBox:AddDivider()
    HalloweenCandyBox:AddLabel('Barbarit The Hallowed Settings')

    HalloweenCandyBox:AddSlider('BarbaritFarmDistance', {
        Text = 'Farm Distance',
        Default = 16,
        Min = 5,
        Max = 30,
        Rounding = 1,
        Tooltip = 'Distance to farm below Barbarit The Hallowed',
        Callback = function(Value)
            if not getgenv().HalloweenCandyFarmSettings.BossSettings then
                getgenv().HalloweenCandyFarmSettings.BossSettings = {}
            end
            if not getgenv().HalloweenCandyFarmSettings.BossSettings["Barbarit The Hallowed"] then
                getgenv().HalloweenCandyFarmSettings.BossSettings["Barbarit The Hallowed"] = {}
            end
            getgenv().HalloweenCandyFarmSettings.BossSettings["Barbarit The Hallowed"].FarmDistance = Value
            print(string.format("[Halloween Candy Farm] Barbarit farm distance set to: %d", Value))
        end
    })

    HalloweenCandyBox:AddToggle('BarbaritDodgeSpinAttack', {
        Text = 'Dodge Spin Attack',
        Default = false,
        Tooltip = 'Dodge Barbarit\'s spin attack',
        Callback = function(Value)
            if not getgenv().HalloweenCandyFarmSettings.BossSettings then
                getgenv().HalloweenCandyFarmSettings.BossSettings = {}
            end
            if not getgenv().HalloweenCandyFarmSettings.BossSettings["Barbarit The Hallowed"] then
                getgenv().HalloweenCandyFarmSettings.BossSettings["Barbarit The Hallowed"] = {}
            end
            getgenv().HalloweenCandyFarmSettings.BossSettings["Barbarit The Hallowed"].DodgeSpinAttack = Value
            print(string.format("[Halloween Candy Farm] Barbarit dodge spin attack set to: %s", tostring(Value)))
        end
    })

    HalloweenCandyBox:AddDivider()
    HalloweenCandyBox:AddLabel('Hallowed Chakra Knight Settings')

    HalloweenCandyBox:AddSlider('KnightFarmDistance', {
        Text = 'Farm Distance',
        Default = 16,
        Min = 5,
        Max = 30,
        Rounding = 1,
        Tooltip = 'Distance to farm below Hallowed Chakra Knight',
        Callback = function(Value)
            if not getgenv().HalloweenCandyFarmSettings.BossSettings then
                getgenv().HalloweenCandyFarmSettings.BossSettings = {}
            end
            if not getgenv().HalloweenCandyFarmSettings.BossSettings["Hallowed Chakra Knight"] then
                getgenv().HalloweenCandyFarmSettings.BossSettings["Hallowed Chakra Knight"] = {}
            end
            getgenv().HalloweenCandyFarmSettings.BossSettings["Hallowed Chakra Knight"].FarmDistance = Value
            print(string.format("[Halloween Candy Farm] Knight farm distance set to: %d", Value))
        end
    })

    HalloweenCandyBox:AddToggle('KnightDodgeSpearAttack', {
        Text = 'Dodge Spear Attack',
        Default = false,
        Tooltip = 'Dodge Knight\'s spear attack',
        Callback = function(Value)
            if not getgenv().HalloweenCandyFarmSettings.BossSettings then
                getgenv().HalloweenCandyFarmSettings.BossSettings = {}
            end
            if not getgenv().HalloweenCandyFarmSettings.BossSettings["Hallowed Chakra Knight"] then
                getgenv().HalloweenCandyFarmSettings.BossSettings["Hallowed Chakra Knight"] = {}
            end
            getgenv().HalloweenCandyFarmSettings.BossSettings["Hallowed Chakra Knight"].DodgeSpearAttack = Value
            print(string.format("[Halloween Candy Farm] Knight dodge spear attack set to: %s", tostring(Value)))
        end
    })

    HalloweenCandyBox:AddToggle('KnightDodgeJumpSlamAttack', {
        Text = 'Dodge Jump and Slam Attack',
        Default = false,
        Tooltip = 'Dodge Knight\'s jump and slam attack',
        Callback = function(Value)
            if not getgenv().HalloweenCandyFarmSettings.BossSettings then
                getgenv().HalloweenCandyFarmSettings.BossSettings = {}
            end
            if not getgenv().HalloweenCandyFarmSettings.BossSettings["Hallowed Chakra Knight"] then
                getgenv().HalloweenCandyFarmSettings.BossSettings["Hallowed Chakra Knight"] = {}
            end
            getgenv().HalloweenCandyFarmSettings.BossSettings["Hallowed Chakra Knight"].DodgeJumpSlamAttack = Value
            print(string.format("[Halloween Candy Farm] Knight dodge jump and slam attack set to: %s", tostring(Value)))
        end
    })

    HalloweenCandyBox:AddDivider()
    HalloweenCandyBox:AddLabel('Global Settings')

    HalloweenCandyBox:AddSlider('ActiveSenseTimeout', {
        Text = 'Active Sense Timeout (seconds)',
        Default = 20,
        Min = 5,
        Max = 60,
        Rounding = 1,
        Tooltip = 'Server hop if someone uses active Chakra Sense for longer than this',
        Callback = function(Value)
            getgenv().HalloweenCandyFarmSettings.ActiveSenseTimeout = Value
        end
    })

    HalloweenCandyBox:AddToggle('SafetyMode2', {
        Text = 'Safety Mode',
        Default = false,
        Tooltip = 'Teleport to safe spot when someone uses Chakra Sense actively',
        Callback = function(Value)
            getgenv().HalloweenCandyFarmSettings.SafetyMode = Value
        end
    })

    HalloweenCandyBox:AddToggle('CollectRewards', {
        Text = 'Collect Rewards',
        Default = true,
        Tooltip = 'Collect trinket rewards after defeating boss',
        Callback = function(Value)
            getgenv().HalloweenCandyFarmSettings.CollectRewards = Value
        end
    })

    HalloweenCandyBox:AddToggle('HalloweenCandyFarmToggle', {
        Text = 'Enable Halloween Candy Farm',
        Default = false,
        Tooltip = 'Automatically farms selected boss for candy',
        Callback = function(Value)
            getgenv().HalloweenCandyFarmSettings.Enabled = Value

            if Value then
                local player = game:GetService("Players").LocalPlayer
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local loadingScreen = player.PlayerGui.ClientGui.MenuScreen.LoadingScreen
                
                while loadingScreen.BackgroundTransparency < 1 or not replicatedStorage.Loaded:FindFirstChild(player.Name) do
                    task.wait(0.1)
                end
                
                task.wait(3)
                
                startHalloweenCandyFarm()
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Candy Farm",
                    Text = "Farm started!",
                    Duration = 3
                })
            else
                -- ADDED: Ensure the setting is set to false
                getgenv().HalloweenCandyFarmSettings.Enabled = false
                halloweenCandyFarmRunning = false
                stopHalloweenCandyFarm()
                
                -- ADDED: Notification
                _G.NotificationLib:MakeNotification({
                    Title = "Halloween Candy Farm",
                    Text = "Farm stopped!",
                    Duration = 3
                })
            end      
        end
    })
    
    updateLoadingProgress("Halloween Tab", "✓ Complete")
    return true
end

-- ============================================
-- TELEPORTS TAB LOADER
-- ============================================

local function loadTeleportsTab()
    updateLoadingProgress("Teleports Tab", "Initializing...")
    
    local BasicTeleportBox = Tabs.Teleport:AddLeftGroupbox('Basic Teleports')
    local FruitTeleportBox = Tabs.Teleport:AddRightGroupbox('Fruit Teleports')
    
    -- Basic Teleports
    BasicTeleportBox:AddDropdown('ChakraPointDropdown', {
        Values = chakraPoints,
        Default = 1,
        Multi = false,
        Text = 'Chakra Point',
    })

    BasicTeleportBox:AddButton({
        Text = 'Teleport To Chakra Point',
        Func = teleportToChakraPoint
    })

    BasicTeleportBox:AddButton({
        Text = 'Force Teleport To Chakra Point',
        Func = forceteleportToChakraPoint
    })

    BasicTeleportBox:AddDivider()

    BasicTeleportBox:AddDropdown('NPCDropdown', {
        Values = npcs,
        Default = 1,
        Multi = false,
        Text = 'NPCs',
    })

    BasicTeleportBox:AddButton({
        Text = 'Teleport To NPC',
        Func = teleportToNPC
    })

    BasicTeleportBox:AddDivider()

    BasicTeleportBox:AddDropdown('PlayerDropdown', {
        Values = {},
        Default = 1,
        Multi = false,
        Text = 'Players',
        SpecialType = 'Player'
    })

    BasicTeleportBox:AddButton({
        Text = 'Teleport To Player',
        Func = teleportToPlayer
    })
    
    -- Fruit Teleports
    FruitTeleportBox:AddButton({
        Text = 'Show Fruit Count',
        Func = showFruitCount,
        Tooltip = 'Shows how many Life Up Fruits and Chakra Fruits are available'
    })

    FruitTeleportBox:AddButton({
        Text = 'Teleport To Life Up Fruit',
        Func = teleportToLifeUpFruit,
        Tooltip = 'Teleports to unvisited Life Up Fruit (ESP removed when fruit spawns)'
    })

    FruitTeleportBox:AddButton({
        Text = 'Teleport To Chakra Fruit',
        Func = teleportToChakraFruit,
        Tooltip = 'Teleports to unvisited Chakra Fruit (ESP removed when fruit spawns)'
    })
    
    updateLoadingProgress("Teleports Tab", "✓ Complete")
    return true
end

-- ============================================
-- MISC TAB LOADER
-- ============================================

local function loadMiscTab()
    updateLoadingProgress("Misc Tab", "Initializing...")
    
    local MovementBox = Tabs.Music:AddLeftGroupbox('Movement')
    local OtherBox = Tabs.Music:AddLeftGroupbox('Other')
    
    -- Movement
    MovementBox:AddToggle('FlyToggle', {
        Text = 'Fly',
        Default = false,
        Tooltip = 'You can Fly',
        Callback = function(Value)
            getgenv().MovementSettings.Fly = Value
            flyHack(Value)
        end
    }):AddKeyPicker('FlyKeybind', {
        Default = 'None',
        Text = 'Fly',
        NoUI = false,
        Mode = 'Toggle',
        Callback = function(Value)
            getgenv().MovementSettings.Fly = Value
            flyHack(Value)
            Toggles.FlyToggle:SetValue(Value)
        end
    })

    MovementBox:AddSlider('FlySpeed', {
        Text = 'Fly Speed',
        Default = 50,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            getgenv().MovementSettings.FlySpeed = Value
        end
    })

    MovementBox:AddToggle('SpeedToggle', {
        Text = 'Speed',
        Default = false,
        Callback = function(Value)
            getgenv().MovementSettings.Speed = Value
            speed(Value)
        end
    }):AddKeyPicker('SpeedKeybind', {
        Default = 'None',
        Text = 'Speed',
        NoUI = false,
        Mode = 'Toggle',
        Callback = function(Value)
            getgenv().MovementSettings.Speed = Value
            speed(Value)
            Toggles.SpeedToggle:SetValue(Value)
        end
    })

    MovementBox:AddSlider('WalkSpeed', {
        Text = 'Walk Speed',
        Default = 50,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            getgenv().MovementSettings.WalkSpeed = Value
        end
    })

    MovementBox:AddToggle('NoClipToggle', {
        Text = 'No Clip',
        Default = false,
        Callback = function(Value)
            getgenv().MovementSettings.NoClip = Value
            noClip(Value)
        end
    }):AddKeyPicker('NoClipKeybind', {
        Default = 'None',
        Text = 'NoClip',
        NoUI = false,
        Mode = 'Toggle',
        Callback = function(Value)
            getgenv().MovementSettings.NoClip = Value
            noClip(Value)
            Toggles.NoClipToggle:SetValue(Value)
        end
    })

    MovementBox:AddToggle('NoFallDamage', {
        Text = 'No Fall Damage',
        Default = false,
        Callback = function(Value)
            getgenv().MovementSettings.NoFallDamage = Value
        end
    })
    
    -- Other
    OtherBox:AddLabel('Auto Activations')

    OtherBox:AddInput('AutoActivationsItemName', {
        Default = "Exact Item Name",
        Text = 'Item Name',
        Placeholder = 'Enter item name exactly',
        Callback = function(Value)
            getgenv().AutoActivationsSettings.ItemName = Value
        end
    })

    OtherBox:AddToggle('AutoActivationsToggle', {
        Text = 'Enable Auto Activations',
        Default = false,
        Tooltip = 'Automatically selects item, awakens, and repeats on respawn',
        Callback = function(Value)
            getgenv().AutoActivationsSettings.Enabled = Value
            
            if Value then
                autoActivationsCount = 0
                if autoActivationsLabel then
                    autoActivationsLabel:SetText("Auto Activations: 0")
                end
                startAutoActivations()
            else
                stopAutoActivations()
            end
        end
    })

    autoActivationsLabel = OtherBox:AddLabel("Auto Activations: 0")
    
    updateLoadingProgress("Misc Tab", "✓ Complete")
    return true
end

-- ============================================
-- QUESTS TAB LOADER
-- ============================================
--[[
local function loadQuestsTab()
    updateLoadingProgress("Quests Tab", "Initializing...")
    
    local QuestBox = Tabs.Quests:AddLeftGroupbox('Quest Controls')
    
    local questList = {
        "Passageway",
        "Flower Bouquet",
        "Crate Delivery",
        "Bells",
        "Shark Girl",
        "Golem",
        "Oasis",
        "Pickpocket",
        "Lavarossa",
        "Bolive Crops",
        "Chakra Crops",
        "Thirsty Hoshi",
        "Mail"
    }
    
    QuestBox:AddDropdown('QuestSelection', {
        Text = 'Select Quest',
        Default = 1,
        Values = questList,
        Multi = false,
        Callback = function(Value)
            selectedquest = Value
        end
    })
    
    QuestBox:AddButton({
        Text = 'Start Quest',
        Func = function()
            if not selectedquest or selectedquest == "" then
                _G.NotificationLib:MakeNotification({
                    Title = "No Quest Selected",
                    Text = "Please select a quest from the dropdown",
                    Duration = 2
                })
                return
            end
            
            task.spawn(function()
                local success, err = pcall(function()
                    features.DoQuest()
                end)
                
                if not success then
                    warn("[Quest Error]", err)
                    _G.NotificationLib:MakeNotification({
                        Title = "Quest Error",
                        Text = tostring(err),
                        Duration = 3
                    })
                end
            end)
        end,
        Tooltip = 'Starts the selected quest'
    })
    
    QuestBox:AddButton({
        Text = 'Return To Menu',
        Func = function()
            task.spawn(function()
                local success, err = pcall(function()
                    features.ReturnMenu()
                end)
                
                if not success then
                    warn("[Return Menu Error]", err)
                    _G.NotificationLib:MakeNotification({
                        Title = "Return Menu Error",
                        Text = tostring(err),
                        Duration = 3
                    })
                end
            end)
        end,
        Tooltip = 'Returns to the main menu'
    })
    
    updateLoadingProgress("Quests Tab", "✓ Complete")
    return true
end]]

-- ============================================
-- UI SETTINGS TAB LOADER
-- ============================================

local function loadUISettingsTab()
    updateLoadingProgress("UI Settings Tab", "Initializing...")
    
    SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

    Library:SetWatermarkVisibility(false)

    Library.KeybindFrame.Visible = false
    
    Tabs['UI Settings']:AddLeftGroupbox('Menu'):AddButton({
        Text = 'Unload', 
        Func = function() 
            Library:Unload() 
        end
    })
    
    Tabs['UI Settings']:AddLeftGroupbox('Menu'):AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { 
        Default = 'End', 
        NoUI = true, 
        Text = 'Menu keybind' 
    })

    Library.ToggleKeybind = Options.MenuKeybind

    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
    ThemeManager:SetFolder('Bishop Hub')
    SaveManager:SetFolder('Bishop Hub/Bloodlines')
    SaveManager:BuildConfigSection(Tabs['UI Settings'])
    ThemeManager:ApplyToTab(Tabs['UI Settings'])
    SaveManager:LoadAutoloadConfig()
    
    updateLoadingProgress("UI Settings Tab", "✓ Complete")
    return true
end

-- ============================================
-- MAIN SEQUENTIAL LOADER
-- ============================================

local function startSequentialLoading()
    task.spawn(function()
        local success, err
        
        -- Load Main Tab
        task.wait(0.5)
        success, err = pcall(loadMainTab)
        if not success then
            warn("[Loading Error] Main Tab:", err)
        end
        
        -- Load ESP Tab
        task.wait(0.5)
        success, err = pcall(loadESPTab)
        if not success then
            warn("[Loading Error] ESP Tab:", err)
        end
        
        -- Load Auto Farm Tab
        task.wait(0.5)
        success, err = pcall(loadAutoFarmTab)
        if not success then
            warn("[Loading Error] Auto Farm Tab:", err)
        end
        
        -- Load Halloween Tab
        task.wait(0.5)
        success, err = pcall(loadHalloweenTab)
        if not success then
            warn("[Loading Error] Halloween Tab:", err)
        end
        
        -- Load Teleports Tab
        task.wait(0.5)
        success, err = pcall(loadTeleportsTab)
        if not success then
            warn("[Loading Error] Teleports Tab:", err)
        end
        
        -- Load Misc Tab
        task.wait(0.5)
        success, err = pcall(loadMiscTab)
        if not success then
            warn("[Loading Error] Misc Tab:", err)
        end

        -- Load Quests Tab
        task.wait(0.5)
        success, err = pcall(loadQuestsTab)
        if not success then
            warn("[Loading Error] Quests Tab:", err)
        end
        
        -- Load UI Settings Tab
        task.wait(0.5)
        success, err = pcall(loadUISettingsTab)
        if not success then
            warn("[Loading Error] UI Settings Tab:", err)
        end
        
        -- Final notification
        if loadingNotification then
            loadingNotification:Remove()
        end
        
        _G.NotificationLib:MakeNotification({
            Title = "Bishop Hub",
            Text = "GUI has successfully loaded!",
            Duration = 5
        })
        
        -- Restore boss selection from config
        task.spawn(function()
            task.wait(1)
            if getgenv().HalloweenCandyFarmSettings and getgenv().HalloweenCandyFarmSettings.SelectedBosses then
                local savedBosses = getgenv().HalloweenCandyFarmSettings.SelectedBosses
                local selectionDict = {}
                for _, bossName in ipairs(savedBosses) do
                    selectionDict[bossName] = true
                end
                if Options.BossSelection then
                    Options.BossSelection:SetValue(selectionDict)
                end
                print("[Config] Restored boss selection:", table.concat(savedBosses, ", "))
            end
        end)
        
        print("[Bishop Hub] All tabs loaded successfully!")
    end)
end

-- ============================================
-- CLEANUP/UNLOAD SYSTEM
-- ============================================

Library:OnUnload(function()
    -- Disconnect movement features
    flyHack(false)
    speed(false)
    noClip(false)
    
    -- Disconnect visual features
    timeChanger(false)
    noFog(false)
    noRain(false)
    fullBright(false)
    
    -- Disconnect misc features
    autoPickup(false)
    setupSpectate(false)
    infiniteJumpCounter(false)
    chatLogger(false)
    noBlindness(false)
    chakraCharge(false)
    chakraBoost(false)
    
    -- Stop farming systems
    if getgenv().HalloweenFarmSettings and getgenv().HalloweenFarmSettings.Enabled then
        getgenv().HalloweenFarmSettings.Enabled = false
        if _G.HalloweenFarmLib and _G.HalloweenFarmLib.stopFarm then
            _G.HalloweenFarmLib.stopFarm()
        end
    end
    
    if getgenv().HalloweenCandyFarmSettings and getgenv().HalloweenCandyFarmSettings.Enabled then
        getgenv().HalloweenCandyFarmSettings.Enabled = false
        stopHalloweenCandyFarm()
    end
    
    if getgenv().BossFarmSettings and getgenv().BossFarmSettings.Enabled then
        getgenv().BossFarmSettings.Enabled = false
        if _G.BossFarmLib and _G.BossFarmLib.stop then
            _G.BossFarmLib.stop()
        end
    end
    
    -- Stop auto activations
    if getgenv().AutoActivationsSettings and getgenv().AutoActivationsSettings.Enabled then
        getgenv().AutoActivationsSettings.Enabled = false
        stopAutoActivations()
    end
    
    -- Stop auto-equip weapon
    if getgenv().AutoEquipSettings and getgenv().AutoEquipSettings.Enabled then
        getgenv().AutoEquipSettings.Enabled = false
        setupAutoEquip(false)
    end
    
    -- Stop infinite M1
    if getgenv().InfiniteM1Settings and getgenv().InfiniteM1Settings.Enabled then
        getgenv().InfiniteM1Settings.Enabled = false
        stopInfiniteM1()
    end
    
    -- Stop auto sell
    if getgenv().AutoSellSettings then
        if getgenv().AutoSellSettings.Fruits then
            getgenv().AutoSellSettings.Fruits = false
            autoSellFruits(false)
        end
        if getgenv().AutoSellSettings.Trinkets then
            getgenv().AutoSellSettings.Trinkets = false
            autoSellTrinkets(false)
        end
        if getgenv().AutoSellSettings.Gems then
            getgenv().AutoSellSettings.Gems = false
            autoSellGems(false)
        end
    end

    -- Stop Ryo farming
    if getgenv().Ryofarming and getgenv().Ryofarming.Value then
        getgenv().Ryofarming.Value = false
        if Toggles.RyoFarmToggle then
            Toggles.RyoFarmToggle:SetValue(false)
        end
    end
    
    -- Clean up ESP module
    if _G.ESPModule then
        _G.ESPModule.Cleanup()
    end
    
    -- Clean up spectate connections
    for _, connection in pairs(spectateConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    spectateConnections = {}
    
    -- Clean up jutsu prediction connections
    for playerName, connections in pairs(jutsuConnections) do
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
    jutsuConnections = {}
    
    -- Clean up animation connections
    for playerName, connections in pairs(animationConnections) do
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
    animationConnections = {}
    
    -- Clean up observer connections
    for _, connection in pairs(observerConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    observerConnections = {}
    
    -- Clean up chakra sense skill connections
    for playerName, connections in pairs(chakraSenseSkillConnections) do
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
    chakraSenseSkillConnections = {}
    
    -- Clean up eye notification connections
    for _, conn in pairs(notifyEyesConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    notifyEyesConnections = {}
    
    -- Clean up GUI elements
    if ChatLoggerFrame and ChatLoggerFrame.Parent then
        ChatLoggerFrame.Parent:Destroy()
    end
    
    if chakraSenseGui and chakraSenseGui.Parent then
        chakraSenseGui:Destroy()
    end
    
    -- Clean up maid connections
    for key, item in pairs(maid) do
        if type(item) == "userdata" and item.Disconnect then
            item:Disconnect()
        elseif type(item) == "userdata" and item.Destroy then
            item:Destroy()
        end
    end
    
    -- Reset camera if spectating
    if currentSpectating then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
    
    -- Cancel auto continue
    if autoContinueThread then
        task.cancel(autoContinueThread)
        autoContinueThread = nil
    end
    
    print("[Bishop Hub] Successfully unloaded all features")
    Library.Unloaded = true
end)

-- ============================================
-- START LOADING
-- ============================================

startSequentialLoading()

print("[Bishop Hub] Complete reorganized script loaded!")
