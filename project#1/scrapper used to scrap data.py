import requests
from bs4 import BeautifulSoup
import csv

# URL of the archived Wikipedia page
url = 'https://web.archive.org/web/20230908091635/https:/en.wikipedia.org/wiki/List_of_largest_banks'

# Send a GET request to the URL
response = requests.get(url)
if response.status_code != 200:
    raise Exception(f"Failed to load page with status code: {response.status_code}")

# Parse the HTML content using BeautifulSoup
soup = BeautifulSoup(response.content, 'html.parser')

# Find all tables with the class 'wikitable'
tables = soup.find_all('table', {'class': 'wikitable'})

# Ensure there are at least two tables
if len(tables) < 2:
    raise Exception("Less than two tables found on the page")

# Select the second table
table = tables[1]

# Initialize a list to hold the rows of data
data = []

# Extract the table headers (for the first row)
headers = table.find_all('th')
header_row = [header.get_text(strip=True) for header in headers]
data.append(header_row)

# Extract the table rows
rows = table.find_all('tr')[1:]  # Skip the header row

for row in rows:
    cols = row.find_all('td')
    if len(cols) >= 3:  # Ensure there are enough columns
        rank = cols[0].get_text(strip=True)
        bank_name = cols[1].get_text(strip=True)
        total_assets = cols[2].get_text(strip=True)
        # Add the dollar sign to the total assets
        total_assets = f"${total_assets}"
        data.append([rank, bank_name, total_assets])

# Define the column headers for the CSV file
csv_headers = ['Rank', 'Bank name', 'Total assets (2022) (US$ billion)']

# Write the data to a CSV file
with open('exchange.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(csv_headers)
    writer.writerows(data[1:])  # Skip the original header row and write only the data

print("Data successfully extracted and saved to 'exchange.csv'")
