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
    TEST_RUN = .\tests\test_c_calc.exe
else
    # Unix/Linux settings (for GitHub Actions)
    CC = gcc
    CFLAGS = -Wall -Wextra -std=c99 -fPIC -I c_backend
    PYTHON = python3
    RM = rm -f
    RMDIR = rm -rf
    PATH_SEP = /
    EXE_EXT = 
    TEST_RUN = ./tests/test_c_calc
endif

# Python package info
PACKAGE_NAME = python_interface
BUILD_DIR = build
DIST_DIR = dist

.PHONY: all build test test_c test_python clean install dev-install lint format clean-pycache clean-all

# Default target
all: build

# Build the Python extension
build:
	$(PYTHON) setup.py build_ext --inplace

# Build for development (includes debug symbols)
dev-build:
ifeq ($(OS),Windows_NT)
	$(CC) /c $(CFLAGS) /Zi c_backend$(PATH_SEP)calc.c /Fo:c_backend$(PATH_SEP)calc.obj
else
	$(CC) $(CFLAGS) -g -c c_backend/calc.c -o c_backend/calc.o
endif
	$(PYTHON) setup.py build_ext --inplace --debug

# Run all tests
test: test_c test_python

# Test C backend
test_c:
ifeq ($(OS),Windows_NT)
	$(CC) tests$(PATH_SEP)test_c_calc.c c_backend$(PATH_SEP)calc.c /Fe:tests$(PATH_SEP)test_c_calc.exe
	$(TEST_RUN)
	$(RM) tests$(PATH_SEP)test_c_calc.exe tests$(PATH_SEP)*.obj
else
	$(CC) $(CFLAGS) -o tests/test_c_calc tests/test_c_calc.c c_backend/calc.c
	$(TEST_RUN)
	$(RM) tests/test_c_calc
endif

# Test Python interface
test_python:
	$(PYTHON) -m pytest python_interface/test_python_calc.py -v

# Alternative: unittest (if you prefer unittest over pytest)
test_python_unittest:
	$(PYTHON) -m unittest python_interface.test_python_calc -v

# Run tests with coverage
test_coverage:
	$(PYTHON) -m pytest --cov=python_interface --cov-report=html --cov-report=xml

# Install package in development mode
dev-install:
	$(PYTHON) -m pip install -e .

# Install package
install:
	$(PYTHON) -m pip install .

# Code formatting
format:
	$(PYTHON) -m black python_interface/
	$(PYTHON) -m isort python_interface/

# Code linting
lint:
	$(PYTHON) -m flake8 python_interface/
	$(PYTHON) -m pylint python_interface/

# Build distribution packages
dist: clean
	$(PYTHON) setup.py sdist bdist_wheel

# Clean __pycache__ directories specifically
clean-pycache:
ifeq ($(OS),Windows_NT)
	@echo Cleaning __pycache__ directories...
	-for /d /r . %%d in (__pycache__) do if exist "%%d" $(RMDIR) "%%d" 2>nul
	@echo Done.
else
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
endif

# Clean build artifacts
clean:
ifeq ($(OS),Windows_NT)
	@echo Cleaning build artifacts...
	-$(RM) *.o *.obj *.exe 2>nul
	-$(RM) *.pyd 2>nul
	-$(RM) python_interface$(PATH_SEP)*.pyd 2>nul
	-$(RM) c_backend$(PATH_SEP)*.o c_backend$(PATH_SEP)*.obj 2>nul
	-$(RM) tests$(PATH_SEP)*.exe tests$(PATH_SEP)*.obj 2>nul
	-if exist $(BUILD_DIR) $(RMDIR) $(BUILD_DIR) 2>nul
	-if exist $(DIST_DIR) $(RMDIR) $(DIST_DIR) 2>nul
	-for /d %%i in (*.egg-info) do if exist "%%i" $(RMDIR) "%%i" 2>nul
	-if exist .pytest_cache $(RMDIR) .pytest_cache 2>nul
	-if exist htmlcov $(RMDIR) htmlcov 2>nul
	-if exist .coverage $(RM) .coverage 2>nul
	$(MAKE) clean-pycache
	@echo Clean completed.
else
	$(RM) *.o *.so *.pyc *.pyd
	$(RM) python_interface/*.so python_interface/*.pyd
	$(RM) c_backend/*.o
	$(RM) tests/test_c_calc
	$(RMDIR) $(BUILD_DIR) $(DIST_DIR) *.egg-info
	$(RMDIR) __pycache__ .pytest_cache htmlcov
	$(RM) .coverage
	find . -name "*.pyc" -delete
	find . -name "*.pyd" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
endif

# Deep clean - removes everything including installed packages
clean-all: clean
ifeq ($(OS),Windows_NT)
	@echo Performing deep clean...
	-$(PYTHON) -m pip uninstall -y $(PACKAGE_NAME) 2>nul
else
	$(PYTHON) -m pip uninstall -y $(PACKAGE_NAME) 2>/dev/null || true
endif

# Help target
help:
	@echo "Available targets:"
	@echo "  build        - Build the Python extension"
	@echo "  dev-build    - Build with debug symbols"
	@echo "  test         - Run all tests"
	@echo "  test_c       - Run C tests only"
	@echo "  test_python  - Run Python tests only"
	@echo "  test_coverage- Run tests with coverage report"
	@echo "  clean        - Clean build artifacts"
	@echo "  clean-pycache- Clean only __pycache__ directories"
	@echo "  clean-all    - Deep clean including uninstall"
	@echo "  install      - Install the package"
	@echo "  dev-install  - Install in development mode"
	@echo "  format       - Format code with black and isort"
	@echo "  lint         - Lint code with flake8 and pylint"
	@echo "  dist         - Build distribution packages"
	@echo "  help         - Show this help message"