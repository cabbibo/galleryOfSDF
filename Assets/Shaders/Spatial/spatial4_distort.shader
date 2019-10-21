Shader "spatial/spatial4_distort"
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


    float3 p = pos ;

    float4 grow = float4(_Parameter1,_Parameter2,_Parameter3,_Parameter4);
    p.xyz += .1*sin(  8.*p.zxy )*grow.x;
    p.xyz += 0.20*sin(10.*p.yzx)*grow.y ;
    p.xyz += 0.2*sin(  12.0*p.yzx )*grow.z;
    p.xyz += 0.10*sin( 23.0*p.yzx)*grow.w;


                float radius = .5;
                float distanceToSphere = length( pos ) - radius;
                float sphereID = 1;
                return float2( (length( p/3 ) - .1) * .4 , sphereID ) ;
            }

            // Coloring different for each sphere using Hue Saturation Value function
            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){

                float3 col = lerp( nor * .5 + .5 , _BaseColor , dist/_MaxDistance);
                
           

                return col;
            }

            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}

