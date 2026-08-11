import Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using Aquarium
using Aquarium.CairoMakie   # provides `save`
using VideoIO

#############################################################################################
## Configuration
#############################################################################################

# Data paths (relative to this environment)
const DATA_DIR = joinpath(@__DIR__, "..", "data")
const VIS_DIR = joinpath(@__DIR__, "..", "visualization")

data_dir = joinpath(DATA_DIR, "rexeel_c_start")

# Output directory
output_dir = joinpath(VIS_DIR, "rss_figures", "c_start")
mkpath(output_dir)

# Only the optimal parameter set is extracted (the figure in the paper).
param_set_name = "optimal"

# Frame grabs are taken at these times, measured from the start of the recording.
# Both takes are trimmed so that motion begins at frame 0.
time_points = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0]

# Source videos. `seek_offset` is how many frames to step back from the computed
# frame before seeking: the hardware take runs a few frames ahead of the genesis
# render, so it needs a larger offset to line the two up.
sources = [
    (label = "hardware",   path = joinpath(data_dir, "hardware_cstart_optimal.mov"),   seek_offset = 5),
    (label = "genesis",    path = joinpath(data_dir, "genesis_cstart_optimal.mp4"),    seek_offset = 1),
    # The Aquarium render starts exactly at simulation t=0, so it needs no offset.
    (label = "simulation", path = joinpath(data_dir, "simulation_cstart_optimal.mp4"), seek_offset = 0),
]

println("="^80)
println("RExEel C-Start: Video Frame Extraction ($param_set_name)")
println("="^80)
println()

#############################################################################################
## Frame extraction
#############################################################################################

"""
    extract_frames(path, label, seek_offset)

Write one PNG per entry in `time_points`, named
`\$(param_set_name)_\$(label)_video_frame_t<time>s.png`. VideoIO yields 2-D
`RGB{N0f8}` frames, which `save` writes directly.
"""
function extract_frames(path, label, seek_offset)
    if !isfile(path)
        println("  ⚠ Warning: video not found: $path")
        return 0
    end

    video = VideoIO.openvideo(path)
    fps = VideoIO.framerate(video)
    written = 0

    try
        println("  $label: $(round(fps, digits=2)) fps, seek offset $seek_offset frame(s)")
        for t in time_points
            frame_number = Int(round(t * fps))
            VideoIO.seek(video, max(0.0, (frame_number - seek_offset) / fps))
            img = read(video)

            suffix = replace(string(t), "." => "p")
            filename = joinpath(output_dir,
                "$(param_set_name)_$(label)_video_frame_t$(suffix)s.png")
            save(filename, img)
            written += 1
            println("    ✓ t=$(t)s  →  $(basename(filename))")
        end
    finally
        close(video)
    end

    return written
end

total = 0
for src in sources
    global total += extract_frames(src.path, src.label, src.seek_offset)
    println()
end

#############################################################################################
## Summary
#############################################################################################

println("="^80)
println("Wrote $total frames to $(normpath(output_dir))")
println("="^80)
