# Final Project: Transforming and Analyzing Data with SQL

## Project Goals
The goal of this project is to practice my SQL skills by answering data-related questions, performing data transformations, and cleaning messy data. Additionally, I will explore new questions that arise during the process.

## Process Overview

1. **Import Data**: Imported data from CSV files into PostgreSQL.
2. **Explore the Data**: Analyzed the structure of the dataset, including the number of tables, columns, data types, and relationships between the tables.
3. **Answer Questions**: Used SQL queries to answer predefined questions about the data.
4. **Data Cleaning**: Cleaned and transformed the data to ensure accuracy and consistency.
5. **Ask New Questions**: Formulated and answered additional questions of interest.
6. **Summarize Results**: Summarized key findings based on the analysis.

## Results

### Key Insights:
- The majority of top sales are from developed countries, predominantly in North America and Europe.
- Time spent on the site by visitors does not necessarily correlate with higher product purchases.
- The number of page views also does not strongly influence product sales.
- The most significant factor affecting product sales is the visitor's location. Visitors from more developed countries tend to purchase more products.

## Challenges 

The biggest challenge was cleaning the data, which was very messy and inconsistent. This required significant effort to ensure accuracy and consistency, especially for the `analytics` table. 

### SQL Optimization:
The SQL processing time was initially very slow. I implemented optimization techniques such as:
- Filtering data to reduce the number of rows.
- Selecting specific columns to minimize data size.
- Using aggregate functions to condense the dataset.

## Future Goals

If I had more time, I would explore visualization tools for PostgreSQL to make the analysis more intuitive and visually appealing.
