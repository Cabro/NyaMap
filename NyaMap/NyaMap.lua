--------------------------------------------------------------
--texture:SetTexCoord(TLX, TLY, BLX, BLY, TRX, TRY, BRX, BRY);
-- Legend: T = Top, B = Bottom, L = Left, R = Right, X, Y
-- 
-- Both rings should turn at the same speed, lua 5.0 uses  
-- radians in their sin/cos/tan equations instead of the 
-- degrees used in 4.0. Thus if you're not comfortable with  
-- radians, I will suggest using math.deg and math.rad for 
-- translating between them.
--------------------------------------------------------------
Nya_Debugmode = false;
local TimeElapsed = 0;
local RotationTime = 90;
local Outer = {};
local Inner = {};
local math = math;
local sin = math.sin;
local cos = math.cos;
local tan = math.tan;
local pi = math.pi;
local pi2 = pi * 2;

local function print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, 0.2, 1, 0.2);
end

function Nya_OnEvent()
	if event == "ADDON_LOADED" then
		if arg1 == "NyaMap" then
			Nya_OnLoad()
			this:UnregisterEvent("ADDON_LOADED");
		end
	end
end

function Nya_OnLoad()
	if Nya_Debugmode then
		print("lua loaded");
	end
	this:SetScript("OnUpdate", Nya_OnUpdate);
	Nya_HideAnnoyingStuff();
	Nya_CreateFrames();
end

function Nya_OnUpdate()
	TimeElapsed = TimeElapsed + arg1;
	if TimeElapsed > RotationTime then
		TimeElapsed = TimeElapsed - RotationTime;
	end
	Nya_RotateTextures(TimeElapsed)
end

function Nya_RotateTextures(elapsed)
	Outer.TLX, Outer.TLY, Outer.BLX, Outer.BLY, Outer.TRX, Outer.TRY, Outer.BRX, Outer.BRY = Nya_GetCoordMatrix(elapsed, 1);
	Inner.TLX, Inner.TLY, Inner.BLX, Inner.BLY, Inner.TRX, Inner.TRY, Inner.BRX, Inner.BRY = Nya_GetCoordMatrix(elapsed, -1);
	
	Nya_AuraRune_ABorder_Texture:SetTexCoord(Outer.TLX, Outer.TLY, Outer.BLX, Outer.BLY, Outer.TRX, Outer.TRY, Outer.BRX, Outer.BRY);
	Nya_AURARUNE256Border_Texture:SetTexCoord(Inner.TLX, Inner.TLY, Inner.BLX, Inner.BLY, Inner.TRX, Inner.TRY, Inner.BRX, Inner.BRY);
	
	if Nya_Debugmode then
		--print("Outer coords:\n TLX: "..Outer.TLX.."\n TLY: "..Outer.TLY.."\n BLX: "..Outer.BLX.."\n BLY: "..Outer.BLY.."\n TRX: "..Outer.TRX.."\n TRY: "..Outer.TRY.."\n BRX: "..Outer.BRX.."\n BRY: "..Outer.BRY);
		print("Inner coords: "..Inner.TLX..", "..Inner.TLY..", "..Inner.BLX..", "..Inner.BLY..", "..Inner.TRX..", "..Inner.TRY..", "..Inner.BRX..", "..Inner.BRY);
	end
end

function Nya_GetCoordMatrix(elapsed, direction)
	local angle = pi2 * elapsed / RotationTime * direction;
	TLX, TLY, BLX, BLY, TRX, TRY, BRX, BRY = 0.5-sin(angle), 0.5+cos(angle), 0.5+cos(angle), 0.5+sin(angle), 0.5-cos(angle), 0.5-sin(angle), 0.5+sin(angle), 0.5-cos(angle);
	
	return TLX, TLY, BLX, BLY, TRX, TRY, BRX, BRY;
end

function Nya_HideAnnoyingStuff()
	MinimapBorder:Hide();
	MinimapBorderTop:Hide();
	MinimapToggleButton:Hide();
	--GameTimeFrame:Hide();
	MinimapZoneText:Hide();
	MinimapZoomIn:Hide();
	MinimapZoomOut:Hide();
end

function Nya_CreateFrames()
	Nya_CreateFrame("AuraRune_A", 350);
	Nya_CreateFrame("AURARUNE256", 255);
	if Nya_Debugmode then
		print("Borders created");
	end
end

function Nya_CreateFrame(name, size)
	if getglobal("Nya_"..name.."Border") then
		if Nya_Debugmode then
			print("Nya_"..name.."Border already exists");
		end
		return;
	end
	Minimap:CreateTexture("Nya_"..name.."Border_Texture", "ARTWORK");
	local texture = getglobal("Nya_"..name.."Border_Texture");
	texture:SetBlendMode("ADD");
	texture:SetTexture("Spells\\"..name);
	texture:SetWidth(size)
	texture:SetHeight(size)
	texture:SetVertexColor(0, 0, 1);
	texture:SetPoint("CENTER", Minimap, "CENTER");
	if Nya_Debugmode then
		print("Nya_"..name.."Border created");
	end
end

CreateFrame("Frame", "Nya_Main");
Nya_Main:SetScript("OnEvent", Nya_OnEvent);
Nya_Main:RegisterEvent("ADDON_LOADED");
