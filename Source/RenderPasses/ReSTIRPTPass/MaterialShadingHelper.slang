#include "Utils/Math/MathConstants.slangh"

import Scene.ShadingData;
import Scene.Scene;
import Scene.Material.TextureSampler;
import Scene.Material.MaterialFactory;
import Utils.Math.MathHelpers;
import Utils.Color.ColorHelpers;
import Utils.Sampling.SampleGenerator;
// import Rendering.Materials.BxDF;
import Rendering.Materials.Fresnel;
import Rendering.Materials.Microfacet;
import PathState;
import LoadShadingData;



// StandardBSDFData getStandardBSDFData(const ShadingData sd, SamplerState s, const BasicMaterialData data)
// {
//     let lod = ExplicitLodTextureSampler(0.f);

//     StandardBSDFData d = {};

//     d.eta = sd.frontFacing ? (sd.IoR / data.IoR) : (data.IoR / sd.IoR);
//     d.diffuseTransmission = data.diffuseTransmission;
//     d.specularTransmission = data.specularTransmission;
//     if (d.diffuseTransmission > 0.f || d.specularTransmission > 0.f)
//     {
//         d.transmission = gScene.materials.sampleTexture(data.texTransmission, s, sd.uv, float4(data.transmission, 0.f), lod).rgb;
//     }

//     // Calculate the specular reflectance for dielectrics from the IoR, as in the Disney BSDF [Burley 2015].
//     // UE4 uses 0.08 multiplied by a default specular value of 0.5, hence F0=0.04 as default. The default IoR=1.5 gives the same result.
//     float f = (data.IoR - 1.f) / (data.IoR + 1.f);
//     float F0 = f * f;

//     // Sample base color.
//     const float3 baseColor = gScene.materials.sampleTexture(data.texBaseColor, s, sd.uv, data.baseColor, lod).rgb;

//     // Sample the specular texture.
//     // Depending on the shading model this encodes the material parameters differently.
//     const float4 spec = gScene.materials.sampleTexture(data.texSpecular, s, sd.uv, data.specular, lod);

// #if MATERIAL_SYSTEM_HAS_SPEC_GLOSS_MATERIALS
//     if (data.getShadingModel() == ShadingModel::MetalRough)
// #endif
//     {
//         // G - Roughness; B - Metallic
//         d.diffuse = lerp(baseColor, float3(0), spec.b);
//         d.specular = lerp(float3(F0), baseColor, spec.b);
//         d.roughness = spec.g;
//         d.metallic = spec.b;
//     }
// #if MATERIAL_SYSTEM_HAS_SPEC_GLOSS_MATERIALS
//     else // ShadingModel::SpecGloss
//     {
//         d.diffuse = baseColor;
//         d.specular = spec.rgb;
//         d.roughness = 1 - spec.a;
//         d.metallic = getMetallic(d.diffuse, d.specular);
//     }
// #endif

//     return d;
// }

// /** Evaluates whether the incoming and outgoing directions define a transmission event.
//     Otherwise, the event is a reflection.
//     \param[in] wi The incoming direction pointing outward from the surface.
//     \param[in] wo The outgoing direction pointing outward from the surface.
//     \param[in] faceN The face normal.
//     \return True if wi and wo point to the opposite sides of the plane defined by faceN.
// */
// // bool isTransmissionEvent(const float3 wi, const float3 wo, const float3 faceN)
// // {
// //     return (dot(wi, faceN) > 0) != (dot(wo, faceN) > 0);
// // }

// not considering transmission cases for now
// bool hasRoughComponent(const ShadingData sd, float roughnessThreshold)
// bool hasRoughComponent(PathState path, bool isPrimaryHit, const ShadingData sd, float roughnessThreshold)
// {
//     // BasicMaterialData bmd = gScene.materials.getBasicMaterialData(sd.materialID);
//     // SamplerState s = gScene.materials.getTextureSampler(gScene.materials.getMaterialHeader(sd.materialID).getDefaultTextureSamplerID());
//     //StandardBSDFData data = getStandardBSDFData(sd, s, bmd);

//     // diffuseReflection
//     // FalcorBSDF bsdf = FalcorBSDF(sd, data);

//     let hints = getMaterialInstanceHints(path.hit, isPrimaryHit);
//     let lod = ExplicitLodTextureSampler(0.f);
//     const IMaterialInstance mi = gScene.materials.getMaterialInstance(sd, lod, hints);
//     BSDFProperties bsdfProperties = mi.getProperties(sd);
//     mi.getLobeTypes(sd);
//     return mi.pDiffuseReflection > 0 || bsdfProperties.roughness > roughnessThreshold;
//     //return bsdf.pDiffuseReflection > 0 || gScene.materials.getBSDF(sd, lod).getProperties(sd).roughness > roughnessThreshold;
// }

