_G.FastAttack = true

if _G.FastAttack then
    local _ENV = (getgenv or getrenv or getfenv)()

    local function SafeWaitForChild(parent, childName)
        local success, result = pcall(function()
            return parent:WaitForChild(childName)
        end)
        if not success or not result then
            warn("noooooo: " .. childName)
        end
        return result
    end

    local function WaitChilds(path, ...)
        local last = path
        for _, child in {...} do
            last = last:FindFirstChild(child) or SafeWaitForChild(last, child)
            if not last then break end
        end
        return last
    end

    local VirtualInputManager = game:GetService("VirtualInputManager")
    local CollectionService = game:GetService("CollectionService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TeleportService = game:GetService("TeleportService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    if not Player then
        warn("Wtf, IDK what is that bug =)")
        return
    end

    local Remotes = SafeWaitForChild(ReplicatedStorage, "Remotes")
    if not Remotes then return end

    local Validator = SafeWaitForChild(Remotes, "Validator")
    local CommF = SafeWaitForChild(Remotes, "CommF_")
    local CommE = SafeWaitForChild(Remotes, "CommE")

    local ChestModels = SafeWaitForChild(workspace, "ChestModels")
    local WorldOrigin = SafeWaitForChild(workspace, "_WorldOrigin")
    local Characters = SafeWaitForChild(workspace, "Characters")
    local Enemies = SafeWaitForChild(workspace, "Enemies")
    local Map = SafeWaitForChild(workspace, "Map")

    local EnemySpawns = SafeWaitForChild(WorldOrigin, "EnemySpawns")
    local Locations = SafeWaitForChild(WorldOrigin, "Locations")

    local RenderStepped = RunService.RenderStepped
    local Heartbeat = RunService.Heartbeat
    local Stepped = RunService.Stepped

    local Modules = SafeWaitForChild(ReplicatedStorage, "Modules")
    local Net = SafeWaitForChild(Modules, "Net")

    local sethiddenproperty = sethiddenproperty or function(...) return ... end
    local setupvalue = setupvalue or (debug and debug.setupvalue)
    local getupvalue = getupvalue or (debug and debug.getupvalue)

    local Settings = {
        AutoClick = true,
        ClickDelay = 0,
    }

    local Module = {}

    Module.FastAttack = (function()
        if _ENV.rz_FastAttack then
            return _ENV.rz_FastAttack
        end

        local FastAttack = {
            Distance = 100,
            attackMobs = true,
            attackPlayers = true,
            Equipped = nil
        }

        local RegisterAttack = SafeWaitForChild(Net, "RE/RegisterAttack")
        local RegisterHit = SafeWaitForChild(Net, "RE/RegisterHit")

        local function IsAlive(character)
        return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0
        end

        local function ProcessEnemies(OthersEnemies, Folder)
            local BasePart = nil
            for _, Enemy in Folder:GetChildren() do
                local Head = Enemy:FindFirstChild("Head")
                if Head and IsAlive(Enemy) and Player:DistanceFromCharacter(Head.Position) < FastAttack.Distance then
                    if Enemy ~= Player.Character then
                        table.insert(OthersEnemies, { Enemy, Head })
                        BasePart = Head
                    end
                end
            end
            return BasePart
        end

        function FastAttack:Attack(BasePart, OthersEnemies)
            if not BasePart or #OthersEnemies == 0 then return end
            RegisterAttack:FireServer(Settings.ClickDelay or 0)
            RegisterHit:FireServer(BasePart, OthersEnemies)
        end

        function FastAttack:AttackNearest()
            local OthersEnemies = {}
            local Part1 = ProcessEnemies(OthersEnemies, Enemies)
            local Part2 = ProcessEnemies(OthersEnemies, Characters)
            if #OthersEnemies > 0 then
                self:Attack(Part1 or Part2, OthersEnemies)
            else
                task.wait(0)
            end
        end

        function FastAttack:BladeHits()
            local Equipped = IsAlive(Player.Character) and Player.Character:FindFirstChildOfClass("Tool")
            if Equipped and Equipped.ToolTip ~= "Gun" then
                self:AttackNearest()
            else
                task.wait(0)
            end
        end

        task.spawn(function()
            while task.wait(Settings.ClickDelay) do
                if Settings.AutoClick then
                    FastAttack:BladeHits()
                end
            end
        end)

        _ENV.rz_FastAttack = FastAttack
        return FastAttack
    end)()
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if getgenv().Team == "Marines" then
    ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
elseif getgenv().Team == "Pirates" then
    ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
end

repeat
    task.wait(1)
    local chooseTeam = playerGui:FindFirstChild("ChooseTeam", true)
    local uiController = playerGui:FindFirstChild("UIController", true)

    if chooseTeam and chooseTeam.Visible and uiController then
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and getfenv(v).script == uiController then
                local constant = getconstants(v)
                pcall(function()
                    if (constant[1] == "Pirates" or constant[1] == "Marines") and #constant == 1 then
                        if constant[1] == getgenv().Team then
                            v(getgenv().Team)
                        end
                    end
                end)
            end
        end
    end
until player.Team
hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Death), function() end)
hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Respawn), function() end)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
Window = Fluent:CreateWindow({
    Title = "Lunar",
    SubTitle="By BlastHuynz", 
    TabWidth=155, 
    Theme="Darker",
    Acrylic=false,
    Size=UDim2.fromOffset(500, 300), 
    MinimizeKey = Enum.KeyCode.LeftControl
})
local Tabs = {

Info=Window:AddTab({ Title="Tab Info" }),
    Main=Window:AddTab({ Title="Tab Fram" }),

Main1=Window:AddTab({ Title="Tab Fram Other" }),
    Sea=Window:AddTab({ Title="Tab Sea Event" }),
    Item=Window:AddTab({ Title="Tab Stack Fram" }),
    Setting=Window:AddTab({ Title="Tab Setting" }),
    Status=Window:AddTab({ Title="Tab Status" }),
    Stats=Window:AddTab({ Title="Tab Stats" }),
    Player=Window:AddTab({ Title="Tab Player" }),
    Teleport=Window:AddTab({ Title="Tab Teleport" }),
    Visual=Window:AddTab({ Title="Tab Visual" }),
    Fruit=Window:AddTab({ Title="Tab Fruit" }),
    Raid=Window:AddTab({ Title="Tab Raid" }),
    Race=Window:AddTab({ Title="Tab Race" }),
    Shop=Window:AddTab({ Title="Tab Shop" }),
    Misc=Window:AddTab({ Title="Tab Misc" }),
}
local Options = Fluent.Options
local id = game.PlaceId
if id==2753915549 then Sea1=true; elseif id==4442272183 then Sea2=true; elseif id==7449423635 then Sea3=true; else game:Shutdown() end;
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait()
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
Sea1=false
Sea2=false
Sea3=false
local placeId = game.PlaceId
if placeId==2753915549 then
Sea1=true
elseif placeId==4442272183 then
Sea2=true
elseif placeId==7449423635 then
Sea3=true
end
function CheckLevel()
local Lv = game:GetService("Players").LocalPlayer.Data.Level.Value
if Sea1 then
if Lv==1 or Lv<=9 or SelectMonster=="Bandit" then 
Ms="Bandit"
NameQuest="BanditQuest1"
QuestLv=1
NameMon="Bandit"
CFrameQ=CFrame.new(1060.9383544922, 16.455066680908, 1547.7841796875)
CFrameMon=CFrame.new(1038.5533447266, 41.296249389648, 1576.5098876953)
elseif Lv==10 or Lv<=14 or SelectMonster=="Monkey" then
Ms="Monkey"
NameQuest="JungleQuest"
QuestLv=1
NameMon="Monkey"
CFrameQ=CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
CFrameMon=CFrame.new(-1448.1446533203, 50.851993560791, 63.60718536377)
elseif Lv==15 or Lv<=29 or SelectMonster=="Gorilla" then
Ms="Gorilla"
NameQuest="JungleQuest"
QuestLv=2
NameMon="Gorilla"
CFrameQ=CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
CFrameMon=CFrame.new(-1142.6488037109, 40.462348937988,-515.39227294922)
elseif Lv==30 or Lv<=39 or SelectMonster=="Pirate" then
Ms="Pirate"
NameQuest="BuggyQuest1"
QuestLv=1
NameMon="Pirate"
CFrameQ=CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
CFrameMon=CFrame.new(-1201.0881347656, 40.628940582275, 3857.5966796875)
elseif Lv==40 or Lv<=59 or SelectMonster=="Brute" then
Ms="Brute"
NameQuest="BuggyQuest1"
QuestLv=2
NameMon="Brute"
CFrameQ=CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
CFrameMon=CFrame.new(-1387.5324707031, 24.592035293579, 4100.9575195313)
elseif Lv==60 or Lv<=74 or SelectMonster=="Desert Bandit" then
Ms="Desert Bandit"
NameQuest="DesertQuest"
QuestLv=1
NameMon="Desert Bandit"
CFrameQ=CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
CFrameMon=CFrame.new(984.99896240234, 16.109552383423, 4417.91015625)
elseif Lv==75 or Lv<=89 or SelectMonster=="Desert Officer" then
Ms="Desert Officer"
NameQuest="DesertQuest"
QuestLv=2
NameMon="Desert Officer"
CFrameQ=CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
CFrameMon=CFrame.new(1547.1510009766, 14.452038764954, 4381.8002929688)
elseif Lv==90 or Lv<=99 or SelectMonster=="Snow Bandit" then
Ms="Snow Bandit"
NameQuest="SnowQuest"
QuestLv=1
NameMon="Snow Bandit"
CFrameQ=CFrame.new(1386.8073730469, 87.272789001465,-1298.3576660156)
CFrameMon=CFrame.new(1356.3028564453, 105.76865386963,-1328.2418212891)
elseif Lv==100 or Lv<=119 or SelectMonster=="Snowman" then
Ms="Snowman"
NameQuest="SnowQuest"
QuestLv=2
NameMon="Snowman"
CFrameQ=CFrame.new(1386.8073730469, 87.272789001465,-1298.3576660156)
CFrameMon=CFrame.new(1218.7956542969, 138.01184082031,-1488.0262451172)
elseif Lv==120 or Lv<=149 or SelectMonster=="Chief Petty Officer" then
Ms="Chief Petty Officer"
NameQuest="MarineQuest2"
QuestLv=1
NameMon="Chief Petty Officer"
CFrameQ=CFrame.new(-5035.49609375, 28.677835464478, 4324.1840820313)
CFrameMon=CFrame.new(-4931.1552734375, 65.793113708496, 4121.8393554688)
elseif Lv==150 or Lv<=174 or SelectMonster=="Sky Bandit" then
Ms="Sky Bandit"
NameQuest="SkyQuest"
QuestLv=1
NameMon="Sky Bandit"
CFrameQ=CFrame.new(-4842.1372070313, 717.69543457031,-2623.0483398438)
CFrameMon=CFrame.new(-4955.6411132813, 365.46365356445,-2908.1865234375)
elseif Lv==175 or Lv<=189 or SelectMonster=="Dark Master" then
Ms="Dark Master"
NameQuest="SkyQuest"
QuestLv=2
NameMon="Dark Master"
CFrameQ=CFrame.new(-4842.1372070313, 717.69543457031,-2623.0483398438)
CFrameMon=CFrame.new(-5148.1650390625, 439.04571533203,-2332.9611816406)
elseif Lv==190 or Lv<=209 or SelectMonster=="Prisoner" then
Ms="Prisoner"
NameQuest="PrisonerQuest"
QuestLv=1
NameMon="Prisoner"
CFrameQ=CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0,-0.999846935, 0, 0.0175017118)
CFrameMon=CFrame.new(4937.31885, 0.332031399, 649.574524, 0.694649816, 0,-0.719348073, 0, 1, 0, 0.719348073, 0, 0.694649816)
elseif Lv==210 or Lv<=249 or SelectMonster=="Dangerous Prisoner" then
Ms="Dangerous Prisoner"
NameQuest="PrisonerQuest"
QuestLv=2
NameMon="Dangerous Prisoner"
CFrameQ=CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0,-0.999846935, 0, 0.0175017118)
CFrameMon=CFrame.new(5099.6626, 0.351562679, 1055.7583, 0.898906827, 0,-0.438139856, 0, 1, 0, 0.438139856, 0, 0.898906827)
elseif Lv==250 or Lv<=274 or SelectMonster=="Toga Warrior" then
Ms="Toga Warrior"
NameQuest="ColosseumQuest"
QuestLv=1
NameMon="Toga Warrior"
CFrameQ=CFrame.new(-1577.7890625, 7.4151420593262,-2984.4838867188)
CFrameMon=CFrame.new(-1872.5166015625, 49.080215454102,-2913.810546875)
elseif Lv==275 or Lv<=299 or SelectMonster=="Gladiator"  then
Ms="Gladiator"
NameQuest="ColosseumQuest"
QuestLv=2
NameMon="Gladiator"
CFrameQ=CFrame.new(-1577.7890625, 7.4151420593262,-2984.4838867188)
CFrameMon=CFrame.new(-1521.3740234375, 81.203170776367,-3066.3139648438)
elseif Lv==300 or Lv<=324 or SelectMonster=="Military Soldier" then
Ms="Military Soldier"
NameQuest="MagmaQuest"
QuestLv=1
NameMon="Military Soldier"
CFrameQ=CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
CFrameMon=CFrame.new(-5369.0004882813, 61.24352645874, 8556.4921875)
elseif Lv==325 or Lv<=374 or SelectMonster=="Military Spy" then
Ms="Military Spy"
NameQuest="MagmaQuest"
QuestLv=2
NameMon="Military Spy"
CFrameQ=CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
CFrameMon=CFrame.new(-5787.00293, 75.8262634, 8651.69922, 0.838590562, 0,-0.544762194, 0, 1, 0, 0.544762194, 0, 0.838590562)
elseif Lv==375 or Lv<=399 or SelectMonster=="Fishman Warrior" then 
Ms="Fishman Warrior"
NameQuest="FishmanQuest"
QuestLv=1
NameMon="Fishman Warrior"
CFrameQ=CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
CFrameMon=CFrame.new(60844.10546875, 98.462875366211, 1298.3985595703)
if _G.AutoLevel and (CFrameMon.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>3000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
end
elseif Lv==400 or Lv<=449 or SelectMonster=="Fishman Commando" then 
Ms="Fishman Commando"
NameQuest="FishmanQuest"
QuestLv=2
NameMon="Fishman Commando"
CFrameQ=CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
CFrameMon=CFrame.new(61738.3984375, 64.207321166992, 1433.8375244141)
if _G.AutoLevel and (CFrameMon.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>3000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
end
elseif Lv==10 or Lv<=474 or SelectMonster=="God's Guard" then 
Ms="God's Guard"
NameQuest="SkyExp1Quest"
QuestLv=1
NameMon="God's Guard"
CFrameQ=CFrame.new(-4721.8603515625, 845.30297851563,-1953.8489990234)
CFrameMon=CFrame.new(-4628.0498046875, 866.92877197266,-1931.2352294922)
if _G.AutoLevel and (CFrameMon.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>3000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248,-1667.55688))
end
elseif Lv==475 or Lv<=524 or SelectMonster=="Shanda" then 
Ms="Shanda"
NameQuest="SkyExp1Quest"
QuestLv=2
NameMon="Shanda"
CFrameQ=CFrame.new(-7863.1596679688, 5545.5190429688,-378.42266845703)
CFrameMon=CFrame.new(-7685.1474609375, 5601.0751953125,-441.38876342773)
if _G.AutoLevel and (CFrameMon.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>3000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625,-380.29119873047))
end
elseif Lv==525 or Lv<=549 or SelectMonster=="Royal Squad" then 
Ms="Royal Squad"
NameQuest="SkyExp2Quest"
QuestLv=1
NameMon="Royal Squad"
CFrameQ=CFrame.new(-7903.3828125, 5635.9897460938,-1410.923828125)
CFrameMon=CFrame.new(-7654.2514648438, 5637.1079101563,-1407.7550048828)
elseif Lv==550 or Lv<=624 or SelectMonster=="Royal Soldier" then 
Ms="Royal Soldier"
NameQuest="SkyExp2Quest"
QuestLv=2
NameMon="Royal Soldier"
CFrameQ=CFrame.new(-7903.3828125, 5635.9897460938,-1410.923828125)
CFrameMon=CFrame.new(-7760.4106445313, 5679.9077148438,-1884.8112792969)
elseif Lv==625 or Lv<=649 or SelectMonster=="Galley Pirate" then 
Ms="Galley Pirate"
NameQuest="FountainQuest"
QuestLv=1
NameMon="Galley Pirate"
CFrameQ=CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
CFrameMon=CFrame.new(5557.1684570313, 152.32717895508, 3998.7758789063)
elseif Lv>=650 or SelectMonster=="Galley Captain" then 
Ms="Galley Captain"
NameQuest="FountainQuest"
QuestLv=2
NameMon="Galley Captain"
CFrameQ=CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
CFrameMon=CFrame.new(5677.6772460938, 92.786109924316, 4966.6323242188)
end
end
if Sea2 then
if Lv==700 or Lv<=724 or SelectMonster=="Raider" then 
Ms="Raider"
NameQuest="Area1Quest"
QuestLv=1
NameMon="Raider"
CFrameQ=CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)
CFrameMon=CFrame.new(68.874565124512, 93.635643005371, 2429.6752929688)
elseif Lv==725 or Lv<=774 or SelectMonster=="Mercenary" then 
Ms="Mercenary"
NameQuest="Area1Quest"
QuestLv=2
NameMon="Mercenary"
CFrameQ=CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)
CFrameMon=CFrame.new(-864.85009765625, 122.47104644775, 1453.1505126953)
elseif Lv==775 or Lv<=799 or SelectMonster=="Swan Pirate" then 
Ms="Swan Pirate"
NameQuest="Area2Quest"
QuestLv=1
NameMon="Swan Pirate"
CFrameQ=CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
CFrameMon=CFrame.new(1065.3669433594, 137.64012145996, 1324.3798828125)
elseif Lv==800 or Lv<=874 or SelectMonster=="Factory Staff" then
Ms="Factory Staff"
NameQuest="Area2Quest"
QuestLv=2
NameMon="Factory Staff"
CFrameQ=CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
CFrameMon=CFrame.new(533.22045898438, 128.46876525879, 355.62615966797)
elseif Lv==875 or Lv<=899 or SelectMonster=="Marine Lieutenan" then
Ms="Marine Lieutenant"
NameQuest="MarineQuest3"
QuestLv=1
NameMon="Marine Lieutenant"
CFrameQ=CFrame.new(-2440.9934082031, 73.04190826416,-3217.7082519531)
CFrameMon=CFrame.new(-2489.2622070313, 84.613594055176,-3151.8830566406)
elseif Lv==900 or Lv<=949 or SelectMonster=="Marine Captain" then 
Ms="Marine Captain"
NameQuest="MarineQuest3"
QuestLv=2
NameMon="Marine Captain"
CFrameQ=CFrame.new(-2440.9934082031, 73.04190826416,-3217.7082519531)
CFrameMon=CFrame.new(-2335.2026367188, 79.786659240723,-3245.8674316406)
elseif Lv==950 or Lv<=974 or SelectMonster=="Zombie" then
Ms="Zombie"
NameQuest="ZombieQuest"
QuestLv=1
NameMon="Zombie"
CFrameQ=CFrame.new(-5494.3413085938, 48.505931854248,-794.59094238281)
CFrameMon=CFrame.new(-5536.4970703125, 101.08577728271,-835.59075927734)
elseif Lv==975 or Lv<=999 or SelectMonster=="Vampire" then
Ms="Vampire"
NameQuest="ZombieQuest"
QuestLv=2
NameMon="Vampire"
CFrameQ=CFrame.new(-5494.3413085938, 48.505931854248,-794.59094238281)
CFrameMon=CFrame.new(-5806.1098632813, 16.722528457642,-1164.4384765625)
elseif Lv==1000 or Lv<=1049 or SelectMonster=="Snow Trooper" then 
Ms="Snow Trooper"
NameQuest="SnowMountainQuest"
QuestLv=1
NameMon="Snow Trooper"
CFrameQ=CFrame.new(607.05963134766, 401.44781494141,-5370.5546875)
CFrameMon=CFrame.new(535.21051025391, 432.74209594727,-5484.9165039063)
elseif Lv==1050 or Lv<=1099 or SelectMonster=="Winter Warrior" then 
Ms="Winter Warrior"
NameQuest="SnowMountainQuest"
QuestLv=2
NameMon="Winter Warrior"
CFrameQ=CFrame.new(607.05963134766, 401.44781494141,-5370.5546875)
CFrameMon=CFrame.new(1234.4449462891, 456.95419311523,-5174.130859375)
elseif Lv==1100 or Lv<=1124 or SelectMonster=="Lab Subordinate" then 
Ms="Lab Subordinate"
NameQuest="IceSideQuest"
QuestLv=1
NameMon="Lab Subordinate"
CFrameQ=CFrame.new(-6061.841796875, 15.926671981812,-4902.0385742188)
CFrameMon=CFrame.new(-5720.5576171875, 63.309471130371,-4784.6103515625)
elseif Lv==1125 or Lv<=1174 or SelectMonster=="Horned Warrior" then
Ms="Horned Warrior"
NameQuest="IceSideQuest"
QuestLv=2
NameMon="Horned Warrior"
CFrameQ=CFrame.new(-6061.841796875, 15.926671981812,-4902.0385742188)
CFrameMon=CFrame.new(-6292.751953125, 91.181983947754,-5502.6499023438)
elseif Lv==1175 or Lv<=1199 or SelectMonster=="Magma Ninja" then 
Ms="Magma Ninja"
NameQuest="FireSideQuest"
QuestLv=1
NameMon="Magma Ninja"
CFrameQ=CFrame.new(-5429.0473632813, 15.977565765381,-5297.9614257813)
CFrameMon=CFrame.new(-5461.8388671875, 130.36347961426,-5836.4702148438)
elseif Lv==1200 or Lv<=1249 or SelectMonster=="Lava Pirate" then 
Ms="Lava Pirate"
NameQuest="FireSideQuest"
QuestLv=2
NameMon="Lava Pirate"
CFrameQ=CFrame.new(-5429.0473632813, 15.977565765381,-5297.9614257813)
CFrameMon=CFrame.new(-5251.1889648438, 55.164535522461,-4774.4096679688)
elseif Lv==1250 or Lv<=1274 or SelectMonster=="Ship Deckhand" then
Ms="Ship Deckhand"
NameQuest="ShipQuest1"
QuestLv=1
NameMon="Ship Deckhand"
CFrameQ=CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625)
CFrameMon=CFrame.new(921.12365722656, 125.9839553833, 33088.328125)
if _G.AutoLevel and (CFrameMon.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>20000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
end
elseif Lv==1275 or Lv<=1299 or SelectMonster=="Ship Engineer"  then 
Ms="Ship Engineer"
NameQuest="ShipQuest1"
QuestLv=2
NameMon="Ship Engineer"
CFrameQ=CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625)
CFrameMon=CFrame.new(886.28179931641, 40.47790145874, 32800.83203125)
if _G.AutoLevel and (CFrameMon.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>20000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
end
elseif Lv==1300 or Lv<=1324 or SelectMonster=="Ship Steward" then 
Ms="Ship Steward"
NameQuest="ShipQuest2"
QuestLv=1
NameMon="Ship Steward"
CFrameQ=CFrame.new(971.42065429688, 125.08293151855, 33245.54296875)
CFrameMon=CFrame.new(943.85504150391, 129.58183288574, 33444.3671875)
if _G.AutoLevel and (CFrameMon.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>20000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
end
elseif Lv==1325 or Lv<=1349 or SelectMonster=="Ship Officer" then 
Ms="Ship Officer"
NameQuest="ShipQuest2"
QuestLv=2
NameMon="Ship Officer"
CFrameQ=CFrame.new(971.42065429688, 125.08293151855, 33245.54296875)
CFrameMon=CFrame.new(955.38458251953, 181.08335876465, 33331.890625)
if _G.AutoLevel and (CFrameMon.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>20000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
end
elseif Lv==1350 or Lv<=1374 or SelectMonster=="Arctic Warrior" then 
Ms="Arctic Warrior"
NameQuest="FrostQuest"
QuestLv=1
NameMon="Arctic Warrior"
CFrameQ=CFrame.new(5668.1372070313, 28.202531814575,-6484.6005859375)
CFrameMon=CFrame.new(5935.4541015625, 77.26016998291,-6472.7568359375)
if _G.AutoLevel and (CFrameMon.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>20000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-6508.5581054688, 89.034996032715,-132.83953857422))
end
elseif Lv==1375 or Lv<=1424 or SelectMonster=="Snow Lurker" then
Ms="Snow Lurker"
NameQuest="FrostQuest"
QuestLv=2
NameMon="Snow Lurker"
CFrameQ=CFrame.new(5668.1372070313, 28.202531814575,-6484.6005859375)
CFrameMon=CFrame.new(5628.482421875, 57.574996948242,-6618.3481445313)
elseif Lv==1425 or Lv<=1449 or SelectMonster=="Sea Soldier" then
Ms="Sea Soldier"
NameQuest="ForgottenQuest"
QuestLv=1
NameMon="Sea Soldier"
CFrameQ=CFrame.new(-3054.5827636719, 236.87213134766,-10147.790039063)
CFrameMon=CFrame.new(-3185.0153808594, 58.789089202881,-9663.6064453125)
elseif Lv>=1450 or SelectMonster=="Water Fighter" then 
Ms="Water Fighter"
NameQuest="ForgottenQuest"
QuestLv=2
NameMon="Water Fighter"
CFrameQ=CFrame.new(-3054.5827636719, 236.87213134766,-10147.790039063)
CFrameMon=CFrame.new(-3262.9301757813, 298.69036865234,-10552.529296875)
end
end
if Sea3 then
if Lv==1500 or Lv<=1524 or SelectMonster=="Pirate Millionaire" then 
Ms="Pirate Millionaire"
NameQuest="PiratePortQuest"
QuestLv=1
NameMon="Pirate Millionaire"
CFrameQ=CFrame.new(-450.1046447753906, 107.68145751953125, 5950.72607421875)
CFrameMon=CFrame.new(-193.99227905273438, 56.12502670288086, 5755.7880859375)
elseif Lv==1525 or Lv<=1574 or SelectMonster=="Pistol Billionaire" then 
Ms="Pistol Billionaire"
NameQuest="PiratePortQuest"
QuestLv=2
NameMon="Pistol Billionaire"
CFrameQ=CFrame.new(-450.1046447753906, 107.68145751953125, 5950.72607421875)
CFrameMon=CFrame.new(-188.14462280273438, 84.49613189697266, 6337.0419921875)
elseif Lv==1575 or Lv<=1599 or SelectMonster=="Dragon Crew Warrior" then 
Ms="Dragon Crew Warrior"
NameQuest="DragonCrewQuest"
QuestLv=1
NameMon="Dragon Crew Warrior"
CFrameQ=CFrame.new(6735.11083984375, 126.99046325683594,-711.0979614257812)
CFrameMon=CFrame.new(6615.2333984375, 50.847679138183594,-978.93408203125)
elseif Lv==1600 or Lv<=1624 or SelectMonster=="Dragon Crew Archer" then 
Ms="Dragon Crew Archer"
NameQuest="DragonCrewQuest"
QuestLv=2
NameMon="Dragon Crew Archer"
CFrameQ=CFrame.new(6735.11083984375, 126.99046325683594,-711.0979614257812)
CFrameMon=CFrame.new(6818.58935546875, 483.718994140625, 512.726806640625)
elseif Lv==1625 or Lv<=1649 or SelectMonster=="Hydra Enforcer" then 
Ms="Hydra Enforcer"
NameQuest="VenomCrewQuest"
QuestLv=1
NameMon="Hydra Enforcer"
CFrameQ=CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
CFrameMon=CFrame.new(4547.115234375, 1001.60205078125, 334.1954650878906)
elseif Lv==1650 or Lv<=1699 or SelectMonster=="Venomous Assailant" then 
Ms="Venomous Assailant"
NameQuest="VenomCrewQuest"
QuestLv=2
NameMon="Venomous Assailant"
CFrameQ=CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
CFrameMon=CFrame.new(4637.88525390625, 1077.85595703125, 882.4183959960938)
elseif Lv==1700 or Lv<=1724 or SelectMonster=="Marine Commodore" then
Ms="Marine Commodore"
NameQuest="MarineTreeIsland"
QuestLv=1
NameMon="Marine Commodore"
CFrameQ=CFrame.new(2179.98828125, 28.731239318848,-6740.0551757813)
CFrameMon=CFrame.new(2198.0063476563, 128.71075439453,-7109.5043945313)
elseif Lv==1725 or Lv<=1774 or SelectMonster=="Marine Rear Admiral" then
Ms="Marine Rear Admiral"
NameQuest="MarineTreeIsland"
QuestLv=2
NameMon="Marine Rear Admiral"
CFrameQ=CFrame.new(2179.98828125, 28.731239318848,-6740.0551757813)
CFrameMon=CFrame.new(3294.3142089844, 385.41125488281,-7048.6342773438)
elseif Lv==1775 or Lv<=1799 or SelectMonster=="Fishman Raider" then 
Ms="Fishman Raider"
NameQuest="DeepForestIsland3"
QuestLv=1
NameMon="Fishman Raider"
CFrameQ=CFrame.new(-10582.759765625, 331.78845214844,-8757.666015625)
CFrameMon=CFrame.new(-10553.268554688, 521.38439941406,-8176.9458007813)
elseif Lv==1800 or Lv<=1824 or SelectMonster=="Fishman Captain" then
Ms="Fishman Captain"
NameQuest="DeepForestIsland3"
QuestLv=2
NameMon="Fishman Captain"
CFrameQ=CFrame.new(-10583.099609375, 331.78845214844,-8759.4638671875)
CFrameMon=CFrame.new(-10789.401367188, 427.18637084961,-9131.4423828125)
elseif Lv==1825 or Lv<=1849 or SelectMonster=="Forest Pirate" then 
Ms="Forest Pirate"
NameQuest="DeepForestIsland"
QuestLv=1
NameMon="Forest Pirate"
CFrameQ=CFrame.new(-13232.662109375, 332.40396118164,-7626.4819335938)
CFrameMon=CFrame.new(-13489.397460938, 400.30349731445,-7770.251953125)
elseif Lv==1850 or Lv<=1899 or SelectMonster=="Mythological Pirate" then 
Ms="Mythological Pirate"
NameQuest="DeepForestIsland"
QuestLv=2
NameMon="Mythological Pirate"
CFrameQ=CFrame.new(-13232.662109375, 332.40396118164,-7626.4819335938)
CFrameMon=CFrame.new(-13508.616210938, 582.46228027344,-6985.3037109375)
elseif Lv==1900 or Lv<=1924 or SelectMonster=="Jungle Pirate" then 
Ms="Jungle Pirate"
NameQuest="DeepForestIsland2"
QuestLv=1
NameMon="Jungle Pirate"
CFrameQ=CFrame.new(-12682.096679688, 390.88653564453,-9902.1240234375)
CFrameMon=CFrame.new(-12267.103515625, 459.75262451172,-10277.200195313)
elseif Lv==1925 or Lv<=1974 or SelectMonster=="Musketeer Pirate" then 
Ms="Musketeer Pirate"
NameQuest="DeepForestIsland2"
QuestLv=2
NameMon="Musketeer Pirate"
CFrameQ=CFrame.new(-12682.096679688, 390.88653564453,-9902.1240234375)
CFrameMon=CFrame.new(-13291.5078125, 520.47338867188,-9904.638671875)
elseif Lv==1975 or Lv<=1999 or SelectMonster=="Reborn Skeleton" then
Ms="Reborn Skeleton"
NameQuest="HauntedQuest1"
QuestLv=1
NameMon="Reborn Skeleton"
CFrameQ=CFrame.new(-9480.80762, 142.130661, 5566.37305,-0.00655503059, 4.52954225e-08,-0.999978542, 2.04920472e-08, 1, 4.51620679e-08, 0.999978542,-2.01955679e-08,-0.00655503059)
CFrameMon=CFrame.new(-8761.77148, 183.431747, 6168.33301, 0.978073597,-1.3950732e-05,-0.208259016,-1.08073925e-06, 1,-7.20630269e-05, 0.208259016, 7.07080399e-05, 0.978073597)
elseif Lv==2000 or Lv<=2024 or SelectMonster=="Living Zombie" then
Ms="Living Zombie"
NameQuest="HauntedQuest1"
QuestLv=2
NameMon="Living Zombie"
CFrameQ=CFrame.new(-9480.80762, 142.130661, 5566.37305,-0.00655503059, 4.52954225e-08,-0.999978542, 2.04920472e-08, 1, 4.51620679e-08, 0.999978542,-2.01955679e-08,-0.00655503059)
CFrameMon=CFrame.new(-10103.7529, 238.565979, 6179.75977, 0.999474227, 2.77547141e-08, 0.0324240364,-2.58006327e-08, 1,-6.06848474e-08,-0.0324240364, 5.98163865e-08, 0.999474227)
elseif Lv==2025 or Lv<=2049 or SelectMonster=="Demonic Soul" then
Ms="Demonic Soul"
NameQuest="HauntedQuest2"
QuestLv=1
NameMon="Demonic Soul"
CFrameQ=CFrame.new(-9516.9931640625, 178.00651550293, 6078.4653320313)
CFrameMon=CFrame.new(-9712.03125, 204.69589233398, 6193.322265625)
elseif Lv==2050 or Lv<=2074 or SelectMonster=="Posessed Mummy" then
Ms="Posessed Mummy"
NameQuest="HauntedQuest2"
QuestLv=2
NameMon="Posessed Mummy"
CFrameQ=CFrame.new(-9516.9931640625, 178.00651550293, 6078.4653320313)
CFrameMon=CFrame.new(-9545.7763671875, 69.619895935059, 6339.5615234375)
elseif Lv==2075 or Lv<=2099 or SelectMonster=="Peanut Scout" then
Ms="Peanut Scout"
NameQuest="NutsIslandQuest"
QuestLv=1
NameMon="Peanut Scout"
CFrameQ=CFrame.new(-2105.53198, 37.2495995,-10195.5088,-0.766061664, 0,-0.642767608, 0, 1, 0, 0.642767608, 0,-0.766061664)
CFrameMon=CFrame.new(-2150.587890625, 122.49767303467,-10358.994140625)
elseif Lv==2100 or Lv<=2124 or SelectMonster=="Peanut President" then
Ms="Peanut President"
NameQuest="NutsIslandQuest"
QuestLv=2
NameMon="Peanut President"
CFrameQ=CFrame.new(-2105.53198, 37.2495995,-10195.5088,-0.766061664, 0,-0.642767608, 0, 1, 0, 0.642767608, 0,-0.766061664)
CFrameMon=CFrame.new(-2150.587890625, 122.49767303467,-10358.994140625)
elseif Lv==2125 or Lv<=2149 or SelectMonster=="Ice Cream Chef" then
Ms="Ice Cream Chef"
NameQuest="IceCreamIslandQuest"
QuestLv=1
NameMon="Ice Cream Chef"
CFrameQ=CFrame.new(-819.376709, 64.9259796,-10967.2832,-0.766061664, 0, 0.642767608, 0, 1, 0,-0.642767608, 0,-0.766061664)
CFrameMon=CFrame.new(-789.941528, 209.382889,-11009.9805,-0.0703101531,-0,-0.997525156,-0, 1.00000012,-0, 0.997525275, 0,-0.0703101456)
elseif Lv==2150 or Lv<=2199 or SelectMonster=="Ice Cream Commander" then
Ms="Ice Cream Commander"
NameQuest="IceCreamIslandQuest"
QuestLv=2
NameMon="Ice Cream Commander"
CFrameQ=CFrame.new(-819.376709, 64.9259796,-10967.2832,-0.766061664, 0, 0.642767608, 0, 1, 0,-0.642767608, 0,-0.766061664)
CFrameMon=CFrame.new(-789.941528, 209.382889,-11009.9805,-0.0703101531,-0,-0.997525156,-0, 1.00000012,-0, 0.997525275, 0,-0.0703101456)
elseif Lv==2200 or Lv<=2224 or SelectMonster=="Cookie Crafter" then
Ms="Cookie Crafter"
NameQuest="CakeQuest1"
QuestLv=1
NameMon="Cookie Crafter"
CFrameQ=CFrame.new(-2022.29858, 36.9275894,-12030.9766,-0.961273909, 0,-0.275594592, 0, 1, 0, 0.275594592, 0,-0.961273909)
CFrameMon=CFrame.new(-2321.71216, 36.699482,-12216.7871,-0.780074954, 0, 0.625686109, 0, 1, 0,-0.625686109, 0,-0.780074954)
elseif Lv==2225 or Lv<=2249 or SelectMonster=="Cake Guard" then
Ms="Cake Guard"
NameQuest="CakeQuest1"
QuestLv=2
NameMon="Cake Guard"
CFrameQ=CFrame.new(-2022.29858, 36.9275894,-12030.9766,-0.961273909, 0,-0.275594592, 0, 1, 0, 0.275594592, 0,-0.961273909)
CFrameMon=CFrame.new(-1418.11011, 36.6718941,-12255.7324, 0.0677844882, 0, 0.997700036, 0, 1, 0,-0.997700036, 0, 0.0677844882)
elseif Lv==2250 or Lv<=2274 or SelectMonster=="Baking Staff" then
Ms="Baking Staff"
NameQuest="CakeQuest2"
QuestLv=1
NameMon="Baking Staff"
CFrameQ=CFrame.new(-1928.31763, 37.7296638,-12840.626, 0.951068401,-0,-0.308980465, 0, 1,-0, 0.308980465, 0, 0.951068401)
CFrameMon=CFrame.new(-1980.43848, 36.6716766,-12983.8418,-0.254443765, 0,-0.967087567, 0, 1, 0, 0.967087567, 0,-0.254443765)
elseif Lv==2275 or Lv<=2299 or SelectMonster=="Head Baker" then
Ms="Head Baker"
NameQuest="CakeQuest2"
QuestLv=2
NameMon="Head Baker"
CFrameQ=CFrame.new(-1928.31763, 37.7296638,-12840.626, 0.951068401,-0,-0.308980465, 0, 1,-0, 0.308980465, 0, 0.951068401)
CFrameMon=CFrame.new(-2251.5791, 52.2714615,-13033.3965,-0.991971016, 0,-0.126466095, 0, 1, 0, 0.126466095, 0,-0.991971016)
elseif Lv==2300 or Lv<=2324 or SelectMonster=="Cocoa Warrior" then
Ms="Cocoa Warrior"
NameQuest="ChocQuest1"
QuestLv=1
NameMon="Cocoa Warrior"
CFrameQ=CFrame.new(231.75, 23.9003029,-12200.292,-1, 0, 0, 0, 1, 0, 0, 0,-1)
CFrameMon=CFrame.new(167.978516, 26.2254658,-12238.874,-0.939700961, 0, 0.341998369, 0, 1, 0,-0.341998369, 0,-0.939700961)
elseif Lv==2325 or Lv<=2349 or SelectMonster=="Chocolate Bar Battler" then
Ms="Chocolate Bar Battler"
NameQuest="ChocQuest1"
QuestLv=2
NameMon="Chocolate Bar Battler"
CFrameQ=CFrame.new(231.75, 23.9003029,-12200.292,-1, 0, 0, 0, 1, 0, 0, 0,-1)
CFrameMon=CFrame.new(701.312073, 25.5824986,-12708.2148,-0.342042685, 0,-0.939684391, 0, 1, 0, 0.939684391, 0,-0.342042685)
elseif Lv==2350 or Lv<=2374 or SelectMonster=="Sweet Thief" then
Ms="Sweet Thief"
NameQuest="ChocQuest2"
QuestLv=1
NameMon="Sweet Thief"
CFrameQ=CFrame.new(151.198242, 23.8907146,-12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0,-0.906319618, 0, 0.422592998)
CFrameMon=CFrame.new(-140.258301, 25.5824986,-12652.3115, 0.173624337,-0,-0.984811902, 0, 1,-0, 0.984811902, 0, 0.173624337)
elseif Lv==2375 or Lv<=2400 or SelectMonster=="Candy Rebel" then
Ms="Candy Rebel"
NameQuest="ChocQuest2"
QuestLv=2
NameMon="Candy Rebel"
CFrameQ=CFrame.new(151.198242, 23.8907146,-12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0,-0.906319618, 0, 0.422592998)
CFrameMon=CFrame.new(47.9231453, 25.5824986,-13029.2402,-0.819156051, 0,-0.573571265, 0, 1, 0, 0.573571265, 0,-0.819156051)
elseif Lv==2400 or Lv<=2424 or SelectMonster=="Candy Pirate" then
Ms="Candy Pirate"
NameQuest="CandyQuest1"
QuestLv=1
NameMon="Candy Pirate"
CFrameQ=CFrame.new(-1149.328, 13.5759039,-14445.6143,-0.156446099, 0,-0.987686574, 0, 1, 0, 0.987686574, 0,-0.156446099)
CFrameMon=CFrame.new(-1437.56348, 17.1481285,-14385.6934, 0.173624337,-0,-0.984811902, 0, 1,-0, 0.984811902, 0, 0.173624337)
elseif Lv==2425 or Lv<=2449 or SelectMonster=="Snow Demon" then
Ms="Snow Demon"
NameQuest="CandyQuest1"
QuestLv=2
NameMon="Snow Demon"
CFrameQ=CFrame.new(-1149.328, 13.5759039,-14445.6143,-0.156446099, 0,-0.987686574, 0, 1, 0, 0.987686574, 0,-0.156446099)
CFrameMon=CFrame.new(-916.222656, 17.1481285,-14638.8125, 0.866007268, 0, 0.500031412, 0, 1, 0,-0.500031412, 0, 0.866007268)
elseif Lv==2450 or Lv<=2474 or SelectMonster=="Isle Outlaw" then
Ms="Isle Outlaw"
NameQuest="TikiQuest1"
QuestLv=1
NameMon="Isle Outlaw"
CFrameQ=CFrame.new(-16549.890625, 55.68635559082031,-179.91360473632812)
CFrameMon=CFrame.new(-16162.8193359375, 11.6863374710083,-96.45481872558594)
elseif Lv==2475 or Lv<=2499  or SelectMonster=="Island Boy" then
Ms="Island Boy"
NameQuest="TikiQuest1"
QuestLv=2
NameMon="Island Boy"
CFrameQ=CFrame.new(-16549.890625, 55.68635559082031,-179.91360473632812)
CFrameMon=CFrame.new(-16357.3125, 20.632822036743164, 1005.64892578125)
elseif Lv==2500 or Lv<=2524 or SelectMonster=="Sun-kissed Warrior" then
Ms="Sun-kissed Warrior"
NameQuest="TikiQuest2"
QuestLv=1
NameMon="Sun-kissed Warrior"
CFrameQ=CFrame.new(-16541.021484375, 54.77081298828125, 1051.461181640625)
CFrameMon=CFrame.new(-16357.3125, 20.632822036743164, 1005.64892578125)
elseif Lv==2525 or Lv<=2549 or SelectMonster=="Isle Champion" then
Ms="Isle Champion"
NameQuest="TikiQuest2"
QuestLv=2
NameMon="Isle Champion"
CFrameQ=CFrame.new(-16541.021484375, 54.77081298828125, 1051.461181640625)
CFrameMon=CFrame.new(-16848.94140625, 21.68633460998535, 1041.4490966796875)
elseif Lv==2550 or Lv<=2574 or SelectMonster=="Serpent Hunter" then
Ms="Serpent Hunter"
NameQuest="TikiQuest3"
QuestLv=1
NameMon="Serpent Hunter"
CFrameQ=CFrame.new(-16665.19140625, 104.59640502929688, 1579.6943359375)
CFrameMon=CFrame.new(-16621.4140625, 121.40631103515625, 1290.6881103515625)
elseif Lv==2575 or Lv<=2599 or SelectMonster=="Skull Slayer" or Lv==2600 then
Ms="Skull Slayer"
NameQuest="TikiQuest3"
QuestLv=2
NameMon="Skull Slayer"
CFrameQ=CFrame.new(-16665.19140625, 104.59640502929688, 1579.6943359375)
CFrameMon=CFrame.new(-16811.5703125, 84.625244140625, 1542.235107421875)
end
end
end
if Sea1 then
tableMon={
  "Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer","Sky Bandit","Dark Master","Prisoner", "Dangerous Prisoner","Toga Warrior","Gladiator","Military Soldier","Military Spy","Fishman Warrior","Fishman Commando","God's Guard","Shanda","Royal Squad","Royal Soldier","Galley Pirate","Galley Captain"
} elseif Sea2 then
tableMon={
  "Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant","Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"
} elseif Sea3 then
tableMon={
  "Pirate Millionaire","Dragon Crew Warrior","Dragon Crew Archer","Hydra Enforcer","Venomous Assailant","Marine Commodore","Marine Rear Admiral","Fishman Raider","Fishman Captain","Forest Pirate","Mythological Pirate","Jungle Pirate","Musketeer Pirate","Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy", "Peanut Scout", "Peanut President", "Ice Cream Chef", "Ice Cream Commander", "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker", "Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief", "Candy Rebel", "Candy Pirate", "Snow Demon","Isle Outlaw","Island Boy","Sun-kissed Warrior","Isle Champion","Serpent Hunter","Skull Slayer"
}
end
if Sea1 then
AreaList={
  'Jungle', 'Buggy', 'Desert', 'Snow', 'Marine', 'Sky', 'Prison', 'Colosseum', 'Magma', 'Fishman', 'Sky Island', 'Fountain'
} elseif Sea2 then
AreaList={
  'Area 1', 'Area 2', 'Zombie', 'Marine', 'Snow Mountain', 'Ice fire', 'Ship', 'Frost', 'Forgotten'
} elseif Sea3 then
AreaList={
  'Pirate Port', 'Amazon', 'Marine Tree', 'Deep Forest', 'Haunted Castle', 'Nut Island', 'Ice Cream Island', 'Cake Island', 'Choco Island', 'Candy Island','Tiki Outpost'
}
end
function CheckBossQuest()
if Sea1 then
if SelectBoss=="The Gorilla King" then
BossMon="The Gorilla King"
NameBoss='The Gorrila King'
NameQuestBoss="JungleQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$2,000\n7,000 Exp."
CFrameQBoss=CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
CFrameBoss=CFrame.new(-1088.75977, 8.13463783,-488.559906,-0.707134247, 0, 0.707079291, 0, 1, 0,-0.707079291, 0,-0.707134247)
elseif SelectBoss=="Bobby" then
BossMon="Bobby"
NameBoss='Bobby'
NameQuestBoss="BuggyQuest1"
QuestLvBoss=3
RewardBoss="Reward:\n$8,000\n35,000 Exp."
CFrameQBoss=CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
CFrameBoss=CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344)
elseif SelectBoss=="The Saw" then
BossMon="The Saw"
NameBoss='The Saw'
CFrameBoss=CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906)
elseif SelectBoss=="Yeti" then
BossMon="Yeti"
NameBoss='Yeti'
NameQuestBoss="SnowQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$10,000\n180,000 Exp."
CFrameQBoss=CFrame.new(1386.8073730469, 87.272789001465,-1298.3576660156)
CFrameBoss=CFrame.new(1218.7956542969, 138.01184082031,-1488.0262451172)
elseif SelectBoss=="Mob Leader" then
BossMon="Mob Leader"
NameBoss='Mob Leader'
CFrameBoss=CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813)
elseif SelectBoss=="Vice Admiral" then
BossMon="Vice Admiral"
NameBoss='Vice Admiral'
NameQuestBoss="MarineQuest2"
QuestLvBoss=2
RewardBoss="Reward:\n$10,000\n180,000 Exp."
CFrameQBoss=CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625)
CFrameBoss=CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375)
elseif SelectBoss=="Saber Expert" then
NameBoss='Saber Expert'
BossMon="Saber Expert"
CFrameBoss=CFrame.new(-1458.89502, 29.8870335,-50.633564)
elseif SelectBoss=="Warden" then
BossMon="Warden"
NameBoss='Warden'
NameQuestBoss="ImpelQuest"
QuestLvBoss=1
RewardBoss="Reward:\n$6,000\n850,000 Exp."
CFrameBoss=CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961,-4.49946401e-06, 0.975376427,-1.95412576e-05, 1, 9.03162072e-06,-0.975376427,-2.10519756e-05, 0.220546961)
CFrameQBoss=CFrame.new(5191.86133, 2.84020686, 686.438721,-0.731384635, 0, 0.681965172, 0, 1, 0,-0.681965172, 0,-0.731384635)
elseif SelectBoss=="Chief Warden" then
BossMon="Chief Warden"
NameBoss='Chief Warden'
NameQuestBoss="ImpelQuest"
QuestLvBoss=2
RewardBoss="Reward:\n$10,000\n1,000,000 Exp."
CFrameBoss=CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343,-0.00062915677, 0.939684749, 0.00191645394, 0.999998152,-2.80422337e-05,-0.939682961, 0.00181045406, 0.342041939)
CFrameQBoss=CFrame.new(5191.86133, 2.84020686, 686.438721,-0.731384635, 0, 0.681965172, 0, 1, 0,-0.681965172, 0,-0.731384635)
elseif SelectBoss=="Swan" then
BossMon="Swan"
NameBoss='Swan'
NameQuestBoss="ImpelQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$15,000\n1,600,000 Exp."
CFrameBoss=CFrame.new(5325.09619, 7.03906584, 719.570679,-0.309060812, 0, 0.951042235, 0, 1, 0,-0.951042235, 0,-0.309060812)
CFrameQBoss=CFrame.new(5191.86133, 2.84020686, 686.438721,-0.731384635, 0, 0.681965172, 0, 1, 0,-0.681965172, 0,-0.731384635)
elseif SelectBoss=="Magma Admiral" then
BossMon="Magma Admiral"
NameBoss='Magma Admiral'
NameQuestBoss="MagmaQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$15,000\n2,800,000 Exp."
CFrameQBoss=CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875)
CFrameBoss=CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875)
elseif SelectBoss=="Fishman Lord" then
BossMon="Fishman Lord"
NameBoss='Fishman Lord'
NameQuestBoss="FishmanQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$15,000\n4,000,000 Exp."
CFrameQBoss=CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
CFrameBoss=CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984)
elseif SelectBoss=="Wysper" then
BossMon="Wysper"
NameBoss='Wysper'
NameQuestBoss="SkyExp1Quest"
QuestLvBoss=3
RewardBoss="Reward:\n$15,000\n4,800,000 Exp."
CFrameQBoss=CFrame.new(-7861.947265625, 5545.517578125,-379.85974121094)
CFrameBoss=CFrame.new(-7866.1333007813, 5576.4311523438,-546.74816894531)
elseif SelectBoss=="Thunder God" then
BossMon="Thunder God"
NameBoss='Thunder God'
NameQuestBoss="SkyExp2Quest"
QuestLvBoss=3
RewardBoss="Reward:\n$20,000\n5,800,000 Exp."
CFrameQBoss=CFrame.new(-7903.3828125, 5635.9897460938,-1410.923828125)
CFrameBoss=CFrame.new(-7994.984375, 5761.025390625,-2088.6479492188)
elseif SelectBoss=="Cyborg" then
BossMon="Cyborg"
NameBoss='Cyborg'
NameQuestBoss="FountainQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$20,000\n7,500,000 Exp."
CFrameQBoss=CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
CFrameBoss=CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)
elseif SelectBoss=="Ice Admiral" then
BossMon="Ice Admiral"
NameBoss='Ice Admiral'
CFrameBoss=CFrame.new(1266.08948, 26.1757946,-1399.57678,-0.573599219, 0,-0.81913656, 0, 1, 0, 0.81913656, 0,-0.573599219)
elseif SelectBoss=="Greybeard" then
BossMon="Greybeard"
NameBoss='Greybeard'
CFrameBoss=CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
end
end
if Sea2 then
if SelectBoss=="Diamond" then
BossMon="Diamond"
NameBoss='Diamond'
NameQuestBoss="Area1Quest"
QuestLvBoss=3
RewardBoss="Reward:\n$25,000\n9,000,000 Exp."
CFrameQBoss=CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375)
CFrameBoss=CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407)
elseif SelectBoss=="Jeremy" then
BossMon="Jeremy"
NameBoss='Jeremy'
NameQuestBoss="Area2Quest"
QuestLvBoss=3
RewardBoss="Reward:\n$25,000\n11,500,000 Exp."
CFrameQBoss=CFrame.new(636.79943847656, 73.413787841797, 918.00415039063)
CFrameBoss=CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)
elseif SelectBoss=="Fajita" then
BossMon="Fajita"
NameBoss='Fajita'
NameQuestBoss="MarineQuest3"
QuestLvBoss=3
RewardBoss="Reward:\n$25,000\n15,000,000 Exp."
CFrameQBoss=CFrame.new(-2441.986328125, 73.359344482422,-3217.5324707031)
CFrameBoss=CFrame.new(-2172.7399902344, 103.32216644287,-4015.025390625)
elseif SelectBoss=="Don Swan" then
BossMon="Don Swan"
NameBoss='Don Swan'
CFrameBoss=CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)
elseif SelectBoss=="Smoke Admiral" then
BossMon="Smoke Admiral"
NameBoss='Smoke Admiral'
NameQuestBoss="IceSideQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$20,000\n25,000,000 Exp."
CFrameQBoss=CFrame.new(-5429.0473632813, 15.977565765381,-5297.9614257813)
CFrameBoss=CFrame.new(-5275.1987304688, 20.757257461548,-5260.6669921875)
elseif SelectBoss=="Awakened Ice Admiral" then
BossMon="Awakened Ice Admiral"
NameBoss='Awakened Ice Admiral'
NameQuestBoss="FrostQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$20,000\n36,000,000 Exp."
CFrameQBoss=CFrame.new(5668.9780273438, 28.519989013672,-6483.3520507813)
CFrameBoss=CFrame.new(6403.5439453125, 340.29766845703,-6894.5595703125)
elseif SelectBoss=="Tide Keeper" then
BossMon="Tide Keeper"
NameBoss='Tide Keeper'
NameQuestBoss="ForgottenQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$12,500\n38,000,000 Exp."
CFrameQBoss=CFrame.new(-3053.9814453125, 237.18954467773,-10145.0390625)
CFrameBoss=CFrame.new(-3795.6423339844, 105.88877105713,-11421.307617188)
elseif SelectBoss=="Darkbeard" then
BossMon="Darkbeard"
NameBoss='Darkbeard'
CFrameMon=CFrame.new(3677.08203125, 62.751937866211,-3144.8332519531)
elseif SelectBoss=="Cursed Captain" then
BossMon="Cursed Captain"
NameBoss='Cursed Captain'
CFrameBoss=CFrame.new(916.928589, 181.092773, 33422)
elseif SelectBoss=="Order" then
BossMon="Order"
NameBoss='Order'
CFrameBoss=CFrame.new(-6217.2021484375, 28.047645568848,-5053.1357421875)
end
end
if Sea3 then
if SelectBoss=="Stone" then
BossMon="Stone"
NameBoss='Stone'
NameQuestBoss="PiratePortQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$25,000\n40,000,000 Exp."
CFrameQBoss=CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625)
CFrameBoss=CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438)
elseif SelectBoss=="Hydra Leader" then
BossMon="Hydra Leader"
NameBoss='Hydra Leader'
NameQuestBoss="VenomCrewQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$30,000\n52,000,000 Exp."
CFrameQBoss=CFrame.new(5445.9541015625, 601.62945556641, 751.43792724609)
CFrameBoss=CFrame.new(5543.86328125, 668.97399902344, 199.0341796875)
elseif SelectBoss=="Kilo Admiral" then
BossMon="Kilo Admiral"
NameBoss='Kilo Admiral'
NameQuestBoss="MarineTreeIsland"
QuestLvBoss=3
RewardBoss="Reward:\n$35,000\n56,000,000 Exp."
CFrameQBoss=CFrame.new(2179.3010253906, 28.731239318848,-6739.9741210938)
CFrameBoss=CFrame.new(2764.2233886719, 432.46154785156,-7144.4580078125)
elseif SelectBoss=="Captain Elephant" then
BossMon="Captain Elephant"
NameBoss='Captain Elephant'
NameQuestBoss="DeepForestIsland"
QuestLvBoss=3
RewardBoss="Reward:\n$40,000\n67,000,000 Exp."
CFrameQBoss=CFrame.new(-13232.682617188, 332.40396118164,-7626.01171875)
CFrameBoss=CFrame.new(-13376.7578125, 433.28689575195,-8071.392578125)
elseif SelectBoss=="Beautiful Pirate" then
BossMon="Beautiful Pirate"
NameBoss='Beautiful Pirate'
NameQuestBoss="DeepForestIsland2"
QuestLvBoss=3
RewardBoss="Reward:\n$50,000\n70,000,000 Exp."
CFrameQBoss=CFrame.new(-12682.096679688, 390.88653564453,-9902.1240234375)
CFrameBoss=CFrame.new(5283.609375, 22.56223487854,-110.78285217285)
elseif SelectBoss=="Cake Queen" then
BossMon="Cake Queen"
NameBoss='Cake Queen'
NameQuestBoss="IceCreamIslandQuest"
QuestLvBoss=3
RewardBoss="Reward:\n$30,000\n112,500,000 Exp."
CFrameQBoss=CFrame.new(-819.376709, 64.9259796,-10967.2832,-0.766061664, 0, 0.642767608, 0, 1, 0,-0.642767608, 0,-0.766061664)
CFrameBoss=CFrame.new(-678.648804, 381.353943,-11114.2012,-0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929,-0.417492568, 0.0167988986,-0.90852499)
elseif SelectBoss=="Longma" then
BossMon="Longma"
NameBoss='Longma'
CFrameBoss=CFrame.new(-10238.875976563, 389.7912902832,-9549.7939453125)
elseif SelectBoss=="Soul Reaper" then
BossMon="Soul Reaper"
NameBoss='Soul Reaper'
CFrameBoss=CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
elseif SelectBoss=="rip_indra True Form" then
BossMon="rip_indra True Form"
NameBoss='rip_indra True Form'
CFrameBoss=CFrame.new(-5415.3920898438, 505.74133300781,-2814.0166015625)
end
end
end
function MaterialMon()
if SelectMaterial=="Radioactive Material" then
MMon="Factory Staff"
MPos=CFrame.new(295,73,-56)
SP="Default"
elseif SelectMaterial=="Mystic Droplet" then
MMon="Water Fighter"
MPos=CFrame.new(-3385,239,-10542)
SP="Default"
elseif SelectMaterial=="Magma Ore" then
if Sea1 then
MMon="Military Spy"
MPos=CFrame.new(-5815,84,8820)
SP="Default"
elseif Sea2 then
MMon="Magma Ninja"
MPos=CFrame.new(-5428,78,-5959)
SP="Default"
end
elseif SelectMaterial=="Angel Wings" then
MMon="God's Guard"
MPos=CFrame.new(-4698,845,-1912)
SP="Default"
if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-7859.09814, 5544.19043,-381.476196)).Magnitude>=5000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7859.09814, 5544.19043,-381.476196))
end
elseif SelectMaterial=="Leather" then
if Sea1 then
MMon="Brute"
MPos=CFrame.new(-1145,15,4350)
SP="Default"
elseif Sea2 then
MMon="Marine Captain"
MPos=CFrame.new(-2010.5059814453125, 73.00115966796875,-3326.620849609375)
SP="Default"
elseif Sea3 then
MMon="Jungle Pirate"
MPos=CFrame.new(-11975.78515625, 331.7734069824219,-10620.0302734375)
SP="Default"
end
elseif SelectMaterial=="Scrap Metal" then
if Sea1 then
MMon="Brute"
MPos=CFrame.new(-1145,15,4350)
SP="Default"
elseif Sea2 then
MMon="Swan Pirate"
MPos=CFrame.new(878,122,1235)
SP="Default"
elseif Sea3 then
MMon="Jungle Pirate"
MPos=CFrame.new(-12107,332,-10549)
SP="Default"
end
elseif SelectMaterial=="Fish Tail" then
if Sea3 then
MMon="Fishman Raider"
MPos=CFrame.new(-10993,332,-8940)
SP="Default"
elseif Sea1 then
MMon="Fishman Warrior"
MPos=CFrame.new(61123,19,1569)
SP="Default"
if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875)).Magnitude>=17000 then
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875))
end
end
elseif SelectMaterial=="Demonic Wisp" then
MMon="Demonic Soul"
MPos=CFrame.new(-9507,172,6158)
SP="Default"
elseif SelectMaterial=="Vampire Fang" then
MMon="Vampire"
MPos=CFrame.new(-6033,7,-1317)
SP="Default"
elseif SelectMaterial=="Conjured Cocoa" then
MMon="Chocolate Bar Battler"
MPos=CFrame.new(620.6344604492188,78.93644714355469,-12581.369140625)
SP="Default"
elseif SelectMaterial=="Dragon Scale" then
MMon="Dragon Crew Archer"
MPos=CFrame.new(6827.91455078125, 609.4127197265625, 252.3538055419922)
SP="Default"
elseif SelectMaterial=="Gunpowder" then
MMon="Pistol Billionaire"
MPos=CFrame.new(-469,74,5904)
SP="Default"
elseif SelectMaterial=="Mini Tusk" then
MMon="Mythological Pirate"
MPos=CFrame.new()
SP="Default"
end
end
function UpdateIslandESP() 
    for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if IslandESP then 
                if v.Name ~="Sea" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name='NameEsp'
                        bill.ExtentsOffset=Vector3.new(0, 1, 0)
                        bill.Size=UDim2.new(1,200,1,30)
                        bill.Adornee=v
                        bill.AlwaysOnTop=true
                        local name = Instance.new('TextLabel',bill)
                        name.Font="GothamBold"
                        name.FontSize="Size14"
                        name.TextWrapped=true
                        name.Size=UDim2.new(1,0,1,0)
                        name.TextYAlignment='Top'
                        name.BackgroundTransparency=1
                        name.TextStrokeTransparency=0.5
                        name.TextColor3=Color3.fromRGB(8, 0, 0)
                    else
                        v['NameEsp'].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function isnil(thing)
