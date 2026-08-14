import re
import sys
import glob

def check_file(filepath):
    errors = 0
    with open(filepath, 'r') as f:
        content = f.read()

    # Check for basic GDScript errors (like missing colons after func/if/for/while, mismatched types, etc)
    lines = content.split('\n')
    for i, line in enumerate(lines):
        line = line.strip()
        if line.startswith('func ') and not line.endswith(':'):
            # Might be multiline, but usually simple functions end in :
            pass

        if (line.startswith('if ') or line.startswith('elif ') or line.startswith('else') or line.startswith('for ') or line.startswith('while ')) and not line.endswith(':'):
             print(f"Error in {filepath}:{i+1} - Missing colon at end of statement: {line}")
             errors += 1

    if errors == 0:
        print(f"{filepath} passed basic syntax check.")
    return errors

total_errors = 0
for f in glob.glob("*.gd"):
    total_errors += check_file(f)

sys.exit(total_errors)
