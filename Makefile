# Cross-platform Makefile for CLI Calculator

# Detect OS
ifeq ($(OS),Windows_NT)
    # Windows settings
    CC = cl
    CFLAGS = /nologo /W3 /EHsc /I c_backend
    PYTHON = python
    RM = del /Q /F
    RMDIR = rmdir /S /Q
    PATH_SEP = \\
    EXE_EXT = .exe
    TEST_RUN = tests\\test_c_calc.exe
    MKDIR = mkdir
    NULL_DEVICE = NUL
else
    # Unix/Linux/macOS settings
    CC = gcc
    CFLAGS = -Wall -Wextra -std=c99 -fPIC -I c_backend
    PYTHON = python3
    RM = rm -f
    RMDIR = rm -rf
    PATH_SEP = /
    EXE_EXT = 
    TEST_RUN = ./tests/test_c_calc
    MKDIR = mkdir -p
    NULL_DEVICE = /dev/null
endif

# Python package info
PACKAGE_NAME = calculator
BUILD_DIR = build
DIST_DIR = dist

.PHONY: all build test test_c test_python clean install dev-install lint format clean-pycache clean-all setup lint docs

# Default target
all: setup build

# Create necessary directories
setup:
ifeq ($(OS),Windows_NT)
	@if not exist tests $(MKDIR) tests 2>$(NULL_DEVICE) || echo Directory exists
	@if not exist python_interface $(MKDIR) python_interface 2>$(NULL_DEVICE) || echo Directory exists  
	@if not exist c_backend $(MKDIR) c_backend 2>$(NULL_DEVICE) || echo Directory exists
else
	@$(MKDIR) tests python_interface c_backend 2>$(NULL_DEVICE) || true
endif
	@echo "Setting up project structure..."

# Create __init__.py if it doesn't exist
init-files: setup
ifeq ($(OS),Windows_NT)
	@if not exist python_interface\\__init__.py echo from ._calc import add, sub, mul, divide > python_interface\\__init__.py
else
	@test -f python_interface/__init__.py || echo "from ._calc import add, sub, mul, divide" > python_interface/__init__.py
endif

# Build the Python extension
build: init-files
	$(PYTHON) setup.py build_ext --inplace

# Build for development (includes debug symbols)
dev-build: init-files
ifeq ($(OS),Windows_NT)
	$(CC) /c $(CFLAGS) /Zi c_backend$(PATH_SEP)calc.c /Fo:c_backend$(PATH_SEP)calc.obj
else
	$(CC) $(CFLAGS) -g -c c_backend/calc.c -o c_backend/calc.o
endif
	$(PYTHON) setup.py build_ext --inplace --debug

# Run all tests
test: test_c test_python test_cli

# Test C backend
test_c: setup
	@echo "Testing C backend..."
ifeq ($(OS),Windows_NT)
	$(CC) $(CFLAGS) tests$(PATH_SEP)test_c_calc.c c_backend$(PATH_SEP)calc.c /Fe:tests$(PATH_SEP)test_c_calc.exe /I c_backend
	$(TEST_RUN)
	-$(RM) tests$(PATH_SEP)test_c_calc.exe tests$(PATH_SEP)*.obj 2>$(NULL_DEVICE)
else
	$(CC) $(CFLAGS) -I c_backend -o tests/test_c_calc tests/test_c_calc.c c_backend/calc.c
	$(TEST_RUN)
	-$(RM) tests/test_c_calc 2>$(NULL_DEVICE)
endif
	@echo "C tests completed successfully!"

# Test Python interface
test_python: build
	@echo "Testing Python interface..."
	$(PYTHON) -m pytest tests/test_python_calc.py -v

# Test CLI functionality
test_cli: 
	@echo "Testing CLI functionality..."
	@echo "Running basic calculator tests..."
	@calc 5 3 add || echo "Addition test failed"
	@calc 10 2 div || echo "Division test failed"
	@calc 7 4 sub || echo "Subtraction test failed"
	@calc 3 6 mul || echo "Multiplication test failed"
	@echo "CLI tests completed!"

# Alternative: unittest (if you prefer unittest over pytest)
test_python_unittest: build
	$(PYTHON) -m unittest tests.test_python_calc -v

# Run tests with coverage
test_coverage: build
	$(PYTHON) -m pytest --cov=python_interface --cov-report=html --cov-report=xml tests/test_python_calc.py

# Install package in development mode
dev-install: build
	$(PYTHON) -m pip install -e .

# Install package
install: build
	$(PYTHON) -m pip install .

# Code formatting
format:
	@echo "Formatting code..."
	-$(PYTHON) -m black python_interface/ 2>$(NULL_DEVICE) || echo "Black not installed or formatting issues found"
	-$(PYTHON) -m isort python_interface/ 2>$(NULL_DEVICE) || echo "isort not installed or import issues found"

# Code linting
lint:
	@echo "Linting code..."
	-$(PYTHON) -m pre-commit run --all-files
	-$(PYTHON) -m flake8 python_interface/ --max-line-length=88 --ignore=E203,W503,E501 2>$(NULL_DEVICE) || echo "flake8 issues found"
	-$(PYTHON) -m pylint python_interface/ --disable=C0111,C0103,R0903,C0114,C0115,C0116 2>$(NULL_DEVICE) || echo "pylint issues found"

# Build distribution packages
dist: clean build
	$(PYTHON) setup.py sdist bdist_wheel

# Clean __pycache__ directories specifically
clean-pycache:
ifeq ($(OS),Windows_NT)
	@echo Cleaning __pycache__ directories...
	-for /d /r . %%d in (__pycache__) do if exist "%%d" $(RMDIR) "%%d" 2>$(NULL_DEVICE)
