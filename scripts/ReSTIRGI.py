from falcor import *

def render_graph_ReSTIRGI():
    g = RenderGraph("ReSTIRGI")
    ReSTIRGI = createPass("ReSTIRGI", {'samplesPerPixel': 1})
    g.addPass(ReSTIRGI, "ReSTIRGI")
    VBufferRT = createPass("VBufferRT", {'samplePattern': 'Stratified', 'sampleCount': 16, 'useAlphaTest': True})
    g.addPass(VBufferRT, "VBufferRT")
    AccumulatePass = createPass("AccumulatePass", {'enabled': True, 'precisionMode': 'Single'})
    g.addPass(AccumulatePass, "AccumulatePass")
    ToneMapper = createPass("ToneMapper", {'autoExposure': False, 'exposureCompensation': 0.0})
    g.addPass(ToneMapper, "ToneMapper")
    g.addEdge("VBufferRT.vbuffer", "ReSTIRGI.vbuffer")
    g.addEdge("VBufferRT.viewW", "ReSTIRGI.viewW")
    g.addEdge("VBufferRT.mvec", "ReSTIRGI.mvec")
    g.addEdge("ReSTIRGI.color", "AccumulatePass.input")
    g.addEdge("AccumulatePass.output", "ToneMapper.src")
    g.markOutput("ToneMapper.dst")
    return g

ReSTIRGI = render_graph_ReSTIRGI()
try: m.addGraph(ReSTIRGI)
except NameError: None
