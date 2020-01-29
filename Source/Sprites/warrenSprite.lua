local warrenSpriteInfo = {}

warrenSpriteInfo.sheet =
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
        {
            x=0, -- blocking sprite
            y=1024,
            width=256,
            height=256,

        },
        {
            x=256, -- celebrating sprite
            y=1024,
            width=256,
            height=256,

        },
    },

    sheetContentWidth = 1536,
    sheetContentHeight = 1280
}

warrenSpriteInfo.frameIndex =
{
    -- resting frames: 1,2,3,4,5,6
    -- kicking frames: 7,8,9,10,11,12
    -- punching frames: 13,14,15,16,17
    -- extra whip frame: 18
    -- jump frames: 19 up, 20 flip, 21 down
    -- duress frames: 22 damage, 23 ko, 24 dizzy
    -- blocking frame: 25
    -- celebrating frames: 26

    ["normal"] = 1,
    ["damage"] = 22,
    -- ["damage"] = 2,
}

warrenSpriteInfo.hitIndex = {
    {
      {x=-2,y=-58,type="circle",purpose="vulnerability",radius=28},
      {x=-3,y=-15,type="circle",purpose="vulnerability",radius=23},
      {x=-3,y=23.666666666667,type="circle",purpose="vulnerability",radius=25},
      {x=-1.3333333333333,y=60,type="circle",purpose="vulnerability",radius=23},
    },
    {
      {x=-8,y=-49.333333333333,type="circle",purpose="vulnerability",radius=27},
      {x=-7.3333333333333,y=-7.3333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=-9.6666666666667,y=28,type="circle",purpose="vulnerability",radius=21},
      {x=-10.333333333333,y=61.666666666667,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=23.333333333333,y=0,type="circle",purpose="defense",radius=10},
      {x=-16,y=-49.666666666667,type="circle",purpose="vulnerability",radius=27},
      {x=-14.666666666667,y=-8.3333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=-10.666666666667,y=30.333333333333,type="circle",purpose="vulnerability",radius=25},
      {x=-9,y=64,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=-2,y=-53.666666666667,type="circle",purpose="vulnerability",radius=26},
      {x=-6,y=-13.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=-4,y=27.333333333333,type="circle",purpose="vulnerability",radius=25},
      {x=10.666666666667,y=64,type="circle",purpose="vulnerability",radius=18},
      {x=-20,y=65.333333333333,type="circle",purpose="vulnerability",radius=18},
    },
    {
      {x=7.6666666666667,y=-61.666666666667,type="circle",purpose="vulnerability",radius=26},
      {x=4.6666666666667,y=-16.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=5.3333333333333,y=23.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=2.6666666666667,y=62.333333333333,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=20.666666666667,y=-54.333333333333,type="circle",purpose="vulnerability",radius=26},
      {x=11.666666666667,y=-14.333333333333,type="circle",purpose="vulnerability",radius=22},
      {x=10,y=23.333333333333,type="circle",purpose="vulnerability",radius=22},
      {x=12,y=46.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=11,y=63.333333333333,type="circle",purpose="vulnerability",radius=24},
    },
    {
      {x=10.333333333333,y=0,type="circle",purpose="vulnerability",radius=25},
      {x=-2,y=38.666666666667,type="circle",purpose="vulnerability",radius=27},
      {x=0.66666666666667,y=76,type="circle",purpose="vulnerability",radius=18},
      {x=-34.666666666667,y=62.333333333333,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=8.6666666666667,y=3.3333333333333,type="circle",purpose="vulnerability",radius=25},
      {x=0.66666666666667,y=42.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=-24,y=72.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=8,y=73.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=34,y=63.333333333333,type="circle",purpose="attack",radius=12},
      {x=54,y=66,type="circle",purpose="attack",radius=12},
      {x=76,y=72,type="circle",purpose="attack",radius=15},
    },
    {
      {x=-19.333333333333,y=1.3333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=-4,y=39.333333333333,type="circle",purpose="vulnerability",radius=27},
      {x=-11.333333333333,y=76.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=26.666666666667,y=67.333333333333,type="circle",purpose="vulnerability",radius=18},
    },
    {
      {x=41.666666666667,y=-70.333333333333,type="circle",purpose="vulnerability",radius=25},
      {x=40.666666666667,y=-24.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=48.333333333333,y=13,type="circle",purpose="vulnerability",radius=24},
      {x=30.666666666667,y=49.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=48.666666666667,y=45.666666666667,type="circle",purpose="vulnerability",radius=12},
    },
    {
      {x=31.333333333333,y=-85.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=36.666666666667,y=-46,type="circle",purpose="vulnerability",radius=20},
      {x=59.333333333333,y=-70.666666666667,type="circle",purpose="defense",radius=10},
      {x=66,y=-84,type="circle",purpose="defense",radius=10},
      {x=2.6666666666667,y=-58.666666666667,type="circle",purpose="defense",radius=10},
      {x=9.3333333333333,y=-41.333333333333,type="circle",purpose="defense",radius=10},
      {x=44,y=-15.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=33.333333333333,y=11,type="circle",purpose="vulnerability",radius=12},
      {x=26.666666666667,y=31.333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=21.666666666667,y=50.333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=70.666666666667,y=-26,type="circle",purpose="attack",radius=12},
      {x=88.666666666667,y=-32.666666666667,type="circle",purpose="attack",radius=15},
      {x=113.66666666667,y=-47.333333333333,type="circle",purpose="attack",radius=18},
    },
    {
      {x=32.666666666667,y=-69,type="circle",purpose="vulnerability",radius=27},
      {x=31.333333333333,y=-23,type="circle",purpose="vulnerability",radius=21},
      {x=24,y=15,type="circle",purpose="vulnerability",radius=27},
      {x=31.666666666667,y=55.666666666667,type="circle",purpose="vulnerability",radius=18},
    },
    {
      {x=8.6666666666667,y=-62,type="circle",purpose="vulnerability",radius=26},
      {x=6.3333333333333,y=-19,type="circle",purpose="vulnerability",radius=23},
      {x=4.6666666666667,y=17,type="circle",purpose="vulnerability",radius=20},
      {x=4.6666666666667,y=42.666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=2.6666666666667,y=67.666666666667,type="circle",purpose="vulnerability",radius=16},
    },
    {
      {x=65.333333333333,y=-35.333333333333,type="circle",purpose="attack",radius=9},
      {x=50.666666666667,y=-34.666666666667,type="circle",purpose="attack",radius=10},
      {x=34.666666666667,y=-34.333333333333,type="circle",purpose="attack",radius=10},
      {x=17,y=-61,type="circle",purpose="vulnerability",radius=26},
      {x=11,y=-21,type="circle",purpose="vulnerability",radius=20},
      {x=12.666666666667,y=13,type="circle",purpose="vulnerability",radius=18},
      {x=13.333333333333,y=33.666666666667,type="circle",purpose="vulnerability",radius=20},
      {x=13,y=64,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=9,y=-63.666666666667,type="circle",purpose="vulnerability",radius=25},
      {x=4,y=-19.666666666667,type="circle",purpose="vulnerability",radius=21},
      {x=4,y=16.666666666667,type="circle",purpose="vulnerability",radius=19},
      {x=4.3333333333333,y=45.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=2,y=69.333333333333,type="circle",purpose="vulnerability",radius=18},
    },
    {
      {x=21,y=-56.666666666667,type="circle",purpose="vulnerability",radius=25},
      {x=12.666666666667,y=-16,type="circle",purpose="vulnerability",radius=20},
      {x=12.666666666667,y=20,type="circle",purpose="vulnerability",radius=20},
      {x=13.666666666667,y=42,type="circle",purpose="vulnerability",radius=21},
      {x=11.333333333333,y=66,type="circle",purpose="vulnerability",radius=22},
    },
    {
      {x=64,y=-30,type="circle",purpose="attack",radius=9},
      {x=49.333333333333,y=-28.666666666667,type="circle",purpose="attack",radius=10},
      {x=37.333333333333,y=-28.666666666667,type="circle",purpose="attack",radius=10},
      {x=27.666666666667,y=-53.666666666667,type="circle",purpose="vulnerability",radius=27},
      {x=21.666666666667,y=-13.666666666667,type="circle",purpose="vulnerability",radius=17},
      {x=21,y=15.333333333333,type="circle",purpose="vulnerability",radius=16},
      {x=20.333333333333,y=43.666666666667,type="circle",purpose="vulnerability",radius=26},
      {x=4,y=70.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=40,y=72,type="circle",purpose="vulnerability",radius=10},
    },
    {
      {x=-7.6666666666667,y=-62,type="circle",purpose="vulnerability",radius=26},
      {x=-5.3333333333333,y=-21,type="circle",purpose="vulnerability",radius=22},
      {x=-4,y=12.666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=-5.3333333333333,y=39.666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=-2.6666666666667,y=68,type="circle",purpose="vulnerability",radius=18},
    },
    {
      {x=21.333333333333,y=-54.666666666667,type="circle",purpose="vulnerability",radius=26},
      {x=12,y=-18.666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=13.333333333333,y=11.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=32,y=24,type="circle",purpose="defense",radius=10},
      {x=26,y=41.333333333333,type="circle",purpose="defense",radius=10},
      {x=20.666666666667,y=60.666666666667,type="circle",purpose="defense",radius=14},
      {x=-1.3333333333333,y=35,type="circle",purpose="vulnerability",radius=12},
      {x=-8,y=61,type="circle",purpose="vulnerability",radius=18},
    },
    {
      {x=23,y=-50.666666666667,type="circle",purpose="vulnerability",radius=26},
      {x=21,y=-2.6666666666667,type="circle",purpose="vulnerability",radius=32},
    },
    {
      {x=18.333333333333,y=-57.666666666667,type="circle",purpose="vulnerability",radius=27},
      {x=10.666666666667,y=-18.666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=12.666666666667,y=12.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=-4,y=39.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=29,y=34,type="circle",purpose="vulnerability",radius=15},
      {x=31.666666666667,y=57.333333333333,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=-12.333333333333,y=-58,type="circle",purpose="vulnerability",radius=24},
      {x=-8,y=-16,type="circle",purpose="vulnerability",radius=21},
      {x=-0.66666666666667,y=17.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=-10.333333333333,y=50.333333333333,type="circle",purpose="vulnerability",radius=21},
      {x=3.3333333333333,y=39.666666666667,type="circle",purpose="vulnerability",radius=18},
    },
    {
      {x=-54.666666666667,y=-2.6666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=-14.666666666667,y=-4.6666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=24,y=-13.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=59.333333333333,y=-2,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=-1,y=-58.666666666667,type="circle",purpose="vulnerability",radius=26},
      {x=-5.3333333333333,y=-18,type="circle",purpose="vulnerability",radius=18},
      {x=0.66666666666667,y=17.333333333333,type="circle",purpose="vulnerability",radius=21},
      {x=-1,y=41,type="circle",purpose="vulnerability",radius=21},
      {x=-2,y=66.666666666667,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=8,y=-62.666666666667,type="circle",purpose="defense",radius=24},
      {x=20,y=-37,type="circle",purpose="defense",radius=20},
      {x=3.6666666666667,y=-8.6666666666667,type="circle",purpose="defense",radius=17},
      {x=19.333333333333,y=17.666666666667,type="circle",purpose="defense",radius=18},
      {x=18.333333333333,y=38.666666666667,type="circle",purpose="defense",radius=12},
      {x=11.333333333333,y=54,type="circle",purpose="defense",radius=10},
    },
}

function warrenSpriteInfo:getSheet()
    return self.sheet;
end

function warrenSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return warrenSpriteInfo