// bool classifyAsRough(const ShadingData sd, float roughnessThreshold)
// bool classifyAsRough(PathState path,bool isPrimaryHit,const ShadingData sd,float roughnessThreshold)
// {
//     let hints = getMaterialInstanceHints(path.hit, isPrimaryHit);
//     let lod = ExplicitLodTextureSampler(0.f);
//     const IMaterialInstance mi = gScene.materials.getMaterialInstance(sd, lod, hints);
//     BSDFProperties bsdfProperties = mi.getProperties(sd);
//     //let bsdfProperties = gScene.materials.getBSDF(sd, lod).getProperties(sd);
//     return bsdfProperties.roughness > roughnessThreshold;
// }

// /** Evaluates the BSDF multiplied by NdotL for a given incident direction.

//     \param[in] sd Shading point data.
//     \param[in] L Normalized incident direction from shading point towards light source.
//     \return (f_d + f_r) * saturate(dot(N,L))
// */
// float3 evalBSDFCosine(const ShadingData sd, float3 L, inout SampleGenerator sg, uint allowedSampledFlags = -1, bool allowDeltaEval = false)
// {
//     float3 wo = sd.toLocal(sd.V);
//     float3 wi = sd.toLocal(L);
//     BasicMaterialData bmd = gScene.materials.getBasicMaterialData(sd.materialID);
//     SamplerState s = gScene.materials.getTextureSampler(gScene.materials.getMaterialHeader(sd.materialID).getDefaultTextureSamplerID());
//     StandardBSDFData data = getStandardBSDFData(sd, s, bmd);
//     FalcorBSDF bsdf = FalcorBSDF(sd, data);
//     return bsdf.eval(wi, wo, sg, allowedSampledFlags, allowDeltaEval);
// }

// /** Evaluates the probability density function for both the diffuse and specular sampling strategy.
//     \param[in] sd Describes the shading point.
//     \param[in] L The normalized incident direction for which to evaluate the pdf.
//     \return Probability density with respect to solid angle from the shading point.
// */
// float evalPdfBSDF(const ShadingData sd, float3 L, uint allowedSampledFlags = -1, bool allowDeltaEval = false)
// {
//     float3 wo = sd.toLocal(sd.V);
//     float3 wi = sd.toLocal(L);
//     BasicMaterialData bmd = gScene.materials.getBasicMaterialData(sd.materialID);
//     SamplerState s = gScene.materials.getTextureSampler(gScene.materials.getMaterialHeader(sd.materialID).getDefaultTextureSamplerID());
//     StandardBSDFData data = getStandardBSDFData(sd, s, bmd);
//     FalcorBSDF bsdf = FalcorBSDF(sd, data);
//     return bsdf.evalPdf(wi, wo, allowedSampledFlags, allowDeltaEval);
// }

// float evalPdfBSDF(const ShadingData sd, float3 L, out float pdfAll, uint allowedSampledFlags = -1, bool allowDeltaEval = false)
// {
//     float3 wo = sd.toLocal(sd.V);
//     float3 wi = sd.toLocal(L);
//     BasicMaterialData bmd = gScene.materials.getBasicMaterialData(sd.materialID);
//     SamplerState s = gScene.materials.getTextureSampler(gScene.materials.getMaterialHeader(sd.materialID).getDefaultTextureSamplerID());
//     StandardBSDFData data = getStandardBSDFData(sd, s, bmd);
//     FalcorBSDF bsdf = FalcorBSDF(sd, data);
//     return bsdf.evalPdfAll(wi, wo, pdfAll, allowedSampledFlags, allowDeltaEval);
// }

// float evalPdfBSDFWithV(in ShadingData sd, float3 V, float3 L, uint allowedSampledFlags = -1, bool allowDeltaEval = false)
// {
//     sd.V = V;
//     float3 wo = sd.toLocal(V);
//     float3 wi = sd.toLocal(L);
//     BasicMaterialData bmd = gScene.materials.getBasicMaterialData(sd.materialID);
//     SamplerState s = gScene.materials.getTextureSampler(gScene.materials.getMaterialHeader(sd.materialID).getDefaultTextureSamplerID());
//     StandardBSDFData data = getStandardBSDFData(sd, s, bmd);
//     FalcorBSDF bsdf = FalcorBSDF(sd, data);
//     return bsdf.evalPdf(wi, wo, allowedSampledFlags, allowDeltaEval);
// }

// /** Importance sampling of the BSDF.

