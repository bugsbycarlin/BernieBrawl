local BidenSpriteInfo = {}

BidenSpriteInfo.sheet =
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
        {
            x=1280,
            y=256,
            width=256,
            height=256,

        },
        {
            x=1536,
            y=256,
            width=256,
            height=256,

        },
        {
            x=1792,
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
    },

    sheetContentWidth = 2048,
    sheetContentHeight = 1024
}


-- 256, 512, 768, 1024, 1280, 1536, 1792, 2048, 2304, 2560, 2816, 3072, 3328, 3584, 3840, 4096, 4352, 4608, 4864


-- 384, 768, 1152, 1536, 1920, 2304, 2688, 3072, 3456, 3840, 4224, 4608, 4992, 5376, 5760, 6144, 6528, 6912, 729

BidenSpriteInfo.frameIndex =
{
    ["normal"] = 1,
    ["punch"] = 3,
    ["damage"] = 2,
}

BidenSpriteInfo.hitIndex = 
{
    {
      {y=-42.333333333333,type="circle",purpose="defense",radius=11,x=39.666666666667},
      {y=-34.333333333333,type="circle",purpose="defense",radius=11,x=11.666666666667},
      {y=-70,type="circle",purpose="vulnerability",radius=24,x=8.6666666666667},
      {y=-31,type="circle",purpose="vulnerability",radius=24,x=-1.3333333333333},
      {y=-36.333333333333,type="circle",purpose="vulnerability",radius=11,x=20},
      {y=-22.666666666667,type="circle",purpose="vulnerability",radius=12,x=28.666666666667},
      {y=-1,type="circle",purpose="vulnerability",radius=18,x=-3.6666666666667},
      {y=13,type="circle",purpose="vulnerability",radius=15,x=14},
      {y=29,type="circle",purpose="vulnerability",radius=15,x=21.333333333333},
      {y=46.333333333333,type="circle",purpose="vulnerability",radius=15,x=21},
      {y=67,type="circle",purpose="vulnerability",radius=12,x=21},
      {y=70,type="circle",purpose="vulnerability",radius=10,x=33.333333333333},
      {y=24,type="circle",purpose="vulnerability",radius=15,x=-14},
      {y=46.666666666667,type="circle",purpose="vulnerability",radius=15,x=-22.666666666667},
      {y=62.666666666667,type="circle",purpose="vulnerability",radius=15,x=-37},
      {y=75.333333333333,type="circle",purpose="vulnerability",radius=15,x=-42.666666666667}
    },
    {
      {y=-36.333333333333,type="circle",purpose="defense",radius=11,x=39.333333333333},
      {y=-25.666666666667,type="circle",purpose="defense",radius=11,x=8.6666666666667},
      {y=-64.666666666667,type="circle",purpose="vulnerability",radius=24,x=8.3333333333333},
      {y=-24.666666666667,type="circle",purpose="vulnerability",radius=24,x=-3},
      {y=-31.333333333333,type="circle",purpose="vulnerability",radius=12,x=20},
      {y=-19,type="circle",purpose="vulnerability",radius=12,x=28},
      {y=4.3333333333333,type="circle",purpose="vulnerability",radius=18,x=-1.3333333333333},
      {y=29,type="circle",purpose="vulnerability",radius=15,x=-12.666666666667},
      {y=47.333333333333,type="circle",purpose="vulnerability",radius=15,x=-20.333333333333},
      {y=64,type="circle",purpose="vulnerability",radius=15,x=-37.333333333333},
      {y=76.666666666667,type="circle",purpose="vulnerability",radius=15,x=-45.333333333333},
      {y=17.333333333333,type="circle",purpose="vulnerability",radius=15,x=15.333333333333},
      {y=31.666666666667,type="circle",purpose="vulnerability",radius=15,x=22},
      {y=47.333333333333,type="circle",purpose="vulnerability",radius=15,x=23.333333333333},
      {y=69.666666666667,type="circle",purpose="vulnerability",radius=15,x=26.666666666667}
    },
    {
      {y=-62.333333333333,type="circle",purpose="vulnerability",radius=25,x=7.3333333333333},
      {y=-30,type="circle",purpose="defense",radius=11,x=37.333333333333},
      {y=-18,type="circle",purpose="defense",radius=11,x=9},
      {y=-22,x=-3,purpose="vulnerability",type="circle",radius=24},
      {y=-28.333333333333,x=18,purpose="vulnerability",type="circle",radius=12},
      {y=-13.333333333333,x=27.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=5.3333333333333,x=-4,purpose="vulnerability",type="circle",radius=18},
      {y=32.666666666667,x=-12.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=48.666666666667,x=-21,purpose="vulnerability",type="circle",radius=15},
      {y=64.666666666667,x=-37.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=74.666666666667,x=-44.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=18,x=15.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=34.333333333333,x=24.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=52.333333333333,x=26,purpose="vulnerability",type="circle",radius=15},
      {y=71.333333333333,x=30,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-36.666666666667,x=38.666666666667,purpose="defense",type="circle",radius=11},
      {y=-25.666666666667,x=10.666666666667,purpose="defense",type="circle",radius=11},
      {y=-66.333333333333,x=8,purpose="vulnerability",type="circle",radius=23},
      {y=-28.333333333333,x=-2.3333333333333,purpose="vulnerability",type="circle",radius=24},
      {y=-30.666666666667,x=21.333333333333,purpose="vulnerability",type="circle",radius=12},
      {y=-18,x=28.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=0.66666666666667,x=-2.3333333333333,purpose="vulnerability",type="circle",radius=18},
      {y=24.666666666667,x=-11.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=45,x=-19.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=60.333333333333,x=-35.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=74.333333333333,x=-42.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=16,x=16,purpose="vulnerability",type="circle",radius=15},
      {y=34,x=24.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=53.333333333333,x=24.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=70.666666666667,x=28,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-41.333333333333,x=40,purpose="defense",type="circle",radius=11},
      {y=-34,x=11.333333333333,purpose="defense",type="circle",radius=11},
      {y=-69.333333333333,x=7,purpose="vulnerability",type="circle",radius=24},
      {y=-30.333333333333,x=-2.6666666666667,purpose="vulnerability",type="circle",radius=24},
      {y=-37,x=19.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=-24.666666666667,x=28.333333333333,purpose="vulnerability",type="circle",radius=12},
      {y=-0.66666666666667,x=-3.6666666666667,purpose="vulnerability",type="circle",radius=18},
      {y=25,x=-13.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=44,x=-22.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=59,x=-34,purpose="vulnerability",type="circle",radius=15},
      {y=74.333333333333,x=-41.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=12.333333333333,x=13,purpose="vulnerability",type="circle",radius=15},
      {y=26.333333333333,x=19,purpose="vulnerability",type="circle",radius=15},
      {y=43.333333333333,x=21.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=66.333333333333,x=25.666666666667,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-41.333333333333,x=42,purpose="defense",type="circle",radius=11},
      {y=-33,x=14.333333333333,purpose="defense",type="circle",radius=11},
      {y=-68,x=8,purpose="vulnerability",type="circle",radius=23},
      {y=-26.666666666667,x=-0.33333333333333,purpose="vulnerability",type="circle",radius=24},
      {y=-33,x=21.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=-23.333333333333,x=32.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=-0.33333333333333,x=-3,purpose="vulnerability",type="circle",radius=18},
      {y=25,x=-12,purpose="vulnerability",type="circle",radius=15},
      {y=45,x=-19.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=61.333333333333,x=-36,purpose="vulnerability",type="circle",radius=15},
      {y=76.666666666667,x=-42.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=15,x=15,purpose="vulnerability",type="circle",radius=15},
      {y=32,x=22.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=50.333333333333,x=23,purpose="vulnerability",type="circle",radius=15},
      {y=69.666666666667,x=26.666666666667,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-42,x=42,purpose="defense",type="circle",radius=11},
      {y=-30.333333333333,x=16.666666666667,purpose="defense",type="circle",radius=11},
      {y=-64,x=7,purpose="vulnerability",type="circle",radius=23},
      {y=-23,x=-0.66666666666667,purpose="vulnerability",type="circle",radius=24},
      {y=-29.666666666667,x=24,purpose="vulnerability",type="circle",radius=12},
      {y=-21.333333333333,x=35.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=6.3333333333333,x=-2.3333333333333,purpose="vulnerability",type="circle",radius=18},
      {y=29,x=-10.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=49.333333333333,x=-16.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=61,x=-35.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=75.666666666667,x=-44.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=20,x=17.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=36.666666666667,x=26.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=56.666666666667,x=28,purpose="vulnerability",type="circle",radius=15},
      {y=70.666666666667,x=29.666666666667,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-48,x=45.666666666667,purpose="defense",type="circle",radius=11},
      {y=-41,x=13,purpose="defense",type="circle",radius=11},
      {y=-68,x=7.6666666666667,purpose="vulnerability",type="circle",radius=23},
      {y=-28.333333333333,x=-0.66666666666667,purpose="vulnerability",type="circle",radius=24},
      {y=-33.666666666667,x=28.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=-28,x=39.333333333333,purpose="vulnerability",type="circle",radius=12},
      {y=1.6666666666667,x=-3.3333333333333,purpose="vulnerability",type="circle",radius=18},
      {y=27,x=-12.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=46,x=-18,purpose="vulnerability",type="circle",radius=15},
      {y=61,x=-35.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=75,x=-42.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=17.666666666667,x=16.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=34,x=23.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=54,x=22.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=70.666666666667,x=29,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-53,x=47,purpose="defense",type="circle",radius=11},
      {y=-48.666666666667,x=8,purpose="defense",type="circle",radius=11},
      {y=-69.666666666667,x=6.3333333333333,purpose="vulnerability",type="circle",radius=23},
      {y=-30.333333333333,x=-2,purpose="vulnerability",type="circle",radius=24},
      {y=-36.666666666667,x=28.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=-34.666666666667,x=41,purpose="vulnerability",type="circle",radius=12},
      {y=0,x=-2,purpose="vulnerability",type="circle",radius=18},
      {y=23,x=-14.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=40.666666666667,x=-21,purpose="vulnerability",type="circle",radius=15},
      {y=56,x=-32.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=71.666666666667,x=-39.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=16.666666666667,x=15.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=32.666666666667,x=21.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=49.666666666667,x=20.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=67.666666666667,x=26,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-40.333333333333,x=43.333333333333,purpose="defense",type="circle",radius=11},
      {y=-35.333333333333,x=12,purpose="defense",type="circle",radius=11},
      {y=-65.666666666667,x=8,purpose="vulnerability",type="circle",radius=23},
      {y=-25.333333333333,x=-0.66666666666667,purpose="vulnerability",type="circle",radius=24},
      {y=-31.333333333333,x=24,purpose="vulnerability",type="circle",radius=12},
      {y=-23.333333333333,x=34.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=3.6666666666667,x=-2.3333333333333,purpose="vulnerability",type="circle",radius=18},
      {y=29.333333333333,x=-8.6666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=47,x=-13.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=63.666666666667,x=-27.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=79.333333333333,x=-36,purpose="vulnerability",type="circle",radius=15},
      {y=18.666666666667,x=15,purpose="vulnerability",type="circle",radius=15},
      {y=36.333333333333,x=19.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=54.666666666667,x=17.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=70.333333333333,x=19,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-32,x=36.666666666667,purpose="defense",type="circle",radius=10},
      {y=-21.666666666667,x=13.666666666667,purpose="defense",type="circle",radius=10},
      {y=-63.333333333333,x=8,purpose="vulnerability",type="circle",radius=23},
      {y=-22,x=-1,purpose="vulnerability",type="circle",radius=24},
      {y=-27.333333333333,x=18.333333333333,purpose="vulnerability",type="circle",radius=12},
      {y=-16.666666666667,x=26.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=5.3333333333333,x=-2,purpose="vulnerability",type="circle",radius=18},
      {y=25,x=7,purpose="vulnerability",type="circle",radius=21},
      {y=42,x=19,purpose="vulnerability",type="circle",radius=15},
      {y=53.333333333333,x=-6.6666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=69.333333333333,x=-19,purpose="vulnerability",type="circle",radius=15},
      {y=80,x=-26,purpose="vulnerability",type="circle",radius=15},
      {y=62.666666666667,x=15.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=72,x=14,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-35.333333333333,x=26.666666666667,purpose="defense",type="circle",radius=15},
      {y=-25,x=0.66666666666667,purpose="vulnerability",type="circle",radius=24},
      {y=-20,x=26,purpose="vulnerability",type="circle",radius=12},
      {y=-65.666666666667,x=7.6666666666667,purpose="vulnerability",type="circle",radius=23},
      {y=8.6666666666667,x=0,purpose="vulnerability",type="circle",radius=18},
      {y=32,x=4.6666666666667,purpose="vulnerability",type="circle",radius=21},
      {y=69.333333333333,x=-7.6666666666667,purpose="vulnerability",type="circle",radius=21},
      {y=49.666666666667,x=7,purpose="vulnerability",type="circle",radius=12}
    },
    {
      {y=-44,x=24,purpose="defense",type="circle",radius=15},
      {y=-68.666666666667,x=8,purpose="vulnerability",type="circle",radius=24},
      {y=-27.333333333333,x=1.3333333333333,purpose="vulnerability",type="circle",radius=24},
      {y=-24,x=28,purpose="vulnerability",type="circle",radius=12},
      {y=1.3333333333333,x=-2.6666666666667,purpose="vulnerability",type="circle",radius=18},
      {y=23.333333333333,x=0.66666666666667,purpose="vulnerability",type="circle",radius=18},
      {y=52,x=-5.3333333333333,purpose="vulnerability",type="circle",radius=21},
      {y=81,x=-6.6666666666667,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-36.666666666667,x=24.666666666667,purpose="defense",type="circle",radius=15},
      {y=-66.666666666667,x=8.3333333333333,purpose="vulnerability",type="circle",radius=23},
      {y=-25,x=0.33333333333333,purpose="vulnerability",type="circle",radius=24},
      {y=-19,x=27.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=7.3333333333333,x=0,purpose="vulnerability",type="circle",radius=18},
      {y=27,x=5.3333333333333,purpose="vulnerability",type="circle",radius=18},
      {y=51,x=0.33333333333333,purpose="vulnerability",type="circle",radius=18},
      {y=74,x=-9.3333333333333,purpose="vulnerability",type="circle",radius=18},
      {y=41.333333333333,x=13,purpose="vulnerability",type="circle",radius=12}
    },
    {
      {y=-33.666666666667,x=31,purpose="defense",type="circle",radius=11},
      {y=-22.666666666667,x=14,purpose="defense",type="circle",radius=11},
      {y=-62.666666666667,x=7,purpose="vulnerability",type="circle",radius=23},
      {y=-22,x=0.33333333333333,purpose="vulnerability",type="circle",radius=24},
      {y=-16.666666666667,x=24.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=6.6666666666667,x=-1,purpose="vulnerability",type="circle",radius=18},
      {y=30.333333333333,x=7,purpose="vulnerability",type="circle",radius=24},
      {y=51,x=16,purpose="vulnerability",type="circle",radius=15},
      {y=72,x=14.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=59.333333333333,x=-14,purpose="vulnerability",type="circle",radius=15},
      {y=80,x=-26.666666666667,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-37.333333333333,x=35.333333333333,purpose="defense",type="circle",radius=11},
      {y=-28.666666666667,x=12.333333333333,purpose="defense",type="circle",radius=11},
      {y=-65.333333333333,x=8,purpose="vulnerability",type="circle",radius=23},
      {y=-26.666666666667,x=0,purpose="vulnerability",type="circle",radius=24},
      {y=-20,x=28.666666666667,purpose="vulnerability",type="circle",radius=12},
      {y=4.6666666666667,x=0,purpose="vulnerability",type="circle",radius=18},
      {y=30,x=-7.3333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=51.333333333333,x=-15.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=68,x=-30,purpose="vulnerability",type="circle",radius=15},
      {y=77.666666666667,x=-33,purpose="vulnerability",type="circle",radius=15},
      {y=21.333333333333,x=17.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=40.666666666667,x=20.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=60,x=17.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=72,x=20.666666666667,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=24,x=22,purpose="defense",type="circle",radius=15},
      {y=-54,x=28,purpose="defense",type="circle",radius=12},
      {y=-72.333333333333,x=-6.3333333333333,purpose="vulnerability",type="circle",radius=24},
      {y=-29.333333333333,x=-12.333333333333,purpose="vulnerability",type="circle",radius=27},
      {y=-36.333333333333,x=19.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=16,x=-5,purpose="vulnerability",type="circle",radius=27},
      {y=46.666666666667,x=19.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=61,x=25,purpose="vulnerability",type="circle",radius=15},
      {y=46,x=-28,purpose="vulnerability",type="circle",radius=15},
      {y=62.666666666667,x=-38,purpose="vulnerability",type="circle",radius=15},
      {y=80.333333333333,x=-38.666666666667,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-29,x=77.666666666667,purpose="attack",type="circle",radius=10},
      {y=-15.333333333333,x=69.333333333333,purpose="attack",type="circle",radius=15},
      {y=-15.666666666667,x=48.333333333333,purpose="attack",type="circle",radius=15},
      {y=-14,x=28.333333333333,purpose="attack",type="circle",radius=15},
      {y=-36.333333333333,x=29,purpose="defense",type="circle",radius=10},
      {y=-77.666666666667,x=-10,purpose="vulnerability",type="circle",radius=24},
      {y=-31.333333333333,x=-10.333333333333,purpose="vulnerability",type="circle",radius=30},
      {y=-35.666666666667,x=-33,purpose="vulnerability",type="circle",radius=18},
      {y=-6.6666666666667,x=-37.333333333333,purpose="vulnerability",type="circle",radius=18},
      {y=12.666666666667,x=-22,purpose="vulnerability",type="circle",radius=15},
      {y=32.666666666667,x=-30,purpose="vulnerability",type="circle",radius=15},
      {y=51.333333333333,x=-36,purpose="vulnerability",type="circle",radius=15},
      {y=76,x=-38,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=10,x=36.333333333333,purpose="defense",type="circle",radius=15},
      {y=-72.666666666667,x=-7.3333333333333,purpose="vulnerability",type="circle",radius=24},
      {y=-31.333333333333,x=-12,purpose="vulnerability",type="circle",radius=30},
      {y=-6.6666666666667,x=-4.6666666666667,purpose="vulnerability",type="circle",radius=21},
      {y=18,x=-20,purpose="vulnerability",type="circle",radius=15},
      {y=40,x=-31.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=60,x=-41.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=76.666666666667,x=-44.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=-0.66666666666667,x=19.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=31.333333333333,x=30.666666666667,purpose="vulnerability",type="circle",radius=15},
      {y=48.666666666667,x=30.666666666667,purpose="vulnerability",type="circle",radius=15}
    },
    {
      {y=-65,x=-2.3333333333333,purpose="vulnerability",type="circle",radius=24},
      {y=-22.666666666667,x=-10,purpose="vulnerability",type="circle",radius=30},
      {y=2,x=-4,purpose="vulnerability",type="circle",radius=21},
      {y=-8.6666666666667,x=20,purpose="vulnerability",type="circle",radius=12},
      {y=27.666666666667,x=15.333333333333,purpose="vulnerability",type="circle",radius=24},
      {y=59.333333333333,x=24.666666666667,purpose="vulnerability",type="circle",radius=18},
      {y=30,x=-17.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=51.333333333333,x=-22,purpose="vulnerability",type="circle",radius=15},
      {y=66.666666666667,x=-37.333333333333,purpose="vulnerability",type="circle",radius=15},
      {y=79.666666666667,x=-44.666666666667,purpose="vulnerability",type="circle",radius=15}
    }
}

function BidenSpriteInfo:getSheet()
    return self.sheet;
end

function BidenSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return BidenSpriteInfo