return (thing==nil)
end
local function round(n)
return math.floor(tonumber(n)+0.5)
end
Number=math.random(1, 1000000)
function UpdatePlayerChams()
for i,v in pairs(game:GetService'Players':GetChildren()) do
    pcall(function()
        if not isnil(v.Character) then
            if ESPPlayer then
                if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Character.Head)
                    bill.Name='NameEsp'..Number
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v.Character.Head
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font=Enum.Font.GothamSemibold
                    name.FontSize="Size10"
                    name.TextWrapped=true
                    name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Character.Head.Position).Magnitude/3) ..' Distance')
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    if v.Team==game.Players.LocalPlayer.Team then
                        name.TextColor3=Color3.new(0,0,254)
                    else
                        name.TextColor3=Color3.new(255,0,0)
                    end
                else
                    v.Character.Head['NameEsp'..Number].TextLabel.Text=(v.Name ..' | '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Character.Head.Position).Magnitude/3) ..' Distance\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
                end
            else
                if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                    v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end
    end)
end
end
function UpdateChestChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if string.find(v.Name,"Chest") then
            if ChestESP then
                if string.find(v.Name,"Chest") then
                    if not v:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name='NameEsp'..Number
                        bill.ExtentsOffset=Vector3.new(0, 1, 0)
                        bill.Size=UDim2.new(1,200,1,30)
                        bill.Adornee=v
                        bill.AlwaysOnTop=true
                        local name = Instance.new('TextLabel',bill)
                        name.Font=Enum.Font.GothamSemibold
                        name.FontSize="Size14"
                        name.TextWrapped=true
                        name.Size=UDim2.new(1,0,1,0)
                        name.TextYAlignment='Top'
                        name.BackgroundTransparency=1
                        name.TextStrokeTransparency=0.5
                        if v.Name=="Chest1" then
                            name.TextColor3=Color3.fromRGB(109, 109, 109)
                            name.Text=("Chest 1" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name=="Chest2" then
                            name.TextColor3=Color3.fromRGB(173, 158, 21)
                            name.Text=("Chest 2" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name=="Chest3" then
                            name.TextColor3=Color3.fromRGB(85, 255, 255)
                            name.Text=("Chest 3" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        end
                    else
                        v['NameEsp'..Number].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp'..Number) then
                    v:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end
    end)
end
end
function UpdateDevilChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if DevilFruitESP then
            if string.find(v.Name, "Fruit") then   
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Handle)
                    bill.Name='NameEsp'..Number
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v.Handle
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font=Enum.Font.GothamSemibold
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(255, 255, 255)
                    name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
                end
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end
    end)
end
end
function UpdateFlowerChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if v.Name=="Flower2" or v.Name=="Flower1" then
            if FlowerESP then 
                if not v:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name='NameEsp'..Number
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font=Enum.Font.GothamSemibold
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(255, 0, 0)
                    if v.Name=="Flower1" then 
                        name.Text=("Blue Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        name.TextColor3=Color3.fromRGB(0, 0, 255)
                    end
                    if v.Name=="Flower2" then
                        name.Text=("Red Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        name.TextColor3=Color3.fromRGB(255, 0, 0)
                    end
                else
                    v['NameEsp'..Number].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                end
            else
                if v:FindFirstChild('NameEsp'..Number) then
                v:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end   
    end)
end
end
function UpdateRealFruitChams() 
for i,v in pairs(game.Workspace.AppleSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name='NameEsp'..Number
                bill.ExtentsOffset=Vector3.new(0, 1, 0)
                bill.Size=UDim2.new(1,200,1,30)
                bill.Adornee=v.Handle
                bill.AlwaysOnTop=true
                local name = Instance.new('TextLabel',bill)
                name.Font=Enum.Font.GothamSemibold
                name.FontSize="Size14"
                name.TextWrapped=true
                name.Size=UDim2.new(1,0,1,0)
                name.TextYAlignment='Top'
                name.BackgroundTransparency=1
                name.TextStrokeTransparency=0.5
                name.TextColor3=Color3.fromRGB(255, 0, 0)
                name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
for i,v in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name='NameEsp'..Number
                bill.ExtentsOffset=Vector3.new(0, 1, 0)
                bill.Size=UDim2.new(1,200,1,30)
                bill.Adornee=v.Handle
                bill.AlwaysOnTop=true
                local name = Instance.new('TextLabel',bill)
                name.Font=Enum.Font.GothamSemibold
                name.FontSize="Size14"
                name.TextWrapped=true
                name.Size=UDim2.new(1,0,1,0)
                name.TextYAlignment='Top'
                name.BackgroundTransparency=1
                name.TextStrokeTransparency=0.5
                name.TextColor3=Color3.fromRGB(255, 174, 0)
                name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
for i,v in pairs(game.Workspace.BananaSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name='NameEsp'..Number
                bill.ExtentsOffset=Vector3.new(0, 1, 0)
                bill.Size=UDim2.new(1,200,1,30)
                bill.Adornee=v.Handle
                bill.AlwaysOnTop=true
                local name = Instance.new('TextLabel',bill)
                name.Font=Enum.Font.GothamSemibold
                name.FontSize="Size14"
                name.TextWrapped=true
                name.Size=UDim2.new(1,0,1,0)
                name.TextYAlignment='Top'
                name.BackgroundTransparency=1
                name.TextStrokeTransparency=0.5
                name.TextColor3=Color3.fromRGB(251, 255, 0)
                name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
end
function UpdateIslandESP() 
    for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if IslandESP then 
                if v.Name ~="Sea" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name='NameEsp'
                        bill.ExtentsOffset=Vector3.new(0, 1, 0)
                        bill.Size=UDim2.new(1,200,1,30)
                        bill.Adornee=v
                        bill.AlwaysOnTop=true
                        local name = Instance.new('TextLabel',bill)
                        name.Font="GothamBold"
                        name.FontSize="Size14"
                        name.TextWrapped=true
                        name.Size=UDim2.new(1,0,1,0)
                        name.TextYAlignment='Top'
                        name.BackgroundTransparency=1
                        name.TextStrokeTransparency=0.5
                        name.TextColor3=Color3.fromRGB(7, 236, 240)
                    else
                        v['NameEsp'].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function isnil(thing)
return (thing==nil)
end
local function round(n)
return math.floor(tonumber(n)+0.5)
end
Number=math.random(1, 1000000)
function UpdatePlayerChams()
for i,v in pairs(game:GetService'Players':GetChildren()) do
    pcall(function()
        if not isnil(v.Character) then
            if ESPPlayer then
                if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Character.Head)
                    bill.Name='NameEsp'..Number
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v.Character.Head
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font=Enum.Font.GothamSemibold
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Character.Head.Position).Magnitude/3) ..' Distance')
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    if v.Team==game.Players.LocalPlayer.Team then
                        name.TextColor3=Color3.new(0,255,0)
                    else
                        name.TextColor3=Color3.new(255,0,0)
                    end
                else
                    v.Character.Head['NameEsp'..Number].TextLabel.Text=(v.Name ..' | '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Character.Head.Position).Magnitude/3) ..' Distance\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
                end
            else
                if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                    v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end
    end)
end
end
function UpdateChestChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if string.find(v.Name,"Chest") then
            if ChestESP then
                if string.find(v.Name,"Chest") then
                    if not v:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name='NameEsp'..Number
                        bill.ExtentsOffset=Vector3.new(0, 1, 0)
                        bill.Size=UDim2.new(1,200,1,30)
                        bill.Adornee=v
                        bill.AlwaysOnTop=true
                        local name = Instance.new('TextLabel',bill)
                        name.Font=Enum.Font.GothamSemibold
                        name.FontSize="Size14"
                        name.TextWrapped=true
                        name.Size=UDim2.new(1,0,1,0)
                        name.TextYAlignment='Top'
                        name.BackgroundTransparency=1
                        name.TextStrokeTransparency=0.5
                        if v.Name=="Chest1" then
                            name.TextColor3=Color3.fromRGB(109, 109, 109)
                            name.Text=("Chest 1" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name=="Chest2" then
                            name.TextColor3=Color3.fromRGB(173, 158, 21)
                            name.Text=("Chest 2" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name=="Chest3" then
                            name.TextColor3=Color3.fromRGB(85, 255, 255)
                            name.Text=("Chest 3" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        end
                    else
                        v['NameEsp'..Number].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp'..Number) then
                    v:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end
    end)
end
end
function UpdateDevilChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if DevilFruitESP then
            if string.find(v.Name, "Fruit") then   
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Handle)
                    bill.Name='NameEsp'..Number
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v.Handle
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font=Enum.Font.GothamSemibold
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(255, 255, 255)
                    name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
                end
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end
    end)
end
end
function UpdateFlowerChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if v.Name=="Flower2" or v.Name=="Flower1" then
            if FlowerESP then 
                if not v:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name='NameEsp'..Number
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font=Enum.Font.GothamSemibold
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(255, 0, 0)
                    if v.Name=="Flower1" then 
                        name.Text=("Blue Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        name.TextColor3=Color3.fromRGB(0, 0, 255)
                    end
                    if v.Name=="Flower2" then
                        name.Text=("Red Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                        name.TextColor3=Color3.fromRGB(255, 0, 0)
                    end
                else
                    v['NameEsp'..Number].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' Distance')
                end
            else
                if v:FindFirstChild('NameEsp'..Number) then
                v:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end   
    end)
