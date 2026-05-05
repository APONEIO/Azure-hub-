local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- // Configuration
local CorrectKey = "2103198321031983u("
local DiscordLink = "https://discord.gg/HaDhUpbJN"

-- // Function to Load Main Script (Wrapped to prevent NIL error)
local function LoadMainHub()
    local Window = Fluent:CreateWindow({
        Title = "Azure Hub | Rivals",
        SubTitle = "Premium",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- Icons must be exact Lucide names (all lowercase)
    local Tabs = {
        Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
        Movement = Window:AddTab({ Title = "Movement", Icon = "zap" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    local Player = game.Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")

    local Config = {
        Aimbot = false,
        Silent = false,
        FOV = 100,
        WalkSpeed = 16,
        Fly = false,
        FlySpeed = 50,
        Noclip = false
    }

    -- // Combat Features
    Tabs.Combat:AddToggle("Aimbot", {Title = "Aimbot", Default = false}):OnChanged(function(v) Config.Aimbot = v end)
    Tabs.Combat:AddToggle("Silent", {Title = "Silent Aim", Default = false}):OnChanged(function(v) Config.Silent = v end)
    Tabs.Combat:AddSlider("FOV", {Title = "FOV Size", Default = 100, Min = 10, Max = 800, Rounding = 0}):OnChanged(function(v) Config.FOV = v end)

    -- // Movement Features
    Tabs.Movement:AddSlider("Speed", {
        Title = "Custom WalkSpeed",
        Default = 16,
        Min = 16,
        Max = 300,
        Rounding = 0,
        Callback = function(Value) Config.WalkSpeed = Value end
    })

    Tabs.Movement:AddToggle("Fly", {Title = "Fly", Default = false}):OnChanged(function(v) Config.Fly = v end)
    Tabs.Movement:AddSlider("FlySpeed", {Title = "Fly Speed", Default = 50, Min = 10, Max = 500, Rounding = 0}):OnChanged(function(v) Config.FlySpeed = v end)
    Tabs.Movement:AddToggle("Noclip", {Title = "Noclip", Default = false}):OnChanged(function(v) Config.Noclip = v end)

    -- // Main Loop
    RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = Config.WalkSpeed
            
            if Config.Noclip then
                for _, v in pairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
            
            if Config.Fly and Player.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = Player.Character.HumanoidRootPart
                local MoveDir = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Camera.CFrame.RightVector end
                HRP.Velocity = MoveDir * Config.FlySpeed
            end
        end
    end)

    Window:SelectTab(1)
end

-- // 1. Key System Window (Loaded First)
local KeyWindow = Fluent:CreateWindow({
    Title = "Azure Hub | Verification",
    SubTitle = "Enter Key",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 300),
    Acrylic = false,
    Theme = "Dark"
})

local KeyTab = KeyWindow:AddTab({ Title = "Key", Icon = "key" })

local KeyInput = KeyTab:AddInput("KeyInput", {
    Title = "Enter Key",
    Default = "",
    Placeholder = "...",
})

KeyTab:AddButton({
    Title = "Check Key",
    Callback = function()
        if KeyInput.Value == CorrectKey then
            Fluent:Notify({Title = "Azure Hub", Content = "Access Granted!", Duration = 2})
            KeyWindow:Destroy() -- Removes Key UI
            task.wait(1) -- WAIT 1 SECOND (Fixes the Nil Error)
            LoadMainHub() -- Starts the Script
        else
            Fluent:Notify({Title = "Error", Content = "Invalid Key!", Duration = 2})
        end
    end
})

KeyTab:AddButton({
    Title = "Get Key (Copy Discord)",
    Callback = function()
        setclipboard(DiscordLink)
        Fluent:Notify({Title = "Azure Hub", Content = "Discord Link Copied!", Duration = 5})
    end
})
