###################################################################################
# Clear working directory/RAM
rm(list=ls())

###################################################################################
# Load packages
if (!require("pacman")) {
  install.packages("pacman")
}
pacman::p_load(tidyverse, data.table, cowplot)


###################################################################################
# Import data
marijuana_use <- read.csv("temp/data-for-cleveland-plot.csv")

###################################################################################
# custom color pallete
cbPalette <- c("#3F3DCB", 
               "#d6d4d3", 
               "#0CC693")

###################################################################################
# Plot difference in marijuana use by age-group and recreational status

past_year <- ggplot(marijuana_use, aes(mj_use_365_1, other_order)) +
  geom_segment(aes(x = mj_use_365_0, xend = mj_use_365_1, y = other_order, yend = other_order)) +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(mj_use_365_0, other_order), size=5, color="black", fill = "black", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(mj_use_365_0, other_order), size=4, color="white", fill = "white", shape = 23) +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), aes(mj_use_365_0, other_order), size=5, color="black", fill = "black", shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), aes(mj_use_365_0, other_order), size=4, color="white", fill = "white", shape = 16) +
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=5, color="black",  fill = "black",  shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=4, color=cbPalette[2], fill = cbPalette[2], shape = 16) + 
  theme_classic() + 
  labs(title = "", 
       x = "Percent reporting marijuana use in past year", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
  annotate("text", label = "Mean for recreational\n marijuana states", x = 29, y = 50, size = 4, colour = "black", hjust = 0) +
  geom_point(aes(x = 30, y = 45), size=5, color="black",  fill = "black",  shape = 23) +
  geom_point(aes(x = 30, y = 45), size=4, color="white",  fill = "white",  shape = 23) +
  annotate("text", label = " 2005", x = 32, y = 45, size = 4, colour = "black") +
  geom_point(aes(x = 35, y = 45), size=5, color="black",  fill = "black",  shape = 23) +
  geom_point(aes(x = 35, y = 45), size=4, color=cbPalette[3],  fill = cbPalette[3],  shape = 23) +
  annotate("text", label = " 2017", x = 37, y = 45, size = 4, colour = "black") +
  annotate("text", label = "Mean for other states", x = 29, y = 40, size = 4, colour = "black", hjust = 0) +
  geom_point(aes(x = 30, y = 37.5), size=5, color="black",  fill = "black",  shape = 16) +
  geom_point(aes(x = 30, y = 37.5), size=4, color="white",  fill = "white",  shape = 16) +
  annotate("text", label = " 2005", x = 32, y = 37.5, size = 4, colour = "black") +
  geom_point(aes(x = 35, y = 37.5), size=5, color="black",  fill = "black",  shape = 16) +
  geom_point(aes(x = 35, y = 37.5), size=4, color=cbPalette[2],  fill = cbPalette[2],  shape = 16) +
  annotate("text", label = " 2017", x = 37, y = 37.5, size = 4, colour = "black")  +
  scale_x_continuous(limits = c(0, 42),
                     breaks = c(0, 5, 10, 15, 20, 25, 30, 35, 40), 
                     labels = c("0", "5", "10", "15", "20", "25", "30", "35", "40"))



past_month <- ggplot(marijuana_use, aes(mj_use_30_1, other_order)) +
  geom_segment(aes(x = mj_use_30_0, xend = mj_use_30_1, y = other_order, yend = other_order)) +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(mj_use_30_0, other_order), size=5, color="black", fill = "black", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(mj_use_30_0, other_order), size=4, color="white", fill = "white", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), aes(mj_use_30_0, other_order), size=5, color="black", fill = "black", shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), aes(mj_use_30_0, other_order), size=4, color="white", fill = "white", shape = 16) +
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=5, color="black",  fill = "black",  shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=4, color=cbPalette[2], fill = cbPalette[2], shape = 16) + 
  theme_classic() + 
  labs(title = "", 
       x = "Percent reporting marijuana use in past month", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) +
  scale_x_continuous(limits = c(0, 42),
                     breaks = c(0, 5, 10, 15, 20, 25, 30, 35, 40), 
                     labels = c("0", "5", "10", "15", "20", "25", "30", "35", "40"))



combined_plot_raw_data <- plot_grid(past_month, past_year,
                           ncol = 2)

ggsave(combined_plot_raw_data, file = "output/plots/change-in-use-raw-data.pdf", width = 15, height = 4)

