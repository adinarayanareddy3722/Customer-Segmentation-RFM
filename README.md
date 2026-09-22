# Customer Segmentation and Revenue Optimization

RFM analysis and behavioral clustering on a UK online retail dataset. The project identifies high-value and at-risk customers and turns that into retention and growth recommendations.

## Business objective

A one-size-fits-all marketing strategy wastes budget. This project segments the customer base using transaction data to find High-Value customers and At-Risk users, then gives recommendations to grow Customer Lifetime Value.

## Dataset

Source: Kaggle E-commerce Dataset
Size: 541,909 rows, 8 columns
Timeframe: 01/12/2010 to 09/12/2011

Fields: InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

## Files

E-Commerce.ipynb: data cleaning in Python (pandas)
E-Commerce.sql: RFM calculation and customer segmentation in SQL
E-Commerce.pbix: interactive Power BI dashboard
E-Commerce.pptx: stakeholder-facing summary of the analysis and recommendations

## Pipeline

1. Raw data goes through E-Commerce.ipynb. This fills missing descriptions, drops rows with no CustomerID, removes invalid stock codes and duplicates, converts dates, builds a TotalSales column, removes cancelled orders and invalid quantities or prices, and trims whitespace. Output: a cleaned dataset.
2. The cleaned data loads into a SQL table. E-Commerce.sql calculates Recency, Frequency, and Monetary per customer, scores each with NTILE(5) quintiles, and segments customers into High Value, Medium Value, Low Value, and Dormant based on total spend.
3. E-Commerce.pbix visualizes the segments for interactive exploration.
4. E-Commerce.pptx presents the full analysis, findings, and segment-level strategy to a business audience.

## Key findings

26.12% of customers generate 80% of revenue.
23.25% of products generate 80% of sales volume.

## Segments and strategy

High Value: recent, frequent, big spenders. Strategy: VIP tiered loyalty program, early access, member-only discounts.
Medium Value: steady shoppers with average basket size. Strategy: basket analysis and personalized upsell emails.
Low Value: occasional or one-time buyers. Strategy: automated low-cost engagement through push notifications and newsletters.
Dormant: previously active, haven't purchased recently. Strategy: an aggressive win-back campaign with a time-sensitive discount.

## Tools used

Python (pandas), SQL, Power BI

## Author

Adi Narayana Reddy Nallamilli