end
end
function UpdateRealFruitChams() 
for i,v in pairs(game.Workspace.AppleSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name='NameEsp'..Number
                bill.ExtentsOffset=Vector3.new(0, 1, 0)
                bill.Size=UDim2.new(1,200,1,30)
                bill.Adornee=v.Handle
                bill.AlwaysOnTop=true
                local name = Instance.new('TextLabel',bill)
                name.Font=Enum.Font.GothamSemibold
                name.FontSize="Size14"
                name.TextWrapped=true
                name.Size=UDim2.new(1,0,1,0)
                name.TextYAlignment='Top'
                name.BackgroundTransparency=1
                name.TextStrokeTransparency=0.5
                name.TextColor3=Color3.fromRGB(255, 0, 0)
                name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
for i,v in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name='NameEsp'..Number
                bill.ExtentsOffset=Vector3.new(0, 1, 0)
                bill.Size=UDim2.new(1,200,1,30)
                bill.Adornee=v.Handle
                bill.AlwaysOnTop=true
                local name = Instance.new('TextLabel',bill)
                name.Font=Enum.Font.GothamSemibold
                name.FontSize="Size14"
                name.TextWrapped=true
                name.Size=UDim2.new(1,0,1,0)
                name.TextYAlignment='Top'
                name.BackgroundTransparency=1
                name.TextStrokeTransparency=0.5
                name.TextColor3=Color3.fromRGB(255, 174, 0)
                name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
for i,v in pairs(game.Workspace.BananaSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name='NameEsp'..Number
                bill.ExtentsOffset=Vector3.new(0, 1, 0)
                bill.Size=UDim2.new(1,200,1,30)
                bill.Adornee=v.Handle
                bill.AlwaysOnTop=true
                local name = Instance.new('TextLabel',bill)
                name.Font=Enum.Font.GothamSemibold
                name.FontSize="Size14"
                name.TextWrapped=true
                name.Size=UDim2.new(1,0,1,0)
                name.TextYAlignment='Top'
                name.BackgroundTransparency=1
                name.TextStrokeTransparency=0.5
                name.TextColor3=Color3.fromRGB(251, 255, 0)
                name.Text=(v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
end
spawn(function()
while wait() do
    pcall(function()
        if MobESP then
            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if v:FindFirstChild('HumanoidRootPart') then
                    if not v:FindFirstChild("MobEap") then
                        local BillboardGui = Instance.new("BillboardGui")
                        local TextLabel = Instance.new("TextLabel")
                        BillboardGui.Parent=v
                        BillboardGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
                        BillboardGui.Active=true
                        BillboardGui.Name="MobEap"
                        BillboardGui.AlwaysOnTop=true
                        BillboardGui.LightInfluence=1.000
                        BillboardGui.Size=UDim2.new(0, 200, 0, 50)
                        BillboardGui.StudsOffset=Vector3.new(0, 2.5, 0)
                        TextLabel.Parent=BillboardGui
                        TextLabel.BackgroundColor3=Color3.fromRGB(255, 255, 255)
                        TextLabel.BackgroundTransparency=1.000
                        TextLabel.Size=UDim2.new(0, 200, 0, 50)
                        TextLabel.Font=Enum.Font.GothamBold
                        TextLabel.TextColor3=Color3.fromRGB(7, 236, 240)
                        TextLabel.Text.Size=35
                    end
                    local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.HumanoidRootPart.Position).Magnitude)
                    v.MobEap.TextLabel.Text=v.Name.."-"..Dis.." Distance"
                end
            end
        else
            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if v:FindFirstChild("MobEap") then
                    v.MobEap:Destroy()
                end
            end
        end
    end)
end
end)
spawn(function()
while wait() do
    pcall(function()
        if SeaESP then
            for i,v in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
                if v:FindFirstChild('HumanoidRootPart') then
                    if not v:FindFirstChild("Seaesps") then
                        local BillboardGui = Instance.new("BillboardGui")
                        local TextLabel = Instance.new("TextLabel")
                        BillboardGui.Parent=v
                        BillboardGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
                        BillboardGui.Active=true
                        BillboardGui.Name="Seaesps"
                        BillboardGui.AlwaysOnTop=true
                        BillboardGui.LightInfluence=1.000
                        BillboardGui.Size=UDim2.new(0, 200, 0, 50)
                        BillboardGui.StudsOffset=Vector3.new(0, 2.5, 0)
                        TextLabel.Parent=BillboardGui
                        TextLabel.BackgroundColor3=Color3.fromRGB(255, 255, 255)
                        TextLabel.BackgroundTransparency=1.000
                        TextLabel.Size=UDim2.new(0, 200, 0, 50)
                        TextLabel.Font=Enum.Font.GothamBold
                        TextLabel.TextColor3=Color3.fromRGB(7, 236, 240)
                        TextLabel.Text.Size=35
                    end
                    local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.HumanoidRootPart.Position).Magnitude)
                    v.Seaesps.TextLabel.Text=v.Name.."-"..Dis.." Distance"
                end
            end
        else
            for i,v in pairs (game:GetService("Workspace").SeaBeasts:GetChildren()) do
                if v:FindFirstChild("Seaesps") then
                    v.Seaesps:Destroy()
                end
            end
        end
    end)
end
end)
spawn(function()
while wait() do
    pcall(function()
        if NpcESP then
            for i,v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                if v:FindFirstChild('HumanoidRootPart') then
                    if not v:FindFirstChild("NpcEspes") then
                        local BillboardGui = Instance.new("BillboardGui")
                        local TextLabel = Instance.new("TextLabel")
                        BillboardGui.Parent=v
                        BillboardGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
                        BillboardGui.Active=true
                        BillboardGui.Name="NpcEspes"
                        BillboardGui.AlwaysOnTop=true
                        BillboardGui.LightInfluence=1.000
                        BillboardGui.Size=UDim2.new(0, 200, 0, 50)
                        BillboardGui.StudsOffset=Vector3.new(0, 2.5, 0)
                        TextLabel.Parent=BillboardGui
                        TextLabel.BackgroundColor3=Color3.fromRGB(255, 255, 255)
                        TextLabel.BackgroundTransparency=1.000
                        TextLabel.Size=UDim2.new(0, 200, 0, 50)
                        TextLabel.Font=Enum.Font.GothamBold
                        TextLabel.TextColor3=Color3.fromRGB(7, 236, 240)
                        TextLabel.Text.Size=35
                    end
                    local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.HumanoidRootPart.Position).Magnitude)
                    v.NpcEspes.TextLabel.Text=v.Name.."-"..Dis.." Distance"
                end
            end
        else
            for i,v in pairs (game:GetService("Workspace").NPCs:GetChildren()) do
                if v:FindFirstChild("NpcEspes") then
                    v.NpcEspes:Destroy()
                end
            end
        end
    end)
end
end)
function isnil(thing)
return (thing==nil)
end
local function round(n)
return math.floor(tonumber(n)+0.5)
end
Number=math.random(1, 1000000)
function UpdateIslandMirageESP() 
for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
    pcall(function()
        if MirageIslandESP then 
            if v.Name=="Mirage Island" then
                if not v:FindFirstChild('NameEsp') then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name='NameEsp'
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font="Code"
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(80, 245, 245)
                else
                    v['NameEsp'].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' M')
                end
            end
        else
            if v:FindFirstChild('NameEsp') then
                v:FindFirstChild('NameEsp'):Destroy()
            end
        end
    end)
end
end
function UpdateAuraESP() 
for i,v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
    pcall(function()
        if AuraESP then 
            if v.Name=="Master of Enhancement" then
                if not v:FindFirstChild('NameEsp') then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name='NameEsp'
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font="Code"
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(80, 245, 245)
                else
                    v['NameEsp'].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' M')
                end
            end
        else
            if v:FindFirstChild('NameEsp') then
                v:FindFirstChild('NameEsp'):Destroy()
            end
        end
    end)
end
end
function UpdateLSDESP() 
for i,v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
    pcall(function()
        if LADESP then 
            if v.Name=="Legendary Sword Dealer" then
                if not v:FindFirstChild('NameEsp') then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name='NameEsp'
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font="Code"
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(80, 245, 245)
                else
                    v['NameEsp'].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' M')
                end
            end
        else
            if v:FindFirstChild('NameEsp') then
                v:FindFirstChild('NameEsp'):Destroy()
            end
        end
    end)
end
end
function UpdateGeaESP() 
for i,v in pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren()) do 
    pcall(function()
        if GearESP then 
            if v.Name=="MeshPart" then
                if not v:FindFirstChild('NameEsp') then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name='NameEsp'
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1,200,1,30)
                    bill.Adornee=v
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel',bill)
                    name.Font="Code"
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1,0,1,0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(80, 245, 245)
                else
                    v['NameEsp'].TextLabel.Text=(v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) ..' M')
                end
            end
        else
            if v:FindFirstChild('NameEsp') then
                v:FindFirstChild('NameEsp'):Destroy()
            end
        end
    end)
end
end
function Tween2(KG)
    local Distance = (KG.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 350
    local tweenInfo = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, {
        CFrame = KG
    })
    tween:Play()
    if _G.StopTween2 then
        tween:Cancel()
    end
    _G.Clip2 = true
    wait(Distance / Speed)
    _G.Clip2 = false
end
function BKP(Point)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Point
    task.wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Point
end
TweenSpeed = 350
function Tween(KG)
    local Distance = (KG.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = TweenSpeed  
    local tweenInfo = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, {
        CFrame = KG
    })
    tween:Play()
    if _G.StopTween then
        tween:Cancel()
    end
end
function EquipTool(ToolSe)
        if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
            local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
            wait()
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
   spawn(function()
            while task.wait() do
                pcall(function()
                    if _G.AutoEvoRace or _G.CastleRaid or _G.CollectAzure or _G.TweenToKitsune or _G.GhostShip or _G.Ship or _G.Auto_Holy_Torch or _G.TeleportPly or _G.Auto_Sea3 or _G.Auto_Sea2 or _G.Tweenfruit or _G.AutoFishCrew or _G.Auto_Saber or _G.AutoShark or _G.Auto_Warden or _G.Auto_RainbowHaki or AutoFarmRace or _G.AutoQuestRace or Auto_Law or AutoTushita or _G.AutoHolyTorch or _G.AutoTerrorshark or _G.farmpiranya or _G.Auto_MusketeerHat or _G.Auto_ObservationV2 or _G.AutoNear or _G.Auto_PoleV1 or _G.Auto_Buddy or _G.Ectoplasm or AutoEvoRace or AutoBartilo or _G.Auto_Canvander or _G.AutoLevel or _G.Auto_DualKatana or Auto_Quest_Yama_3 or Auto_Quest_Yama_2 or Auto_Quest_Yama_1 or Auto_Quest_Tushita_1 or Auto_Quest_Tushita_2 or Auto_Quest_Tushita_3  or _G.Clip2 or _G.Auto_Regoku or _G.AutoBone or _G.AutoBoneNoQuest or _G.AutoBoss or AutoFarmMasDevilFruit or AutoFarmMasGun or AutoHallowSycthe or AutoTushita or _G.Cake or _G.Auto_SkullGuitar or _G.AutoFarmSwan or _G.AutoEliteor or AutoNextIsland or Musketeer or _G.AutoMaterial or AutoFarmRaceQuest or _G.Factory or _G.Auto_Saw or _G.AutoFrozenDimension or _G.AutoKillTrial or _G.AutoUpgrade or _G.TweenToFrozenDimension then
                        if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                            local Noclip = Instance.new("BodyVelocity")
                            Noclip.Name="BodyClip"
                            Noclip.Parent=game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                            Noclip.MaxForce=Vector3.new(100000,100000,100000)
                            Noclip.Velocity=Vector3.new(0,0,0)
                        end
                    else
                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
                    end
                end)
            end
        end)
spawn(function()
  pcall(function()
    game:GetService("RunService").Stepped:Connect(function()
      if _G.AutoEvoRace or _G.Auto_RainbowHaki or _G.Auto_SkullGuitar or _G.CastleRaid or _G.CollectAzure or _G.TweenToKitsune or _G.Auto_Sea3 or _G.Auto_Sea2 or _G.GhostShip or _G.Ship or _G.Auto_Holy_Torch or _G.TeleportPly or _G.Tweenfruit or _G.Auto_Saber or _G.Auto_PoleV1 or _G.Auto_MusketeerHat or _G.AutoFishCrew or _G.AutoShark or AutoFarmRace or _G.AutoQuestRace or _G.Auto_Warden or Auto_Law or _G.Auto_DualKatana or Auto_Quest_Tushita_1 or Auto_Quest_Tushita_2 or Auto_Quest_Tushita_3 or AutoTushita or _G.AutoHolyTorch or _G.Auto_Buddy or _G.AutoTerrorshark or _G.farmpiranya or Auto_Quest_Yama_3 or _G.Auto_ObservationV2 or Auto_Quest_Yama_2 or Auto_Quest_Yama_1 or _G.AutoNear or _G.Ectoplasm or AutoEvoRace or _G.AutoKillTrial or AutoBartilo or AutoFarmMasGun or _G.Auto_Regoku or _G.AutoLevel or _G.Clip2 or _G.AutoBone or _G.Auto_Canvander or _G.AutoBoneNoQuest or _G.AutoBoss or _G.Auto_Saw or AutoFarmMasDevilFruit or AutoHallowSycthe or AutoTushita or _G.Cake or _G.AutoFarmSwan or _G.AutoEliteor or AutoNextIsland or Musketeer or _G.AutoMaterial or _G.Factory or _G.AutoFrozenDimension or AutoFarmRaceQuest or _G.AutoUpgrade or _G.TweenToFrozenDimension then
      for i,v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
      if v:IsA("BasePart") then
      v.CanCollide=false
      end
      end
      end
      end)
    end)
  end)
  task.spawn(function()
    if game.Players.LocalPlayer.Character:FindFirstChild("Stun") then
    game.Players.LocalPlayer.Character.Stun.Changed:connect(function()
      pcall(function()
        if game.Players.LocalPlayer.Character:FindFirstChild("Stun") then
        game.Players.LocalPlayer.Character.Stun.Value=0
        end
        end)
      end)
    end
    end)
function CheckMaterial(matname)
for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
if type(v)=="table" then
if v.Type=="Material" then
if v.Name==matname then
return v.Count
end
end
end
end
return 0
end
function GetWeaponInventory(Weaponname)
for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
if type(v)=="table" then
if v.Type=="Sword" then
if v.Name==Weaponname then
return true
end
end
end
end
return false
end
local player = game.Players.LocalPlayer
function AttackNoCoolDown()
    local character = player.Character
    if not character then return end
    local equippedWeapon = nil
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            equippedWeapon = item
            break
        end
    end
    if not equippedWeapon then return end
    local function IsEntityAlive(entity)
        return entity and entity:FindFirstChild("Humanoid") and entity.Humanoid.Health > 0
    end
    local function GetEnemiesInRange(range)
        local enemies = game:GetService("Workspace").Enemies:GetChildren()
        local targets = {}
        local playerPos = character:GetPivot().Position
        for _, enemy in ipairs(enemies) do
            local primaryPart = enemy:FindFirstChild("HumanoidRootPart")
            if primaryPart and IsEntityAlive(enemy) and (primaryPart.Position - playerPos).Magnitude <= range then
                table.insert(targets, enemy)
            end
        end
        return targets
    end
    if equippedWeapon:FindFirstChild("LeftClickRemote") then
        local attackCount = 1  
        local enemiesInRange = GetEnemiesInRange(60)
        for _, enemy in ipairs(enemiesInRange) do
            local direction = (enemy.HumanoidRootPart.Position - character:GetPivot().Position).Unit
            pcall(function()
                equippedWeapon.LeftClickRemote:FireServer(direction, attackCount)
            end)
            attackCount = attackCount + 1
            if attackCount > 10000000000000 then attackCount = 1 end
        end
    else
        local targets = {}
        local enemies = game:GetService("Workspace").Enemies:GetChildren()
        local playerPos = character:GetPivot().Position
        local mainTarget = nil
        for _, enemy in ipairs(enemies) do
            if not enemy:GetAttribute("IsBoat") and IsEntityAlive(enemy) then
                local head = enemy:FindFirstChild("Head")
                if head and (playerPos - head.Position).Magnitude <= 60 then
                    table.insert(targets, { enemy, head })
                    mainTarget = head
                end
            end
        end
        if not mainTarget then return end
        pcall(function()
            local storage = game:GetService("ReplicatedStorage")
            local attackEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
            local hitEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")
            if #targets > 0 then
                attackEvent:FireServer(0.0000000000001)
                hitEvent:FireServer(mainTarget, targets)
            else
                task.wait(0.0000000000001)
            end
        end)
    end
end
Type=1
spawn(function()
    while wait() do
        if Type==1 then
            Pos=CFrame.new(0, 20, 0)
        end
    end
end)
spawn(function()
    while wait() do
        Type=1
    end
end)
  function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end
function to(P)
    repeat wait(_G.Fast_Delay)
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=P
        task.wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=P
    until (P.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=2000
end
function to(p)
        pcall(function()
            if (p.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>=2000 and not Auto_Raid and game.Players.LocalPlayer.Character.Humanoid.Health>0 then
                if NameMon=="FishmanQuest" then
                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
                elseif Mon=="God's Guard"  then
                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248,-1667.55688))
                elseif NameMon=="SkyExp1Quest" then
                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625,-380.29119873047))
                elseif NameMon=="ShipQuest1" then
                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                elseif NameMon=="ShipQuest2" then
                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                elseif NameMon=="FrostQuest" then
                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-6508.5581054688, 89.034996032715,-132.83953857422))
                else
                        repeat wait(_G.Fast_Delay)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=p
                        wait(.05)
                        game.Players.LocalPlayer.Character.Head:Destroy()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=p
                    until (p.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<2500 and game.Players.LocalPlayer.Character.Humanoid.Health>0
                    wait()
                end
            end
        end)
    end
wait(2.0)
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local existingGui = playerGui:FindFirstChild("CustomScreenGui")
if existingGui then
    existingGui:Destroy()
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomScreenGui"
ScreenGui.Parent = playerGui
local Button = Instance.new("ImageButton")
Button.Name = "CustomButton"
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 50, 0, 50)
Button.Position = UDim2.new(0.015, 0, 0.02, 20)
Button.BackgroundTransparency = 1
Button.Image = "rbxassetid://112497595160752"
local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Button
local imageLoaded = false
ContentProvider:PreloadAsync({Button.Image}, function()
    imageLoaded = true
end)
Button.MouseButton1Click:Connect(function()
    if not imageLoaded then
        return
    end
    local VirtualInputManager = game:GetService("VirtualInputManager")
    if VirtualInputManager then
        task.defer(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
        end)
    end
end)
task.defer(function()
    if game:GetService("ReplicatedStorage"):FindFirstChild("Effect") 
        and game:GetService("ReplicatedStorage").Effect:FindFirstChild("Container") 
        and game:GetService("ReplicatedStorage").Effect.Container:FindFirstChild("Death") then
        local DeathEffect = require(game:GetService("ReplicatedStorage").Effect.Container.Death)
        local CameraShaker = require(game:GetService("ReplicatedStorage").Util.CameraShaker)
        if CameraShaker then
            CameraShaker:Stop()
        end
        if hookfunction then
            hookfunction(DeathEffect, function(...) return ... end)
        end
    end
end)
wait(1.0)
Tabs.Info:AddButton({
        Title="Lunar",
        Description="Discord",
        Callback=function()
            setclipboard(tostring("https://discord.gg/tenhub")) 
        end
})
Tabs.Info:AddButton({
    Title="BlasrHuynz",
    Description="Youtube",
    Callback=function()
        setclipboard(tostring("https://www.youtube.com/"))
    end
})
Tabs.Info:AddParagraph({
    Title="BlastHuynz",
    Content="Credits"
})
local executorName
if identifyexecutor then
    executorName=identifyexecutor()
elseif getexecutorname then
    executorName=getexecutorname()
end
if executorName then
    Tabs.Info:AddParagraph({
        Title="Executor in use",
        Content=executorName
    })
end
Tabs.Info:AddParagraph({
    Title="Update",
    Content="Script supports pc and pe"
})
Tabs.Info:AddParagraph({
    Title="All Clients Android Supported",
    Content=""
})
Tabs.Info:AddParagraph({
    Title="All Clients PC Supported",
    Content=""
})
_G.FastAttackVxeze_Mode="Super Fast Attack"
spawn(function()
    while wait() do
        if _G.FastAttackVxeze_Mode then
            pcall(function()
                if _G.FastAttackVxeze_Mode=="Super Fast Attack" then
                    _G.Fast_Delay=0.0000000000001 
                end
            end)
        end
    end
end)
local AutoFram = Tabs.Main:AddSection("Auto Fram")
local DropdownSelectWeapon = Tabs.Main:AddDropdown("DropdownSelectWeapon", {
    Title = "Select Weapon",
    Description = "",
    Values = {'Melee', 'Sword', 'Blox Fruit'},
    Multi = false,
    Default = 1,
})
DropdownSelectWeapon:SetValue('Melee')
DropdownSelectWeapon:OnChanged(function(Value)
    ChooseWeapon = Value
end)
task.spawn(function()
    while wait() do
        pcall(function()
            if ChooseWeapon == "Melee" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            SelectWeapon = v.Name
                        end
                    end
                end
            elseif ChooseWeapon == "Sword" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            SelectWeapon = v.Name
                        end
                    end
                end
            elseif ChooseWeapon == "Blox Fruit" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            SelectWeapon = v.Name
                        end
                    end
                end
            end
        end)
    end
end)
    local ToggleLevel = Tabs.Main:AddToggle("ToggleLevel", {
        Title="Auto Fram Level",
        Description="",
        Default=false })
    ToggleLevel:OnChanged(function(Value)
        _G.AutoLevel=Value
        if Value==false then
            wait()
            Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
            wait()
        end
    end)
    Options.ToggleLevel:SetValue(false)
    spawn(function()
        while task.wait() do
        if _G.AutoLevel then
        pcall(function()
          CheckLevel()
          if not string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==false then
          game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
          Tween(CFrameQ)
          if (CFrameQ.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=5 then
          game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,QuestLv)
          end
          elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==true then
          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
          if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
          if v.Name==Ms then
          repeat wait(_G.Fast_Delay)
          AttackNoCoolDown()
          bringmob=true
          AutoHaki()
          EquipTool(SelectWeapon)
          Tween(v.HumanoidRootPart.CFrame*Pos)
          v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
          v.HumanoidRootPart.Transparency=1
          v.Humanoid.JumpPower=0
          v.Humanoid.WalkSpeed=0
          v.HumanoidRootPart.CanCollide=false
          FarmPos=v.HumanoidRootPart.CFrame
          MonFarm=v.Name
          until not _G.AutoLevel or not v.Parent or v.Humanoid.Health<=0 or not game:GetService("Workspace").Enemies:FindFirstChild(v.Name) or game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible==false
          bringmob=false
        end   
          end
          end
          for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do
          if string.find(v.Name,NameMon) then
          if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude>=10 then
            Tween(v.HumanoidRootPart.CFrame*Pos)
          end
          end
          end
          end
          end)
        end
        end
        end)        
    local ToggleMobAura = Tabs.Main:AddToggle("ToggleMobAura", {
        Title="Auto Mob Aura",
        Description="",
        Default=false })
    ToggleMobAura:OnChanged(function(Value)
        _G.AutoNear=Value
        if Value==false then
            wait()
            Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
            wait()
        end
    end)
    Options.ToggleMobAura:SetValue(false)
    spawn(function()
        while wait() do
        if _G.AutoNear then
        pcall(function()
          for i,v in pairs (game.Workspace.Enemies:GetChildren()) do
          if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
          if v.Name then
          if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v:FindFirstChild("HumanoidRootPart").Position).Magnitude<=5000 then
            repeat wait(_G.Fast_Delay)
                AttackNoCoolDown()
                bringmob=true
          AutoHaki()
          EquipTool(SelectWeapon)
          Tween(v.HumanoidRootPart.CFrame*Pos)
          v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
          v.HumanoidRootPart.Transparency=1
          v.Humanoid.JumpPower=0
          v.Humanoid.WalkSpeed=0
          v.HumanoidRootPart.CanCollide=false
          FarmPos=v.HumanoidRootPart.CFrame
          MonFarm=v.Name
          until not _G.AutoNear or not v.Parent or v.Humanoid.Health<=0 or not game.Workspace.Enemies:FindFirstChild(v.Name)
          bringmob=false
        end
          end
          end
          end
          end)
        end
        end
      end)
local AutoFram = Tabs.Main1:AddSection("CastleRaid")
    local ToggleCastleRaid = Tabs.Main1:AddToggle("ToggleCastleRaid", {
        Title="Auto Castle Raid",
        Description="", 
        Default=false })
    ToggleCastleRaid:OnChanged(function(Value)
        _G.CastleRaid=Value
    end)
    Options.ToggleCastleRaid:SetValue(false)
    spawn(function()
        while wait() do
            if _G.CastleRaid then
                pcall(function()
                    local CFrameCastleRaid = CFrame.new(-5496.17432, 313.768921,-2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1,-1.06665446e-07,-0.380223751, 1.12297109e-07, 0.924894512)
                    if (CFrame.new(-5539.3115234375, 313.800537109375,-2972.372314453125).Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=500 then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if _G.CastleRaid and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0 then
                                if (v.HumanoidRootPart.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<2000 then
                                    repeat wait(_G.Fast_Delay)
                                        AttackNoCoolDown()
                                        AutoHaki()
                                        EquipTool(SelectWeapon)
                                        v.HumanoidRootPart.CanCollide=false
                                        v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                        Tween(v.HumanoidRootPart.CFrame*Pos)
                                    until v.Humanoid.Health<=0 or not v.Parent or not _G.CastleRaid
                                end
                            end
                        end
                    else
                        Tween(CFrameCastleRaid)
                    end
                end)
            end
        end
        end)
local ToggleHakiFortress = Tabs.Main1:AddToggle("ToggleHakiFortress", { 
    Title="Auto On Haki", 
    Description="", 
    Default=false 
})
ToggleHakiFortress:OnChanged(function(Value)
    _G.EnableHakiFortress=Value
end)
Options.ToggleHakiFortress:SetValue(false)
local function EquipAuraAndTeleport(storageName, targetPosition)
    local args = {
        [1]={
            ["StorageName"]=storageName,
            ["Type"]="AuraSkin",
            ["Context"]="Equip"
        }
    }
    game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/FruitCustomizerRF"):InvokeServer(unpack(args))
    Tween2(targetPosition)
end
local function IsAtPosition(targetPosition, tolerance)
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    local characterPosition = character.HumanoidRootPart.Position
    return (characterPosition-targetPosition).Magnitude<tolerance
end
spawn(function()
    while true do
        if _G.EnableHakiFortress then
            EquipAuraAndTeleport("Snow White", Vector3.new(-4971.71826171875, 335.9582214355469,-3720.0595703125))
            while not IsAtPosition(Vector3.new(-4971.71826171875, 335.9582214355469,-3720.0595703125), 1) do
                wait(0.1)
            end
            wait(0.5) 
            EquipAuraAndTeleport("Pure Red", Vector3.new(-5414.92041015625, 314.2582092285156,-2212.20166015625))
            while not IsAtPosition(Vector3.new(-5414.92041015625, 314.2582092285156,-2212.20166015625), 1) do
                wait(0.1)
            end
            wait(0.5) 
            EquipAuraAndTeleport("Winter Sky", Vector3.new(-5420.26318359375, 1089.3582763671875,-2666.8193359375))
            while not IsAtPosition(Vector3.new(-5420.26318359375, 1089.3582763671875,-2666.8193359375), 1) do
                wait(0.1)
            end
            wait(0.5) 
            _G.EnableHakiFortress=false
        end
        wait(0.5)
    end
end)
local ToggleCollectChest = Tabs.Main1:AddToggle("ToggleCollectChest", {
    Title = "Auto Chest",
    Description = "",
    Default = false
})
ToggleCollectChest:OnChanged(function(Value)
    _G.AutoCollectChest = Value
end)
spawn(function()
    while wait() do
        if _G.AutoCollectChest then
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer 
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local Position = Character:GetPivot().Position
            local CollectionService = game:GetService("CollectionService")
            local Chests = CollectionService:GetTagged("_ChestTagged") 
            local Distance, Nearest = math.huge
            for i = 1, #Chests do
                local Chest = Chests[i]
                local Magnitude = (Chest:GetPivot().Position - Position).Magnitude
                if not Chest:GetAttribute("IsDisabled") and Magnitude < Distance then
                    Distance, Nearest = Magnitude, Chest
                end
            end
            if Nearest then
                local ChestPosition = Nearest:GetPivot().Position
                local CFrameTarget = CFrame.new(ChestPosition)
                Tween2(CFrameTarget) 
            end
        end
    end
end)
local ToggleCollectBerry = Tabs.Main1:AddToggle("ToggleCollectBerry", {
    Title = "Auto Berry and Hop",
    Description = "",
    Default = false
})
ToggleCollectBerry:OnChanged(function(Value)
    _G.AutoCollectBerry = Value
end)
spawn(function()
    while wait() do
        if _G.AutoCollectBerry then
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local Position = Character:GetPivot().Position
            local CollectionService = game:GetService("CollectionService")
            local BerryBushes = CollectionService:GetTagged("BerryBush")
            local Distance, Nearest, BerryName = math.huge, nil, nil
            for i = 1, #BerryBushes do
                local Bush = BerryBushes[i]
                for AttributeName, Berry in pairs(Bush:GetAttributes()) do
                    local Magnitude = (Bush.Parent:GetPivot().Position - Position).Magnitude
                    if Magnitude < Distance then
                        Distance, Nearest, BerryName = Magnitude, Bush, Berry
                    end
                end
            end
            if Nearest then
                local BushPosition = Nearest.Parent:GetPivot().Position
                local CFrameTarget = CFrame.new(BushPosition)
                Tween2(CFrameTarget)
                Fluent:Notify({
                    Title = "Lunar Community",
                    Content = "Find Berry: " .. tostring(BerryName),
                    Duration = 10
                })
            else
                Hop()
            end
        end
    end
end)
local Mastery = Tabs.Main:AddSection("Auto Fram Mastery")
local DropdownMastery = Tabs.Main:AddDropdown("DropdownMastery", {
    Title = "Select Fram",
    Description = "",
    Values = {"Level", "Level No Quest", "Near Mob", "Bone", "Cake", "Ecto"},
    Multi = false,
    Default = 1,
})
DropdownMastery:SetValue(TypeMastery)
DropdownMastery:OnChanged(function(Value)
    TypeMastery = Value
end)
local ToggleMasteryFruit = Tabs.Main:AddToggle("ToggleMasteryFruit", {
    Title = "Auto Fram Fruit",
    Description = "",
    Default = false
})
ToggleMasteryFruit:OnChanged(function(Value)
    AutoFarmMasDevilFruit = Value
end)
Options.ToggleMasteryFruit:SetValue(false)
local ToggleMasteryGun = Tabs.Main:AddToggle("ToggleMasteryGun", {
    Title = "Auto Fram Gun",
    Description = "",
    Default = false
})
ToggleMasteryGun:OnChanged(function(Value)
    AutoFarmMasGun = Value
end)
local SliderHealt = Tabs.Main:AddSlider("SliderHealt", {
    Title = "Healt Mob",
    Description = "",
    Default = 25,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        KillPercent = Value
    end
})
SliderHealt:OnChanged(function(Value)
    KillPercent = Value
end)
SliderHealt:SetValue(20)
spawn(function()
    while task.wait() do
        if _G.UseSkill then
            pcall(function()
                if _G.UseSkill then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == MonFarm and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                            repeat 
                                game:GetService("RunService").Heartbeat:wait()
                                EquipTool(game.Players.LocalPlayer.Data.DevilFruit.Value)
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                PositionSkillMasteryDevilFruit = v.HumanoidRootPart.Position
                                if game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value) then
                                    game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).MousePos.Value = PositionSkillMasteryDevilFruit
                                    local DevilFruitMastery = game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).Level.Value
                                    if SkillZ and DevilFruitMastery >= 1 then
                                        game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
                                        wait()
                                        game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
                                    end
                                    if SkillX and DevilFruitMastery >= 1 then
                                        game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
                                        wait()
                                        game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
                                    end
                                    if SkillC and DevilFruitMastery >= 1 then
                                        game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
                                        wait()
                                        game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
                                    end
                                    if SkillV and DevilFruitMastery >= 1 then
                                        game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
                                        wait()
                                        game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
                                    end
                                    if SkillF and DevilFruitMastery >= 1 then
                                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                                        wait()
                                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                                    end
                                end
                            until not AutoFarmMasDevilFruit or not _G.UseSkill or v.Humanoid.Health == 0
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasDevilFruit and TypeMastery == 'Near Mob' then
            pcall(function()
                for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v.Name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChild("HumanoidRootPart").Position).Magnitude <= 5000 then
                            repeat wait(_G.Fast_Delay)
                                if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                    _G.UseSkill = true
                                else
                                    _G.UseSkill = false
                                    AutoHaki()
                                    bringmob = true
                                    EquipTool(SelectWeapon)
                                    Tween(v.HumanoidRootPart.CFrame * Pos)
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v.HumanoidRootPart.Transparency = 1
                                    v.Humanoid.JumpPower = 0
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.CanCollide = false
                                    FarmPos = v.HumanoidRootPart.CFrame
                                    MonFarm = v.Name
                                    AttackNoCoolDown()
                                end
                            until not AutoFarmMasDevilFruit or not MasteryType == 'Near Mob' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Near Mob'
                            bringmob = false
                            _G.UseSkill = false
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasDevilFruit and TypeMastery == 'Ecto' then
            pcall(function()
                local EctoMob = CFrame.new(904.4072265625, 181.05767822266, 33341.38671875)
                Tween(EctoMob)
            end)
            local Distance = (Vector3.new(904.4072265625, 181.05767822266, 33341.38671875) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Distance > 20000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == "Ship Steward" or v.Name == "Ship Engineer" or v.Name == "Ship Deckhand" or v.Name == "Ship Officer" then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkill = true
                            else
                                _G.UseSkill = false
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                                AttackNoCoolDown()
                            end
                        until not AutoFarmMasDevilFruit or not MasteryType == 'Ecto' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Ecto'
                        bringmob = false
                        _G.UseSkill = false
                    end
                end
            end
            for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if v.Name == "Ship Steward" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Ship Engineer" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Ship Deckhand" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Ship Officer" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasDevilFruit and TypeMastery == 'Cake' then
            pcall(function()
                local cakepos = CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625)
                Tween(cakepos)
            end)
            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == "Cookie Crafter" or v.Name == "Cake Guard" or v.Name == "Baking Staff" or v.Name == "Head Baker" then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkill = true
                            else
                                _G.UseSkill = false
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                                AttackNoCoolDown()
                            end
                        until not AutoFarmMasDevilFruit or not MasteryType == 'Cake' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Cake'
                        bringmob = false
                        _G.UseSkill = false
                    end
                end
            end
            for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if v.Name == "Cookie Crafter" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Cake Guard" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Baking Staff" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Head Baker" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasDevilFruit and TypeMastery == 'Level No Quest' then
            pcall(function()
                CheckLevel()
                Tween(CFrameQ)
            end)
            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == Ms then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkill = true
                            else
                                _G.UseSkill = false
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                                AttackNoCoolDown()
                            end
                        until not AutoFarmMasDevilFruit or not MasteryType == 'Level No Quest' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Level No Quest'
                        bringmob = false
                        _G.UseSkill = false
                    end
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasDevilFruit and TypeMastery == 'Level' then
            pcall(function()
                CheckLevel()
                if not string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    Tween(CFrameQ)
                end
                if (CFrameQ.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                end
            end)
            if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Name == Ms then
                                repeat wait(_G.Fast_Delay)
                                    if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                        _G.UseSkill = true
                                    else
                                        _G.UseSkill = false
                                        AutoHaki()
                                        bringmob = true
                                        EquipTool(SelectWeapon)
                                        Tween(v.HumanoidRootPart.CFrame * Pos)
                                        v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        v.HumanoidRootPart.Transparency = 1
                                        v.Humanoid.JumpPower = 0
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.CanCollide = false
                                        FarmPos = v.HumanoidRootPart.CFrame
                                        MonFarm = v.Name
                                        AttackNoCoolDown()
                                    end
                                until not AutoFarmMasDevilFruit or not MasteryType == 'Level' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Level'
                                bringmob = false
                                _G.UseSkill = false
                            end
                        end
                    end
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasDevilFruit and TypeMastery == 'Bone' then
            pcall(function()
                local boneframe = CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625)
                Tween(boneframe)
            end)
            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy" then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkill = true
                            else
                                _G.UseSkill = false
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                                AttackNoCoolDown()
                            end
                        until not AutoFarmMasDevilFruit or not MasteryType == 'Bone' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Bone'
                        bringmob = false
                        _G.UseSkill = false
                    end
                end
            end
            for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if v.Name == "Reborn Skeleton" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Living Zombie" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Demonic Soul" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Posessed Mummy" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                end
            end
        end
    end
end)
spawn(function()
    while task.wait() do
        if _G.UseSkillGun then
            pcall(function()
                if _G.UseSkillGun then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == MonFarm and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                            repeat game:GetService("RunService").Heartbeat:wait()
                                EquipToolGun()
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                PositionSkillMasteryGun = v.HumanoidRootPart.Position
                                if SkillZ then
                                    game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
                                    wait()
                                    game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
                                end
                                if SkillX then
                                    game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
                                    wait()
                                    game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
                                end
                                if SkillC then
                                    game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
                                    wait()
                                    game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
                                end
                                if SkillV then
                                    game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
                                    wait()
                                    game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
                                end
                                if SkillF then
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                                    wait()
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                                end
                            until not AutoFarmMasGun or not _G.UseSkillGun or v.Humanoid.Health == 0
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasGun and TypeMastery == 'Near Mob' then
            pcall(function()
                for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v.Name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChild("HumanoidRootPart").Position).Magnitude <= 5000 then
                            repeat wait(_G.Fast_Delay)
                                if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                    _G.UseSkillGun = true
                                else
                                    _G.UseSkillGun = false
                                    AutoHaki()
                                    bringmob = true
                                    EquipTool(SelectWeapon)
                                    Tween(v.HumanoidRootPart.CFrame * Pos)
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v.HumanoidRootPart.Transparency = 1
                                    v.Humanoid.JumpPower = 0
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.CanCollide = false
                                    FarmPos = v.HumanoidRootPart.CFrame
                                    MonFarm = v.Name
                                    AttackNoCoolDown()
                                end
                            until not AutoFarmMasGun or not MasteryType == 'Near Mob' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Near Mob'
                            bringmob = false
                            _G.UseSkillGun = false
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasGun and TypeMastery == 'Ecto' then
            pcall(function()
                local EctoMob = CFrame.new(904.4072265625, 181.05767822266, 33341.38671875)
                Tween(EctoMob)
            end)
            local Distance = (Vector3.new(904.4072265625, 181.05767822266, 33341.38671875) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Distance > 20000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == "Ship Steward" or v.Name == "Ship Engineer" or v.Name == "Ship Deckhand" or v.Name == "Ship Officer" then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkillGun = true
                            else
                                _G.UseSkillGun = false
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                                AttackNoCoolDown()
                            end
                        until not AutoFarmMasGun or not MasteryType == 'Ecto' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Ecto'
                        bringmob = false
                        _G.UseSkillGun = false
                    end
                end
            end
            for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if v.Name == "Ship Steward" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Ship Engineer" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Ship Deckhand" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Ship Officer" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasGun and TypeMastery == 'Cake' then
            pcall(function()
                local cakepos = CFrame.new(-1579.9111328125, 329.7358703613281, -12310.365234375)
                Tween(cakepos)
            end)
            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == "Cookie Crafter" or v.Name == "Cake Guard" or v.Name == "Baking Staff" or v.Name == "Head Baker" then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkillGun = true
                            else
                                _G.UseSkillGun = false
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                                AttackNoCoolDown()
                            end
                        until not AutoFarmMasGun or not MasteryType == 'Cake' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Cake'
                        bringmob = false
                        _G.UseSkillGun = false
                    end
                end
            end
            for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if v.Name == "Cookie Crafter" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Cake Guard" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Baking Staff" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Head Baker" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasGun and TypeMastery == 'Level' then
            pcall(function()
                CheckLevel()
                if not string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    Tween(CFrameQ)
                end
                if (CFrameQ.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                end
            end)
            if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Name == Ms then
                                repeat wait(_G.Fast_Delay)
                                    if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                        _G.UseSkillGun = true
                                    else
                                        _G.UseSkillGun = false
                                        AutoHaki()
                                        bringmob = true
                                        EquipTool(SelectWeapon)
                                        Tween(v.HumanoidRootPart.CFrame * Pos)
                                        v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        v.HumanoidRootPart.Transparency = 1
                                        v.Humanoid.JumpPower = 0
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.CanCollide = false
                                        FarmPos = v.HumanoidRootPart.CFrame
                                        MonFarm = v.Name
                                        AttackNoCoolDown()
                                    end
                                until not AutoFarmMasGun or not MasteryType == 'Level' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Level'
                                bringmob = false
                                _G.UseSkillGun = false
                            end
                        end
                    end
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasGun and TypeMastery == 'Level No Quest' then
            pcall(function()
                CheckLevel()
                Tween(CFrameQ)
            end)
            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == Ms then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkillGun = true
                            else
                                _G.UseSkillGun = false
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                                AttackNoCoolDown()
                            end
                        until not AutoFarmMasGun or not MasteryType == 'Level No Quest' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Level No Quest'
                        bringmob = false
                        _G.UseSkillGun = false
                    end
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasGun and TypeMastery == 'Bone' then
            pcall(function()
                local boneframe = CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625)
                Tween(boneframe)
            end)
            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy" then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkillGun = true
                            else
                                _G.UseSkillGun = false
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                Tween(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                                AttackNoCoolDown()
                            end
                        until not AutoFarmMasGun or not MasteryType == 'Bone' or not v.Parent or v.Humanoid.Health == 0 or not TypeMastery == 'Bone'
                        bringmob = false
                        _G.UseSkillGun = false
                    end
                end
            end
            for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if v.Name == "Reborn Skeleton" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Living Zombie" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Demonic Soul" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                elseif v.Name == "Posessed Mummy" then
                    Tween(v.HumanoidRootPart.CFrame * Pos)
                end
            end
        end
    end
end)
function EquipToolGun()
    pcall(function()
        for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v.ToolTip == "Gun" and v:IsA('Tool') then
                local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name)
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid)
            end
        end
    end)
end
spawn(function()
    local gg = getrawmetatable(game)
    local old = gg.__namecall
    setreadonly(gg, false)
    gg.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = { ... }
        if tostring(method) == "FireServer" then
            if tostring(args[1]) == "RemoteEvent" then
                if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                    if _G.UseSkillGun then
                        if type(args[2]) == "vector" then
                            args[2] = PositionSkillMasteryGun
                        else
                            args[2] = CFrame.new(PositionSkillMasteryGun)
                        end
                        return old(unpack(args))
                    end
                    if _G.UseSkill then
                        if type(args[2]) == "vector" then
                            args[2] = PositionSkillMasteryDevilFruit
                        else
                            args[2] = CFrame.new(PositionSkillMasteryDevilFruit)
                        end
                        return old(unpack(args))
                    end
                end
            end
        end
        return old(...)
    end)
end)
if Sea3 then
local MiscFarm = Tabs.Main:AddSection("Fram Bone")
local StatusBone = Tabs.Main:AddParagraph({
    Title="Status Bone",
    Content=""
})
spawn(function()
    pcall(function()
        while wait() do
            local bones = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
            StatusBone:SetDesc("You Have: " .. tostring(bones) .. " Bones")
        end
    end)
end)
local ToggleBone = Tabs.Main:AddToggle("ToggleBone", {
    Title="Auto Fram Bone",
    Description="", 
    Default=false })
