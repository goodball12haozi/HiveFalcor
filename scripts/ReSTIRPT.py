from pathlib import WindowsPath, PosixPath
from falcor import *

def render_graph_ReSTIRPT():
    g = RenderGraph('ReSTIRPT')
    g.create_pass('VBufferRT', 'VBufferRT', {'outputSize': 'Default', 'samplePattern': 'Center', 'sampleCount': 16, 'useAlphaTest': True, 'adjustShadingNormals': True, 'forceCullMode': False, 'cull': 'Back', 'useTraceRayInline': False, 'useDOF': True})
    g.create_pass('RTXDIPass', 'RTXDIPass', {'options': {'mode': 'SpatiotemporalResampling', 'presampledTileCount': 128, 'presampledTileSize': 1024, 'storeCompactLightInfo': True, 'localLightCandidateCount': 24, 'infiniteLightCandidateCount': 8, 'envLightCandidateCount': 8, 'brdfCandidateCount': 1, 'brdfCutoff': 0.0, 'testCandidateVisibility': True, 'biasCorrection': 'Basic', 'depthThreshold': 0.10000000149011612, 'normalThreshold': 0.5, 'samplingRadius': 30.0, 'spatialSampleCount': 1, 'spatialIterations': 5, 'maxHistoryLength': 20, 'boilingFilterStrength': 0.0, 'rayEpsilon': 0.0010000000474974513, 'useEmissiveTextures': False, 'enableVisibilityShortcut': False, 'enablePermutationSampling': False}})
    g.create_pass('AccumulatePass', 'AccumulatePass', {'enabled': False, 'outputSize': 'Default', 'autoReset': True, 'precisionMode': 'Single', 'maxFrameCount': 0, 'overflowMode': 'Stop'})
    g.create_pass('ToneMapper', 'ToneMapper', {'outputSize': 'Default', 'useSceneMetadata': True, 'exposureCompensation': 0.0, 'autoExposure': False, 'filmSpeed': 100.0, 'whiteBalance': False, 'whitePoint': 6500.0, 'operator': 'Aces', 'clamp': True, 'whiteMaxLuminance': 1.0, 'whiteScale': 11.199999809265137, 'fNumber': 1.0, 'shutter': 1.0, 'exposureMode': 'AperturePriority'})
    g.create_pass('ReSTIRPTPass', 'ReSTIRPTPass', {'samplesPerPixel': 1, 'maxSurfaceBounces': 9, 'maxDiffuseBounces': 9, 'maxSpecularBounces': 9, 'maxTransmissionBounces': 9, 'adjustShadingNormals': False, 'lodBias': 0.0, 'sampleGenerator': 0, 'useBSDFSampling': True, 'useNEE': True, 'useMIS': True, 'useRussianRoulette': False, 'useAlphaTest': True, 'maxNestedMaterials': 2, 'useLightsInDielectricVolumes': False, 'limitTransmission': False, 'maxTransmissionReflectionDepth': 0, 'maxTransmissionRefractionDepth': 0, 'disableCaustics': False, 'specularRoughnessThreshold': 0.20000000298023224, 'disableDirectIllumination': True, 'primaryLodMode': 'Mip0', 'colorFormat': 'LogLuvHDR', 'misHeuristic': 'Balance', 'misPowerExponent': 2.0, 'emissiveSampler': 'Power', 'spatialMisKind': 'Pairwise', 'temporalMisKind': 'Talbot', 'shiftStrategy': 'Hybrid', 'rejectShiftBasedOnJacobian': 0, 'jacobianRejectionThreshold': 10.0, 'nearFieldDistance': 0.10000000149011612, 'temporalHistoryLength': 20, 'useMaxHistory': True, 'seedOffset': 0, 'enableTemporalReuse': True, 'enableSpatialReuse': True, 'numSpatialRounds': 1, 'pathSamplingMode': 'ReSTIR', 'localStrategyType': 3, 'enableTemporalReprojection': True, 'noResamplingForTemporalReuse': False, 'spatialNeighborCount': 3, 'featureBasedRejection': True, 'spatialReusePattern': 'Default', 'smallWindowRestirWindowRadius': 2, 'spatialReuseRadius': 20.0, 'useDirectLighting': True, 'separatePathBSDF': True, 'candidateSamples': 1, 'temporalUpdateForDynamicScene': False, 'enableRayStats': False, 'useNRDDemodulation': True})
    g.add_edge('ReSTIRPTPass.color', 'AccumulatePass.input')
    g.add_edge('VBufferRT.vbuffer', 'RTXDIPass.vbuffer')
    g.add_edge('VBufferRT.mvec', 'RTXDIPass.mvec')
    g.add_edge('AccumulatePass.output', 'ToneMapper.src')
    g.add_edge('VBufferRT.vbuffer', 'ReSTIRPTPass.vbuffer')
    g.add_edge('VBufferRT.mvec', 'ReSTIRPTPass.motionVectors')
    g.add_edge('RTXDIPass.color', 'ReSTIRPTPass.directLighting')
    g.mark_output('ToneMapper.dst')
    return g

ReSTIRPT = render_graph_ReSTIRPT()
try: m.addGraph(ReSTIRPT)
except NameError: None
