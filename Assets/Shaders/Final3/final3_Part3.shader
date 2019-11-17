Shader "final/final3_part3"
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


                float l = 1110;
                float scale = 1.25;
                float3 offset = -float3(_Parameter1,_Parameter2,_Parameter3) * .2;

                float3 ogPos = pos;
         

                float2 rod;
                rod = float2(sdCapsule( ogPos- float3(0.2, 0 , 0 ), float3(0,0,3)  * 2, float3(0,-0,-3) * 2  , .03),6);
                //fractal = hardU(rod,fractal);
                rod = hardU(rod,float2(sdCapsule( ogPos - float3(0.2, .2 , 0 ), float3(0,0,3)  * 2, float3(0,-0,-3) * 2  , .03),6));
                rod = hardU(rod,float2(sdCapsule( ogPos - float3(0.2, -.2 , 0 ), float3(0,0,3)  * 2, float3(0,-0,-3) * 2  , .03),6));

              
                return rod;
            }


            // Coloring different for each sphere using Hue Saturation Value function
            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){

                float3 col = nor * .5 + .5;

                float m = dot( rd , nor );

                 if( id == 1 ){
                  col = hsv(.75,1,1);
                }else if( id == 2 ){
                  col = hsv(.4,0.5,.4);
                }else if( id == 3 ){
                  col =hsv(.9,1,.2);
                }else if( id == 4 ){
                  col = hsv(.8,1,.3);
                }else{
                  col = hsv(.1,.7,1);
                }

                col *= (1.3+m) + max(dot( nor , float3(1,1,0)),0);//nor * .5 + .5;
                
           

                return col;
            }

            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}
