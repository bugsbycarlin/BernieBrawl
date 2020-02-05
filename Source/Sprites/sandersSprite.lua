local sandersSpriteInfo = {}

sandersSpriteInfo.sheet =
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
            x=1536,
            y=512,
            width=256,
            height=256,

        },
        {
            x=1792,
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
            x=1536,
            y=768,
            width=256,
            height=256,

        },
        {
            x=1792,
            y=768,
            width=256,
            height=256,

        },
        {
            x=0,
            y=1024,
            width=256,
            height=256,

        },
        {
            x=256,
            y=1024,
            width=256,
            height=256,

        },
        {
            x=512,
            y=1024,
            width=256,
            height=256,

        },
        {
            x=768,
            y=1024,
            width=256,
            height=256,

        },
    },

    sheetContentWidth = 2048,
    sheetContentHeight = 2048,
}


-- 256, 512, 768, 1024, 1280, 1536, 1792, 2048, 2304, 2560, 2816, 3072, 3328, 3584, 3840, 4096, 4352, 4608, 4864
-- 384, 768, 1152, 1536, 1920, 2304, 2688, 3072, 3456, 3840, 4224, 4608, 4992, 5376, 5760, 6144, 6528, 6912, 729

-- resting frames: 1 - 8
-- punching frames: 9 - 19
-- slap punching: 20, 21
-- jumping: 22 up, 23 kick, 24 down
-- wild kicking: 25, 26, 27, 28 (starts and ends on the main resting frame, frame 1)
-- celebrating: 29
-- blocking: 30
-- damage: 31
-- dizzy: 32
-- ko: 33
-- summoning special: 34, 35, 36

