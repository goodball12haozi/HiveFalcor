from falcor import *

def render_graph_ReSTIROG():
    g = RenderGraph("ReSTIROG")
    ReSTIROG = createPass("ReSTIROGPass", {'samplesPerPixel': 1})
    g.addPass(ReSTIROG, "ReSTIROG")
    VBufferRT = createPass("VBufferRT", {'samplePattern': 'Stratified', 'sampleCount': 16, 'useAlphaTest': True})
    g.addPass(VBufferRT, "VBufferRT")
    AccumulatePass = createPass("AccumulatePass", {'enabled': True, 'precisionMode': 'Single'})
    g.addPass(AccumulatePass, "AccumulatePass")
    ToneMapper = createPass("ToneMapper", {'autoExposure': False, 'exposureCompensation': 0.0})
    g.addPass(ToneMapper, "ToneMapper")
    g.addEdge("VBufferRT.vbuffer", "ReSTIROG.vbuffer")
    g.addEdge("VBufferRT.viewW", "ReSTIROG.viewW")
    g.addEdge("VBufferRT.mvec", "ReSTIROG.mvec")
    g.addEdge("ReSTIROG.color", "AccumulatePass.input")
    g.addEdge("AccumulatePass.output", "ToneMapper.src")
    g.markOutput("ToneMapper.dst")
    return g

ReSTIROG = render_graph_ReSTIROG()
try: m.addGraph(ReSTIROG)
except NameError: None
