local WhipSpriteInfo = {}

WhipSpriteInfo.sheet =
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

WhipSpriteInfo.frameIndex =
{
}

function WhipSpriteInfo:getSheet()
    return self.sheet;
end

function WhipSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return WhipSpriteInfo