//     Note: The evaluated pdf for the generated sample is expensive to compute, as the pdf is a weighted
//     combination of two sampling strategies. If the caller doesn't explicitly need the probability, they
//     should be careful not to touch the value so that the compiler can do dead code elimination.

//     \param[in] sd Shading point data.
//     \param[in] sg Sample generator.
//     \param[out] result Generated sample. Only valid if true is returned.
//     \return True if a sample was generated, false otherwise.
// */
// bool sampleBSDF<S : ISampleGenerator>(const ShadingData sd, inout S sg, out BSDFSample result, bool useDeterministicBSDF = false)
// {
//     float3 wo = sd.toLocal(sd.V);
//     float3 wi;

//     BasicMaterialData bmd = gScene.materials.getBasicMaterialData(sd.materialID);
//     SamplerState s = gScene.materials.getTextureSampler(gScene.materials.getMaterialHeader(sd.materialID).getDefaultTextureSamplerID());
//     StandardBSDFData data = getStandardBSDFData(sd, s, bmd);
//     FalcorBSDF bsdf = FalcorBSDF(sd, data);
    
//     bool valid = bsdf.sample(wo, wi, result.pdf, result.pdfSingle, result.weight, result.lobe, sg);
//     result.wo = sd.fromLocal(wi);

//     if (useDeterministicBSDF)
//     {
//         if (result.pdfSingle == 0.f) result.pdf = 0.f;
//         // Ensure consistency with the geometry.
//         bool compatibleWithReflection = !isTransmissionEvent(result.wo, sd.V, sd.N);

//         uint allowedSampledFlags = 0;
//         if (compatibleWithReflection)
//         {
//             allowedSampledFlags |= (uint)SampledBSDFFlags::DiffuseReflection;
//             allowedSampledFlags |= (uint)SampledBSDFFlags::SpecularReflection;
//             allowedSampledFlags |= (uint)SampledBSDFFlags::SpecularReflectionTransmission;
//         }
//         else
//         {
//             allowedSampledFlags |= (uint)SampledBSDFFlags::DiffuseTransmission;
//             allowedSampledFlags |= (uint)SampledBSDFFlags::SpecularReflectionTransmission;
//         }

//         // Evaluate all lobes and divide by the full PDF. TODO: Optimize.
//         result.weight = bsdf.eval(wo, wi, sg, allowedSampledFlags, result.isLobe(LobeType::Delta)) / result.pdf;
//     }

//     return valid;
// }

// /** Reference implementation that uses cosine-weighted hemisphere sampling.
//     This is for testing purposes only.
//     \param[in] sd Shading point data.
//     \param[in] sg Sample generator.
//     \param[out] result Generated sample. Only valid if true is returned.
//     \return True if a sample was generated, false otherwise.
// */
// bool sampleBSDF_Reference<S : ISampleGenerator>(const ShadingData sd, inout S sg, out BSDFSample result)
// {
//     float3 wo = sd.toLocal(sd.V);
//     float3 wi = sample_cosine_hemisphere_concentric(sampleNext2D(sg), result.pdf); // pdf = cos(theta) / pi

//     if (result.pdf == 0.f) return false;

//     BasicMaterialData bmd = gScene.materials.getBasicMaterialData(sd.materialID);
//     SamplerState s = gScene.materials.getTextureSampler(gScene.materials.getMaterialHeader(sd.materialID).getDefaultTextureSamplerID());
//     StandardBSDFData data = getStandardBSDFData(sd, s, bmd);
//     FalcorBSDF bsdf = FalcorBSDF(sd, data);

//     // Ensure consistency with the geometry.
//     result.wo = sd.fromLocal(wi);

//     bool compatibleWithTransmission = isTransmissionEvent(result.wo, sd.V, sd.N);
//     bool compatibleWithReflection = !compatibleWithTransmission;

//     uint allowedSampledFlags = 0;
//     if (compatibleWithReflection)
//     {
//         allowedSampledFlags |= (uint)SampledBSDFFlags::DiffuseReflection;
//         allowedSampledFlags |= (uint)SampledBSDFFlags::SpecularReflection;
//         allowedSampledFlags |= (uint)SampledBSDFFlags::SpecularReflectionTransmission;
//     }
//     else
//     {
//         allowedSampledFlags |= (uint)SampledBSDFFlags::DiffuseTransmission;
//         allowedSampledFlags |= (uint)SampledBSDFFlags::SpecularReflectionTransmission;
//     }

//     result.weight = bsdf.eval(wo, wi, sg, allowedSampledFlags) / result.pdf;
//     result.lobe = (uint)LobeType::DiffuseReflection;

//     return true;
// }

