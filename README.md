# CLI-calculator
A high-performance command-line calculator with a C backend and Python interface, featuring comprehensive testing.

# Features:

Fast C Backend: Core arithmetic operations implemented in C for optimal performance
Python Interface: Easy-to-use Python bindings using the Python C API
Command Line Interface: Simple and intuitive CLI for quick calculations
Cross-Platform: Compatible with Windows, macOS, and Linux
Comprehensive Testing: Includes both C and Python test suites with CI/CD integration
Development Tools: Support for code formatting, linting, and coverage reporting



# Installation:

# Quick Install (Method 1 - Using Make)

Step 1: Run CMD as Adminstrator then For Window Install via Chocolatey (Recommended if you have Chocolatey):
choco install make

Step 2: Clone the repository
Run the following command:
git clone <repository-url>
Then navigate into the project directory:
cd calculator

Step 3: Run in Terminal (pip install -r requirements.txt)

Step 4: Install dependencies and setup
Run:
make install

Step 5: Build the C extension
Run:
make build

Step 6: Test the Python interface
Run:
make test_python

Step 7: Clean up build artifacts
Run:
make clean


# Quick Install (Method 2 - Using pip)

Step 1: Clone the repository
Run:
git clone <repository-url>
Then navigate into the project directory:
cd CLI-calculator

Step 2: Install in development mode
Run:
pip install -e .

Step 3: Test it out
Start a Python interactive session by running:
python

Step 4: In the Python interactive session, run the following commands:

1) import calculator as cal
2) cal.mul(1, 2) → 2.0
3) cal.add(5.5, 3.2) → 8.7
4) cal.divide(10, 2) → 5.0
5) cal.sub(15, 7) → 8.0
6) exit()