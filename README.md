# Rolling-Market-Operations-Plan, Market Forecasting Dashboard – Project Summary
## 🎯 The Problem
The traveling market was struggling to adapt its inventory to different cities. A "one-size-fits-all" approach to product staging wasn’t driving revenue growth. There was no system to:

Prioritize different city buying patterns

Plan how much of each item needs to be sold

Align inventory with revenue goals per event

## ✅ The Solution
We built a location-based forecasting dashboard that allows the team to:

Customize staging based on local buying behavior

Generate a produce plan for each market stop

Predict how many units of each product to bring based on historical sales data and a target revenue goal

## 🧾 The Data
We built the project using three main tables:

Orders – Tracks each item purchased, when, and by whom

Customers – Includes customer city (used to infer realistic nearby buyers)

Products – Includes fluctuating purchase and sales prices over time

Each product's price changes with each batch purchased and resold. So we timestamped all price changes and aligned each order to the correct price at the time it was placed.

## ⚠️ Constraint: Missing Price Data
Some historical product prices were missing at the time of purchase. To resolve this:

We used SQL to match each order to the most recent known price before the order date

If no price existed before the order, we matched it to the earliest price after the order date

This ensured every order had an accurate product sale and purchase price.

## 🧠 SQL Logic Used
We used a combination of ROW_NUMBER() and COALESCE() to grab the most relevant price:
you can find that query in the other file

## 📊 Visualizations: Location-Specific Produce Planning
We created a dashboard that helps plan revenue and inventory by location:

Revenue Goal Forecast

The user enters a revenue target for a specific city

The system allocates that goal proportionally based on historical revenue share by product

Products are rounded to whole units, and low-sellers (e.g. 0.1 units) are excluded

Example Scenario:

In Pasadena, you usually sell 10 apples ($2 each) and 2 grape bundles ($5 each)

That means ~66% of revenue comes from apples, 33% from grapes

If your revenue goal is $20, the system suggests:
~7 apples and 1 grape bundle

Since you can’t sell 0.33 of a grape bundle, it rounds up to the highest-contributing product

Location-Specific Plans

Each city has different customer behavior

The system adjusts plans dynamically to reflect what actually sells in that market

## 📈 Dashboard Features
The dashboard includes:

📍 Market City Selector

💵 Target Revenue Input

📦 Produce Plan Table – Based on historical product performance and revenue share

📈 Average Sales Per City – Daily revenue performance over time

📆 Most Recent Visit Sales – Total revenue from the last visit

🏆 Top Product by Revenue per city

📍 Regional Map of locations with ZIP codes

🧮 Profit Calculation – Tracks both purchase and resale margins