ToggleBone:OnChanged(function(Value)
    _G.AutoBone=Value
    if Value==false then
        wait()
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
    end
end)
Options.ToggleBone:SetValue(false)
local BoneCFrame = CFrame.new(-9515.75, 174.8521728515625, 6079.40625)
spawn(function()
    while wait() do
        if _G.AutoBone then
            pcall(function()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, "Demonic Soul") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==false then
                 Tween(BoneCFrame)
                if (BoneCFrame.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=3 then    
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest","HauntedQuest2",1)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==true then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0 then
                                if v.Name=="Reborn Skeleton" or v.Name=="Living Zombie" or v.Name=="Demonic Soul" or v.Name=="Posessed Mummy" then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Demonic Soul") then
                                        repeat wait(_G.Fast_Delay)
                                            AttackNoCoolDown()
                                            AutoHaki()
                                            bringmob=true
                                            EquipTool(SelectWeapon)
                                            Tween(v.HumanoidRootPart.CFrame*Pos)
                                            v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                            v.HumanoidRootPart.Transparency=1
                                            v.Humanoid.JumpPower=0
                                            v.Humanoid.WalkSpeed=0
                                            v.HumanoidRootPart.CanCollide=false
                                            FarmPos=v.HumanoidRootPart.CFrame
                                            MonFarm=v.Name
                                        until not _G.AutoBone or v.Humanoid.Health<=0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==false
                                    else
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                        bringmob=false
                                    end
                                end
                            end
                        end
                    else
                    end
                end
            end)
        end
    end
end)
local BoneNoQuest = CFrame.new(-9515.75, 174.8521728515625, 6079.40625)
spawn(function()
    while wait() do
        if _G.AutoBoneNoQuest then
            pcall(function()
                Tween(BoneNoQuest)
                if (BoneNoQuest.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=3 then
                end
                if game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy") then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0 then
                            if v.Name=="Reborn Skeleton" or v.Name=="Living Zombie" or v.Name=="Demonic Soul" or v.Name=="Posessed Mummy" then
                                repeat wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    bringmob=true
                                    EquipTool(SelectWeapon)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                    v.HumanoidRootPart.Transparency=1
                                    v.Humanoid.JumpPower=0
                                    v.Humanoid.WalkSpeed=0
                                    v.HumanoidRootPart.CanCollide=false
                                    FarmPos=v.HumanoidRootPart.CFrame
                                    MonFarm=v.Name
                                until not _G.AutoBoneNoQuest or v.Humanoid.Health<=0 or not v.Parent
                            end
                        end
                    end
                end
            end)
        end
    end
end)
Tabs.Main:AddButton({
    Title="Pray",
    Description="",
    Callback=function()
        local args = {
            [1]="gravestoneEvent",
            [2]=1
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.Main:AddButton({
    Title="Try Your Luck",
    Description="",
    Callback=function()
        local args = {
            [1]="gravestoneEvent",
            [2]=2
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
local ToggleRandomBone = Tabs.Main:AddToggle("ToggleRandomBone", {Title="Random Bone",Description="", Default=false })
ToggleRandomBone:OnChanged(function(Value)  
        _G.AutoRandomBone=Value
end)
Options.ToggleRandomBone:SetValue(false)
spawn(function()
    while wait() do
    if _G.AutoRandomBone then
    local args = {
     [1]="Bones",
     [2]="Buy",
     [3]=1,
     [4]=1
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
    end
    end)
end
if Sea3 then
local MiscFarm = Tabs.Main:AddSection("Cake Prince")
local Mob_Kill_Cake_Prince = Tabs.Main:AddParagraph({
    Title="Status Cake Prince",
    Content=""
})
spawn(function()
    while wait() do
        pcall(function()
            if string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"))==88 then
                Mob_Kill_Cake_Prince:SetDesc("Spawner: "..string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,41).."")
            elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"))==87 then
                Mob_Kill_Cake_Prince:SetDesc("Spawner: "..string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,40).."")
            elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"))==86 then
                Mob_Kill_Cake_Prince:SetDesc("Spawner: "..string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,39).." ")
            else
                Mob_Kill_Cake_Prince:SetDesc("Cake Prince : âœ…ï¸")
            end
        end)
    end
end)
local ToggleCake = Tabs.Main:AddToggle("ToggleCake", {
    Title = "Auto Fram Cake",
    Description = "", 
    Default = false
})
ToggleCake:OnChanged(function(Value)
    _G.Cake = Value
    if Value == false then
        wait()
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
    end
end)
Options.ToggleCake:SetValue(false)
spawn(function()
    while wait() do
        if _G.Cake then
            pcall(function()
                if game.ReplicatedStorage:FindFirstChild("Cake Prince") or game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") or game.ReplicatedStorage:FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Cake Prince" or v.Name == "Dough King" then
                                repeat
                                    wait(_G.Fast_Delay)  
                                    AutoHaki()  
                                    EquipTool(SelectWeapon)  
                                    v.HumanoidRootPart.CanCollide = false  
                                    v.Humanoid.WalkSpeed = 0  
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)  
                                    Tween(v.HumanoidRootPart.CFrame * Pos)  
                                    AttackNoCoolDown()  
                                until _G.Cake == false or not v.Parent or v.Humanoid.Health <= 0
                            end    
                        end    
                    else
                        Tween(CFrame.new(-2009.2802734375, 4532.97216796875, -14937.3076171875)) 
                    end
                else
                    if game.Workspace.Enemies:FindFirstChild("Baking Staff") or game.Workspace.Enemies:FindFirstChild("Head Baker") or game.Workspace.Enemies:FindFirstChild("Cake Guard") or game.Workspace.Enemies:FindFirstChild("Cookie Crafter") then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if (v.Name == "Baking Staff" or v.Name == "Head Baker" or v.Name == "Cake Guard" or v.Name == "Cookie Crafter") and v.Humanoid.Health > 0 then
                                repeat
                                    wait(_G.Fast_Delay)  
                                    AutoHaki()  
                                    EquipTool(SelectWeapon)  
                                    bringmob = true  
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)  
                                    POSCAKE = v.HumanoidRootPart.CFrame  
                                    Tween(v.HumanoidRootPart.CFrame * Pos)  
                                    AttackNoCoolDown()  
                                until _G.Cake == false or game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") or game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    else
                        bringmob = false
                        Tween(CFrame.new(-1579.9111328125, 329.7358703613281, -12310.365234375)) 
                    end
                end
            end)
        end
    end
end)
spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if _G.Cake and bringmob and (v.Name == "Cookie Crafter" or v.Name == "Cake Guard" or v.Name == "Baking Staff" or v.Name == "Head Baker") and (v.HumanoidRootPart.Position - POSCAKE.Position).magnitude <= 350 then
                    v.HumanoidRootPart.CFrame = POSCAKE
                    v.HumanoidRootPart.CanCollide = false
                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    if v.Humanoid:FindFirstChild("Animator") then
                        v.Humanoid.Animator:Destroy()
                    end
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                end
            end
        end)
    end)
end)
spawn(function()
    while wait() do
        if _G.Cake then
            pcall(function()
                if game.ReplicatedStorage:FindFirstChild("Cake Prince") or game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") or game.ReplicatedStorage:FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Cake Prince" or v.Name == "Dough King" then
                                repeat
                                    wait(_G.Fast_Delay)  
                                    AutoHaki()  
                                    EquipTool(SelectWeapon)  
                                    v.HumanoidRootPart.CanCollide = false  
                                    v.Humanoid.WalkSpeed = 0  
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)  
                                    Tween(v.HumanoidRootPart.CFrame * Pos)  
                                    AttackNoCoolDown()  
                                until _G.Cake == false or not v.Parent or v.Humanoid.Health <= 0
                            end    
                        end    
                    else
                        Tween(CFrame.new(-2009.2802734375, 4532.97216796875, -14937.3076171875)) 
                    end
                else
                    if game.Workspace.Enemies:FindFirstChild("Baking Staff") or game.Workspace.Enemies:FindFirstChild("Head Baker") or game.Workspace.Enemies:FindFirstChild("Cake Guard") or game.Workspace.Enemies:FindFirstChild("Cookie Crafter") then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if (v.Name == "Baking Staff" or v.Name == "Head Baker" or v.Name == "Cake Guard" or v.Name == "Cookie Crafter") and v.Humanoid.Health > 0 then
                                repeat
                                    wait(_G.Fast_Delay)  
                                    AutoHaki()  
                                    EquipTool(SelectWeapon)  
                                    bringmob = true  
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)  
                                    POSCAKE = v.HumanoidRootPart.CFrame  
                                    Tween(v.HumanoidRootPart.CFrame * Pos)  
                                    AttackNoCoolDown()  
                                until _G.Cake == false or game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") or game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    else
                        bringmob = false
                        Tween(CFrame.new(-1579.9111328125, 329.7358703613281, -12310.365234375)) 
                    end
                end
            end)
        end
    end
end)
    local ToggleSpawnCake = Tabs.Main:AddToggle("ToggleSpawnCake", {
        Title="Spawner Cake Prince",
        Description="", 
        Default=true })
    ToggleSpawnCake:OnChanged(function(Value)
      _G.SpawnCakePrince=Value
    end)
    Options.ToggleSpawnCake:SetValue(true)
end
spawn(function()
  while wait() do
    if _G.SpawnCakePrince then
      local args = {
        [1]="CakePrinceSpawner",
        [2]=true
      }
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))                    
      local args = {
        [1]="CakePrinceSpawner"
      }
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
  end
end)
    if Sea2 then
    local MiscFarm = Tabs.Main:AddSection("Ectoplasm Farm")
    local ToggleVatChatKiDi = Tabs.Main:AddToggle("ToggleVatChatKiDi", {
        Title="Auto Farm Ectoplasm",
        Description="", 
        Default=false })
    ToggleVatChatKiDi:OnChanged(function(Value)
        _G.Ectoplasm=Value
    end)
    Options.ToggleVatChatKiDi:SetValue(false)
    spawn(function()
        while wait() do
            pcall(function()
                if _G.Ectoplasm then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Ship Deckhand") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Engineer") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Steward") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Officer") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Ship Steward" or v.Name=="Ship Engineer" or v.Name=="Ship Deckhand" or v.Name=="Ship Officer" and v:FindFirstChild("Humanoid") then
                                if v.Humanoid.Health>0 then
                                    repeat wait(_G.Fast_Delay)
                                        AttackNoCoolDown()
                                        AutoHaki()
                                        bringmob=true
                                        EquipTool(SelectWeapon)
                                        Tween(v.HumanoidRootPart.CFrame*Pos)
                                        v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                        v.HumanoidRootPart.Transparency=1
                                        v.Humanoid.JumpPower=0
                                        v.Humanoid.WalkSpeed=0
                                        v.HumanoidRootPart.CanCollide=false
                                        FarmPos=v.HumanoidRootPart.CFrame
                                        MonFarm=v.Name
                                    until _G.Ectoplasm==false or not v.Parent or v.Humanoid.Health==0 or not game:GetService("Workspace").Enemies:FindFirstChild(v.Name)
                                    bringmob=false
                                end
                            end
                        end
                    else
                        local Distance = (Vector3.new(904.4072265625, 181.05767822266, 33341.38671875)-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if Distance>20000 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                        end
                        Tween(CFrame.new(904.4072265625, 181.05767822266, 33341.38671875))
                    end
                end
            end)
        end
    end)
end
local boss = Tabs.Main:AddSection("Fram Boss")
    if Sea1 then
        tableBoss={"The Gorilla King","Bobby","Yeti","Mob Leader","Vice Admiral","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Saber Expert"}
    elseif Sea2 then
        tableBoss={"Diamond","Jeremy","Fajita","Don Swan","Smoke Admiral","Cursed Captain","Darkbeard","Order","Awakened Ice Admiral","Tide Keeper"}
    elseif Sea3 then
        tableBoss={"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","rip_indra True Form","Longma","Soul Reaper","Cake Queen"}
    end
    local DropdownBoss = Tabs.Main:AddDropdown("DropdownBoss", {
        Title="Select Boss",
        Description="",
        Values=tableBoss,
        Multi=false,
        Default=1,
    })
    DropdownBoss:SetValue(_G.SelectBoss)
    DropdownBoss:OnChanged(function(Value)
        _G.SelectBoss=Value
    end)
    local ToggleAutoFarmBoss = Tabs.Main:AddToggle("ToggleAutoFarmBoss", {
        Title="Auto Fram Boss",
        Description="", 
        Default=false })
    ToggleAutoFarmBoss:OnChanged(function(Value)
        _G.AutoBoss=Value
    end)
    Options.ToggleAutoFarmBoss:SetValue(false)
    spawn(function()
        while wait() do
            if _G.AutoBoss then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectBoss) then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name==_G.SelectBoss then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                    repeat wait(_G.Fast_Delay)
                                        AttackNoCoolDown()
                                        AutoHaki()
                                        EquipTool(SelectWeapon)
                                        v.HumanoidRootPart.CanCollide=false
                                        v.Humanoid.WalkSpeed=0
                                        v.HumanoidRootPart.Size=Vector3.new(60,60,60)                             
                                        Tween(v.HumanoidRootPart.CFrame*Pos)
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoBoss or not v.Parent or v.Humanoid.Health<=0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss) then
                            Tween(game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame*Pos)
                        end
                    end
                end)
            end
        end
    end)
    local Material = Tabs.Main:AddSection("MateriaList")
    if Sea1 then
        MaterialList={
          "Scrap Metal","Leather","Angel Wings","Magma Ore","Fish Tail"
        } elseif Sea2 then
        MaterialList={
          "Scrap Metal","Leather","Radioactive Material","Mystic Droplet","Magma Ore","Vampire Fang"
        } elseif Sea3 then
        MaterialList={
          "Scrap Metal","Leather","Demonic Wisp","Conjured Cocoa","Dragon Scale","Gunpowder","Fish Tail","Mini Tusk","Hydra Enforcer","Venomous Assailant"
        }
        end
    local DropdownMaterial = Tabs.Main:AddDropdown("DropdownMaterial", {
        Title="Select MateriaList",
        Description="",
        Values=MaterialList,
        Multi=false,
        Default=1,
    })
    DropdownMaterial:SetValue(SelectMaterial)
    DropdownMaterial:OnChanged(function(Value)
        SelectMaterial=Value
    end)
    local ToggleMaterial = Tabs.Main:AddToggle("ToggleMaterial", {
        Title="Auto Fram MateriaList",
        Description="", 
        Default=false })
    ToggleMaterial:OnChanged(function(Value)
        _G.AutoMaterial=Value
        if Value==false then
            wait()
            Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
            wait()
        end
    end)
    Options.ToggleMaterial:SetValue(false)
    spawn(function()
        while task.wait() do
        if _G.AutoMaterial then
        pcall(function()
          MaterialMon(SelectMaterial)
            Tween(MPos)
          if game:GetService("Workspace").Enemies:FindFirstChild(MMon) then
          for i,v in pairs (game.Workspace.Enemies:GetChildren()) do
          if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
          if v.Name==MMon then
            repeat wait(_G.Fast_Delay)
                AttackNoCoolDown()
          AutoHaki()
          bringmob=true
          EquipTool(SelectWeapon)
          Tween(v.HumanoidRootPart.CFrame*Pos)
          v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
          v.HumanoidRootPart.Transparency=1
          v.Humanoid.JumpPower=0
          v.Humanoid.WalkSpeed=0
          v.HumanoidRootPart.CanCollide=false
          FarmPos=v.HumanoidRootPart.CFrame
          MonFarm=v.Name
          until not _G.AutoMaterial or not v.Parent or v.Humanoid.Health<=0
          bringmob=false
        end
          end
          end
          else
            for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do
          if string.find(v.Name, Mon) then
          if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude>=10 then
          Tween(v.HumanoidRootPart.CFrame*Pos)
          end
          end
          end
          end
          end)
        end
        end
      end)
if Sea3 then
local RoughSea = Tabs.Sea:AddSection("Kitsune Island")
local StatusKitsune = Tabs.Sea:AddParagraph({
    Title = "Status Kitsune Island",
    Content = ""
})
function UpdateKitsune()
    if game.Workspace._WorldOrigin.Locations:FindFirstChild('Kitsune Island') then
        StatusKitsune:SetDesc("Kitsune Island : âœ…ï¸")
    else
        StatusKitsune:SetDesc("Kitsune Island : âŒï¸")
    end
end
spawn(function()
    pcall(function()
        while wait() do
            UpdateKitsune()
        end
    end)
end)
local ToggleTPKitsune = Tabs.Sea:AddToggle("ToggleTPKitsune", {Title = "Teleport Kitsune Island", Description = "", Default = false})
ToggleTPKitsune:OnChanged(function(Value)
    _G.TweenToKitsune = Value
end)
Options.ToggleTPKitsune:SetValue(false)
spawn(function()
    local kitsuneIsland
    while not kitsuneIsland do
        kitsuneIsland = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland")
        wait(1)
    end
    while wait() do
        if _G.TweenToKitsune then
            local shrineActive = kitsuneIsland:FindFirstChild("ShrineActive")
            if shrineActive then
                for _, v in pairs(shrineActive:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:find("NeonShrinePart") then
                        Tween2(v.CFrame)
                    end
                end
            end
        end
    end
end)
local ToggleCollectAzure = Tabs.Sea:AddToggle("ToggleCollectAzure", {Title = "Auto Collect Azure", Description = "", Default = false})
ToggleCollectAzure:OnChanged(function(Value)
    _G.CollectAzure = Value
end)
Options.ToggleCollectAzure:SetValue(false)
spawn(function()
    while wait() do
        if _G.CollectAzure then
            pcall(function()
                if game:GetService("Workspace"):FindFirstChild("AttachedAzureEmber") then
                    Tween(game:GetService("Workspace"):WaitForChild("EmberTemplate"):FindFirstChild("Part").CFrame)
                end
            end)
        end
    end
end)
Tabs.Sea:AddButton({
    Title = "Trade Azure",
    Description = "",
    Callback = function()            
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/KitsuneStatuePray"):InvokeServer()
    end
})
local RoughSea = Tabs.Sea:AddSection("Sea")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local SetSpeedBoat = 350 
local nextDistance = 3000 
local npcPosition = Vector3.new(-16665.191, 104.596, 1579.694) 
local rotationSequence = {80, -50, -80, 50} 
local currentStep = 1 
local function getPlayerBoat()
    for _, boat in pairs(Workspace.Boats:GetChildren()) do
        local seat = boat:FindFirstChild("VehicleSeat")
        if seat and seat.Occupant == character:FindFirstChild("Humanoid") then
            return boat
        end
    end
    return nil
end
RunService.RenderStepped:Connect(function()
    if not character or not character.PrimaryPart then return end
    local distance = (character.PrimaryPart.Position - npcPosition).Magnitude
    local distanceInMeters = math.floor(distance / 10)
    if distanceInMeters >= nextDistance then
        local boat = getPlayerBoat()
        if boat and boat.PrimaryPart then
            local angle = rotationSequence[currentStep]
            local newRotation = boat.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(angle), 0)
            boat:SetPrimaryPartCFrame(newRotation)
            currentStep = currentStep + 1
            if currentStep > #rotationSequence then
                currentStep = 1 
            end
            nextDistance = nextDistance + 1000
        end
    end
end)
local seatHistory, isTeleporting, notified = {}, false, false
local islandsToDelete = {
    Prehistoric = { "ShipwreckIsland", "SandIsland", "TreeIsland", "TinyIsland", "MysticIsland", "KitsuneIsland", "FrozenDimension" },
    Mirage = { "ShipwreckIsland", "SandIsland", "TreeIsland", "TinyIsland", "PrehistoricIsland", "KitsuneIsland", "FrozenDimension" },
    Frozen = { "ShipwreckIsland", "SandIsland", "TreeIsland", "TinyIsland", "MysticIsland", "KitsuneIsland", "PrehistoricIsland" }
}
local function createToggle(title, toggleKey, islands, islandName, notification)
    local toggle = Tabs.Sea:AddToggle(toggleKey, { Title = title, Default = false })
    Options[toggleKey]:SetValue(false)
    toggle:OnChanged(function(value) _G[toggleKey] = value end)
    RunService.RenderStepped:Connect(function()
        if not _G[toggleKey] then
            notified = false
            return
        end
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        local function tpToMyBoat()
            if isTeleporting then return end
            isTeleporting = true
            for _, seat in pairs(seatHistory) do
                if seat and seat.Parent and seat.Name == "VehicleSeat" and not seat.Occupant then
                    Tween2(seat.CFrame)
                    break
                end
            end
            isTeleporting = false
        end
        local boatFound, currentBoat = false, nil
        for _, boat in pairs(Workspace.Boats:GetChildren()) do
            local seat = boat:FindFirstChild("VehicleSeat")
            if seat then
                if seat.Occupant == humanoid then
                    boatFound, currentBoat = true, seat
                    seatHistory[boat.Name] = seat
                elseif seat.Occupant == nil then
                    tpToMyBoat()
                end
            end
        end
        if not boatFound then return end
        currentBoat.MaxSpeed = SetSpeedBoat
        currentBoat.CFrame = CFrame.new(currentBoat.Position) * currentBoat.CFrame.Rotation
        VirtualInputManager:SendKeyEvent(true, "W", false, game)
        for _, part in pairs(Workspace.Boats:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        for _, island in ipairs(islands) do
            local toDelete = Workspace.Map:FindFirstChild(island)
            if toDelete and toDelete:IsA("Model") then
                toDelete:Destroy()
            end
        end
        local targetIsland = Workspace.Map:FindFirstChild(islandName)
        if targetIsland then
            VirtualInputManager:SendKeyEvent(false, "W", false, game)
            _G[toggleKey] = false
            if not notified then
                Fluent:Notify({
                    Title = "Lunar",
                    Content = notification,
                    Duration = 10
                })
                notified = true
            end
        end
    end)
end
createToggle("Auto Find Prehistoric", "AutoFindPrehistoric", islandsToDelete.Prehistoric, "PrehistoricIsland", "Prehistoric Island")
createToggle("Auto Find Mirage", "AutoFindMirage", islandsToDelete.Mirage, "MysticIsland", "Mystic Island")
createToggle("Auto Find Leviathan", "AutoFindFrozen", islandsToDelete.Frozen, "FrozenDimension", "Leviathan Island")
local AutoComeTikiToggle = Tabs.Sea:AddToggle("AutoComeTiki", {
    Title="Auto Tiki Island",
    Description="",
    Default=false
})
AutoComeTikiToggle:OnChanged(function(value)
    _G.AutoComeTiki=value 
end)
RunService.RenderStepped:Connect(function()
    if not _G.AutoComeTiki then return end 
    local player = Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then return end
    local humanoid = character.Humanoid
    local boat = nil
    for _, b in pairs(Workspace.Boats:GetChildren()) do
        local seat = b:FindFirstChild("VehicleSeat")
        if seat and seat.Occupant==humanoid then
            boat=seat
            break
        end
    end
    if boat then
        boat.MaxSpeed=SetSpeedBoat  
        local tikiPosition = CFrame.new(-16217.7568359375, 9.126761436462402, 446.06536865234375)
        local currentPosition = boat.Position
        local targetPosition = tikiPosition.Position
        local direction = (targetPosition-currentPosition).unit
        local moveVector = direction*boat.MaxSpeed*RunService.RenderStepped:Wait()
        boat.CFrame=boat.CFrame+moveVector 
        local lookAt = CFrame.new(currentPosition, targetPosition)  
        boat.CFrame=CFrame.new(boat.Position, targetPosition)  
        if (boat.Position-targetPosition).magnitude<120 then
            _G.AutoComeTiki=false
            VirtualInputManager:SendKeyEvent(false, "W", false, game) 
        end
    end
end)
local AutoComeHydraToggle = Tabs.Sea:AddToggle("AutoComeHydra", {
    Title="Auto Hydra Island",
    Description="",
    Default=false
})
AutoComeHydraToggle:OnChanged(function(value)
    _G.AutoComeHydra=value  
end)
RunService.RenderStepped:Connect(function()
    if not _G.AutoComeHydra then return end 
    local player = Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then return end
    local humanoid = character.Humanoid
    local boat = nil
    for _, b in pairs(Workspace.Boats:GetChildren()) do
        local seat = b:FindFirstChild("VehicleSeat")
        if seat and seat.Occupant==humanoid then
            boat=seat
            break
        end
    end
    if boat then
        boat.MaxSpeed=SetSpeedBoat  
        local tikiPosition = CFrame.new(5193.9375,-0.04690289497375488, 1631.578369140625)
        local currentPosition = boat.Position
        local targetPosition = tikiPosition.Position
        local direction = (targetPosition-currentPosition).unit
        local moveVector = direction*boat.MaxSpeed*RunService.RenderStepped:Wait()
        boat.CFrame=boat.CFrame+moveVector 
        local lookAt = CFrame.new(currentPosition, targetPosition)  
        boat.CFrame=CFrame.new(boat.Position, targetPosition)  
        if (boat.Position-targetPosition).magnitude<120 then
            _G.AutoComeHydra=false 
            VirtualInputManager:SendKeyEvent(false, "W", false, game)
        end
    end
end)
Tabs.Sea:AddButton({
    Title="Teleport Sea Hunting",
    Description="",
    Callback=function()
        Tween2(CFrame.new(-16917.154296875, 7.757596015930176, 511.8203125))
    end
})
local seatHistory = {}
local boatList = {"Beast Hunter", "Sleigh", "Miracle", "The Sentinel", "Guardian", "Lantern", "Dinghy", "PirateSloop", "PirateBrigade", "PirateGrandBrigade", "MarineGrandBrigade", "MarineBrigade", "MarineSloop"} 
local DropdownBoat = Tabs.Sea:AddDropdown("DropdownBoat", {
    Title="Select Boat",
    Description="",
    Values=boatList,
    Multi=false,
    Default=1,
})
DropdownBoat:SetValue(selectedBoat)
DropdownBoat:OnChanged(function(Value)
    selectedBoat=Value
end)
local function buyBoat(boatName)
    local args = {
        [1]="BuyBoat",
        [2]=boatName
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    task.delay(2, function()
        for _, boat in pairs(Workspace.Boats:GetChildren()) do
            if boat:IsA("Model") and boat.Name==boatName then
                local seat = boat:FindFirstChild("VehicleSeat")
                if seat and not seat.Occupant then
                    seatHistory[boatName]=seat
                end
            end
        end
    end)
end
local function tpToMyBoat()
    for boatName, seat in pairs(seatHistory) do
        if seat and seat.Parent and seat.Name=="VehicleSeat" and not seat.Occupant then
            Tween2(seat.CFrame)
        end
    end
end
game:GetService("RunService").RenderStepped:Connect(function()
    for boatName, seat in pairs(seatHistory) do
        if seat and seat.Parent and seat.Name=="VehicleSeat" and not seat.Occupant then
            seatHistory[boatName]=seat
        end
    end
end)
Tabs.Sea:AddButton({
    Title="Buy Boat",
    Description="",
    Callback=function()
        buyBoat(selectedBoat)
    end
})
Tabs.Sea:AddButton({
    Title="Teleport Boat",
    Description="",
    Callback=function()
        tpToMyBoat()
    end
})
local ToggleTerrorshark = Tabs.Sea:AddToggle("ToggleTerrorshark", {Title="Auto Terror Shark", Description="", Default=false})
ToggleTerrorshark:OnChanged(function(Value)
    _G.AutoTerrorshark = Value
end)
Options.ToggleTerrorshark:SetValue(false)
_G.IsFlying = false 
spawn(function()
    while wait() do
        if _G.AutoTerrorshark then
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    if character.Humanoid.Health < 6000 and not _G.IsFlying then
                        _G.IsFlying = true
                        Tween(CFrame.new(character.HumanoidRootPart.Position.X, 360, character.HumanoidRootPart.Position.Z))
                    end
                    if _G.IsFlying and character.Humanoid.Health >= 8000 then
                        _G.IsFlying = false
                    end
                    if not _G.IsFlying and character.Humanoid.Health >= 8000 then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") then
                            for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Terrorshark" then
                                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                        repeat 
                                            wait(_G.Fast_Delay)
                                            if character.Humanoid.Health < 6000 then
                                                _G.IsFlying = true
                                                Tween(CFrame.new(character.HumanoidRootPart.Position.X, 360, character.HumanoidRootPart.Position.Z))
                                                break
                                            end
                                            AttackNoCoolDown()
                                            AutoHaki()
                                            EquipTool(SelectWeapon)
                                            v.HumanoidRootPart.CanCollide = false
                                            v.Humanoid.WalkSpeed = 0
                                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                            Tween(v.HumanoidRootPart.CFrame * Pos)
                                        until not _G.AutoTerrorshark or not v.Parent or v.Humanoid.Health <= 0 or _G.IsFlying
                                    end
                                end
                            end
                        else
                            if game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark") then
                                Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark").HumanoidRootPart.CFrame * Pos)
                            end
                        end
                    end
                end
            end)
        end
    end
end)
     local TogglePiranha = Tabs.Sea:AddToggle("TogglePiranha", {Title="Auto Piranha",Description="", Default=false })
     TogglePiranha:OnChanged(function(Value)
        _G.farmpiranya=Value
     end)
     Options.TogglePiranha:SetValue(false)
     spawn(function()
        while wait() do
            if _G.farmpiranya then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Piranha") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Piranha" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                    repeat wait(_G.Fast_Delay)
                                        AttackNoCoolDown()
                                        AutoHaki()
                                        EquipTool(SelectWeapon)
                                        v.HumanoidRootPart.CanCollide=false
                                        v.Humanoid.WalkSpeed=0
                                        v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                        Tween(v.HumanoidRootPart.CFrame*Pos)
                                    until not _G.farmpiranya or not v.Parent or v.Humanoid.Health<=0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Piranha") then
                            Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Piranha").HumanoidRootPart.CFrame*Pos)
                        else  
                        end
                    end
                end)
            end
        end
     end)
     local ToggleShark = Tabs.Sea:AddToggle("ToggleShark", {Title="Auto Shark",Description="", Default=false })
     ToggleShark:OnChanged(function(Value)
        _G.AutoShark=Value
     end)
     Options.ToggleShark:SetValue(false)
     spawn(function()
        while wait() do
            if _G.AutoShark then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Shark") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Shark" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                    repeat wait(_G.Fast_Delay)
                                        AttackNoCoolDown()
                                        AutoHaki()
                                        EquipTool(SelectWeapon)
                                        v.HumanoidRootPart.CanCollide=false
                                        v.Humanoid.WalkSpeed=0
                                        v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                        Tween(v.HumanoidRootPart.CFrame*Pos)
                                        game.Players.LocalPlayer.Character.Humanoid.Sit=false
                                    until not _G.AutoShark or not v.Parent or v.Humanoid.Health<=0
                                end
                            end
                        end
                    else
                        Tween(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat.CFrame*CFrame.new(0,1,0))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark") then
                            Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark").HumanoidRootPart.CFrame*Pos)
                        else
                        end
                    end
                end)
            end
        end
    end)
    local ToggleFishCrew = Tabs.Sea:AddToggle("ToggleFishCrew", {Title="Auto FishCrew",Description="", Default=false })
    ToggleFishCrew:OnChanged(function(Value)
       _G.AutoFishCrew=Value
    end)
    Options.ToggleFishCrew:SetValue(false)
    spawn(function()
        while wait() do
            if _G.AutoFishCrew then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Fish Crew Member" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                    repeat wait(_G.Fast_Delay)
                                        AttackNoCoolDown()
                                        AutoHaki()
                                        EquipTool(SelectWeapon)
                                        v.HumanoidRootPart.CanCollide=false
                                        v.Humanoid.WalkSpeed=0
                                        v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                        Tween(v.HumanoidRootPart.CFrame*Pos)
                                        game.Players.LocalPlayer.Character.Humanoid.Sit=false
                                    until not _G.AutoFishCrew or not v.Parent or v.Humanoid.Health<=0
                                end
                            end
                        end
                    else
                        Tween(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat.CFrame*CFrame.new(0,1,0))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Fish Crew Member") then
                            Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Fish Crew Member").HumanoidRootPart.CFrame*Pos)
                        else
                        end
                    end
                end)
            end
        end
    end)
    local ToggleShip = Tabs.Sea:AddToggle("ToggleShip", {Title="Auto Ship",Description="", Default=false })
    ToggleShip:OnChanged(function(Value)
        _G.Ship=Value
       end)
       Options.ToggleShip:SetValue(false)
       function CheckPirateBoat()
        local checkmmpb = {"PirateGrandBrigade", "PirateBrigade"}
        for r, v in next, game:GetService("Workspace").Enemies:GetChildren() do
            if table.find(checkmmpb, v.Name) and v:FindFirstChild("Health") and v.Health.Value>0 then
                return v
            end
        end
    end
    spawn(function()
while wait() do
    if _G.Ship then
        pcall(function()
            if CheckPirateBoat() then
                game:GetService("VirtualInputManager"):SendKeyEvent(true,32,false,game)
                wait(.5)
                game:GetService("VirtualInputManager"):SendKeyEvent(false,32,false,game)
                local v = CheckPirateBoat()
                repeat
                    wait()
                    spawn(Tween(v.Engine.CFrame*CFrame.new(0,-20, 0)), 1)
                    AimBotSkillPosition=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,-5, 0)
                    Skillaimbot=true
                    AutoSkill=false
                until not v or not v.Parent or v.Health.Value<=0 or not CheckPirateBoat()
                Skillaimbot=true
                AutoSkill=false
            end
        end)
    end
