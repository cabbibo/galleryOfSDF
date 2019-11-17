Shader "final/final2"
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

    float4 grow = float4(sin(_Time.y*_Parameter1),sin(_Time.y*2*_Parameter1 + .3 ),sin(_Time.y*1.7*_Parameter1 + 1.3), sin(_Time.y*3*_Parameter1 + .9));
    p.xyz += .1*sin( 1.5*_Parameter2*  8.*p.zxy )*grow.x;
    p.xyz += 0.20*sin( 1.5*_Parameter2*10.*p.yzx)*grow.y ;
    p.xyz += 0.2*sin( 1.5*_Parameter2*  12.0*p.yzx )*grow.z;
    p.xyz += 0.10*sin( 1.5*_Parameter2* 23.0*p.yzx)*grow.w;


                float radius = .5;
                float distanceToSphere = length( pos ) - radius;
                float sphereID = 1;
                
                float2 distortedSphere = float2( (length(p) - .6) * .4 , 1 );

                float3 newPos = modit( pos , _Parameter4) - .5 * _Parameter4;

                //float3 cubePos = modit

                float2 repeatCube = float2( sdSphere(newPos,.1 * 3*_Parameter3) , 2);
                float2 repeatCube2 = float2( sdSphere(newPos,.05* 3*_Parameter3) , 3);

                float2 res = smoothS( repeatCube ,distortedSphere  , 0.2);
                return hardU(repeatCube2,res);



            }

            #include "../Chunks/calcAO.cginc"

            // Coloring different for each sphere using Hue Saturation Value function
            float3 color( float3 pos , float3 nor , float3 ro , float3 rd , float dist , float id){

                float3 col = pow(id-1,2);//lerp( nor * .5 + .5 , _BaseColor , dist/_MaxDistance);
                
float ao = calcAO( pos , nor );
                col = ao;

                //if(id==3){ col = .4;}//nor * .5 + .5;}
           

                return col;
            }

            #include "../Chunks/sdfBottomInclude.cginc"

            ENDCG
        }
    }
}

