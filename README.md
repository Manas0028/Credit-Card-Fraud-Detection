# 💳 Credit Card Fraud Detection & Data Analysis

## 📌 Project Overview

This project presents an end-to-end **Credit Card Fraud Detection and Data Analysis** workflow using **Python, MySQL, Power BI, and Excel**.

The objective is to analyze credit card transaction data, identify fraudulent transaction patterns, perform data cleaning and exploratory data analysis, develop SQL-based business insights, and create interactive dashboards for fraud monitoring.

The project demonstrates practical skills in:

- Data Cleaning & Preprocessing
- Exploratory Data Analysis (EDA)
- Statistical Analysis
- SQL Data Analysis
- KPI Development
- Data Visualization
- Business Intelligence
- Dashboard Development
- Fraud Pattern Analysis

---

## 🎯 Business Problem

Credit card fraud is a major challenge for financial institutions because fraudulent transactions represent a very small proportion of total transactions, making them difficult to identify using simple transaction-volume analysis.

This project analyzes transaction-level data to answer questions such as:

- How many transactions are fraudulent?
- What percentage of transactions are fraudulent?
- What is the average fraud transaction amount?
- Which transaction amount ranges have higher fraud rates?
- During which elapsed-time hour buckets are more fraud transactions observed?
- What is the total monetary value associated with fraudulent transactions?
- Which fraudulent transactions have the highest amounts?

---

## 🎯 Project Objectives

1. Clean and validate the transaction dataset.
2. Perform exploratory data analysis using Python.
3. Analyze fraud vs legitimate transactions.
4. Identify patterns based on transaction amounts.
5. Analyze fraud patterns across hourly buckets.
6. Perform SQL-based KPI and business analysis.
7. Create an interactive Power BI dashboard.
8. Build an Excel-based analysis dashboard.
9. Generate actionable business insights from transaction data.

---

## 📊 Dataset

The dataset contains **284,807 credit card transactions** with **31 original variables**.

### Main Columns

| Column | Description |
|---|---|
| `Time` | Seconds elapsed between transactions |
| `V1 - V28` | Anonymized numerical features |
| `Amount` | Transaction amount |
| `Class` | Transaction classification |

### Class Definition

| Class | Meaning |
|---|---|
| `0` | Legitimate Transaction |
| `1` | Fraudulent Transaction |

Additional analytical columns were created during the project:

- `Hour`
- `Amount_Range`

> **Note:** `V1`–`V28` are anonymized features, so their individual business meanings are not assumed.

---

## 🛠️ Tools & Technologies

### Programming & Analysis

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook

### Database

- MySQL
- SQL
- CTEs
- Window Functions
- Aggregate Functions
- CASE Statements
- GROUP BY
- HAVING

### Business Intelligence

- Microsoft Power BI
- DAX
- Power Query
- Interactive Dashboards
- KPI Cards
- Slicers

### Spreadsheet Analysis

- Microsoft Excel
- Excel Tables
- Formulas
- KPI Analysis
- Charts
- Dashboard Design

### Version Control

- Git
- GitHub

---

## 🔄 Project Workflow

```text
Raw Dataset
     ↓
Data Cleaning & Validation
     ↓
Exploratory Data Analysis
     ↓
Feature Creation
     ↓
Python Analysis
     ↓
MySQL Data Analysis
     ↓
Power BI Dashboard
     ↓
Excel Analysis Dashboard
     ↓
Business Insights