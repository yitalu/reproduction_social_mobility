# Functions used in "./code/leslie_matrix_model.R"

transform_population <- function(leslie_matrix, population_current) {
  population_next <- leslie_matrix %*% population_current
  return(population_next)
}

normalize_distribution <- function(distribution) {
  normalized_distribution <- distribution / sum(distribution)
  return(normalized_distribution)
}