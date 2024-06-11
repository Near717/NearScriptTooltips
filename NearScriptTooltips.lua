local addon = {
	name = "NearScriptTooltips",
}
-------------------------------------------------------------------------------------------------------------------------

local total_craftedAbilityIds = 11

-- table adapted from ScriptTracker, thanks to akamatsu02!
local craftedAbilityScripts = {
	[SPECIALIZED_ITEMTYPE_CRAFTED_ABILITY_SCRIPT_PRIMARY] = { -- focus
		[1] = { bound = 207999, unbound = 204549 },
		[2] = { bound = 208000, unbound = 204550 },
		[3] = { bound = 208001, unbound = 204551 },
		[4] = { bound = 208002, unbound = 204552 },
		[5] = { bound = 208003, unbound = 204553 },
		[6] = { bound = 208004, unbound = 204554 },
		[7] = { bound = 208005, unbound = 204555 },
		[8] = { bound = 208006, unbound = 204556 },
		[9] = { bound = 208007, unbound = 204557 },
		[10] = { bound = 208008, unbound = 204558 },
		[12] = { bound = 208010, unbound = 204560 },
		[13] = { bound = 208011, unbound = 204561 },
		[14] = { bound = 208012, unbound = 204562 },
		[15] = { bound = 208013, unbound = 204563 },
		[16] = { bound = 208014, unbound = 204564 },
		[17] = { bound = 208015, unbound = 204565 },
		[18] = { bound = 208016, unbound = 204566 },
		[19] = { bound = 208017, unbound = 204567 },
		[20] = { bound = 208018, unbound = 204568 },
		[22] = { bound = 208019, unbound = 204570 },
		[23] = { bound = 208020, unbound = 204571 },
	},
	[SPECIALIZED_ITEMTYPE_CRAFTED_ABILITY_SCRIPT_SECONDARY] = { -- signature
		[24] = { bound = 208021, unbound = 204572 },
		[25] = { bound = 208022, unbound = 204573 },
		[26] = { bound = 208023, unbound = 204574 },
		[27] = { bound = 208024, unbound = 204575 },
		[28] = { bound = 208025, unbound = 204576 },
		[29] = { bound = 208026, unbound = 204577 },
		[30] = { bound = 208027, unbound = 204578 },
		[31] = { bound = 208028, unbound = 204579 },
		[32] = { bound = 208029, unbound = 204580 },
		[33] = { bound = 208030, unbound = 204581 },
		[34] = { bound = 208031, unbound = 204582 },
		[35] = { bound = 208032, unbound = 204583 },
		[36] = { bound = 208033, unbound = 204584 },
		[37] = { bound = 208034, unbound = 204585 },
		[38] = { bound = 208035, unbound = 204586 },
		[39] = { bound = 208036, unbound = 204587 },
		[40] = { bound = 208037, unbound = 204588 },
		[41] = { bound = 208038, unbound = 204589 },
		[42] = { bound = 208039, unbound = 204590 },
		[70] = { bound = 208041, unbound = 207949 },
	},
	[SPECIALIZED_ITEMTYPE_CRAFTED_ABILITY_SCRIPT_TERTIARY] = { -- affix
		[44] = { bound = 208042, unbound = 204592 },
		[45] = { bound = 208043, unbound = 204593 },
		[46] = { bound = 208044, unbound = 204594 },
		[47] = { bound = 208045, unbound = 204595 },
		[48] = { bound = 208046, unbound = 204596 },
		[49] = { bound = 208047, unbound = 204597 },
		[50] = { bound = 208048, unbound = 204598 },
		[51] = { bound = 208049, unbound = 204599 },
		[52] = { bound = 208050, unbound = 204600 },
		[53] = { bound = 208051, unbound = 204601 },
		[54] = { bound = 208052, unbound = 204602 },
		[55] = { bound = 208053, unbound = 204603 },
		[56] = { bound = 208054, unbound = 204604 },
		[57] = { bound = 208055, unbound = 204605 },
		[58] = { bound = 208056, unbound = 204606 },
		[59] = { bound = 208057, unbound = 204607 },
		[60] = { bound = 208058, unbound = 204608 },
		[61] = { bound = 208059, unbound = 204609 },
		[62] = { bound = 208060, unbound = 204610 },
		[63] = { bound = 208061, unbound = 204611 },
		[64] = { bound = 208062, unbound = 204612 },
		[65] = { bound = 208063, unbound = 204613 },
		[66] = { bound = 208064, unbound = 204614 },
		[67] = { bound = 208065, unbound = 204615 },
		[68] = { bound = 208066, unbound = 204616 },
		[69] = { bound = 208067, unbound = 204617 },
	},
}

