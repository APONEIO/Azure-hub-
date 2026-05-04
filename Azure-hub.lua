local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- // Key Configuration
local CorrectKey = "2103198321031983u("
local DiscordLink = "https://discord.gg/HaDhUpbJN"

-- // Initial Key Window
local KeyWindow = Fluent:CreateWindow({
    Title = "Azure Hub | Verification",
    SubTitle = "Key System",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 300),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local KeyTab = KeyWindow:AddTab({ Title = "Key", Icon = "key" })

local KeyInput = KeyTab:AddInput("KeyInput", {
    Title = "Enter Key",
    Default = "",
    Placeholder = "Paste key here...",
    Numeric = false,
    Finished = false,
    Callback = function() end
})

KeyTab:AddButton({
    Title = "Check Key",
    Description = "Verify your key to unlock Azure Hub",
    Callback = function()
        if KeyInput.Value == CorrectKey then
            Fluent:Notify({
                Title = "Success!",
                Content = "Key verified. Loading Azure Hub...",
                Duration = 3
            })
            KeyWindow:Destroy()
            LoadMainHub()
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Invalid Key! Please try again.",
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

-- // Main Script Function
function LoadMainHub()
    local Window = Fluent:CreateWindow({
        Title = "Azure Hub | Rivals",
        SubTitle = "v1.0",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
        Movement = Window:AddTab({ Title = "Movement", Icon = "Zap" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    -- // Variables
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

    -- // Combat Features
    Tabs.Combat:AddToggle("Aimbot", {Title = "Aimbot", Default = false}):OnChanged(function(v) AimbotEnabled = v end)
    Tabs.Combat:AddToggle("Silent", {Title = "Silent Aim", Default = false}):OnChanged(function(v) SilentAimEnabled = v end)
    Tabs.Combat:AddSlider("FOV", {Title = "FOV Size", Default = 100, Min = 10, Max = 800, Rounding = 0}):OnChanged(function(v) FOV = v end)

    -- // Movement Features (Custom Speed)
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

    -- // Main Loop
    RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = WalkSpeedValue
        end

        if NoclipEnabled and Player.Character then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end

        if FlyEnabled and Player.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = Player.Character.HumanoidRootPart
            local MoveDir = Vector3.new(0,0,0)
            local UIS = game:GetService("UserInputService")
            if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Camera.CFrame.RightVector end
            HRP.Velocity = MoveDir * FlySpeed
        end
    end)
end
