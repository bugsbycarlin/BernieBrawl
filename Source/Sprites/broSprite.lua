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
      {x=42.666666666667,y=-28,type="circle",purpose="attack",radius=9},
      {x=58.666666666667,y=-29,type="circle",purpose="attack",radius=10},
      {x=-0.66666666666667,y=-52.333333333333,type="circle",purpose="vulnerability",radius=21},
      {x=20.666666666667,y=-26,type="circle",purpose="attack",radius=9},
      {x=32.666666666667,y=-27.666666666667,type="circle",purpose="attack",radius=9},
      {x=-9.6666666666667,y=-16.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=-12.333333333333,y=15.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=3.3333333333333,y=38.666666666667,type="circle",purpose="vulnerability",radius=12},
      {x=4.6666666666667,y=53.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=6.6666666666667,y=70.666666666667,type="circle",purpose="vulnerability",radius=12},
      {x=19.666666666667,y=76.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=-25,y=37,type="circle",purpose="vulnerability",radius=12},
      {x=-28,y=51.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=-30.333333333333,y=64,type="circle",purpose="vulnerability",radius=9},
      {x=-34.666666666667,y=78.666666666667,type="circle",purpose="vulnerability",radius=9},
    },
    {
      {x=0.66666666666667,y=-53,type="circle",purpose="vulnerability",radius=21},
      {x=-11.333333333333,y=-14.333333333333,type="circle",purpose="vulnerability",radius=24},
      {x=18.666666666667,y=-12.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=29.666666666667,y=-26.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=-12.333333333333,y=17.333333333333,type="circle",purpose="vulnerability",radius=18},
      {x=5,y=37.333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=2.6666666666667,y=54,type="circle",purpose="vulnerability",radius=9},
      {x=2,y=70.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=12,y=78,type="circle",purpose="vulnerability",radius=9},
      {x=-24.333333333333,y=38,type="circle",purpose="vulnerability",radius=9},
      {x=-32.333333333333,y=51.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=-43.666666666667,y=62,type="circle",purpose="vulnerability",radius=9},
      {x=-36.666666666667,y=77.666666666667,type="circle",purpose="vulnerability",radius=9},
    },
    {
      {x=2.6666666666667,y=-49.333333333333,type="circle",purpose="vulnerability",radius=21},
      {x=-13.666666666667,y=-16,type="circle",purpose="vulnerability",radius=24},
      {x=14,y=-11.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=24.666666666667,y=-16,type="circle",purpose="vulnerability",radius=9},
      {x=36,y=-27.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=-18,y=18,type="circle",purpose="vulnerability",radius=18},
      {x=4.6666666666667,y=35.333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=0,y=51.333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=-4,y=68,type="circle",purpose="vulnerability",radius=12},
      {x=6.6666666666667,y=80,type="circle",purpose="vulnerability",radius=9},
      {x=-29.333333333333,y=82.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=-27.333333333333,y=69.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=-28.666666666667,y=52.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=-24,y=38.666666666667,type="circle",purpose="vulnerability",radius=9},
    },
    {
      {x=1.3333333333333,y=-53,type="circle",purpose="vulnerability",radius=21},
      {x=-13,y=-12.666666666667,type="circle",purpose="vulnerability",radius=24},
      {x=9.3333333333333,y=-19.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=17.333333333333,y=-11.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=27.333333333333,y=-18.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=36,y=-32.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=-13.333333333333,y=17,type="circle",purpose="vulnerability",radius=18},
      {x=3.3333333333333,y=39.333333333333,type="circle",purpose="vulnerability",radius=12},
      {x=4.6666666666667,y=52.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=4.6666666666667,y=68,type="circle",purpose="vulnerability",radius=9},
      {x=16,y=78.666666666667,type="circle",purpose="vulnerability",radius=9},
      {x=-32,y=81.333333333333,type="circle",purpose="vulnerability",radius=9},
      {x=-32.666666666667,y=68,type="circle",purpose="vulnerability",radius=9},
      {x=-27.333333333333,y=52,type="circle",purpose="vulnerability",radius=9},
      {x=-24,y=36,type="circle",purpose="vulnerability",radius=12},
    },
}

function broSpriteInfo:getSheet()
    return self.sheet;
end

function broSpriteInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return broSpriteInfo