else
	@echo "Cleaning __pycache__ directories..."
	-find . -name "__pycache__" -type d -exec rm -rf {} + 2>$(NULL_DEVICE) || true
	-find . -name "*.pyc" -delete 2>$(NULL_DEVICE) || true
	-find . -name "*.pyd" -delete 2>$(NULL_DEVICE) || true
endif
	@echo "Cache cleanup completed."

# Build Sphinx documentation
docs:
	python -m sphinx.cmd.build -b html docs/source docs/build

# Clean build artifacts
clean: clean-pycache
ifeq ($(OS),Windows_NT)
	@echo Cleaning build artifacts...
	-$(RM) *.o *.obj *.exe 2>$(NULL_DEVICE)
	-$(RM) *.pyd 2>$(NULL_DEVICE)
	-$(RM) python_interface$(PATH_SEP)*.pyd 2>$(NULL_DEVICE)
	-$(RM) c_backend$(PATH_SEP)*.o c_backend$(PATH_SEP)*.obj 2>$(NULL_DEVICE)
	-$(RM) tests$(PATH_SEP)*.exe tests$(PATH_SEP)*.obj 2>$(NULL_DEVICE)
	-if exist $(BUILD_DIR) $(RMDIR) $(BUILD_DIR) 2>$(NULL_DEVICE)
	-if exist $(DIST_DIR) $(RMDIR) $(DIST_DIR) 2>$(NULL_DEVICE) 
	-for /d %%i in (*.egg-info) do if exist "%%i" $(RMDIR) "%%i" 2>$(NULL_DEVICE)
	-if exist .pytest_cache $(RMDIR) .pytest_cache 2>$(NULL_DEVICE)
	-if exist htmlcov $(RMDIR) htmlcov 2>$(NULL_DEVICE)
	-if exist .coverage $(RM) .coverage 2>$(NULL_DEVICE)
else
	@echo "Cleaning build artifacts..."
	-$(RM) *.o *.so *.pyc *.pyd 2>$(NULL_DEVICE)
	-$(RM) python_interface/*.so python_interface/*.pyd 2>$(NULL_DEVICE)
	-$(RM) c_backend/*.o 2>$(NULL_DEVICE)
	-$(RM) tests/test_c_calc 2>$(NULL_DEVICE)
	-$(RMDIR) $(BUILD_DIR) $(DIST_DIR) *.egg-info 2>$(NULL_DEVICE) || true
	-$(RMDIR) .pytest_cache htmlcov 2>$(NULL_DEVICE) || true
	-$(RM) .coverage 2>$(NULL_DEVICE) || true
endif
	@echo "Clean completed."

# Deep clean - removes everything including installed packages
clean-all: clean
	@echo "Performing deep clean..."
ifeq ($(OS),Windows_NT)
	-$(PYTHON) -m pip uninstall -y $(PACKAGE_NAME) 2>$(NULL_DEVICE) || echo "Package not installed"
else
	-$(PYTHON) -m pip uninstall -y $(PACKAGE_NAME) 2>$(NULL_DEVICE) || echo "Package not installed"
endif

# Verify installation
verify: install
	@echo "Verifying installation..."
	@$(PYTHON) -c "import calculator; print('Calculator module imported successfully')" || echo "Import failed"
	@$(PYTHON) -c "from calculator import add, sub, mul, divide; print('Functions imported successfully')" || echo "Function import failed"
	@calc --help || echo "CLI help not available"

# Development setup - install all dev dependencies
dev-setup: setup
	@echo "Setting up development environment..."
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install pytest pytest-cov black isort flake8 pylint
	$(PYTHON) -m pip install -r requirements.txt
	$(PYTHON) -m pip install  pre-commit sphinx ninja
	$(PYTHON) -m pre-commit install
	

# Quick test - run a simple functionality check
quick-test: build
	@echo "Running quick functionality test..."
	@$(PYTHON) -c "
	try:
	    from calculator import add, sub, mul, divide
	    assert add(2, 3) == 5
	    assert sub(5, 3) == 2  
	    assert mul(2, 3) == 6
	    assert divide(6, 3) == 2
	    print('✓ All basic operations working correctly')
	except Exception as e:
	    print(f'✗ Quick test failed: {e}')
	    exit(1)
	"

# Help target
help:
	@echo "Available targets:"
	@echo "  all          - Setup and build the project"
	@echo "  setup        - Create necessary directories"
	@echo "  init-files   - Create missing __init__.py files"
	@echo "  build        - Build the Python extension"
	@echo "  dev-build    - Build with debug symbols"
	@echo "  dev-setup    - Install development dependencies"
	@echo "  test         - Run all tests (C, Python, CLI)"
	@echo "  test_c       - Run C tests only"
	@echo "  test_python  - Run Python tests only"
	@echo "  test_cli     - Run CLI tests only"
	@echo "  test_coverage- Run tests with coverage report"
	@echo "  quick-test   - Run basic functionality test"
	@echo "  clean        - Clean build artifacts"
	@echo "  clean-pycache- Clean only __pycache__ directories"
	@echo "  clean-all    - Deep clean including uninstall"
	@echo "  install      - Install the package"
	@echo "  dev-install  - Install in development mode"
	@echo "  format       - Format code with black and isort"
	@echo "  lint         - Lint code with flake8 and pylint"
	@echo "  dist         - Build distribution packages"
	@echo "  verify       - Verify installation works"
	@echo "  help         - Show this help message"
