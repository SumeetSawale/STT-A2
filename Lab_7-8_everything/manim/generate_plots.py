import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load the CSV file
df = pd.read_csv("bandit_report.csv")

# Trim column names to remove leading/trailing spaces
df.columns = df.columns.str.strip()

# Line plot for issues based on severity
plt.figure(figsize=(10, 5))
df[['High Severity', 'Medium Severity', 'Low Severity']].plot(kind='line')
plt.title('Issues Based on Severity')
plt.xlabel('Commit Index')
plt.ylabel('Number of Issues')
plt.legend(['High Severity', 'Medium Severity', 'Low Severity'])
plt.grid()
plt.show()

# Line plot for issues based on confidence
plt.figure(figsize=(10, 5))
df[['High Confidence', 'Medium Confidence', 'Low Confidence']].plot(kind='line')
plt.title('Issues Based on Confidence')
plt.xlabel('Commit Index')
plt.ylabel('Number of Issues')
plt.legend(['High Confidence', 'Medium Confidence', 'Low Confidence'])
plt.grid()
plt.show()

# Histogram for CWE occurrences
cwe_list = []
for cwe_str in df['CWEs'].dropna():
    cwe_list.extend(cwe_str.replace('"', '').split(';'))

cwe_series = pd.Series(cwe_list)
cwe_series = cwe_series[cwe_series != '']  # Remove empty strings

plt.figure(figsize=(12, 6))
sns.histplot(cwe_series, bins=len(cwe_series.unique()), kde=False, discrete=True, binwidth=1, shrink=0.5)
plt.xticks(rotation=90)
plt.title('Histogram of CWE Occurrences')
plt.xlabel('CWE ID')
plt.ylabel('Frequency')
plt.grid()
plt.show()