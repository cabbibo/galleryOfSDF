Shader "sdf/raytrace5_Time"
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

            // Combining two spheres 
            float2 map( float3 pos ){

                float radius = _Parameter1 + _Parameter1 * .5 * sin(_Time.y);


                float3 offset = float3(0, radius * _Parameter3 * sin(_Time.y * _Parameter3), radius * _Parameter3 * sin(_Time.y * _Parameter2));
                float distanceToSphere = length( pos-offset ) - radius;
                float sphereID = 1;
                float2 sphere1 = float2( distanceToSphere , sphereID );
                return sphere1;
            }


            // Coloring different for each sphere using Hue Saturation Value function
            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){

                float3 col = hsv(_Parameter4 * sin(_Time.y),1,1);
                
           

                return col;
            }

            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}
