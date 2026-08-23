-- Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local FYFPConfig = {
	FPS = {
		Enabled = false,
		Value = 300,
		Fluctuating = true,
	},
	Memory = {
		Enabled = false,
		Value = 1024,
		Fluctuating = true,
	},
	ScreenRes = {
		Enabled = false,
		Width = 1920,
		Height = 1080,
	},
	GQ = {
		Enabled = false,
		Value = 5,
	},
	Debug = {
		Log = false,
		Rayfield = nil,
		con = nil,
		preRenderCon = nil,
	},
}
local debugLog = function(...)
	if FYFPConfig.Debug.Log then
		print(...)
	end
end

local Window = Rayfield:CreateWindow({
	Name = "Flex your FPS and Ping",
	LoadingTitle = "Flex your FPS and Ping UI",
	LoadingSubtitle = "",

	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "FlexYourFpsAndPing",
	},
})

local Main = Window:CreateTab("Main")

-- FPS
Main:CreateSection("FPS")
Main:CreateToggle({
	Name = "Enable Spoofed FPS",
	CurrentValue = false,
	Flag = "EnableFPS",
	Callback = function(v)
		FYFPConfig.FPS.Enabled = v
	end,
})
FPSInput = Main:CreateInput({
	Name = "FPS",
	CurrentValue = "300",
	PlaceholderText = "Spoofed FPS amount",
	RemoveTextAfterFocusLost = false,
	Flag = "FPSValue",
	Callback = function(value)
		if tonumber(value) == nil then
			FPSInput:Set(tostring(FYFPConfig.FPS.Value))
			Rayfield:Notify({
				Title = "Error",
				Content = "FPS must be a number",
				Duration = 5,
				Image = "circle-x",
			})
			return
		end
		if tonumber(value) > 3500 then
			FPSInput:Set("3500")
			FYFPConfig.FPS.Value = 3500
			Rayfield:Notify({
				Title = "Error",
				Content = "FPS can't be higher than 3500",
				Duration = 5,
				Image = "circle-x",
			})
			return
		end
		FYFPConfig.FPS.Value = tonumber(value)
	end,
})
Main:CreateToggle({
	Name = "Enable Fluctuating FPS",
	CurrentValue = true,
	Flag = "EnableFluctuatingFPS",
	Callback = function(v)
		FYFPConfig.FPS.Fluctuating = v
	end,
})

-- Memory
Main:CreateSection("Memory")
Main:CreateToggle({
	Name = "Enable Spoofed Memory",
	CurrentValue = false,
	Flag = "EnableMemory",
	Callback = function(v)
		FYFPConfig.Memory.Enabled = v
	end,
})
MemoryInput = Main:CreateInput({
	Name = "Memory",
	CurrentValue = "1024",
	PlaceholderText = "Spoofed Memory amount",
	RemoveTextAfterFocusLost = false,
	Flag = "MemoryValue",
	Callback = function(value)
		if tonumber(value) == nil then
			MemoryInput:Set(tostring(FYFPConfig.Memory.Value))
			Rayfield:Notify({
				Title = "Error",
				Content = "Memory must be a number",
				Duration = 5,
				Image = "circle-x",
			})
			return
		end
		FYFPConfig.Memory.Value = tonumber(value)
	end,
})
Main:CreateToggle({
	Name = "Enable Fluctuating Memory",
	CurrentValue = true,
	Flag = "EnableFluctuatingMemory",
	Callback = function(v)
		FYFPConfig.Memory.Fluctuating = v
	end,
})

-- Screen Resolution
Main:CreateSection("Screen Resolution")
Main:CreateToggle({
	Name = "Enable Spoofed Screen Resolution",
	CurrentValue = false,
	Flag = "EnableScreenRes",
	Callback = function(v)
		FYFPConfig.ScreenRes.Enabled = v
	end,
})
ScreenWidthInput = Main:CreateInput({
	Name = "Screen Width",
	CurrentValue = "1920",
	PlaceholderText = "Spoofed Screen Width",
	RemoveTextAfterFocusLost = false,
	Flag = "ScreenResWidth",
	Callback = function(value)
		if tonumber(value) == nil then
			ScreenWidthInput:Set(tostring(FYFPConfig.ScreenRes.Width))
			Rayfield:Notify({
				Title = "Error",
				Content = "Screen Width must be a number",
				Duration = 5,
				Image = "circle-x",
			})
			return
		end
		FYFPConfig.ScreenRes.Width = tonumber(value)
	end,
})
ScreenHeightInput = Main:CreateInput({
	Name = "Screen Height",
	CurrentValue = "1080",
	PlaceholderText = "Spoofed Screen Height",
	RemoveTextAfterFocusLost = false,
	Flag = "ScreenResHeight",
	Callback = function(value)
		if tonumber(value) == nil then
			ScreenHeightInput:Set(tostring(FYFPConfig.ScreenRes.Height))
			Rayfield:Notify({
				Title = "Error",
				Content = "Screen Height must be a number",
				Duration = 5,
				Image = "circle-x",
			})
			return
		end
		FYFPConfig.ScreenRes.Height = tonumber(value)
	end,
})

