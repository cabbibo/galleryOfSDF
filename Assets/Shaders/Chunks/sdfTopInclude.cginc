

            #include "UnityCG.cginc"
            #include "../Chunks/sdfFunctions.cginc"

            struct appdata{
                float4 vertex : POSITION;
            };

            struct v2f 
            {
                float3 eye : TEXCOORD0;
                float3 world : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            float4x4 _WTL;
            float4x4 _LTW;
            int _MaxSteps;
            float _MaxDistance;
            float _IntersectionPrecision;
            float _NormalDelta;
            float _Parameter1;
            float _Parameter2;
            float _Parameter3;
            float _Parameter4;
            float4 _BaseColor;

            v2f vert (appdata v)
            {
                v2f o;

                o.world = mul(_WTL, float4(mul(unity_ObjectToWorld,v.vertex).xyz , 1)).xyz;
                o.eye = mul(_WTL,float4(_WorldSpaceCameraPos,1)).xyz;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }


