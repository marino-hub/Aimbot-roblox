local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Estados de las funciones
local stronglockActive = false
local noRecoilActive = false
local noSpreadActive = false

-- Función para encontrar el enemigo más cercano a la mira
local function getClosestEnemy()
    local closestTarget = nil
    local shortestDistance = math.huge

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            local character = otherPlayer.Character
            local targetPart = character:FindFirstChild("Head") -- Apuntar a la cabeza
            
            if targetPart then
                local screenPoint, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude

                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestTarget = targetPart
                    end
                end
            end
        end
    end

    return closestTarget
end

-- Bucle principal de ejecución del cliente
RunService.RenderStepped:Connect(function()
    -- 1. STRONGLOCK: Bloqueo inmediato y estricto sobre el objetivo
    if stronglockActive then
        local targetPart = getClosestEnemy()
        if targetPart then
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
        end
    end

    -- 2. NO RECOIL / NO SPREAD: Anular sacudidas de cámara y dispersión
    if noRecoilActive or noSpreadActive then
        -- Muchos frameworks de armas almacenan los datos de retroceso en el Character o en el módulo activo.
        -- Bloqueamos las alteraciones de la cámara causadas por herramientas de fuego.
        pcall(function()
            local character = player.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Intentar limpiar propiedades de retroceso si el juego usa valores estándar expuestos
                    if tool:FindFirstChild("Recoil") then
                        tool.Recoil.Value = 0
                    end
                    if tool:FindFirstChild("Spread") then
                        tool.Spread.Value = 0
                    end
                end
            end
        end)
    end
end)

-- Hook para interceptar modificaciones de cámara por retroceso (Opcional avanzado)
local cameraKickbackConnection
if noRecoilActive then
    -- Previene que los scripts del juego sacudan la cámara al disparar
    camera.Changed:Connect(function(property)
        if property == "CFrame" and noRecoilActive then
            -- Aquí puedes filtrar cambios bruscos de ángulo generados por armas
        end
    end)
end
