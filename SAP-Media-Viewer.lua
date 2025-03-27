local f = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
f:SetWidth(600)
f:SetHeight(500)
f:SetPoint("CENTER", UIParent, "CENTER", 0, 250)
f:SetFrameStrata("TOOLTIP")
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", function(self) self:StartMoving() end)
f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

f.scroll = CreateFrame("ScrollFrame", "myScrollFrame", f, "UIPanelScrollFrameTemplate")
f.scroll:SetPoint("TOPLEFT", f, 0, -30)
f.scroll:SetPoint("BOTTOMRIGHT", f, -26, 10)
f.scroll:EnableMouse(true)

f.content = CreateFrame("Frame", nil, f.scroll)
f.content:SetSize(f.scroll:GetWidth(), 0)
f.scroll:SetScrollChild(f.content)

f.scroll:SetScript("OnSizeChanged", function(_, width, height)
    f.content:SetWidth(width)
    f.content:SetHeight(height)
end)

local mediaImages = {
    "1.tga", "2.tga", "3.tga", "4.tga", "5.tga", "6.tga", "7.tga"
}

local totalImages = {}
for _ = 1, 20 do
    for _, image in ipairs(mediaImages) do
        table.insert(totalImages, image)
    end
end

local maxImagesPerRow = 5
local spacing = 5
local imageSize = (f.scroll:GetWidth() - (spacing * (maxImagesPerRow - 1)) - 10) / maxImagesPerRow
local lastXOffset, lastYOffset = 10, 0

for index, imageName in ipairs(totalImages) do
    local imageTexture = f.content:CreateTexture(nil, "ARTWORK")
    imageTexture:SetSize(imageSize, imageSize)
    imageTexture:SetTexture("Interface\\AddOns\\SAP-Media\\Media\\Images\\" .. imageName)
    imageTexture:SetPoint("TOPLEFT", f.content, "TOPLEFT", lastXOffset, lastYOffset)

    lastXOffset = lastXOffset + imageSize + spacing
    if index % maxImagesPerRow == 0 then
        lastXOffset = 10
        lastYOffset = lastYOffset - (imageSize + spacing)
    end
end

local numRows = math.ceil(#totalImages / maxImagesPerRow)
f.content:SetHeight(numRows * (imageSize + spacing))

local addonFrame = CreateFrame("Frame")
addonFrame:RegisterEvent("ADDON_LOADED")
addonFrame:SetScript("OnEvent", function(_, _, addonName)
    if addonName == "SAP-Media" then
        f:Hide()
    end
end)

SLASH_SAPMEDIA1 = "/sap"

local function ShowMediaWindow()
    if not f:IsShown() then
        f:Show()
    end
end

local function HideMediaWindow()
    if f:IsShown() then
        f:Hide()
    end
end

local function ResetMediaWindowPosition()
    f:ClearAllPoints()
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 250)
end

local function ShowHelp()
    print("|cFFFFA500SAP Media Commands:|r")
    print("|cFF00FF00/sap show|r - Show the SAP Media window")
    print("|cFF00FF00/sap hide|r - Hide the SAP Media window")
    print("|cFF00FF00/sap reset|r - Reset the window position to default (0, 250)")
    print("|cFF00FF00/sap help|r - Show this help message")
end

SlashCmdList["SAPMEDIA"] = function(msg)
    if msg == "show" then
        ShowMediaWindow()
    elseif msg == "hide" then
        HideMediaWindow()
    elseif msg == "reset" then
        ResetMediaWindowPosition()
    elseif msg == "help" then
        ShowHelp()
    else
        print("|cFFFF0000Unknown command. Type /sap help for a list of commands.|r")
    end
end
