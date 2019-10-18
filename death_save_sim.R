# A Monte Carlo simulation to determine the probability of surviving death saving throws in Dungeons and Dragons 5e

# Function to simulate a death saving throw
# Reports both the result of either living or dieing, a 1 or 0 respectively, and the amount of rolls it took
death_save <- function() {
  rolling <- T
  live <- 0
  die <- 0
  roll_length <- 0
  while (rolling == T) {
    # Roll the die and save value as either live or die
    roll <- sample(1:20, 1)
    roll_length <- roll_length + 1
    if (roll == 20) {
      live <- live + 3
    } else if (roll == 1) {
      die <- die + 2
    } else if (1 < roll & roll < 10) {
      die <- die + 1
    } else {
      live <- live + 1
    }
    
    # Check how many successes or failures there are and either keep rolling or not
    if (live >= 3) {
      rolling <- F
      result <- 1
    } else if (die >= 3) {
      rolling <- F
      result <- 0
    }
  }
  return(list(result, roll_length))
}

options(digits = 2) # report to 2 sig figs

# Conduct Monte Carlo simulation
trials <- 10^5

ds_data <- replicate(trials, death_save())
ds_result <- unlist(ds_data[1,])
ds_roll_length <- unlist(ds_data[2,])

# Results
mean_outcome <- mean(ds_result)
mean_roll <- mean(ds_roll_length)

# Plot the results
library(ggplot2)
library(scales)
library(gridExtra)
df <- data.frame(rolls=ds_roll_length, results=ds_result, d_a=rep("", trials))

p <- ggplot(df, aes(d_a, fill=factor(results))) + 
  geom_bar() +
  geom_text(aes(label=scales::percent(..count../sum(..count..))), stat='count', position="stack", vjust=1.2) +
  theme(legend.position = "none") + labs(title = "Overall Survival", x="Outcome", y="Simulations")

p2 <- ggplot(df, aes(rolls, fill=factor(results))) + geom_bar()  + 
  labs(title = paste("Survival by Roll Length (",format(trials, scientific = T), " simulations)", sep=""), 
       x="Roll Length", y="") +
  theme(legend.title = element_blank()) + 
  scale_fill_discrete(labels=c("Dead", "Alive")) +
  geom_text(aes(label=scales::percent(..count../sum(..count..))), stat='count', position="stack", vjust=1.2) +
  geom_vline(aes(xintercept=mean_roll), color="blue", linetype="longdash", size=1) +
  geom_text(mapping=aes(label=paste("Mean = ", format(mean_roll, digits=2)), x=mean_roll), y=0, size=4, angle=90, vjust=1.2, hjust=-0.12)

grid.arrange(p, p2, widths=c(1,3))
