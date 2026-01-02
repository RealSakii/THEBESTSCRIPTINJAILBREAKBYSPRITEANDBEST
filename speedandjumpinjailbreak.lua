local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local humanoid
local infiniteJump = false

local NORMAL_SPEED = 16
local RUN_SPEED = 150

local function setupCharacter(char)
    humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = NORMAL_SPEED
end

setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    -- เปิด/ปิด กระโดดไม่จำกัด
    if input.KeyCode == Enum.KeyCode.B then
        infiniteJump = not infiniteJump
    end

    -- Infinite Jump
    if infiniteJump and input.KeyCode == Enum.KeyCode.Space then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--Speed

  local walkspeedplayer = game:GetService("Players").LocalPlayer
    local walkspeedmouse = walkspeedplayer:GetMouse()
 
    local walkspeedenabled = false
 
    function x_walkspeed(key)
        if (key == "x") then
            if walkspeedenabled == false then
                _G.WS = 150;
                local Humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid;
                Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                Humanoid.WalkSpeed = _G.WS;
                end)
                Humanoid.WalkSpeed = _G.WS;
 
                walkspeedenabled = true
            elseif walkspeedenabled == true then
                _G.WS = 20;
                local Humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid;
                Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                Humanoid.WalkSpeed = _G.WS;
                end)
                Humanoid.WalkSpeed = _G.WS;
 
                walkspeedenabled = false
            end
        end
    end
 
    walkspeedmouse.KeyDown:connect(x_walkspeed)


--teleport

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ตั้งค่าความไกลสูงสุดที่วาร์ปได้ (ถ้าต้องการจำกัดระยะ)
local MAX_DISTANCE = 1000 

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	-- ตรวจสอบว่าไม่ได้กำลังพิมพ์ในช่อง Chat และกดปุ่ม 
	if not gameProcessed and input.KeyCode == Enum.KeyCode.T then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then

			-- ตรวจสอบว่าเมาส์ชี้ไปที่ตำแหน่งใดในโลก (Vector3)
			local targetPosition = mouse.Hit.Position

			-- ย้ายตำแหน่งตัวละคร (บวกความสูงขึ้น 3 หน่วยเพื่อไม่ให้จมดิน)
			character:SetPrimaryPartCFrame(CFrame.new(targetPosition + Vector3.new(0, 3, 0)))
		end
	end
end)

--// Simple Aimbot + FOV Circle (LocalScript)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- SETTINGS
local AIMBOT_ENABLED = true
local FOV_RADIUS = 120
local AIM_PART = "UpperTorso"
local TEAM_CHECK = false

-- FOV Circle
local FOV = Drawing.new("Circle")
FOV.Color = Color3.fromRGB(0, 200, 255)
FOV.Thickness = 2
FOV.NumSides = 100
FOV.Radius = FOV_RADIUS
FOV.Filled = false
FOV.Visible = true

-- Toggle Aimbot
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Q then
		AIMBOT_ENABLED = not AIMBOT_ENABLED
	end
end)

-- หาเป้าที่ใกล้เมาส์ที่สุด
local function GetClosestPlayer()
	local closest = nil
	local shortest = FOV_RADIUS

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if TEAM_CHECK and player.Team == LocalPlayer.Team then continue end

			local part = player.Character:FindFirstChild(AIM_PART)
			local hum = player.Character:FindFirstChild("Humanoid")

			if part and hum and hum.Health > 0 then
				local pos, visible = Camera:WorldToViewportPoint(part.Position)
				if visible then
					local dist = (Vector2.new(pos.X, pos.Y) -
						Vector2.new(Mouse.X, Mouse.Y)).Magnitude

					if dist < shortest then
						shortest = dist
						closest = part
					end
				end
			end
		end
	end
	return closest
end

-- Update
RunService.RenderStepped:Connect(function()
	-- อัปเดตวง FOV
	FOV.Position = Vector2.new(Mouse.X, Mouse.Y)

	if AIMBOT_ENABLED then
		local target = GetClosestPlayer()
		if target then
			Camera.CFrame = CFrame.new(
				Camera.CFrame.Position,
				target.Position
			)
		end
	end
end)

--
