# Loan Risk Prediction with Vertex AI

This repository contains code and instructions for utilizing Google Cloud's Vertex AI to develop a machine learning model for predicting loan risk using a tabular dataset.

## Overview

This project demonstrates the process of:

- Uploading a dataset to Vertex AI.
- Training a machine learning model using AutoML on Vertex AI.
- Evaluating the model's performance.
- Deploying the trained model to an endpoint.
- Obtaining predictions from the deployed model.


## Prerequisites

Before getting started, ensure you have the following:

- Access to Google Cloud Platform (GCP) account.
- Enabled Vertex AI API and necessary permissions.
- Basic understanding of Python and machine learning concepts.

## Usage

### Step 1: Setting Up Google Cloud Environment

1. **Create a GCP Project**: If you haven't already, create a project on Google Cloud Platform.

2. **Enable Vertex AI API**: Enable the Vertex AI API in your project.

3. **Install Google Cloud SDK**: Install and set up the Google Cloud SDK on your local machine.

### Step 2: Uploading Dataset to Vertex AI

1. **Prepare Dataset**: Format your loan risk dataset (in CSV, for example) and organize it appropriately.

2. **Upload Dataset**: Use Google Cloud Console or SDK to upload the dataset to Vertex AI.

### Step 3: Training the Model with AutoML

1. **Define Model Configuration**: Configure the parameters and settings for your AutoML model.

2. **Initiate Training**: Start the training process using the uploaded dataset.

### Step 4: Evaluating Model Performance

1. **Assess Model Metrics**: Retrieve and analyze model performance metrics such as accuracy, precision, recall, etc.

### Step 5: Deploying the Model

1. **Deploy Model**: Deploy the trained model as an endpoint for making predictions.

### Step 6: Getting Predictions

1. **Query the Model**: Use provided sample code or SDK to send queries and receive predictions from the deployed model.


