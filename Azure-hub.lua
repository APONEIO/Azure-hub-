l-- // Azure Hub | Rivals Script
-- // Optimized for Delta, Hydrogen, and PC executors

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- // Safety check: If library fails to load
if not Fluent then
    game.Players.LocalPlayer:Kick("Azure Hub: Failed to load UI Library")
    return
end

local CorrectKey = "2103198321031983u("
local DiscordLink = "https://discord.gg/HaDhUpbJN"

-- // 1. Key System Window
local KeyWindow = Fluent:CreateWindow({
    Title = "Azure Hub | Verification",
    SubTitle = "by APONEIO",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 320),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local KeyTab = KeyWindow:AddTab({ Title = "Key", Icon = "key" })

local KeyInput = KeyTab:AddInput("KeyInput", {
    Title = "Enter Key",
    Default = "",
    Placeholder = "Paste key here...",
    Callback = function() end
})

KeyTab:AddButton({
    Title = "Check Key",
    Description = "Verify your key to unlock the hub",
    Callback = function()
        if KeyInput.Value == CorrectKey then
            Fluent:Notify({
                Title = "Success!",
                Content = "Access Granted! Loading Azure Hub...",
                Duration = 3
            })
            KeyWindow:Destroy()
            task.wait(0.5)
            LoadMainHub()
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Wrong Key! Get it from Discord.",
                Duration = 3
            })
        end
    end
})

KeyTab:AddButton({
    Title = "Get Key",
    Description = "Copies Discord link to clipboard",
    Callback = function()
        setclipboard(DiscordLink)
        Fluent:Notify({
            Title = "Clipboard",
            Content = "Discord link copied! Join to get the key.",
            Duration = 5
        })
    end
})

-- // 2. Main Hub Function
function LoadMainHub()
    local Window = Fluent:CreateWindow({
        Title = "Azure Hub | Rivals",
        SubTitle = "Premium Edition",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- IMPORTANT: All icons MUST be lowercase (e.g., "crosshair" not "Crosshair")
    local Tabs = {
        Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
        Movement = Window:AddTab({ Title = "Movement", Icon = "zap" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    local Player = game.Players.LocalPlayer
    local Mouse = Player:GetMouse()
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")

    local AimbotEnabled = false
    local SilentAimEnabled = false
    local FOV = 100
    local NoclipEnabled = false
    local FlyEnabled = false
    local FlySpeed = 50
    local WalkSpeedValue = 16

    -- // Combat Tab
    Tabs.Combat:AddToggle("Aimbot", {Title = "Aimbot", Default = false}):OnChanged(function(v) AimbotEnabled = v end)
    Tabs.Combat:AddToggle("Silent", {Title = "Silent Aim", Default = false}):OnChanged(function(v) SilentAimEnabled = v end)
    Tabs.Combat:AddSlider("FOV", {Title = "FOV Size", Default = 100, Min = 10, Max = 800, Rounding = 0}):OnChanged(function(v) FOV = v end)

    -- // Movement Tab
    Tabs.Movement:AddSlider("Speed", {
        Title = "Custom WalkSpeed",
        Default = 16,
        Min = 16,
        Max = 300,
        Rounding = 0,
        Callback = function(Value) WalkSpeedValue = Value end
    })

    Tabs.Movement:AddToggle("Fly", {Title = "Fly", Default = false}):OnChanged(function(v) FlyEnabled = v end)
    Tabs.Movement:AddToggle("Noclip", {Title = "Noclip", Default = false}):OnChanged(function(v) NoclipEnabled = v end)

    -- // Main Loop (Logic)
    RunService.RenderStepped:Connect(function
