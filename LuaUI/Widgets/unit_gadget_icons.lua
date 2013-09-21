-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Gadget Icons",
    desc      = "Shows icons from gadgets that cannot access the widget stuff by themselves.",
    author    = "CarRepairer and GoogleFrog",
    date      = "2012-01-28",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = true,
  }
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local echo = Spring.Echo


local min   = math.min
local floor = math.floor

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


local myAllyTeamID = 666

local powerTexture = 'Luaui/Images/visible_energy.png'
local facplopTexture = 'Luaui/Images/factory.png'
local rearmTexture = 'LuaUI/Images/noammo.png'

local lastLowPower = {}
local lastFacPlop = {}
local lastRearm = {}

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function SetIcons(unitID)
	for _,unitID in ipairs(Spring.GetAllUnits()) do
		local lowpower = Spring.GetUnitRulesParam(unitID, "lowpower") 
		if lowpower then
			if (not lastLowPower[unitID]) or lastLowPower[unitID] ~= lowpower then
				lastLowPower[unitID] = lowpower
				if lowpower ~= 0 then
					WG.icons.SetUnitIcon( unitID, {name='lowpower', texture=powerTexture} )
				else
					WG.icons.SetUnitIcon( unitID, {name='lowpower', texture=nil} )
				end
			end
		end
		
		local facplop = Spring.GetUnitRulesParam(unitID, "facplop") 
		if facplop or lastFacPlop[unitID] == 1 then
			if not facplop then
				facplop = 0
			end
			if (not lastFacPlop[unitID]) or lastFacPlop[unitID] ~= facplop then
				lastFacPlop[unitID] = facplop
				if facplop ~= 0 then
					WG.icons.SetUnitIcon( unitID, {name='facplop', texture=facplopTexture} )
					WG.icons.SetPulse( 'facplop', true )
				else
					WG.icons.SetUnitIcon( unitID, {name='facplop', texture=nil} )
				end
			end
		end
		
		local rearm = Spring.GetUnitRulesParam(unitID, "noammo") 
		if rearm then
			if (not lastRearm[unitID]) or lastRearm[unitID] ~= rearm then
				lastRearm[unitID] = rearm
				if rearm ~= 0 then
					WG.icons.SetUnitIcon( unitID, {name='rearm', texture=rearmTexture} )
				else
					WG.icons.SetUnitIcon( unitID, {name='rearm', texture=nil} )
				end
			end
		end
	end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	-- There should be a better way to do this, lazy fix.
	WG.icons.SetUnitIcon( unitID, {name='lowpower', texture=nil} )
	WG.icons.SetUnitIcon( unitID, {name='facplop', texture=nil} )
	WG.icons.SetUnitIcon( unitID, {name='rearm', texture=nil} )
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------


function widget:GameFrame(f)
	if f%8 == 0 then
		SetIcons()
	end
end


function widget:Initialize()
	WG.icons.SetOrder( 'lowpower', 2 )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
