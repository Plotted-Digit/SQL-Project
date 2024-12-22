# SQL Project - Business Analysis

A comprehensive analysis of business data using SQL queries to solve critical problem statements.

## Table of Contents
- [Overview](#overview)
- [Deliverables](#Deliverables)
- [Problem Statements](#Problem-Statements)
- [Explanation of Code](#Explanation-of-Code)
- [Presentation and Findings](#Presentation-and-Findings)
- [Navigation](#Navigation)

## Overview

Here is the sql to calculate the provided problem and the data output screenshots.


## Deliverables

The project's deliverables include the following:

- **SQL Query File**: Contains the SQL queries used to generate data for solving each problem statement.
- **OUTPUT**: OUTPUT TABLE.
- **PIE CHART**: PIE CHART.

## Problem Statements

### Top 10 Highest Selling Products
**Problem Statement:** Determine the top 10 highest selling products in the database using the `salesorderdetail` table and `LineTotal` as sales. Create a Pie chart to visualize this information.

## Explanation of Code 

```sql
-- SQL Query for Problem Statement 1
#Select Database
use adventureworks;
SELECT
#Select table fields ProductID and sum of LineTotal for each ProductID
ProductID,
round(sum(LineTotal), 4) as Sales
#Define the Source Table
FROM adventureworks.salesorderdetail
#Partioning the table for each ProductID
group by ProductID
#Arrange all data in descending order of Sales
order by Sales desc 
#Show top 10 rows only
limit 10;
```

## Presentation and Findings

THE TABLE OF OUTPUT DATA

![Table Output of Data](Table_Question_1.png)

THE PIE CHART CREATED WITH OUTPUT DATA

![Pie Chart of Data](PIE_Chart_Question_1.png)




## Navigation

[Main Page](https://github.com/Plotted-Digit/SQL-Project/) &emsp; [1st Problem](https://github.com/Plotted-Digit/SQL-Project/tree/main/QUESTION_1/readme.md) &emsp; [2nd Problem](https://github.com/Plotted-Digit/SQL-Project/tree/main/QUESTION_2/readme.md) &emsp; [3rd Problem](https://github.com/Plotted-Digit/SQL-Project/tree/main/QUESTION_3/readme.md) &emsp; [4th Problem](https://github.com/Plotted-Digit/SQL-Project/tree/main/QUESTION_4/readme.md) &emsp; [5th Problem](https://github.com/Plotted-Digit/SQL-Project/tree/main/QUESTION_5/readme.md) &emsp; [6th Problem](https://github.com/Plotted-Digit/SQL-Project/tree/main/QUESTION_6/readme.md) &emsp; [7th Problem](https://github.com/Plotted-Digit/SQL-Project/tree/main/QUESTION_7/readme.md)
