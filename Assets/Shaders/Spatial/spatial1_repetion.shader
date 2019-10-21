Shader "spatial/spatial1_Repetition"
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

            // Folding Space, and *then* doing our sphere map
            float2 map( float3 pos ){

                float3 newPos = modit( pos , _Parameter2) - _Parameter2 * .5;
                float id =  abs( pos.x / _Parameter2 );
                float radius = _Parameter1;
                float distanceToSphere = length( newPos ) - radius;
                float2 sphere  = float2( distanceToSphere , id );

                return sphere;
            }


            // Coloring different for each sphere using Hue Saturation Value function
            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){

                float3 col = lerp( nor * .5 + .5 , _BaseColor , dist/_MaxDistance );
                
           

                return col;
            }

            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}