-- Graphics Quality
Main:CreateSection("Graphics Quality")
Main:CreateToggle({
	Name = "Enable Spoofed Graphics Quality",
	CurrentValue = false,
	Flag = "EnableGQ",
	Callback = function(v)
		FYFPConfig.GQ.Enabled = v
	end,
})
Main:CreateSlider({
	Name = "Graphics Quality (0 = Automatic)",
	Range = { 0, 10 },
	Increment = 1,
	Suffix = "",
	CurrentValue = 5,
	Flag = "GQValue",
	Callback = function(v)
		FYFPConfig.GQ.Value = v
	end,
})

-- Settings
local Settings = Window:CreateTab("Settings")
Settings:CreateToggle({
	Name = "Enable Console Logging",
	CurrentValue = false,
	Flag = "EnableLogging",
	Callback = function(v)
		FYFPConfig.Debug.Log = v
	end,
})
Settings:CreateButton({
	Name = "Close UI",
	Callback = function()
		Rayfield:Destroy()
		FYFPConfig.Debug.con:Disconnect()
		FYFPConfig.Debug.preRenderCon:Disconnect()
	end,
})
Rayfield:LoadConfiguration()
FYFPConfig.Debug.Rayfield = Rayfield

-- Main Script
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local GUI = game:GetService("GuiService")
local TS = game:GetService("TextService")
local STATS = game:GetService("Stats")

local RUN = game:GetService("RunService")
local frameCount = 0
local lastClock = os.clock()
local fps = 0
FYFPConfig.Debug.preRenderCon = RUN.PreRender:Connect(function()
	frameCount += 1
	local currentTime = os.clock()
	if currentTime - lastClock >= 1 then
		fps = frameCount
		frameCount = 0
		lastClock = currentTime
	end
end)

local function getDefaultSetting(flag)
	if flag == "FPS" then
		return fps
	elseif flag == "Memory" then
		return STATS:GetTotalMemoryUsageMb()
	elseif flag == "ScreenRes" then
		return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(0, 0)
	elseif flag == "GQ" then
		return UserSettings():GetService("UserGameSettings").SavedQualityLevel
	end
	return nil
end

local QLM = {
	["0"] = Enum.SavedQualitySetting.Automatic,
	["1"] = Enum.SavedQualitySetting.QualityLevel1,
	["2"] = Enum.SavedQualitySetting.QualityLevel2,
	["3"] = Enum.SavedQualitySetting.QualityLevel3,
	["4"] = Enum.SavedQualitySetting.QualityLevel4,
	["5"] = Enum.SavedQualitySetting.QualityLevel5,
	["6"] = Enum.SavedQualitySetting.QualityLevel6,
	["7"] = Enum.SavedQualitySetting.QualityLevel7,
	["8"] = Enum.SavedQualitySetting.QualityLevel8,
	["9"] = Enum.SavedQualitySetting.QualityLevel9,
	["10"] = Enum.SavedQualitySetting.QualityLevel10,
}

local function getSetting(flag)
	local config = FYFPConfig[flag]
	if not config.Enabled then
		return getDefaultSetting(flag)
	end

	if config.Fluctuating ~= nil and config.Fluctuating then
		local value = config.Value
		if flag == "FPS" then
			return math.random(value - 10, value + 10)
		elseif flag == "Memory" then
			return math.random() * 1.8 + (value - 0.9)
		end
	end

	if flag == "ScreenRes" then
		return Vector2.new(config.Width, config.Height)
	end
	if flag == "GQ" then
		return QLM[tostring(config.Value)]
	end
	return config.Value
end

FYFPConfig.Debug.con = RS:WaitForChild("meow").OnClientEvent:Connect(function(arg)
	debugLog("meow received from server, type: " .. tostring(arg.t))
	if type(arg) ~= "table" then
		return
	end

	if arg.t == "device" and type(arg.token) == "number" then
		local data = {
			A = UIS.VREnabled,
			B = GUI:IsTenFootInterface(),
			C = GUI.IsWindows,
			D = "0.716.0.7160875", -- normal getfenv().version() could trigger anticheat
			E = UIS.GyroscopeEnabled or UIS.AccelerometerEnabled,
			F = UIS.TouchEnabled,
			G = UIS.KeyboardEnabled,
			H = UIS.MouseEnabled,
			I = TS:GetTextSize(utf8.char(65535), 16, "SourceSans", Vector2.one * 1000)
				~= TS:GetTextSize(utf8.char(63743), 16, "SourceSans", Vector2.one * 1000),
		}
		debugLog("Sending device data to server, token: " .. arg.token)
		RS:WaitForChild("nya"):FireServer({ t = "device", token = arg.token, tbl = data })
	elseif arg.t == "metrics" and type(arg.token) == "number" then
		debugLog("Sending metrics to server, token: " .. arg.token)
		RS:WaitForChild("nya"):FireServer({
			t = "metrics",
			token = arg.token,
			fps = getSetting("FPS"),
			gfx = getSetting("GQ"),
			mem = getSetting("Memory"),
			res = getSetting("ScreenRes"),
		})
		debugLog("Metrics sent")
	end
end)
