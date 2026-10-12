local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local function setupAdminPanel(character)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    local camera = Workspace.CurrentCamera

    -- Limpiar interfaz anterior si ya existía
    if player.PlayerGui:FindFirstChild("MobileAdminGui") then
        player.PlayerGui.MobileAdminGui:Destroy()
    end

    -- Crear interfaz gráfica flotante (Panel Admin)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MobileAdminGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 200, 0, 360)
    MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 160, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.Text = "PANEL RIVALS MÓVIL"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = Title

    -- Botón de Minimizar (-) corregido y visible
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 35, 0, 30)
    MinBtn.Position = UDim2.new(0, 162, 0, 0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 40)
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 18
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = MainFrame

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinBtn

    -- Mini Ventana flotante para maximizar
    local MiniFrame = Instance.new("TextButton")
    MiniFrame.Size = UDim2.new(0, 110, 0, 35)
    MiniFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
    MiniFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MiniFrame.Text = "[ + ] PANEL"
    MiniFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    MiniFrame.TextSize = 12
    MiniFrame.Font = Enum.Font.GothamBold
    MiniFrame.Visible = false
    MiniFrame.Active = true
    MiniFrame.Draggable = true
    MiniFrame.Parent = ScreenGui

    local MiniCorner = Instance.new("UICorner")
    MiniCorner.CornerRadius = UDim.new(0, 8)
    MiniCorner.Parent = MiniFrame

    -- Función auxiliar para crear botones del panel principal
    local function createButton(name, posY)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 180, 0, 32)
        btn.Position = UDim2.new(0, 10, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        btn.Text = name .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.Parent = MainFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn
        return btn
    end

    local FlyBtn = createButton("VUELO", 40)
    local NoclipBtn = createButton("NOCLIP", 78)
    local LockBtn = createButton("STRONGLOCK", 116)
    local RecoilBtn = createButton("NO RECOIL", 154)
    local SpreadBtn = createButton("NO SPREAD", 192)
    local EspBtn = createButton("ESP", 230)
    local SpeedBtn = createButton("VELOCIDAD (80)", 268)

    -- Botones de Subir y Bajar para el vuelo
    local UpBtn = Instance.new("TextButton")
    UpBtn.Size = UDim2.new(0, 85, 0, 28)
    UpBtn.Position = UDim2.new(0, 10, 0, 312)
    UpBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
    UpBtn.Text = "SUBIR"
    UpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    UpBtn.TextSize = 11
    UpBtn.Font = Enum.Font.GothamBold
    UpBtn.Parent = MainFrame
    Instance.new("UICorner", UpBtn).CornerRadius = UDim.new(0, 6)

    local DownBtn = Instance.new("TextButton")
    DownBtn.Size = UDim2.new(0, 85, 0, 28)
    DownBtn.Position = UDim2.new(0, 105, 0, 312)
    DownBtn.BackgroundColor3 = Color3.fromRGB(160, 80, 40)
    DownBtn.Text = "BAJAR"
    DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DownBtn.TextSize = 11
    DownBtn.Font = Enum.Font.GothamBold
    DownBtn.Parent = MainFrame
    Instance.new("UICorner", DownBtn).CornerRadius = UDim.new(0, 6)

    -- Lógica de Minimizar y Maximizar
    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MiniFrame.Position = MainFrame.Position
        MiniFrame.Visible = true
    end)

    MiniFrame.MouseButton1Click:Connect(function()
        MiniFrame.Visible = false
        MainFrame.Position = MiniFrame.Position
        MainFrame.Visible = true
    end)

    -- Estados de las funciones
    local flying = false
    local noclip = false
    local stronglock = false
    local noRecoil = false
    local noSpread = false
    local espActive = false
    local highSpeed = false
    
    local speed = 35
    local upState = false
    local downState = false
    local espHighlights = {}

    -- Conexiones de los Botones
    FlyBtn.MouseButton1Click:Connect(function()
        flying = not flying
        FlyBtn.Text = flying and "VUELO: ON" or "VUELO: OFF"
        FlyBtn.BackgroundColor3 = flying and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(180, 40, 40)
        if not flying and humanoidRootPart and humanoid then
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)

    NoclipBtn.MouseButton1Click:Connect(function()
        noclip = not noclip
        NoclipBtn.Text = noclip and "NOCLIP: ON" or "NOCLIP: OFF"
        NoclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(180, 40, 40)
    end)

    LockBtn.MouseButton1Click:Connect(function()
        stronglock = not stronglock
        LockBtn.Text = stronglock and "STRONGLOCK: ON" or "STRONGLOCK: OFF"
        LockBtn.BackgroundColor3 = stronglock and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(180, 40, 40)
    end)

    RecoilBtn.MouseButton1Click:Connect(function()
        noRecoil = not noRecoil
        RecoilBtn.Text = noRecoil and "NO RECOIL: ON" or "NO RECOIL: OFF"
        RecoilBtn.BackgroundColor3 = noRecoil and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(180, 40, 40)
    end)

    SpreadBtn.MouseButton1Click:Connect(function()
        noSpread = not noSpread
        SpreadBtn.Text = noSpread and "NO SPREAD: ON" or "NO SPREAD: OFF"
        SpreadBtn.BackgroundColor3 = noSpread and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(180, 40, 40)
    end)

    EspBtn.MouseButton1Click:Connect(function()
        espActive = not espActive
        EspBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
        EspBtn.BackgroundColor3 = espActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(180, 40, 40)

        if espActive then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hl = Instance.new("Highlight")
                    hl.Name = "AdminESP"
                    hl.Adornee = p.Character
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                    table.insert(espHighlights, hl)
                end
            end
        else
            for _, hl in ipairs(espHighlights) do
                if hl then hl:Destroy() end
            end
            espHighlights = {}
        end
    end)

    SpeedBtn.MouseButton1Click:Connect(function()
        highSpeed = not highSpeed
        SpeedBtn.Text = highSpeed and "VELOCIDAD: 80" or "VELOCIDAD: 16"
        SpeedBtn.BackgroundColor3 = highSpeed and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(180, 40, 40)
        humanoid.WalkSpeed = highSpeed and 80 or 16
    end)

    UpBtn.MouseButton1Down:Connect(function() upState = true end)
    UpBtn.MouseButton1Up:Connect(function() upState = false end)
    DownBtn.MouseButton1Down:Connect(function() downState = true end)
    DownBtn.MouseButton1Up:Connect(function() downState = false end)

    local function getClosestEnemy()
        local closestTarget = nil
        local shortestDistance = math.huge

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
                local targetPart = otherPlayer.Character:FindFirstChild("Head")
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

    -- Bucle principal del panel
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not character or not character.Parent or not humanoidRootPart or not humanoidRootPart.Parent or humanoid.Health <= 0 then
            if ScreenGui then ScreenGui:Destroy() end
            if connection then connection:Disconnect() end
            return
        end

        -- Lógica de Vuelo
        if flying then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            local moveDir = humanoid.MoveDirection
            local verticalVel = 0
            if upState then verticalVel = speed end
            if downState then verticalVel = -speed end

            local horizontalVel = moveDir * speed
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(horizontalVel.X, verticalVel, horizontalVel.Z)
            
            if moveDir.Magnitude > 0 then
                local lookVec = camera.CFrame.LookVector
                local flatLook = Vector3.new(lookVec.X, 0, lookVec.Z)
                if flatLook.Magnitude > 0 then
                    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + flatLook.Unit)
                end
            end
        end

        -- Lógica de Noclip
        if noclip then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        -- Lógica de Stronglock
        if stronglock then
            local target = getClosestEnemy()
            if target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end
        end

        -- Control seguro de No Recoil y No Spread sobre herramientas activas
        pcall(function()
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        local name = obj.Name:lower()
                        if noRecoil and (name:find("recoil") or name:find("kick")) then
                            obj.Value = 0
                        end
                        if noSpread and (name:find("spread") or name:find("deviation") or name:find("accuracy")) then
                            obj.Value = 0
                        end
                    end
                end
            end
        end)
    end)
end

-- Recarga automática al reaparecer
player.CharacterAdded:Connect(function(newCharacter)
    task.wait(1)
    setupAdminPanel(newCharacter)
end)

if player.Character then
    setupAdminPanel(player.Character)
end
