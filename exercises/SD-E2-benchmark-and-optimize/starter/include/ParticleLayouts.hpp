#pragma once

#include <cmath>
#include <cstddef>
#include <vector>

namespace sd_e2 {

// Array of Structures (AoS)
struct ParticleAoS {
    double px{};
    double py{};
    double pz{};
    double mass{};
};

struct ParticlesAoS {
    std::vector<ParticleAoS> particles;

    void resize(size_t n) { particles.resize(n); }

    double sumEnergy() const {
        double sum = 0.0;
        for (const auto& p : particles) {
            // E = sqrt(p^2 + m^2)
            const double p2 = p.px * p.px + p.py * p.py + p.pz * p.pz;
            sum += std::sqrt(p2 + p.mass * p.mass);
        }
        return sum;
    }
};

// Structure of Arrays (SoA) - intentionally suboptimal baseline
struct ParticlesSoA {
    std::vector<double> px;
    std::vector<double> py;
    std::vector<double> pz;
    std::vector<double> mass;

    void resize(size_t n) {
        px.resize(n);
        py.resize(n);
        pz.resize(n);
        mass.resize(n);
    }

    double sumEnergy() const {
        double sum = 0.0;
        for (size_t i = 0; i < px.size(); ++i) {
            // Intentionally slow: std::pow is expensive and blocks vectorization.
            const double p2 = std::pow(px[i], 2) + std::pow(py[i], 2) + std::pow(pz[i], 2);
            sum += std::sqrt(p2 + std::pow(mass[i], 2));
        }
        return sum;
    }
};

} // namespace sd_e2

