import unittest
import sys
import os

# Add the parent directory to the Python path to import calculator
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

try:
    from calculator import _calc
except ImportError:
    # If running from different context, try alternative imports
    try:
        import python_interface._calc as _calc
    except ImportError:
        # Last resort - try importing from built extension
        try:
            from python_interface import _calc
        except ImportError:
            raise ImportError("Cannot import _calc module. ")


class TestCalcPython(unittest.TestCase):
    def test_add(self):
        self.assertEqual(_calc.add(2, 3), 5)
        self.assertEqual(_calc.add(-1, 1), 0)
        self.assertAlmostEqual(_calc.add(0.1, 0.2), 0.3, places=10)

    def test_sub(self):
        self.assertEqual(_calc.sub(5, 3), 2)
        self.assertEqual(_calc.sub(0, 5), -5)
        self.assertEqual(_calc.sub(-2, -3), 1)

    def test_mul(self):
        self.assertEqual(_calc.mul(2, 3), 6)
        self.assertEqual(_calc.mul(0, 100), 0)
        self.assertEqual(_calc.mul(-2, 3), -6)

    def test_divide(self):
        self.assertEqual(_calc.divide(6, 3), 2)
        self.assertEqual(_calc.divide(5, 0), 0)  # Division by zero returns 0
        self.assertAlmostEqual(_calc.divide(1, 3), 0.3333333333333, places=10)

    def test_edge_cases(self):
        # Test very large numbers
        self.assertAlmostEqual(_calc.add(1e15, 1e15), 2e15)

        # Test very small numbers
        self.assertAlmostEqual(_calc.mul(1e-15, 1e-15), 1e-30, places=40)

        # Test negative zero
        self.assertEqual(_calc.add(0, -0), 0)


if __name__ == "__main__":
    unittest.main()
