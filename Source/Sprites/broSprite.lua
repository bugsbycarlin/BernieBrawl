local broSpriteInfo = {}

broSpriteInfo.sheet =
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
    },

    sheetContentWidth = 1024,
    sheetContentHeight = 256
}

broSpriteInfo.hitIndex = 
{
    {
      {x=-0.33333333333333,y=-58.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=2.3333333333333,y=-41.666666666667,type="circle",purpose="vulnerability",radius=16},
      {x=-12.333333333333,y=-18,type="circle",purpose="vulnerability",radius=20},
      {x=-14,y=9.3333333333333,type="circle",purpose="vulnerability",radius=19},
      {x=0.33333333333333,y=30.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=3.3333333333333,y=44.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=3.6666666666667,y=59.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=6.6666666666667,y=76.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=17.666666666667,y=78.333333333333,type="circle",purpose="vulnerability",radius=8},
      {x=-24.333333333333,y=32.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=-28.333333333333,y=48,type="circle",purpose="vulnerability",radius=10},
      {x=-29.666666666667,y=62.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=-32,y=80.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=60.333333333333,y=-29.666666666667,type="circle",purpose="attack",radius=7},
      {x=50.333333333333,y=-29.666666666667,type="circle",purpose="attack",radius=7},
      {x=39,y=-29.333333333333,type="circle",purpose="attack",radius=7},
      {x=27,y=-28.666666666667,type="circle",purpose="attack",radius=7},
      {x=15,y=-27.333333333333,type="circle",purpose="attack",radius=7},
    },
    {
      {x=0,y=-59.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=2.6666666666667,y=-40,type="circle",purpose="vulnerability",radius=16},
      {x=-9.6666666666667,y=-17.333333333333,type="circle",purpose="vulnerability",radius=20},
      {x=-13.666666666667,y=6.6666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=0.33333333333333,y=26.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=5.3333333333333,y=37.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=3,y=52.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=-1,y=69,type="circle",purpose="vulnerability",radius=10},
      {x=11,y=79.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=-23.333333333333,y=27.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=-25,y=41,type="circle",purpose="vulnerability",radius=10},
      {x=-32.666666666667,y=53.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=-41,y=67,type="circle",purpose="vulnerability",radius=10},
      {x=-34.333333333333,y=77,type="circle",purpose="vulnerability",radius=7},
    },
    {
      {x=1.6666666666667,y=-56.666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=1,y=-38.333333333333,type="circle",purpose="vulnerability",radius=16},
      {x=-12.666666666667,y=-17.333333333333,type="circle",purpose="vulnerability",radius=19},
      {x=-16.666666666667,y=7.6666666666667,type="circle",purpose="vulnerability",radius=18},
      {x=-3.6666666666667,y=26.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=4,y=37,type="circle",purpose="vulnerability",radius=10},
      {x=-0.33333333333333,y=51.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=-6,y=65.333333333333,type="circle",purpose="vulnerability",radius=10},
      {x=3.6666666666667,y=79.333333333333,type="circle",purpose="vulnerability",radius=8},
      {x=-25.666666666667,y=30,type="circle",purpose="vulnerability",radius=11},
      {x=-26.333333333333,y=46,type="circle",purpose="vulnerability",radius=9},
      {x=-27,y=60.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=-28.333333333333,y=78.666666666667,type="circle",purpose="vulnerability",radius=10},
    },
    {
      {x=0.66666666666667,y=-58,type="circle",purpose="vulnerability",radius=17},
      {x=1,y=-41.333333333333,type="circle",purpose="vulnerability",radius=17},
      {x=-12.333333333333,y=-16.333333333333,type="circle",purpose="vulnerability",radius=19},
      {x=-13.333333333333,y=7,type="circle",purpose="vulnerability",radius=18},
      {x=-11.666666666667,y=33.666666666667,type="circle",purpose="vulnerability",radius=23},
      {x=5,y=53.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=4,y=69.666666666667,type="circle",purpose="vulnerability",radius=10},
      {x=16,y=77.333333333333,type="circle",purpose="vulnerability",radius=8},
      {x=-30,y=53.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=-32.333333333333,y=66,type="circle",purpose="vulnerability",radius=8},
      {x=-34,y=78.333333333333,type="circle",purpose="vulnerability",radius=8},
    },
}

function broSpriteInfo:getSheet()
    return self.sheet;
end

function broSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return broSpriteInfo