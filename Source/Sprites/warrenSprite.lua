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
    },

    sheetContentWidth = 1536,
    sheetContentHeight = 1024
}

warrenSpriteInfo.frameIndex =
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

warrenSpriteInfo.hitIndex = 
{
    {
        {y=-58,type="circle",purpose="vulnerability",radius=28,x=-2},
        {y=-15,type="circle",purpose="vulnerability",radius=23,x=-3},
        {y=23.666666666667,type="circle",purpose="vulnerability",radius=25,x=-3},
        {y=60,type="circle",purpose="vulnerability",radius=23,x=-1.3333333333333},
    },
    {
        {y=-49.333333333333,x=-8,purpose="vulnerability",type="circle",radius=27},
        {y=-7.3333333333333,x=-7.3333333333333,purpose="vulnerability",type="circle",radius=24},
        {y=28,x=-9.6666666666667,purpose="vulnerability",type="circle",radius=21},
        {y=61.666666666667,x=-10.333333333333,purpose="vulnerability",type="circle",radius=21}
    },
    {
        {y=0,type="circle",purpose="defense",radius=10,x=23.333333333333},
        {y=-49.666666666667,x=-16,purpose="vulnerability",type="circle",radius=27},
        {y=-8.3333333333333,x=-14.666666666667,purpose="vulnerability",type="circle",radius=24},
        {y=30.333333333333,x=-10.666666666667,purpose="vulnerability",type="circle",radius=25},
        {y=64,x=-9,purpose="vulnerability",type="circle",radius=21}
    },
    {
        {y=-53.666666666667,x=-2,purpose="vulnerability",type="circle",radius=26},
        {y=-13.333333333333,x=-6,purpose="vulnerability",type="circle",radius=24},
        {y=27.333333333333,x=-4,purpose="vulnerability",type="circle",radius=25},
        {y=64,x=10.666666666667,purpose="vulnerability",type="circle",radius=18},
        {y=65.333333333333,x=-20,purpose="vulnerability",type="circle",radius=18}
    },
    {
        {y=-61.666666666667,x=7.6666666666667,purpose="vulnerability",type="circle",radius=26},
        {y=-16.666666666667,x=4.6666666666667,purpose="vulnerability",type="circle",radius=24},
        {y=23.333333333333,x=5.3333333333333,purpose="vulnerability",type="circle",radius=24},
        {y=62.333333333333,x=2.6666666666667,purpose="vulnerability",type="circle",radius=21}
    },
    {
        {y=-54.333333333333,radius=26,purpose="vulnerability",x=20.666666666667,type="circle"},
        {y=-14.333333333333,radius=22,purpose="vulnerability",x=11.666666666667,type="circle"},
        {y=23.333333333333,radius=22,purpose="vulnerability",x=10,type="circle"},
        {y=46.666666666667,radius=24,purpose="vulnerability",x=12,type="circle"},
        {y=63.333333333333,radius=24,purpose="vulnerability",x=11,type="circle"}
    },
    {
        {y=0,radius=25,purpose="vulnerability",x=10.333333333333,type="circle"},
        {y=38.666666666667,radius=27,purpose="vulnerability",x=-2,type="circle"},
        {y=76,radius=18,purpose="vulnerability",x=0.66666666666667,type="circle"},
        {y=62.333333333333,radius=21,purpose="vulnerability",x=-34.666666666667,type="circle"}
    },
    {
        {y=3.3333333333333,type="circle",purpose="vulnerability",radius=25,x=8.6666666666667},
        {y=42.333333333333,type="circle",purpose="vulnerability",radius=24,x=0.66666666666667},
        {y=72.666666666667,type="circle",purpose="vulnerability",radius=15,x=-24},
        {y=73.333333333333,type="circle",purpose="vulnerability",radius=18,x=8},
        {y=63.333333333333,type="circle",purpose="attack",radius=12,x=34},
        {y=66,type="circle",purpose="attack",radius=12,x=54},
        {y=72,type="circle",purpose="attack",radius=15,x=76}
    },
    {
        {y=1.3333333333333,type="circle",purpose="vulnerability",radius=24,x=-19.333333333333},
        {y=39.333333333333,type="circle",purpose="vulnerability",radius=27,x=-4},
        {y=76.666666666667,type="circle",purpose="vulnerability",radius=15,x=-11.333333333333},
        {y=67.333333333333,type="circle",purpose="vulnerability",radius=18,x=26.666666666667}
    },
    {
        {y=-70.333333333333,type="circle",purpose="vulnerability",radius=25,x=41.666666666667},
        {y=-24.666666666667,type="circle",purpose="vulnerability",radius=24,x=40.666666666667},
        {y=13,type="circle",purpose="vulnerability",radius=24,x=48.333333333333},
        {y=49.333333333333,type="circle",purpose="vulnerability",radius=17,x=30.666666666667},
        {y=45.666666666667,type="circle",purpose="vulnerability",radius=12,x=48.666666666667}
    },
    {
        {y=-85.666666666667,type="circle",purpose="vulnerability",radius=24,x=31.333333333333},
        {y=-46,type="circle",purpose="vulnerability",radius=20,x=36.666666666667},
        {y=-70.666666666667,type="circle",purpose="defense",radius=10,x=59.333333333333},
        {y=-84,type="circle",purpose="defense",radius=10,x=66},
        {y=-58.666666666667,type="circle",purpose="defense",radius=10,x=2.6666666666667},
        {y=-41.333333333333,type="circle",purpose="defense",radius=10,x=9.3333333333333},
        {y=-15.333333333333,type="circle",purpose="vulnerability",radius=18,x=44},
        {y=11,type="circle",purpose="vulnerability",radius=12,x=33.333333333333},
        {y=31.333333333333,type="circle",purpose="vulnerability",radius=12,x=26.666666666667},
        {y=50.333333333333,type="circle",purpose="vulnerability",radius=12,x=21.666666666667},
        {y=-26,type="circle",purpose="attack",radius=12,x=70.666666666667},
        {y=-32.666666666667,type="circle",purpose="attack",radius=15,x=88.666666666667},
        {y=-47.333333333333,type="circle",purpose="attack",radius=18,x=113.66666666667}
    },
    {
        {y=-69,type="circle",purpose="vulnerability",radius=27,x=32.666666666667},
        {y=-23,type="circle",purpose="vulnerability",radius=21,x=31.333333333333},
        {y=15,type="circle",purpose="vulnerability",radius=27,x=24},
        {y=55.666666666667,type="circle",purpose="vulnerability",radius=18,x=31.666666666667}
    },
    {
        {y=-62,type="circle",purpose="vulnerability",radius=26,x=8.6666666666667},
        {y=-19,type="circle",purpose="vulnerability",radius=23,x=6.3333333333333},
        {y=17,type="circle",purpose="vulnerability",radius=20,x=4.6666666666667},
        {y=42.666666666667,type="circle",purpose="vulnerability",radius=18,x=4.6666666666667},
        {y=67.666666666667,type="circle",purpose="vulnerability",radius=16,x=2.6666666666667}
    },
    {
        {y=-35.333333333333,x=65.333333333333,purpose="attack",type="circle",radius=9},
        {y=-34.666666666667,x=50.666666666667,purpose="attack",type="circle",radius=10},
        {y=-34.333333333333,x=34.666666666667,purpose="attack",type="circle",radius=10},
        {y=-61,x=17,purpose="vulnerability",type="circle",radius=26},
        {y=-21,x=11,purpose="vulnerability",type="circle",radius=20},
        {y=13,x=12.666666666667,purpose="vulnerability",type="circle",radius=18},
        {y=33.666666666667,x=13.333333333333,purpose="vulnerability",type="circle",radius=20},
        {y=64,x=13,purpose="vulnerability",type="circle",radius=21}
    },
    {
        {y=-63.666666666667,x=9,purpose="vulnerability",type="circle",radius=25},
        {y=-19.666666666667,x=4,purpose="vulnerability",type="circle",radius=21},
        {y=16.666666666667,x=4,purpose="vulnerability",type="circle",radius=19},
        {y=45.333333333333,x=4.3333333333333,purpose="vulnerability",type="circle",radius=17},
        {y=69.333333333333,x=2,purpose="vulnerability",type="circle",radius=18}
    },
    {
        {y=-56.666666666667,x=21,purpose="vulnerability",type="circle",radius=25},
        {y=-16,x=12.666666666667,purpose="vulnerability",type="circle",radius=20},
        {y=20,x=12.666666666667,purpose="vulnerability",type="circle",radius=20},
        {y=42,x=13.666666666667,purpose="vulnerability",type="circle",radius=21},
        {y=66,x=11.333333333333,purpose="vulnerability",type="circle",radius=22}
    },
    {
        {y=-30,x=64,purpose="attack",type="circle",radius=9},
        {y=-28.666666666667,x=49.333333333333,purpose="attack",type="circle",radius=10},
        {y=-28.666666666667,x=37.333333333333,purpose="attack",type="circle",radius=10},
        {y=-53.666666666667,x=27.666666666667,purpose="vulnerability",type="circle",radius=27},
        {y=-13.666666666667,x=21.666666666667,purpose="vulnerability",type="circle",radius=17},
        {y=15.333333333333,x=21,purpose="vulnerability",type="circle",radius=16},
        {y=43.666666666667,x=20.333333333333,purpose="vulnerability",type="circle",radius=26},
        {y=70.666666666667,x=4,purpose="vulnerability",type="circle",radius=10},
        {y=72,x=40,purpose="vulnerability",type="circle",radius=10}
    },
    {
        {y=-62,x=-7.6666666666667,purpose="vulnerability",type="circle",radius=26},
        {y=-21,x=-5.3333333333333,purpose="vulnerability",type="circle",radius=22},
        {y=12.666666666667,x=-4,purpose="vulnerability",type="circle",radius=18},
        {y=39.666666666667,x=-5.3333333333333,purpose="vulnerability",type="circle",radius=18},
        {y=68,x=-2.6666666666667,purpose="vulnerability",type="circle",radius=18}
    },
    {
        {y=-54.666666666667,x=21.333333333333,purpose="vulnerability",type="circle",radius=26},
        {y=-18.666666666667,x=12,purpose="vulnerability",type="circle",radius=18},
        {y=11.333333333333,x=13.333333333333,purpose="vulnerability",type="circle",radius=18},
        {y=24,x=32,purpose="defense",type="circle",radius=10},
        {y=41.333333333333,x=26,purpose="defense",type="circle",radius=10},
        {y=60.666666666667,x=20.666666666667,purpose="defense",type="circle",radius=14},
        {y=35,x=-1.3333333333333,purpose="vulnerability",type="circle",radius=12},
        {y=61,x=-8,purpose="vulnerability",type="circle",radius=18}
    },
    {
        {y=-50.666666666667,x=23,purpose="vulnerability",type="circle",radius=26},
        {y=-2.6666666666667,x=21,purpose="vulnerability",type="circle",radius=32}
    },
    {
        {y=-57.666666666667,x=18.333333333333,purpose="vulnerability",type="circle",radius=27},
        {y=-18.666666666667,x=10.666666666667,purpose="vulnerability",type="circle",radius=18},
        {y=12.333333333333,x=12.666666666667,purpose="vulnerability",type="circle",radius=18},
        {y=39.333333333333,x=-4,purpose="vulnerability",type="circle",radius=18},
        {y=34,x=29,purpose="vulnerability",type="circle",radius=15},
        {y=57.333333333333,x=31.666666666667,purpose="vulnerability",type="circle",radius=15}
    },
    {
        {y=-58,x=-12.333333333333,purpose="vulnerability",type="circle",radius=24},
        {y=-16,x=-8,purpose="vulnerability",type="circle",radius=21},
        {y=17.333333333333,x=-0.66666666666667,purpose="vulnerability",type="circle",radius=18},
        {y=50.333333333333,x=-10.333333333333,purpose="vulnerability",type="circle",radius=21},
        {y=39.666666666667,x=3.3333333333333,purpose="vulnerability",type="circle",radius=18}
    },
    {
        {y=-2.6666666666667,x=-54.666666666667,purpose="vulnerability",type="circle",radius=24},
        {y=-4.6666666666667,x=-14.666666666667,purpose="vulnerability",type="circle",radius=18},
        {y=-13.333333333333,x=24,purpose="vulnerability",type="circle",radius=24},
        {y=-2,x=59.333333333333,purpose="vulnerability",type="circle",radius=15}
    },
    {
        {y=-58.666666666667,x=-1,purpose="vulnerability",type="circle",radius=26},
        {y=-18,x=-5.3333333333333,purpose="vulnerability",type="circle",radius=18},
        {y=17.333333333333,x=0.66666666666667,purpose="vulnerability",type="circle",radius=21},
        {y=41,x=-1,purpose="vulnerability",type="circle",radius=21},
        {y=66.666666666667,x=-2,purpose="vulnerability",type="circle",radius=21}
    },
}

function warrenSpriteInfo:getSheet()
    return self.sheet;
end

function warrenSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return warrenSpriteInfo