import unittest
from calculator import _calc


class TestCalcPython(unittest.TestCase):
    def test_add(self):
        self.assertEqual(_calc.add(2, 3), 5)

    def test_sub(self):
        self.assertEqual(_calc.sub(5, 3), 2)

    def test_mul(self):
        self.assertEqual(_calc.mul(2, 3), 6)

    def test_divide(self):
        self.assertEqual(_calc.divide(6, 3), 2)
        self.assertEqual(_calc.divide(5, 0), 0)


if __name__ == "__main__":
    unittest.main()
