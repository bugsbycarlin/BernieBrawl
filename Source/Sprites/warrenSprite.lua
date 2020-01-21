local WarrenSpriteInfo = {}

WarrenSpriteInfo.sheet =
{
    frames = {
        {
            x=0,
            y=0,
            width=256,
            height=256,

        },
        {
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            x=1024,
            y=0,
            width=256,
            height=256,

        },
        {
            x=1280,
            y=0,
            width=256,
            height=256,

        },
        {
            x=0,
            y=256,
            width=256,
            height=256,

        },
        {
            x=256,
            y=256,
            width=256,
            height=256,

        },
        {
            x=512,
            y=256,
            width=256,
            height=256,

        },
        {
            x=768,
            y=256,
            width=256,
            height=256,

        },
        {
            x=1024,
            y=256,
            width=256,
            height=256,

        },
        {
            x=1280,
            y=256,
            width=256,
            height=256,

        },
        {
            x=0,
            y=512,
            width=256,
            height=256,

        },
        {
            x=256,
            y=512,
            width=256,
            height=256,

        },
        {
            x=512,
            y=512,
            width=256,
            height=256,

        },
        {
            x=768,
            y=512,
            width=256,
            height=256,

        },
        {
            x=1024,
            y=512,
            width=256,
            height=256,

        },
        {
            x=1280,
            y=512,
            width=256,
            height=256,

        },
        {
            x=0,
            y=768,
            width=256,
            height=256,

        },
        {
            x=256,
            y=768,
            width=256,
            height=256,

        },
        {
            x=512,
            y=768,
            width=256,
            height=256,

        },
        {
            x=768,
            y=768,
            width=256,
            height=256,

        },
        {
            x=1024,
            y=768,
            width=256,
            height=256,

        },
        {
            x=1280,
            y=768,
            width=256,
            height=256,

        },
    },

    sheetContentWidth = 1536,
    sheetContentHeight = 1024
}

WarrenSpriteInfo.frameIndex =
{
    -- resting frames: 1,2,3,4,5,6
    -- kicking frames: 7,8,9,10,11,12
    -- punching frames: 13,14,15,16,17
    -- extra whip frame: 18
    -- jump frames: 19 up, 20 flip, 21 down
    -- duress frames: 22 damage, 23 ko, 24 dizzy

    ["normal"] = 1,
    ["damage"] = 22,
    -- ["damage"] = 2,
}

function WarrenSpriteInfo:getSheet()
    return self.sheet;
end

function WarrenSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return WarrenSpriteInfo