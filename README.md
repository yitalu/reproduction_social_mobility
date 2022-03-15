# Reproduction and Social Mobility
This project aims to replicate the social mobility theory by Alan Rogers [^1] [^2]. See [here](./draft/abstract.md) for an abstract.

There are three sets of code that constitute this replication:

### 1. Leslie Matrix Model
First, I reproduce the Leslie matrix model in R. See file [leslie_matrix_model.R](./code/leslie_matrix_model.R) and its supporting functions in [leslie_matrix_functions.R](./code/leslie_matrix_functions.R). The matrix model is the backbone of the social mobility model. It basically shows that the **growth rates** for a population and its age/wealth classes, the age/wealth **class distribution** in the population, and the proportions of **long-term fitness** can be captured by the dominant eigenvalue, the corresponding eigenvector, and the corresponding left eigenvector, respectively. See visualizations in the [figures](./figures) folder.

For the certain leslie matrices I have tried, we see that for individuals in the third class, they reproduce less offspring, but in the long-run, they have a higher fitness (genetic representation) in the population.


### 2. Social Mobility Model
The second part attempts to replicate the core of the social mobility model, in which parents maximize long-term growth rates by choosing a best reproductive strategy --- an optimized fertility allocation as a proportion of their wealth. See [social_mobility_model.py](./code/social_mobility_model.py) as the start. It makes use of the optimization algorithm [social_mobility_optimization.py](./code/social_mobility_optimization.py) and its supporting functions in [social_mobility_functions.py](./code/social_mobility_functions.py). Input desired parameters in the PARAMETERS part of [social_mobility_model.py](./code/social_mobility_model.py) and get your data in the [data](./data) folder.


### 3. Data Analysis
The data produced by the model is analyzed in the third part: [analyze_data.R](./code/analyze_data.R), which makes use of [read_data.R](./code/read_data.R). The preliminary analysis shows no clear pattern as said in the [abstract](./draft/abstract.md). Further analysis will be added.



[^1]: Rogers, A. R. (1990). Evolutionary economics of human reproduction. *Ethology and Sociobiology, 11*(6), 479-495.

[^2]: Harpending, H., & Rogers, A. (1990). Fitness in stratified societies. *Ethology and sociobiology, 11*(6), 497-509.