local font = "$(BOLD_FONT)|$(KB_14)|soft-shadow-thin"
local color = ZO_ColorDef:New("c0c09c")
local r, g, b = 255, 255, 255
local lineAnchor = LABEL_LINE_ANCHOR_TOP
local modifyTextType = MODIFY_TEXT_TYPE_NONE
local textAlignment = TEXT_ALIGN_LEFT
local setToFullSize = true

local function ReturnItemLink(itemLink)
	return itemLink
end

local function TooltipHook(tooltipControl, method, linkFunc)
	local origMethod = tooltipControl[method]

	tooltipControl[method] = function(self, ...)
		local link = linkFunc(...)
		local itemType, specializedItemType = GetItemLinkItemType(link)
		origMethod(self, ...)

		if itemType == ITEMTYPE_CRAFTED_ABILITY_SCRIPT then
			local itemId = GetItemLinkItemId(link)
			ZO_Tooltip_AddDivider(tooltipControl)
			tooltipControl:AddLine("Applicable to:", font, r, g, b)

			local text = ""

			for craftedAbilityScriptId, value in pairs(craftedAbilityScripts[specializedItemType]) do
				if (itemId == value.bound or itemId == value.unbound) then
					for craftedAbilityId = 1, total_craftedAbilityIds do
						local description1 = GetCraftedAbilityScriptDescription(craftedAbilityId, craftedAbilityScriptId)
						local description2 = GetCraftedAbilityScriptGeneralDescription(craftedAbilityScriptId)

						if description1 ~= description2 then
							local craftedAbilityName = GetCraftedAbilityDisplayName(craftedAbilityId)
							craftedAbilityName = color:Colorize(craftedAbilityName)
							-- tooltipControl:AddLine(craftedAbilityName, font, r, g, b, lineAnchor, modifyTextType, textAlignment, setToFullSize)
							text = text .. craftedAbilityName .. "\n"
						end
					end
				end
			end
			tooltipControl:AddLine(text, font, r, g, b, lineAnchor, modifyTextType, textAlignment, setToFullSize)
		end
	end
end

local function Initialize()
	TooltipHook(ItemTooltip, "SetBagItem", GetItemLink)
	TooltipHook(ItemTooltip, "SetTradeItem", GetTradeItemLink)
	TooltipHook(ItemTooltip, "SetBuybackItem", GetBuybackItemLink)
	TooltipHook(ItemTooltip, "SetStoreItem", GetStoreItemLink)
	TooltipHook(ItemTooltip, "SetAttachedMailItem", GetAttachedItemLink)
	TooltipHook(ItemTooltip, "SetLootItem", GetLootItemLink)
	TooltipHook(ItemTooltip, "SetTradingHouseItem", GetTradingHouseSearchResultItemLink)
	TooltipHook(ItemTooltip, "SetTradingHouseListing", GetTradingHouseListingItemLink)
	TooltipHook(ItemTooltip, "SetLink", ReturnItemLink)
	TooltipHook(PopupTooltip, "SetLink", ReturnItemLink)
end

-------------------------------------------------------------------------------------------------------------------------
-- Addon loading
-------------------------------------------------------------------------------------------------------------------------
local function OnAddonLoaded(_, name)
	if name ~= addon.name then return end
	EVENT_MANAGER:UnregisterForEvent(addon.name, EVENT_ADD_ON_LOADED)

	Initialize()
end

EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
