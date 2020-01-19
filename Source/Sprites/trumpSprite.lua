local TrumpSpriteInfo = {}

TrumpSpriteInfo.sheet =
{
    frames = {
    
        {
            -- hair
            x=0,
            y=0,
            width=256,
            height=256,

        },
        {
            -- saiyan hair
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- punch
            x=512,
            y=0,
            width=256,
            height=256,

        },
    },

    sheetContentWidth = 768,
    sheetContentHeight = 256
}

TrumpSpriteInfo.frameIndex =
{
    ["normal"] = 1,
    ["punch"] = 3,
    ["damage"] = 2,
}

function TrumpSpriteInfo:getSheet()
    return self.sheet;
end

function TrumpSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return TrumpSpriteInfo