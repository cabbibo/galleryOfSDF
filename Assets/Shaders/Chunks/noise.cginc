
#ifndef __noise_hlsl_
#define __noise_hlsl_

// The MIT License
// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// from : https://www.shadertoy.com/view/4sfGzS
 
float hash( float n )
{
    return frac(sin(n)*43758.5453);
}
 
float hash(float3 p)  // replace this by something better
{
    p  = frac( p*0.3183099+.1 );
  p *= 17.0;
    return frac( p.x*p.y*p.z*(p.x+p.y+p.z) );
}

float noise( in float3 x )
{
    float3 i = floor(x);
    float3 f = frac(x);
    f = f*f*(3.0-2.0*f);
  
    return lerp(lerp(lerp( hash(i+float3(0,0,0)), 
                        hash(i+float3(1,0,0)),f.x),
                   lerp( hash(i+float3(0,1,0)), 
                        hash(i+float3(1,1,0)),f.x),f.y),
               lerp(lerp( hash(i+float3(0,0,1)), 
                        hash(i+float3(1,0,1)),f.x),
                   lerp( hash(i+float3(0,1,1)), 
                        hash(i+float3(1,1,1)),f.x),f.y),f.z);
}
#endif 