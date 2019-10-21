Shader "spatial/spatial7_symmetry"
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



            // Folding Space, and *then* doing our sphere map
            float2 map( float3 pos ){

                // reflection across the yx plane
                float3 newPos =  float3(pos.x , pos.y,abs(pos.z));
                float distanceToSphere = length( newPos - float3(.5,_Parameter3,.5) ) - _Parameter1;
                float2 sphere  = float2( distanceToSphere ,1 );

                sphere = hardU( sphere, float2(length( newPos - float3(.5,-_Parameter4,.5) ) - _Parameter2,1));

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