end
end)
    local ToggleGhostShip = Tabs.Sea:AddToggle("ToggleGhostShip", {Title="Auto GhostShip",Description="",Default=false })
    ToggleGhostShip:OnChanged(function(Value)
        _G.GhostShip=Value
       end)
       Options.ToggleGhostShip:SetValue(false)
       function CheckPirateBoat()
        local checkmmpb = {"FishBoat"}
        for r, v in next, game:GetService("Workspace").Enemies:GetChildren() do
            if table.find(checkmmpb, v.Name) and v:FindFirstChild("Health") and v.Health.Value>0 then
                return v
            end
        end
    end
spawn(function()
while wait() do
    pcall(function()
        if _G.bjirFishBoat then
            if CheckPirateBoat() then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, 32, false, game)
                wait()
                game:GetService("VirtualInputManager"):SendKeyEvent(false, 32, false, game)
                local v = CheckPirateBoat()
                repeat
                    wait()
                    spawn(Tween(v.Engine.CFrame*CFrame.new(0,-20, 0), 1))
                    AutoSkill=true
                    Skillaimbot=true
                    AimBotSkillPosition=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,-5, 0)
                until v.Parent or v.Health.Value<=0 or not CheckPirateBoat()
                AutoSkill=false
                Skillaimbot=false
            end
        end
    end)
end
end)
spawn(function()
    while wait() do
        if _G.bjirFishBoat then
               pcall(function()
                    if CheckPirateBoat() then
                        AutoHaki()
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") then
                                if v.ToolTip=="Melee" then
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                end
                            end
                        end
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,"C",false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") then
                                if v.ToolTip=="Blox Fruit" then 
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                end
                            end
                        end
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,"V",false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,"V",false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait()
                        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") then
                                if v.ToolTip=="Sword" then 
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                end
                            end
                        end
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait()
                        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") then
                                if v.ToolTip=="Gun" then 
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                end
                            end
                        end
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                    end
                end)
            end
    end
      end)
    local AutoElite = Tabs.Main:AddSection("Elite")
    local StatusElite = Tabs.Main:AddParagraph({
        Title="Status Elite",
        Content=""
    })
    spawn(function()
        while wait() do
            pcall(function()
                if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban") then
                    StatusElite:SetDesc("Elite Boss: âœ…ï¸ | Killed:  "..game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress"))    
                else
                    StatusElite:SetDesc("Elite Boss: âŒï¸ | Killed: "..game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress"))    
                end
            end)
        end
    end)
    local ToggleElite = Tabs.Main:AddToggle("ToggleElite", {Title="Auto Fram Elite",Description="", Default=false })
    ToggleElite:OnChanged(function(Value)
       _G.AutoElite=Value
       end)
       Options.ToggleElite:SetValue(false)
       spawn(function()
           while task.wait() do
               if _G.AutoElite then
                   pcall(function()
                       game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                       if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==true then
                           if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Diablo") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Deandre") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Urban") then
                               if game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban") then
                                   for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                       if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                           if v.Name=="Diablo" or v.Name=="Deandre" or v.Name=="Urban" then
                                            repeat wait(_G.Fast_Delay)
                                                AttackNoCoolDown()
                                                   EquipTool(SelectWeapon)
                                                   AutoHaki()
                                                   Tween2(v.HumanoidRootPart.CFrame*Pos)
                                                   v.Humanoid.WalkSpeed=0
                                                   v.HumanoidRootPart.CanCollide=false
                                                   v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                               until _G.AutoElite==false or v.Humanoid.Health<=0 or not v.Parent
                                           end
                                       end
                                   end
                               else
                                   if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
                                    Tween2(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo").HumanoidRootPart.CFrame*CFrame.new(2,20,2))
                                   elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
                                    Tween2(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre").HumanoidRootPart.CFrame*CFrame.new(2,20,2))
                                   elseif game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
                                    Tween2(game:GetService("ReplicatedStorage"):FindFirstChild("Urban").HumanoidRootPart.CFrame*CFrame.new(2,20,2))
                                   end
                               end
                           end
                       else
                           game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                       end
                   end)
               end
           end
       end)
    end
if Sea3 then
    local AutoMysticIsland = Tabs.Sea:AddSection("Auto Mystic Island")
    local StatusMirage = Tabs.Sea:AddParagraph({
        Title="Status",
        Content=""
    })
    task.spawn(function()
        while task.wait() do
            pcall(function()
                local moonTextureId = game:GetService("Lighting").Sky.MoonTextureId
                if moonTextureId=="http://www.roblox.com/asset/?id=9709149431" then
                    FullMoonStatus="100%"
                elseif moonTextureId=="http://www.roblox.com/asset/?id=9709149052" then
                    FullMoonStatus="75%"
                elseif moonTextureId=="http://www.roblox.com/asset/?id=9709143733" then
                    FullMoonStatus="50%"
                elseif moonTextureId=="http://www.roblox.com/asset/?id=9709150401" then
                    FullMoonStatus="25%"
                elseif moonTextureId=="http://www.roblox.com/asset/?id=9709149680" then
                    FullMoonStatus="15%"
                else
                    FullMoonStatus="0%"
                end
            end)
        end
    end)
    task.spawn(function()
        while task.wait() do
            pcall(function()
                if game.Workspace.Map:FindFirstChild("MysticIsland") then
                    MirageStatus="âœ…ï¸"
                else
                    MirageStatus="âŒï¸"
                end
            end)
        end
    end)
    spawn(function()
        pcall(function()
            while wait() do
                StatusMirage:SetDesc("Mirage Island: " .. MirageStatus .. " | Full Moon: " .. FullMoonStatus)
            end
        end)
    end)
    Tabs.Sea:AddButton({
        Title="Teleport To HighestPoint",
        Description="",
        Callback=function()
            TweenToHighestPoint()
        end
    })
    function TweenToHighestPoint()
        local HighestPoint = getHighestPoint()
        if HighestPoint then
            Tween2(HighestPoint.CFrame*CFrame.new(0, 211.88, 0))
        end
    end
    function getHighestPoint()
        if not game.Workspace.Map:FindFirstChild("MysticIsland") then
            return nil
        end
        for _, v in pairs(game:GetService("Workspace").Map.MysticIsland:GetDescendants()) do
            if v:IsA("MeshPart") then
                if v.MeshId=="rbxassetid://6745037796" then
                    return v
                end
            end
        end
    end
end
local ToggleTpAdvanced = Tabs.Sea:AddToggle("ToggleTpAdvanced", {
    Title="Teleport To Advanced Fruit Dealer", 
    Description="", 
    Default=false
})
ToggleTpAdvanced:OnChanged(function(Value)
    _G.AutoTpAdvanced=Value
end)
spawn(function()
    while wait() do
        if _G.AutoTpAdvanced then
            local advancedFruitDealer = game.ReplicatedStorage.NPCs:FindFirstChild("Advanced Fruit Dealer")
            if advancedFruitDealer and advancedFruitDealer:IsA("Model") then
                local dealerPosition = advancedFruitDealer.PrimaryPart and advancedFruitDealer.PrimaryPart.Position
                if dealerPosition then
                    Tween2(CFrame.new(dealerPosition))
                end
            end
        end
    end
end)
local ToggleTweenGear = Tabs.Sea:AddToggle("ToggleTweenGear", {Title="Teleport To Gear",Description="", Default=false })
ToggleTweenGear:OnChanged(function(Value)
    _G.TweenToGear=Value
end) 
Options.ToggleTweenGear:SetValue(false)
spawn(function()
    pcall(function()
        while wait() do
            if _G.TweenToGear then
                if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
                    for i,v in pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren()) do 
                        if v:IsA("MeshPart")then 
                            if v.Material==Enum.Material.Neon then  
                                Tween2(v.CFrame)
                            end
                        end
                    end
                end
            end
        end
    end)
    end)
local Togglelockmoon = Tabs.Sea:AddToggle("Togglelockmoon", {
    Title="Lock Moon + Use Race",
    Description="",
    Default=false
})
Togglelockmoon:OnChanged(function(Value)
    _G.AutoLockMoon=Value
end)
Options.Togglelockmoon:SetValue(false)
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoLockMoon then
                local moonDir = game.Lighting:GetMoonDirection()
                local lookAtPos = game.Workspace.CurrentCamera.CFrame.p+moonDir*100
                game.Workspace.CurrentCamera.CFrame=CFrame.lookAt(
                    game.Workspace.CurrentCamera.CFrame.p,
                    lookAtPos
                )
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoLockMoon then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
            end
        end)
    end
end)
local ToggleAutoSaber = Tabs.Item:AddToggle("ToggleAutoSaber", {
    Title="Auto Saber",
    Description="",
    Default=false
})
ToggleAutoSaber:OnChanged(function(Value)
    _G.Auto_Saber=Value
end)
Options.ToggleAutoSaber:SetValue(false)
spawn(function()
    while task.wait() do
        if _G.Auto_Saber and game.Players.LocalPlayer.Data.Level.Value>=200 then
            pcall(function()
                if game:GetService("Workspace").Map.Jungle.Final.Part.Transparency==0 then
                    if game:GetService("Workspace").Map.Jungle.QuestPlates.Door.Transparency==0 then
                        if (CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09,-0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724,-4.39869794e-08, 0.37091279).Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=100 then
                            Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=game:GetService("Workspace").Map.Jungle.QuestPlates.Plate1.Button.CFrame
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=game:GetService("Workspace").Map.Jungle.QuestPlates.Plate2.Button.CFrame
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=game:GetService("Workspace").Map.Jungle.QuestPlates.Plate3.Button.CFrame
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=game:GetService("Workspace").Map.Jungle.QuestPlates.Plate4.Button.CFrame
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=game:GetService("Workspace").Map.Jungle.QuestPlates.Plate5.Button.CFrame
                            wait(1)
                        else
                            Tween(CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09,-0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724,-4.39869794e-08, 0.37091279))
                        end
                    else
                        if game:GetService("Workspace").Map.Desert.Burn.Part.Transparency==0 then
                            if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Torch") or game.Players.LocalPlayer.Character:FindFirstChild("Torch") then
                                EquipTool("Torch")
                                Tween(CFrame.new(1114.61475, 5.04679728, 4350.22803,-0.648466587,-1.28799094e-09, 0.761243105,-5.70652914e-10, 1, 1.20584542e-09,-0.761243105, 3.47544882e-10,-0.648466587))
                            else
                                Tween(CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551,-0.167722285,-0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805e-05,-0.258850515, 0.965917408))
                            end
                        else
                            if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan") ~=0 then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
                                wait(0.5)
                                EquipTool("Cup")
                                wait(0.5)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", game:GetService("Players").LocalPlayer.Character.Cup)
                                wait(0)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
                            else
                                if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")==nil then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                                elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")==0 then
                                    if game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader") or game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader") then
                                        Tween(CFrame.new(-2967.59521,-4.91089821, 5328.70703, 0.342208564,-0.0227849055, 0.939347804, 0.0251603816, 0.999569714, 0.0150796166,-0.939287126, 0.0184739735, 0.342634559))
                                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                            if v.Name=="Mob Leader" then
                                                if game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader [Lv. 120] [Boss]") then
                                                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                                        repeat
                                                            task.wait(_G.Fast_Delay)
                                                            AutoHaki()
                                                            EquipTool(SelectWeapon)
                                                            v.HumanoidRootPart.CanCollide=false
                                                            v.Humanoid.WalkSpeed=0
                                                            v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                                            Tween(v.HumanoidRootPart.CFrame*Pos)
                                                            AttackNoCoolDown()
                                                        until v.Humanoid.Health<=0 or not _G.Auto_Saber
                                                    end
                                                end
                                                if game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader") then
                                                    Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader").HumanoidRootPart.CFrame*Pos)
                                                end
                                            end
                                        end
                                    end
                                elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")==1 then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                                    wait(0.5)
                                    EquipTool("Relic")
                                    wait(0.5)
                                    Tween(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-09, 0.481375456, 2.53851997e-08, 1,-5.79995607e-08,-0.481375456, 6.30572643e-08, 0.876514494))
                                end
                            end
                        end
                    end
                else
                    if game:GetService("Workspace").Enemies:FindFirstChild("Saber Expert") or game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert") then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                if v.Name=="Saber Expert" then
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        EquipTool(SelectWeapon)
                                        Tween(v.HumanoidRootPart.CFrame*Pos)
                                        v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                        v.HumanoidRootPart.Transparency=1
                                        v.Humanoid.JumpPower=0
                                        v.Humanoid.WalkSpeed=0
                                        v.HumanoidRootPart.CanCollide=false
                                        bringmob=true
                                        FarmPos=v.HumanoidRootPart.CFrame
                                        MonFarm=v.Name
                                        AttackNoCoolDown()
                                    until v.Humanoid.Health<=0 or not _G.Auto_Saber
                                    bringmob=true
                                    if v.Humanoid.Health<=0 then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
local ToggleAutoPoleV1 = Tabs.Item:AddToggle("ToggleAutoPoleV1", {
    Title="Auto Pole V1",
    Description="",
    Default=false
})
ToggleAutoPoleV1:OnChanged(function(Value)
    _G.Auto_PoleV1=Value
end)
Options.ToggleAutoPoleV1:SetValue(false)
local PolePos = CFrame.new(-7748.0185546875, 5606.80615234375,-2305.898681640625)
spawn(function()
    while wait() do
        if _G.Auto_PoleV1 then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Thunder God") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name=="Thunder God" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.Humanoid.WalkSpeed=0
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    AttackNoCoolDown()
                                until not _G.Auto_PoleV1 or not v.Parent or v.Humanoid.Health<=0
                            end
                        end
                    end
                else
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-PolePos.Position).Magnitude<1500 then
                        Tween(PolePos)
                    end
                end
                Tween(CFrame.new(-7748.0185546875, 5606.80615234375,-2305.898681640625))
                if game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God") then
                    Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God").HumanoidRootPart.CFrame*Pos)
                end
            end)
        end
    end
end)
local ToggleAutoSaw = Tabs.Item:AddToggle("ToggleAutoSaw", {
    Title="Auto Saw",
    Description="",
    Default=false
})
ToggleAutoSaw:OnChanged(function(Value)
    _G.Auto_Saw=Value
end)
Options.ToggleAutoSaw:SetValue(false)
local PolePos = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094)
spawn(function()
    while wait() do
        if _G.Auto_Saw then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("The Saw") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name=="The Saw" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.Humanoid.WalkSpeed=0
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    AttackNoCoolDown()
                                until not _G.Auto_Saw or not v.Parent or v.Humanoid.Health<=0
                            end
                        end
                    end
                else
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-PolePos.Position).Magnitude<1500 then
                        Tween(PolePos)
                    end
                end
                Tween(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
                if game:GetService("ReplicatedStorage"):FindFirstChild("The Saw") then
                    Tween(game:GetService("ReplicatedStorage"):FindFirstChild("The Saw").HumanoidRootPart.CFrame*Pos)
                end
            end)
        end
    end
end)
local ToggleAutoWarden = Tabs.Item:AddToggle("ToggleAutoWarden", {
    Title="Auto Warden",
    Description="",
    Default=false
})
ToggleAutoWarden:OnChanged(function(Value)
    _G.Auto_Warden=Value
end)
Options.ToggleAutoWarden:SetValue(false)
local WardenPos = CFrame.new(5186.14697265625, 24.86684226989746, 832.1885375976562)
spawn(function()
    while wait() do
        if _G.Auto_Warden then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Chief Warden") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name=="Chief Warden" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.Humanoid.WalkSpeed=0
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    AttackNoCoolDown()
                                until not _G.Auto_Warden or not v.Parent or v.Humanoid.Health<=0
                            end
                        end
                    end
                else
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-WardenPos.Position).Magnitude<1500 then
                        Tween(WardenPos)
                    end
                end
                Tween(CFrame.new(5186.14697265625, 24.86684226989746, 832.1885375976562))
                if game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden") then
                    Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden").HumanoidRootPart.CFrame*Pos)
                end
            end)
        end
    end
end)
if Sea3 then
    local ToggleHallow = Tabs.Item:AddToggle("ToggleHallow", {Title="Auto Hallow",Description="", Default=false })
    ToggleHallow:OnChanged(function(Value)
        AutoHallowSycthe=Value
    end)
    Options.ToggleHallow:SetValue(false)
    spawn(function()
        while wait() do
            if AutoHallowSycthe then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if string.find(v.Name , "Soul Reaper") then
                                repeat wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.Transparency=1
                                    sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                until v.Humanoid.Health<=0 or AutoHallowSycthe==false
                            end
                        end
                    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hallow Essence") then
                        repeat Tween(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)) wait() until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=8                        
                      wait()
                        EquipTool("Hallow Essence")
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper") then
                            Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame*Pos)
                        else
                        end
                    end
                end)
            end
        end
    end)
    spawn(function()
           while wait() do
           if AutoHallowSycthe then
           local args = {
            [1]="Bones",
            [2]="Buy",
            [3]=1,
            [4]=1
           }
           game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
           end
           end
           end)       
           local ToggleYama = Tabs.Main1:AddToggle("ToggleYama", {Title="Auto Yama",Description="", Default=false })
           ToggleYama:OnChanged(function(Value)
            _G.AutoYama=Value
           end)
           Options.ToggleYama:SetValue(false)
           spawn(function()
            while wait() do
                if _G.AutoYama then
                    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress")>=30 then
                        repeat wait()
                            fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)
                        until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Yama") or not _G.AutoYama
                    end
                end
            end
        end)
        local ToggleTushita = Tabs.Main1:AddToggle("ToggleTushita", {Title="Auto Tushita",Description="", Default=false })
        ToggleTushita:OnChanged(function(Value)
            AutoTushita=Value
        end)
        Options.ToggleTushita:SetValue(false)
           spawn(function()
                   while wait() do
                               if AutoTushita then
                                   if game:GetService("Workspace").Enemies:FindFirstChild("Longma") then
                                       for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                           if v.Name==("Longma" or v.Name=="Longma") and v.Humanoid.Health>0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                            repeat wait(_G.Fast_Delay)
                                                AttackNoCoolDown()
                                                   AutoHaki()
                                                   if not game.Players.LocalPlayer.Character:FindFirstChild(SelectWeapon) then
                                                       wait()
                                                       EquipTool(SelectWeapon)
                                                   end
                                                   FarmPos=v.HumanoidRootPart.CFrame
                                                   v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                                   v.Humanoid.JumpPower=0
                                                   v.Humanoid.WalkSpeed=0
                                                   v.HumanoidRootPart.CanCollide=false
                                                   v.Humanoid:ChangeState(11)
                                                   Tween(v.HumanoidRootPart.CFrame*Pos)
                                               until not AutoTushita or not v.Parent or v.Humanoid.Health<=0
                                           end
                                       end
                                   else
                                       Tween(CFrame.new(-10238.875976563, 389.7912902832,-9549.7939453125))
                                   end
                               end
                           end
                   end)
                   local ToggleHoly = Tabs.Main1:AddToggle("ToggleHoly", {Title="Auto Holy",Description="", Default=false })
                   ToggleHoly:OnChanged(function(Value)
                    _G.Auto_Holy_Torch=Value
                   end)
                   Options.ToggleHoly:SetValue(false)
                   spawn(function()
                    while wait() do
                        if _G.Auto_Holy_Torch then
                            pcall(function()
                                wait()
                                repeat Tween(CFrame.new(-10752, 417,-9366)) wait() until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-10752, 417,-9366)).Magnitude<=10
                                wait()
                                repeat Tween(CFrame.new(-11672, 334,-9474)) wait() until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-11672, 334,-9474)).Magnitude<=10
                                wait()
                                repeat Tween(CFrame.new(-12132, 521,-10655)) wait() until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-12132, 521,-10655)).Magnitude<=10
                                wait()
                                repeat Tween(CFrame.new(-13336, 486,-6985)) wait() until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-13336, 486,-6985)).Magnitude<=10
                                wait()
                                repeat Tween(CFrame.new(-13489, 332,-7925)) wait() until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-13489, 332,-7925)).Magnitude<=10
                            end)
                        end
                    end
                end)
            end
local ToggleAutoCanvander = Tabs.Item:AddToggle("ToggleAutoCanvander", {
    Title="Auto Canvander",
    Description="",
    Default=false
})
ToggleAutoCanvander:OnChanged(function(Value)
    _G.Auto_Canvander=Value
end)
Options.ToggleAutoCanvander:SetValue(false)
local PolePos = CFrame.new(5311.07421875, 426.0243835449219, 165.12762451171875)
spawn(function()
    while wait() do
        if _G.Auto_Canvander then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name=="Beautiful Pirate" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.Humanoid.WalkSpeed=0
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    AttackNoCoolDown()
                                until not _G.Auto_Canvander or not v.Parent or v.Humanoid.Health<=0
                            end
                        end
                    end
                else
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-PolePos.Position).Magnitude<1500 then
                        Tween(PolePos)
                    end
                end
                Tween(CFrame.new(5311.07421875, 426.0243835449219, 165.12762451171875))
                if game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate") then
                    Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate").HumanoidRootPart.CFrame*Pos)
                end
            end)
        end
    end
end)
local ToggleAutoMusketeerHat = Tabs.Item:AddToggle("ToggleAutoMusketeerHat", {
    Title="Auto MusketeerHat",
    Description="",
    Default=false
})
ToggleAutoMusketeerHat:OnChanged(function(Value)
    _G.Auto_MusketeerHat=Value
end)
Options.ToggleAutoMusketeerHat:SetValue(false)
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.Auto_MusketeerHat then
                if game:GetService("Players").LocalPlayer.Data.Level.Value>=1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBandits==false then
                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and 
                       string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and 
                       game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==true then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Forest Pirate") then
                            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name=="Forest Pirate" then
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        pcall(function()
                                            EquipTool(SelectWeapon)
                                            AutoHaki()
                                            v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                            Tween(v.HumanoidRootPart.CFrame*Pos)
                                            v.HumanoidRootPart.CanCollide=false
                                            AttackNoCoolDown()
                                            PosMon=v.HumanoidRootPart.CFrame
                                            MonFarm=v.Name
                                            bringmob=true
                                        end)
                                    until _G.Auto_MusketeerHat==false or not v.Parent or v.Humanoid.Health<=0 or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==false
                                    bringmob=false
                                end
                            end
                        else
                            bringmob=false
                            Tween(CFrame.new(-13206.452148438, 425.89199829102,-7964.5537109375))
                        end
                    else
                        Tween(CFrame.new(-12443.8671875, 332.40396118164,-7675.4892578125))
                        if (Vector3.new(-12443.8671875, 332.40396118164,-7675.4892578125)-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=30 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Level.Value>=1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBoss==false then
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible and 
                       string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") and 
                       game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==true then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant") then
                            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name=="Captain Elephant" then
                                    OldCFrameElephant=v.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        pcall(function()
                                            EquipTool(SelectWeapon)
                                            AutoHaki()
                                            v.HumanoidRootPart.CanCollide=false
                                            v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                            Tween(v.HumanoidRootPart.CFrame*Pos)
                                            v.HumanoidRootPart.CanCollide=false
                                            v.HumanoidRootPart.CFrame=OldCFrameElephant
                                            AttackNoCoolDown()
                                        end)
                                    until _G.Auto_MusketeerHat==false or v.Humanoid.Health<=0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible==false
                                end
                            end
                        else
                            Tween(CFrame.new(-13374.889648438, 421.27752685547,-8225.208984375))
                        end
                    else
                        Tween(CFrame.new(-12443.8671875, 332.40396118164,-7675.4892578125))
                        if (CFrame.new(-12443.8671875, 332.40396118164,-7675.4892578125).Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=4 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Level.Value>=1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")==2 then
                    Tween(CFrame.new(-12512.138671875, 340.39279174805,-9872.8203125))
                end
            end
        end
    end)
end)
local ToggleAutoObservationV2 = Tabs.Item:AddToggle("ToggleAutoObservationV2", {
    Title="Auto Observation v2",
    Description="",
    Default=false
})
ToggleAutoObservationV2:OnChanged(function(Value)
    _G.Auto_ObservationV2=Value
end)
Options.ToggleAutoObservationV2:SetValue(false)
spawn(function()
    while wait() do
        pcall(function()
            if _G.Auto_ObservationV2 then
                if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")==3 then
                    _G.Auto_MusketeerHat=false
                    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Banana") 
                        and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Apple") 
                        and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pineapple") then
                        repeat 
                            Tween(CFrame.new(-12444.78515625, 332.40396118164,-7673.1806640625)) 
                            wait() 
                        until not _G.Auto_ObservationV2 
                            or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-12444.78515625, 332.40396118164,-7673.1806640625)).Magnitude<=10
                        wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Fruit Bowl") 
                        or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Fruit Bowl") then
                        repeat 
                            Tween(CFrame.new(-10920.125, 624.20275878906,-10266.995117188)) 
                            wait() 
                        until not _G.Auto_ObservationV2 
                            or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-10920.125, 624.20275878906,-10266.995117188)).Magnitude<=10
                        wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk2", "Start")
                        wait(1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk2", "Buy")
                    else
                        for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                            if v.Name=="Apple" or v.Name=="Banana" or v.Name=="Pineapple" then
                                v.Handle.CFrame=game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0, 1, 10)
                                wait()
                                firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, v.Handle, 0)    
                                wait()
                            end
                        end   
                    end
                else
                    _G.Auto_MusketeerHat=true
                end
            end
        end)
    end
end)
local ToggleAutoRainbowHaki = Tabs.Item:AddToggle("ToggleAutoRainbowHaki", {
    Title="Auto Rainbow Haki",
    Description="",
    Default=false
})
ToggleAutoRainbowHaki:OnChanged(function(Value)
    _G.Auto_RainbowHaki=Value
end)
Options.ToggleAutoRainbowHaki:SetValue(false)
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.Auto_RainbowHaki then
                if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                    Tween(CFrame.new(-11892.0703125, 930.57672119141,-8760.1591796875))
                    if (Vector3.new(-11892.0703125, 930.57672119141,-8760.1591796875)-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=30 then
                        wait(1.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HornedMan", "Bet")
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Stone") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Stone") then
                        for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Stone" then
                                OldCFrameRainbow=v.HumanoidRootPart.CFrame
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    EquipTool(SelectWeapon)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.HumanoidRootPart.CFrame=OldCFrameRainbow
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    AttackNoCoolDown()
                                until not _G.Auto_RainbowHaki or v.Humanoid.Health<=0 or not v.Parent or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                            end
                        end
                    else
                        Tween(CFrame.new(-1086.11621, 38.8425903, 6768.71436))
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Hydra Leader") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Hydra Leader") then
                        for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Hydra Leader" then
                                OldCFrameRainbow=v.HumanoidRootPart.CFrame
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    EquipTool(SelectWeapon)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.HumanoidRootPart.CFrame=OldCFrameRainbow
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    AttackNoCoolDown()
                                until not _G.Auto_RainbowHaki or v.Humanoid.Health<=0 or not v.Parent or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                            end
                        end
                    else
                        Tween(CFrame.new(5713.98877, 601.922974, 202.751251))
                    end
                elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Kilo Admiral") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Kilo Admiral") then
                        for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Kilo Admiral" then
                                OldCFrameRainbow=v.HumanoidRootPart.CFrame
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    EquipTool(SelectWeapon)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    v.HumanoidRootPart.CFrame=OldCFrameRainbow
                                    AttackNoCoolDown()
                                until not _G.Auto_RainbowHaki or v.Humanoid.Health<=0 or not v.Parent or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                            end
                        end
                    else
                        Tween(CFrame.new(2877.61743, 423.558685,-7207.31006))
                    end
                elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant") then
                        for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Captain Elephant" then
                                OldCFrameRainbow=v.HumanoidRootPart.CFrame
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    EquipTool(SelectWeapon)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    v.HumanoidRootPart.CFrame=OldCFrameRainbow
                                    AttackNoCoolDown()
                                until not _G.Auto_RainbowHaki or v.Humanoid.Health<=0 or not v.Parent or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                            end
                        end
                    else
                        Tween(CFrame.new(-13485.0283, 331.709259,-8012.4873))
                    end
                elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Beautiful Pirate") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate") then
                        for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Beautiful Pirate" then
                                OldCFrameRainbow=v.HumanoidRootPart.CFrame
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    EquipTool(SelectWeapon)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    v.HumanoidRootPart.CFrame=OldCFrameRainbow
                                    AttackNoCoolDown()
                                until not _G.Auto_RainbowHaki or v.Humanoid.Health<=0 or not v.Parent or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                            end
                        end
                    else
                        Tween(CFrame.new(5312.3598632813, 20.141201019287,-10.158538818359))
                    end
                else
                    Tween(CFrame.new(-11892.0703125, 930.57672119141,-8760.1591796875))
                    if (Vector3.new(-11892.0703125, 930.57672119141,-8760.1591796875)-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=30 then
                        wait(1.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HornedMan", "Bet")
                    end
                end
            end
        end
    end)
end)
local ToggleAutoSkullGuitar = Tabs.Item:AddToggle("ToggleAutoSkullGuitar", {
    Title="Auto Skull Guitar",
    Description="",
    Default=false
})
ToggleAutoSkullGuitar:OnChanged(function(Value)
    _G.Auto_SkullGuitar=Value
end)
Options.ToggleAutoSkullGuitar:SetValue(false)
spawn(function()
        while wait() do
            pcall(function()
                if _G.Auto_SkullGuitar then
                    if GetWeaponInventory("Skull Guitar")==false then
                        if (CFrame.new(-9681.458984375, 6.139880657196045, 6341.3720703125).Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=5000 then
                            if game:GetService("Workspace").NPCs:FindFirstChild("Skeleton Machine") then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("soulGuitarBuy",true)
                            else
                                if game:GetService("Workspace").Map["Haunted Castle"].Candle1.Transparency==0 then
                                    if game:GetService("Workspace").Map["Haunted Castle"].Placard1.Left.Part.Transparency==0 then
                                        Quest2=true
                                        repeat wait() Tween(CFrame.new(-8762.69140625, 176.84783935546875, 6171.3076171875)) until (CFrame.new(-8762.69140625, 176.84783935546875, 6171.3076171875).Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=3 or not _G.Auto_SkullGuitar
                                        wait(1)
                                        fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard7.Left.ClickDetector)
                                        wait(1)
                                        fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard6.Left.ClickDetector)
                                        wait(1)
                                        fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard5.Left.ClickDetector)
                                        wait(1)
                                        fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard4.Right.ClickDetector)
                                        wait(1)
                                        fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard3.Left.ClickDetector)
                                        wait(1)
                                        fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard2.Right.ClickDetector)
                                        wait(1)
                                        fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard1.Right.ClickDetector)
                                        wait(1)
                                    elseif game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment1:FindFirstChild("ClickDetector") then
                                        if game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part1:FindFirstChild("ClickDetector") then
                                            Quest4=true
                                            repeat wait() Tween(CFrame.new(-9553.5986328125, 65.62338256835938, 6041.58837890625)) until (CFrame.new(-9553.5986328125, 65.62338256835938, 6041.58837890625).Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=3 or not _G.Auto_SkullGuitar
                                            wait(1)
                                            Tween(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.CFrame)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.ClickDetector)
                                            wait(1)
                                            Tween(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.CFrame)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
                                            wait(1)
                                            Tween(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.CFrame)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
                                            wait(1)
                                            Tween(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.CFrame)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.ClickDetector)
                                            wait(1)
                                            Tween(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.CFrame)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
                                            wait(1)
                                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
                                        else
                                            Quest3=true
                                        end
                                    else
                                        if game:GetService("Workspace").NPCs:FindFirstChild("Ghost") then
                                            local args = {
                                                [1]="GuitarPuzzleProgress",
                                                [2]="Ghost"
                                            }
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                                        end
                                        if game.Workspace.Enemies:FindFirstChild("Living Zombie") then
                                            for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                                                if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0 then
                                                    if v.Name=="Living Zombie" then
                                                        EquipTool(SelectWeapon)
                                                        v.HumanoidRootPart.Size=Vector3.new(60,60,60)
                                                        v.HumanoidRootPart.Transparency=1
                                                        v.Humanoid.JumpPower=0
                                                        v.Humanoid.WalkSpeed=0
                                                        v.HumanoidRootPart.CanCollide=false
                                                        v.HumanoidRootPart.CFrame=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,20,0)
                                                        Tween(CFrame.new(-10160.787109375, 138.6616973876953, 5955.03076171875))
                                                        game:GetService'VirtualUser':CaptureController()
                                                        game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                                    end
                                                end
                                            end
                                        else
                                            Tween(CFrame.new(-10160.787109375, 138.6616973876953, 5955.03076171875))
                                        end
                                    end
                                else    
                                    if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent",2), "Error") then
                                        Tween(CFrame.new(-8653.2060546875, 140.98487854003906, 6160.033203125))
                                    elseif string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent",2), "Nothing") then
                                        Tween("Wait Full Moon")
                                    else
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent",2,true)
                                    end
                                end
                            end
                        else
                            Tween(CFrame.new(-9681.458984375, 6.139880657196045, 6341.3720703125))
                        end
                        end
                    end
            end)
        end
