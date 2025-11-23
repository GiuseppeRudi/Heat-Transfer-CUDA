getwd()
mat <- as.matrix(read.table("temperature_step_10000.dat"))

dim(mat)

mat <- as.matrix(temperature_step_10000)

library(ggplot2)
library(reshape2)

df <- melt(mat)
ggplot(df, aes(Var2, Var1, fill = value)) +
  geom_tile() +
  scale_fill_gradientn(colors = heat.colors(200)) +
  coord_fixed()
