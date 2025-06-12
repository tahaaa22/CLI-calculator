"""
Calculator package - C-backed calculator with Python interface
"""

try:
    from ._calc import add, sub, mul, divide
except ImportError as e:
    # Provide a helpful error message if the C extension isn't built
    raise ImportError(
        "Cannot import C extension. Please build the extension first:\n"
        "  python setup.py build_ext --inplace\n"
        f"Original error: {e}"
    )

__version__ = "0.1.0"
__author__ = "Youssef Awad, Amr Doma"

# Export the main functions
__all__ = ["add", "sub", "mul", "divide"]
