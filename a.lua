-- NeonUI Example Usage Script
-- This script demonstrates how to use the NeonUI library with tab functionality

-- Updated to use loadstring format for GitHub loading
local NeonUI = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ntomoki0814-ui/ui/refs/heads/main/NeonUI.lua"))()

-- Create main window
local window = NeonUI:CreateWindow("NeonUI Demo", "Showcase of all components with tabs")

-- Create multiple tabs for different categories
local mainTab = NeonUI:CreateTab(window, "メイン")
local playerTab = NeonUI:CreateTab(window, "プレイヤー")
local visualTab = NeonUI:CreateTab(window, "ビジュアル")
local settingsTab = NeonUI:CreateTab(window, "設定")

-- Main Tab Content
local mainSection = NeonUI:CreateSection(mainTab, "🎮 基本機能")
mainSection.LayoutOrder = 1

local infoLabel = NeonUI:CreateLabel(mainTab, "NeonUIへようこそ！ネオンスタイルのモダンなUIライブラリです。")
infoLabel.LayoutOrder = 2

local testButton = NeonUI:CreateButton(mainTab, "テストボタン", function()
    print("ボタンがクリックされました！")
end)
testButton.LayoutOrder = 3

local autoFarmToggle = NeonUI:CreateToggle(mainTab, "オートファーム", false, function(state)
    print("オートファーム:", state and "ON" or "OFF")
end)
autoFarmToggle.LayoutOrder = 4

-- Player Tab Content
local playerSection = NeonUI:CreateSection(playerTab, "🏃 プレイヤー設定")
playerSection.LayoutOrder = 1

local speedSlider = NeonUI:CreateSlider(playerTab, "歩行速度", 16, 100, 16, function(value)
    print("歩行速度を設定:", value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)
speedSlider.LayoutOrder = 2

local jumpSlider = NeonUI:CreateSlider(playerTab, "ジャンプ力", 50, 200, 50, function(value)
    print("ジャンプ力を設定:", value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)
jumpSlider.LayoutOrder = 3

local flyToggle = NeonUI:CreateToggle(playerTab, "フライ", false, function(state)
    print("フライ:", state and "ON" or "OFF")
    -- フライ機能をここに追加
end)
flyToggle.LayoutOrder = 4

local noClipToggle = NeonUI:CreateToggle(playerTab, "ノークリップ", false, function(state)
    print("ノークリップ:", state and "ON" or "OFF")
    -- ノークリップ機能をここに追加
end)
noClipToggle.LayoutOrder = 5

-- Visual Tab Content
local visualSection = NeonUI:CreateSection(visualTab, "👁️ ビジュアル機能")
visualSection.LayoutOrder = 1

local espToggle = NeonUI:CreateToggle(visualTab, "ESP", false, function(state)
    print("ESP:", state and "ON" or "OFF")
    -- ESP機能をここに追加
end)
espToggle.LayoutOrder = 2

local wallhackToggle = NeonUI:CreateToggle(visualTab, "ウォールハック", false, function(state)
    print("ウォールハック:", state and "ON" or "OFF")
    -- ウォールハック機能をここに追加
end)
wallhackToggle.LayoutOrder = 3

local brightnessSlider = NeonUI:CreateSlider(visualTab, "明度", 0, 10, 1, function(value)
    print("明度を設定:", value)
    -- 明度調整をここに追加
end)
brightnessSlider.LayoutOrder = 4

local fovSlider = NeonUI:CreateSlider(visualTab, "視野角", 70, 120, 70, function(value)
    print("視野角を設定:", value)
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = value
    end
end)
fovSlider.LayoutOrder = 5

-- Settings Tab Content
local settingsSection = NeonUI:CreateSection(settingsTab, "⚙️ 設定")
settingsSection.LayoutOrder = 1

local nameInput = NeonUI:CreateTextBox(settingsTab, "名前を入力...", function(text, enterPressed)
    if enterPressed and text ~= "" then
        print("名前が入力されました:", text)
    end
end)
nameInput.LayoutOrder = 2

local commandInput = NeonUI:CreateTextBox(settingsTab, "コマンドを入力...", function(text, enterPressed)
    if enterPressed and text ~= "" then
        print("コマンドが入力されました:", text)
        if text:lower() == "hello" or text:lower() == "こんにちは" then
            print("こんにちは！")
        elseif text:lower() == "reset" or text:lower() == "リセット" then
            if game.Players.LocalPlayer.Character then
                game.Players.LocalPlayer.Character:BreakJoints()
            end
        end
    end
end)
commandInput.LayoutOrder = 3

local statusLabel = NeonUI:CreateLabel(settingsTab, "ステータス: 準備完了", NeonUI.Config.Colors.Success)
statusLabel.LayoutOrder = 4

local playerLabel = NeonUI:CreateLabel(settingsTab, "プレイヤー: " .. game.Players.LocalPlayer.Name)
playerLabel.LayoutOrder = 5

local saveButton = NeonUI:CreateButton(settingsTab, "設定を保存", function()
    print("設定が保存されました！")
    -- 設定保存機能をここに追加
end)
saveButton.LayoutOrder = 6

local resetButton = NeonUI:CreateButton(settingsTab, "設定をリセット", function()
    print("設定がリセットされました！")
    -- 設定リセット機能をここに追加
end)
resetButton.LayoutOrder = 7

print("NeonUI Demo with tabs loaded successfully!")
print("タブ機能付きNeonUIデモが正常に読み込まれました！")
