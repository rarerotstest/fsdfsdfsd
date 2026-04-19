-- ══════════════════════════════════════════════════════════════════
--  BRAINROT MERGED SCRIPT
-- ══════════════════════════════════════════════════════════════════
--
--  animals:
--      drag  = Dragon Cannelloni
--      meowl = Meowl
--      ele   = Strawberry Elephant
--      skib  = Skibidi Toilet
--      head  = Headless Horseman
--
--  mutations:
--      gold, diamond, bloodrot, candy, lava,
--      galaxy, radio, yinyang, cursed, rainbow, divine
--
--  examples:
--      "drag"
--      "rainbowmeowl"
--      "golddrag"
--      "radioele"
--      "head"
--
--  if theres an empty slot:
--      			[1] = ""
--      				-> randomly picks a brainrot for you

-- Wait for game to load
repeat task.wait() until game:IsLoaded()

local RS         = game:GetService("ReplicatedStorage")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Wait for LocalPlayer to exist
local player = Players.LocalPlayer
while not player do
    task.wait()
    player = Players.LocalPlayer
end

local playerGui = player:WaitForChild("PlayerGui")

-- Wait for character to exist before continuing
local character = player.Character or player.CharacterAdded:Wait()

-- ══════════════════════════════════════════════
--  PODIUM CONFIG
-- ══════════════════════════════════════════════
local PODIUM_CONFIG = {
    [1]  = "lavadrag",
    [2]  = "candydrag",
    [3]  = "bloodrotdrag",
    [4]  = "diamonddrag",
    [5]  = "drag",
    [6]  = "drag",
    [7]  = "galaxydrag",
    [8]  = "ele",
    [9]  = "ele",
    [10] = "rainbowdrag",
    [11] = "ele",
    [12] = "drag",
    [13] = "rainbowdrag",
    [14] = "rainbowmeowl",
    [15] = "galaxydrag",
    [16] = "diamondmeowl",
    [17] = "rainbowskib",
    [18] = "ele",
    [19] = "meowl",
    [20] = "goldmeowl",
    [21] = "ele",
    [22] = "diamondmeowl",
}

-- ══════════════════════════════════════════════
--  TIMER CONFIG
-- ══════════════════════════════════════════════
-- local TIMER_PRESETS = {
--     default = {
--         INITIAL_WAIT = 4.9,              -- Wait before READY button appears
--         READY_COUNTDOWN = 4.9,           -- Countdown after clicking READY
--         OTHER_READY_DELAY = 1.5,         -- Delay before showing other person as ready
--         POST_READY_WAIT = 2.0,           -- Wait after both shown as ready
--         ACCEPT_COUNTDOWN = 4.9,          -- Wait before ACCEPT button becomes clickable
--         FINAL_CONFIRM_COUNTDOWN = 4.9,   -- Countdown after clicking ACCEPT
--         FINAL_CONFIRM_VISUAL_HOLD = 0.35, -- Hold time showing confirmations
--         PROCESSING_TIME_MIN = 1.8,       -- Minimum processing duration
--         PROCESSING_TIME_MAX = 2.8,       -- Maximum processing duration
--     }
-- }

local TIMER_PRESETS = {
    default = {
        INITIAL_WAIT = 3.0,              -- Wait before READY button appears (matches original 3s countdown)
        READY_COUNTDOWN = 3.0,           -- Countdown after clicking READY
        OTHER_READY_DELAY = 1.5,         -- Delay before showing the other person as "Ready!"
        POST_READY_WAIT = 2.0,           -- Wait after both are shown as ready (before accept phase)
        ACCEPT_COUNTDOWN = 3.0,          -- Countdown before ACCEPT button becomes clickable
        FINAL_CONFIRM_COUNTDOWN = 2.5,   -- Countdown after clicking ACCEPT (exact match to original)
        FINAL_CONFIRM_VISUAL_HOLD = 0.35,-- Hold time showing both "Confirmed!" (exact match)
        PROCESSING_TIME_MIN = 2.5,       -- Processing duration (exact match to original)
        PROCESSING_TIME_MAX = 2.5,       -- Keep same as min for consistency with original
    }
}

local ACTIVE_TIMER_PRESET = "default"
local TIMERS = TIMER_PRESETS[ACTIVE_TIMER_PRESET]

local MULTIPLIER = 13

local BACK_ROW_PODIUMS = {
    [6]=true,[7]=true,[8]=true,[9]=true,[10]=true,
    [16]=true,[17]=true,[18]=true
}

-- ══════════════════════════════════════════════
--  VIEWPORT CAMERA MULTIPLIERS - FIXED!
-- ══════════════════════════════════════════════
local VIEWPORT_CAMERA_MULTIPLIERS = {
    ["Dragon Cannelloni"]   = 0.9,   -- Perfect as-is
    ["Headless Horseman"]   = 1.14,  -- Was too big, camera needs to be farther
    ["Strawberry Elephant"] = 1.07,  -- Camera needs to be farther
    ["Meowl"]               = 0.86,  -- Can be slightly closer
    ["Skibidi Toilet"]      = 0.89,  -- Can be slightly closer
}

local ANIMAL_SHORTHAND = {
    drag  = "Dragon Cannelloni",
    meowl = "Meowl",
    ele   = "Strawberry Elephant",
    skib  = "Skibidi Toilet",
    head  = "Headless Horseman",
}

local MUTATION_SHORTHAND = {
    gold     = "Gold",
    diamond  = "Diamond",
    bloodrot = "Bloodrot",
    candy    = "Candy",
    lava     = "Lava",
    galaxy   = "Galaxy",
    radio    = "Radioactive",
    yinyang  = "YinYang",
    cursed   = "Cursed",
    rainbow  = "Rainbow",
    divine   = "Divine",
}

local RANDOM_EMPTY_POOL = {
    "Meowl",
    "Dragon Cannelloni",
    "Strawberry Elephant",
    "Skibidi Toilet",
    "Headless Horseman",
}

local EMPTY_SLOT_RANDOM = Random.new()

local ANIMAL_SETTINGS = {
    ["Meowl"]               = { heightOffset=4.11, overheadOffset=3 },
    ["Dragon Cannelloni"]   = { heightOffset=4.79, overheadOffset=3 },
    ["Strawberry Elephant"] = { heightOffset=4.49, overheadOffset=1.5 },
    ["Skibidi Toilet"]      = { heightOffset=2.79, overheadOffset=3 },
    ["Headless Horseman"]   = { heightOffset=4.79, overheadOffset=8,
                                overrideAttachment="BrainrotRootPartAttachment" },
}

local MUTATION_RULES = {
    Gold        = { paletteIdx=1 },
    Diamond     = { paletteIdx=1 },
    Bloodrot    = { paletteIdx=1 },
    Candy       = { paletteIdx=1, colorAttr="CandyColor" },
    Lava        = { paletteIdx=1 },
    Galaxy      = { paletteIdx=1, neonAll=true },
    Radioactive = { paletteIdx=2, colorAttr="RadioactiveColor",
                    ignoreAttr="RadioactiveIgnore", studAttr="RadioactiveStud" },
    YinYang     = { paletteIdx=3, colorAttr="YinYangColor" },
    Cursed      = { paletteIdx=1, colorAttr="CursedColor",
                    ignoreAttr="CursedIgnore", studAttr="CursedStud" },
    Divine      = { paletteIdx=1, colorAttr="DivineColor",
                    ignoreAttr="DivineIgnore", studAttr="DivineStud" },
    Rainbow     = { paletteIdx=1 },
}

local RAINBOW_CYCLE_SPEED = 1/4
local RAINBOW_UPDATE_RATE = 1/10

local RAINBOW_VISUAL_PARTS = {
    ["Cube.001"]=true, ["Cube.008"]=true, ["Cube.009"]=true,
    ["Cube.010"]=true, ["Cube.012"]=true, ["Cube.014"]=true,
    ["Cube.016"]=true, ["Cube.027"]=true, ["Cube.001"]=true,
}

local FORCED_MUTATION_PARTS = {
    ["Bloodrot"] = {
        ["Cube.001"] = true,
        ["Cube.027"] = true,
    },
	["Rainbow"] = {
		["Cube.001"] = true,
        ["Cube.027"] = true,
	},
	["Galaxy"] = {
		["Cube.001"] = true,
        ["Cube.027"] = true,
	},
	["Gold"] = {
		["Cube.001"] = true,
        ["Cube.027"] = true,
	},
	["Diamond"] = {
		["Cube.001"] = true,
        ["Cube.027"] = true,
	},
	["Candy"] = {
		["Cube.001"] = true,
        ["Cube.027"] = true,
	},
}

local KEEP_SA = { ["Cube.001"]=true, ["Cube.027"]=true }

local DRAGON_SURFACE_STRIP = {
    ["Cube.009"] = true,
}

local NEEDS_ROTATION_TRADE = {
    ["Meowl"]=true, ["Strawberry Elephant"]=true,
    ["Skibidi Toilet"]=true, ["Headless Horseman"]=true,
}

local SELECTED_BG       = Color3.fromRGB(15, 50, 15)
local UNSELECTED_BG     = Color3.fromRGB(35, 45, 50)
local SELECTED_STROKE   = Color3.fromRGB(0, 255, 0)
local UNSELECTED_STROKE = Color3.fromRGB(0, 0, 0)
local READY_GREEN       = Color3.fromRGB(81, 158, 86)

-- ══════════════════════════════════════════════
--  DATA MODULES
-- ══════════════════════════════════════════════
local AnimalsData   = require(RS.Datas.Animals)
local RaritiesData  = require(RS.Datas.Rarities)
local MutationsData = require(RS.Datas.Mutations)

