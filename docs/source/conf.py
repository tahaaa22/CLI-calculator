# Configuration file for the Sphinx documentation builder.

# -- Path setup --------------------------------------------------------------

import os
import sys

sys.path.insert(0, os.path.abspath("../.."))

# -- Project information -----------------------------------------------------

project = "CLI Calculator"
copyright = "2025, docs/source"
author = "docs/source"
release = "docs/build"

# -- General configuration ---------------------------------------------------

extensions = ["sphinx.ext.autodoc", "breathe"]

templates_path = ["_templates"]
exclude_patterns = []

breathe_projects = {"CLI-calculator": "../../xml"}
breathe_default_project = "CLI-calculator"

language = "en"

# -- Options for HTML output -------------------------------------------------

html_theme = "alabaster"
html_static_path = ["_static"]
