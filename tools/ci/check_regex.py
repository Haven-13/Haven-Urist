'''
Usage:
    $ python check_regex.py

check_regex.py - Run regex expression tests on all DM code inside current
    directory

    To add, modify, or remove test cases/expressions, edit this script.
    See the "cases" variable and the use of exact(int, string, string).

Copyright 2021 Martin Lyrå

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
'''

# Standard Python
import os
import re as regex
import time

# Third party
import colorama
from colorama import Fore, Back, Style

class TestExpression:
    def __init__(self, expected, message, pattern) -> None:
        self.expected = expected
        self.message = message
        self.pattern = pattern

def exactly(num, message, pattern) -> TestExpression:
    return TestExpression(num, message, pattern)

# These were lifted from the old check_paths.sh script
# With the original comment:
#
# With the potential exception of << if you increase any
# of these numbers you're probably doing it wrong
cases = [
    exactly(0, "escapes", r'\\\\(red|blue|green|black|b|i[^mc])'),
    exactly(6, "Del()s", r'\WDel\('),

    exactly(2, "/atom text paths", r'"/atom'),
    exactly(2, "/area text paths", r'"/area'),
    exactly(2, "/datum text paths", r'"/datum'),
    exactly(2, "/mob text paths", r'"/mob'),
    exactly(19, "/obj text paths", r'"/obj'),
    exactly(8, "/turf text paths", r'"/turf'),
    exactly(28, "text2path uses", r'text2path'),

    exactly(0, "world<< uses", r'world[ \t]*<<'),
    exactly(0, "world.log<< uses", r'world.log[ \t]*<<'),
    exactly(208, "to_world() uses", r'to_world\('),
    exactly(71, "to_world_log() uses", r'to_world_log\('),

    exactly(113, "<< uses", r'(?<!<)<<(?!<)'),
    exactly(0, "incorrect indentations", r'^( {4,})'),
    exactly(0, "superflous whitespace", r'[ \t]+$'),
    exactly(74, "mixed indentation", r'^( +\t+|\t+ +)')
]
# With the potential exception of << if you increase any
# of these numbers you're probably doing it wrong

def construct_filename_regex(extensions):
    return regex.compile(rf'\.({str.join("|", extensions)})$')

def collect_candidate_files(directory, extensions):
    if not isinstance(extensions, list):
        extensions = [extensions]
    expression = construct_filename_regex(extensions)

    def is_a_match(file):
        return regex.search(expression, file) is not None

    candidates = dict()
    for path, subdirectories, files in os.walk(directory):
        for file in files:
            if is_a_match(file):
                full_path = os.path.join(path, file)
                full_path = os.path.normpath(full_path)
                candidates[len(candidates) + 1] = full_path
    return candidates

# A constant for the function below, so it won't be compiled
# every time the function is called
line_comment_regex_expression = regex.compile(r'^\s*\/\/')

def test_file(results, expressions, file, ignore_comments=False):
    def is_a_line_comment(line):
        return line_comment_regex_expression.match(line)

    is_comment_block = False
    for line in open(file, 'r', encoding='latin-1'):
        if ignore_comments:
            if str.find(line, '/*') >= 0:
                is_comment_block = True
            if str.find(line, '*/') >= 0:
                is_comment_block = False
            if is_comment_block or is_a_line_comment(line):
                continue

        for it in range(0, len(expressions)):
            expression = expressions[it]
            matches = regex.findall(expression, line)
            if len(matches) > 0:
                key = file
                for _ in matches:
                    if key not in results[it]:
                        results[it][key] = 1
                    else:
                        results[it][key] += 1
                    results[it]["SUM"] += 1


if __name__ == "__main__":
    colorama.init()

    start_time = time.time()
    files_to_test = collect_candidate_files('./', 'dm')

    results = list()
    expressions = list()
    for it in range(0, len(cases)):
        case = cases[it]
        results.append({
            "SUM": 0
        })
        expressions.append(regex.compile(case.pattern))

    for it in files_to_test:
        file = files_to_test[it]
        test_file(results, expressions, file)

    # This is the end, go process the data then show the results!

    print(f"\n{'='*5} Regex Results {'='*36}")
    print("\n%-12s | %-6s | %s"
        % (
            "Result",
            "Target",
            "Description"
        )
    )
    print(f"{'-'*13}+{'-'*8}+{'-'*33}")

    failure = 0
    for it in range(0, len(results)):
        case = cases[it]
        count = results[it]["SUM"]

        match = True
        colour = Fore.GREEN
        if not count == case.expected:
            failure += 1
            match = False
            colour = Fore.RED

        print(
            (f"{colour}%4s:%7i |%7i | %s{Fore.RESET}")
            % (
                "OK" if match else ">>>>",
                count,
                case.expected,
                case.message
            )
        )
    print("\n"
        + (
            f"{Fore.RED}There are mismatches present, please address those"
            if failure else
            f"{Fore.GREEN}All OK!"
        ) + Fore.RESET
    )
    print("\nThis script completed in %7.3f seconds"
        % (time.time() - start_time)
    )
    print(f"{'='*56}\n")

    exit(failure > 0)
