add_plugin(ReSTIROG)

target_sources(ReSTIROG PRIVATE
    ReSTIROG.cpp
    ReSTIROG.h
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

target_source_group(ReSTIROG "RenderPasses")