end)
local ToggleAutoBuddy = Tabs.Item:AddToggle("ToggleAutoBuddy", {
    Title="Auto Buddy",
    Description="",
    Default=false
})
ToggleAutoBuddy:OnChanged(function(Value)
    _G.Auto_Buddy=Value
end)
Options.ToggleAutoBuddy:SetValue(false)
local BuddyPos = CFrame.new(-731.2034301757812, 381.5658874511719,-11198.4951171875)
spawn(function()
    while wait() do
        if _G.Auto_Buddy then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name=="Cake Queen" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.Humanoid.WalkSpeed=0
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    AttackNoCoolDown()
                                until not _G.Auto_Buddy or not v.Parent or v.Humanoid.Health<=0
                            end
                        end
                    end
                else
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-BuddyPos.Position).Magnitude<1500 then
                        Tween(BuddyPos)
                    end
                end
                Tween(CFrame.new(-731.2034301757812, 381.5658874511719,-11198.4951171875))
                if game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen") then
                    Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen").HumanoidRootPart.CFrame*Pos)
                end
            end)
        end
    end
end)
local ToggleAutoDualKatana = Tabs.Item:AddToggle("ToggleAutoDualKatana", {
    Title="Auto CDK",
    Description="",
    Default=false
})
ToggleAutoDualKatana:OnChanged(function(Value)
    _G.Auto_DualKatana=Value
end)
Options.ToggleAutoDualKatana:SetValue(false)
spawn(function()
        while wait() do
            pcall(function()
                if _G.Auto_DualKatana then
                    if game.Players.LocalPlayer.Character:FindFirstChild("Tushita") or game.Players.LocalPlayer.Backpack:FindFirstChild("Tushita") or game.Players.LocalPlayer.Character:FindFirstChild("Yama") or game.Players.LocalPlayer.Backpack:FindFirstChild("Yama") then
                        if game.Players.LocalPlayer.Character:FindFirstChild("Tushita") or game.Players.LocalPlayer.Backpack:FindFirstChild("Tushita") then
                            if game.Players.LocalPlayer.Backpack:FindFirstChild("Tushita") then
                                EquipTool("Tushita")
                            end
                        elseif game.Players.LocalPlayer.Character:FindFirstChild("Yama") or game.Players.LocalPlayer.Backpack:FindFirstChild("Yama") then
                            if game.Players.LocalPlayer.Backpack:FindFirstChild("Yama") then
                                EquipTool("Yama")
                            end
                        end
                    else
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem","Tushita")
                    end
                end
            end)
        end
    end)
    spawn(function()
        while wait() do
            pcall(function()
                if _G.Auto_DualKatana then
                    if GetMaterial("Alucard Fragment")==0 then
                        Auto_Quest_Yama_1=true
                        Auto_Quest_Yama_2=false
                        Auto_Quest_Yama_3=false
                        Auto_Quest_Tushita_1=false
                        Auto_Quest_Tushita_2=false
                        Auto_Quest_Tushita_3=false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
                    elseif GetMaterial("Alucard Fragment")==1 then
                        Auto_Quest_Yama_1=false
                        Auto_Quest_Yama_2=true
                        Auto_Quest_Yama_3=false
                        Auto_Quest_Tushita_1=false
                        Auto_Quest_Tushita_2=false
                        Auto_Quest_Tushita_3=false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
                    elseif GetMaterial("Alucard Fragment")==2 then
                        Auto_Quest_Yama_1=false
                        Auto_Quest_Yama_2=false
                        Auto_Quest_Yama_3=true
                        Auto_Quest_Tushita_1=false
                        Auto_Quest_Tushita_2=false
                        Auto_Quest_Tushita_3=false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
                    elseif GetMaterial("Alucard Fragment")==3 then
                        Auto_Quest_Yama_1=false
                        Auto_Quest_Yama_2=false
                        Auto_Quest_Yama_3=false
                        Auto_Quest_Tushita_1=true
                        Auto_Quest_Tushita_2=false
                        Auto_Quest_Tushita_3=false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
                    elseif GetMaterial("Alucard Fragment")==4 then
                        Auto_Quest_Yama_1=false
                        Auto_Quest_Yama_2=false
                        Auto_Quest_Yama_3=false
                        Auto_Quest_Tushita_1=false
                        Auto_Quest_Tushita_2=true
                        Auto_Quest_Tushita_3=false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
                    elseif GetMaterial("Alucard Fragment")==5 then
                        Auto_Quest_Yama_1=false
                        Auto_Quest_Yama_2=false
                        Auto_Quest_Yama_3=false
                        Auto_Quest_Tushita_1=false
                        Auto_Quest_Tushita_2=false
                        Auto_Quest_Tushita_3=true
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
                    elseif GetMaterial("Alucard Fragment")==6 then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton Boss [Lv. 2025] [Boss]") or game:GetService("Workspace").ReplicatedStorage:FindFirstChild("Cursed Skeleton Boss [Lv. 2025] [Boss]") then
                            Auto_Quest_Yama_1=false
                            Auto_Quest_Yama_2=false
                            Auto_Quest_Yama_3=false
                            Auto_Quest_Tushita_1=false
                            Auto_Quest_Tushita_2=false
                            Auto_Quest_Tushita_3=false
                            if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton Boss [Lv. 2025] [Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200]") then
                                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v.Name=="Cursed Skeleton Boss" or v.Name=="Cursed Skeleton" then
                                        if v.Humanoid.Health>0 then
                                            EquipTool(Sword)
                                            Tween(v.HumanoidRootPart.CFrame*pos)
                                            v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                            v.HumanoidRootPart.Transparency=1
                                            v.Humanoid.JumpPower=0
                                            v.Humanoid.WalkSpeed=0
                                            v.HumanoidRootPart.CanCollide=false
                                            bringmob=true
                                            FarmPos=v.HumanoidRootPart.CFrame
                                            MonFarm=v.Name
                                            AttackNoCoolDown()
                                        end
                                    end
                                end
                            end
                        else
                            if (CFrame.new(-12361.7060546875, 603.3547973632812,-6550.5341796875).Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=100 then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
                                wait(1)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
                                wait(1)
                                Tween(CFrame.new(-12361.7060546875, 603.3547973632812,-6550.5341796875))
                                wait(1.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                                wait(1.5)
                                Tween(CFrame.new(-12253.5419921875, 598.8999633789062,-6546.8388671875))
                            else
                                Tween(CFrame.new(-12361.7060546875, 603.3547973632812,-6550.5341796875))
                            end   
                        end
                    end
                end
            end)
        end
    end)
    spawn(function()
        while wait() do
            if Auto_Quest_Yama_1 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Mythological Pirate") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Mythological Pirate" then
                                repeat wait()
                                    Tween(v.HumanoidRootPart.CFrame*CFrame.new(0,0,-2))
                                until _G.Auto_DualKatana==false or Auto_Quest_Yama_1==false
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
                            end
                        end
                    else
                        Tween(CFrame.new(-13451.46484375, 543.712890625,-6961.0029296875))
                    end
                end)
            end
        end
    end)
    spawn(function()
        while wait() do
            pcall(function()
                if Auto_Quest_Yama_2 then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HazeESP") then
                            v.HazeESP.Size=UDim2.new(50,50,50,50)
                            v.HazeESP.MaxDistance="inf"
                        end
                    end
                    for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                        if v:FindFirstChild("HazeESP") then
                            v.HazeESP.Size=UDim2.new(50,50,50,50)
                            v.HazeESP.MaxDistance="inf"
                        end
                    end
                end
            end)
        end
    end)
    spawn(function()
        while wait() do
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if Auto_Quest_Yama_2 and v:FindFirstChild("HazeESP") and (v.HumanoidRootPart.Position-FarmPossEsp.Position).magnitude<=300 then
                        v.HumanoidRootPart.CFrame=FarmPossEsp
                        v.HumanoidRootPart.CanCollide=false
                        v.HumanoidRootPart.Size=Vector3.new(50,50,50)
                        if not v.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                            local vc = Instance.new("BodyVelocity", v.HumanoidRootPart)
                            vc.MaxForce=Vector3.new(1, 1, 1)*math.huge
                            vc.Velocity=Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end
    end)
    spawn(function()
        while wait() do
            if Auto_Quest_Yama_2 then 
                pcall(function() 
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HazeESP") then
                            repeat wait()
                                if (v.HumanoidRootPart.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>2000 then
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                else
                                    EquipTool(Sword)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                    v.HumanoidRootPart.Transparency=1
                                    v.Humanoid.JumpPower=0
                                    v.Humanoid.WalkSpeed=0
                                    v.HumanoidRootPart.CanCollide=false
                                    FarmPos=v.HumanoidRootPart.CFrame
                                    MonFarm=v.Name
                                    AttackNoCoolDown()
                                    if v.Humanoid.Health<=0 and v.Humanoid:FindFirstChild("Animator") then
                                        v.Humanoid.Animator:Destroy()
                                    end                            
                                end      
                            until _G.Auto_DualKatana==false or Auto_Quest_Yama_2==false or not v.Parent or v.Humanoid.Health<=0 or not v:FindFirstChild("HazeESP")
                        else
                            for x,y in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                                if y:FindFirstChild("HazeESP") then
                                    if (y.HumanoidRootPart.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>2000 then
                                        Tween(y.HumanoidRootPart.CFrameMon*Pos)
                                    else
                                        Tween(y.HumanoidRootPart.CFrame*Pos)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
    spawn(function()
        while wait() do
            if Auto_Quest_Yama_3 then
                pcall(function()
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Hallow Essence") then         
                        Tween(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame)
                    elseif game:GetService("Workspace").Map:FindFirstChild("HellDimension") then
                        repeat wait()
                            if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200]") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200] [Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Hell's Messenger [Lv. 2200] [Boss]") then
                                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v.Name=="Cursed Skeleton" or v.Name=="Cursed Skeleton" or v.Name=="Hell's Messenger" then
                                        if v.Humanoid.Health>0 then
                                            repeat wait()
                                                EquipTool(Sword)
                                                Tween(v.HumanoidRootPart.CFrame*Pos)
                                                v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                                v.HumanoidRootPart.Transparency=1
                                                v.Humanoid.JumpPower=0
                                                v.Humanoid.WalkSpeed=0
                                                v.HumanoidRootPart.CanCollide=false
                                                FarmPos=v.HumanoidRootPart.CFrame
                                                MonFarm=v.Name
                                                AttackNoCoolDown()
                                                if v.Humanoid.Health<=0 and v.Humanoid:FindFirstChild("Animator") then
                                                    v.Humanoid.Animator:Destroy()
                                                end
                                            until v.Humanoid.Health<=0 or not v.Parent or Auto_Quest_Yama_3==false
                                        end
                                    end
                                end
                            else
                                wait(5)
                                Tween(game:GetService("Workspace").Map.HellDimension.Torch1.CFrame)
                                wait(1.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                                wait(1.5)        
                                Tweem(game:GetService("Workspace").Map.HellDimension.Torch2.CFrame)
                                wait(1.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                                wait(1.5)     
                                Tween(game:GetService("Workspace").Map.HellDimension.Torch3.CFrame)
                                wait(1.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                                wait(1.5)     
                                Tween(game:GetService("Workspace").Map.HellDimension.Exit.CFrame)
                            end
                        until _G.Auto_DualKatana==false or Auto_Quest_Yama_3==false or GetMaterial("Alucard Fragment")==3
                    else
                        if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") or game.ReplicatedStorage:FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]") then
                            if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") then
                                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v.Name=="Soul Reaper" then
                                        if v.Humanoid.Health>0 then
                                            repeat wait()
                                                Tween(v.HumanoidRootPart.CFrame*Pos)
                                            until _G.Auto_DualKatana==false or Auto_Quest_Yama_3==false or game:GetService("Workspace").Map:FindFirstChild("HellDimension")
                                        end
                                    end
                                end
                            else
                                Tween(CFrame.new(-9570.033203125, 315.9346923828125, 6726.89306640625))
                            end
                        else
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones","Buy",1,1)
                        end
                    end
                end)
            end
        end
    end)
    spawn(function()
        while wait() do
            if Auto_Quest_Tushita_1 then
                Tween(CFrame.new(-9546.990234375, 21.139892578125, 4686.1142578125))
                wait(5)
                Tween(CFrame.new(-6120.0576171875, 16.455780029296875,-2250.697265625))
                wait(5)
                Tween(CFrame.new(-9533.2392578125, 7.254445552825928,-8372.69921875))    
            end
        end
    end)
    spawn(function()
        while wait() do
            if Auto_Quest_Tushita_2 then
                pcall(function()
                    if (CFrame.new(-5539.3115234375, 313.800537109375,-2972.372314453125).Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=500 then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if Auto_Quest_Tushita_2 and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0 then
                                if (v.HumanoidRootPart.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<2000 then
                                    repeat wait()
                                        EquipTool(Sword)
                                        Tween(v.HumanoidRootPart.CFrame*Pos)
                                        v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                        v.HumanoidRootPart.Transparency=1
                                        v.Humanoid.JumpPower=0
                                        v.Humanoid.WalkSpeed=0
                                        v.HumanoidRootPart.CanCollide=false
                                        FarmPos=v.HumanoidRootPart.CFrame
                                        MonFarm=v.Name
                                        AttackNoCoolDown()
                                        if v.Humanoid.Health<=0 and v.Humanoid:FindFirstChild("Animator") then
                                            v.Humanoid.Animator:Destroy()
                                        end
                                    until v.Humanoid.Health<=0 or not v.Parent or Auto_Quest_Tushita_2==false
                                end
                            end
                        end
                    else
                        Tween(CFrame.new(-5545.1240234375, 313.800537109375,-2976.616455078125))
                    end
                end)
            end
        end
    end)
    spawn(function()
        while wait() do
            if Auto_Quest_Tushita_3 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") or game.ReplicatedStorage:FindFirstChild("Cake Queen [Lv. 2175] [Boss]") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name=="Cake Queen" then
                                    if v.Humanoid.Health>0 then
                                        repeat wait()
                                            EquipTool(Sword)
                                            Tween(v.HumanoidRootPart.CFrame*Pos)
                                            v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                            v.HumanoidRootPart.Transparency=1
                                            v.Humanoid.JumpPower=0
                                            v.Humanoid.WalkSpeed=0
                                            v.HumanoidRootPart.CanCollide=false
                                            FarmPos=v.HumanoidRootPart.CFrame
                                            MonFarm=v.Name
                                            AttackNoCoolDown()
                                            if v.Humanoid.Health<=0 and v.Humanoid:FindFirstChild("Animator") then
                                                v.Humanoid.Animator:Destroy()
                                            end
                                        until _G.Auto_DualKatana==false or Auto_Quest_Tushita_3==false or game:GetService("Workspace").Map:FindFirstChild("HeavenlyDimension")
                                    end
                                end
                            end
                        else
                            Tween(CFrame.new(-709.3132934570312, 381.6005859375,-11011.396484375))
                        end
                    elseif game:GetService("Workspace").Map:FindFirstChild("HeavenlyDimension") then
                        repeat wait()
                            if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200]") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200] [Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Heaven's Guardian [Lv. 2200] [Boss]") then
                                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v.Name=="Cursed Skeleton" or v.Name=="Cursed Skeleton" or v.Name=="Heaven's Guardian" then
                                        if v.Humanoid.Health>0 then
                                            repeat wait()
                                                EquipTool(Sword)
                                                Tween(v.HumanoidRootPart.CFrame*Pos)
                                                v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                                v.HumanoidRootPart.Transparency=1
                                                v.Humanoid.JumpPower=0
                                                v.Humanoid.WalkSpeed=0
                                                v.HumanoidRootPart.CanCollide=false
                                                FarmPos=v.HumanoidRootPart.CFrame
                                                MonFarm=v.Name
                                                AttackNoCoolDown()
                                                if v.Humanoid.Health<=0 and v.Humanoid:FindFirstChild("Animator") then
                                                    v.Humanoid.Animator:Destroy()
                                                end
                                            until v.Humanoid.Health<=0 or not v.Parent or Auto_Quest_Tushita_3==false
                                        end
                                    end
                                end
                            else
                                wait(5)
                                Tween(game:GetService("Workspace").Map.HeavenlyDimension.Torch1.CFrame)
                                wait(1.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                                wait(1.5)        
                                Tween(game:GetService("Workspace").Map.HeavenlyDimension.Torch2.CFrame)
                                wait(1.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                                wait(1.5)     
                                Tween(game:GetService("Workspace").Map.HeavenlyDimension.Torch3.CFrame)
                                wait(1.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                                wait(1.5)     
                                Tween(game:GetService("Workspace").Map.HeavenlyDimension.Exit.CFrame)
                            end
                        until not _G.Auto_DualKatana or not Auto_Quest_Tushita_3 or GetMaterial("Alucard Fragment")==6
                    end
                end)
            end
        end
    end)
if Sea2 then
        local ToggleFactory = Tabs.Main1:AddToggle("ToggleFactory", {Title="Auto Factory",Description="", Default=false })
        ToggleFactory:OnChanged(function(Value)
            _G.Factory=Value
        end)
        Options.ToggleFactory:SetValue(false)
        spawn(function()
            while wait() do
                if _G.Factory then
                    if game.Workspace.Enemies:FindFirstChild("Core") then
                        for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                            if v.Name=="Core" and v.Humanoid.Health>0 then
                                repeat wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    repeat Tween(CFrame.new(448.46756, 199.356781,-441.389252))
                                        wait()
                                    until not _G.Factory or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(448.46756, 199.356781,-441.389252)).Magnitude<=10
                                    EquipTool(SelectWeapon)
                                    AutoHaki()
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                    v.HumanoidRootPart.Transparency=1
                                    v.Humanoid.JumpPower=0
                                    v.Humanoid.WalkSpeed=0
                                    v.HumanoidRootPart.CanCollide=false
                                    FarmPos=v.HumanoidRootPart.CFrame
                                    MonFarm=v.Name
                                until not v.Parent or v.Humanoid.Health<=0  or _G.Factory==false
                            end
                        end
                    elseif game.ReplicatedStorage:FindFirstChild("Core") then
                        repeat Tween(CFrame.new(448.46756, 199.356781,-441.389252))
                            wait()
                        until not _G.Factory or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(448.46756, 199.356781,-441.389252)).Magnitude<=10
                    end
                end
            end
        end)
    end
local ToggleAutoFarmSwan = Tabs.Main1:AddToggle("ToggleAutoFarmSwan", {
    Title="Auto Fram Swan",
    Description="",
    Default=false
})
ToggleAutoFarmSwan:OnChanged(function(Value)
    _G.Auto_FarmSwan=Value
end)
Options.ToggleAutoFarmSwan:SetValue(false)
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmSwan then
                if game:GetService("Workspace").Enemies:FindFirstChild("Don Swan") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name=="Don Swan" and v.Humanoid.Health>0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            repeat
                                task.wait()
                                pcall(function()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    AttackNoCoolDown()
                                end)
                            until _G.AutoFarmSwan==false or v.Humanoid.Health<=0
                        end
                    end
                else
                    repeat
                        task.wait()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(2284.912109375, 15.537666320801, 905.48291015625))
                    until (CFrame.new(2284.912109375, 15.537666320801, 905.48291015625).Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=4 or _G.AutoFarmSwan==false
                end
            end
        end
    end)
end)
local ToggleAutoRengoku = Tabs.Item:AddToggle("ToggleAutoRengoku", {
    Title="Auto Rengoku",
    Description="",
    Default=false
})
ToggleAutoRengoku:OnChanged(function(Value)
    _G.Auto_Regoku=Value
end)    
Options.ToggleAutoRengoku:SetValue(false)
spawn(function()
    pcall(function()
        while wait() do
            if _G.Auto_Regoku then
                if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hidden Key") then
                    EquipTool("Hidden Key")
                    Tween(CFrame.new(6571.1201171875, 299.23028564453,-6967.841796875))
                elseif game:GetService("Workspace").Enemies:FindFirstChild("Snow Lurker") or game:GetService("Workspace").Enemies:FindFirstChild("Arctic Warrior") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if (v.Name=="Snow Lurker" or v.Name=="Arctic Warrior") and v.Humanoid.Health>0 then
                            repeat
                                task.wait(_G.Fast_Delay)
                                EquipTool(SelectWeapon)
                                AutoHaki()
                                v.HumanoidRootPart.CanCollide=false
                                v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                FarmPos=v.HumanoidRootPart.CFrame
                                MonFarm=v.Name
                                Tween(v.HumanoidRootPart.CFrame*Pos)
                                AttackNoCoolDown()
                                bringmob=true
                            until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or _G.Auto_Regoku==false or not v.Parent or v.Humanoid.Health<=0
                            bringmob=false
                        end
                    end
                else
                    bringmob=false
                    Tween(CFrame.new(5439.716796875, 84.420944213867,-6715.1635742188))
                end
            end
        end
    end)
end)
if Sea2 or Sea3 then
    local ToggleHakiColor = Tabs.Shop:AddToggle("ToggleHakiColor", {Title="Auto Collect Haki",Description="",Default=false })
    ToggleHakiColor:OnChanged(function(Value)
        _G.Auto_Buy_Enchancement=Value
    end)
        Options.ToggleHakiColor:SetValue(false)
    spawn(function()
            while wait() do
                if _G.Auto_Buy_Enchancement then
                    local args = {
                        [1]="ColorsDealer",
                        [2]="2"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end 
            end
        end)
end
if Sea2 then
    local ToggleSwordLengend = Tabs.Shop:AddToggle("ToggleSwordLengend", {Title="Auto Sword Legend",Description="",Default=false })
    ToggleSwordLengend:OnChanged(function(Value)
        _G.BuyLengendSword=Value
    end)
        Options.ToggleSwordLengend:SetValue(false)
        spawn(function()
            while wait() do
                pcall(function()
                    if _G.BuyLengendSword or Triple_A then
                        local args = {
                            [1]="LegendarySwordDealer",
                            [2]="2"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    else
                        wait()
                    end
                end)
            end
        end)
    end
if Sea2 then
    local ToggleEvoRace = Tabs.Main1:AddToggle("ToggleEvoRace", {Title="Auto Race V2", Description="", Default=false})
    ToggleEvoRace:OnChanged(function(Value)
        _G.AutoEvoRace=Value
    end)
    Options.ToggleEvoRace:SetValue(false)
    spawn(function()
        pcall(function()
            while wait(0.1) do
                if _G.AutoEvoRace then
                    if not game:GetService("Players").LocalPlayer.Data.Race:FindFirstChild("Evolved") then
                        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "1")==0 then
                            Tween(CFrame.new(-2779.83521, 72.9661407,-3574.02002,-0.730484903, 6.39014104e-08,-0.68292886, 3.59963224e-08, 1, 5.50667032e-08, 0.68292886, 1.56424669e-08,-0.730484903))
                            if (Vector3.new(-2779.83521, 72.9661407,-3574.02002)-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=4 then
                                wait(1.3)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "2")
                            end
                        elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "1")==1 then
                            pcall(function()
                                if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 1") and not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flower 1") then
                                    Tween(game:GetService("Workspace").Flower1.CFrame)
                                elseif not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 2") and not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flower 2") then
                                    Tween(game:GetService("Workspace").Flower2.CFrame)
                                elseif not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 3") and not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flower 3") then
                                    if game:GetService("Workspace").Enemies:FindFirstChild("Zombie") then
                                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                            if v.Name=="Zombie" then
                                                repeat
                                                    task.wait(_G.Fast_Delay)
                                                    AutoHaki()
                                                    EquipTool(SelectWeapon)
                                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                                    v.HumanoidRootPart.CanCollide=false
                                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                                    AttackNoCoolDown()
                                                    FarmPos=v.HumanoidRootPart.CFrame
                                                    MonFarm=v.Name
                                                    bringmob=true
                                                until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health<=0 or _G.AutoEvoRace==false
                                                bringmob=false
                                            end
                                        end
                                    else
                                        Tween(CFrame.new(-5685.9233398438, 48.480125427246,-853.23724365234))
                                    end
                                end
                            end)
                        elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "1")==2 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "3")
                        end
                    end
                end
            end
        end)
    end)
end
local ToggleAutoT = Tabs.Setting:AddToggle("ToggleAutoT", {Title="Auto On V3", Description="", Default=false })
ToggleAutoT:OnChanged(function(Value)
    _G.AutoT=Value
    end)
 Options.ToggleAutoT:SetValue(false)
 spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoT then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
            end
        end)
    end
    end)
local ToggleAutoY = Tabs.Setting:AddToggle("ToggleAutoY", {Title="Auto On V4", Description="", Default=false })
ToggleAutoY:OnChanged(function(Value)
    _G.AutoY=Value
end)
Options.ToggleAutoY:SetValue(false)
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoY then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
                wait()
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
            end
        end)
    end
end)
local ToggleAutoKen = Tabs.Setting:AddToggle("ToggleAutoKen", {Title="Auto Ken", Description="", Default=false })
ToggleAutoKen:OnChanged(function(Value)
    _G.AutoKen=Value
    if Value then
        game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
    else
        game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", false) 
    end
end)
Options.ToggleAutoKen:SetValue(false)
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoKen then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
            end
        end)
    end
