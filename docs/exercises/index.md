# Exercises Overview

This course uses **self-contained exercise mini-projects** under `exercises/`.
Each exercise has a `starter/` directory with its own `CMakeLists.txt`.

## How to work

1. Enter the exercise `starter/` directory.
2. Configure and build with CMake.
3. Run the program and the tests.
4. Commit in small, atomic steps.

## Exercises in the timetable

- **TT-E1 Debugging (Sanitizers)**: fix a real memory bug using ASan/UBSan, then lock it with a unit test.
- **TT-E2 Docs & CI**: add one documentation page and ensure MkDocs builds locally and in CI.
- **SD-E1 Parallel event processing (OpenMP)**: make a parallel loop correct, then improve performance (false sharing).
- **SD-E2 Benchmark & optimise**: measure performance with Google Benchmark and apply one targeted optimisation.
