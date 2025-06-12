.. CLI Calculator documentation master file, created by
   sphinx-quickstart on Thu Jun 12 17:21:26 2025.

CLI Calculator documentation
============================

A command-line calculator with a C extension backend and a Python interface.

Project Structure
-----------------

- **python_interface/**: Python CLI and C extension wrappers.
- **calculator.c**: C extension source code for arithmetic operations.
- **calc.h**: C header for arithmetic functions.
- **docs/**: Sphinx documentation.
- **cli.py**: Python CLI for calculator operations.

Usage
-----

Run the CLI calculator from the command line:

.. code-block:: shell

   python -m python_interface.cli 5 3 add
   # Output: 5.0 + 3.0 = 8.0

   python -m python_interface.cli 10 2 div
   # Output: 10.0 / 2.0 = 5.0

C Extension API
---------------

The core arithmetic operations are implemented in C for performance and exposed to Python.

.. doxygenfunction:: add
   :project: CLI-calculator

.. doxygenfunction:: sub
   :project: CLI-calculator

.. doxygenfunction:: mul
   :project: CLI-calculator

.. doxygenfunction:: divide
   :project: CLI-calculator

Build Instructions
------------------

To build the C extension:

.. code-block:: shell

   python setup.py build_ext --inplace

If you encounter import errors, ensure the extension is built and available.

Authors
-------
- Ahmed mohamed taha
- Sama mohamed
- Ghada Tarek
- Youssef Awad
- Amr Doma

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   modules
