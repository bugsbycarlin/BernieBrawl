local trumpSpriteInfo = {}

trumpSpriteInfo.sheet =
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
            x=1536,
            y=0,
            width=256,
            height=256,

        },
        {
            x=1792,
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
    },

    sheetContentWidth = 2048,
    sheetContentHeight = 512,
}


-- 256, 512, 768, 1024, 1280, 1536, 1792, 2048, 2304, 2560, 2816, 3072, 3328, 3584, 3840, 4096, 4352, 4608, 4864
-- 384, 768, 1152, 1536, 1920, 2304, 2688, 3072, 3456, 3840, 4224, 4608, 4992, 5376, 5760, 6144, 6528, 6912, 729

-- resting frames: 1 - 12
-- damage frame: 13

trumpSpriteInfo.hitIndex = 
{
    {
      {x=-1.6666666666667,y=-75.333333333333,type="circle",purpose="vulnerability",radius=27},
      {x=-6,y=-17.666666666667,type="circle",purpose="vulnerability",radius=44},
      {x=22.333333333333,y=36.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=23.333333333333,y=72,type="circle",purpose="vulnerability",radius=24},
      {x=-28.666666666667,y=32,type="circle",purpose="vulnerability",radius=24},
      {x=-37,y=66.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=20.333333333333,y=93.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-43.666666666667,y=91.666666666667,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=-1,y=-74.666666666667,type="circle",purpose="vulnerability",radius=27},
      {x=-4,y=-15.333333333333,type="circle",purpose="vulnerability",radius=44},
      {x=24.666666666667,y=37,type="circle",purpose="vulnerability",radius=24},
      {x=27,y=69.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=26,y=95.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-27.333333333333,y=36,type="circle",purpose="vulnerability",radius=24},
      {x=-40,y=70.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=-46.666666666667,y=92.333333333333,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=0.66666666666667,y=-77,type="circle",purpose="vulnerability",radius=28},
      {x=-3,y=-15.666666666667,type="circle",purpose="vulnerability",radius=45},
      {x=24.333333333333,y=34.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=26,y=64.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=27.333333333333,y=90.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=-25.333333333333,y=36,type="circle",purpose="vulnerability",radius=24},
      {x=-37.666666666667,y=60.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=-50.666666666667,y=89.666666666667,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=-0.33333333333333,y=-76.666666666667,type="circle",purpose="vulnerability",radius=27},
      {x=-4.3333333333333,y=-16.333333333333,type="circle",purpose="vulnerability",radius=45},
      {x=24.666666666667,y=33,type="circle",purpose="vulnerability",radius=24},
      {x=29.333333333333,y=61.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=34,y=92.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=-28.666666666667,y=35.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=-41,y=67,type="circle",purpose="vulnerability",radius=24},
      {x=-52,y=91,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=0.33333333333333,y=-75,type="circle",purpose="vulnerability",radius=28},
      {x=-2,y=-15.333333333333,type="circle",purpose="vulnerability",radius=44},
      {x=23.666666666667,y=34,type="circle",purpose="vulnerability",radius=24},
      {x=26,y=60.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=29,y=90.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-27.333333333333,y=36.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=-41.666666666667,y=65.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=-48.666666666667,y=91.666666666667,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=-3.3333333333333,y=-75.333333333333,type="circle",purpose="vulnerability",radius=28},
      {x=-2.3333333333333,y=-16,type="circle",purpose="vulnerability",radius=45},
      {x=24.333333333333,y=36,type="circle",purpose="vulnerability",radius=24},
      {x=25,y=64.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=25,y=92,type="circle",purpose="vulnerability",radius=15},
      {x=-27,y=34.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=-41,y=66.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=-45.333333333333,y=92.666666666667,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=-2.3333333333333,y=-75.666666666667,type="circle",purpose="vulnerability",radius=28},
      {x=-2.3333333333333,y=-18.333333333333,type="circle",purpose="vulnerability",radius=44},
      {x=22.666666666667,y=34.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=22.333333333333,y=66.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=19.333333333333,y=94,type="circle",purpose="vulnerability",radius=15},
      {x=-29.333333333333,y=33,type="circle",purpose="vulnerability",radius=24},
      {x=-38,y=65,type="circle",purpose="vulnerability",radius=21},
      {x=-43.333333333333,y=92,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=0.33333333333333,y=-76.666666666667,type="circle",purpose="vulnerability",radius=27},
      {x=-2.3333333333333,y=-18,type="circle",purpose="vulnerability",radius=44},
      {x=17.666666666667,y=36,type="circle",purpose="vulnerability",radius=24},
      {x=-29,y=32.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=16.333333333333,y=64.333333333333,type="circle",purpose="vulnerability",radius=21},
      {x=13,y=92.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-36,y=63.333333333333,type="circle",purpose="vulnerability",radius=21},
      {x=-39.666666666667,y=90,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=13.333333333333,y=39.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=2.6666666666667,y=-73.666666666667,type="circle",purpose="vulnerability",radius=27},
      {x=-4.3333333333333,y=-17.666666666667,type="circle",purpose="vulnerability",radius=42},
      {x=-23.333333333333,y=35.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=8,y=67,type="circle",purpose="vulnerability",radius=24},
      {x=5.3333333333333,y=93,type="circle",purpose="vulnerability",radius=15},
      {x=-33.333333333333,y=64,type="circle",purpose="vulnerability",radius=21},
      {x=-38,y=90,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=3.6666666666667,y=-76.333333333333,type="circle",purpose="vulnerability",radius=27},
      {x=-7.3333333333333,y=-19.666666666667,type="circle",purpose="vulnerability",radius=42},
      {x=-5.3333333333333,y=35.666666666667,type="circle",purpose="vulnerability",radius=39},
      {x=0,y=86.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=-30.333333333333,y=77,type="circle",purpose="vulnerability",radius=24},
    },
    {
      {x=1.3333333333333,y=-75.333333333333,type="circle",purpose="vulnerability",radius=27},
      {x=-4.6666666666667,y=-19.333333333333,type="circle",purpose="vulnerability",radius=42},
      {x=-4.3333333333333,y=38.666666666667,type="circle",purpose="vulnerability",radius=41},
      {x=5.3333333333333,y=89,type="circle",purpose="vulnerability",radius=18},
      {x=-33,y=79,type="circle",purpose="vulnerability",radius=24},
    },
    {
      {x=-3,y=-77,type="circle",purpose="vulnerability",radius=27},
      {x=-8.6666666666667,y=-16.666666666667,type="circle",purpose="vulnerability",radius=45},
      {x=18,y=36.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=13.333333333333,y=62.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=13.333333333333,y=96.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-26,y=45.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=-40,y=74.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=-37.333333333333,y=96.333333333333,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=0,y=-66.333333333333,type="circle",purpose="vulnerability",radius=29},
      {x=-11,y=-14.333333333333,type="circle",purpose="vulnerability",radius=45},
      {x=28.666666666667,y=33.333333333333,type="circle",purpose="vulnerability",radius=27},
      {x=19.333333333333,y=56.666666666667,type="circle",purpose="vulnerability",radius=21},
      {x=6.6666666666667,y=82.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-20.666666666667,y=49.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=-32.666666666667,y=82.666666666667,type="circle",purpose="vulnerability",radius=24},
    },
}

function trumpSpriteInfo:getSheet()
    return self.sheet;
end

function trumpSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return trumpSpriteInfo