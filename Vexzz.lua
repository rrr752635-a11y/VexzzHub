--[[
    ╔══════════════════════════════════════╗
    ║     VEXZ HUB — MONEY GLITCHER v3     ║
    ║   [ KHUSUS GAME KEAMANAN RENDAH ]    ║
    ╚══════════════════════════════════════╝
]]

local Players           = game:GetService("Players")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local StarterGui        = game:GetService("StarterGui")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

local function notify(txt, title)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Vexz Hub",
            Text = tostring(txt),
            Duration = 2
        })
    end)
end

local function getGuiParent()
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LP:WaitForChild("PlayerGui")
end

-- CLEANUP
pcall(function()
    local parent = getGuiParent()
    local old = parent:FindFirstChild("VexzHub")
    if old then old:Destroy() end
    if Lighting:FindFirstChild("VexzBlur") then
        Lighting.VexzBlur:Destroy()
    end
end)

local Blur = Instance.new("BlurEffect")
Blur.Name = "VexzBlur"
Blur.Size = 12
Blur.Parent = Lighting

-- ============ GUI SETUP (GLASS) ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VexzHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = getGuiParent()

local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
Backdrop.BackgroundTransparency = 0.35
Backdrop.BorderSizePixel = 0
Backdrop.Parent = ScreenGui

local BackdropGrad = Instance.new("UIGradient", Backdrop)
BackdropGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 25, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 40, 70))
})
BackdropGrad.Rotation = 135

local Main = Instance.new("Frame")
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0.85, 0, 0.75, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
Main.BackgroundTransparency = 0.12
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local SizeConstraint = Instance.new("UISizeConstraint", Main)
SizeConstraint.MinSize = Vector2.new(280, 380)
SizeConstraint.MaxSize = Vector2.new(520, 720)

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 22)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.72
MainStroke.Thickness = 1.5

local MainGrad = Instance.new("UIGradient", Main)
MainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 0))
})
MainGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.45),
    NumberSequenceKeypoint.new(1, 0.88)
})
MainGrad.Rotation = 45

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 30)
Title.Position = UDim2.new(0, 20, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🚨 VEXZ GLITCHER v3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -70, 0, 14)
Subtitle.Position = UDim2.new(0, 22, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Low Security Game Exploit"
Subtitle.TextColor3 = Color3.fromRGB(255, 200, 100)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -46, 0, 13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 100)
CloseBtn.BackgroundTransparency = 0.55
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Blur:Destroy()
end)

-- Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -30, 1, -90)
Container.Position = UDim2.new(0, 15, 0, 75)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 12)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Button Builder
local function makeButton(text, subtext, icon, callback, toggleMode)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 78)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundTransparency = 0.9
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = Container

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 14)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Transparency = 0.78
    Stroke.Thickness = 1

    local Grad = Instance.new("UIGradient", Btn)
    Grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 0))
    })
    Grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.55),
        NumberSequenceKeypoint.new(1, 0.95)
    })
    Grad.Rotation = 30

    local IconLbl = Instance.new("TextLabel")
    IconLbl.Size = UDim2.new(0, 50, 1, 0)
    IconLbl.Position = UDim2.new(0, 12, 0, 0)
    IconLbl.BackgroundTransparency = 1
    IconLbl.Text = icon
    IconLbl.TextSize = 28
    IconLbl.Font = Enum.Font.GothamBold
    IconLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    IconLbl.Parent = Btn

    local TextLbl = Instance.new("TextLabel")
    TextLbl.Size = UDim2.new(1, -100, 0, 22)
    TextLbl.Position = UDim2.new(0, 68, 0, 16)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextSize = 15
    TextLbl.Font = Enum.Font.GothamBold
    TextLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.Parent = Btn

    local SubLbl = Instance.new("TextLabel")
    SubLbl.Size = UDim2.new(1, -100, 0, 16)
    SubLbl.Position = UDim2.new(0, 68, 0, 40)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text = subtext or ""
    SubLbl.TextSize = 11
    SubLbl.Font = Enum.Font.Gotham
    SubLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    SubLbl.TextXAlignment = Enum.TextXAlignment.Left
    SubLbl.Parent = Btn

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 10, 0, 10)
    StatusDot.Position = UDim2.new(1, -24, 0.5, -5)
    StatusDot.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = Btn
    Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

    local active = false
    local function updateVisual(state)
        active = state
        if toggleMode then
            if active then
                StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
                Btn.BackgroundTransparency = 0.75
            else
                StatusDot.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
                Btn.BackgroundTransparency = 0.9
            end
        end
    end

    Btn.MouseButton1Click:Connect(function()
        if toggleMode then updateVisual(not active) end
        pcall(callback, active)
    end)

    return Btn, updateVisual
end

-- ==========================================
-- FITUR 1: AUTO-SCAN REMOTE & SPAM MONEY
-- ==========================================
-- Logika: Mencari RemoteEvent yang namanya berbau uang, lalu spam FireServer
local spamActive = false
local spamConn = nil

