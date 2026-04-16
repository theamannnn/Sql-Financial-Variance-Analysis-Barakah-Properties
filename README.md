# 📊 Sql-Financial-Variance-Analysis-Barakah-Properties - Track Property Costs With Clarity

[![Download the app](https://img.shields.io/badge/Download%20Release-4B8BBE?style=for-the-badge&logo=github&logoColor=white)](https://github.com/theamannnn/Sql-Financial-Variance-Analysis-Barakah-Properties/releases)

## 🖥️ What This Project Does

This project helps a property management team compare rental income with maintenance costs. It uses PostgreSQL to answer business questions about where money comes in, where money goes out, and how those numbers change across properties and time.

The database includes:
- 5 related tables
- 1,800+ transaction records
- JOINs to connect data
- GROUP BY to roll up totals
- CASE WHEN to label results
- HAVING to filter grouped data
- CTEs to make queries easier to follow
- subqueries for deeper checks

It is built for users who want a clear view of financial variance in a real estate setting.

## 📥 Download and Run on Windows

1. Go to the [Releases page](https://github.com/theamannnn/Sql-Financial-Variance-Analysis-Barakah-Properties/releases)
2. Download the latest Windows release file
3. Open the downloaded file from your Downloads folder
4. If Windows asks for permission, choose **Run** or **Yes**
5. Follow the on-screen steps to load the database files or open the project package
6. If the release includes a SQL file, open it in PostgreSQL tools such as pgAdmin
7. If the release includes a setup package, run it and follow the prompts
8. Start the included analysis or open the database files as instructed in the release

## 🔧 What You Need

You do not need advanced computer skills to use this project. A standard Windows PC is enough.

Recommended setup:
- Windows 10 or Windows 11
- At least 4 GB of RAM
- 200 MB of free disk space
- PostgreSQL installed, or pgAdmin if the package includes SQL scripts
- Internet access for the initial download

If you plan to explore the SQL queries, install:
- PostgreSQL
- pgAdmin 4
- A text editor such as Notepad++ or VS Code

## 📁 Project Contents

This repository centers on a property finance model with linked tables that store:
- rental records
- maintenance costs
- property details
- time periods
- related transaction data

The SQL logic is built to support questions such as:
- Which properties produce the most rental income?
- Which properties have the highest maintenance cost?
- Where does income exceed cost, and by how much?
- Which months show the largest variance?
- Which properties need closer review?

## 🚀 Getting Started

Follow these steps after download:

1. Download the release from the Releases page
2. Extract the files if they come in a ZIP folder
3. Open the folder and look for a README file or SQL file
4. If you see a `.sql` file, open it in pgAdmin or another PostgreSQL tool
5. Restore or run the script in the order shown
6. Check that all tables load without errors
7. Run the sample queries to view the analysis

If the release includes a ready-to-use package, you can open it and start reviewing the results right away.

## 🗄️ Database Structure

The project uses 5 related tables to keep the data organized. The table design supports clean reporting and reduces repeated data.

Common table types in the project:
- properties
- tenants
- rental income
- maintenance records
- reporting periods

This structure makes it easier to compare rent and cost data without mixing unrelated records.

## 📈 Questions This Analysis Answers

The SQL in this project is built around 7 business questions. These questions help a property team review performance and spot problems.

Examples include:
- Which property earns the most rental income?
- Which property spends the most on maintenance?
- What is the net variance for each property?
- Which period shows the best result?
- Which period shows the worst result?
- Which properties have steady income but rising costs?
- Which properties should be reviewed first?

The queries use:
- JOINs to combine tables
- GROUP BY to total values
- CASE WHEN to mark results like profit, loss, or neutral
- HAVING to keep only grouped results that meet a rule
- CTEs to break complex logic into steps
- subqueries to compare one result against another

## 🧩 How the SQL Is Organized

The SQL is written to be readable and useful. Each query focuses on one task.

You may find sections like:
- data loading
- table checks
- income totals
- cost totals
- variance checks
- ranked results
- filtered results for review

This layout helps a user follow the flow from raw records to final numbers.

## 🪟 Opening the Files in Windows

After download, Windows may show the file in one of these forms:
- a ZIP folder
- a SQL script
- a database backup file
- a release package

If you see a ZIP folder:
1. Right-click the file
2. Choose **Extract All**
3. Pick a folder
4. Open the extracted folder

If you see a SQL file:
1. Open pgAdmin
2. Connect to PostgreSQL
3. Open the Query Tool
4. Load the SQL file
5. Run the script

If you see a backup file:
1. Open pgAdmin
2. Create or select a database
3. Restore the backup
4. Wait for the import to finish

## 🧾 Sample Output You Can Expect

The analysis is designed to show clear results such as:
- total rental income by property
- total maintenance cost by property
- net variance by month
- properties with positive variance
- properties with negative variance
- ranked property performance
- grouped totals for review

These outputs help turn raw records into simple business insight.

## 🔍 Why This Project Is Useful

Property teams often track rent and cost in separate files. That makes it hard to see the full picture. This project puts the data into one PostgreSQL model so the team can compare values with less effort.

It helps with:
- monthly review
- property ranking
- cost control
- income tracking
- variance analysis
- management reporting

## 🛠️ Troubleshooting

If the file does not open:
- make sure the download finished
- extract the ZIP file first
- check that Windows did not block the file
- try opening it again from the extracted folder

If the SQL script does not run:
- confirm that PostgreSQL is installed
- make sure you are connected to the correct database
- check that all tables were created in the right order
- look for missing semicolons or file paths if you edited the file

If the data does not appear:
- refresh the table view
- rerun the import script
- verify that the database connection is active

## 🧠 File and Topic Focus

This project is built around:
- cte
- data analysis
- data analytics
- financial analysis
- postgresql
- property management
- real estate
- sql
- variance analysis
- window functions

These topics match the project’s goal of showing how property income compares with maintenance spending.

## 📌 Quick Use Guide

1. Download the latest release
2. Open it on Windows
3. Load the SQL files into PostgreSQL
4. Run the queries
5. Review the income, cost, and variance results

## 📎 Download Again

[Visit the Releases page to download](https://github.com/theamannnn/Sql-Financial-Variance-Analysis-Barakah-Properties/releases)