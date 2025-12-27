#!/bin/bash
# Post-create script for CSC 2026 Development Environment

set -e

echo "=========================================="
echo "CSC Latin America 2026 - Environment Setup"
echo "=========================================="

# Source ROOT environment
source /opt/root/bin/thisroot.sh

# Verify installations
echo ""
echo "Verifying tool installations..."
echo "-------------------------------"

echo -n "GCC version: "
gcc --version | head -1

echo -n "G++ version: "
g++ --version | head -1

echo -n "CMake version: "
cmake --version | head -1

echo -n "Python version: "
python3 --version

echo -n "ROOT version: "
root-config --version

echo -n "Git version: "
git --version

# Check for sanitizer support
echo ""
echo "Checking sanitizer support..."
echo "-----------------------------"

# Create a simple test program
cat > /tmp/test_sanitizers.cpp << 'EOF'
int main() { return 0; }
EOF

if g++ -fsanitize=address /tmp/test_sanitizers.cpp -o /tmp/test_asan 2>/dev/null; then
    echo "✓ AddressSanitizer (ASan) available"
else
    echo "✗ AddressSanitizer (ASan) NOT available"
fi

if g++ -fsanitize=undefined /tmp/test_sanitizers.cpp -o /tmp/test_ubsan 2>/dev/null; then
    echo "✓ UndefinedBehaviorSanitizer (UBSan) available"
else
    echo "✗ UndefinedBehaviorSanitizer (UBSan) NOT available"
fi

if g++ -fsanitize=thread /tmp/test_sanitizers.cpp -o /tmp/test_tsan 2>/dev/null; then
    echo "✓ ThreadSanitizer (TSan) available"
else
    echo "✗ ThreadSanitizer (TSan) NOT available"
fi

rm -f /tmp/test_sanitizers.cpp /tmp/test_asan /tmp/test_ubsan /tmp/test_tsan

# Check OpenMP support
echo ""
echo "Checking OpenMP support..."
echo "--------------------------"
cat > /tmp/test_omp.cpp << 'EOF'
#include <omp.h>
int main() { return omp_get_max_threads(); }
EOF

if g++ -fopenmp /tmp/test_omp.cpp -o /tmp/test_omp 2>/dev/null; then
    echo "✓ OpenMP available"
else
    echo "✗ OpenMP NOT available"
fi
rm -f /tmp/test_omp.cpp /tmp/test_omp

# Check TBB
echo ""
echo "Checking TBB support..."
echo "-----------------------"
if [ -f /usr/local/lib/libtbb.so ] || [ -f /usr/lib/x86_64-linux-gnu/libtbb.so.12 ]; then
    echo "✓ oneTBB available"
else
    echo "✗ oneTBB NOT available"
fi

# Check Catch2
echo ""
echo "Checking Catch2..."
echo "------------------"
if [ -f /usr/local/lib/cmake/Catch2/Catch2Config.cmake ]; then
    echo "✓ Catch2 available"
else
    echo "✗ Catch2 NOT available"
fi

# Check Google Benchmark
echo ""
echo "Checking Google Benchmark..."
echo "----------------------------"
if [ -f /usr/local/lib/libbenchmark.a ]; then
    echo "✓ Google Benchmark available"
else
    echo "✗ Google Benchmark NOT available"
fi

# Check Python packages
echo ""
echo "Checking Python packages..."
echo "---------------------------"
python3 -c "import pytest; print('✓ pytest', pytest.__version__)" 2>/dev/null || echo "✗ pytest NOT available"
python3 -c "import numpy; print('✓ numpy', numpy.__version__)" 2>/dev/null || echo "✗ numpy NOT available"
python3 -c "import uproot; print('✓ uproot', uproot.__version__)" 2>/dev/null || echo "✗ uproot NOT available"
python3 -c "import ROOT; print('✓ PyROOT available')" 2>/dev/null || echo "✗ PyROOT NOT available"

# Check perf
echo ""
echo "Checking perf tools..."
echo "----------------------"
if command -v perf &> /dev/null; then
    echo "✓ perf available"
    echo "  Note: perf may require elevated privileges in containers"
else
    echo "✗ perf NOT available"
fi

# Check FlameGraph
if command -v flamegraph.pl &> /dev/null; then
    echo "✓ FlameGraph tools available"
else
    echo "✗ FlameGraph tools NOT available"
fi

# Setup complete message
echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Quick Start:"
echo "  - C++ with ROOT:  root -l"
echo "  - Python:         python3"
echo "  - Jupyter:        jupyter lab --ip=0.0.0.0"
echo "  - Build project:  cmake -B build && cmake --build build"
echo ""
echo "Testing:"
echo "  - C++ tests:      ctest --test-dir build"
echo "  - Python tests:   pytest -v"
echo ""
echo "Profiling:"
echo "  - perf record -g ./program"
echo "  - perf report"
echo ""
echo "Happy coding! - CSC Latin America 2026"
echo "=========================================="
