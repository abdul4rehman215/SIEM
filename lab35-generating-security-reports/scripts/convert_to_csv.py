# scripts/convert_to_csv.py
import csv

with open('summary.log', 'r') as infile, open('report.csv', 'w', newline='') as outfile:
    writer = csv.writer(outfile)
    for line in infile:
        writer.writerow(line.strip().split())