local function findMoneyRemotes()
    local remotes = {}
    local keywords = {"money", "cash", "coin", "give", "reward", "purchase", "buy"}
    
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local lowerName = obj.Name:lower()
            for _, kw in ipairs(keywords) do
                if lowerName:find(kw) then
                    table.insert(remotes, obj)
                    break
                end
            end
        end
    end
    return remotes
end

local function startMoneySpam()
    spamActive = true
    local targets = findMoneyRemotes()
    
    if #targets == 0 then
        notify("❌ Remote uang tidak ditemukan. Game aman?")
        return
    end
    
    notify("🎯 Menemukan " .. #targets .. " Remote. Spamming...")
    
    spamConn = task.spawn(function()
        while spamActive do
            for _, remote in ipairs(targets) do
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        -- Tembak dengan angka gede
                        remote:FireServer(999999)
                        remote:FireServer()
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer(999999)
                    end
                end)
            end
            task.wait(0.1) -- Jeda sedikit biar gak kena kick anti-spam
        end
    end)
end

local function stopMoneySpam()
    spamActive = false
    if spamConn then task.cancel(spamConn) end
    notify("🛑 Spam dihentikan")
end

makeButton("Spam Money Remote", "Cari & tembak RemoteEvent", "💸", function(state)
    if state then startMoneySpam() else stopMoneySpam() end
end, true)

-- ==========================================
-- FITUR 2: TOOL DUPE (INFINITE MONEY TOOL)
-- ==========================================
-- Logika: Clone tool di backpack. Kalau tool-nya bisa dijual/dipake buat duit, ini bakal OP.
local function dupeAllTools()
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then notify("❌ Backpack tidak ada") return end
    
    local count = 0
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            for i = 1, 5 do -- Dupe 5x per tool
                local ok = pcall(function()
                    local clone = tool:Clone()
                    clone.Parent = backpack
                end)
                if ok then count += 1 end
            end
        end
    end
    notify("📦 " .. count .. " Tool berhasil di-dupe!")
end

makeButton("Mass Tool Dupe", "Clone tool 5x lipat", "📦", function()
    dupeAllTools()
end, false)

-- ==========================================
-- FITUR 3: AUTO-RESET GLITCH (REJOIN SPAM)
-- ==========================================
-- Logika: Beberapa game ngasih duit tiap kali karakter mati/reset. 
-- Ini bakal auto-reset terus-terusan.
local autoResetActive = false
local resetConn = nil

local function startAutoReset()
    autoResetActive = true
    resetConn = task.spawn(function()
        while autoResetActive do
            local char = LP.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    hum.Health = 0 -- Matiin diri sendiri
                end
            end
            task.wait(1) -- Delay 1 detik biar respawn
        end
    end)
end

local function stopAutoReset()
    autoResetActive = false
    if resetConn then task.cancel(resetConn) end
end

makeButton("Auto-Reset Glitch", "Bunuh diri buat dapet duit", "🔄", function(state)
    if state then startAutoReset() else stopAutoReset() end
end, true)

-- ==========================================
-- FITUR 4: VISUAL LEADERSTATS (BYPASS UI)
-- ==========================================
-- Logika: Kalau game nge-update UI pake client script, kita bisa paksa Value-nya.
-- (Ini kadang ngaruh di game super murah).
local function forceLeaderstats()
    local ls = LP:FindFirstChild("leaderstats")
    if not ls then notify("❌ Leaderstats tidak ada") return end
    
    for _, stat in ipairs(ls:GetChildren()) do
        if stat:IsA("IntValue") or stat:IsA("NumberValue") then
            pcall(function()
                stat.Value = stat.Value + 1000000
            end)
        end
    end
    notify("💰 Leaderstats dipaksa naik! (Cek UI)")
end

makeButton("Force Leaderstats UI", "Paksa naikin angka UI", "📈", function()
    forceLeaderstats()
end, false)

-- FOOTER
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 18)
Footer.Position = UDim2.new(0, 0, 1, -24)
Footer.BackgroundTransparency = 1
Footer.Text = "Vexz Glitcher v3 · Use Alt Account!"
Footer.TextColor3 = Color3.fromRGB(150, 150, 180)
Footer.TextSize = 10
Footer.Font = Enum.Font.Gotham
Footer.Parent = Main

-- DRAG
do
    local dragging, dragStart, startPos
    local function inputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end
    local function inputChanged(input)
        if dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    local function inputEnded() dragging = false end
    TitleBar.InputBegan:Connect(inputBegan)
    TitleBar.InputChanged:Connect(inputChanged)
    UserInputService.InputChanged:Connect(inputChanged)
    UserInputService.InputEnded:Connect(inputEnded)
end

notify("✅ Vexz Glitcher v3 Loaded!")
