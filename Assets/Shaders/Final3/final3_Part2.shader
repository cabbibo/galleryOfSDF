Shader "final/final3_part2"
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
                // using an iteratively to move
                for (int i=0; i<floor(_Parameter1 * 10 +1); i++) {
                   
                    pos.zy = abs(pos.zy);
                    // scale and offset the position
                    pos = pos*1.2+ offset;
                    
                    // Rotate the position
                    float2 rotation = float2(1.2,.5);
                    pR(pos.zy,_Parameter4*3.14 + .1*sin(_Time.y));
                    pR(pos.xz,_Parameter4*3.14 + .1*sin(_Time.y * 1.5));     

                    l=min(length(pos),l);//length6(pos);
                }

                // scaling space so we have better step sizes
                float2 fractal  = float2( l*.5-.1 , 1);

                float3 eyePos = float3(-.1,0,0);

                float2 eye;// = hardU(float2(length(ogPos-eyePos)- .3,3), sphere);

                float3 pupilPos = eyePos + normalize(float3( -1 , sin( _Time.y ) , sin( _Time.y * 2))) * .3;

                eye = float2(length(ogPos-eyePos)- .3,3);
                eye = hardS(float2(length(ogPos-pupilPos)- .2,4), eye);
                eye = hardU(float2(length(ogPos-pupilPos)- .1,5), eye );

                fractal = hardS(float2(length(ogPos-eyePos)- .4,2), fractal);
                fractal = hardU(eye, fractal);
                return eye;
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
