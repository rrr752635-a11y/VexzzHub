--[[
    ╔══════════════════════════════════════╗
    ║      VEXZ HUB — TRUE MONEY v5        ║
    ║   Remote Spy · Touch Spam · Sell     ║
    ╚══════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LP = Players.LocalPlayer

local function notify(txt, title)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title or "Vexz v5", Text = tostring(txt), Duration = 3})
    end)
end

local function getGuiParent()
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LP:WaitForChild("PlayerGui")
end

pcall(function()
    local old = getGuiParent():FindFirstChild("VexzHub")
    if old then old:Destroy() end
end)

-- GUI SETUP (Ringan)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VexzHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getGuiParent()

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💸 VEXZ v5 — SERVER SIDE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 100)
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.Parent = Main

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

local function makeButton(text, icon, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 55)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundTransparency = 0.9
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = Container
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

    local IconLbl = Instance.new("TextLabel")
    IconLbl.Size = UDim2.new(0, 40, 1, 0)
    IconLbl.Position = UDim2.new(0, 10, 0, 0)
    IconLbl.BackgroundTransparency = 1
    IconLbl.Text = icon
    IconLbl.TextSize = 22
    IconLbl.Font = Enum.Font.GothamBold
    IconLbl.Parent = Btn

    local TextLbl = Instance.new("TextLabel")
    TextLbl.Size = UDim2.new(1, -60, 1, 0)
    TextLbl.Position = UDim2.new(0, 55, 0, 0)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextSize = 13
    TextLbl.Font = Enum.Font.GothamBold
    TextLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.Parent = Btn

    Btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

-- ==========================================
-- FITUR 1: REMOTE SPY (LOG NAMA REMOTE)
-- ==========================================
local spying = false
makeButton("🕵️ Spy Remote (Lihat di Console)", "Cek Remote apa yg dipanggil game", function()
    if spying then notify("Spy udah jalan! Cek F9 / Console") return end
    spying = true
    notify("Spy ON. Lakukan aksi yang ngasih duit (misal beli/jual/pijit koin)")
    
    -- Hook __namecall (butuh executor yang support)
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
            print("[SPY] Remote:", self:GetFullName(), "Args:", ...)
        end
        return oldNamecall(self, ...)
    end)
end)

-- ==========================================
-- FITUR 2: AUTO TOUCH SPAM (COIN FARM)
-- ==========================================
local touching = false
makeButton("🪙 Touch Spam (Koin)", "Nempelin badan ke part duit", function()
    if touching then touching = false; notify("Touch Spam OFF"); return end
    touching = true
    notify("Nyari part duit...")
    
    task.spawn(function()
        while touching do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    -- Cari part yang namanya berbau koin/uang
                    if obj:IsA("BasePart") and obj.Name:lower():match("coin|cash|money|reward|claim") then
                        pcall(function()
                            firetouchinterest(hrp, obj, 0)
                            task.wait(0.05)
                            firetouchinterest(hrp, obj, 1)
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- ==========================================
-- FITUR 3: AUTO SELL (JUAL BARANG DUPE)
-- ==========================================
makeButton("💰 Auto Sell Tool", "Jual tool dupe ke server", function()
    -- Cari remote yang ada embel-embel "sell" atau "jual"
    local sellRemote = nil
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            if n:find("sell") or n:find("jual") or n:find("shop") then
                sellRemote = obj
                break
            end
        end
    end
    
    if not sellRemote then notify("❌ Remote Sell tidak ketemu!"); return end
    
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    
    local count = 0
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            pcall(function()
                if sellRemote:IsA("RemoteEvent") then
                    sellRemote:FireServer(tool.Name) -- Tembak jual pake nama tool
                else
                    sellRemote:InvokeServer(tool.Name)
                end
                count += 1
            end)
            task.wait(0.2)
        end
    end
    notify("✅ " .. count .. " Tool ditembak ke Sell Remote")
end)
