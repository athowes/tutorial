install.packages("DBI")

# DBI helps connect R to database management systems (DBMS)
# Separates connectivity into front-end and back-end
# DBI back-ends include: RPostgres, RMariaDB, RSQLite, obdc, bigrquery

library(DBI)

con <- dbConnect(RSQLite::SQLite(), dbname = ":memory:")
class(con)
dbListTables(con)
dbWriteTable(con, "mtcars", mtcars)
dbListTables(con)

dbListFields(con, "mtcars")

res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)

res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
while (!dbHasCompleted(res)) {
  chunk <- dbFetch(res, n = 5)
  print(nrow(chunk))
}

dbClearResult(res)

dbDisconnect(con)
