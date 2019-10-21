Shader "spatial/spatial6_twist"
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


//Using Inigo's twist fucntion from:
//https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm




            // Folding Space, and *then* doing our sphere map
            float2 map( float3 pos ){

                float k = _Parameter1 * 6.28;

                float c = cos(k*pos.y);
                float s = sin(k*pos.y);
                float2x2  m = float2x2(c,-s,s,c);
                float2 xz = mul(m,pos.xz);
                float3 newPos = float3(xz,pos.y);
                float dist = sdBox( newPos ,float3(_Parameter2,_Parameter3,_Parameter4) );
                float2 cube = float2(dist,1);

                return cube;
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

