local buttigiegSpriteInfo = {}

buttigiegSpriteInfo.sheet =
{
    frames = {
    
        {
            -- buttigieg_placeholder_1
            x=0,
            y=0,
            width=256,
            height=256,

        },
        {
            -- buttigieg_punch_placeholder_1
            x=256,
            y=0,
            width=256,
            height=256,

        },
    },

    sheetContentWidth = 512,
    sheetContentHeight = 256
}

buttigiegSpriteInfo.frameIndex =
{
    ["normal"] = 1,
    ["punch"] = 2,
    ["damage"] = 1,
}

function buttigiegSpriteInfo:getSheet()
    return self.sheet;
end

function buttigiegSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return buttigiegSpriteInfo