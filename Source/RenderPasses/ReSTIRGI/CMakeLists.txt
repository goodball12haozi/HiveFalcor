add_plugin(ReSTIRGI)

target_sources(ReSTIRGI PRIVATE
    ReSTIRGI.cpp
    ReSTIRGI.h
    ColorType.slang
    GeneratePaths.cs.slang
    GuideData.slang
    LoadShadingData.slang
    NRDHelpers.slang
    Params.slang
    PathState.slang
    PathTracer.slang
    PathTracerNRD.slang
    ReflectTypes.cs.slang
    ResolvePass.cs.slang
    StaticParams.slang
    TracePass.rt.slang
)

target_source_group(ReSTIRGI "RenderPasses")
