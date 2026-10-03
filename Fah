-- Extreme FPS Boost (Delta)
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local Players = game:GetService("Players")

pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
pcall(function() settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01 end)
pcall(function() setfpscap(999) end)

-- Освещение
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
pcall(function() Lighting.Technology = Enum.Technology.Compatibility end)

for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
        v:Destroy()
    end
end

-- Серое небо
local gray = Color3.fromRGB(128, 128, 128)
Lighting.ClockTime = 14
Lighting.Ambient = gray
Lighting.OutdoorAmbient = gray
Lighting.ColorShift_Top = gray
Lighting.ColorShift_Bottom = gray

local sky = Instance.new("Sky")
sky.CelestialBodiesShown = false
sky.StarCount = 0
sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt = "", "", ""
sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = "", "", ""
sky.Parent = Lighting

local atm = Instance.new("Atmosphere")
atm.Density = 1
atm.Offset = 1
atm.Color = gray
atm.Decay = gray
atm.Glare = 0
atm.Haze = 0
atm.Parent = Lighting

-- Вода
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
    Terrain.Decoration = false
end

-- Упрощение объектов
local function optimize(v)
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
        v.CastShadow = false
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke")
        or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
        v.Enabled = false
    elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
        v.Enabled = false
    elseif v:IsA("Explosion") then
        v.Visible = false
    end
end

for _, v in ipairs(workspace:GetDescendants()) do
    pcall(optimize, v)
end

-- Новые объекты тоже оптимизируем
workspace.DescendantAdded:Connect(function(v)
    pcall(optimize, v)
end)

print("FPS Boost активирован")