sandersSpriteInfo.hitIndex = 
{
  {
    {x=-3.3333333333333,y=-67,type="circle",purpose="vulnerability",radius=24},
    {x=-11.666666666667,y=-28.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=-13,y=11.333333333333,type="circle",purpose="vulnerability",radius=27},
    {x=10,y=38.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=16,y=62,type="circle",purpose="vulnerability",radius=15},
    {x=28.333333333333,y=78.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-23,y=42.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-26.666666666667,y=69.333333333333,type="circle",purpose="vulnerability",radius=18},
    {x=24.666666666667,y=-29.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=48,y=-43,type="circle",purpose="vulnerability",radius=12},
  },
  {
    {x=1,y=-66,type="circle",purpose="vulnerability",radius=24},
    {x=-8.6666666666667,y=-30.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=26.666666666667,y=-29.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=49.666666666667,y=-37.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-12.333333333333,y=7,type="circle",purpose="vulnerability",radius=27},
    {x=10.333333333333,y=33,type="circle",purpose="vulnerability",radius=15},
    {x=16.333333333333,y=56.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=24.333333333333,y=78.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-23.333333333333,y=41,type="circle",purpose="vulnerability",radius=12},
    {x=-27.333333333333,y=62.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=-28.666666666667,y=79,type="circle",purpose="vulnerability",radius=12},
  },
  {
    {x=3.6666666666667,y=-66.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-7.6666666666667,y=-28.333333333333,type="circle",purpose="vulnerability",radius=27},
    {x=28.666666666667,y=-30,type="circle",purpose="vulnerability",radius=21},
    {x=56.666666666667,y=-36,type="circle",purpose="vulnerability",radius=12},
    {x=-10,y=5.6666666666667,type="circle",purpose="vulnerability",radius=27},
   {x=-20.666666666667,y=41.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-24.666666666667,y=68,type="circle",purpose="vulnerability",radius=18},
    {x=12.333333333333,y=32,type="circle",purpose="vulnerability",radius=15},
    {x=16,y=57.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=24,y=76,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=4,y=-66.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=-6,y=-24.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=32.666666666667,y=-32.333333333333,type="circle",purpose="vulnerability",radius=21},
    {x=59.333333333333,y=-33.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-7.3333333333333,y=13.333333333333,type="circle",purpose="vulnerability",radius=27},
    {x=-20,y=45.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=-27,y=67.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=16.333333333333,y=34.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=19,y=56.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=25,y=76.666666666667,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=8,y=-65.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-4.6666666666667,y=-26.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=33,y=-35.333333333333,type="circle",purpose="vulnerability",radius=21},
    {x=61,y=-36.666666666667,type="circle",purpose="vulnerability",radius=9},
    {x=-5,y=10.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=17,y=34.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=20.333333333333,y=56,type="circle",purpose="vulnerability",radius=15},
    {x=25.333333333333,y=78,type="circle",purpose="vulnerability",radius=15},
    {x=-19.666666666667,y=41.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-25.666666666667,y=57.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-29.666666666667,y=75,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=4,y=-64.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=-5.3333333333333,y=-27,type="circle",purpose="vulnerability",radius=27},
    {x=32,y=-31.333333333333,type="circle",purpose="vulnerability",radius=21},
    {x=60,y=-31.333333333333,type="circle",purpose="vulnerability",radius=9},
    {x=-6.3333333333333,y=11,type="circle",purpose="vulnerability",radius=27},
    {x=14.333333333333,y=36,type="circle",purpose="vulnerability",radius=15},
    {x=18.666666666667,y=58.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=24.666666666667,y=77.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-20.666666666667,y=42.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=-29,y=69,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=2,y=-65.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=-6.6666666666667,y=-29.333333333333,type="circle",purpose="vulnerability",radius=27},
    {x=-9,y=7.6666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=32,y=-31.333333333333,type="circle",purpose="vulnerability",radius=21},
    {x=56.666666666667,y=-36.666666666667,type="circle",purpose="vulnerability",radius=9},
    {x=-20.333333333333,y=39.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-25.333333333333,y=61.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=-27.333333333333,y=80,type="circle",purpose="vulnerability",radius=12},
    {x=11.333333333333,y=32.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=16.333333333333,y=51.666666666667,type="circle",purpose="vulnerability",radius=15},
{x=24.666666666667,y=74,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=0,y=-67,type="circle",purpose="vulnerability",radius=24},
    {x=-9.6666666666667,y=-30,type="circle",purpose="vulnerability",radius=27},
    {x=-11.666666666667,y=5.3333333333333,type="circle",purpose="vulnerability",radius=27},
    {x=26,y=-30,type="circle",purpose="vulnerability",radius=18},
    {x=52.666666666667,y=-40,type="circle",purpose="vulnerability",radius=12},
    {x=-22,y=38.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-25.666666666667,y=60,type="circle",purpose="vulnerability",radius=15},
    {x=-29.333333333333,y=75.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=6,y=27.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=13,y=46,type="circle",purpose="vulnerability",radius=15},
    {x=18.666666666667,y=69.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=30.333333333333,y=80,type="circle",purpose="vulnerability",radius=12},
  },
  {
    {x=-2,y=-68.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-11.333333333333,y=-31,type="circle",purpose="vulnerability",radius=27},
    {x=-13,y=6,type="circle",purpose="vulnerability",radius=27},
    {x=26,y=-28,type="circle",purpose="vulnerability",radius=15},
    {x=46,y=-43.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-25,y=37.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-25.333333333333,y=57.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-31.666666666667,y=76.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=10.666666666667,y=28.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=14.666666666667,y=46,type="circle",purpose="vulnerability",radius=12},
    {x=18,y=65.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=28,y=80.666666666667,type="circle",purpose="vulnerability",radius=12},
  },
  {
    {x=37.333333333333,y=-35.333333333333,type="circle",purpose="vulnerability",radius=9},
    {x=-3.6666666666667,y=-67,type="circle",purpose="vulnerability",radius=24},
    {x=-12,y=-29.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=-13,y=8,type="circle",purpose="vulnerability",radius=27},
    {x=23,y=-28.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=49,y=-43,type="circle",purpose="vulnerability",radius=9},
    {x=-25.666666666667,y=39.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-28,y=59,type="circle",purpose="vulnerability",radius=12},
    {x=-31,y=75.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=10,y=32.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=13.333333333333,y=49.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=17.333333333333,y=68,type="circle",purpose="vulnerability",radius=12},
    {x=30,y=77.666666666667,type="circle",purpose="vulnerability",radius=12},
  },
  {
    {x=0.66666666666667,y=-65.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=22.333333333333,y=-39.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=54,y=-43.333333333333,type="circle",purpose="vulnerability",radius=9},
    {x=-12,y=-26,type="circle",purpose="vulnerability",radius=27},
    {x=-10.333333333333,y=11.333333333333,type="circle",purpose="vulnerability",radius=27},
    {x=-22.333333333333,y=43.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-27.666666666667,y=59.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-28.666666666667,y=79.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=12,y=28.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=16.666666666667,y=46,type="circle",purpose="vulnerability",radius=12},
    {x=20.333333333333,y=65.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=26.666666666667,y=80,type="circle",purpose="vulnerability",radius=12},
  },
  {
    {x=42.666666666667,y=-33.666666666667,type="circle",purpose="vulnerability",radius=9},
    {x=56,y=-40,type="circle",purpose="vulnerability",radius=9},
    {x=5,y=-68.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-3.3333333333333,y=-30.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=32.666666666667,y=-25.666666666667,type="circle",purpose="vulnerability",radius=9},
    {x=24.666666666667,y=-14.666666666667,type="circle",purpose="vulnerability",radius=9},
    {x=-5.6666666666667,y=5.3333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=14,y=26.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=18,y=42,type="circle",purpose="vulnerability",radius=12},
    {x=19,y=62,type="circle",purpose="vulnerability",radius=12},
    {x=27,y=79.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-19,y=33.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-25.666666666667,y=50.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-30.666666666667,y=66.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-30,y=80,type="circle",purpose="vulnerability",radius=10},
  },
  {
    {x=19.333333333333,y=59,type="circle",purpose="vulnerability",radius=15},
{x=30,y=78,type="circle",purpose="vulnerability",radius=12},
    {x=-16,y=32.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-23.333333333333,y=49.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-29.333333333333,y=65.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-30,y=83.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=10.333333333333,y=-66.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=71.333333333333,y=-38,type="circle",purpose="attack",radius=10},
    {x=56.333333333333,y=-37.333333333333,type="circle",purpose="attack",radius=10},
    {x=42.666666666667,y=-36.666666666667,type="circle",purpose="attack",radius=10},
    {x=30.666666666667,y=-37.333333333333,type="circle",purpose="attack",radius=10},
    {x=44.666666666667,y=-24.333333333333,type="circle",purpose="attack",radius=10},
    {x=32.666666666667,y=-18.666666666667,type="circle",purpose="attack",radius=10},
    {x=-1,y=-31.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-5,y=4,type="circle",purpose="vulnerability",radius=24},
    {x=11,y=24.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=18,y=40.666666666667,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=56.666666666667,y=-52.666666666667,type="circle",purpose="attack",radius=10},
    {x=44,y=-46,type="circle",purpose="attack",radius=10},
    {x=36,y=-36,type="circle",purpose="attack",radius=15},
    {x=6,y=-68,type="circle",purpose="vulnerability",radius=24},
    {x=-2,y=-31.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=30,y=-19.666666666667,type="circle",purpose="attack",radius=10},
    {x=-6,y=6,type="circle",purpose="vulnerability",radius=24},
    {x=-18.333333333333,y=34,type="circle",purpose="vulnerability",radius=12},
    {x=-24,y=52.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-29.666666666667,y=67,type="circle",purpose="vulnerability",radius=12},
    {x=-29.333333333333,y=78.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=12.666666666667,y=23.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=17.333333333333,y=39,type="circle",purpose="vulnerability",radius=15},
    {x=20,y=62.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=24.666666666667,y=79.666666666667,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=5.3333333333333,y=-66,type="circle",purpose="vulnerability",radius=24},
    {x=29.333333333333,y=-68.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=31.333333333333,y=-45,type="circle",purpose="vulnerability",radius=15},
    {x=-5.6666666666667,y=-29.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=-6.6666666666667,y=8.3333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-20.333333333333,y=36.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-25,y=57,type="circle",purpose="vulnerability",radius=12},
    {x=-30.666666666667,y=76.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=13.333333333333,y=27.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=18,y=43.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=19,y=63.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=27.333333333333,y=79.333333333333,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=13.333333333333,y=-66.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=0,y=-31.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-2.6666666666667,y=5,type="circle",purpose="vulnerability",radius=27},
    {x=31.333333333333,y=-40,type="circle",purpose="attack",radius=15},
    {x=50,y=-41,type="circle",purpose="attack",radius=10},
    {x=65.666666666667,y=-38.666666666667,type="circle",purpose="attack",radius=10},
    {x=78.333333333333,y=-39.666666666667,type="circle",purpose="attack",radius=10},
    {x=91.666666666667,y=-41.666666666667,type="circle",purpose="attack",radius=10},
    {x=-15.666666666667,y=36,type="circle",purpose="vulnerability",radius=12},
    {x=-22,y=53,type="circle",purpose="vulnerability",radius=12},
    {x=-28.333333333333,y=69,type="circle",purpose="vulnerability",radius=12},
    {x=-27.333333333333,y=81.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=20,y=27,type="circle",purpose="vulnerability",radius=12},
    {x=22.333333333333,y=42,type="circle",purpose="vulnerability",radius=15},
    {x=23,y=63.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=28.666666666667,y=79.333333333333,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=18.666666666667,y=41.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=8.3333333333333,y=-67.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-1,y=-33,type="circle",purpose="vulnerability",radius=24},
    {x=28,y=-34,type="circle",purpose="vulnerability",radius=15},
    {x=47.333333333333,y=-24.666666666667,type="circle",purpose="attack",radius=10},
    {x=59.333333333333,y=-32,type="circle",purpose="attack",radius=10},
    {x=74.666666666667,y=-36.666666666667,type="circle",purpose="attack",radius=10},
    {x=-4.6666666666667,y=4,type="circle",purpose="vulnerability",radius=24},
    {x=12.666666666667,y=23.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=19.666666666667,y=64,type="circle",purpose="vulnerability",radius=15},
    {x=27,y=79.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=-16.666666666667,y=33.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-23,y=53,type="circle",purpose="vulnerability",radius=12},
    {x=-28.666666666667,y=71.666666666667,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=4,y=-65.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-4.6666666666667,y=-30.333333333333,type="circle",purpose="vulnerability",radius=27},
    {x=-8.6666666666667,y=8,type="circle",purpose="vulnerability",radius=27},
    {x=32,y=-30.666666666667,type="circle",purpose="vulnerability",radius=18},
    {x=52,y=-42,type="circle",purpose="vulnerability",radius=9},
    {x=-19.666666666667,y=42.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-28.666666666667,y=60,type="circle",purpose="vulnerability",radius=12},
    {x=-29.333333333333,y=77.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=13.666666666667,y=26.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=16.333333333333,y=44.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=19,y=65,type="circle",purpose="vulnerability",radius=15},
    {x=28,y=78.666666666667,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=-4.3333333333333,y=-66.333333333333,type="circle",purpose="vulnerability",radius=24},
{x=-12,y=-28,type="circle",purpose="vulnerability",radius=27},
    {x=-14.333333333333,y=6.3333333333333,type="circle",purpose="vulnerability",radius=27},
    {x=-24,y=36.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-28,y=55,type="circle",purpose="vulnerability",radius=12},
    {x=-30,y=76.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=8,y=26.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=11,y=41,type="circle",purpose="vulnerability",radius=15},
    {x=16.333333333333,y=64,type="circle",purpose="vulnerability",radius=15},
    {x=28,y=78.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=24.666666666667,y=-32.666666666667,type="circle",purpose="vulnerability",radius=18},
    {x=47.333333333333,y=-43,type="circle",purpose="vulnerability",radius=10},
  },
  {
    {x=9.6666666666667,y=-65.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=25.333333333333,y=-40.666666666667,type="circle",purpose="attack",radius=10},
    {x=38,y=-35.333333333333,type="circle",purpose="attack",radius=10},
    {x=52,y=-37.333333333333,type="circle",purpose="attack",radius=10},
    {x=71,y=-39.333333333333,type="circle",purpose="attack",radius=15},
    {x=0.66666666666667,y=-30.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=28.666666666667,y=-14.666666666667,type="circle",purpose="attack",radius=10},
    {x=-2.3333333333333,y=2.3333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-15.333333333333,y=30.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=-26.666666666667,y=50.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-38,y=66.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=14.333333333333,y=26.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=20,y=40.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=20.333333333333,y=60.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=26,y=77.333333333333,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=17.333333333333,y=-64.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=46.666666666667,y=-57.333333333333,type="circle",purpose="attack",radius=10},
    {x=44.666666666667,y=-42.666666666667,type="circle",purpose="attack",radius=10},
    {x=9,y=-32,type="circle",purpose="vulnerability",radius=24},
    {x=2.3333333333333,y=6,type="circle",purpose="vulnerability",radius=24},
    {x=-15.333333333333,y=30.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=-26.666666666667,y=47.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=-34.666666666667,y=61.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=21.333333333333,y=29.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=23,y=45,type="circle",purpose="vulnerability",radius=15},
    {x=22.666666666667,y=68.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=33.333333333333,y=81.333333333333,type="circle",purpose="vulnerability",radius=9},
  },
  {
    {x=31.333333333333,y=60.666666666667,type="circle",purpose="defense",radius=15},
    {x=37.333333333333,y=38.666666666667,type="circle",purpose="defense",radius=15},
    {x=49.333333333333,y=20.333333333333,type="circle",purpose="defense",radius=14},
    {x=28,y=14.666666666667,type="circle",purpose="defense",radius=15},
    {x=19.333333333333,y=-65.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=7.3333333333333,y=-26.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=52.666666666667,y=-39.333333333333,type="circle",purpose="vulnerability",radius=9},
    {x=41.333333333333,y=-27.333333333333,type="circle",purpose="vulnerability",radius=12},
    {x=46,y=-66.666666666667,type="circle",purpose="vulnerability",radius=9},
    {x=0.33333333333333,y=1,type="circle",purpose="vulnerability",radius=24},
    {x=-10.666666666667,y=28.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=-22,y=50,type="circle",purpose="vulnerability",radius=12},
    {x=-28,y=68,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=78.666666666667,y=5.3333333333333,type="circle",purpose="attack",radius=15},
    {x=54.666666666667,y=6,type="circle",purpose="attack",radius=15},
    {x=30,y=6.6666666666667,type="circle",purpose="attack",radius=15},
    {x=-0.66666666666667,y=-66.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=-6.6666666666667,y=-26.333333333333,type="circle",purpose="vulnerability",radius=27},
    {x=29.333333333333,y=-19.666666666667,type="circle",purpose="vulnerability",radius=21},
    {x=58.666666666667,y=-30.666666666667,type="circle",purpose="vulnerability",radius=12},
    {x=-9.3333333333333,y=10.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=-31.333333333333,y=41.333333333333,type="circle",purpose="vulnerability",radius=18},
    {x=-13.333333333333,y=58.666666666667,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=-2,y=-64.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=24.333333333333,y=72,type="circle",purpose="defense",radius=15},
    {x=20,y=46.666666666667,type="circle",purpose="defense",radius=15},
    {x=18.666666666667,y=31.333333333333,type="circle",purpose="defense",radius=15},
    {x=-14.333333333333,y=8,type="circle",purpose="vulnerability",radius=27},
    {x=-26.666666666667,y=41,type="circle",purpose="vulnerability",radius=15},
    {x=-42,y=63,type="circle",purpose="vulnerability",radius=18},
    {x=-13.333333333333,y=-26.666666666667,type="circle",purpose="vulnerability",radius=30},
    {x=21.333333333333,y=-27,type="circle",purpose="vulnerability",radius=15},
    {x=37.666666666667,y=-47,type="circle",purpose="vulnerability",radius=12},
  },
  {
    {x=6,y=-35,type="circle",purpose="vulnerability",radius=24},
    {x=-7,y=-3.6666666666667,type="circle",purpose="vulnerability",radius=27},
     {x=7.6666666666667,y=29.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=-23.333333333333,y=27.333333333333,type="circle",purpose="vulnerability",radius=18},
    {x=28.333333333333,y=48.333333333333,type="circle",purpose="vulnerability",radius=15},
    {x=14.666666666667,y=69.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=26,y=80.333333333333,type="circle",purpose="vulnerability",radius=9},
    {x=-34.333333333333,y=51,type="circle",purpose="vulnerability",radius=15},
    {x=-30.333333333333,y=73.666666666667,type="circle",purpose="vulnerability",radius=15},
  },
  {
    {x=17.333333333333,y=-17.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=-1.3333333333333,y=11,type="circle",purpose="vulnerability",radius=30},
    {x=20,y=38.333333333333,type="circle",purpose="vulnerability",radius=18},
    {x=19.666666666667,y=70.333333333333,type="circle",purpose="vulnerability",radius=18},
    {x=-27.333333333333,y=42,type="circle",purpose="vulnerability",radius=18},
    {x=-29,y=67.333333333333,type="circle",purpose="vulnerability",radius=18},
  },
  {
    {x=64.666666666667,y=-28,type="circle",purpose="attack",radius=10},
    {x=63.333333333333,y=-10.666666666667,type="circle",purpose="attack",radius=10},
    {x=61.333333333333,y=14.666666666667,type="circle",purpose="attack",radius=21},
    {x=76.666666666667,y=40.333333333333,type="circle",purpose="attack",radius=18},
    {x=84.666666666667,y=4,type="circle",purpose="attack",radius=9},
    {x=32.333333333333,y=31.333333333333,type="circle",purpose="vulnerability",radius=24},
    {x=-10,y=48.666666666667,type="circle",purpose="vulnerability",radius=24},
    {x=6,y=21.333333333333,type="circle",purpose="vulnerability",radius=9},
    {x=20.666666666667,y=67.666666666667,type="circle",purpose="vulnerability",radius=18},
    {x=-2.6666666666667,y=77,type="circle",purpose="vulnerability",radius=12},
    {x=-20,y=76.666666666667,type="circle",purpose="vulnerability",radius=9},
  },
  {
    {x=119,y=5,type="circle",purpose="attack",radius=9},
    {x=87.666666666667,y=-8.6666666666667,type="circle",purpose="attack",radius=24},
    {x=102.33333333333,y=-23.333333333333,type="circle",purpose="attack",radius=12},
    {x=109.66666666667,y=-3,type="circle",purpose="attack",radius=12},
    {x=70,y=2.3333333333333,type="circle",purpose="attack",radius=24},
    {x=42.333333333333,y=-11,type="circle",purpose="vulnerability",radius=12},
    {x=51,y=21.333333333333,type="circle",purpose="vulnerability",radius=9},
    {x=29.333333333333,y=12,type="circle",purpose="vulnerability",radius=24},
    {x=3.3333333333333,y=29,type="circle",purpose="vulnerability",radius=24},
    {x=-17.333333333333,y=55.666666666667,type="circle",purpose="vulnerability",radius=27},
    {x=7.6666666666667,y=56,type="circle",purpose="vulnerability",radius=12},
    {x=-45,y=72.666666666667,type="circle",purpose="vulnerability",radius=15},
    {x=6,y=4.3333333333333,type="circle",purpose="vulnerability",radius=9},
  },
  {  
  },
}

function sandersSpriteInfo:getSheet()
    return self.sheet;
end

function sandersSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return sandersSpriteInfo