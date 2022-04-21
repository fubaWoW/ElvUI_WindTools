local W, F, E, L = unpack(select(2, ...))
local TT = E:GetModule("Tooltip")
local S = W:GetModule("Skins")

local _G = _G
local format = format
local gsub = gsub
local pairs = pairs
local strfind = strfind

function S:TTSetStyle(_, tt)
    if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
        if tt.widgetContainer then
            if tt.TopOverlay then
                tt.TopOverlay:StripTextures()
            end
            if tt.BottomOverlay then
                tt.BottomOverlay:StripTextures()
            end
            if tt.NineSlice then
                self:StripEdgeTextures(tt.NineSlice)
            end
            tt:SetTemplate("Transparent")
        end
        self:CreateShadow(tt)
    end
end

function S:TTGameTooltip_SetDefaultAnchor(_, tt)
    if (tt.StatusBar) then
        self:CreateShadow(tt.StatusBar)
    end

    if _G.GameTooltipStatusBar then
        self:CreateShadow(_G.GameTooltipStatusBar, 6)
    end
end

function S:TooltipFrames()
    if not self:CheckDB("tooltip", "tooltips") then
        return
    end

    local styleTT = {
        _G.DataTextTooltip,
        _G.ElvUIConfigTooltip,
        _G.ElvUISpellBookTooltip,
        _G.EmbeddedItemTooltip,
        _G.FriendsTooltip,
        _G.GameTooltip,
        _G.ItemRefShoppingTooltip1,
        _G.ItemRefShoppingTooltip2,
        _G.ItemRefTooltip,
        _G.QuestScrollFrame.CampaignTooltip,
        _G.QuestScrollFrame.StoryTooltip,
        _G.ReputationParagonTooltip,
        _G.ShoppingTooltip1,
        _G.ShoppingTooltip2,
        _G.WarCampaignTooltip,
        _G.LibDBIconTooltip,
        _G.AceGUITooltip,
        _G.AceConfigDialogTooltip
    }

    for _, tt in pairs(styleTT) do
        if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
            self:CreateShadow(tt)
        end
    end

    self:CreateShadow(_G.FloatingBattlePetTooltip)

    self:SecureHook(TT, "SetStyle", "TTSetStyle")
    self:SecureHook(TT, "GameTooltip_SetDefaultAnchor", "TTGameTooltip_SetDefaultAnchor")
    self:SecureHook("QueueStatusFrame_Update", "CreateShadow")
    self:SecureHook(_G.GameTooltip, "Show", "StyleTooltipsIcons")
end

local function styleIconString(text)
    if not text or not strfind(text, "|T.+|t") then
        return
    end

    -- text = gsub(text, "|T([^:]+):(%d+):(%d+):(.-)|t", function(texture, width, height, oldStyle)
    --     if strfind(texture, "Addons") or texture == "0" then
    --         return format("|T%s:%d:%d:%s|t", texture, width, height, oldStyle)
    --     else
    --         return format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t", texture, width, height)
    --     end
    -- end)

    text = gsub(text, "|T([^:]+):0|t", function(texture)
        if strfind(texture, "Addons") or texture == "0" then
            return format("|T%s:0|t", texture)
        else
            return format("|T%s:0:0:0:0:64:64:5:59:5:59|t", texture)
        end
    end)

    return text
end

local function styleIconsInLine(line)
    if line then
        local styledText = styleIconString(line:GetText())
        if styledText then
            line:SetText(styledText)
        end
    end
end

function S:StyleTooltipsIcons(tt)
    for i = 2, tt:NumLines() do
        styleIconsInLine(_G[tt:GetName() .. "TextLeft" .. i])
        styleIconsInLine(_G[tt:GetName() .. "TextRight" .. i])
    end
end

S:AddCallback("TooltipFrames")
