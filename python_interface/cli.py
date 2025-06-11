#!/usr/bin/env python3
"""
CLI Calculator - Command line interface for the calculator module
"""
import argparse
import sys

try:
    from . import add, sub, mul, divide
except ImportError:
    # Handle case when running as script directly
    from calculator import add, sub, mul, divide


def main():
    """Main CLI function"""
    parser = argparse.ArgumentParser(
        description="CLI Calculator - Perform basic arithmetic operations",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  calc 5 3 add     # Addition: 5 + 3 = 8
  calc 10 2 div    # Division: 10 / 2 = 5
  calc 7 4 sub     # Subtraction: 7 - 4 = 3
  calc 3 6 mul     # Multiplication: 3 * 6 = 18
        """,
    )

    parser.add_argument("a", type=float, help="First number")
    parser.add_argument("b", type=float, help="Second number")
    parser.add_argument(
        "op", choices=["add", "sub", "mul", "div"], help="Operation to perform"
    )

    try:
        args = parser.parse_args()

        # Map operations to functions
        operations = {
            "add": add,
            "sub": sub,
            "mul": mul,
            "div": divide,
        }

        # Perform calculation
        result = operations[args.op](args.a, args.b)

        # Format output
        op_symbols = {"add": "+", "sub": "-", "mul": "*", "div": "/"}

        print(f"{args.a} {op_symbols[args.op]} {args.b} = {result}")

        # Ensure output is flushed
        sys.stdout.flush()

    except KeyboardInterrupt:
        print("\nOperation cancelled.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
