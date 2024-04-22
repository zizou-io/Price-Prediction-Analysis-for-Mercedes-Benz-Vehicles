**Price-Prediction-for-Mercedes-Benz-Vehicles**
**Overview**

The Mercedes-Benz Price Prediction project aims to equip junior salespeople with an advanced pricing tool, enhancing their decision-making capabilities regarding used car pricing. The project utilizes the R programming language and popular libraries like tidyverse, caret, and randomForest to develop a predictive model for estimating the prices of used Mercedes-Benz cars.

**Business Objectives**

- **Empower Sales Team:** Provide junior salespeople with a powerful pricing tool to make informed decisions on used car pricing.
- **Enhance Decision-Making:** Improve decision-making capabilities by leveraging advanced predictive modeling techniques.

**Key Features**

- **Data Exploration:** Conduct a comprehensive exploration of the dataset, including head, structure, and summary analysis, to gain insights into the available information.
- **Visualization:** Utilize ggplot2 and other visualization tools to create informative plots, such as Average Price by Model, Distribution of Prices, Distribution of Engine Size, and Correlation between Price and Mileage.
- **Data Preparation:** Convert categorical variables to factors, identify and handle outliers, and refine the dataset for modeling.
- **Modeling:** Employ Linear Regression as a baseline model and Random Forest for predictive modeling. Train and evaluate the models using metrics like RMSE (Root Mean Squared Error) and MAE (Mean Absolute Error).
- **Model Evaluation:** Use visualizations, including a plot of predictions against actual prices and feature importance analysis, to comprehensively evaluate the models.
- **Recommendations:** Provide insights into model performance and recommendations for future improvements, such as collecting more data, trying different algorithms, and hyperparameter tuning.

**Results**

The models demonstrate promising results, with an average % error for most models under 5% and an average absolute error of less than $700. The Random Forest model outperforms the Linear Regression model in terms of both RMSE and MAE.

**Recommendations**

- **Collect More Data:** Expanding the dataset can further enhance model accuracy.
- **Explore Different Algorithms:** Trying different machine learning algorithms could uncover alternative models with improved performance.
- **Hyperparameter Tuning:** Fine-tuning model parameters to optimize predictive capabilities.
- **Exercise Caution with Rare Models:** Advise salespeople to be cautious when relying on predictions for car models with fewer than 50 instances. The model may have limited data to make accurate predictions for these rare models. Salespeople may manually adjust the predicted prices based on their understanding of market demand or consult with senior salespeople.