end)
local ToggleSaveSpawn = Tabs.Setting:AddToggle("ToggleSaveSpawn", {Title="Save Set Spawn", Description="", Default=false })
ToggleSaveSpawn:OnChanged(function(Value)
    _G.SaveSpawn=Value
    if Value then
        local args = {
            [1]="SetSpawnPoint"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
end)
Options.ToggleSaveSpawn:SetValue(false)
spawn(function()
    while wait() do
        pcall(function()
            if _G.SaveSpawn then
                local args = {
                    [1]="SetSpawnPoint"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end
        end)
    end
end)
Tabs.Setting:AddButton({
    Title = "Fps Boost",
    Description = "",
    Callback = function()
        local a = false
        local b = game
        local c = b.Workspace
        local d = b.Lighting
        local e = c.Terrain
        e.WaterWaveSize = 0
        e.WaterWaveSpeed = 0
        e.WaterReflectance = 0
        e.WaterTransparency = 0
        d.GlobalShadows = false
        d.FogEnd = 9e9
        d.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"
        for _, f in pairs(b:GetDescendants()) do
            if f:IsA("Part") or f:IsA("Union") or f:IsA("CornerWedgePart") or f:IsA("TrussPart") then
                f.Material = "Plastic"
                f.Reflectance = 0
            elseif f:IsA("Decal") or f:IsA("Texture") and a then
                f.Transparency = 1
            elseif f:IsA("ParticleEmitter") or f:IsA("Trail") then
                f.Lifetime = NumberRange.new(0)
            elseif f:IsA("Explosion") then
                f.BlastPressure = 1
                f.BlastRadius = 1
            elseif f:IsA("Fire") or f:IsA("SpotLight") or f:IsA("Smoke") or f:IsA("Sparkles") then
                f.Enabled = false
            elseif f:IsA("MeshPart") then
                f.Material = "Plastic"
                f.Reflectance = 0
                f.TextureID = 10385902758728957
            end
        end
        for _, g in pairs(d:GetChildren()) do
            if g:IsA("BlurEffect") or g:IsA("SunRaysEffect") or g:IsA("ColorCorrectionEffect") or g:IsA("BloomEffect") or g:IsA("DepthOfFieldEffect") then
                g.Enabled = false
            end
        end
    end
})
local ToggleBringMob = Tabs.Setting:AddToggle("ToggleBringMob", {Title="Bring Mob",Description="", Default=true})
ToggleBringMob:OnChanged(function(Value)
    _G.BringMob = Value
end)
Options.ToggleBringMob:SetValue(true)
spawn(function()
    while wait() do
        pcall(function()
            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if _G.BringMob and bringmob then
                    if v.Name == MonFarm and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if v.Name == "Factory Staff" then
                            if (v.HumanoidRootPart.Position - FarmPos.Position).Magnitude <= 1000000000 then
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.CFrame = FarmPos
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == MonFarm then
                            if (v.HumanoidRootPart.Position - FarmPos.Position).Magnitude <= 10000000000 then
                                v.HumanoidRootPart.CFrame = FarmPos
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.Humanoid:ChangeState(11)
                                v.Humanoid:ChangeState(14)
                                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
local ToggleRemoveNotify = Tabs.Setting:AddToggle("ToggleRemoveNotify", {Title="Remove Notify",Description="", Default=false })
ToggleRemoveNotify:OnChanged(function(Value)
    RemoveNotify=Value
    end)
    Options.ToggleRemoveNotify:SetValue(false)
    spawn(function()
        while wait() do
            if RemoveNotify then
                game.Players.LocalPlayer.PlayerGui.Notifications.Enabled=false
            else
                game.Players.LocalPlayer.PlayerGui.Notifications.Enabled=true
            end
        end
    end)
    local ToggleWhite = Tabs.Setting:AddToggle("ToggleWhite", {Title="Remove White",Description="", Default=false })
    ToggleWhite:OnChanged(function(Value)
       _G.WhiteScreen=Value
       if _G.WhiteScreen==true then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    elseif _G.WhiteScreen==false then
        game:GetService("RunService"):Set3dRenderingEnabled(true)
            end
        end)
        Options.ToggleWhite:SetValue(false)
        local SKill = Tabs.Setting:AddSection("Mastery Skill")
local ToggleZ = Tabs.Setting:AddToggle("ToggleZ", {Title="Skill Z",Description="", Default=true })
ToggleZ:OnChanged(function(Value)
    SkillZ=Value
end)
Options.ToggleZ:SetValue(true)
local ToggleX = Tabs.Setting:AddToggle("ToggleX", {Title="Skill X", Description="",Default=true })
ToggleX:OnChanged(function(Value)
    SkillX=Value
end)
Options.ToggleX:SetValue(true)
local ToggleC = Tabs.Setting:AddToggle("ToggleC", {Title="Skill C",Description="", Default=true })
ToggleC:OnChanged(function(Value)
    SkillC=Value
end)
Options.ToggleC:SetValue(true)
local ToggleV = Tabs.Setting:AddToggle("ToggleV", {Title="Skill V",Description="", Default=true })
ToggleV:OnChanged(function(Value)
    SkillV=Value
end)
Options.ToggleV:SetValue(true)
local ToggleF = Tabs.Setting:AddToggle("ToggleF", {Title="Skill F",Description="", Default=false })
ToggleF:OnChanged(function(Value)
   SkillF=Value
    end)
Options.ToggleF:SetValue(true)
local Usser = Tabs.Info:AddParagraph({
    Title="Status",
    Content="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"..
        "Name : "..game.Players.LocalPlayer.DisplayName.." (@"..game.Players.LocalPlayer.Name..")\n"..
        "Levels : "..game:GetService("Players").LocalPlayer.Data.Level.Value.."\n"..
        "Money : "..game:GetService("Players").LocalPlayer.Data.Beli.Value.."\n"..
        "Point F : "..game:GetService("Players").LocalPlayer.Data.Fragments.Value.."\n"..
        "Bounty : "..game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value.."\n"..
        "Health : "..game.Players.LocalPlayer.Character.Humanoid.Health.."/"..game.Players.LocalPlayer.Character.Humanoid.MaxHealth.."\n"..
        "Energy : "..game.Players.LocalPlayer.Character.Energy.Value.."/"..game.Players.LocalPlayer.Character.Energy.MaxValue.."\n"..
        "Race : "..game:GetService("Players").LocalPlayer.Data.Race.Value.."\n"..
        "Devil Fruit : "..game:GetService("Players").LocalPlayer.Data.DevilFruit.Value.."\n"..
        "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”"
})
local Time = Tabs.Status:AddParagraph({
    Title="Time",
    Content=""
})
local function UpdateLocalTime()
    local date = os.date("*t")
    local hour = date.hour % 24
    local ampm = hour<12 and "AM" or "PM"
    local formattedTime = string.format("%02i:%02i:%02i %s", ((hour-1) % 12)+1, date.min, date.sec, ampm)
    local formattedDate = string.format("%02d/%02d/%04d", date.day, date.month, date.year)
    local LocalizationService = game:GetService("LocalizationService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local name = player.Name
    local regionCode = "Unknown"
    local success, code=pcall(function()
        return LocalizationService:GetCountryRegionForPlayerAsync(player)
    end)
    if success then
        regionCode=code
    end
    Time:SetDesc(formattedDate .. "-" .. formattedTime .. " [ " .. regionCode .. " ]")
end
spawn(function()
    while true do
        UpdateLocalTime()
        game:GetService("RunService").RenderStepped:Wait()
    end
end)
local ServerTime = Tabs.Status:AddParagraph({
    Title="Servers Time",
    Content=""
})
local function UpdateServerTime()
    local GameTime = math.floor(workspace.DistributedGameTime+0.5)
    local Hour = math.floor(GameTime/(60^2)) % 24
    local Minute = math.floor(GameTime/60) % 60
    local Second = GameTime % 60
    ServerTime:SetDesc(string.format("%02d Hour-%02d Minute-%02d Second", Hour, Minute, Second))
end
spawn(function()
    while task.wait() do
        pcall(UpdateServerTime)
    end
end)
local FrozenIsland = Tabs.Status:AddParagraph({
    Title="Leviathan Island",
    Content=""
})
spawn(function()
pcall(function()
    while wait() do
        if game:GetService("Workspace").Map:FindFirstChild("FrozenDimension") then
            FrozenIsland:SetDesc('âœ…')
        else
            FrozenIsland:SetDesc('âŒ')
        end
    end
end)
end)
local Input = Tabs.Status:AddInput("Input", {
        Title="Job ID",
        Default="",
        Placeholder="",
        Numeric=false, 
        Finished=false, 
        Callback=function(Value)
            _G.Job=Value
        end
    })
    Tabs.Status:AddButton({
        Title="Join Job ID",
        Description="",
        Callback=function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.placeId,_G.Job, game.Players.LocalPlayer)
        end
    })
    Tabs.Status:AddButton({
        Title="Copy Job ID",
        Description="",
        Callback=function()
            setclipboard(tostring(game.JobId))
        end
    })
    local Toggle = Tabs.Status:AddToggle("MyToggle", {Title="Spam Join Job ID", Default=false })
    Toggle:OnChanged(function(Value)
  _G.Join=Value
        end)
        spawn(function()
while wait() do
if _G.Join then
game:GetService("TeleportService"):TeleportToPlaceInstance(game.placeId,_G.Job, game.Players.LocalPlayer)
end
end
end)
local ToggleMelee = Tabs.Stats:AddToggle("ToggleMelee", {Title="Add Melee",Description="", Default=false })
ToggleMelee:OnChanged(function(Value)
    _G.Auto_Stats_Melee=Value
    end)
Options.ToggleMelee:SetValue(false)
local ToggleDe = Tabs.Stats:AddToggle("ToggleDe", {Title="Add Default",Description="", Default=false })
ToggleDe:OnChanged(function(Value)
    _G.Auto_Stats_Defense=Value
    end)
Options.ToggleDe:SetValue(false)
local ToggleSword = Tabs.Stats:AddToggle("ToggleSword", {Title="Add Sword",Description="", Default=false })
ToggleSword:OnChanged(function(Value)
    _G.Auto_Stats_Sword=Value
    end)
Options.ToggleSword:SetValue(false)
local ToggleGun = Tabs.Stats:AddToggle("ToggleGun", {Title="Add Gun", Description="",Default=false })
ToggleGun:OnChanged(function(Value)
    _G.Auto_Stats_Gun=Value
    end)
Options.ToggleGun:SetValue(false)
local ToggleFruit = Tabs.Stats:AddToggle("ToggleFruit", {Title="Add Fruit",Description="", Default=false })
ToggleFruit:OnChanged(function(Value)
    _G.Auto_Stats_Devil_Fruit=Value
    end)
Options.ToggleFruit:SetValue(false)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Devil_Fruit then
            local args = {
                [1]="AddPoint",
                [2]="Demon Fruit",
                [3]=3
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Gun then
            local args = {
                [1]="AddPoint",
                [2]="Gun",
                [3]=3
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Sword then
            local args = {
                [1]="AddPoint",
                [2]="Sword",
                [3]=3
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Defense then
            local args = {
                [1]="AddPoint",
                [2]="Defense",
                [3]=3
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Melee then
            local args = {
                [1]="AddPoint",
                [2]="Melee",
                [3]=3
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end)
local Playerslist = {}
for i,v in pairs(game:GetService("Players"):GetChildren()) do
    table.insert(Playerslist,v.Name)
end
local SelectedPly = Tabs.Player:AddDropdown("SelectedPly", {
    Title="Select Player",
    Description="",
    Values=Playerslist,
    Multi=false,
    Default=1,
})
SelectedPly:SetValue(_G.SelectPly)
SelectedPly:OnChanged(function(Value)
    _G.SelectPly=Value
end)
Tabs.Player:AddButton({
    Title="ReLoad Player",
    Description="",
    Callback=function()
        table.clear(Playerslist)
        for i,v in pairs(game:GetService("Players"):GetChildren()) do
            table.insert(Playerslist,v.Name)
        end
    end
})
local ToggleTeleport = Tabs.Player:AddToggle("ToggleTeleport", {Title="Teleport Player", Description="",Default=false })
ToggleTeleport:OnChanged(function(Value)
    _G.TeleportPly=Value
    if Value==false then
        wait()
        AutoHaki()
        Tween2(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
    end
end)
Options.ToggleTeleport:SetValue(false)
spawn(function()
    while wait() do
        if _G.TeleportPly then
            pcall(function()
                if game.Players:FindFirstChild(_G.SelectPly) then
                    Tween2(game.Players[_G.SelectPly].Character.HumanoidRootPart.CFrame)
                end
            end)
        end
    end
end)
local ToggleWalkonWater = Tabs.Player:AddToggle("ToggleWalkonWater", {Title="Walk on Water",Description="", Default=true })
ToggleWalkonWater:OnChanged(function(Value)
  _G.WalkonWater=Value
end)
Options.ToggleWalkonWater:SetValue(true)
spawn(function()
  while task.wait() do
    pcall(function()
      if _G.WalkonWater then
        game:GetService("Workspace").Map["WaterBase-Plane"].Size=Vector3.new(1000,112,1000)
      else
        game:GetService("Workspace").Map["WaterBase-Plane"].Size=Vector3.new(1000,80,1000)
      end
    end)
  end
end)
local ToggleSpeedRun = Tabs.Player:AddToggle("ToggleSpeedRun", {Title = "Speed Run",Description = "", Default = true })
ToggleSpeedRun:OnChanged(function(Value)
    InfAbility = Value
    if Value == false then
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
    end
end)
Options.ToggleSpeedRun:SetValue(true)
spawn(function()
    while wait() do
        if InfAbility then
            InfAb()
        end
    end
end)
function InfAb()
    if InfAbility then
        if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            local inf = Instance.new("ParticleEmitter")
            inf.Acceleration = Vector3.new(0,0,0)
            inf.Archivable = true
            inf.Drag = 20
            inf.EmissionDirection = Enum.NormalId.Top
            inf.Enabled = true
            inf.Lifetime = NumberRange.new(0,0)
            inf.LightInfluence = 0
            inf.LockedToPart = true
            inf.Name = "Agility"
            inf.Rate = 500
            local numberKeypoints2 = {
                NumberSequenceKeypoint.new(0, 0);
                NumberSequenceKeypoint.new(1, 4); 
            }
            inf.Size = NumberSequence.new(numberKeypoints2)
            inf.RotSpeed = NumberRange.new(9999, 99999)
            inf.Rotation = NumberRange.new(0, 0)
            inf.Speed = NumberRange.new(30, 30)
            inf.SpreadAngle = Vector2.new(0,0,0,0)
            inf.Texture = ""
            inf.VelocityInheritance = 0
            inf.ZOffset = 2
            inf.Transparency = NumberSequence.new(0)
            inf.Color = ColorSequence.new(Color3.fromRGB(0,0,0),Color3.fromRGB(0,0,0))
            inf.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        end
    else
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
        end
    end
end
local ToggleNoClip = Tabs.Player:AddToggle("ToggleNoClip", {Title = "No Clip",Description = "", Default = true })
ToggleNoClip:OnChanged(function(value)
    _G.LOf = value
end)
Options.ToggleNoClip:SetValue(true)
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.LOf then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false    
                    end
                end
            end
        end)
    end)
end)
local ToggleEnablePvp = Tabs.Player:AddToggle("ToggleEnablePvp", {Title="Enable PVP", Description="",Default=false })
ToggleEnablePvp:OnChanged(function(Value)
  _G.EnabledPvP=Value
end)
Options.ToggleEnablePvp:SetValue(false)
spawn(function()
  pcall(function()
      while wait() do
          if _G.EnabledPvP then
              if game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible==true then
                  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
              end
          end
      end
  end)
end)
local Teleport = Tabs.Teleport:AddSection("World")
local ToggleAutoSea2 = Tabs.Main1:AddToggle("ToggleAutoSea2", {
    Title="Auto Sea 2",
    Description="",
    Default=false
})
ToggleAutoSea2:OnChanged(function(Value)
    _G.Auto_Sea2=Value
end)
Options.ToggleAutoSea2:SetValue(false)
spawn(function()
    while wait() do 
        if _G.Auto_Sea2 then
            pcall(function()
                local MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
                if MyLevel>=700 and World1 then
                    if game:GetService("Workspace").Map.Ice.Door.CanCollide==false and game:GetService("Workspace").Map.Ice.Door.Transparency==1 then
                        local CFrame1 = CFrame.new(4849.29883, 5.65138149, 719.611877)
                        repeat 
                            Tween(CFrame1) 
                            wait() 
                        until (CFrame1.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=3 or _G.Auto_Sea2==false
                        wait(1.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DressrosaQuestProgress","Detective")
                        wait(0.5)
                        EquipTool("Key")
                        repeat 
                            Tween(CFrame.new(1347.7124, 37.3751602,-1325.6488)) 
                            wait() 
                        until (Vector3.new(1347.7124, 37.3751602,-1325.6488)-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=3 or _G.Auto_Sea2==false
                        wait(0.5)
                    else
                        if game:GetService("Workspace").Map.Ice.Door.CanCollide==false and game:GetService("Workspace").Map.Ice.Door.Transparency==1 then
                            if game:GetService("Workspace").Enemies:FindFirstChild("Ice Admiral") then
                                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v.Name=="Ice Admiral" then
                                        if not v.Humanoid.Health<=0 then
                                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                                                OldCFrameSecond=v.HumanoidRootPart.CFrame
                                                repeat 
                                                    task.wait(_G.Fast_Delay)
                                                    AutoHaki()
                                                    EquipTool(SelectWeapon)
                                                    v.HumanoidRootPart.CanCollide=false
                                                    v.Humanoid.WalkSpeed=0
                                                    v.Head.CanCollide=false
                                                    v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                                    v.HumanoidRootPart.CFrame=OldCFrameSecond
                                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                                    AttackNoCoolDown()
                                                    sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius", math.huge)
                                                until not _G.Auto_Sea2 or not v.Parent or v.Humanoid.Health<=0
                                            end
                                        else
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
                                        end
                                    end
                                end
                            else
                                if game:GetService("ReplicatedStorage"):FindFirstChild("Ice Admiral") then
                                    Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Ice Admiral").HumanoidRootPart.CFrame*Pos)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
local ToggleAutoSea3 = Tabs.Main1:AddToggle("ToggleAutoSea3", {
    Title="Auto Sea 3",
    Description="",
    Default=false
})
ToggleAutoSea3:OnChanged(function(Value)
    _G.Auto_Sea3=Value
end)
Options.ToggleAutoSea3:SetValue(false)
spawn(function()
    while wait() do
        if _G.AutoSea3 then
            pcall(function()
                if game:GetService("Players").LocalPlayer.Data.Level.Value>=1500 and World2 then
                    _G.AutoLevel=false
                    if game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("ZQuestProgress", "General")==0 then
                        Tween(CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016))
                        if (CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016).Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=10 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                        end
                        wait(1.8)
                        if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
                            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name=="rip_indra" then
                                    OldCFrameThird=v.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        AutoHaki()
                                        EquipTool(SelectWeapon)
                                        Tween(v.HumanoidRootPart.CFrame*Pos)
                                        v.HumanoidRootPart.CFrame=OldCFrameThird
                                        v.HumanoidRootPart.Size=Vector3.new(50, 50, 50)
                                        v.HumanoidRootPart.CanCollide=false
                                        v.Humanoid.WalkSpeed=0
                                        AttackNoCoolDown()
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
                                    until _G.AutoSea3==false or v.Humanoid.Health<=0 or not v.Parent
                                end
                            end
                        elseif not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") and (CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016).Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=1000 then
                            Tween(CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016))
                        end
                    end
                end
            end)
        end
    end
end)
Tabs.Teleport:AddButton({
    Title="Sea 1",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
    end
})
Tabs.Teleport:AddButton({
    Title="Sea 2",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
    end
})
Tabs.Teleport:AddButton({
    Title="Sea 3",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
    end
})
local Mastery = Tabs.Teleport:AddSection("Island")
if Sea1 then
 IslandList={
                "WindMill",
                "Marine",
                "Middle Town",
                "Jungle",
                "Pirate Village",
                "Desert",
                "Snow Island",
                "MarineFord",
                "Colosseum",
                "Sky Island 1",
                "Sky Island 2",
                "Sky Island 3",
                "Prison",
                "Magma Village",
                "Under Water Island",
                "Fountain City",
                "Shank Room",
                "Mob Island",
}
elseif Sea2 then
       IslandList={
        "The Cafe",
        "Frist Spot",
        "Dark Area",
        "Flamingo Mansion",
        "Flamingo Room",
        "Green Zone",
        "Factory",
        "Colossuim",
        "Zombie Island",
        "Two Snow Mountain",
        "Punk Hazard",
        "Cursed Ship",
        "Ice Castle",
        "Forgotten Island",
        "Ussop Island",
        "Mini Sky Island",
       }
elseif Sea3 then
    IslandList={
        "Mansion",
        "Port Town",
        "Great Tree",
        "Castle On The Sea",
        "MiniSky", 
        "Hydra Island",
        "Floating Turtle",
        "Haunted Castle",
        "Ice Cream Island",
        "Peanut Island",
        "Cake Island",
        "Cocoa Island",
        "Candy Island",
        "Tiki Outpost",
       }
    end
local DropdownIsland = Tabs.Teleport:AddDropdown("DropdownIsland",{
    Title="Select Island",
    Description="",
    Values=IslandList,
    Multi=false,
    Default=1,
})
DropdownIsland:SetValue(_G.SelectIsland)
DropdownIsland:OnChanged(function(Value)
    _G.SelectIsland=Value
end)
Tabs.Teleport:AddButton({
    Title="Teleport Island",
    Description="",
    Callback=function()
            if _G.SelectIsland=="WindMill" then
                Tween2(CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594))
            elseif _G.SelectIsland=="Marine" then
                Tween2(CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156))
            elseif _G.SelectIsland=="Middle Town" then
                Tween2(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
            elseif _G.SelectIsland=="Jungle" then
                Tween2(CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754))
            elseif _G.SelectIsland=="Pirate Village" then
                Tween2(CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969))
            elseif _G.SelectIsland=="Desert" then
                Tween2(CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688))
            elseif _G.SelectIsland=="Snow Island" then
                Tween2(CFrame.new(1347.8067626953, 104.66806030273,-1319.7370605469))
            elseif _G.SelectIsland=="MarineFord" then
                Tween2(CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313))
            elseif _G.SelectIsland=="Colosseum" then
                Tween2( CFrame.new(-1427.6203613281, 7.2881078720093,-2792.7722167969))
            elseif _G.SelectIsland=="Sky Island 1" then
                Tween2(CFrame.new(-4869.1025390625, 733.46051025391,-2667.0180664063))
            elseif _G.SelectIsland=="Sky Island 2" then  
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248,-1667.55688))
            elseif _G.SelectIsland=="Sky Island 3" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625,-380.29119873047))
            elseif _G.SelectIsland=="Prison" then
                Tween2( CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656))
            elseif _G.SelectIsland=="Magma Village" then
                Tween2(CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875))
            elseif _G.SelectIsland=="Under Water Island" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            elseif _G.SelectIsland=="Fountain City" then
                Tween2(CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813))
            elseif _G.SelectIsland=="Shank Room" then
                Tween2(CFrame.new(-1442.16553, 29.8788261,-28.3547478))
            elseif _G.SelectIsland=="Mob Island" then
                Tween2(CFrame.new(-2850.20068, 7.39224768, 5354.99268))
            elseif _G.SelectIsland=="The Cafe" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-281.93707275390625, 306.130615234375, 609.280029296875))
                wait()
                Tween2(CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828))
            elseif _G.SelectIsland=="Frist Spot" then
                Tween2(CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375))
            elseif _G.SelectIsland=="Dark Area" then
                Tween2(CFrame.new(3780.0302734375, 22.652164459229,-3498.5859375))
            elseif _G.SelectIsland=="Flamingo Mansion" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-281.93707275390625, 306.130615234375, 609.280029296875))
            elseif _G.SelectIsland=="Flamingo Room" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(2284.912109375, 15.152034759521484, 905.48291015625))
            elseif _G.SelectIsland=="Green Zone" then
                Tween2( CFrame.new(-2448.5300292969, 73.016105651855,-3210.6306152344))
            elseif _G.SelectIsland=="Factory" then
                Tween2(CFrame.new(424.12698364258, 211.16171264648,-427.54049682617))
            elseif _G.SelectIsland=="Colossuim" then
                Tween2( CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641))
            elseif _G.SelectIsland=="Zombie Island" then
                Tween2(CFrame.new(-5622.033203125, 492.19604492188,-781.78552246094))
            elseif _G.SelectIsland=="Two Snow Mountain" then
                Tween2(CFrame.new(753.14288330078, 408.23559570313,-5274.6147460938))
            elseif _G.SelectIsland=="Punk Hazard" then
                Tween2(CFrame.new(-6127.654296875, 15.951762199402,-5040.2861328125))
            elseif _G.SelectIsland=="Cursed Ship" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.40197753906, 125.05712890625, 32885.875))
            elseif _G.SelectIsland=="Ice Castle" then
                Tween2(CFrame.new(6148.4116210938, 294.38687133789,-6741.1166992188))
            elseif _G.SelectIsland=="Forgotten Island" then
                Tween2(CFrame.new(-3032.7641601563, 317.89672851563,-10075.373046875))
            elseif _G.SelectIsland=="Ussop Island" then
                Tween2(CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781))
            elseif _G.SelectIsland=="Mini Sky Island" then
                Tween2(CFrame.new(-288.74060058594, 49326.31640625,-35248.59375))
            elseif _G.SelectIsland=="Great Tree" then
                Tween2(CFrame.new(2681.2736816406, 1682.8092041016,-7190.9853515625))
            elseif _G.SelectIsland=="Castle On The Sea" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5075.50927734375, 314.5155029296875,-3150.0224609375))
            elseif _G.SelectIsland=="MiniSky" then
                Tween2(CFrame.new(-260.65557861328, 49325.8046875,-35253.5703125))
            elseif _G.SelectIsland=="Port Town" then
                Tween2(CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375))
            elseif _G.SelectIsland=="Hydra Island" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5661.5322265625, 1013.0907592773438,-334.9649963378906))
            elseif _G.SelectIsland=="Floating Turtle" then
                Tween2(CFrame.new(-13274.528320313, 531.82073974609,-7579.22265625))
            elseif _G.SelectIsland=="Mansion" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12468.5380859375, 375.0094299316406,-7554.62548828125))
            elseif _G.SelectIsland=="Castle On The Sea" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5075.50927734375, 314.5155029296875,-3150.0224609375))
            elseif _G.SelectIsland=="Haunted Castle" then
                Tween2(CFrame.new(-9515.3720703125, 164.00624084473, 5786.0610351562))
            elseif _G.SelectIsland=="Ice Cream Island" then
                Tween2(CFrame.new(-902.56817626953, 79.93204498291,-10988.84765625))
            elseif _G.SelectIsland=="Peanut Island" then
                Tween2(CFrame.new(-2062.7475585938, 50.473892211914,-10232.568359375))
            elseif _G.SelectIsland=="Cake Island" then
                Tween2(CFrame.new(-1884.7747802734375, 19.327526092529297,-11666.8974609375))
            elseif _G.SelectIsland=="Cocoa Island" then
                Tween2(CFrame.new(87.94276428222656, 73.55451202392578,-12319.46484375))
            elseif _G.SelectIsland=="Candy Island" then
                Tween2(CFrame.new(-1014.4241943359375, 149.11068725585938,-14555.962890625))
            elseif _G.SelectIsland=="Tiki Outpost" then
                Tween2(CFrame.new(-16542.447265625, 55.68632888793945, 1044.41650390625))
            end
        end
    })
Tabs.Visual:AddButton({
    Title="Visual",
    Description="",
    Callback=function()
        local plr = game:GetService("Players").LocalPlayer
        local Notification = require(game:GetService("ReplicatedStorage").Notification)
        local Data = plr:WaitForChild("Data")
        local EXPFunction = require(game.ReplicatedStorage:WaitForChild("EXPFunction"))
        local LevelUp = require(game:GetService("ReplicatedStorage").Effect.Container.LevelUp)
        local Sound = require(game:GetService("ReplicatedStorage").Util.Sound)
        local LevelUpSound = game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp_Proxy") or game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp")
        function v129(p15)
            local v130 = p15;
            while true do
                local v131, v132=string.gsub(v130, "^(-?%d+)(%d%d%d)", "%1,%2");
                v130=v131;
                if v132==0 then
                    break;
                end;    
            end;
            return v130;
        end;
        Notification.new("<Color=Yellow>QUEST COMPLETED!<Color=/>"):Display()
        Notification.new("Earned<Color=Yellow>9,999,999,999,999 Exp.<Color=/>(+None)"):Display()
        Notification.new("Earned<Color=Green>$9,999,999,999,999<Color=/>"):Display()
        plr.Data.Exp.Value=999999999999
        plr.Data.Beli.Value=plr.Data.Beli.Value+999999999999
        delay=0
        count=0
        while plr.Data.Exp.Value-EXPFunction(Data.Level.Value)>0 do
            plr.Data.Exp.Value=plr.Data.Exp.Value-EXPFunction(Data.Level.Value)
            plr.Data.Level.Value=plr.Data.Level.Value+1
            plr.Data.Points.Value=plr.Data.Points.Value+3
            LevelUp({ plr })
            Sound.Play(Sound, LevelUpSound.Value)
            Notification.new("<Color=Green>LEVEL UP!<Color=/>(" .. plr.Data.Level.Value .. ")"):Display()
            count=count+1
            if count>=5 then
                delay=tick()
                count=0
                wait()
            end
        end
    end
})
Tabs.Visual:AddInput("Input_Level", {
    Title="Level",
    Default="",
    Placeholder="Enter",
    Numeric=false, 
    Finished=false,
    Callback=function(value)
        game:GetService("Players")["LocalPlayer"].Data.Level.Value=tonumber(value)
    end
})
Tabs.Visual:AddInput("Input_EXP", {
    Title="Exp",
    Default="",
    Placeholder="Enter",
    Numeric=false, 
    Finished=false,
    Callback=function(value)
        game:GetService("Players")["LocalPlayer"].Data.Exp.Value=tonumber(value)
    end
})
Tabs.Visual:AddInput("Input_Beli", {
    Title="Money",
    Default="",
    Placeholder="Enter",
    Numeric=false, 
    Finished=false,
    Callback=function(value)
        game:GetService("Players")["LocalPlayer"].Data.Beli.Value=tonumber(value)
    end
})
Tabs.Visual:AddInput("Input_Fragments", {
    Title="Point F",
    Default="",
    Placeholder="Enter",
    Numeric=false, 
    Finished=false,
    Callback=function(value)
        game:GetService("Players")["LocalPlayer"].Data.Fragments.Value=tonumber(value)
    end
})    
local Remote_GetFruits = game.ReplicatedStorage:FindFirstChild("Remotes").CommF_:InvokeServer("GetFruits");
Table_DevilFruitSniper={}
ShopDevilSell={}
for i, v in next, Remote_GetFruits do
    table.insert(Table_DevilFruitSniper, v.Name)
    if v.OnSale then 
        table.insert(ShopDevilSell, v.Name)
    end
end
_G.SelectFruit=nil
_G.PermanentFruit=nil
_G.AutoBuyFruitSniper=false
_G.AutoSwitchPermanentFruit=false
local DropdownFruit = Tabs.Fruit:AddDropdown("DropdownFruit", {
    Title="Select Fruit",
    Description="",
    Values=Table_DevilFruitSniper,
    Multi=false,
    Default=1,
})
DropdownFruit:SetValue(_G.SelectFruit)
DropdownFruit:OnChanged(function(Value)
    _G.SelectFruit=Value
end)
local ToggleFruit = Tabs.Fruit:AddToggle("ToggleFruit", {
    Title="Buy Fruit",
    Description="",
    Default=false 
})
ToggleFruit:OnChanged(function(Value)
    if Value then
        _G.AutoBuyFruitSniper=true
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", _G.SelectFruit, false)
        end)
        _G.AutoBuyFruitSniper=false
    end
end)
Options.ToggleFruit:SetValue(false)
local DropdownPermanentFruit = Tabs.Fruit:AddDropdown("DropdownPermanentFruit", {
    Title="Buy Permanent Fruit",
    Description="",
    Values=Table_DevilFruitSniper,
    Multi=false,
    Default=1,
})
DropdownPermanentFruit:SetValue(_G.PermanentFruit)
DropdownPermanentFruit:OnChanged(function(Value)
    _G.PermanentFruit=Value
end)
local TogglePermanentFruit = Tabs.Fruit:AddToggle("TogglePermanentFruit", {
    Title="Trade Permanent Fruit",
    Description="",
    Default=false 
})
TogglePermanentFruit:OnChanged(function(Value)
    if Value then
        _G.AutoSwitchPermanentFruit=true
        pcall(function()
            local args = {
                [1]="SwitchFruit",
                [2]=_G.PermanentFruit
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end)
        _G.AutoSwitchPermanentFruit=false
    end
end)
Options.TogglePermanentFruit:SetValue(false)
local ToggleStore = Tabs.Fruit:AddToggle("ToggleStore", {Title="Store Fruit",Description="", Default=false })
ToggleStore:OnChanged(function(Value)
    _G.AutoStoreFruit=Value
end)
Options.ToggleStore:SetValue(false)
spawn(function()
    while task.wait() do
        if _G.AutoStoreFruit then
            pcall(function()
                if _G.AutoStoreFruit then
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bomb Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Bomb-Bomb",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bomb Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spike Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spike Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Spike-Spike",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spike Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Chop Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Chop Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Chop-Chop",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Chop Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spring Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spring Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Spring-Spring",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spring Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rocket Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Kilo Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Rocket-Rocket",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Kilo Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Smoke Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Smoke Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Smoke-Smoke",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Smoke Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spin Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spin Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Spin-Spin",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spin Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flame Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flame Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Flame-Flame",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flame Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Falcon Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Falcon Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Falcon",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("alcon Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ice Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Ice Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Ice-Ice",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Ice Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Sand Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sand Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Sand-Sand",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sand Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dark Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dark Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Dark-Dark",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dark Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ghost Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Revive Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Ghost-Ghost",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Revive Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Diamond Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Diamond Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Diamond-Diamond",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Diamond Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Light Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Light Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Light-Light",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Light Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Love Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Love Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Love-Love",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Love Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rubber Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rubber Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Rubber-Rubber",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rubber Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Barrier Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Barrier Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Barrier-Barrier",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Barrier Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Magma Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Magma Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Magma-Magma",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Magma Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Portal Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Portal Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Door-Door",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Portal Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Quake Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Quake Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Quake-Quake",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Quake Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Buddha Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Buddha Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buddha",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Buddha Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spider Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spider Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Spider-Spider",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spider Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bird: Phoenix Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Phoenix Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Phoenix",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Phoenix Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rumble Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rumble Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Rumble-Rumble",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rumble Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Pain Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pain Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Pain-Pain",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pain Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Gravity Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Gravity Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Gravity-Gravity",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Gravity Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dough Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dough Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Dough-Dough",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dough Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Shadow Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Shadow Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Shadow-Shadow",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Shadow Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Venom Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Venom Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Venom-Venom",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Venom Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Control Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Control Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Control-Control",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Control Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spirit Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spirit Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Soul-Soul",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spirit Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Dragon-Dragon",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Fruit"))
                        if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Leopard Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Leopard Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Leopard-Leopard",game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Leopard Fruit"))
                    end
                end
                end
            end)
        end
        wait()
    end
    end)
local ToggleRandomFruit = Tabs.Fruit:AddToggle("ToggleRandomFruit", {Title="Random Fruit",Description="", Default=false })
ToggleRandomFruit:OnChanged(function(Value)
    _G.Random_Auto=Value
end)
Options.ToggleRandomFruit:SetValue(false)
spawn(function()
    pcall(function()
        while wait() do
            if _G.Random_Auto then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")
            end 
        end
    end)
end)
local ToggleCollectTP = Tabs.Fruit:AddToggle("ToggleCollectTP", {Title="Teleport Fruit",Description="", Default=false })
ToggleCollectTP:OnChanged(function(Value)
    _G.CollectFruitTP=Value
end)
Options.ToggleCollectTP:SetValue(false)
spawn(function()
        while wait() do
            if _G.CollectFruitTP then
                    for i,v in pairs(game.Workspace:GetChildren()) do
                        if string.find(v.Name, "Fruit") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=v.Handle.CFrame
                        end
                    end
                end
            end
       end)
local ToggleCollect = Tabs.Fruit:AddToggle("ToggleCollect", {Title="Collect Fruit",Description="", Default=false })
ToggleCollect:OnChanged(function(Value)
    _G.Tweenfruit=Value
end)
Options.ToggleCollect:SetValue(false)
spawn(function()
    while wait() do
        if _G.Tweenfruit then
            for i,v in pairs(game.Workspace:GetChildren()) do
                if string.find(v.Name, "Fruit") then
                    Tween(v.Handle.CFrame)
                end
            end
        end
end
end)
local Mastery = Tabs.Fruit:AddSection("Esp")
local ToggleEspPlayer = Tabs.Fruit:AddToggle("ToggleEspPlayer", {Title="Player",Description="", Default=false })
ToggleEspPlayer:OnChanged(function(Value)
    ESPPlayer=Value
    UpdatePlayerChams()
end)
Options.ToggleEspPlayer:SetValue(false)
local ToggleEspFruit = Tabs.Fruit:AddToggle("ToggleEspFruit", {Title="Fruit",Description="", Default=false })
ToggleEspFruit:OnChanged(function(Value)
    DevilFruitESP=Value
    while DevilFruitESP do wait()
        UpdateDevilChams() 
    end
end)
Options.ToggleEspFruit:SetValue(false)
local ToggleEspIsland = Tabs.Fruit:AddToggle("ToggleEspIsland", {Title="Island",Description="", Default=false })
ToggleEspIsland:OnChanged(function(Value)
    IslandESP=Value
    while IslandESP do wait()
        UpdateIslandESP() 
    end
end)
Options.ToggleEspIsland:SetValue(false)
local ToggleEspFlower = Tabs.Fruit:AddToggle("ToggleEspFlower", {Title="Flower",Description="", Default=false })
ToggleEspFlower:OnChanged(function(Value)
    FlowerESP=Value
    UpdateFlowerChams() 
end)
Options.ToggleEspFlower:SetValue(false)
spawn(function()
    while wait() do
        if FlowerESP then
            UpdateFlowerChams() 
        end
        if DevilFruitESP then
            UpdateDevilChams() 
        end
        if ChestESP then
            UpdateChestChams() 
        end
        if ESPPlayer then
            UpdatePlayerChams()
        end
        if RealFruitESP then
            UpdateRealFruitChams()
        end
    end
end)
local ToggleEspRealFruit = Tabs.Fruit:AddToggle("ToggleEspRealFruit", {Title="Real Fruit", Description="", Default=false })
ToggleEspRealFruit:OnChanged(function(Value)
    RealFruitEsp=Value
    while RealFruitEsp do 
        wait()
        UpdateRealFruitEsp() 
    end
end)
Options.ToggleEspRealFruit:SetValue(false)
function UpdateRealFruitEsp() 
    for _, v in pairs(game.Workspace.AppleSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if RealFruitEsp then 
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui', v.Handle)
                    bill.Name='NameEsp'..Number
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1, 200, 1, 30)
                    bill.Adornee=v.Handle
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel', bill)
                    name.Font=Enum.Font.GothamSemibold
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(255, 0, 0)
                    name.Text=(v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) .. ' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name .. ' ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) .. ' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end 
        end
    end
    for _, v in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if RealFruitEsp then 
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui', v.Handle)
                    bill.Name='NameEsp'..Number
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1, 200, 1, 30)
                    bill.Adornee=v.Handle
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel', bill)
                    name.Font=Enum.Font.GothamSemibold
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(255, 174, 0)
                    name.Text=(v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) .. ' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name .. ' ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) .. ' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end 
        end
    end
    for _, v in pairs(game.Workspace.BananaSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if RealFruitEsp then 
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui', v.Handle)
                    bill.Name='NameEsp'..Number
                    bill.ExtentsOffset=Vector3.new(0, 1, 0)
                    bill.Size=UDim2.new(1, 200, 1, 30)
                    bill.Adornee=v.Handle
                    bill.AlwaysOnTop=true
                    local name = Instance.new('TextLabel', bill)
                    name.Font=Enum.Font.GothamSemibold
                    name.FontSize="Size14"
                    name.TextWrapped=true
                    name.Size=UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment='Top'
                    name.BackgroundTransparency=1
                    name.TextStrokeTransparency=0.5
                    name.TextColor3=Color3.fromRGB(251, 255, 0)
                    name.Text=(v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) .. ' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text=(v.Name .. ' ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Handle.Position).Magnitude/3) .. ' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end 
        end
    end
end
local ToggleIslandMirageEsp = Tabs.Fruit:AddToggle("ToggleIslandMirageEsp", {Title="Mirage", Description="", Default=false })
ToggleIslandMirageEsp:OnChanged(function(Value)
    IslandMirageEsp=Value
    while IslandMirageEsp do 
        wait()
        UpdateIslandMirageEsp() 
    end
end)
Options.ToggleIslandMirageEsp:SetValue(false)
function isnil(thing)
    return (thing==nil)
end
local function round(n)
    return math.floor(tonumber(n)+0.5)
end
Number=math.random(1, 1000000)
function UpdateIslandMirageEsp() 
    for _, v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if MirageIslandESP then 
                if v.Name=="Mirage Island" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui', v)
                        bill.Name='NameEsp'
                        bill.ExtentsOffset=Vector3.new(0, 1, 0)
                        bill.Size=UDim2.new(1, 200, 1, 30)
                        bill.Adornee=v
                        bill.AlwaysOnTop=true
                        local name = Instance.new('TextLabel', bill)
                        name.Font=Enum.Font.Code
                        name.FontSize=Enum.FontSize.Size14
                        name.TextWrapped=true
                        name.Size=UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment=Enum.TextYAlignment.Top
                        name.BackgroundTransparency=1
                        name.TextStrokeTransparency=0.5
                        name.TextColor3=Color3.fromRGB(80, 245, 245)
                    else
                        v['NameEsp'].TextLabel.Text=(v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position-v.Position).Magnitude/3) .. ' M')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
local Chips = {"Flame","Ice","Quake","Light","Dark","Spider","Rumble","Magma","Buddha","Sand","Phoenix","Dough"}
local DropdownRaid = Tabs.Raid:AddDropdown("DropdownRaid", {
    Title="Select Chip",
    Description="",
    Values=Chips,
    Multi=false,
    Default=1,
})
DropdownRaid:SetValue(SelectChip)
DropdownRaid:OnChanged(function(Value)
    SelectChip=Value
end)
local ToggleBuy = Tabs.Raid:AddToggle("ToggleBuy", {Title="Buy Chip", Description="",Default=false })
ToggleBuy:OnChanged(function(Value)
    _G.Auto_Buy_Chips_Dungeon=Value
end)
Options.ToggleBuy:SetValue(false)
spawn(function()
    while wait() do
        if _G.Auto_Buy_Chips_Dungeon then
            pcall(function()
                local args = {
                    [1]="RaidsNpc",
                    [2]="Select",
                    [3]=SelectChip
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end)
        end
    end
end)
    local ToggleStart = Tabs.Raid:AddToggle("ToggleStart", {Title="Star Raid",Description="", Default=false })
    ToggleStart:OnChanged(function(Value)
        _G.Auto_StartRaid=Value
end)
Options.ToggleStart:SetValue(false)
spawn(function()
    while wait() do
        pcall(function()
            if _G.Auto_StartRaid then
                if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible==false then
                    if not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") and
                        (game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Special Microchip") or
                         game:GetService("Players").LocalPlayer.Character:FindFirstChild("Special Microchip")) then
                        if Sea2 then
                            Tween2(CFrame.new(-6438.73535, 250.645355,-4501.50684))
                            local args = {
                                [1]="SetSpawnPoint"
                            }
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                            fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                        elseif Sea3 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5075.50927734375, 314.5155029296875,-3150.0224609375))
                            Tween2(CFrame.new(-5017.40869, 314.844055,-2823.0127,-0.925743818, 4.48217499e-08,-0.378151238, 4.55503146e-09, 1, 1.07377559e-07, 0.378151238, 9.7681621e-08,-0.925743818))
                            local args = {
                                [1]="SetSpawnPoint"
                            }
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                            fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
                        end
                    end
                end
            end
        end)
    end
end)
local ToggleNextIsland = Tabs.Raid:AddToggle("ToggleNextIsland", {
    Title="Auto Fram Raid",
    Description="",
    Default=false
})
ToggleNextIsland:OnChanged(function(Value)
    AutoNextIsland=Value
    if not Value then
        _G.AutoNear=false
    end
end)
Options.ToggleNextIsland:SetValue(false)
spawn(function()
    local visitedIslands = {}
    while task.wait() do
        if AutoNextIsland then
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local locations = game:GetService("Workspace")["_WorldOrigin"].Locations
                    local pos = character.HumanoidRootPart.Position
                    if (pos-Vector3.new(-6438.73535, 250.645355,-4501.50684)).Magnitude<1 or
                       (pos-Vector3.new(-5017.40869, 314.844055,-2823.0127)).Magnitude<1 then
                        visitedIslands={}  
                    end
                    if locations:FindFirstChild("Island 1") then
                        _G.AutoNear=true
                    end
                    if locations:FindFirstChild("Island 2") and not visitedIslands["Island 2"] then
                        Tween(locations:FindFirstChild("Island 2").CFrame)
                        visitedIslands["Island 2"]=true
                        AutoNextIsland=false
                        wait()
                        AutoNextIsland=true
                    elseif locations:FindFirstChild("Island 3") and not visitedIslands["Island 3"] then
                        Tween(locations:FindFirstChild("Island 3").CFrame)
                        visitedIslands["Island 3"]=true
                        AutoNextIsland=false
                        wait()
                        AutoNextIsland=true
                    elseif locations:FindFirstChild("Island 4") and not visitedIslands["Island 4"] then
                        Tween(locations:FindFirstChild("Island 4").CFrame)
                        visitedIslands["Island 4"]=true
                        AutoNextIsland=false
                        wait()
                        AutoNextIsland=true
                    elseif locations:FindFirstChild("Island 5") and not visitedIslands["Island 5"] then
                        Tween(locations:FindFirstChild("Island 5").CFrame)
                        visitedIslands["Island 5"]=true
                        AutoNextIsland=false
                        wait()
                        AutoNextIsland=true
                    end
                end
            end)
        end
    end
end)
local ToggleAwake = Tabs.Raid:AddToggle("ToggleAwake", {Title="Thá»©c Tá»‰nh",Description="", Default=false })
ToggleAwake:OnChanged(function(Value)
    AutoAwakenAbilities=Value
end)
Options.ToggleAwake:SetValue(false)
spawn(function()
    while task.wait() do
        if AutoAwakenAbilities then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakener","Awaken")
            end)
        end
    end
end)
local ToggleGetFruit = Tabs.Raid:AddToggle("ToggleGetFruit", {Title="Collect Fruit 1M",Description="", Default=false })
ToggleGetFruit:OnChanged(function(Value)
    _G.Autofruit=Value
end)
spawn(function()
    while wait() do
        pcall(function()
     if _G.Autofruit then
local args = {
    [1]="LoadFruit",
    [2]="Rocket-Rocket"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Spin-Spin"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Chop-Chop"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Spring-Spring"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Bomb-Bomb"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Smoke-Smoke"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Spike-Spike"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Flame-Flame"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Falcon-Falcon"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Ice-Ice"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Sand-Sand"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Dark-Dark"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Ghost-Ghost"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Diamond-Diamond"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Light-Light"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Rubber-Rubber"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
local args = {
    [1]="LoadFruit",
    [2]="Barrier-Barrier"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end
end)
end
end)
if Sea2 then
Tabs.Main1:AddButton({
    Title="Teleport Raid Sea 2",
    Description="",
    Callback=function()
     Tween2(CFrame.new(-6438.73535, 250.645355,-4501.50684))
end
})
elseif Sea3 then
    Tabs.Main1:AddButton({
        Title="Teleport Raid Sea 3",
        Description="",
        Callback=function()
         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5075.50927734375, 314.5155029296875,-3150.0224609375))
           Tween2(CFrame.new(-5017.40869, 314.844055,-2823.0127,-0.925743818, 4.48217499e-08,-0.378151238, 4.55503146e-09, 1, 1.07377559e-07, 0.378151238, 9.7681621e-08,-0.925743818))
        end
        })
