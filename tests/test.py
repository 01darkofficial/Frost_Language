import os
import subprocess

def read_expected_output(file_path):
    """
    Extract expected output or error comments from the test file.
    """
    expected = []
    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if line.startswith("// expect:"):
                expected.append(line[10:].strip())
            elif line.startswith("// expect error:"):
                expected.append(f"ERROR: {line[15:].strip()}")
    return expected


def run_test(interpreter_path, test_file):
    """
    Run the test file through the interpreter and capture its output.
    """
    try:
        result = subprocess.run(
            [interpreter_path, test_file],
            capture_output=True,
            text=True,
            timeout=5
        )
        output = result.stdout.strip()
        errors = result.stderr.strip()
        combined_output = output + (("\n" + errors) if errors else "")
        print(f"DEBUG: Actual Output:\n{combined_output}")  # Debugging
        return True, combined_output.strip()
    except Exception as e:
        return False, f"Test execution failed: {e}"


def compare_output(actual, expected):
    """
    Compare actual output to expected output.
    """
    actual_lines = actual.splitlines()
    if len(actual_lines) != len(expected):
        return False, f"Line count mismatch.\nExpected: {len(expected)}, Got: {len(actual_lines)}"
    
    for i, (actual_line, expected_line) in enumerate(zip(actual_lines, expected)):
        if actual_line != expected_line:
            return False, f"Line {i + 1} mismatch.\nExpected: {expected_line}\nGot: {actual_line}"
    
    return True, "Pass"


def run_tests(interpreter_path, test_dir):
    """
    Run all tests in the specified directory.
    """
    passed = 0
    failed = 0

    for root, _, files in os.walk(test_dir):
        for file in files:
            if file.endswith(".ft"):  # Replace with your test file extension
                test_file = os.path.join(root, file)
                print(f"Running test: {test_file}")
                
                # Read expected output
                expected = read_expected_output(test_file)
                if not expected:
                    print(f"SKIPPED: No expectations in {test_file}")
                    continue

                # Run the test
                success, actual_output = run_test(interpreter_path, test_file)
                if not success:
                    print(f"ERROR: {actual_output}")
                    failed += 1
                    continue

                # Compare output
                is_correct, message = compare_output(actual_output, expected)
                if is_correct:
                    print("PASS")
                    passed += 1
                else:
                    print("FAIL")
                    print(message)
                    failed += 1

    # Report results
    print("\nTest Summary")
    print(f"Passed: {passed}")
    print(f"Failed: {failed}")


if __name__ == "__main__":
    # Path to your interpreter executable
    interpreter_path = "./build/frost.exe"  # Replace with your interpreter path
    # Path to the test directory
    test_dir = "tests"

    run_tests(interpreter_path, test_dir)
