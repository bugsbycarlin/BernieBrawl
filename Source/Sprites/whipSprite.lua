local whipSpriteInfo = {}

whipSpriteInfo.sheet =
{
    frames = {
    
        {
            x=0,
            y=0,
            width=1024,
            height=256,

        },
        {
            x=0,
            y=256,
            width=1024,
            height=256,

        },
        {
            x=0,
            y=512,
            width=1024,
            height=256,

        },
        {
            x=0,
            y=768,
            width=1024,
            height=256,

        },
        {
            x=0,
            y=1024,
            width=1024,
            height=256,

        },
    },

    sheetContentWidth = 1024,
    sheetContentHeight = 1280
}

whipSpriteInfo.frameIndex =
{
}

function whipSpriteInfo:getSheet()
    return self.sheet;
end

function whipSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return whipSpriteInfo