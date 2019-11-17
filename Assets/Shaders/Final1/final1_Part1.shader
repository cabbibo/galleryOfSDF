Shader "final/final1_part1"
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

               

                float fTime = _Time.y * _Parameter2 * 3;

                float3 fPos = pos-float3(.5,0,0) - .5*float3(sin(fTime), cos(fTime), sin(fTime + .4));
                float3 fPos2 = pos-float3(.5,0,0) - .5*float3(sin(.7*fTime+ .5), cos(.9*fTime + .7), sin(fTime + .9));

                float m = .1 + _Parameter4 * .5;
                float3 newPos = modit( pos , m) - m/2;

                float2 cubes= float2(sdBox( newPos , .1 ),1);
                float2 cubes2= float2(sdBox( newPos , .05 ),4);

                float2 sphere = float2( sdSphere( fPos , .2 + _Parameter3 * .6 ),2);
                sphere = smoothU( sphere , float2(  sdSphere( fPos2 , .2 + _Parameter3 * .6 ),2) , .3);


      
                




                return  sphere;
            }


            #include "../Chunks/calcAO.cginc"


            // Coloring different for each sphere using Hue Saturation Value function
            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){


                float ao = calcAO( pos , nor);

                float3 reflectedLight = normalize(reflect(rd,nor));

                float4 val = texCUBE(_Cube,reflectedLight);


                float3 fCol =val * hsv( id * .2 + _Parameter1 ,ao * 2,1);//hsv( id * ao * .4 ,1,1);//nor * .5 + .5;

                
                float3 col = fCol;//lerp( fCol , _BaseColor, dist/_MaxDistance);// nor * .5 + .5;//lerp( hsv( _Parameter3 , 1,1),hsv( _Parameter4 , 1,1), id-1);
                
           

                return col;
            }


            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}