###################################################################################
# Plot percent difference in marijuana use by age-group and recreational status

percent_past_month <- ggplot(marijuana_use, aes(per_diff_30, other_order)) +
  geom_segment(aes(x = per_diff_30, xend = 0, y = other_order, yend = other_order)) +
  geom_vline(xintercept = 0, linetype="dashed", width = .75, color = "black") +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=5, color="black",  fill = "black",  shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=4, color=cbPalette[2], fill = cbPalette[2], shape = 16) + 
  theme_classic()  +
  labs(title = "Marijuana use in past-month", 
       x = "Percent change in use from 2005/2006 to 2016/2017", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
annotate("text", label = "recreational marijuana states", x = 77, y = 18, size = 4, colour = "black", hjust = 0) +
  geom_point(aes(x = 72.5, y = 18), size=5, color="black",  fill = "black",  shape = 23) +
  geom_point(aes(x = 72.5, y = 18), size=4, color=cbPalette[3],  fill = cbPalette[3],  shape = 23) +
  annotate("text", label = "other states", x = 77, y = 14, size = 4, colour = "black", hjust = 0) +
  geom_point(aes(x = 72.5, y = 14), size=5, color="black",  fill = "black",  shape = 16) +
  geom_point(aes(x = 72.5, y = 14), size=4, color=cbPalette[2],  fill = cbPalette[2],  shape = 16)  +
  scale_x_continuous(limits = c(-15, 122),
                     breaks = c(-15, 0, 15, 30, 45, 60, 75, 90, 105, 120), 
                     labels = c("-15", "0", "15", "30", "45", "60", "75", "90", "105", "120"))


percent_past_year <- ggplot(marijuana_use, aes(per_diff_365, other_order)) +
  geom_segment(aes(x = per_diff_365, xend = 0, y = other_order, yend = other_order)) +
  geom_vline(xintercept = 0, linetype="dashed", width = .75, color = "black") +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=5, color="black",  fill = "black",  shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=4, color=cbPalette[2], fill = cbPalette[2], shape = 16) + 
  theme_classic()  +
  labs(title = "Marijuana use in past-year", 
       x = "Percent change in use from 2005/2006 to 2016/2017", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
  scale_x_continuous(limits = c(-15, 122),
                     breaks = c(-15, 0, 15, 30, 45, 60, 75, 90, 105, 120), 
                     labels = c("-15", "0", "15", "30", "45", "60", "75", "90", "105", "120"))

###################################################################################
# Plot difference in marijuana use by age-group and recreational status

diff_month <- ggplot(marijuana_use, aes(diff_30, other_order)) +
  geom_segment(aes(x = diff_30, xend = 0, y = other_order, yend = other_order)) +
  geom_vline(xintercept = 0, linetype="dashed", width = .75, color = "black") +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(diff_30, other_order), size=5, color="black", fill = "black", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(diff_30, other_order), size=4, color="white", fill = "white", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) +
  theme_classic() + 
  labs(title = "Marijuana use in past-month", 
       x = "Difference in percent change in use between recreational states and other states", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
  scale_x_continuous(limits = c(-15, 122),
                     breaks = c(-15, 0, 15, 30, 45, 60, 75, 90, 105, 120), 
                     labels = c("-15", "0", "15", "30", "45", "60", "75", "90", "105", "120"))


diff_year <- ggplot(marijuana_use, aes(diff_365, other_order)) +
  geom_vline(xintercept = 0, linetype="dashed", width = .75, color = "black") +
  geom_segment(aes(x = diff_365, xend = 0, y = other_order, yend = other_order)) +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(diff_365, other_order), size=5, color="black", fill = "black", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(diff_365, other_order), size=4, color="white", fill = "white", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) +
  theme_classic() + 
  labs(title = "Marijuana use in past-year", 
       x = "Difference in percent change in use between recreational states and other states", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
  scale_x_continuous(limits = c(-15, 122),
                     breaks = c(-15, 0, 15, 30, 45, 60, 75, 90, 105, 120), 
                     labels = c("-15", "0", "15", "30", "45", "60", "75", "90", "105", "120"))




combined_plot <- plot_grid(percent_past_month, percent_past_year, 
  diff_month, diff_year, 
  ncol = 2)

ggsave(combined_plot, file = "output/plots/change-in-use.pdf", width = 14, height = 7)

# Black and white 

###################################################################################
# custom color pallete
cbPalette <- c("#3F3DCB", 
               "#d6d4d3", 
               "#000000")

###################################################################################
# Plot difference in marijuana use by age-group and recreational status

past_year <- ggplot(marijuana_use, aes(mj_use_365_1, other_order)) +
  geom_segment(aes(x = mj_use_365_0, xend = mj_use_365_1, y = other_order, yend = other_order)) +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(mj_use_365_0, other_order), size=5, color="black", fill = "black", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(mj_use_365_0, other_order), size=4, color="white", fill = "white", shape = 23) +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), aes(mj_use_365_0, other_order), size=5, color="black", fill = "black", shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), aes(mj_use_365_0, other_order), size=4, color="white", fill = "white", shape = 16) +
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=5, color="black",  fill = "black",  shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=4, color=cbPalette[2], fill = cbPalette[2], shape = 16) + 
  theme_classic() + 
  labs(title = "", 
       x = "Percent reporting marijuana use in past year", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
  annotate("text", label = "Mean for recreational\n marijuana states", x = 29, y = 50, size = 4, colour = "black", hjust = 0) +
  geom_point(aes(x = 30, y = 45), size=5, color="black",  fill = "black",  shape = 23) +
  geom_point(aes(x = 30, y = 45), size=4, color="white",  fill = "white",  shape = 23) +
  annotate("text", label = " 2005", x = 32, y = 45, size = 4, colour = "black") +
  geom_point(aes(x = 35, y = 45), size=5, color="black",  fill = "black",  shape = 23) +
  geom_point(aes(x = 35, y = 45), size=4, color=cbPalette[3],  fill = cbPalette[3],  shape = 23) +
  annotate("text", label = " 2017", x = 37, y = 45, size = 4, colour = "black") +
  annotate("text", label = "Mean for other states", x = 29, y = 40, size = 4, colour = "black", hjust = 0) +
  geom_point(aes(x = 30, y = 37.5), size=5, color="black",  fill = "black",  shape = 16) +
  geom_point(aes(x = 30, y = 37.5), size=4, color="white",  fill = "white",  shape = 16) +
  annotate("text", label = " 2005", x = 32, y = 37.5, size = 4, colour = "black") +
  geom_point(aes(x = 35, y = 37.5), size=5, color="black",  fill = "black",  shape = 16) +
  geom_point(aes(x = 35, y = 37.5), size=4, color=cbPalette[2],  fill = cbPalette[2],  shape = 16) +
  annotate("text", label = " 2017", x = 37, y = 37.5, size = 4, colour = "black")  +
  scale_x_continuous(limits = c(0, 42),
                     breaks = c(0, 5, 10, 15, 20, 25, 30, 35, 40), 
                     labels = c("0", "5", "10", "15", "20", "25", "30", "35", "40"))



past_month <- ggplot(marijuana_use, aes(mj_use_30_1, other_order)) +
  geom_segment(aes(x = mj_use_30_0, xend = mj_use_30_1, y = other_order, yend = other_order)) +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(mj_use_30_0, other_order), size=5, color="black", fill = "black", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(mj_use_30_0, other_order), size=4, color="white", fill = "white", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), aes(mj_use_30_0, other_order), size=5, color="black", fill = "black", shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), aes(mj_use_30_0, other_order), size=4, color="white", fill = "white", shape = 16) +
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=5, color="black",  fill = "black",  shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=4, color=cbPalette[2], fill = cbPalette[2], shape = 16) + 
  theme_classic() + 
  labs(title = "", 
       x = "Percent reporting marijuana use in past month", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) +
  scale_x_continuous(limits = c(0, 42),
                     breaks = c(0, 5, 10, 15, 20, 25, 30, 35, 40), 
                     labels = c("0", "5", "10", "15", "20", "25", "30", "35", "40"))



