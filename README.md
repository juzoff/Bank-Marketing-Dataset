# Bank Marketing Dataset Project

**Note: This project is organized into multiple branches on GitHub, each correlating with a different portion of the assignment. To explore specific sections, please select the branch that corresponds to the task or analysis you are interested in. This structure allows for a focused review of each component of the project, making it easier to follow along with the data preparation, modeling, and evaluation processes.**

**Timeframe of Project: May 2024 - August 2024**

**Tools Used:** Python and SAS were primarily used for data preparation, modeling, and analysis.

**Project Description:**

*   **Data Collection:** I started by obtaining the Bank Marketing dataset, which includes various customer attributes and whether they subscribed to a term deposit.

**Data Preparation:**

*   **Data Cleaning:** I cleaned the data to handle missing values, outliers, and inconsistencies. I also encoded categorical variables and normalized numerical features to ensure the data was ready for analysis.
*   **Exploratory Data Analysis (EDA):** I conducted EDA to understand the data distribution, relationships between variables, and key patterns. This included visualizing the data by plotting various charts in an Excel spreadsheet for better insights. Additionally, I plotted the correlation among attributes to evaluate weak, moderate, and strong correlational relationships.
*   **Class Distribution Analysis:** I assessed whether the dataset had an imbalanced class distribution by examining the proportion of records for different classes. It was determined that the dataset required balancing, which was addressed as part of the data preparation process.

**Predictive Modeling/Classification:**

*   **Feature Selection:** To improve model efficiency, I selected relevant features based on their correlation with the target variable (`y`). This involved using statistical tests, feature importance metrics, and logical reasoning to determine which attributes were most likely to influence the target outcome. I carefully developed a selection strategy that balanced statistical evidence with domain knowledge.
*   **Model Building:** I built predictive models using Decision Tree and Naive Bayes algorithms in Python and SAS. The Decision Tree model was chosen for its interpretability, while Naive Bayes was selected for its simplicity and efficiency in handling categorical data.
*   **Training and Test Sets:** I created training and test sets for both models using all attributes and the selected attributes. This allowed for a direct comparison of the models' performance on both the original and filtered datasets.
*   **Model Evaluation:** I evaluated the models on training and test sets using performance metrics like accuracy, precision, recall, and F1-score. I compared the results between the models trained on all attributes versus those trained on selected attributes to determine which approach led to better predictive performance. Visualizations were created to represent the differences in confusion matrix outputs and performance metrics between the models using all attributes and those using selected attributes. These visuals are located in the appendix for reference.
*   **Hyperparameter Tuning:** To optimize the models, I adjusted hyperparameters, such as tree depth for the Decision Tree and smoothing parameters for Naive Bayes, to achieve the best possible performance.
*   **Model Interpretation:** I analyzed the final models to interpret the importance of different features. For example, understanding which customer attributes (e.g., age, job, previous outcomes) had the most significant impact on subscription decisions.

**Conclusions and Recommendations:**

*   **Results and Recommendations:** I summarized the findings, highlighting the key factors influencing customer decisions. Based on these insights, I provided recommendations to improve the bank's telemarketing strategies, such as targeting specific customer segments more effectively.

**Documentation and Reporting:**

*   **Documentation and Reporting:** I documented the entire process, including code, methodology, and results, to ensure the project could be easily understood and replicated by others.

