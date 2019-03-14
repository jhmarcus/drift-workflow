library(ggplot2)
library(cowplot)

# Load the factor analysis (FLASH) results.
out <- readRDS("loadings-forpeter-03-12-2019.rds")
dat <- out$df
pve <- out$pve
rownames(dat) <- dat$ID
names(dat)[1:21] <- paste0("factor",1:21)
dat <- dat[c(23:31,1:21)]
rm(out)

# Load the plink --het output. (Not actually used here.)
het <- read.table("HumanOriginsPublic2068_auto_maf05_geno005_mind02.het",
                  sep = " ",header = TRUE,stringsAsFactors = FALSE,
                  check.names = FALSE)
rows <- match(rownames(dat),het$IID)
dat  <- cbind(dat,het[rows,3:6])

for (i in 2:21) {

  # Sort the populations by mean loading, and split evenly into two
  # data frames.
  f    <- paste0("factor",i)
  x    <- tapply(dat[[f]],dat$Simple.Population.ID,median)
  x    <- sort(x,decreasing = TRUE)
  y    <- names(x)
  pdat1 <- subset(dat,is.element(Simple.Population.ID,y[1:83]))
  pdat2 <- subset(dat,is.element(Simple.Population.ID,y[84:167]))
  pdat1 <- transform(pdat1,
             Simple.Population.ID = factor(Simple.Population.ID,y[1:83]))
  pdat2 <- transform(pdat2,
             Simple.Population.ID = factor(Simple.Population.ID,y[84:167]))

  # Generate the plots.
  p <- list(ggplot(pdat1,aes_string(x = "Simple.Population.ID",y = f)),
            ggplot(pdat2,aes_string(x = "Simple.Population.ID",y = f)))
  for (j in 1:2)
    p[[j]] <- p[[j]] +
      stat_summary(fun.y = median,fun.ymin = function (x) quantile(x,0.1),
                   fun.ymax = function (x) quantile(x,0.9),
                   color = "darkblue",geom = "pointrange",size = 0.25) +
        labs(x = "",y = paste("factor",i)) +
        theme_cowplot(font_size = 11) +
        theme(axis.ticks = element_blank(),
              axis.line  = element_blank(),
              axis.text.x = element_text(angle = 45,size = 5,hjust = 1))
  ggsave(sprintf("plots/factor%02d.pdf",i),plot_grid(p[[1]],p[[2]],nrow = 2))
}