combined_plot_raw_data <- plot_grid(past_month, past_year,
                                    ncol = 2)

ggsave(combined_plot_raw_data, file = "output/plots/bw-change-in-use-raw-data.pdf", width = 15, height = 4)

###################################################################################
# Plot percent difference in marijuana use by age-group and recreational status

percent_past_month <- ggplot(marijuana_use, aes(per_diff_30, other_order)) +
  geom_segment(aes(x = per_diff_30, xend = 0, y = other_order, yend = other_order)) +
  geom_vline(xintercept = 0, linetype="dashed", width = .75, color = "black") +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=5, color="black",  fill = "black",  shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=4, color=cbPalette[2], fill = cbPalette[2], shape = 16) + 
  theme_classic()  +
  labs(title = "Marijuana use in past-month", 
       x = "Percent change in use from 2005/2006 to 2016/2017", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
  annotate("text", label = "recreational marijuana states", x = 77, y = 18, size = 4, colour = "black", hjust = 0) +
  geom_point(aes(x = 72.5, y = 18), size=5, color="black",  fill = "black",  shape = 23) +
  geom_point(aes(x = 72.5, y = 18), size=4, color=cbPalette[3],  fill = cbPalette[3],  shape = 23) +
  annotate("text", label = "other states", x = 77, y = 14, size = 4, colour = "black", hjust = 0) +
  geom_point(aes(x = 72.5, y = 14), size=5, color="black",  fill = "black",  shape = 16) +
  geom_point(aes(x = 72.5, y = 14), size=4, color=cbPalette[2],  fill = cbPalette[2],  shape = 16)  +
  scale_x_continuous(limits = c(-15, 122),
                     breaks = c(-15, 0, 15, 30, 45, 60, 75, 90, 105, 120), 
                     labels = c("-15", "0", "15", "30", "45", "60", "75", "90", "105", "120"))


percent_past_year <- ggplot(marijuana_use, aes(per_diff_365, other_order)) +
  geom_segment(aes(x = per_diff_365, xend = 0, y = other_order, yend = other_order)) +
  geom_vline(xintercept = 0, linetype="dashed", width = .75, color = "black") +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=5, color="black",  fill = "black",  shape = 16) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 0), size=4, color=cbPalette[2], fill = cbPalette[2], shape = 16) + 
  theme_classic()  +
  labs(title = "Marijuana use in past-year", 
       x = "Percent change in use from 2005/2006 to 2016/2017", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
  scale_x_continuous(limits = c(-15, 122),
                     breaks = c(-15, 0, 15, 30, 45, 60, 75, 90, 105, 120), 
                     labels = c("-15", "0", "15", "30", "45", "60", "75", "90", "105", "120"))

###################################################################################
# Plot difference in marijuana use by age-group and recreational status

diff_month <- ggplot(marijuana_use, aes(diff_30, other_order)) +
  geom_segment(aes(x = diff_30, xend = 0, y = other_order, yend = other_order)) +
  geom_vline(xintercept = 0, linetype="dashed", width = .75, color = "black") +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(diff_30, other_order), size=5, color="black", fill = "black", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(diff_30, other_order), size=4, color="white", fill = "white", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) +
  theme_classic() + 
  labs(title = "Marijuana use in past-month", 
       x = "Difference in percent change in use between recreational states and other states", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
  scale_x_continuous(limits = c(-15, 122),
                     breaks = c(-15, 0, 15, 30, 45, 60, 75, 90, 105, 120), 
                     labels = c("-15", "0", "15", "30", "45", "60", "75", "90", "105", "120"))


diff_year <- ggplot(marijuana_use, aes(diff_365, other_order)) +
  geom_vline(xintercept = 0, linetype="dashed", width = .75, color = "black") +
  geom_segment(aes(x = diff_365, xend = 0, y = other_order, yend = other_order)) +
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(diff_365, other_order), size=5, color="black", fill = "black", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), aes(diff_365, other_order), size=4, color="white", fill = "white", shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=5, color="black",  fill = "black",  shape = 23) + 
  geom_point(data = subset(marijuana_use, rm_in_post == 1), size=4, color=cbPalette[3], fill = cbPalette[3], shape = 23) +
  theme_classic() + 
  labs(title = "Marijuana use in past-year", 
       x = "Difference in percent change in use between recreational states and other states", 
       y = "") +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), 
                     labels = c("18 to 25", "12 to 17", "26 and up", "18 and up", "12 and up")) + 
  scale_x_continuous(limits = c(-15, 122),
                     breaks = c(-15, 0, 15, 30, 45, 60, 75, 90, 105, 120), 
                     labels = c("-15", "0", "15", "30", "45", "60", "75", "90", "105", "120"))




combined_plot <- plot_grid(percent_past_month, percent_past_year, 
                           diff_month, diff_year, 
                           ncol = 2)

ggsave(combined_plot, file = "output/plots/bw-change-in-use.pdf", width = 14, height = 7)
