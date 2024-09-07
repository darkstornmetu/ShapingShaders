Shader "Unlit/ShapePolygon"
{
    Properties
    {
        _BaseColor ("BaseColor", Color) = (1, 1, 1, 1)        
        _Radius ("Radius", Float) = 0.25
        _EdgeThickness ("Thickness", Float) = 0.05
        _Sides ("Sides", Range(3, 8)) = 3
    }
    SubShader //BURASI SHADERLAB OLDUĞU İÇİN DEĞİŞMİYOR
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline"}

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define PI2 6.28318530718
                    
            CBUFFER_START(UnityPerMaterial) //In order to use properties _per material kısmı SRP batcher için
            float4 _BaseColor;
            float _Radius;
            float _EdgeThickness;
            int _Sides;
            CBUFFER_END

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            //Eski appdata Bunu attributes diye yapmış unity example'ı ama bu tanımladığımız şey aslında vertexShadera verilen inputlar
            struct VertexInput{
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            //Eski v2f yeni varyings ama aslında vertexoutput
            struct VertexOutput{
                float4 position : SV_POSITION; //means pixel position
                float2 uv : TEXCOORD0;
            };

            VertexOutput vert(VertexInput i)
            {
                VertexOutput o;

                o.position = TransformObjectToHClip(i.position.xyz);
                o.uv = i.uv;

                return o;
            }

            float polygon(float2 pt, float2 center, float radius, int sides, float rotate, float edgeThickness)
            {
                pt -= center;

                sides = floor(sides);
                // Angle and radius from the current pixel
                float theta = atan2(pt.y, pt.x) + rotate;
                float rad = PI2/float(sides);

                // Shaping function that modulate the distance
                float d = cos(floor(0.5 + theta/rad)*rad-theta)*length(pt);

                return 1.0 - smoothstep(radius, radius + edgeThickness, d);
            }

            float4 frag(VertexOutput i) : SV_Target
            {             
                return polygon(i.uv, float2(0.5, 0.5), _Radius, _Sides, _Time.y, _EdgeThickness) *
                    _BaseColor;
            }

            ENDHLSL
        }
    }
}
