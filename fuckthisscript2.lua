-- =============================================
-- fuckthisscript2.lua - Left Button Clone + Hider
-- =============================================

local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 15)

local CONFIG = {
    PositionOffset = UDim2.new(0, 0, 0, 0),
    SizeMultiplier = 0.85,
    DebugHighlight = false,
}

local fixedGui        = nil
local clonedButtons   = nil
local originalButtons = nil

local function createFixedGui()
    if fixedGui and fixedGui.Parent then return end
    fixedGui = Instance.new("ScreenGui")
    fixedGui.Name           = "FixedLeftButtons_Perfect"
    fixedGui.ResetOnSpawn   = false
    fixedGui.DisplayOrder   = 99999
    fixedGui.IgnoreGuiInset = true
    fixedGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    fixedGui.Parent         = playerGui
end

local function hideRealButtons()
    if not originalButtons then return end
    originalButtons.Visible = false
    originalButtons.BackgroundTransparency = 1
    local leftCenterFrame = originalButtons.Parent
    if leftCenterFrame then leftCenterFrame.BackgroundTransparency = 1 end
    for _, child in ipairs(originalButtons:GetDescendants()) do
        if child:IsA("GuiObject") then
            child.Visible = false
            child.BackgroundTransparency = 1
            if child:IsA("ImageLabel") or child:IsA("ImageButton") then child.ImageTransparency = 1 end
            if child:IsA("TextLabel") then child.TextTransparency = 1 end
        end
    end
end

local function makePerfectClone()
    local leftCenterSG = playerGui:FindFirstChild("LeftCenter") or playerGui:WaitForChild("LeftCenter", 10)
    if not leftCenterSG then return end
    local leftCenterFrame = leftCenterSG:FindFirstChild("LeftCenter") or leftCenterSG:WaitForChild("LeftCenter", 5)
    if not leftCenterFrame then return end
    originalButtons = leftCenterFrame:FindFirstChild("Buttons")
    if not originalButtons then return end

    createFixedGui()
    if clonedButtons then clonedButtons:Destroy() end

    clonedButtons = originalButtons:Clone()
    clonedButtons.Name   = "PerfectClonedButtons"
    clonedButtons.Parent = fixedGui
    clonedButtons.ZIndex = 100000
    clonedButtons.Visible = true
    clonedButtons.BackgroundTransparency = CONFIG.DebugHighlight and 0.7 or 1

    for _, desc in ipairs(clonedButtons:GetDescendants()) do
        if desc:IsA("ImageButton") or desc:IsA("ImageLabel") then
            desc.ScaleType = Enum.ScaleType.Fit
            desc.ZIndex    = 100010
            desc.Visible   = true
        elseif desc:IsA("TextLabel") then
            desc.ZIndex           = 100050
            desc.Visible          = true
            desc.TextTransparency = 0
        end
    end

    hideRealButtons()
    _G.CLONE_ORIGINAL_BUTTONS = originalButtons
    _G.CLONE_CLONED_BUTTONS   = clonedButtons
    print("✅ [Button Clone] Clone created")
end

task.delay(0.6, function()
    if playerGui:FindFirstChild("LeftCenter") then
        makePerfectClone()
    else
        playerGui.ChildAdded:Connect(function(child)
            if child.Name == "LeftCenter" then
                task.delay(0.7, makePerfectClone)
            end
        end)
    end
end)

print("✅ [Button Clone] Loaded via loader")
