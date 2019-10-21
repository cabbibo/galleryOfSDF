Shader "spatial/spatial3_fractal"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _MaxSteps ("Max Steps", int) = 100
        _MaxDistance ("Max Distance", float) = 10
        _IntersectionPrecision ("Intersection Precision", float) = .01
        _NormalDelta ("Normal Delta", float) = .01

        _Parameter1("Parameter1",Range(0.0,1.0)) = 0
        _Parameter2("Parameter2",Range(0.0,1.0)) = 0
        _Parameter3("Parameter3",Range(0.0,1.0)) = 0
        _Parameter4("Parameter4",Range(0.0,1.0)) = 0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "../Chunks/sdfTopInclude.cginc"

            // new color functions
            #include "../Chunks/hsv.cginc"

float3 modit(float3 x, float y)
{
  return x - y * floor(x/y);
}


void pR(inout float2 p, float a) {
    p = cos(a)*p + sin(a)*float2(p.y, -p.x);
}


float length6( float3 p )
{
    p = p*p*p; p = p*p;
    return pow( p.x + p.y + p.z, 1.0/6.0 );
}


            // Folding Space, and *then* doing our sphere map
            float2 map( float3 pos ){


                float l = 0;
                float scale = 1.25;
                float3 offset = -float3(_Parameter1,_Parameter2,_Parameter3) * .2;

                // using an iteratively to move
                for (int i=0; i<floor(_Parameter1 * 10 +1); i++) {
                   
                    pos.xy = abs(pos.xy);
                    // scale and offset the position
                    pos = pos*1.2+ offset;
                    
                    // Rotate the position
                    float2 rotation = float2(1.2,.5);
                    pR(pos.xy,_Parameter4*3.14);
                    pR(pos.zx,_Parameter4*3.14);     

                    l=length(pos);//length6(pos);
                }

                // scaling space so we have better step sizes
                float2 sphere  = float2( l*pow(scale, -float(10))-.01 , 1);

                return sphere;
            }


            // Coloring different for each sphere using Hue Saturation Value function
            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){

                float3 col = nor * .5 + .5;
                
           

                return col;
            }

            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}
