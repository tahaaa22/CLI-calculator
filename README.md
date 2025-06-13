#  CLI Calculator

A command-line calculator project with a C backend, Python interface via C-Python API, and multiple supporting tools like Ninja, Sphinx documentation, pre-commit hooks, and GitHub Actions CI/CD.

---

## 📦 Project Structure
```
CLI-calculator/
├── c_backend/
│ ├── calc.c # C backend logic
│ ├── calc.h # C function declarations
│
├── python_interface/
│ ├── calculator.c # Python C extension wrapper
│ ├── init.py # Python package initializer
│ ├── cli.py # CLI tool (argparse)
│
├──  tests/
│ └── test_calc.c # C unit tests
│ └── test_calculator.py # Python unit tests
│
├── docs/
│ ├── source/ # reStructuredText source files
│ └── conf.py # Sphinx config
│ └── Makefile/ # Generated documentation
│
├── .github/
│ └── workflows/
│ └── ci.yml # GitHub Actions CI/CD workflow
│
├── .pre-commit-config.yaml # Pre-commit hooks config
├── build.ninja # Ninja build system file
├── setup.py # Python packaging setup
├── pyproject.toml # PEP 518 build system file
├── requirements.txt # Python dependencies
├── Doxyfile # Doxygen setup file
└── README.md # This file
```

---

### Notes
   1) Python 3.12 assumed — adjust paths in build.ninja if needed.

   2) <Python.h> is added in the c package.
      if not search for folder path Python.h (usually in appdata/local/programs/python/pythonver/include)
      then add the folder extension to your C interpreter. 

---

## 📖 Features

✅ Modular C backend logic  
✅ Python C extension module  
✅ Command-line interface with `argparse`  
✅ C and Python unit tests  
✅ Ninja build system (Windows-optimized)  
✅ Sphinx developer documentation  
✅ Pre-commit hooks for code formatting and linting  
✅ GitHub Actions CI/CD workflow  

---

## 🚀 Quick Installation Options

### Important Note
> It is recommended to create a local environment inside the folder to avoid issues coming from having multiple interpreters installed, even on Anaconda.
```
python -m venv .venv
cd .venv/Scripts
activate.bat
cd ..
cd ..
```
This step is important for any of the following methods.

### 📌 Method 1 — Install with Make (if you have Chocolatey)

> Recommended if you have Chocolatey installed. Install Make via Chocolatey in an elevated windows powershell (Administrator):

```
choco install make
```
Then:

1️⃣ Clone the repository:
```
git clone https://github.com/tahaaa22/CLI-calculator
cd CLI-calculator
```
2️⃣ Install project dependencies:
```
pip install -r requirements.txt
```
3️⃣ Install pre-commit hooks:
```
python -m pre_commit install
python -m pre_commit run --all-files
```
4️⃣ Install and build:
```
make install
make build
```
5️⃣ Run tests:
```
make test_python
```
6️⃣ Clean build artifacts:
```
make clean
```
### 📌 Method 2 — Install with pip (editable install)
1️⃣ Clone the repository:
```
git clone https://github.com/tahaaa22/CLI-calculator
cd CLI-calculator
```
2️⃣ Install dependencies:
```
pip install -r requirements.txt
python -m pre_commit install
```
3️⃣ Install in development (editable) mode:
```
pip install -e .
```
4️⃣ Test it in Python shell:
```
>>> import calculator as cal
>>> cal.mul(1, 2)
2.0
>>> cal.add(5.5, 3.2)
8.7
>>> cal.divide(10, 2)
5.0
>>> cal.sub(15, 7)
8.0
>>> exit()
```

### 🔧 Ninja-based Build Workflow (Recommended for Windows)
1️⃣ Install dependencies:
```
pip install -r requirements.txt
pip install sphinx pre-commit ninja
```
✅ Install Ninja executable:

   1) Download: https://github.com/ninja-build/ninja/releases

   2) Extract ninja.exe to a folder

   3) Add the folder to your system PATH

2️⃣ Build the extension:
```
ninja extbuild
```
3️⃣ Run C unit tests:
```
ninja testc_compile
ninja testc_run
ninja testc
```
4️⃣ Run Python unit tests:
```
ninja testpy
```
5️⃣ Run the CLI:
```
python python_interface/cli.py add 5 3
```

---

### Generate Sphinx docs and run:

   Install Doxygen :
      https://www.doxygen.nl/download.html

(make sure you are in the root)

```
doxygen Doxyfile
sphinx-build -b html docs/source docs/build
cd docs/build
start index.html
```

or via Ninja:
```
cd ..
cd .. #return to the root
ninja docs
```
7️⃣ Clean build artifacts:
```
ninja cleanall
```
---

### Pre-commit setup:
```
python -m pre_commit install
python -m pre_commit run --all-files
```

---

### 📜 License
MIT License © 2025 Ahmed Taha

---

### 📧 Contact
- [Ahmed Taha](https://github.com/tahaaa22)
- [Ghada tarek](https://github.com/ghada-elboghdady)
- [Amr doma](https://github.com/AmrDoma)
- [Youssef awad](https://github.com/Youssef-Awad2004)
- [Sama Mohamed](https://github.com/SamaMohamed10)
