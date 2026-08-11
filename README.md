# Realizing Robotic Swimming with Unified Fluid-Robot Multiphysics

RSS swimming studies for the RExEel robotic eel, built on [Aquarium.jl](https://github.com/RoboticExplorationLab/Aquarium.jl).
Two studies: a **C-start** turning maneuver (trajectory optimization and sim-to-real visuals) and **forward swimming** (simulation plus sim-to-real comparison against hardware and the Genesis simulator).

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

## Data

`data/` and `visualization/` hold roughly 850 MB of simulation outputs, source
footage, and rendered figures. Only the small text files are versioned
(tracking CSVs, `.tikz` figure sources, comparison logs); for the large video files
and images, please contact us at jeonghul@alumni.cmu.edu
