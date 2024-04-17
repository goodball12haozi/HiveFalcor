add_plugin(ReSTIROGPass)

target_sources(ReSTIROGPass PRIVATE
    ReSTIROGPass.cpp
    ReSTIROGPass.h
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

target_copy_shaders(ReSTIROGPass RenderPasses/ReSTIROGPass)

target_source_group(ReSTIROGPass "RenderPasses")
