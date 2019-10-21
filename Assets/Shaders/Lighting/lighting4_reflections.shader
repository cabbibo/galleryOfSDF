﻿Shader "lighting/lighting4_reflections"
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

        _Cube ("Environment Map", Cube) = "" {}

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
            #include "../Chunks/hsv.cginc"


         uniform samplerCUBE _Cube;   

            // Distance to a sphere
            float2 map( float3 pos ){
                float radius = .5;
                float distanceToSphere = length( pos ) - radius;
                float sphereID = 1;
                return float2( distanceToSphere , sphereID );
            }


            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){

                float3 reflectedLight = normalize(reflect(rd,nor));

                float4 val = texCUBE(_Cube,reflectedLight);

                // XYZ of normal turns into RGB
                return 2*pow(length(val.xyz)/3,2);
                
            }

            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}