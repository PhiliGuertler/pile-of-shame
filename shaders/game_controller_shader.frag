#include <flutter/runtime_effect.glsl>

uniform sampler2D uNormalTexture;
uniform sampler2D uColorTexture;
uniform vec2 uSize;
uniform vec3 lightDirection;

out vec4 fragColor;

void main() {
    vec2 position = FlutterFragCoord().xy;
    vec2 uv = position / uSize;

    float shinyFactor = 25.0;
    float ambientFactor = 0.3;
    float diffuseFactor = 0.9;
    float specularFactor = 0.3;
    vec4 lightColor = vec4(1.0, 1.0, 1.0, 1.0);

    vec4 normalizedLightDirection = vec4(normalize(lightDirection), 0.0);

    vec4 normal = normalize(texture(uNormalTexture, uv) * 2 - 1);
    vec4 color = texture(uColorTexture, uv);

    float nDotL = clamp(abs(dot(normalize(normal.xyz), -normalize(normalizedLightDirection.xyz))), 0.0, 1.0);

    vec3 r = normalize(2.0 * nDotL * normal.xyz * normalizedLightDirection.xyz);

    vec4 ambient = ambientFactor * color * lightColor;
    vec4 diffuse = diffuseFactor * color * lightColor * nDotL;
    vec4 specular = specularFactor * 0.3 * vec4(1.0, 1.0, 1.0, 1.0) * lightColor * pow(clamp(dot(normalize(vec3(0.0, 0.5, 1.0)), r), 0.0, 1.0), shinyFactor);

    ambient.w = color.w;
    diffuse.w = color.w;
    specular.w = color.w;

    fragColor = ambient + diffuse + specular;
}