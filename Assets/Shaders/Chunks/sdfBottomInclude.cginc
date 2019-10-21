
            float2 trace( float3 ro , float3 rd ){

                float3 currentMapPosition = ro;
                float currentMapDistance = _IntersectionPrecision*2.;
                float currentMapID = -1000;
                float totalMapDistance = 0;

                for( int i = 0; i < _MaxSteps; i++){


                    if(currentMapDistance < _IntersectionPrecision || totalMapDistance > _MaxDistance ) break;
                    float2 m = map( ro + rd * totalMapDistance );

                    currentMapDistance = m.x;
                    totalMapDistance += m.x;

                    currentMapID = m.y;

          

                }
                float res = -1;

                if( totalMapDistance < _MaxDistance ) res = totalMapDistance;
                if( totalMapDistance > _MaxDistance ) currentMapID = -1.0;

                return float2( res , currentMapID );

            }

            float3 getNor(float3 p){


                float3 delta = float3(_NormalDelta,0,0);

                float x = map( p + delta.xyy ) - map(p-delta.xyy);
                float y = map( p + delta.yxy ) - map(p-delta.yxy);
                float z = map( p + delta.yyx ) - map(p-delta.yyx);

                return normalize( float3(x,y,z));

            }

         

            fixed4 frag (v2f v) : SV_Target
            {

                float3 ro = v.world;
                float3 rd = normalize(v.world-v.eye);


                float2 result = trace( ro , rd );

                fixed3 col = _BaseColor;

                if( result.y > 0 ){

                    float3 pos = ro + result.x * rd;
                    float3 nor = getNor( pos );

                    col = color( pos , nor , ro , rd , result.x , result.y );

                }



                return float4(col,1);
            }


