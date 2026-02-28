# Kibana Dashboard Build Notes — Basic SIEM Overview

## Access
- URL: http://localhost:5601
- Logged in successfully (credentials not recorded)

## Dashboard Created
- Name: Basic SIEM Overview

## Visualizations Added

### 1) Log Count Over Time
- Type: Line chart
- X-axis: @timestamp (Date Histogram)
- Interval: Hourly
- Y-axis: Count
- Saved as: Log Count Over Time
- Observation: spike visible after inserting test auth log line

### 2) Top 5 Source IPs
- Type: Data Table
- Bucket: Terms
- Field: source.ip
- Size: 5
- Saved as: Top 5 Source IPs
- Example values:
  - 203.0.113.55 (12)
  - 192.168.1.1 (8)
  - 10.0.2.23 (6)
  - 198.51.100.22 (4)
  - 10.0.2.10 (3)

### 3) Top Event Categories
- Type: Data Table
- Bucket: Terms
- Field: event.category
- Size: 5
- Saved as: Top Event Categories
- Example values:
  - authentication (15)
  - network (11)
  - process (9)
  - file (6)
  - system (4)

## Layout
- Line chart at top (wide)
- Two tables below (side-by-side)

## Sharing
- Used Kibana “Share” option to generate internal URL
- Accessible to authenticated users
