# RoboticSwimming

RSS swimming studies for the RExEel robotic eel, built on [Aquarium.jl](https://github.com/RoboticExplorationLab/Aquarium).
Two studies: a **C-start** turning manoeuvre (trajectory optimization plus figure
assets) and **forward swimming** (simulation plus sim-to-real comparison against
hardware and the Genesis simulator).

## Setup

```
julia --project=. -e 'using Pkg; Pkg.develop(path="/path/to/Aquarium"); Pkg.instantiate()'
```

`Manifest.toml` is committed, so the dependency set is pinned. Each script calls
`Pkg.activate` itself, so they can be run directly:

```
julia rexeel_forward_swimming/simulate_forward_swimming.jl
```

## Layout

```
rexeel_c_start_optimization_90deg_turn.jl   trajectory optimization for a 90 deg turn
displacement_cost_functions.jl              objective + gradients used by the above

rexeel_c_start/
  simulate_c_starts.jl                      simulates the "initial" and "optimal" parameter sets
  visualize_trajectories.jl                 extracts the c-start figure frames (see below)

rexeel_forward_swimming/
  simulate_forward_swimming.jl              simulates 10/20/30/40 deg tail amplitudes
  sim_to_real_comparison.jl                 sim vs hardware vs Genesis, all amplitudes
  visualize_40_deg_trajectory.jl            detailed figures for the 40 deg case

data/                                       inputs and simulation outputs
visualization/                              rendered figures
```

Scripts resolve `data/` and `visualization/` relative to the repository, so
they work regardless of the current working directory.

### C-start frame extraction

`rexeel_c_start/visualize_trajectories.jl` grabs one frame per source at
t = 0, 0.5 … 3.0 s and writes them to `visualization/rss_figures/c_start/`.
It covers three sources, each with a seek offset that aligns their motion
start:

| source | file | fps | seek offset |
| --- | --- | --- | --- |
| hardware | `hardware_cstart_optimal.mov` | 30 | 5 |
| genesis | `genesis_cstart_optimal.mp4` | 60 | 1 |
| simulation | `simulation_cstart_optimal.mp4` | 20 | 0 |

Only the `optimal` parameter set is extracted. The script previously also
rendered head-trajectory comparisons, per-timepoint trajectory overlays, and
vorticity fields; that code was removed in `864c6fe` and is recoverable from
`6a6f9af` if those assets are needed again.

## Data

`data/` and `visualization/` hold roughly 850 MB of simulation outputs, source
footage, and rendered figures. Only the small text files are versioned
(tracking CSVs, `.tikz` figure sources, comparison logs); the binaries are
gitignored.

To re-fetch the binaries:

```
rsync -a --partial jjs-mac-studio:'~/aquariumCLOSED/data/rexeel_forward_swimming/' data/rexeel_forward_swimming/
rsync -a --partial jjs-mac-studio:'~/aquariumCLOSED/visualization/rss_figures/'    visualization/rss_figures/
```

The C-start source videos are renamed copies of assets that live upstream under
`data/rexeel_c_start_optimization/` (the two `Camo 录像 …` recordings and
`Simulation_cstart_optimal.mp4`), plus the Aquarium render that upstream is
`visualization/rss_figures/c_start/optimal_vorticity_animation.mp4`.
