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

TrumpSpriteInfo.hitIndex = 
{
    {
        {y=-47,x=-1.3333333333333,purpose="vulnerability",type="circle",radius=27},
        {y=-12.333333333333,x=-16,purpose="vulnerability",type="circle",radius=30},
        {y=-18.666666666667,x=26,purpose="vulnerability",type="circle",radius=21},
        {y=41,x=-17,purpose="vulnerability",type="circle",radius=31},
        {y=66,x=12,purpose="vulnerability",type="circle",radius=12},
    },
    {
        {y=-50,x=-1.6666666666667,purpose="vulnerability",type="circle",radius=27},
        {y=-11,x=-13.666666666667,purpose="vulnerability",type="circle",radius=33},
        {y=-21,x=24.333333333333,purpose="vulnerability",type="circle",radius=21},
        {y=43.333333333333,x=-15.666666666667,purpose="vulnerability",type="circle",radius=30},
        {y=65.666666666667,x=12,purpose="vulnerability",type="circle",radius=12},
    },
    {
        {y=-34,x=74.333333333333,purpose="attack",type="circle",radius=10},
        {y=-32.333333333333,x=57.666666666667,purpose="attack",type="circle",radius=10},
        {y=-29.333333333333,x=42,purpose="attack",type="circle",radius=10},
        {y=-28.666666666667,x=25.333333333333,purpose="attack",type="circle",radius=10},
        {y=-50.666666666667,x=1,purpose="vulnerability",type="circle",radius=27},
        {y=-11.666666666667,x=-14,purpose="vulnerability",type="circle",radius=30},
        {y=41,x=-15,purpose="vulnerability",type="circle",radius=30},
        {y=64.666666666667,x=13.333333333333,purpose="vulnerability",type="circle",radius=12},
    }
}

function TrumpSpriteInfo:getSheet()
    return self.sheet;
end

function TrumpSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return TrumpSpriteInfo