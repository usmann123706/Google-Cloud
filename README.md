# E-commerce Data Analysis and Prediction using BigQuery ML

This project leverages Google BigQuery to analyze e-commerce data and build a machine learning model to predict visitor behavior. The steps include exploring the dataset, creating a logistic regression 
model using BigQuery ML, and evaluating and predicting visitor behavior based on the model.

## Project Overview

1. **Explore E-commerce Data:**
   - Analyze the percentage of visitors who made a purchase.
   - Identify the top 5 selling products.
   - Determine the number of visitors who bought on subsequent visits to the website.

2. **Create Training and Evaluation Datasets:**
   - Select relevant features and create datasets for training and evaluation.
   - Use historical data to train the model and evaluate its performance.

3. **Build a Classification Model:**
   - Create a logistic regression model using BigQuery ML.
   - Evaluate the model's performance using metrics like ROC AUC.
   - Predict and rank the probability that a visitor will make a purchase on their next visit.

## Files

- `ecommerce_analysis.sql`: Contains all SQL queries used in the project, including data exploration, model training, evaluation, and prediction.

## Usage

1. Run the SQL queries in `ecommerce_analysis.sql` within BigQuery to perform the data analysis and model training.
2. Evaluate the model performance and use the prediction queries to rank the probability of visitors making a purchase.

## Requirements

- Google Cloud Project with BigQuery enabled.
- Access to the public dataset `data-to-insights.ecommerce.web_analytics`.

## Results

- The analysis provides insights into visitor behavior on the e-commerce website.
- The logistic regression model predicts the likelihood of a visitor making a purchase on a subsequent visit.

