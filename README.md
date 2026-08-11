# RoboticSwimming

RSS swimming studies for the RExEel robotic eel, built on [Aquarium.jl](https://github.com/RoboticExplorationLab/Aquarium).
Two studies: a **C-start** turning manoeuvre (simulation + trajectory optimization)
and **forward swimming** (simulation + sim-to-real comparison against hardware
and the Genesis simulator).

## Setup

```
julia --project=. -e 'using Pkg; Pkg.develop(path="/path/to/Aquarium"); Pkg.instantiate()'
```

`Manifest.toml` is committed, so the dependency set is pinned. Each script calls
`Pkg.activate` itself, so they can be run directly:

```
julia rexeel_c_start/simulate_c_starts.jl
```

## Layout

```
rexeel_c_start_optimization_90deg_turn.jl   trajectory optimization for a 90 deg turn
displacement_cost_functions.jl              objective + gradients used by the above

rexeel_c_start/
  simulate_c_starts.jl                      simulates the "initial" and "optimal" parameter sets
  visualize_trajectories.jl                 head-trajectory figures, vorticity fields, video frames

rexeel_forward_swimming/
  simulate_forward_swimming.jl              simulates 10/20/30/40 deg tail amplitudes
  sim_to_real_comparison.jl                 sim vs hardware vs Genesis, all amplitudes
  visualize_40_deg_trajectory.jl            detailed figures for the 40 deg case

data/                                       inputs and simulation outputs
visualization/                              rendered figures
```

Scripts resolve `data/` and `visualization/` relative to the repository, so
they work regardless of the current working directory.

## Data

`data/` and `visualization/` hold ~1.1 GB of simulation outputs, source footage,
and rendered figures. Only the small text files are versioned (tracking CSVs,
`.tikz` figure sources, comparison logs); the binaries are gitignored.

To re-fetch the binaries:

```
rsync -a --partial jjs-mac-studio:'~/aquariumCLOSED/data/rexeel_c_start/'          data/rexeel_c_start/
rsync -a --partial jjs-mac-studio:'~/aquariumCLOSED/data/rexeel_forward_swimming/' data/rexeel_forward_swimming/
rsync -a --partial jjs-mac-studio:'~/aquariumCLOSED/visualization/rss_figures/'    visualization/rss_figures/
```

The C-start hardware and Genesis assets (`hardware_trajectories.csv`,
`genesis_trajectories.csv`, and the four `.mov`/`.mp4` recordings) live upstream
under `data/rexeel_c_start_optimization/`, but belong in `data/rexeel_c_start/`
here — that is where `visualize_trajectories.jl` expects them.