-- ══════════════════════════════════════════════
--  LOGGING
-- ══════════════════════════════════════════════
local function DLog(text, color)
    color = color or Color3.fromRGB(180,255,180)
    if _G and _G.DLog then pcall(_G.DLog, text, color)
    else print("[Script] "..tostring(text)) end
end

-- ══════════════════════════════════════════════
--  SHARED STATE
-- ══════════════════════════════════════════════
local podiumCollectors = {}
local podiumAnimals    = {}
local podiumMutations  = {}
local tradedPodiums    = {}
local spawnedPodiums   = {}

local selectedFakes       = {}
local fakeTimerThread     = nil
local tradeStage          = 0
local fakeReadyBtn        = nil
local fakeTimerLabel      = nil
local otherUsernameGlobal = "someone"
local interceptNotif      = false
local currentTradeSessionId = 0
local currentFlowRunId      = 0
local updatingOtherSlots    = false

local tradeGuiConnections = {}
local soundHooked = setmetatable({}, { __mode = "k" })
local tradeSoundChildWatcher = nil

local function safeDestroy(obj)
    if obj and obj.Parent then
        pcall(function() obj:Destroy() end)
    end
end

local function safeCancel(thread)
    if thread then
        pcall(function() task.cancel(thread) end)
    end
end

local function clearTradeGuiConnections()
    for _, conn in ipairs(tradeGuiConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(tradeGuiConnections)
end

local function addTradeGuiConnection(conn)
    if conn then
        table.insert(tradeGuiConnections, conn)
    end
    return conn
end

-- ══════════════════════════════════════════════
--  LIVE MODEL CACHE
-- ══════════════════════════════════════════════
local modelCache = {}

local function tryCache(model)
    if not model or not model:IsA("Model") then return end
    if model:FindFirstChild("_FakePodium") then return end
    if model:FindFirstChild("_FakeSpawned") then return end
    local validNames = {
        ["Dragon Cannelloni"]=true, ["Meowl"]=true,
        ["Strawberry Elephant"]=true, ["Skibidi Toilet"]=true,
        ["Headless Horseman"]=true,
    }
    if not validNames[model.Name] then return end
    local meshCount = 0
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("MeshPart") then meshCount += 1 end
    end
    if meshCount == 0 then return end
    local existing = modelCache[model.Name]
    local existingCount = 0
    if existing then
        for _, d in ipairs(existing:GetDescendants()) do
            if d:IsA("MeshPart") then existingCount += 1 end
        end
    end
    if meshCount > existingCount then
        modelCache[model.Name] = model
        DLog("Cached "..model.Name.." ("..meshCount..")", Color3.fromRGB(0,255,100))
    end
end

local function watchFolder(folder)
    for _, c in ipairs(folder:GetChildren()) do
        tryCache(c)
    end
    folder.ChildAdded:Connect(function(c)
        task.wait(0.3)
        tryCache(c)
    end)
end

for _, p in ipairs(workspace.Plots:GetChildren()) do
    watchFolder(p)
    local pods = p:FindFirstChild("AnimalPodiums")
    if pods then
        for _, pod in ipairs(pods:GetChildren()) do
            watchFolder(pod)
        end
        pods.ChildAdded:Connect(function(pod)
            task.wait(0.1)
            watchFolder(pod)
        end)
    end
end

workspace.Plots.ChildAdded:Connect(function(p)
    task.wait(0.2)
    watchFolder(p)
    local pods = p:FindFirstChild("AnimalPodiums")
    if pods then
        for _, pod in ipairs(pods:GetChildren()) do
            watchFolder(pod)
        end
    end
end)

local function getTemplate(animalName)
    local c = modelCache[animalName]
    if c and c.Parent then return c end
    return RS.Models.Animals:FindFirstChild(animalName)
end

-- ══════════════════════════════════════════════
--  FIND PLOT
-- ══════════════════════════════════════════════
local plot = nil
do
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local best = math.huge
        for _, p in ipairs(workspace.Plots:GetChildren()) do
            local sp = p:FindFirstChild("Spawn")
            if sp then
                local d = (sp.Position - hrp.Position).Magnitude
                if d < best then
                    best = d
                    plot = p
                end
            end
        end
    end
end
if not plot then
    DLog("No plot!", Color3.fromRGB(255,80,80))
    return
end
DLog("Plot: "..plot.Name, Color3.fromRGB(0,255,100))

pcall(function()
    local s = game:GetService("SoundService").ToolsSounds.UI.FreezeRayWrong
    s:GetPropertyChangedSignal("Playing"):Connect(function()
        if s.Playing then s:Stop() end
    end)
end)

-- ══════════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════════
local function parseEntry(val)
    if not val or val == "" then return nil, nil end
    val = val:lower()
    for short, mutFull in pairs(MUTATION_SHORTHAND) do
        if val:sub(1, #short) == short then
            local rest = val:sub(#short + 1)
            if ANIMAL_SHORTHAND[rest] then
                return ANIMAL_SHORTHAND[rest], mutFull
            end
        end
    end
    if ANIMAL_SHORTHAND[val] then return ANIMAL_SHORTHAND[val], nil end
    DLog("Unknown: '"..val.."'", Color3.fromRGB(255,80,80))
    return nil, nil
end

local function getIncome(animalName, mutationName)
    local d = AnimalsData[animalName]
    if not d then return 0 end
    local mutData = mutationName and MutationsData[mutationName]
    return (d.Generation or 0) * (1 + (mutData and mutData.Modifier or 0))
end

local function getIncomeForCollect(animalName, mutationName)
    return getIncome(animalName, mutationName) * MULTIPLIER
end

local function formatMoney(n)
    local function fmt(v)
        local r = math.floor(v * 10 + 0.5) / 10
        return r == math.floor(r) and string.format("%d", math.floor(r)) or string.format("%.1f", r)
    end
    if     n >= 1e15 then return "$"..fmt(n/1e15).."Q"
    elseif n >= 1e12 then return "$"..fmt(n/1e12).."T"
    elseif n >= 1e9  then return "$"..fmt(n/1e9).."B"
    elseif n >= 1e6  then return "$"..fmt(n/1e6).."M"
    elseif n >= 1e3  then return "$"..fmt(n/1e3).."K"
    else return "$"..string.format("%d", math.floor(n)) end
end

local function stripZeros(str)
    return str:gsub("%.00%f[%D]",""):gsub("%.(%d-)0+%f[%D]",".%1"):gsub("%.$","")
end

local function lerpColor(a, b, t)
    return Color3.new(a.R+(b.R-a.R)*t, a.G+(b.G-a.G)*t, a.B+(b.B-a.B)*t)
end

local function findAttachment(obj, name, depth)
    depth = depth or 0
    if depth > 12 then return nil end
    for _, c in ipairs(obj:GetChildren()) do
        if c.Name == name and c:IsA("Attachment") then return c end
        local f = findAttachment(c, name, depth + 1)
        if f then return f end
    end
end

local function hookSoundsRecursive(obj)
    if obj:IsA("Sound") and not soundHooked[obj] then
        soundHooked[obj] = true
        obj:GetPropertyChangedSignal("Playing"):Connect(function()
            if obj.Playing then obj:Stop() end
        end)
    end
    for _, desc in ipairs(obj:GetDescendants()) do
        if desc:IsA("Sound") and not soundHooked[desc] then
            soundHooked[desc] = true
            desc:GetPropertyChangedSignal("Playing"):Connect(function()
                if desc.Playing then desc:Stop() end
            end)
        end
    end
end

local function ensureTradeSoundHooks()
    for _, gui in ipairs(playerGui:GetChildren()) do
        hookSoundsRecursive(gui)
    end
    if not tradeSoundChildWatcher then
        tradeSoundChildWatcher = playerGui.ChildAdded:Connect(function(child)
            task.wait(0.05)
            hookSoundsRecursive(child)
        end)
    end
end

-- ══════════════════════════════════════════════
--  PROXIMITY PROMPT FIX
-- ══════════════════════════════════════════════
local function fixProximityPrompts(folder)
    for _, desc in ipairs(folder:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            pcall(function() desc.ActionText = stripZeros(desc.ActionText) end)
            pcall(function() desc.ObjectText  = stripZeros(desc.ObjectText) end)
        end
    end
end

local podiumsFolder = plot:FindFirstChild("AnimalPodiums")
if podiumsFolder then
    fixProximityPrompts(podiumsFolder)
    podiumsFolder.DescendantAdded:Connect(function(desc)
        if desc:IsA("ProximityPrompt") then
            task.wait(0.1)
            pcall(function() desc.ActionText = stripZeros(desc.ActionText) end)
            pcall(function() desc.ObjectText  = stripZeros(desc.ObjectText) end)
        end
    end)
end

-- ══════════════════════════════════════════════
--  VISUAL HELPERS
-- ══════════════════════════════════════════════
local function partHasColoringAttributes(part)
    return part:GetAttribute("Color") ~= nil
        or part:GetAttribute("CandyColor") ~= nil
        or part:GetAttribute("RadioactiveColor") ~= nil
        or part:GetAttribute("YinYangColor") ~= nil
        or part:GetAttribute("CursedColor") ~= nil
        or part:GetAttribute("DivineColor") ~= nil
end

local function shouldKeepSurfaceAppearance(animalName, part)
    if KEEP_SA[part.Name] then return true end

    local lowerName = string.lower(part.Name)
    if lowerName:find("eye", 1, true)
        or lowerName:find("eyes", 1, true)
        or lowerName:find("pupil", 1, true)
        or lowerName:find("iris", 1, true)
        or lowerName:find("mouth", 1, true)
        or lowerName:find("nose", 1, true) then
        return true
    end

    if animalName == "Dragon Cannelloni" then
        return not DRAGON_SURFACE_STRIP[part.Name]
    end

    if (animalName == "Skibidi Toilet" or animalName == "Meowl")
        and part:FindFirstChildOfClass("SurfaceAppearance")
        and not partHasColoringAttributes(part) then
        return true
    end

    return false
end

local function stripSurfaceAppearances(clone, animalName)
    animalName = animalName or clone.Name
    for _, part in ipairs(clone:GetDescendants()) do
        if not (part:IsA("BasePart") or part:IsA("MeshPart")) then continue end
        if shouldKeepSurfaceAppearance(animalName, part) then continue end
        local sa = part:FindFirstChildOfClass("SurfaceAppearance")
        if sa then sa:Destroy() end
    end
end

local function applyMutationColors(clone, animalName, mutationName)
    local mutData = MutationsData[mutationName]
    if not mutData then return end
    
    local rules   = MUTATION_RULES[mutationName] or {}
    local palIdx  = rules.paletteIdx or 1
    local palette = (mutData.Palettes and mutData.Palettes[palIdx]) 
                 or (mutData.Palettes and mutData.Palettes[1])
    
    if not palette then return end

    local mainColor  = mutData.MainColor
    local colorAttr  = rules.colorAttr
    local ignoreAttr = rules.ignoreAttr
    local studAttr   = rules.studAttr
    local neonAll    = rules.neonAll

    local forcedParts = FORCED_MUTATION_PARTS[mutationName] or {}

    for _, part in ipairs(clone:GetDescendants()) do
        if not (part:IsA("BasePart") or part:IsA("MeshPart")) then continue end
        if ignoreAttr and part:GetAttribute(ignoreAttr) == true then continue end

        if forcedParts[part.Name] and mainColor then
            pcall(function()
                part.Color = mainColor
                local sa = part:FindFirstChildOfClass("SurfaceAppearance")
                if sa then
                    sa.Color = mainColor
                end
            end)
        end

        if part.Name == "Cube.009" then
            if mutationName == "YinYang" then
                pcall(function() part.Color = Color3.new(1,1,1) end)
            else
                local wingColor = (palette and palette[1]) or mainColor
                if wingColor then pcall(function() part.Color = wingColor end) end
            end
            continue
        end

        local hasSA = part:FindFirstChildOfClass("SurfaceAppearance") ~= nil
        if animalName == "Dragon Cannelloni" and hasSA and part.Name ~= "Cube.009" then
            continue
        end

        local idx    = (colorAttr and part:GetAttribute(colorAttr)) or part:GetAttribute("Color")
        local hasClr = part:GetAttribute("Color") ~= nil
        local hasMut = colorAttr and part:GetAttribute(colorAttr) ~= nil
        
        if not hasClr and not hasMut and not hasSA then continue end
        if idx == 0 then continue end

        local makeNeon = (studAttr and part:GetAttribute(studAttr) == true)
                      or (neonAll and (idx ~= nil or hasSA))

        local color = nil
        if idx and palette[idx] then
            color = palette[idx]
        elseif animalName ~= "Dragon Cannelloni" and not idx and hasSA and mainColor then
            color = mainColor
        end

        if color then
            pcall(function()
                part.Color = color
                if makeNeon then part.Material = Enum.Material.Neon end
            end)
        end
    end
end

local function fixBaseWings(clone)
    local bodyColor = nil
    for _, part in ipairs(clone:GetDescendants()) do
        if (part:IsA("BasePart") or part:IsA("MeshPart"))
            and part:GetAttribute("Color") == 1 then
            bodyColor = part.Color
            break
        end
    end
    if not bodyColor then return end
    for _, part in ipairs(clone:GetDescendants()) do
        if (part:IsA("BasePart") or part:IsA("MeshPart")) and part.Name == "Cube.009" then
            pcall(function() part.Color = bodyColor end)
        end
    end
end

local function startRainbowAnimation(clone, animalName)
    local mutData = MutationsData["Rainbow"]
    if not mutData then return end
    local palette = mutData.Palettes and mutData.Palettes[1]
    if not palette then return end
    local numColors = #palette

    local entries = {}

    for _, part in ipairs(clone:GetDescendants()) do
        if not (part:IsA("BasePart") or part:IsA("MeshPart")) then continue end

        local hasSA = part:FindFirstChildOfClass("SurfaceAppearance") ~= nil

        if animalName == "Dragon Cannelloni" and hasSA and part.Name ~= "Cube.009" then
            continue
        end

        local idx = part:GetAttribute("Color")

        local forceRainbow = (animalName == "Meowl" and part.Name == "Cube.001")

        if idx ~= nil or RAINBOW_VISUAL_PARTS[part.Name] or forceRainbow or 
           (animalName ~= "Dragon Cannelloni" and hasSA) then
            table.insert(entries, part)
        end
    end

    local lastUpdate = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not clone or not clone.Parent then
            conn:Disconnect()
            return
        end

        local now = tick()
        if now - lastUpdate < RAINBOW_UPDATE_RATE then return end
        lastUpdate = now

        local t = (now * RAINBOW_CYCLE_SPEED) % 1
        local fIdx = t * numColors
        local idxA = math.floor(fIdx) % numColors
        local idxB = (idxA + 1) % numColors
        local frac = fIdx - math.floor(fIdx)
        local ca, cb = palette[idxA+1], palette[idxB+1]
        if not (ca and cb) then return end

        local color = lerpColor(ca, cb, frac)

        for _, part in ipairs(entries) do
            if part.Parent then
                pcall(function()
                    part.Color = color
                    local sa = part:FindFirstChildOfClass("SurfaceAppearance")
                    if sa then
                        sa.Color = color
                    end
                end)
            end
        end
    end)
end

local function startRainbowOverheadAnimation(label)
    local mutData = MutationsData["Rainbow"]
    if not mutData then return end
    local palette = mutData.Palettes and mutData.Palettes[1]
    if not palette or #palette == 0 then return end
    local numColors = #palette

    local gradient = label:FindFirstChildOfClass("UIGradient")
    if not gradient then
        gradient = Instance.new("UIGradient")
        gradient.Rotation = 0
        gradient.Parent = label
    end

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not label or not label.Parent then
            conn:Disconnect()
            return
        end
        local t    = (tick() * RAINBOW_CYCLE_SPEED) % 1
        local fIdx = t * numColors
        local idxA = math.floor(fIdx) % numColors
        local idxB = (idxA + 1) % numColors
        local frac = fIdx - math.floor(fIdx)
        local ca   = palette[idxA + 1]
        local cb   = palette[idxB + 1]
        if not (ca and cb) then return end
        local mid   = lerpColor(ca, cb, frac)
        local prev  = palette[((idxA-1) % numColors)+1] or ca
        local nextC = palette[((idxB+1) % numColors)+1] or cb
        pcall(function()
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,    prev),
                ColorSequenceKeypoint.new(0.33, ca),
                ColorSequenceKeypoint.new(0.5,  mid),
                ColorSequenceKeypoint.new(0.66, cb),
                ColorSequenceKeypoint.new(1,    nextC),
            })
        end)
    end)