end
local Mastery = Tabs.Raid:AddSection("Teleport Raid Law")
local ToggleLaw = Tabs.Raid:AddToggle("ToggleLaw", {Title="Auto Raid Law",Description="", Default=false })
ToggleLaw:OnChanged(function(Value)
    Auto_Law=Value
end)
Options.ToggleLaw:SetValue(false)
spawn(function()
    pcall(function()
        while wait() do
            if Auto_Law then
                if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Microchip") and not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Microchip") and not game:GetService("Workspace").Enemies:FindFirstChild("Order") and not game:GetService("ReplicatedStorage"):FindFirstChild("Order") then
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","1")
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","2")
                end
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait() do
            if Auto_Law then
                if not game:GetService("Workspace").Enemies:FindFirstChild("Order") and not game:GetService("ReplicatedStorage"):FindFirstChild("Order") then
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Microchip") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Microchip") then
                        fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
                    end
                end
                if game:GetService("ReplicatedStorage"):FindFirstChild("Order") or game:GetService("Workspace").Enemies:FindFirstChild("Order") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Order") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name=="Order" then
                                repeat wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    Tween(v.HumanoidRootPart.CFrame*Pos)
                                    v.HumanoidRootPart.CanCollide=false
                                    v.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                until not v.Parent or v.Humanoid.Health<=0 or Auto_Law==false
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Order") then
                        Tween(CFrame.new(-6217.2021484375, 28.047645568848,-5053.1357421875))
                    end
                end
            end
        end
    end)
end)
local Mastery = Tabs.Race:AddSection("Race v4")
Tabs.Race:AddButton({
    Title="Temple of Time",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))
    end
})
Tabs.Race:AddButton({
    Title="Pull Lever",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))
        Tween2(CFrame.new(28575.181640625, 14936.6279296875, 72.31636810302734))
    end
})
Tabs.Race:AddButton({
    Title="Buy Gear",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))
        Tween2(CFrame.new(28981.552734375, 14888.4267578125,-120.245849609375))
    end
})
local Mastery = Tabs.Race:AddSection("Race")
Tabs.Race:AddButton({
    Title="Teleport Door Race",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))
                    if game:GetService("Players").LocalPlayer.Data.Race.Value=="Human" then
                    Tween2(CFrame.new(29221.822265625, 14890.9755859375,-205.99114990234375))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Skypiea" then
                    Tween2(CFrame.new(28960.158203125, 14919.6240234375, 235.03948974609375))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Fishman" then
                    Tween2(CFrame.new(28231.17578125, 14890.9755859375,-211.64173889160156))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Cyborg" then
                    Tween2(CFrame.new(28502.681640625, 14895.9755859375,-423.7279357910156))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Ghoul" then
                    Tween2(CFrame.new(28674.244140625, 14890.6767578125, 445.4310607910156))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Mink" then
                    Tween2(CFrame.new(29012.341796875, 14890.9755859375,-380.1492614746094))
                    end
    end
})
local ToggleHumanandghoul = Tabs.Race:AddToggle("ToggleHumanandghoul", {Title="Auto Trial Human/Ghoul",Description="", Default=false })
ToggleHumanandghoul:OnChanged(function(Value)
    KillAura=Value
end)
Options.ToggleHumanandghoul:SetValue(false)
local ToggleAutotrial = Tabs.Race:AddToggle("ToggleAutotrial", {Title="Auto Trial",Description="", Default=false })
ToggleAutotrial:OnChanged(function(Value)
    _G.AutoQuestRace=Value
end)
Options.ToggleAutotrial:SetValue(false)
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoQuestRace then
                if game:GetService("Players").LocalPlayer.Data.Race.Value=="Human" then
                    for i,v in pairs(game.Workspace.Enemies:GetDescendants()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                            pcall(function()
                                repeat wait()
                                    v.Humanoid.Health=0
                                    v.HumanoidRootPart.CanCollide=false
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.AutoQuestRace or not v.Parent or v.Humanoid.Health<=0
                            end)
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Skypiea" then
                    for i,v in pairs(game:GetService("Workspace").Map.SkyTrial.Model:GetDescendants()) do
                        if v.Name=="snowisland_Cylinder.081" then
                            BKP(v.CFrame*CFrame.new(0,0,0))
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Fishman" then
                    for i,v in pairs(game:GetService("Workspace").SeaBeasts.SeaBeast1:GetDescendants()) do
                        if v.Name=="HumanoidRootPart" then
                            Tween(v.CFrame*Pos)
                            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v:IsA("Tool") then
                                    if v.ToolTip=="Melee" then
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                    end
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v:IsA("Tool") then
                                    if v.ToolTip=="Blox Fruit" then
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                    end
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait()
                            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v:IsA("Tool") then
                                    if v.ToolTip=="Sword" then
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                    end
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait()
                            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v:IsA("Tool") then
                                    if v.ToolTip=="Gun" then
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                    end
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Cyborg" then
                    Tween(CFrame.new(28654, 14898.7832,-30, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Ghoul" then
                    for i,v in pairs(game.Workspace.Enemies:GetDescendants()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                            pcall(function()
                                repeat wait()
                                    v.Humanoid.Health=0
                                    v.HumanoidRootPart.CanCollide=false
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.AutoQuestRace or not v.Parent or v.Humanoid.Health<=0
                            end)
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value=="Mink" then
                    for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do
                        if v.Name=="StartPoint" then
                            Tween(v.CFrame*CFrame.new(0,10,0))
                          end
                       end
                end
            end
        end
    end)
end)
local ToggleKillTrial = Tabs.Race:AddToggle("ToggleKillTrial", {Title="Kill Player Trial", Description="", Default=false})
ToggleKillTrial:OnChanged(function(Value)
    _G.AutoKillTrial=Value
end)
Options.ToggleKillTrial:SetValue(false)
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoKillTrial then
                for _, v in pairs(game:GetService("Players"):GetChildren()) do
                    if v.Name and v.Name ~=game.Players.LocalPlayer.Name and 
                       (v.Character.HumanoidRootPart.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<=100 then
                        if v.Character.Humanoid.Health>0 then
                            repeat
                                wait(_G.Fast_Delay)
                                EquipTool(SelectWeapon)
                                AutoHaki()
                                Tween(v.Character.HumanoidRootPart.CFrame*CFrame.new(0, 0, 5))
                                v.Character.HumanoidRootPart.CanCollide=false
                                v.Character.HumanoidRootPart.Size=Vector3.new(60, 60, 60)
                                AttackNoCoolDown()
                            until not _G.AutoKillTrial or not v.Parent or v.Character.Humanoid.Health<=0
                        end
                    end
                end
            end
        end)
    end
end)
local Mastery = Tabs.Race:AddSection("Train Race")
local ToggleFarmRace = Tabs.Race:AddToggle("ToggleFarmRace", {Title="Auto Train", Description="", Default=false})
local AutoFarmRace = false 
ToggleFarmRace:OnChanged(function(Value)
    AutoFarmRace=Value
end)
Options.ToggleFarmRace:SetValue(false)
spawn(function()
    while wait() do
        if AutoFarmRace then 
            pcall(function()
                if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
                    if game.Players.LocalPlayer.Character.RaceTransformed.Value==true then
                        _G.AutoBoneNoQuest=false
                        Tween(CFrame.new(-9698.4736328125, 445.09442138671875, 6545.8525390625))
                    elseif game.Players.LocalPlayer.Character.RaceTransformed.Value==false then
                        _G.AutoBoneNoQuest=true
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
                        wait()
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
                    end
                end
            end)
        else
            _G.AutoBoneNoQuest=false 
        end
    end
end)
local ToggleUpgrade = Tabs.Race:AddToggle("ToggleUpgrade", {Title="Upgrade Gear", Description="", Default=false })
ToggleUpgrade:OnChanged(function(Value)
    _G.AutoUpgrade=Value
    if _G.AutoUpgrade then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer('UpgradeRace', 'Buy')
    end
end)
Options.ToggleUpgrade:SetValue(false)
local Mastery = Tabs.Shop:AddSection("Ability")
Tabs.Shop:AddButton({
    Title="Geppo",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
    end
})
Tabs.Shop:AddButton({
    Title="Buso",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
    end
})
Tabs.Shop:AddButton({
    Title="Soru",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")
    end
})
Tabs.Shop:AddButton({
    Title="Ken",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk","Buy")
    end
})
local Mastery = Tabs.Shop:AddSection("Sword")
Tabs.Shop:AddButton({
    Title="Cutlass",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Cutlass")
    end
})
Tabs.Shop:AddButton({
    Title="Katana",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Katana")
    end
})
Tabs.Shop:AddButton({
    Title="Iron Mace",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Iron Mace")
    end
})
Tabs.Shop:AddButton({
    Title="Duel Katana",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Duel Katana")
    end
})
Tabs.Shop:AddButton({
    Title="Triple Katana",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Triple Katana")
    end
})
Tabs.Shop:AddButton({
    Title="Pipe",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Pipe")
    end
})
Tabs.Shop:AddButton({
    Title="Dual-Headed Blade",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Dual-Headed Blade")
    end
})
Tabs.Shop:AddButton({
    Title="Bisento",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Bisento")
    end
})
Tabs.Shop:AddButton({
    Title="Soul Cane",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Soul Cane")
    end
})
Tabs.Shop:AddButton({
    Title="Pole V2",
    Description="",
    Callback=function()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ThunderGodTalk")
    end
})
local Mastery = Tabs.Shop:AddSection("Gun")
Tabs.Shop:AddButton({
    Title="Musket",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Musket")
    end
})
Tabs.Shop:AddButton({
    Title="Slingshot",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Slingshot")
    end
})
Tabs.Shop:AddButton({
    Title="Flintlock",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Flintlock")
    end
})
Tabs.Shop:AddButton({
    Title="Refined Slingshot",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Refined Slingshot")
    end
})
Tabs.Shop:AddButton({
    Title="Dual Flintlock",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Dual Flintlock")
    end
})
Tabs.Shop:AddButton({
    Title="Cannon",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Cannon")
    end
})
Tabs.Shop:AddButton({
    Title="Kabucha",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","2")
    end
})
local Mastery = Tabs.Shop:AddSection("Accessory")
Tabs.Shop:AddButton({
    Title="Black Cape",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Black Cape")
    end
})
Tabs.Shop:AddButton({
    Title="Swordsman Hat",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Swordsman Hat")
    end
})
Tabs.Shop:AddButton({
    Title="Tomoe Ring",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Tomoe Ring")
    end
})
local Mastery = Tabs.Shop:AddSection("Melee")
Tabs.Shop:AddButton({
    Title="Black Leg",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
    end
})
Tabs.Shop:AddButton({
    Title="Electro",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
    end
})
Tabs.Shop:AddButton({
    Title="Fishman Karate",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
    end
})
Tabs.Shop:AddButton({
    Title="Dragon Claw",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
    end
})
Tabs.Shop:AddButton({
    Title="Superhuman",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
    end
})
Tabs.Shop:AddButton({
    Title="Death Step",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
    end
})
Tabs.Shop:AddButton({
    Title="Sharkman Karate",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
    end
})
Tabs.Shop:AddButton({
    Title="Electric Claw",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
    end
})
Tabs.Shop:AddButton({
    Title="Dragon Talon",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
    end
})
Tabs.Shop:AddButton({
    Title="Godhuman",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
    end
})
Tabs.Shop:AddButton({
    Title="Sanguine Art",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySanguineArt")
    end
})
local Mastery = Tabs.Shop:AddSection("Misc")
Tabs.Shop:AddButton({
    Title="Reset Start",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")
    end
})
Tabs.Shop:AddButton({
    Title="Trade Race",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
    end
})
Tabs.Shop:AddButton({
    Title="Race Ghoul",
    Description="",
    Callback=function()
        local args = {
            [1]="Ectoplasm",
            [2]="Change",
            [3]=4
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.Shop:AddButton({
    Title="Race Cyborg",
    Description="",
    Callback=function()
        local args = {
            [1]="CyborgTrainer",
            [2]="Buy"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.Shop:AddButton({
    Title="Race Draco",
    Description="Sea 3",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438,-334.9649963378906))
        Tween2(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
        local targetPosition = Vector3.new(5814.42724609375, 1208.3267822265625, 884.5785522460938)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        repeat
            wait()
        until (character.HumanoidRootPart.Position-targetPosition).Magnitude<1
        local args = {
            [1]={
                ["NPC"]="Dragon Wizard",
                ["Command"]="DragonRace"
            }
        }
        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
    end
})
Tabs.Misc:AddButton({
    Title="Join Server",
    Description="",
    Callback=function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end
})
Tabs.Misc:AddButton({
    Title="Rejoin Server",
    Description="",
    Callback=function()
        Hop()
    end
})
function Hop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
        local Site;
        if foundAnything=="" then
            Site=game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site=game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~="null" and Site.nextPageCursor ~=nil then
            foundAnything=Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID=tostring(v.id)
            if tonumber(v.maxPlayers)>tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~=0 then
                        if ID==tostring(Existing) then
                            Possible=false
                        end
                    else
                        if tonumber(actualHour) ~=tonumber(Existing) then
                            local delFile = pcall(function()
                                AllIDs={}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num=num+1
                end
                if Possible==true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait()
                end
            end
        end
    end
    function Teleport() 
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~="" then
                    TPReturner()
                end
            end)
        end
    end
    Teleport()
end      
local Mastery = Tabs.Misc:AddSection("Team")
Tabs.Misc:AddButton({
    Title="Pirate",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Pirates") 
    end
})
Tabs.Misc:AddButton({
    Title="Marine",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Marines") 
    end
})
local Mastery = Tabs.Misc:AddSection("RedeemCode")
local codes = {"KITT_RESET", "Sub2UncleKizaru", "SUB2GAMERROBOT_RESET1", "Sub2Fer999", "Enyu_is_Pro", "JCWK", "StarcodeHEO", "MagicBus", "KittGaming", "Sub2CaptainMaui", "Sub2OfficalNoobie", "TheGreatAce", "Sub2NoobMaster123", "Sub2Daigrock", "Axiore", "StrawHatMaine", "TantaiGaming", "Bluxxy", "SUB2GAMERROBOT_EXP1", "Chandler", "NOMOREHACK", "BANEXPLOIT", "WildDares", "BossBuild", "GetPranked", "EARN_FRUITS", "FIGHT4FRUIT", "NOEXPLOITER", "NOOB2ADMIN", "CODESLIDE", "ADMINHACKED", "ADMINDARES", "fruitconcepts", "krazydares", "TRIPLEABUSE", "SEATROLLING", "24NOADMIN", "REWARDFUN", "NEWTROLL", "fudd10_v2", "Fudd10", "Bignews", "SECRET_ADMIN"}
Tabs.Misc:AddButton({
    Title="Redeem All",
    Description="",
    Callback=function()
        for _, code in ipairs(codes) do
            RedeemCode(code)  
        end
    end
})
function RedeemCode(Code)
    game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(Code)
end
local Mastery = Tabs.Misc:AddSection("Title")
Tabs.Misc:AddButton({
    Title="Titles",
    Description="",
    Callback=function()
        local args = {
            [1]="getTitles"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        game.Players.localPlayer.PlayerGui.Main.Titles.Visible=true
    end
})
local Mastery = Tabs.Misc:AddSection("Awakening")  
Tabs.Misc:AddButton({
    Title="Open Awakening",
    Description="",
    Callback=function()
        game:GetService("Players").LocalPlayer.PlayerGui.Main.AwakeningToggler.Visible=true
    end
})
local Mastery = Tabs.Misc:AddSection("Misc")
local ToggleRejoin = Tabs.Misc:AddToggle("ToggleRejoin", {Title="Rejoin Server", Description="",Default=true })
ToggleRejoin:OnChanged(function(Value)
    _G.AutoRejoin=Value
end)
Options.ToggleRejoin:SetValue(true)
spawn(function()
    while wait() do
        if _G.AutoRejoin then
                getgenv().rejoin=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                    if child.Name=='ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
                        game:GetService("TeleportService"):Teleport(game.PlaceId)
                    end
                 end)
            end
        end
    end)
local Mastery = Tabs.Misc:AddSection("No Fog")
local function NoFog()
    local lighting = game:GetService("Lighting")
    if lighting:FindFirstChild("BaseAtmosphere") then
        lighting.BaseAtmosphere:Destroy()
    end
    if lighting:FindFirstChild("SeaTerrorCC") then
        lighting.SeaTerrorCC:Destroy()
    end
    if lighting:FindFirstChild("LightingLayers") then
        if lighting.LightingLayers:FindFirstChild("Atmosphere") then
            lighting.LightingLayers.Atmosphere:Destroy()
        end
        wait()
        if lighting.LightingLayers:FindFirstChild("DarkFog") then
            lighting.LightingLayers.DarkFog:Destroy()
        end
    end
    lighting.FogEnd=100000
end
Tabs.Misc:AddButton({
    Title="Delete Fog",
    Description="",
    Callback=function()
        NoFog()
    end
})
local ToggleAntiBand = Tabs.Misc:AddToggle("ToggleAntiBand", {
    Title="Anti Band",
    Description="",
    Default=true
})
ToggleAntiBand:OnChanged(function(Value)
    _G.AntiBand=Value
end)
local dangerousIDs = {17884881, 120173604, 912348}
spawn(function()
    while wait() do
        if _G.AntiBand then
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if table.find(dangerousIDs, player.UserId) then
                    Hop()
                end
            end
        end
    end
end)
local Mastery = Tabs.Sea:AddSection("Leviathan")
Tabs.Sea:AddButton({
    Title="Buy Chip Leviathan",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InfoLeviathan", "2")
    end
})
local ToggleTPFrozenDimension = Tabs.Sea:AddToggle("ToggleTPFrozenDimension", {
    Title="Teleport Leviathan Island", 
    Description="", 
    Default=false 
})
ToggleTPFrozenDimension:OnChanged(function(Value)
    _G.TweenToFrozenDimension=Value
end)
ToggleTPFrozenDimension:SetValue(false)
spawn(function()
    local island
    while not island do
        island=game:GetService("Workspace").Map:FindFirstChild("FrozenDimension")
        wait()
    end
    while wait() do
        if _G.TweenToFrozenDimension then
            if island then
                Tween(island.CFrame)  
            end
        end
    end
end)
if Sea3 then
    local BribeLeviathan = Tabs.Sea:AddParagraph({
        Title="Status Chip Leviathan",
        Content=""
    })
    spawn(function()
        pcall(function()
            while wait() do
                local bribeStatus = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InfoLeviathan", "1")
                if bribeStatus==5 then
                    BribeLeviathan:SetDesc("Leviathan Is Out There")
                elseif bribeStatus==0 then
                    BribeLeviathan:SetDesc("I Don't Know")
                else
                    BribeLeviathan:SetDesc("Buy: " .. tostring(bribeStatus))
                end
            end
        end)
    end)
end
local Blaze = Tabs.Main1:AddSection("Draco")
local ToggleBlazeEmber = Tabs.Sea:AddToggle("ToggleBlazeEmber", {
    Title="Collect Blaze Ember", 
    Description="", 
    Default=false
})
ToggleBlazeEmber:OnChanged(function(Value)
    _G.AutoBlazeEmber=Value
end)
spawn(function()
    while wait() do
        if _G.AutoBlazeEmber then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/DragonDojoEmber"):FireServer()
            end)
        end
    end
end)
local ToggleBlazeEmberFarm = Tabs.Main1:AddToggle("ToggleBlazeEmberFarm", {
    Title = "Auto Blaze Ember", 
    Description = "", 
    Default = false
})
ToggleBlazeEmberFarm:OnChanged(function(Value)
    _G.AutoBlazeEmberFarm = Value
end)
spawn(function()
    while task.wait() do
        if _G.AutoBlazeEmberFarm then  
            pcall(function()
                local enemies = game:GetService('Workspace').Enemies
                if enemies:FindFirstChild('Hydra Enforcer') or enemies:FindFirstChild('Venomous Assailant') then
                    for _, v in pairs(enemies:GetChildren()) do
                        if v.Name == 'Hydra Enforcer' or v.Name == 'Venomous Assailant' then
                            if v:FindFirstChild('Humanoid') and v:FindFirstChild('HumanoidRootPart') and v.Humanoid.Health > 0 then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    bringmob = true
                                    EquipTool(SelectWeapon)
                                    Tween2(v.HumanoidRootPart.CFrame * Pos)
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v.HumanoidRootPart.Transparency = 1
                                    v.Humanoid.JumpPower = 0
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.CanCollide = false
                                    FarmPos = v.HumanoidRootPart.CFrame
                                    MonFarm = v.Name
                                until not _G.AutoBlazeEmberFarm or v.Humanoid.Health <= 0
                            end
                        end
                    end
                else
                    Tween2(CFrame.new(4612.078125, 1002.283447265625, 498.2188720703125))
                end
            end)
        end
    end
end)
local ToggleReceiveQuest = Tabs.Main1:AddToggle("ToggleReceiveQuest", {
    Title="Receive Quest", 
    Description="On/Off To 1-2", 
    Default=false
})
ToggleReceiveQuest:OnChanged(function(Value)
    _G.AutoReceiveQuest=Value
    if _G.AutoReceiveQuest then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438,-334.9649963378906))
        Tween2(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
        spawn(function()
            pcall(function()
                while wait() do
                    local args = {
                        [1]={
                            ["Context"]="RequestQuest"
                        }
                    }
                    game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/DragonHunter"):InvokeServer(unpack(args))
                    local checkArgs = {
                        [1]={
                            ["Context"]="Check"
                        }
                    }
                    local response = game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/DragonHunter"):InvokeServer(unpack(checkArgs))
                end
            end)
        end)
    end
end)
local BlazeEmberQuestStatus = Tabs.Main1:AddParagraph({
    Title="Status Blaze Ember",
    Content=""
})
spawn(function()
    pcall(function()
        while wait() do
            local args = {
                [1]={
                    ["Context"]="Check"
                }
            }
            local response = game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/DragonHunter"):InvokeServer(unpack(args))
            if typeof(response)=="table" then
                for key, value in pairs(response) do
                    if value=="Defeat 3 Venomous Assailants on Hydra Island." then
                        BlazeEmberQuestStatus:SetDesc("Defeat 3 Venomous Assailants on Hydra Island.")
                    elseif value=="Defeat 3 Hydra Enforcers on Hydra Island." then
                        BlazeEmberQuestStatus:SetDesc("Defeat 3 Hydra Enforcers on Hydra Island.")
                    elseif value=="Destroy 10 trees on Hydra Island." then
                        BlazeEmberQuestStatus:SetDesc("Destroy 10 trees on Hydra Island.")
                    end
                end
            end
        end
    end)
end)
local ToggleHydraTree = Tabs.Main1:AddToggle("ToggleHydraTree", { 
    Title = "Auto Hydra Tree", 
    Description = "", 
    Default = false 
})
ToggleHydraTree:OnChanged(function(Value)
    _G.AutoHydraTree = Value
end)
local function sendSkillKey(skillKey)
    local virtualInputManager = game:GetService("VirtualInputManager")
    virtualInputManager:SendKeyEvent(true, skillKey, false, game)
    virtualInputManager:SendKeyEvent(false, skillKey, false, game)
end
local function equipAndUseSkill(toolType)
    local player = game.Players.LocalPlayer
    local backpack = player.Backpack
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == toolType then
            item.Parent = player.Character  
            for _, skill in ipairs({"Z", "X", "C", "V", "F"}) do
                wait() 
                pcall(function() sendSkillKey(skill) end) 
            end
            item.Parent = backpack
            break
        end
    end
end
local targets = {
    CFrame.new(5288.61962890625, 1005.4000244140625, 392.43011474609375),
    CFrame.new(5343.39453125, 1004.1998901367188, 361.0687561035156),
    CFrame.new(5235.78564453125, 1004.1998901367188, 431.4530944824219),
    CFrame.new(5321.30615234375, 1004.1998901367188, 440.8951416015625),
    CFrame.new(5258.96484375, 1004.1998901367188, 345.5052490234375),
}
spawn(function()
    while wait() do
        if _G.AutoHydraTree then
            AutoHaki()  
            for _, target in ipairs(targets) do
                if not _G.AutoHydraTree then break end 
                Tween2(target) 
                wait()
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local distance = (character.HumanoidRootPart.Position - target.Position).Magnitude
                    if distance <= 1 then
                        equipAndUseSkill("Melee")
                        equipAndUseSkill("Sword")
                        equipAndUseSkill("Gun")
                    end
                end
            end
        end
    end
end)
Tabs.Main1:AddButton({
    Title="Telepor Dragon Dojo",
    Description="",
    Callback=function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438,-334.9649963378906))
        Tween2(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
    end
})
Tabs.Main1:AddButton({
    Title="Craft Volcanic Magnet",
    Description="Need 15 Blaze Ember + 10 Iron",
    Callback=function()
        local args = {
            [1]="CraftItem",
            [2]="Craft",
            [3]="Volcanic Magnet"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.Main1:AddButton({
    Title = "Craft Dino Hood",
    Description = "Need 25 Dinosaur Bones + 10 Mini Tusk",
    Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "DinoHood"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.Main1:AddButton({
    Title = "Craft T-Rex Skull",
    Description = "Need 8 Dinosaur Bones + 5 Dragon Scale",
    Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "TRexSkull"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
local ToggleCollectFireFlowers = Tabs.Main1:AddToggle("ToggleCollectFireFlowers", {
    Title="Collect Blaze Ember", 
    Description="", 
    Default=false
})
ToggleCollectFireFlowers:OnChanged(function(Value)
    _G.AutoCollectFireFlowers = Value
end)
spawn(function()
    while wait() do
        if _G.AutoCollectFireFlowers then
            local fireFlowersFolder = workspace:FindFirstChild("FireFlowers")
            if fireFlowersFolder then
                for _, obj in pairs(fireFlowersFolder:GetChildren()) do
                    if obj:IsA("Model") and obj.PrimaryPart then
                        local flowerPos = obj.PrimaryPart.Position
                        local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                        local distance = (flowerPos - playerPos).Magnitude
                        if distance <= 1 then
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                            wait(1.5)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
                        else
                            Tween2(CFrame.new(flowerPos))
                        end
                    end
                end
            end
        end
    end
end)
local ToggleWhiteBelt = Tabs.Main1:AddToggle("ToggleWhiteBelt", {
    Title="Auto White Belt",
    Description="",
    Default=false
})
ToggleWhiteBelt:OnChanged(function(Value)
    _G.AutoLevel=Value
    if Value then
        local args = {
            [1]={
                ["NPC"]="Dojo Trainer",
                ["Command"]="RequestQuest"
            }
        }
        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
        spawn(function()
            while _G.AutoLevel do
                local claimArgs = {
                    [1]={
                        ["NPC"]="Dojo Trainer",
                        ["Command"]="ClaimQuest"
                    }
                }
                game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(claimArgs))
                wait()  
            end
        end)
    end
end)
local DracoV4 = Tabs.Sea:AddParagraph({
    Title="Auto Trial Draco",
    Content="Comning Soon"
})
local ToggleTrialTeleport = Tabs.Sea:AddToggle("ToggleTrialTeleport", {
    Title="Teleport Trial Race Draco", 
    Description="", 
    Default=false
})
ToggleTrialTeleport:OnChanged(function(Value)
    _G.AutoTrialTeleport = Value
end)
spawn(function()
    while wait() do
        if _G.AutoTrialTeleport then
            local trialTeleport = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")
            if trialTeleport and trialTeleport:IsA("Part") then
                Tween2(CFrame.new(trialTeleport.Position))
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - trialTeleport.Position).Magnitude
                if distance <= 1 then
                    _G.AutoTrialTeleport = false
                end
            end
        end
    end
end)
local Volcano = Tabs.Sea:AddSection("Volcano Island")
local Prehistoric = Tabs.Sea:AddParagraph({
    Title="Status Volcano",
    Content=""
})
spawn(function()
    pcall(function()
        while wait() do
            if game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
                Prehistoric:SetDesc("Volcano Island: âœ…ï¸")
            else
                Prehistoric:SetDesc("Volcano Island: âŒï¸")
            end
        end
    end)
end)
local ToggleTPVolcano = Tabs.Sea:AddToggle("ToggleTPVolcano", { 
    Title="Teleport Volcano Island", 
    Description="", 
    Default=false 
})
ToggleTPVolcano:OnChanged(function(Value)
    _G.TweenToPrehistoric=Value
end)
Options.ToggleTPVolcano:SetValue(false)
spawn(function()
    local island
    while not island do
        island=game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")
        wait()
    end
    while wait() do
        if _G.TweenToPrehistoric then
            local prehistoricIslandCore = game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")
            if prehistoricIslandCore then
                local relic = prehistoricIslandCore:FindFirstChild("Core") and prehistoricIslandCore.Core:FindFirstChild("PrehistoricRelic")
                local skull = relic and relic:FindFirstChild("Skull")
                if skull then
                    Tween2(CFrame.new(skull.Position))
                    _G.TweenToPrehistoric=false
                end
            end
        end
    end
end)
local ToggleDefendVolcano = Tabs.Sea:AddToggle("ToggleDefendVolcano", {
    Title = "Auto Event", 
    Description = "", 
    Default = false
})
ToggleDefendVolcano:OnChanged(function(Value)
    _G.AutoDefendVolcano = Value
end)
local ToggleMelee = Tabs.Sea:AddToggle("ToggleMelee", {
    Title = "Use Melee", 
    Description = "", 
    Default = false
})
ToggleMelee:OnChanged(function(Value)
    _G.UseMelee = Value
end)
local ToggleSword = Tabs.Sea:AddToggle("ToggleSword", {
    Title = "Use Sword", 
    Description = "", 
    Default = false
})
ToggleSword:OnChanged(function(Value)
    _G.UseSword = Value
end)
local ToggleGun = Tabs.Sea:AddToggle("ToggleGun", {
    Title = "Use Gun", 
    Description = "", 
    Default = false
})
ToggleGun:OnChanged(function(Value)
    _G.UseGun = Value
end)
local function useSkill(skillKey)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, skillKey, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, skillKey, false, game)
end
local function removeLava()
    local interiorLavaModel = game.Workspace.Map.PrehistoricIsland.Core:FindFirstChild("InteriorLava")
    if interiorLavaModel and interiorLavaModel:IsA("Model") then
        interiorLavaModel:Destroy()
    end
    local prehistoricIsland1 = game.Workspace.Map:FindFirstChild("PrehistoricIsland")
    if prehistoricIsland1 then
        for _, descendant in pairs(prehistoricIsland1:GetDescendants()) do
            if descendant:IsA("Part") and descendant.Name:lower():find("lava") then
                descendant:Destroy()
            end
        end
    end
    local prehistoricIsland2 = game.Workspace.Map:FindFirstChild("PrehistoricIsland")
    if prehistoricIsland2 then
        for _, model in pairs(prehistoricIsland2:GetDescendants()) do
            if model:IsA("Model") then
                for _, child in pairs(model:GetDescendants()) do
                    if child:IsA("MeshPart") and child.Name:lower():find("lava") then
                        child:Destroy()
                    end
                end
            end
        end
    end
end
local function findValidRock()
    local volcanoRocksFolder = game.Workspace.Map.PrehistoricIsland.Core.VolcanoRocks
    for _, Rock in pairs(volcanoRocksFolder:GetChildren()) do
        if Rock:IsA("Model") then
            local volcanorock = Rock:FindFirstChild("volcanorock")
            if volcanorock and volcanorock:IsA("MeshPart") then
                local color = volcanorock.Color
                if color == Color3.fromRGB(185, 53, 56) or color == Color3.fromRGB(185, 53, 57) then
                    return volcanorock
                end
            end
        end
    end
    return nil 
end
local function equipAndUseSkill(toolType)
    local player = game.Players.LocalPlayer
    local backpack = player.Backpack
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == toolType then
            item.Parent = player.Character 
            for _, skill in ipairs({"Z", "X", "C", "V", "F"}) do
                wait() 
                pcall(function() useSkill(skill) end) 
            end
            item.Parent = backpack
            break
        end
    end
end
spawn(function()
    while wait() do
        if _G.AutoDefendVolcano then
            AutoHaki() 
            pcall(removeLava) 
            local currentTarget = findValidRock() 
            if currentTarget then
                local targetPosition = CFrame.new(currentTarget.Position + Vector3.new(0, 0, 0))
                Tween2(targetPosition) 
                local color = currentTarget.Color
                if color ~= Color3.fromRGB(185, 53, 56) and color ~= Color3.fromRGB(185, 53, 57) then
                    currentTarget = findValidRock() 
                else
                    local currentPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                    local distance = (currentPosition - currentTarget.Position - Vector3.new(0, 0, 0)).Magnitude
                    if distance <= 1 then
                        if _G.UseMelee then
                            equipAndUseSkill("Melee")
                        end
                        if _G.UseSword then
                            equipAndUseSkill("Sword")
                        end
                        if _G.UseGun then
                            equipAndUseSkill("Gun")
                        end
                    end
                    _G.TweenToPrehistoric = false
                end
            else
                _G.TweenToPrehistoric = true
            end
        end
    end
end)
local ToggleKillAura = Tabs.Sea:AddToggle("ToggleKillAura", {Title="Auto Kill Golems",Description="", Default=false })
ToggleKillAura:OnChanged(function(Value)
    KillAura=Value
end)
Options.ToggleKillAura:SetValue(false)
spawn(function()
    while wait() do
        if KillAura then
            pcall(function()
                for i,v in pairs(game.Workspace.Enemies:GetDescendants()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                        repeat task.wait()
                            sethiddenproperty(game:GetService('Players').LocalPlayer,"SimulationRadius",math.huge)
                            v.Humanoid.Health=0
                            v.HumanoidRootPart.CanCollide=false
                        until not KillAura or not v.Parent or v.Humanoid.Health<=0
                    end
                end
            end)
        end
    end
end)
local ToggleCollectBone = Tabs.Sea:AddToggle("ToggleCollectBone", {
    Title="Collect Bone", 
    Description="", 
    Default=false
})
ToggleCollectBone:OnChanged(function(Value)
    _G.AutoCollectBone=Value
end)
spawn(function()
    while wait() do
        if _G.AutoCollectBone then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name=="DinoBone" then
                    Tween2(CFrame.new(obj.Position))
                end
            end
        end
    end
end)
local ToggleCollectEgg = Tabs.Sea:AddToggle("ToggleCollectEgg", {
    Title = "Collect Egg",
    Description = "",
    Default = false
})
ToggleCollectEgg:OnChanged(function(Value)
    _G.AutoCollectEgg = Value
end)
spawn(function()
    while wait() do
        if _G.AutoCollectEgg then
            local dragonEggs = workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:GetChildren()
            if #dragonEggs > 0 then
                local randomEgg = dragonEggs[math.random(1, #dragonEggs)]
                if randomEgg:IsA("Model") and randomEgg.PrimaryPart then
                    Tween2(randomEgg.PrimaryPart.CFrame)
                    local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                    local eggPosition = randomEgg.PrimaryPart.Position
                    local distance = (playerPosition - eggPosition).Magnitude
                    if distance <= 1 then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                        wait(1.5)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
                    end
                end
            end
        end
    end
end)
local targetPlayers = {
    ["red_game43"] = true,
    ["rip_indra"] = true,
    ["Axiore"] = true,
    ["Polkster"] = true,
    ["wenlocktoad"] = true,
    ["Daigrock"] = true,
    ["toilamvidamme"] = true,
    ["oofficialnoobie"] = true,
    ["Uzoth"] = true,
    ["Azarth"] = true,
    ["arlthmetic"] = true,
    ["Death_King"] = true,
    ["Lunoven"] = true,
    ["TheGreateAced"] = true,
    ["rip_fud"] = true,
    ["drip_mama"] = true,
    ["layandikit12"] = true,
    ["Hingoi"] = true
}
spawn(function()
    while true do
        wait(1)
        for _, v in pairs(game.Players:GetPlayers()) do
            if targetPlayers[v.Name] then
                Hop()
                break
            end
        end
    end
end)
local lastNotificationTime = 0
local notificationCooldown = 10
local currentTime = tick()
if currentTime - lastNotificationTime >= notificationCooldown then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Lunar",
        Text = "Successfully",
        Duration = 1
    })
    lastNotificationTime = currentTime
end
