#' @title Creates kable-style table for Exploratory Analysis Dashboard
#'
#' @description This function builds a kable-style table for displaying tabular
#'  distributions of values for multiple variables at once. All variables
#'  in any given table should include the same possible values (e.g., identical
#'  likert scale values, or Yes / No responses).
#'
#' @param x A data frame conaining only the categorical variables you want
#'  included in the dashboard table.
#' @param nrows The number of rows the dashboard table will have.
#' @param ncols The total number of columns the dashboard table will have.
#' @param colnames Informative column names for the dashboard table. Typically
#'  equal the the categories of the variables included in the table. By default
#'  colnames will grab the values from the first variable in x.
#'
#' @return A kable object
#' @export
#'
#' @examples
#' data("mtcars")
#' mtcars$vs <- factor(mtcars$vs, levels = c(0:1), labels = c("No", "Yes"))
#' mtcars$am <- factor(mtcars$am, levels = c(0:1), labels = c("No", "Yes"))
#'
#' ea_kable(
#'  x = mtcars[8:9],
#'  xlab = c("VS", "AM"),
#'  nrows = 2,
#'  ncols = 2,
#'  colnames = c("Yes", "No")
#' )
ea_kable <- function(x, xlab, nrows, ncols, colnames) {

  # Create first var in df - holds var names
  df <- data.frame(
    y = xlab,
    stringsAsFactors = FALSE
  )
  # print(df)

  # Build a matrix to put the tabular results into
  m <- matrix(NA, nrow = nrows, ncol = (ncols - 1), byrow = TRUE)
  # print(m)

  # Grab values and fill in matrix
  i <- 1
  for (var in x) {
    resp_table <- table(var)
    resp <- as.vector(resp_table)
    perc <- round(table(var) / sum(table(var)) * 100)
    perc <- as.vector(perc)
    out <- paste0(resp, " (", perc, "%", ")")
    m[i, ] <- out
    i <- i + 1
  }

  # Convert to data frame and return kable
  df2 <- as.data.frame(m)
  df3 <- cbind(df, df2)
  names(df3) <- colnames
  kable(df3)
}
