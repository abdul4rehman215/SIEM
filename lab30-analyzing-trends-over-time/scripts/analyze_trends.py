# scripts/analyze_trends.py
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime

# Task 1: Load Data
data = pd.read_csv('login_attempts.csv', parse_dates=['date'])

# Task 1: Preview Data
print(data.head())

# Task 2: Set date as index
data.set_index('date', inplace=True)

# Task 2: Create line chart
plt.figure(figsize=(10, 5))
plt.plot(data.index, data['attempts'], marker='o', linestyle='-')
plt.title('Weekly Login Attempts Over Time')
plt.xlabel('Date')
plt.ylabel('Number of Attempts')
plt.grid(True)
plt.show()

# Task 3: Weekly averages
data_weekly = data.resample('W').mean()
print(data_weekly)

# Task 3: Visual comparison
plt.figure(figsize=(10, 5))
sns.lineplot(data=data_weekly, x=data_weekly.index, y='attempts', label='Weekly Average Attempts')
plt.title('Comparison of Weekly Login Attempts')
plt.xlabel('Week')
plt.ylabel('Average Attempts')
plt.grid(True)
plt.show()

# Task 4: Identify anomalies
threshold = data_weekly['attempts'].mean() + 2 * data_weekly['attempts'].std()
anomalies = data_weekly[data_weekly['attempts'] > threshold]

# Task 4: Plot anomalies
plt.figure(figsize=(10, 5))
sns.lineplot(data=data_weekly, x=data_weekly.index, y='attempts')
plt.scatter(anomalies.index, anomalies['attempts'], color='red', label='Anomalies')
plt.title('Anomaly Detection in Weekly Attempts')
plt.xlabel('Week')
plt.ylabel('Average Attempts')
plt.legend()
plt.show()

# Task 5: Export snapshot
plt.figure(figsize=(10, 5))
sns.lineplot(data=data_weekly, x=data_weekly.index, y='attempts')
plt.savefig('weekly_attempts_snapshot.pdf')
