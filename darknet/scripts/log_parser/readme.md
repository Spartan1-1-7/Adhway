﻿# parsing training log and plot

## Requirements

1. matplotlib

## Usage

1. --source-dir  the directory of training log files 
2. --save-dir the directory to save loss curve, image and csv file
3. --log-file  log file name to be parsed 
4. --csv-file csv file name to save loss data, default it's same with training log file name
5. --show  whether to show after finished parsing, default False, just works on windows or linux with GUI desktop

`python log_parser.py --source-dir ./ --save-dir ./ --log-file test.log --show true`

![plot](https://github.com/AlexeyAB/darknet/blob/master/scripts/log_parser/test_new.svg)
