#!/usr/bin/env python3

print('var cmakeConfig = ""');

with open("CMakeConfig.cmake.in", "r") as f:
    for line in f:
        if '\n' == line[-1]:
            line = line[:-1]
            print("\t+ '%s\\n'" % line.replace(r'\"', r'\\"').replace(r"'", r"\'"))

print(";")
