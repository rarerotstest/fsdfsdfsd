-- =============================================
-- fuckthisscript1.lua - Brainrot Hider
-- =============================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do task.wait() LocalPlayer = Players.LocalPlayer end

print("🔍 [Brainrot Hider] Waiting for Plots folder and your base...")

local plotsFolder = workspace:WaitForChild("Plots", 20)
if not plotsFolder then
    warn("❌ [Brainrot Hider] Plots folder never appeared")
else
    local myPlot = nil
    local maxAttempts = 30
    local attempt = 0

    repeat
        attempt += 1
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local surfaceGui = sign:FindFirstChild("SurfaceGui")
                if surfaceGui then
                    local frame = surfaceGui:FindFirstChild("Frame")
                    local label = frame and frame:FindFirstChildWhichIsA("TextLabel")
                    if label and (label.Text:find(LocalPlayer.Name) or label.Text:find(LocalPlayer.DisplayName)) then
                        myPlot = plot
                        break
                    end
                end

                local yourBase = sign:FindFirstChild("YourBase")
                if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
                    myPlot = plot
                    break
                end
            end
        end

        if not myPlot then
            task.wait(0.5)
        end
    until myPlot or attempt >= maxAttempts

    if not myPlot then
        warn("❌ [Brainrot Hider] Could not find your plot after " .. maxAttempts .. " attempts")
    else
        print("✅ [Brainrot Hider] Plot found: " .. myPlot.Name)

        local skipNames = {
            AnimalPodiums=true, Laser=true, Purchases=true,
            Decorations=true, PlotSign=true, FriendPanel=true,
            CashPad=true, Model=true, Multiplier=true,
        }

        local function isBrainrot(obj)
            if not obj:IsA("Model") then return false end
            if skipNames[obj.Name] then return false end
            return obj:FindFirstChildOfClass("Humanoid") ~= nil
        end

        local function safeHide(obj)
            pcall(function()
                if obj:IsA("MeshPart") or obj:IsA("BasePart") then
                    obj.Transparency = 1
                    obj.CastShadow = false
                elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                    obj.Enabled = false
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    obj.Enabled = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                end
            end)
        end

        local OVERHEAD_MATCH_RADIUS = 25

        local function getMyBrainrotPositions()
            local positions = {}
            for _, obj in ipairs(myPlot:GetChildren()) do
                if isBrainrot(obj) then
                    local root = obj:FindFirstChild("RootPart") or obj:FindFirstChildWhichIsA("BasePart")
                    if root then
                        table.insert(positions, root.Position)
                    end
                end
            end
            return positions
        end

        local function isOverheadMine(template, myPositions)
            if #myPositions == 0 then return false end
            local templatePos = template.Position
            for _, pos in ipairs(myPositions) do
                if (templatePos - pos).Magnitude <= OVERHEAD_MATCH_RADIUS then
                    return true
                end
            end
            return false
        end

        local debris = workspace:WaitForChild("Debris", 10)

        local function hideMyOverheadTemplates()
            if not debris then return end
            local myPositions = getMyBrainrotPositions()
            for _, obj in ipairs(debris:GetChildren()) do
                if obj.Name == "FastOverheadTemplate" then
                    if isOverheadMine(obj, myPositions) then
                        for _, desc in ipairs(obj:GetDescendants()) do
                            pcall(function()
                                if desc:IsA("SurfaceGui") or desc:IsA("BillboardGui") then
                                    desc.Enabled = false
                                end
                            end)
                        end
                    end
                end
            end
        end

        myPlot.ChildAdded:Connect(function(obj)
            task.wait(0.1)
            if isBrainrot(obj) then
                print("🆕 [Brainrot Hider] New brainrot: " .. obj.Name)
            end
        end)

        _G.BRAINROT_PLOT           = myPlot
        _G.BRAINROT_IS_BRAINROT    = isBrainrot
        _G.BRAINROT_SAFE_HIDE      = safeHide
        _G.BRAINROT_HIDE_OVERHEADS = hideMyOverheadTemplates

        print("✅ [Brainrot Hider] Initialized successfully (position-filtered, radius=" .. OVERHEAD_MATCH_RADIUS .. " studs)")
    end
end

print("✅ [Brainrot Hider] Loaded via loader")
