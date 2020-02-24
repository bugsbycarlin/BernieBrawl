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
        {
            x=512, -- flip kicking sprite
            y=1024,
            width=256,
            height=256,

        },
    },

    sheetContentWidth = 1536,
    sheetContentHeight = 1280
}

-- resting frames: 1,2,3,4,5,6
-- kicking frames: 7,8,9,10,11,12
-- punching frames: 13,14,15,16,17
-- extra whip frame: 18
-- jump frames: 19 up, 20 flip, 21 down
-- duress frames: 22 damage, 23 ko, 24 dizzy
-- blocking frame: 25
-- celebrating frames: 26

warrenSpriteInfo.hitIndex = {
    {
      {x=-7,y=-12,type="circle",purpose="vulnerability",radius=18},
      {x=-6.3333333333333,y=-29.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-1,y=32.666666666667,type="circle",purpose="vulnerability",radius=21},
      {x=-1,y=13.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=-1.3333333333333,y=60,type="circle",purpose="vulnerability",radius=23},
      {x=-2,y=-60,type="circle",purpose="vulnerability",radius=23},
    },
    {
      {x=-8.6666666666667,y=27,type="circle",purpose="vulnerability",radius=18},
      {x=-10.333333333333,y=69.666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=-9,y=47,type="circle",purpose="vulnerability",radius=15},
      {x=-8,y=-50.333333333333,type="circle",purpose="vulnerability",radius=23},
      {x=-9.3333333333333,y=3.6666666666667,type="circle",purpose="vulnerability",radius=19},
      {x=-9.3333333333333,y=-14.666666666667,type="circle",purpose="vulnerability",radius=17},
    },
    {
      {x=-12.666666666667,y=9.6666666666667,type="circle",purpose="vulnerability",radius=20},
      {x=-15.333333333333,y=-14.666666666667,type="circle",purpose="vulnerability",radius=20},
      {x=-10.666666666667,y=36.333333333333,type="circle",purpose="vulnerability",radius=22},
      {x=-9,y=64,type="circle",purpose="vulnerability",radius=21},
      {x=-17,y=-51.666666666667,type="circle",purpose="vulnerability",radius=22},
    },
    {
      {x=-4,y=-13.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=-3.3333333333333,y=-25,type="circle",purpose="vulnerability",radius=18},
      {x=-1,y=35.333333333333,type="circle",purpose="vulnerability",radius=22},
      {x=-4.6666666666667,y=12,type="circle",purpose="vulnerability",radius=18},
      {x=14.666666666667,y=71,type="circle",purpose="vulnerability",radius=11},
      {x=11.333333333333,y=53,type="circle",purpose="vulnerability",radius=11},
      {x=-23,y=75.333333333333,type="circle",purpose="vulnerability",radius=11},
      {x=-17.333333333333,y=58,type="circle",purpose="vulnerability",radius=12},
      {x=0,y=-54.666666666667,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=4.6666666666667,y=-7.666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=4.6666666666667,y=-26.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=5.3333333333333,y=31.333333333333,type="circle",purpose="vulnerability",radius=16},
      {x=5,y=13.666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=1.6666666666667,y=70.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=3,y=50.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=8.6666666666667,y=-59.666666666667,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=10.666666666667,y=-5.333333333333,type="circle",purpose="vulnerability",radius=13},
      {x=11,y=-23.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=13,y=35.333333333333,type="circle",purpose="vulnerability",radius=20},
      {x=10.666666666667,y=14.666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=11,y=50.666666666667,type="circle",purpose="vulnerability",radius=20},
      {x=-1,y=71.333333333333,type="circle",purpose="vulnerability",radius=13},
      {x=24.333333333333,y=71.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=20.666666666667,y=-51.333333333333,type="circle",purpose="vulnerability",radius=20},
    },
    {
      {x=-13,y=44.666666666667,type="circle",purpose="vulnerability",radius=20},
      {x=-2,y=26.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=0.66666666666667,y=80,type="circle",purpose="vulnerability",radius=11},
      {x=5,y=63,type="circle",purpose="vulnerability",radius=9},
      {x=-31.666666666667,y=79.333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=-33.666666666667,y=62.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=10.333333333333,y=2,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=8,y=73.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=34,y=63.333333333333,type="circle",purpose="attack",radius=12},
      {x=54,y=66,type="circle",purpose="attack",radius=12},
      {x=76,y=72,type="circle",purpose="attack",radius=15},
      {x=8.6666666666667,y=3.3333333333333,type="circle",purpose="vulnerability",radius=25},
      {x=0.66666666666667,y=42.333333333333,type="circle",purpose="vulnerability",radius=23},
    },
    {
      {x=1,y=41.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=-8,y=25.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=-9.333333333333,y=81.666666666667,type="circle",purpose="vulnerability",radius=11},
      {x=-12.333333333333,y=63.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=25.666666666667,y=79.333333333333,type="circle",purpose="vulnerability",radius=11},
      {x=27.333333333333,y=63.333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=19.666666666667,y=52.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=-19.333333333333,y=1.3333333333333,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=38.666666666667,y=-31.666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=49.333333333333,y=15,type="circle",purpose="vulnerability",radius=22},
      {x=38.333333333333,y=-6,type="circle",purpose="vulnerability",radius=15},
      {x=52.666666666667,y=34.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=30.666666666667,y=63.333333333333,type="circle",purpose="vulnerability",radius=11},
      {x=38,y=42.333333333333,type="circle",purpose="vulnerability",radius=16},
      {x=45.666666666667,y=50.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=41.666666666667,y=-68.333333333333,type="circle",purpose="vulnerability",radius=22},
    },
    {
      {x=31.333333333333,y=-85.666666666667,type="circle",purpose="vulnerability",radius=23},
      {x=46,y=-17.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=30.333333333333,y=19,type="circle",purpose="vulnerability",radius=11},
      {x=36,y=2.6666666666667,type="circle",purpose="vulnerability",radius=11},
      {x=24.666666666667,y=37.333333333333,type="circle",purpose="vulnerability",radius=11},
      {x=21.666666666667,y=52.333333333333,type="circle",purpose="vulnerability",radius=11},
      {x=69.666666666667,y=-24,type="circle",purpose="attack",radius=12},
      {x=88.666666666667,y=-32.666666666667,type="circle",purpose="attack",radius=13},
      {x=119.66666666667,y=-53.333333333333,type="circle",purpose="attack",radius=9},
      {x=104.66666666667,y=-41.333333333333,type="circle",purpose="attack",radius=12},
      {x=36.666666666667,y=-55.666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=40.666666666667,y=-36.666666666667,type="circle",purpose="vulnerability",radius=15},
    },
    {
      {x=32.333333333333,y=-11,type="circle",purpose="vulnerability",radius=14},
      {x=30.333333333333,y=-32,type="circle",purpose="vulnerability",radius=15},
      {x=29,y=38,type="circle",purpose="vulnerability",radius=18},
      {x=19,y=19.333333333333,type="circle",purpose="vulnerability",radius=22},
      {x=33.666666666667,y=4.3333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=32.666666666667,y=57.666666666667,type="circle",purpose="vulnerability",radius=17},
      {x=30.666666666667,y=-66,type="circle",purpose="vulnerability",radius=23},
    },
    {
      {x=5.3333333333333,y=-14,type="circle",purpose="vulnerability",radius=15},
      {x=5.3333333333333,y=-28.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=4.6666666666667,y=38,type="circle",purpose="vulnerability",radius=16},
      {x=5.3333333333333,y=23,type="circle",purpose="vulnerability",radius=15},
      {x=4.6666666666667,y=7.3333333333333,type="circle",purpose="vulnerability",radius=14},
      {x=2.6666666666667,y=55.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=1.6666666666667,y=73.666666666667,type="circle",purpose="vulnerability",radius=14},
      {x=8.6666666666667,y=-58,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=17,y=-59,type="circle",purpose="vulnerability",radius=21},
      {x=13,y=-11,type="circle",purpose="vulnerability",radius=12},
      {x=11.333333333333,y=-27,type="circle",purpose="vulnerability",radius=15},
      {x=15.666666666667,y=26,type="circle",purpose="vulnerability",radius=17},
      {x=12.666666666667,y=7.6666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=14.333333333333,y=45.666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=13,y=69,type="circle",purpose="vulnerability",radius=18},
      {x=55.333333333333,y=-35.333333333333,type="circle",purpose="attack",radius=7},
      {x=65.333333333333,y=-35,type="circle",purpose="attack",radius=6},
      {x=44.666666666667,y=-34.666666666667,type="circle",purpose="attack",radius=7},
      {x=32.666666666667,y=-34.333333333333,type="circle",purpose="attack",radius=7},
    },
    {
      {x=6,y=-18.666666666667,type="circle",purpose="vulnerability",radius=13},
      {x=4.3333333333333,y=-28.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=5,y=37.666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=5,y=20.333333333333,type="circle",purpose="vulnerability",radius=16},
      {x=4.3333333333333,y=2.3333333333333,type="circle",purpose="vulnerability",radius=14},
      {x=2.3333333333333,y=55.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=2,y=73.333333333333,type="circle",purpose="vulnerability",radius=14},
      {x=10,y=-58.666666666667,type="circle",purpose="vulnerability",radius=20},
    },
    {
      {x=12.666666666667,y=-16,type="circle",purpose="vulnerability",radius=12},
      {x=13.666666666667,y=-28.666666666667,type="circle",purpose="vulnerability",radius=12},
      {x=13.666666666667,y=24,type="circle",purpose="vulnerability",radius=17},
      {x=10,y=4.6666666666667,type="circle",purpose="vulnerability",radius=14},
      {x=12.666666666667,y=40,type="circle",purpose="vulnerability",radius=20},
      {x=10.333333333333,y=64,type="circle",purpose="vulnerability",radius=21},
      {x=22,y=-52.666666666667,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=25,y=-22,type="circle",purpose="vulnerability",radius=13},
      {x=20,y=14.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=19.333333333333,y=54.666666666667,type="circle",purpose="vulnerability",radius=23},
      {x=21,y=35.333333333333,type="circle",purpose="vulnerability",radius=20},
      {x=4,y=73.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=40,y=72,type="circle",purpose="vulnerability",radius=10},
      {x=64,y=-29,type="circle",purpose="attack",radius=6},
      {x=45.333333333333,y=-28.666666666667,type="circle",purpose="attack",radius=6},
      {x=53.666666666667,y=-29,type="circle",purpose="attack",radius=6},
      {x=37.333333333333,y=-28.666666666667,type="circle",purpose="attack",radius=6},
      {x=26.666666666667,y=-50.666666666667,type="circle",purpose="vulnerability",radius=19},
      {x=19.666666666667,y=-2.666666666667,type="circle",purpose="vulnerability",radius=13},
    },
    {
      {x=-5.3333333333333,y=-17,type="circle",purpose="vulnerability",radius=12},
      {x=-5.3333333333333,y=-31.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=-5,y=20.666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=-4.3333333333333,y=3.6666666666667,type="circle",purpose="vulnerability",radius=14},
      {x=-3.3333333333333,y=55.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-4.6666666666667,y=38,type="circle",purpose="vulnerability",radius=16},
      {x=-1.6666666666667,y=72,type="circle",purpose="vulnerability",radius=14},
      {x=-8.6666666666667,y=-60,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=12,y=-12.666666666667,type="circle",purpose="vulnerability",radius=12},
      {x=14.666666666667,y=-28.666666666667,type="circle",purpose="vulnerability",radius=12},
      {x=11.333333333333,y=9.333333333333,type="circle",purpose="vulnerability",radius=16},
      {x=26,y=40,type="circle",purpose="defense",radius=10},
      {x=29.666666666667,y=24.333333333333,type="circle",purpose="defense",radius=10},
      {x=20,y=50.333333333333,type="circle",purpose="defense",radius=10},
      {x=20.666666666667,y=65.666666666667,type="circle",purpose="defense",radius=9},
      {x=-1.3333333333333,y=35,type="circle",purpose="vulnerability",radius=10},
      {x=1.6666666666667,y=21.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=-11,y=67,type="circle",purpose="vulnerability",radius=12},
      {x=-5.6666666666667,y=49,type="circle",purpose="vulnerability",radius=10},
      {x=21.333333333333,y=-50.666666666667,type="circle",purpose="vulnerability",radius=20},
    },
    {
      {x=5,y=2.3333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=28,y=28,type="circle",purpose="vulnerability",radius=9},
      {x=25.666666666667,y=13,type="circle",purpose="vulnerability",radius=9},
      {x=55.333333333333,y=13.333333333333,type="circle",purpose="vulnerability",radius=8},
      {x=48.333333333333,y=0,type="circle",purpose="vulnerability",radius=10},
      {x=38.666666666667,y=-13.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=25.666666666667,y=-4.3333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=22,y=-50.666666666667,type="circle",purpose="vulnerability",radius=21},
      {x=7,y=-15.333333333333,type="circle",purpose="vulnerability",radius=11},
      {x=14.666666666667,y=-28.666666666667,type="circle",purpose="vulnerability",radius=13},
    },
    {
      {x=8.666666666667,y=-6.666666666667,type="circle",purpose="vulnerability",radius=13},
      {x=11.666666666667,y=-23,type="circle",purpose="vulnerability",radius=13},
      {x=10.666666666667,y=11.333333333333,type="circle",purpose="vulnerability",radius=15},
      {x=25.333333333333,y=17.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=-11,y=47.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=-4.6666666666667,y=35,type="circle",purpose="vulnerability",radius=10},
      {x=6.6666666666667,y=27.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=30,y=32,type="circle",purpose="vulnerability",radius=12},
      {x=34.666666666667,y=62.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=32,y=48.333333333333,type="circle",purpose="vulnerability",radius=11},
      {x=19.333333333333,y=-52.666666666667,type="circle",purpose="vulnerability",radius=23},
    },
    {
      {x=-5,y=-3,type="circle",purpose="vulnerability",radius=14},
      {x=-11.666666666667,y=-23.666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-0.66666666666667,y=15.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=-23.333333333333,y=57.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=-16,y=42.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=-9.6666666666667,y=28.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=10,y=28.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=9.6666666666667,y=43,type="circle",purpose="vulnerability",radius=9},
      {x=10.666666666667,y=66,type="circle",purpose="vulnerability",radius=10},
      {x=-22.333333333333,y=69.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=6.3333333333333,y=54.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=-12.333333333333,y=-54,type="circle",purpose="vulnerability",radius=20},
    },
    {
      {x=-5.666666666667,y=-4.6666666666667,type="circle",purpose="vulnerability",radius=15},
      {x=-24.333333333333,y=-2,type="circle",purpose="vulnerability",radius=13},
      {x=24,y=-15.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=62.333333333333,y=-2,type="circle",purpose="vulnerability",radius=13},
      {x=46,y=-3.3333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=-51.666666666667,y=-2.6666666666667,type="circle",purpose="vulnerability",radius=20},
    },
    {
      {x=-3.3333333333333,y=0,type="circle",purpose="vulnerability",radius=16},
      {x=-4.6666666666667,y=-24,type="circle",purpose="vulnerability",radius=15},
      {x=-0.33333333333333,y=22.333333333333,type="circle",purpose="vulnerability",radius=19},
      {x=0,y=44,type="circle",purpose="vulnerability",radius=19},
      {x=-3,y=66.666666666667,type="circle",purpose="vulnerability",radius=20},
      {x=-1,y=-54.666666666667,type="circle",purpose="vulnerability",radius=21},
    },
    {
      {x=18,y=-36,type="circle",purpose="defense",radius=19},
      {x=4.6666666666667,y=-5.6666666666667,type="circle",purpose="defense",radius=14},
      {x=4,y=-27,type="circle",purpose="defense",radius=15},
      {x=20.333333333333,y=16.666666666667,type="circle",purpose="defense",radius=17},
      {x=23.333333333333,y=30.333333333333,type="circle",purpose="defense",radius=9},
      {x=15.333333333333,y=40.666666666667,type="circle",purpose="defense",radius=10},
      {x=12.333333333333,y=57,type="circle",purpose="defense",radius=9},
      {x=8,y=-60.666666666667,type="circle",purpose="defense",radius=21},
    },
    {
    },
    {
      {x=21,y=-51.666666666667,type="circle",purpose="vulnerability",radius=21},
      {x=14.666666666667,y=-21,type="circle",purpose="vulnerability",radius=16},
      {x=5.6666666666667,y=1,type="circle",purpose="vulnerability",radius=18},
      {x=9.3333333333333,y=25.333333333333,type="circle",purpose="attack",radius=10},
      {x=28.666666666667,y=2.3333333333333,type="circle",purpose="attack",radius=10},
      {x=41,y=8,type="circle",purpose="attack",radius=9},
      {x=57.666666666667,y=11.666666666667,type="circle",purpose="attack",radius=10},
    },
}

function warrenSpriteInfo:getSheet()
    return self.sheet;
end

function warrenSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return warrenSpriteInfo