end

local function animateSweep(label, baseColor, sweepColor, sweepWidth, duration)
    sweepWidth = sweepWidth or 0.35
    duration   = duration   or 2.5
    label.TextColor3 = Color3.new(1,1,1)
    local gradient = label:FindFirstChildOfClass("UIGradient")
    if not gradient then gradient = Instance.new("UIGradient") gradient.Parent = label end
    gradient.Rotation = 90
    local stroke = label:FindFirstChildOfClass("UIStroke")
    local strokeGradient = stroke and stroke:FindFirstChildOfClass("UIGradient")
    if stroke and not strokeGradient then
        strokeGradient = Instance.new("UIGradient")
        strokeGradient.Rotation = 90
        strokeGradient.Parent = stroke
    end
    if stroke then stroke.Color = Color3.new(1,1,1) end

    task.spawn(function()
        local fps = 30
        while label and label.Parent do
            for i = 0, fps * duration do
                if not label.Parent then return end
                local t    = i / (fps * duration)
                local band = -sweepWidth + t * (1 + sweepWidth * 2)
                local lo   = math.clamp(band - sweepWidth, 0, 1)
                local mid  = math.clamp(band, 0, 1)
                local hi   = math.clamp(band + sweepWidth, 0, 1)

                local function buildSeq(cC, eC)
                    local kps = {}
                    local used = {}
                    local function kp(pos, col)
                        pos = math.clamp(pos, 0, 1)
                        local key = math.floor(pos * 1000)
                        if used[key] then return end
                        used[key] = true
                        table.insert(kps, ColorSequenceKeypoint.new(pos, col))
                    end
                    kp(0, eC)
                    kp(math.max(0, lo), eC)
                    kp(mid, cC)
                    kp(math.min(1, hi), eC)
                    kp(1, eC)
                    table.sort(kps, function(a, b) return a.Time < b.Time end)
                    local cl = {kps[1]}
                    for j = 2, #kps do
                        if kps[j].Time > cl[#cl].Time + 0.002 then
                            table.insert(cl, kps[j])
                        end
                    end
                    return cl
                end

                local tk = buildSeq(sweepColor, baseColor)
                if #tk >= 2 then
                    pcall(function() gradient.Color = ColorSequence.new(tk) end)
                end

                local sk = buildSeq(baseColor, sweepColor)
                if strokeGradient and #sk >= 2 then
                    pcall(function() strokeGradient.Color = ColorSequence.new(sk) end)
                end

                task.wait(1 / fps)
            end

            pcall(function() gradient.Color = ColorSequence.new(baseColor) end)
            if strokeGradient then
                pcall(function() strokeGradient.Color = ColorSequence.new(sweepColor) end)
            end
            task.wait(1)
        end
    end)
end

-- ══════════════════════════════════════════════
--  OVERHEAD
-- ══════════════════════════════════════════════
local function createOverhead(rootPart, fakeRootPart, animalName, overheadOffset, overrideAttachment, mutationName)
    if not rootPart then return end
    local old = rootPart:FindFirstChild("AnimalOverhead")
    if old then old:Destroy() end

    local animalData = AnimalsData[animalName]
    local rarityName = animalData and animalData.Rarity or "Common"
    local income     = getIncome(animalName, mutationName)
    local price      = animalData and animalData.Price or 0
    local mutData    = mutationName and MutationsData[mutationName]

    local overhead = RS.Overheads.AnimalOverhead:Clone()
    overhead.Name = "AnimalOverhead"
    overhead.Size = UDim2.new(15,0,5,0)
    overhead.AlwaysOnTop = false

    local function setLabel(name, text, color, visible, thickness, transparency)
        local lbl = overhead:FindFirstChild(name)
        if not lbl then return nil end
        lbl.Text = text
        lbl.TextColor3 = color
        lbl.Visible = visible
        local s = lbl:FindFirstChildOfClass("UIStroke")
        if not s then s = Instance.new("UIStroke") s.Parent = lbl end
        s.Color = Color3.new(0,0,0)
        s.Thickness = thickness
        s.Transparency = transparency
        s.LineJoinMode = Enum.LineJoinMode.Round
        return lbl
    end

    local mutLabel = overhead:FindFirstChild("Mutation")
    if mutLabel then
        if mutData then
            if mutationName == "Rainbow" then
                mutLabel.RichText = false
                mutLabel.Text = "Rainbow"
                mutLabel.TextColor3 = Color3.new(1,1,1)
                mutLabel.Visible = true
                local stroke = mutLabel:FindFirstChildOfClass("UIStroke")
                if not stroke then stroke = Instance.new("UIStroke") stroke.Parent = mutLabel end
                stroke.Color = Color3.new(0,0,0)
                stroke.Thickness = 3
                stroke.Transparency = 0
                stroke.LineJoinMode = Enum.LineJoinMode.Round
                startRainbowOverheadAnimation(mutLabel)
            else
                mutLabel.RichText = true
                mutLabel.Text = mutData.DisplayWithRichText
                mutLabel.TextColor3 = Color3.new(1,1,1)
                mutLabel.Visible = true
                local stroke = mutLabel:FindFirstChildOfClass("UIStroke")
                if not stroke then stroke = Instance.new("UIStroke") stroke.Parent = mutLabel end
                stroke.Color = Color3.new(0,0,0)
                stroke.Thickness = 3
                stroke.Transparency = 0
                stroke.LineJoinMode = Enum.LineJoinMode.Round
                local grad = mutLabel:FindFirstChildOfClass("UIGradient")
                if grad then grad:Destroy() end
            end
        else
            mutLabel.Visible = false
        end
    end

    if rarityName == "Secret" then
        local lbl = setLabel("Rarity", rarityName, Color3.new(1,1,1), true, 2, 0.35)
        if lbl then animateSweep(lbl, Color3.new(0,0,0), Color3.new(1,1,1), 0.2, 2) end
    elseif rarityName == "OG" then
        local lbl = setLabel("Rarity", rarityName, Color3.new(1,1,1), true, 4, 0.35)
        if lbl then animateSweep(lbl, Color3.fromRGB(255,210,0), Color3.new(0,0,0), 0.35, 2.5) end
    else
        local c = RaritiesData[rarityName] and RaritiesData[rarityName].Color or Color3.new(1,1,1)
        setLabel("Rarity", rarityName, c, true, 4, 0.35)
    end

    setLabel("Generation", formatMoney(income).."/s", Color3.new(1,0.862745,0.196078), true, 5, 0.2)
    setLabel("Price",      formatMoney(price),        Color3.new(0.392157,1,0.235294), true, 5, 0.2)
    setLabel("Stolen",     "STOLEN",                  Color3.new(1,0,0.0156863),       false, 4, 0.35)
    setLabel("DisplayName", animalData and animalData.DisplayName or animalName, Color3.new(1,1,1), true, 5, 0.2)

    local adornee = nil
    if not overrideAttachment then
        adornee = fakeRootPart and findAttachment(fakeRootPart, "HatAttachment")
    end
    if not adornee then
        local att = rootPart:FindFirstChild("BrainrotRootPartAttachment")
        if not att then
            att = Instance.new("Attachment")
            att.Name = "BrainrotRootPartAttachment"
            att.Parent = rootPart
        end
        adornee = att
    end

    overhead.Adornee = adornee
    overhead.StudsOffset = Vector3.new(0, overheadOffset, 0)
    overhead.Parent = rootPart
end

local function playIdle(clone, animalName)
    local animController = clone:FindFirstChildWhichIsA("AnimationController")
        or clone:FindFirstChildWhichIsA("Humanoid")
    local animFolder = RS.Animations.Animals:FindFirstChild(animalName)
    local idleAnim   = animFolder and animFolder:FindFirstChild("Idle")
    if animController and idleAnim then
        local animator = animController:FindFirstChildWhichIsA("Animator")
            or Instance.new("Animator", animController)
        pcall(function()
            local tr = animator:LoadAnimation(idleAnim)
            tr:Play()
        end)
    end
end

-- ══════════════════════════════════════════════
--  PROMPTS & COLLECT
-- ══════════════════════════════════════════════
local function createPrompts(podiumNumber, animalName, mutationName)
    local podium = plot.AnimalPodiums:FindFirstChild(tostring(podiumNumber))
    if not podium then return end
    local spawnPart = podium.Base and podium.Base:FindFirstChild("Spawn")
    if not spawnPart then return end
    local att = spawnPart:FindFirstChild("FakePromptAttachment")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "FakePromptAttachment"
        att.Parent = spawnPart
    end
    for _, c in ipairs(att:GetChildren()) do
        if c:IsA("ProximityPrompt") then c:Destroy() end
    end

    local animalData  = AnimalsData[animalName]
    local price       = animalData and animalData.Price or 0
    local sellPrice   = math.floor(price / 2)
    local sellText    = stripZeros("Sell: "..formatMoney(sellPrice))
    local mutData     = mutationName and MutationsData[mutationName]
    local displayName = animalName

    local grab = Instance.new("ProximityPrompt")
    grab.ActionText = "Grab"
    grab.ObjectText = displayName
    grab.HoldDuration = 1.5
    grab.KeyboardKeyCode = Enum.KeyCode.E
    grab.MaxActivationDistance = 12
    grab.UIOffset = Vector2.new(0,0)
    grab.Parent = att

    local sell = Instance.new("ProximityPrompt")
    sell.ActionText = sellText
    sell.ObjectText = ""
    sell.HoldDuration = 1.5
    sell.KeyboardKeyCode = Enum.KeyCode.F
    sell.MaxActivationDistance = 12
    sell.UIOffset = Vector2.new(0,-80)
    sell.Parent = att
end

local function removePrompts(podiumNumber)
    local podium = plot.AnimalPodiums:FindFirstChild(tostring(podiumNumber))
    if not podium then return end
    local spawnPart = podium.Base and podium.Base:FindFirstChild("Spawn")
    if not spawnPart then return end
    local att = spawnPart:FindFirstChild("FakePromptAttachment")
    if att then att:Destroy() end
end

local function createCollectDisplay(podiumNumber, animalName, mutationName)
    local podium   = plot.AnimalPodiums:FindFirstChild(tostring(podiumNumber))
    if not podium then return end
    local claim    = podium:FindFirstChild("Claim")
    local mainPart = claim and claim:FindFirstChild("Main")
    if not mainPart then return end
    local hitbox   = claim:FindFirstChild("Hitbox")
    local old      = mainPart:FindFirstChild("FakeCollectDisplay")
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FakeCollectDisplay"
    bb.Size = UDim2.new(5,0,2,0)
    bb.StudsOffset = Vector3.new(0,1.5,0)
    bb.AlwaysOnTop = false
    bb.LightInfluence = 0
    bb.Adornee = mainPart
    bb.Parent = mainPart

    local cL = Instance.new("TextLabel")
    cL.Size = UDim2.new(1,0,0.5,0)
    cL.BackgroundTransparency = 1
    cL.Text = "Collect"
    cL.TextColor3 = Color3.new(1,1,1)
    cL.Font = Enum.Font.GothamBold
    cL.TextScaled = true
    cL.Parent = bb
    local cs = Instance.new("UIStroke")
    cs.Color = Color3.new(0,0,0)
    cs.Thickness = 2.5
    cs.Parent = cL

    local aL = Instance.new("TextLabel")
    aL.Size = UDim2.new(1,0,0.5,0)
    aL.Position = UDim2.new(0,0,0.5,0)
    aL.BackgroundTransparency = 1
    aL.Text = "$0"
    aL.TextColor3 = Color3.fromRGB(100,255,50)
    aL.Font = Enum.Font.GothamBold
    aL.TextScaled = true
    aL.Parent = bb
    local as = Instance.new("UIStroke")
    as.Color = Color3.new(0,0,0)
    as.Thickness = 2.5
    as.Parent = aL

    local state = {
        genPerSec   = getIncomeForCollect(animalName, mutationName),
        accumulated = 0,
        lastTick    = tick(),
        collecting  = false,
        amountLabel = aL,
    }
    podiumCollectors[podiumNumber] = state

    if hitbox then
        hitbox.Touched:Connect(function(hit)
            if state.collecting then return end
            local c = player.Character
            if not c or not hit:IsDescendantOf(c) then return end
            state.collecting = true
            state.accumulated = 0
            state.lastTick = tick()
            aL.Text = "$0"
            task.wait(0.5)
            state.collecting = false
        end)
    end
end

-- ══════════════════════════════════════════════
--  SPAWN ANIMAL
-- ══════════════════════════════════════════════
local function spawnAnimal(animalName, podiumNumber, mutationName)
    local ok, err = pcall(function()
        local settings = ANIMAL_SETTINGS[animalName]
        if not settings then error("No settings: "..animalName) end

        for _, child in ipairs(plot:GetChildren()) do
            local tag = child:FindFirstChild("_FakePodium")
            if tag and tag.Value == podiumNumber then
                child:Destroy()
            end
        end

        local podium = plot.AnimalPodiums:FindFirstChild(tostring(podiumNumber))
        if not podium then error("No podium "..podiumNumber) end

        local template = getTemplate(animalName)
        if not template then error("No model: "..animalName) end

        local clone = template:Clone()
        clone.Name = animalName.."_p"..podiumNumber
        Instance.new("BoolValue", clone).Name = "_FakeSpawned"
        local podiumTag = Instance.new("IntValue", clone)
        podiumTag.Name = "_FakePodium"
        podiumTag.Value = podiumNumber

        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("BillboardGui") or d:IsA("Script") or d:IsA("LocalScript") then
                d:Destroy()
            end
        end

        for _, part in ipairs(clone:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.CanCollide = false
                part.Anchored = false
                local dt = part:GetAttribute("DefaultTransparency")
                if dt ~= nil then part.Transparency = dt end
            end
        end

        stripSurfaceAppearances(clone, animalName)

        local rootPart     = clone:FindFirstChild("RootPart")
        local fakeRootPart = clone:FindFirstChild("FakeRootPart")
        local facingAngle  = BACK_ROW_PODIUMS[podiumNumber] and 0 or 180

        if rootPart then
            rootPart.Anchored = true
            rootPart.CFrame = CFrame.new(
                podium.Base.Spawn.Position.X,
                podium.Base.Spawn.Position.Y + settings.heightOffset,
                podium.Base.Spawn.Position.Z
            ) * CFrame.Angles(0, math.rad(facingAngle), 0)
            rootPart.Transparency = 1
        end

        if fakeRootPart and rootPart then
            local w = fakeRootPart:FindFirstChildWhichIsA("WeldConstraint")
                or Instance.new("WeldConstraint", fakeRootPart)
            w.Part0 = rootPart
            w.Part1 = fakeRootPart
        end

        local vfx = clone:FindFirstChild("VfxInstance")
        if vfx and rootPart then
            vfx.Anchored = false
            local w = vfx:FindFirstChildWhichIsA("WeldConstraint")
                or Instance.new("WeldConstraint", vfx)
            w.Part0 = rootPart
            w.Part1 = vfx
            local floorfx = vfx:FindFirstChild("floorfx")
            if floorfx then
                floorfx.Anchored = false
                local w2 = floorfx:FindFirstChildWhichIsA("WeldConstraint")
                    or Instance.new("WeldConstraint", floorfx)
                w2.Part0 = vfx
                w2.Part1 = floorfx
            end
        end

        clone.Parent = plot

        if mutationName == "Rainbow" then
            startRainbowAnimation(clone, animalName)
        elseif mutationName then
            applyMutationColors(clone, animalName, mutationName)
        else
            fixBaseWings(clone)
        end

        createOverhead(rootPart, fakeRootPart, animalName,
            settings.overheadOffset, settings.overrideAttachment, mutationName)
        playIdle(clone, animalName)
        createCollectDisplay(podiumNumber, animalName, mutationName)
        createPrompts(podiumNumber, animalName, mutationName)

        podiumAnimals[podiumNumber]   = animalName
        podiumMutations[podiumNumber] = mutationName

        local meshCount = 0
        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("MeshPart") then meshCount += 1 end
        end
        spawnedPodiums[podiumNumber] = {
            animalName   = animalName,
            mutationName = mutationName,
            meshCount    = meshCount,
        }
    end)
    if not ok then
        DLog("SPAWN ERROR p"..podiumNumber..": "..tostring(err):sub(1,120), Color3.fromRGB(255,80,80))
    end
end

local function removePodiumFromBase(podiumNumber)
    for _, child in ipairs(plot:GetChildren()) do
        local tag = child:FindFirstChild("_FakePodium")
        if tag and tag.Value == podiumNumber then
            child:Destroy()
            break
        end
    end
    removePrompts(podiumNumber)
    local podium = plot.AnimalPodiums:FindFirstChild(tostring(podiumNumber))
    if podium then
        local claim = podium:FindFirstChild("Claim")
        local main  = claim and claim:FindFirstChild("Main")
        if main then
            local d = main:FindFirstChild("FakeCollectDisplay")
            if d then d:Destroy() end
        end
    end
    podiumCollectors[podiumNumber] = nil
    podiumAnimals[podiumNumber]    = nil
    podiumMutations[podiumNumber]  = nil
    tradedPodiums[podiumNumber]    = true
end

-- ══════════════════════════════════════════════
--  INITIAL SPAWN
-- ══════════════════════════════════════════════
do
    for podiumNum = 1, 22 do
        local val = PODIUM_CONFIG[podiumNum]
        if val == nil then
        elseif val == "" then
            local an = RANDOM_EMPTY_POOL[EMPTY_SLOT_RANDOM:NextInteger(1, #RANDOM_EMPTY_POOL)]
            spawnAnimal(an, podiumNum, nil)
        else
            local an, mn = parseEntry(val)
            if an then spawnAnimal(an, podiumNum, mn) end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(3)
        for podNum, info in pairs(spawnedPodiums) do
            local cached = modelCache[info.animalName]
            if not cached or not cached.Parent then continue end
            local n = 0
            for _, d in ipairs(cached:GetDescendants()) do
                if d:IsA("MeshPart") then n += 1 end
            end
            if n > info.meshCount then
                spawnAnimal(info.animalName, podNum, info.mutationName)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        local now = tick()
        for _, state in pairs(podiumCollectors) do
            if not state.collecting then
                local dt = now - state.lastTick
                state.lastTick = now
                state.accumulated = state.accumulated + state.genPerSec * dt
                pcall(function()
                    state.amountLabel.Text = formatMoney(math.floor(state.accumulated))
                end)
            end
        end
    end
end)

-- ══════════════════════════════════════════════
--  NOTIFICATIONS / CANCEL
-- ══════════════════════════════════════════════
local function hookNotifications()
    local function watchInner(inner)
        inner.DescendantAdded:Connect(function(desc)
            if not desc:IsA("TextLabel") then return end
            local function tryReplace()
                if interceptNotif and desc.Text:lower():find("cancel") then
                    desc.Text = '<font color="#92FF67">Trade with '..otherUsernameGlobal..' completed! 🎉</font>'
                    desc.RichText = true
                    interceptNotif = false
                end
            end
            tryReplace()
            desc:GetPropertyChangedSignal("Text"):Connect(tryReplace)
        end)
    end

    local function watchGui(gui)
        local inner = gui:FindFirstChild("Notification")
        if inner then
            watchInner(inner)
        else
            gui.ChildAdded:Connect(function(c)
                if c.Name == "Notification" then watchInner(c) end
            end)
        end
    end

    local notif = playerGui:FindFirstChild("Notification")
    if notif then watchGui(notif) end
    playerGui.ChildAdded:Connect(function(c)
        if c.Name == "Notification" then watchGui(c) end
    end)
end

local function clickCancel(cancelBtn)
    if not cancelBtn then return end
    local ok, conns = pcall(getconnections, cancelBtn.Activated)
    if ok and conns and #conns > 0 then
        for _, conn in ipairs(conns) do
            pcall(function() conn.Function() end)
        end
        return
    end
    local vim = game:GetService("VirtualInputManager")
    local cx = cancelBtn.AbsolutePosition.X + cancelBtn.AbsoluteSize.X/2
    local cy = cancelBtn.AbsolutePosition.Y + cancelBtn.AbsoluteSize.Y/2
    pcall(function()
        vim:SendMouseMoveEvent(cx, cy, game)
        task.wait(0.05)
        vim:SendMouseButtonEvent(cx, cy, 0, true,  game, 0)
        task.wait(0.1)
        vim:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
    end)
end

-- ══════════════════════════════════════════════
--  TRADE VIEWPORT HELPERS
-- ══════════════════════════════════════════════
local function getModel(animalName)
    local m = RS.Models.Animals:FindFirstChild(animalName)
    if m then return m end
    local ok, ev = pcall(function()
        return RS.Controllers.EventController.Events[animalName][animalName]
    end)
    if ok and ev then return ev end
    return nil
end

local function playIdleInViewport(clone)
    local animController = clone:FindFirstChildWhichIsA("AnimationController")
    if not animController then return end
    local animator = animController:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = animController
    end
    local animFolder = RS.Animations.Animals:FindFirstChild(clone.Name)
    local idleAnim   = animFolder and animFolder:FindFirstChild("Idle")
    if idleAnim then
        pcall(function()
            local track = animator:LoadAnimation(idleAnim)
            track:Play()
        end)
    end
end

local function centerModelAtOrigin(clone, needsRotation)
    for _, p in ipairs(clone:GetDescendants()) do
        pcall(function()
            if p:IsA("BasePart") then p.Anchored = true end
        end)
    end
    local rootPart = clone:FindFirstChild("RootPart")
        or clone:FindFirstChild("FakeRootPart")
        or clone:FindFirstChildWhichIsA("BasePart")
    if not rootPart then return end
    local ok, bbCF = pcall(function() return clone:GetBoundingBox() end)
    if not ok then return end
    local offsetToOrigin = -bbCF.Position
    local rotCF = needsRotation and CFrame.Angles(0, math.rad(180), 0) or CFrame.new()
    for _, p in ipairs(clone:GetDescendants()) do
        pcall(function()
            if p:IsA("BasePart") then
                local newPos    = p.CFrame.Position + offsetToOrigin
                local rotatedPos = rotCF * CFrame.new(newPos)
                p.CFrame = CFrame.new(rotatedPos.Position) * (rotCF * CFrame.Angles(
                    math.rad(p.Orientation.X),
                    math.rad(p.Orientation.Y),
                    math.rad(p.Orientation.Z)
                ))
            end
        end)
    end
end

local function applyMutationToViewport(clone, animalName, mutationName)
    if not mutationName then
        fixBaseWings(clone)
        return
    end
    stripSurfaceAppearances(clone, animalName)
    if mutationName == "Rainbow" then
        startRainbowAnimation(clone, animalName)
    else
        applyMutationColors(clone, animalName, mutationName)
    end
end

-- ══════════════════════════════════════════════
--  TRADE FLOW HELPERS
-- ══════════════════════════════════════════════
local function countActivePodiums()
    local n = 0
    for podiumNum = 1, 22 do
        if podiumAnimals[podiumNum] and not tradedPodiums[podiumNum] then n += 1 end
    end
    return n
end

local function hasSelectedFakes()
    for _, v in pairs(selectedFakes) do
        if v then return true end
    end
    return false
end

local function countSelectedFakes()
    local n = 0
    for _, v in pairs(selectedFakes) do
        if v then n += 1 end
    end
    return n
end

local function parseSlotsText(text, fallbackUsed, fallbackCap)
    local used, cap = tostring(text or ""):match("(%d+)%s*/%s*(%d+)")
    return tonumber(used) or (fallbackUsed or 0), tonumber(cap) or (fallbackCap or 0)
end

local function updateTradeSlotLabels(refs)
    if not refs then return end
    local selectedCount = countSelectedFakes()

    if refs.ourBaseSlots then
        local ourUsed = math.max(0, (refs.ourBaseCount or countActivePodiums()) - selectedCount)
        local ourText = ourUsed.."/"..(refs.ourBaseCap or 22)
        if refs.ourBaseSlots.Text ~= ourText then
            refs.ourBaseSlots.Text = ourText
        end
    end

    if refs.otherBaseSlots then
        local displayUsed = math.max(0, (refs.otherBaseCount or 0) + selectedCount)
        local otherText = displayUsed.."/"..(refs.otherBaseCap or 20)
        
        if refs.otherBaseSlots.Text ~= otherText then
            updatingOtherSlots = true
            refs.otherBaseSlots.Text = otherText
            task.wait()
            updatingOtherSlots = false
        end
    end
end

local function hideUnselectedFakes(scroll)
    for _, c in ipairs(scroll:GetChildren()) do
        if c.Name and c.Name:find("FakeSelection_") then
            if not selectedFakes[c.Name] then 
                c.Visible = false 
            end
        end
    end
end

local function visuallyDeselectAll(scroll)
    for _, c in ipairs(scroll:GetChildren()) do
        if c.Name and c.Name:find("FakeSelection_") and selectedFakes[c.Name] then
            local spacer = c:FindFirstChild("Spacer")
            if spacer then
                spacer.BackgroundColor3 = UNSELECTED_BG
                local stroke = spacer:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = UNSELECTED_STROKE end
            end
        end
    end
end

local function createFakeTimerLabel(realTimer)
    if not realTimer or not realTimer.Parent then return nil end
    local old = realTimer.Parent:FindFirstChild("FakeTimerLabel")
    if old then old:Destroy() end
    realTimer.Visible = false
    local fake = realTimer:Clone()
    fake.Name = "FakeTimerLabel"
    fake.Text = ""
    fake.ZIndex = realTimer.ZIndex + 2
    fake.Visible = true
    fake.Parent = realTimer.Parent
    fakeTimerLabel = fake
    return fake
end

local function createFakeReadyButton(realReadyBtn, labelText, onClicked)
    if not realReadyBtn or not realReadyBtn.Parent then return nil end
    local old = realReadyBtn.Parent:FindFirstChild("FakeReadyOverlay")
    if old then old:Destroy() end
    local overlay = realReadyBtn:Clone()
    overlay.Name = "FakeReadyOverlay"
    overlay.ZIndex = realReadyBtn.ZIndex + 30
    overlay.BackgroundColor3 = READY_GREEN
    local txt = overlay:FindFirstChild("Txt")
    if txt then
        txt.Text = labelText
        txt.TextColor3 = Color3.new(1,1,1)
    end
    overlay.Parent = realReadyBtn.Parent
    local fired = false
    local function doClick()
        if fired then return end
        fired = true
        onClicked()
    end
    overlay.MouseButton1Click:Connect(doClick)
    overlay.Activated:Connect(doClick)
    fakeReadyBtn = overlay
    return overlay
end

local function resetFakeTradeState(refs, resetStage)
    currentFlowRunId += 1

    safeCancel(fakeTimerThread)
    fakeTimerThread = nil

    local oldBtn = fakeReadyBtn
    fakeReadyBtn = nil
    safeDestroy(oldBtn)

    local oldTimer = fakeTimerLabel
    fakeTimerLabel = nil
    safeDestroy(oldTimer)

    if refs then
        if refs.setAcceptReady then refs.setAcceptReady(false) end
        if refs.setYourLabel then refs.setYourLabel("Ready!", false) end
        if refs.setOtherLabel then refs.setOtherLabel("Ready!", false) end
        if refs.onDone then pcall(refs.onDone) end
    end

    if resetStage then
        tradeStage = 0
    end
end

-- ══════════════════════════════════════════════
--  FAKE TRADE FLOW
-- ══════════════════════════════════════════════
local runFakeTradeFlow

runFakeTradeFlow = function(refs)
    if not refs then return end

    local realTimer    = refs.timer
    local yourReady    = refs.yourReady
    local otherReady   = refs.otherReady
    local realReadyBtn = refs.readyBtn
    local cancelBtn    = refs.cancelBtn
    local scroll       = refs.scroll
    local sessionId    = refs.sessionId

    local function sessionAlive()
        return refs
            and refs.sessionId == currentTradeSessionId
            and refs.sessionId == sessionId
    end

    if tradeStage >= 2 then return end

    resetFakeTradeState(refs, true)

    if not hasSelectedFakes() then
        if realTimer then realTimer.Visible = true end
        updateTradeSlotLabels(refs)
        return
    end

    if not realTimer or not realReadyBtn or not cancelBtn or not scroll then
        DLog("Trade UI missing required references.", Color3.fromRGB(255,80,80))
        return
    end

    local flowRunId = currentFlowRunId
    local localReadyOverlay = nil

    local function flowAlive()
        return sessionAlive() and flowRunId == currentFlowRunId
    end

    local myTimer = createFakeTimerLabel(realTimer)
    if not myTimer then return end

    local thisThread
    thisThread = task.spawn(function()
        local function cleanup(callOnDone)
            safeDestroy(localReadyOverlay)
            if fakeReadyBtn == localReadyOverlay then
                fakeReadyBtn = nil
            end
            localReadyOverlay = nil

            safeDestroy(myTimer)
            if fakeTimerLabel == myTimer then
                fakeTimerLabel = nil
            end

            if realTimer then realTimer.Visible = true end
            if fakeTimerThread == thisThread then
                fakeTimerThread = nil
            end

            if callOnDone and flowAlive() and refs.onDone then
                pcall(refs.onDone)
            end
        end

        local ok, err = xpcall(function()
            local function countdown(secs, holdZeroFrame)
                local t = secs
                while t > 0 do
                    if not flowAlive() then return false end
                    if myTimer and myTimer.Parent then
                        local display = math.max(0.1, math.ceil((t - 0.0001) * 10) / 10)
                        myTimer.Text = "⏰ "..string.format("%.1f", display).."s Left"
                    end
                    t -= 0.1
                    task.wait(0.1)
                end

                if not flowAlive() then return false end

                if holdZeroFrame and myTimer and myTimer.Parent then
                    myTimer.Text = "⏰ 0.0s Left"
                    task.wait(0.08)
                end

                if myTimer and myTimer.Parent then
                    myTimer.Text = ""
                end
                return true
            end

            tradeStage = 0
            if not countdown(TIMERS.INITIAL_WAIT, false) then return end

            local readyClicked = false
            localReadyOverlay = createFakeReadyButton(realReadyBtn, "READY", function()
                readyClicked = true
            end)
            if not localReadyOverlay then return end

            local waited = 0
            while not readyClicked and waited < 60 do
                if not flowAlive() then return end
                if not hasSelectedFakes() then
                    cleanup(false)
                    updateTradeSlotLabels(refs)
                    return
                end
                task.wait(0.1)
                waited += 0.1
            end

            safeDestroy(localReadyOverlay)
            if fakeReadyBtn == localReadyOverlay then
                fakeReadyBtn = nil
            end
            localReadyOverlay = nil

            if not readyClicked then
                cleanup(false)
                updateTradeSlotLabels(refs)
                return
            end

            if refs.onReady then pcall(refs.onReady) end

            tradeStage = 1
            if refs.setYourLabel then refs.setYourLabel("Ready!", true) end
            pcall(function()
                if yourReady then
                    yourReady.Visible = true
                    local yl = yourReady:FindFirstChild("Label")
                    if yl then yl.Text = "Ready!" end
                end
            end)

            if not countdown(TIMERS.READY_COUNTDOWN, false) then return end

			if not flowAlive() then return end

task.wait(0.5 + Random.new():NextNumber() * 2.0)
            if not flowAlive() then return end

            if refs.setYourLabel then refs.setYourLabel("Ready!", false) end
            pcall(function() if yourReady then yourReady.Visible = false end end)

            tradeStage = 2
            hideUnselectedFakes(scroll)
            visuallyDeselectAll(scroll)

            local acceptClicked = false
            local acceptGate = false
            if refs.setAcceptReady then refs.setAcceptReady(false) end

            localReadyOverlay = createFakeReadyButton(realReadyBtn, "ACCEPT", function()
                if not acceptGate then return end
                acceptClicked = true
            end)
            if not localReadyOverlay then
                cleanup(true)
                return
            end

            pcall(function() localReadyOverlay.Visible = false end)

            if not countdown(TIMERS.ACCEPT_COUNTDOWN, false) then return end

            acceptGate = true
            if refs.setAcceptReady then refs.setAcceptReady(true) end
            pcall(function()
                if localReadyOverlay and localReadyOverlay.Parent then
                    localReadyOverlay.Visible = true
                    localReadyOverlay.BackgroundColor3 = READY_GREEN
                    local t = localReadyOverlay:FindFirstChild("Txt")
                    if t then
                        t.Text = "ACCEPT"
                        t.TextColor3 = Color3.new(1,1,1)
                    end
                end
            end)

            waited = 0
            while not acceptClicked and waited < 60 do
                if not flowAlive() then return end
                task.wait(0.1)
                waited += 0.1
            end

            if acceptClicked and refs.setAcceptReady then
                refs.setAcceptReady(false)
            end

            safeDestroy(localReadyOverlay)
            if fakeReadyBtn == localReadyOverlay then
                fakeReadyBtn = nil
            end
            localReadyOverlay = nil

            if not acceptClicked then
                cleanup(true)
                updateTradeSlotLabels(refs)
                return
            end

            tradeStage = 3
            if refs.setYourLabel then refs.setYourLabel("Confirmed!", true) end
            pcall(function()
                if yourReady then
                    yourReady.Visible = true
                    local yl = yourReady:FindFirstChild("Label")
                    if yl then yl.Text = "Confirmed!" end
                end
            end)

            if not countdown(TIMERS.FINAL_CONFIRM_COUNTDOWN, true) then return end
            if not flowAlive() or tradeStage < 3 then return end

            task.wait(0.8 + Random.new():NextNumber() * 1.5)
            if not flowAlive() or tradeStage < 3 then return end

            if refs.setOtherLabel then refs.setOtherLabel("Confirmed!", true) end
            pcall(function()
                if otherReady then
                    otherReady.Visible = true
                    local ol = otherReady:FindFirstChild("Label")
                    if ol then ol.Text = "Confirmed!" end
                end
            end)

            if myTimer and myTimer.Parent then
                myTimer.Text = "Processing..."
            end

            task.wait(TIMERS.FINAL_CONFIRM_VISUAL_HOLD)
            if not flowAlive() or tradeStage < 3 then return end

            tradeStage = 4
            
            local processingTime = TIMERS.PROCESSING_TIME_MIN
            if TIMERS.PROCESSING_TIME_MAX > TIMERS.PROCESSING_TIME_MIN then
                local rng = Random.new()
                processingTime = TIMERS.PROCESSING_TIME_MIN + 
                    rng:NextNumber() * (TIMERS.PROCESSING_TIME_MAX - TIMERS.PROCESSING_TIME_MIN)
            end
            
            task.wait(processingTime)

            if not flowAlive() then return end

            for fakeName, isSelected in pairs(selectedFakes) do
                if isSelected then
                    local podiumNum = tonumber(fakeName:match("FakeSelection_(%d+)"))
                    if podiumNum and podiumAnimals[podiumNum] then
                        removePodiumFromBase(podiumNum)
                    end
                end
            end

            if myTimer and myTimer.Parent then
                myTimer.Text = ""
            end

            interceptNotif = true
            task.wait(0.1)
            if not flowAlive() then return end
            clickCancel(cancelBtn)

            task.wait(0.5)
            if not flowAlive() then return end

            cleanup(false)
        end, function(e)
            return tostring(e)
        end)

        if not ok then
            DLog("Trade flow error: "..tostring(err):sub(1,220), Color3.fromRGB(255,80,80))
            cleanup(true)
        end
    end)

    fakeTimerThread = thisThread
end

-- ══════════════════════════════════════════════
--  INJECT FAKE BRAINROTS INTO TRADE UI
-- ══════════════════════════════════════════════
local function injectFakeBrainrots(scroll, refs)
    selectedFakes = {}
    tradeStage = 0
    interceptNotif = false

    resetFakeTradeState(refs, true)
    if refs and refs.timer then refs.timer.Visible = true end

    for _, c in ipairs(scroll:GetChildren()) do
        if c.Name and c.Name:find("FakeSelection_") then
            c:Destroy()
        end
    end

    local template = scroll:FindFirstChild("Template")
    if not template then
        DLog("No template!", Color3.fromRGB(255,80,80))
        return
    end

    ensureTradeSoundHooks()

    local activePodiums = {}
    for podiumNum = 1, 22 do
        if podiumAnimals[podiumNum] and not tradedPodiums[podiumNum] then
            table.insert(activePodiums, {
                podiumNum  = podiumNum,
                animalName = podiumAnimals[podiumNum],
                mutation   = podiumMutations[podiumNum],
            })
        end
    end

    updateTradeSlotLabels(refs)

    for idx, entry in ipairs(activePodiums) do
        local podiumNum  = entry.podiumNum
        local animalName = entry.animalName
        local mutation   = entry.mutation
        local animalData = AnimalsData[animalName]
        if not animalData then continue end

        local income  = getIncome(animalName, mutation)
        local genText = formatMoney(income).."/s"
        local mutData = mutation and MutationsData[mutation]

        local fake = template:Clone()
        fake.Name = "FakeSelection_"..podiumNum
        fake.Visible = true
        fake.LayoutOrder = idx

        local spacer = fake:FindFirstChild("Spacer")
        if spacer then
            local titleLbl = spacer:FindFirstChild("Title")
            if titleLbl then titleLbl.Text = animalName end

            local cashLbl = spacer:FindFirstChild("Cash")
            if cashLbl then cashLbl.Text = genText end

            local mutLbl = spacer:FindFirstChild("Mutation")
            if mutLbl then
                if mutData then
                    if mutation == "Rainbow" then
                        mutLbl.RichText = false
                        mutLbl.Text = "Rainbow"
                        mutLbl.TextColor3 = Color3.new(1,1,1)
                        mutLbl.Visible = true
                        startRainbowOverheadAnimation(mutLbl)
                    else
                        mutLbl.RichText = true
                        mutLbl.Text = mutData.DisplayWithRichText or mutation
                        mutLbl.TextColor3 = Color3.new(1,1,1)
                        mutLbl.Visible = true
                    end
                else
                    mutLbl.Visible = false
                end
            end

            local vp = spacer:FindFirstChild("ViewportFrame")
            if vp then
                for _, c in ipairs(vp:GetChildren()) do
                    local ok2, cn = pcall(function() return c.ClassName end)
                    if ok2 and cn ~= "Camera" then c:Destroy() end
                end
                local model = getModel(animalName)
                if model then
                    local clone = model:Clone()
                    clone.Name = animalName
                    stripSurfaceAppearances(clone, animalName)
                    centerModelAtOrigin(clone, NEEDS_ROTATION_TRADE[animalName])
                    local wm = Instance.new("WorldModel")
                    wm.Parent = vp
                    clone.Parent = wm
                    applyMutationToViewport(clone, animalName, mutation)
                    playIdleInViewport(clone)
                    local cam = vp:FindFirstChildOfClass("Camera")
                    if not cam then cam = Instance.new("Camera") cam.Parent = vp end
                    vp.CurrentCamera = cam
                    
                    -- ═══ FIXED CAMERA DISTANCE CALCULATION ═══
                    local ok3, bbCF2, bbSize2 = pcall(function() return clone:GetBoundingBox() end)
                    if ok3 and bbCF2 and bbSize2 then
                        local center = bbCF2.Position
                        local maxDim = math.max(bbSize2.X, bbSize2.Y, bbSize2.Z)
                        
                        -- Use animal-specific multiplier
                        local multiplier = VIEWPORT_CAMERA_MULTIPLIERS[animalName] or 0.9
                        local dist = maxDim * multiplier
                        
                        cam.CFrame = CFrame.new(
                            center + Vector3.new(dist*0.707, dist*0.174, dist*0.707),
                            center
                        )
                    else
                        cam.CFrame = CFrame.new(Vector3.new(8,2,8), Vector3.new(0,0,0))
                    end
                end
            end

            local fakeName = "FakeSelection_"..podiumNum
            local selected = false
            spacer.MouseButton1Click:Connect(function()
                if refs and refs.sessionId ~= currentTradeSessionId then return end
                if tradeStage >= 2 then return end
                selected = not selected
                selectedFakes[fakeName] = selected
                spacer.BackgroundColor3 = selected and SELECTED_BG or UNSELECTED_BG
                local stroke = spacer:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = selected and SELECTED_STROKE or UNSELECTED_STROKE end
                updateTradeSlotLabels(refs)
                if refs then runFakeTradeFlow(refs) end
            end)
        end

        fake.Parent = scroll
    end

    scroll.CanvasPosition = Vector2.new(0, 0)
end

-- ══════════════════════════════════════════════
--  TRADE GUI WATCHER
-- ══════════════════════════════════════════════
task.spawn(function()
    local tradeGui = playerGui:WaitForChild("TradeLiveTrade", 60)
    if not tradeGui then
        DLog("Never found TradeLiveTrade!", Color3.fromRGB(255,80,80))
        return
    end

    hookNotifications()

    local handleOnDone = function() end

    local function handleOpen()
        currentTradeSessionId += 1
        currentFlowRunId += 1
        clearTradeGuiConnections()

        safeCancel(fakeTimerThread)
        fakeTimerThread = nil
        safeDestroy(fakeReadyBtn)
        fakeReadyBtn = nil
        safeDestroy(fakeTimerLabel)
        fakeTimerLabel = nil
        tradeStage = 0

        local scroll = nil
        for _ = 1, 30 do
            local ok, result = pcall(function()
                return playerGui.TradeLiveTrade.TradeLiveTrade.Your.ScrollingFrame
            end)
            if ok and result then
                scroll = result
                break
            end
            task.wait(0.2)
        end
        if not scroll then
            DLog("Scroll not found!", Color3.fromRGB(255,80,80))
            return
        end

        local inner      = tradeGui:FindFirstChild("TradeLiveTrade")
        local other      = inner and inner:FindFirstChild("Other")
        local your       = inner and inner:FindFirstChild("Your")
        local timer      = other and other:FindFirstChild("Timer")
        local readyBtn   = other and other:FindFirstChild("ReadyButton")
        local cancelBtn  = other and other:FindFirstChild("Cancel")
        local yourReady  = your and your:FindFirstChild("Ready")
        local otherReady = other and other:FindFirstChild("Ready")
        local ourBaseSlots   = your and your:FindFirstChild("BaseSlots")
        local otherBaseSlots = other and other:FindFirstChild("BaseSlots")

        if not (scroll and timer and readyBtn and cancelBtn) then
            DLog("Trade UI incomplete, aborting open.", Color3.fromRGB(255,80,80))
            return
        end

        pcall(function() if yourReady then yourReady.Visible = false end end)
        pcall(function() if otherReady then otherReady.Visible = false end end)

        local usernameLbl = other and other:FindFirstChild("Username")
        if usernameLbl then
            otherUsernameGlobal = usernameLbl.Text:gsub("'s Offer",""):gsub(" Offer","")
            addTradeGuiConnection(usernameLbl:GetPropertyChangedSignal("Text"):Connect(function()
                otherUsernameGlobal = usernameLbl.Text:gsub("'s Offer",""):gsub(" Offer","")
            end))
        end

        local visuallyReadied = false
        local acceptClickable = false
        local yourLabel       = "Ready!"
        local yourShouldShow  = false
        local otherLabel      = "Ready!"
        local otherShouldShow = false
        local lockThread      = nil
        local permanentOverlay = nil
        local refs = nil
        local sessionId = currentTradeSessionId

        local ourBaseCount = countActivePodiums()
        local _, ourBaseCap = parseSlotsText(ourBaseSlots and ourBaseSlots.Text, ourBaseCount, 22)
        local otherBaseCount, otherBaseCap = parseSlotsText(otherBaseSlots and otherBaseSlots.Text, 0, 20)

        local function updateOverlay()
            if sessionId ~= currentTradeSessionId then return end
            if not permanentOverlay or not permanentOverlay.Parent then return end
            local ptxt = permanentOverlay:FindFirstChild("Txt")
            local realTxt = readyBtn and readyBtn:FindFirstChild("Txt")
            local inactiveBg = readyBtn and readyBtn.BackgroundColor3 or Color3.fromRGB(75,75,75)
            local inactiveText = realTxt and realTxt.TextColor3 or Color3.fromRGB(210,210,210)

            if tradeStage <= 1 then
                permanentOverlay.BackgroundColor3 = inactiveBg
                if ptxt then
                    ptxt.Text = "READY"
                    ptxt.TextColor3 = inactiveText
                end
            elseif acceptClickable then
                permanentOverlay.BackgroundColor3 = READY_GREEN
                if ptxt then
                    ptxt.Text = "ACCEPT"
                    ptxt.TextColor3 = Color3.new(1,1,1)
                end
            else
                permanentOverlay.BackgroundColor3 = inactiveBg
                if ptxt then
                    ptxt.Text = "ACCEPT"
                    ptxt.TextColor3 = inactiveText
                end
            end
        end

        local function startLock()
            if sessionId ~= currentTradeSessionId then return end
            safeCancel(lockThread)
            if not permanentOverlay or not permanentOverlay.Parent then
                permanentOverlay = readyBtn:Clone()
                permanentOverlay.Name = "PermanentReadyOverlay"
                permanentOverlay.ZIndex = readyBtn.ZIndex + 20
                permanentOverlay.Parent = readyBtn.Parent
            end
            updateOverlay()
            lockThread = task.spawn(function()
                while visuallyReadied and sessionId == currentTradeSessionId do
                    updateOverlay()
                    if yourShouldShow then
                        pcall(function()
                            if yourReady then
                                yourReady.Visible = true
                                local lbl = yourReady:FindFirstChild("Label")
                                if lbl then lbl.Text = yourLabel end
                            end
                        end)
                    end
                    if otherShouldShow then
                        pcall(function()
                            if otherReady then
                                otherReady.Visible = true
                                local ol = otherReady:FindFirstChild("Label")
                                if ol then ol.Text = otherLabel end
                            end
                        end)
                    end
                    task.wait(0.05)
                end
                safeDestroy(permanentOverlay)
                permanentOverlay = nil
            end)
        end

        local function onReady()
            if sessionId ~= currentTradeSessionId then return end
            visuallyReadied = true
            startLock()
        end

        local function onDone()
            visuallyReadied = false
            yourShouldShow  = false
            otherShouldShow = false
            acceptClickable = false
            safeCancel(lockThread)
            lockThread = nil
            safeDestroy(permanentOverlay)
            permanentOverlay = nil
            pcall(function() if yourReady then yourReady.Visible = false end end)
            pcall(function() if otherReady then otherReady.Visible = false end end)
        end
        handleOnDone = onDone

        local otherScroll = other and other:FindFirstChild("ScrollingFrame")
        if otherScroll then
            for _, c in ipairs(otherScroll:GetChildren()) do
                if not c:IsA("UIGridLayout") and c.Name ~= "Template" then
                    pcall(function() c.Visible = false end)
                end
            end
            addTradeGuiConnection(otherScroll.ChildAdded:Connect(function(c)
                task.wait()
                pcall(function() c.Visible = false end)
            end))
        end

        if ourBaseSlots then
            addTradeGuiConnection(ourBaseSlots:GetPropertyChangedSignal("Text"):Connect(function()
                if refs then updateTradeSlotLabels(refs) end
            end))
        end

        if otherBaseSlots then
            addTradeGuiConnection(otherBaseSlots:GetPropertyChangedSignal("Text"):Connect(function()
                if updatingOtherSlots then return end
                if refs and sessionId == currentTradeSessionId then
                    local newText = otherBaseSlots.Text
                    local newUsed, newCap = parseSlotsText(newText, 0, 20)
                    refs.otherBaseCount = newUsed
                    refs.otherBaseCap = newCap
                    updateTradeSlotLabels(refs)
                end
            end))
        end

        addTradeGuiConnection(timer:GetPropertyChangedSignal("Visible"):Connect(function()
            if sessionId ~= currentTradeSessionId then return end
            if tradeStage >= 1 and timer.Visible then timer.Visible = false end
        end))
        addTradeGuiConnection(timer:GetPropertyChangedSignal("Text"):Connect(function()
            if sessionId ~= currentTradeSessionId then return end
            if tradeStage >= 1 then
                timer.Visible = false
                if fakeTimerLabel then fakeTimerLabel.Visible = true end
            end
        end))

        refs = {
            sessionId      = sessionId,
            timer          = timer,
            yourReady      = yourReady,
            otherReady     = otherReady,
            readyBtn       = readyBtn,
            cancelBtn      = cancelBtn,
            scroll         = scroll,
            onReady        = onReady,
            onDone         = onDone,
            setYourLabel   = function(lbl, show) yourLabel = lbl yourShouldShow = show end,
            setOtherLabel  = function(lbl, show) otherLabel = lbl otherShouldShow = show end,
            setAcceptReady = function(v)
                acceptClickable = v
                updateOverlay()
            end,
            ourBaseSlots   = ourBaseSlots,
            otherBaseSlots = otherBaseSlots,
            ourBaseCount   = ourBaseCount,
            ourBaseCap     = ourBaseCap,
            otherBaseCount = otherBaseCount,
            otherBaseCap   = otherBaseCap,
        }

        updateTradeSlotLabels(refs)
        injectFakeBrainrots(scroll, refs)
    end

    tradeGui:GetPropertyChangedSignal("Enabled"):Connect(function()
        if tradeGui.Enabled then
            handleOpen()
        else
            currentTradeSessionId += 1
            currentFlowRunId += 1
            safeCancel(fakeTimerThread)
            fakeTimerThread = nil
            safeDestroy(fakeReadyBtn)
            fakeReadyBtn = nil
            safeDestroy(fakeTimerLabel)
            fakeTimerLabel = nil
            tradeStage = 0
            pcall(function() handleOnDone() end)
            clearTradeGuiConnections()
        end
    end)

    if tradeGui.Enabled then
        handleOpen()
    end
end)

DLog("Script loaded! Viewport camera distances FIXED!", Color3.fromRGB(0,255,100))
