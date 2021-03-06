using ImageMagick, Test
using CairoMakie, AbstractPlotting, MakieGallery
using AbstractPlotting: Pixel
CairoMakie.activate!(type = "png")

# AbstractPlotting.format2mime(::Type{AbstractPlotting.FileIO.format"PDF"}) = MIME("application/pdf")

include("saving.jl") # test saving params

database = MakieGallery.load_database()

ignored_titles = Set((
    "arrows on hemisphere",
    "cobweb plot",
    "orbit diagram",   # takes too long
    "edit polygon",    # not implemented yet
    "hbox",            # discrepancy in subpixel markersize impl
    "lots of heatmaps",# it actually looks crisper, but w/e
    "sliders",         # window events are not propagated
    "subscenes",       # need to implement gaussian blurring
    "fem mesh 2d",     # the colormap is different somehow
    "fem polygon 2d",  # the colormap is different somehow
))

filter!(database) do entry
    "2d" in entry.tags &&
    !("3d" in entry.tags) &&
    !(lowercase(entry.title) ∈ ignored_titles)
end

tested_diff_path = joinpath(@__DIR__, "tested_different")
test_record_path = joinpath(@__DIR__, "test_recordings")
rm(tested_diff_path, force = true, recursive = true)
mkpath(tested_diff_path)
rm(test_record_path, force = true, recursive = true)
mkpath(test_record_path)

MakieGallery.record_examples(test_record_path)
MakieGallery.run_comparison(test_record_path, tested_diff_path)
