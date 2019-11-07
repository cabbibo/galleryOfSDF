Shader "final/final1_part3"
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

float3 modit(float3 x, float y)
{
  return x - y * floor(x/y);
}

            float2 map( float3 pos ){

 

                float2 final=  float2(-sdSphere(pos,1.7),0.4);
                




                return  final;
            }


            #include "../Chunks/calcAO.cginc"


            // Coloring different for each sphere using Hue Saturation Value function
            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){



                float3 reflectedLight = normalize(reflect(rd,nor));

                float4 val = texCUBE(_Cube,reflectedLight);


                float3 col = length(val) * length(val) * .2;//fCol;//lerp( fCol , _BaseColor, dist/_MaxDistance);// nor * .5 + .5;//lerp( hsv( _Parameter3 , 1,1),hsv( _Parameter4 , 1,1), id-1);
                
           

                return col;
            }

            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}
