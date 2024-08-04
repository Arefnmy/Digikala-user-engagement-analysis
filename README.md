# Data-driven analysis of user engagement on Digikala

_This project was completed during the course "Introduction to Statistical Learning" at Sharif University of Technology (Spring 2024)._

## Objective

The objective of this project is to analyze the behavior of buyers of various products on the [Digikala](https://digikala.com) platform using publicly available data provided by [Rade AI](https://www.kaggle.com/datasets/radeai/digikala-comments-and-products). Our aim is to define a user engagement metric for each product to indicate user interaction with that product. This parameter can be useful for sellers to identify which products to focus on.

Since there is no clear solution or method for this problem, we relied on our ideas about parameters, trial and error, and some clustering techniques to arrive at a suitable metric. The most significant parameter missing from our data is the sales volume of each product. Therefore, we focused on other types of parameters, including user ratings and comments. Our idea was to define both positive and negative user engagement for each product to distinguish the impact of positive engagement from negative ones.

## Approach

To differentiate between positive and negative engagement, we examined the ratings and comments of each user, assigning positive and negative points to the product score based on the sentiment of each comment. We performed a sentiment analysis using the [HooshvareLab ParsBERT](https://github.com/hooshvare/parsbert) model to determine the positivity or negativity of each comment.

The dataset contains one user comment per row, including the following parameters: rating, comment body, comment title, lists of advantages and disadvantages, likes and dislikes, product ID, and seller ID. Using these parameters, we introduced several methods to calculate user engagement for a specific product-seller pair:
- **Simple Scoring**: This method sums the scores of each parameter and returns the total result.
- **Weighted Scoring**: This method sums the scores of each parameter, applying predefined weights to each, and returns the weighted total.
- **Biased Scoring**: In this method, the sentiment of a comment is first determined using the rating and sentiment analysis. Then, the total score of the parameters is distributed between positive and negative user engagement, proportionally to the number of likes and dislikes.

Using clustering methods, we then evaluated the effectiveness of each scoring method. We analyzed the distribution of scores to identify products, categories, and subcategories with the highest scores, assessing how well the results aligned with our expectations.

## Project Structure

The `codes` directory contains Jupyter notebooks, including:
- `scoring.ipynb` for exploratory data analysis and defining scoring methods
- `clustering_analysis.ipynb` for clustering analysis
- `score_analysis.ipynb` for examining and comparing various methods

The report of this project can be found in the file named `Digikala_User_Engagement_Analysis_Report.pdf`.
