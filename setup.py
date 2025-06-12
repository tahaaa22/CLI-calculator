# setup.py
from setuptools import setup, Extension

# Define the C extension
calc_ext = Extension(
    "calculator._calc",
    sources=["python_interface/calculator.c", "c_backend/calc.c"],
    include_dirs=["python_interface", "c_backend"],
)

setup(
    name="calculator",
    version="0.1.0",
    author="Youssef Awad, Amr Doma",
    description="C-backed CLI calculator",
    packages=["calculator"],
    package_dir={"calculator": "python_interface"},
    ext_modules=[calc_ext],
    entry_points={
        "console_scripts": [
            "calc=calculator.cli:main",
        ]
    },
    python_requires=">=3.7",
    zip_safe=False,  # Important for C extensions
)
