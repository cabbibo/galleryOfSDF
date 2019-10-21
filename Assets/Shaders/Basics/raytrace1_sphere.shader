Shader "sdf/raytrace1_sphere"
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
            #include "../Chunks/hsv.cginc"

            /*
        
                This is the section where we define the 'map' 
                (AKA the SHAPE) of the world. It will have two values:

                x) the distance to the closest surface of the world
                y) the ID of the closest surface of the world

                There are many amazing writeups about how to define this
                'map' of the world, but you can think about it kindof like a 
                normal topological map, where if you can find where you are 
                on the map, it will tell you the distance to sea level. 
                In this case, rather than drawing the map, we are defining it
                with mathematical functions!

                A few writeups to get in deeper:

                1) Wikipedia: https://en.wikipedia.org/wiki/Signed_distance_function
                2) My SDF shadertoy tutorial : https://www.shadertoy.com/view/Xl2XWt
                3) A realllly awesome / detailed set of tutorials : https://www.alanzucconi.com/2016/07/01/signed-distance-functions/
                4) some ludicrous examples of using this technique: https://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
                5) list of some common sdf functions : https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm


                These examples can do more than I *ever* could in terms of deep explanation, 
                so in these shaders, I will be providing as many simple examples as possible
                with little to no explanation ( except variable names! )

            */


            // Distance to a sphere
            float2 map( float3 pos ){
                float radius = _Parameter1;
                float distanceToSphere = length( pos ) - radius;
                float sphereID = 1;
                return float2( distanceToSphere , sphereID );
            }

            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){
                return hsv(_Parameter2,1,1);
            }

            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}
