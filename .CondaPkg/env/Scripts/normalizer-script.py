#!C:\Users\Elijah Fernandez\Documents\MIT\18.S191\Optimization Project\JuliaBoyz\.CondaPkg\env\python.exe
# -*- coding: utf-8 -*-
import re
import sys

from charset_normalizer.cli.normalizer import cli_detect

if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
    sys.exit(cli_detect())
