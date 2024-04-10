# 3.1.1 Installing packages and opening libraries
install.packages("tidyverse")
install.packages("here")
install.packages("skimr")
install.packages("janitor")
install.packages("lubridate")
install.packages("plotly")
library(tidyverse)
library(here)
library(skimr)
library(janitor)
library(lubridate)
library(plotly)

# 3.1.2 Importing the datasets
salaries <- read_csv("...salaries.csv")

# 3.3.1 Distinct data
n_distinct(salariesIII$work_year)
n_distinct(salariesIII$experience_level)
n_distinct(salariesIII$employment_type)
n_distinct(salariesIII$job_title)
n_distinct(salariesIII$salary)
n_distinct(salariesIII$salary_currency)
n_distinct(salariesIII$salary_in_usd)
n_distinct(salariesIII$employee_residence)
n_distinct(salariesIII$remote_ratio)
n_distinct(salariesIII$company_location)
n_distinct(salariesIII$company_size)

# 3.3.2 Checking for null or blank values
sum(is.na(salariesIII$work_year))
sum(is.na(salariesIII$experience_level))
sum(is.na(salariesIII$employment_type))
sum(is.na(salariesIII$job_title))
sum(is.na(salariesIII$salary))
sum(is.na(salariesIII$salary_currency))
sum(is.na(salariesIII$salary_in_usd))
sum(is.na(salariesIII$employee_residence))
sum(is.na(salariesIII$remote_ratio))
sum(is.na(salariesIII$company_location))
sum(is.na(salariesIII$company_size))

# 3.3.3 Ensuring that numerical data requiring calculations are as numerals
str(salariesIII)
salariesIII$salary <- as.numeric(salariesIII$salary)
salariesIII$salary_in_usd <- as.numeric(salariesIII$salary_in_usd)

# 3.3.4 Checking and removing duplicate rows
duplicates <- sum(duplicated(salariesIII))
salariesIII <- salariesIII[!duplicated(salariesIII), ]

# 3.3.5 Verification of minimum, maximum and average salary values in USD
min_salary_in_usd <- min(salariesIII$salary_in_usd)
max_salary_in_usd <- max(salariesIII$salary_in_usd)
mean_salary_in_usd <- mean(salariesIII$salary_in_usd)

# 3.3.6 Creating the salary column in USD per month
salariesIII$salary_monthly <- salariesIII$salary_in_usd/12

# 3.3.7 Removing the salary and salary_currency columns
salariesIV <- subset(salariesIII, select = -c(salary, salary_currency))
colnames(salariesIV)

# 3.3.8 Contextualizing the column name
colnames(salariesIV)[colnames(salariesIV) == "salary_in_usd"] <- "salary_yearly"
colnames(salariesIV)

# 3.3.9 Rearranging columns in the way wanted
salariesIV <- subset(salariesIV, select = c(
  work_year,
  experience_level,
  employment_type,
  job_title,
  salary_yearly,
  salary_monthly,
  employee_residence,
  remote_ratio,
  company_location,
  company_size
))

head(salariesIV)

# 4.1.1 Work year
year_counts <- table(salariesIV$work_year)

df_year_counts <- as.data.frame(year_counts)
names(df_year_counts) <- c("Year", "Occurrences")

df_year_counts <- df_year_counts[order(df_year_counts$Year), ]

ggplot(df_year_counts, aes(x = Year, y = Occurrences)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(title = "Occurrences Count by Year", x = "Year", y = "Occurrences") +
  theme_minimal()

# 4.1.2 Experience level
experience_counts <- table(salariesIV$experience_level)

df_experience_counts <- as.data.frame(experience_counts)
names(df_experience_counts) <- c("Experience Level", "Occurrences")

df_experience_counts$"Experience Level" <- factor(df_experience_counts$"Experience Level", levels = c("EN", "MI", "SE", "EX"),
                                                  labels = c("Junior", "Intermediate", "Senior", "Executive"))

df_experience_counts <- df_experience_counts[order(match(df_experience_counts$"Experience Level", c("Junior", "Intermediate", "Senior", "Executive"))), ]

ggplot(df_experience_counts, aes(x = reorder(`Experience Level`, Occurrences), y = Occurrences)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(title = "Occurrences Count by Experience Level", x = "Experience Level", y = "Occurrences") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.1.3 Job type
employment_counts <- table(salariesIV$employment_type)

df_employment_counts <- as.data.frame(employment_counts)
names(df_employment_counts) <- c("Employment Type", "Occurrences")

df_employment_counts$"Employment Type" <- factor(df_employment_counts$"Employment Type", levels = c("PT", "FT", "CT", "FL"),
                                                  labels = c("Part-time", "Full-time", "Contract", "Freelance"))

df_employment_counts <- df_employment_counts[order(match(df_employment_counts$"Employment Type", c("Part-time", "Full-time", "Contract", "Freelance"))), ]

ggplot(df_employment_counts, aes(x = reorder(`Employment Type`, Occurrences), y = Occurrences)) +
  geom_bar(stat = "identity", fill = "lightsalmon") +
  labs(title = "Occurrences Count by Employment Type", x = "Employment Type", y = "Occurrences") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.1.4 Job title
job_counts <- table(salariesIV$job_title)

df_job_counts <- as.data.frame(job_counts)
names(df_job_counts) <- c("Job Title", "Occurrences")

df_job_counts <- df_job_counts[order(-df_job_counts$Occurrences), ]

df_job_counts <- head(df_job_counts, 10)

ggplot(df_job_counts, aes(x = reorder(`Job Title`, -Occurrences), y = Occurrences)) +
  geom_bar(stat = "identity", fill = "lightcoral") +
  labs(title = "Top 10 Job Titles by Occurrence Count", x = "Job Title", y = "Occurrences") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.1.5 Employee's country of residence
residence_counts <- table(salariesIV$employee_residence)

df_residence_counts <- as.data.frame(residence_counts)
names(df_residence_counts) <- c("Country of Residence", "Occurrences")

df_residence_counts <- df_residence_counts[order(-df_residence_counts$Occurrences), ]

df_residence_counts <- head(df_residence_counts, 5)

ggplot(df_residence_counts, aes(x = reorder(`Country of Residence`, -Occurrences), y = Occurrences)) +
  geom_bar(stat = "identity", fill = "yellow") +
  labs(title = "Top 5 Countries of Employee Residence", x = "Country of Residence", y = "Occurrences") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
table(salariesIV$employee_residence =="US")
table(salariesIV$employee_residence =="GB")

# 4.1.6 Proportion of remote work
remote_counts <- table(salariesIV$remote_ratio)

df_remote_counts <- as.data.frame(remote_counts)
names(df_remote_counts) <- c("Remote Work Ratio", "Occurrences")

df_remote_counts$`Remote Work Ratio` <- factor(df_remote_counts$`Remote Work Ratio`, levels = c("0", "50", "100"))

ggplot(df_remote_counts, aes(x = `Remote Work Ratio`, y = Occurrences, fill = `Remote Work Ratio`)) +
  geom_bar(stat = "identity") +
  labs(title = "Remote Work Ratio", x = "Remote Work Ratio", y = "Occurrences", fill = "Remote Work Ratio") +
  scale_fill_manual(values = c("lightblue", "lightgreen", "lightcoral"),
                    labels = c("No remote work", "Partially remote", "Fully remote")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.1.7 Company location
location_counts <- table(salariesIV$company_location)

df_location_counts <- as.data.frame(location_counts)
names(df_location_counts) <- c("Company Location Country", "Occurrences")

df_location_counts <- df_location_counts[order(-df_location_counts$Occurrences), ]

df_location_counts <- head(df_location_counts, 5)

ggplot(df_location_counts, aes(x = reorder(`Company Location Country`, -Occurrences), y = Occurrences)) +
  geom_bar(stat = "identity", fill = "green") +
  labs(title = "Top 5 Company Location Countries", x = "Company Location Country", y = "Occurrences") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

table(salariesIV$company_location == "US")
table(salariesIV$company_location == "GB")

# 4.1.8 Company size
company_size_counts <- table(salariesIV$company_size)

df_company_size_counts <- as.data.frame(company_size_counts)
names(df_company_size_counts) <- c("Company Size", "Occurrences")

df_company_size_counts$`Company Size` <- factor(df_company_size_counts$`Company Size`, levels = c("S", "M", "L"),
                                                labels = c("Small", "Medium", "Large"))

ggplot(df_company_size_counts, aes(x = `Company Size`, y = Occurrences, fill = `Company Size`)) +
  geom_bar(stat = "identity") +
  labs(title = "Distribution of Company Size", x = "Company Size", y = "Occurrences") +
  scale_fill_manual(values = c("lightblue", "lightgreen", "lightcoral"),
                    labels = c("Small", "Medium", "Large"),
                    guide = FALSE) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.1 Percentage of employees working for foreign companies
different_country_occurrences <- sum(salariesIV$employee_residence != salariesIV$company_location)

# 4.2.2 Average salaries by experience level
average_salary_by_experience <- salariesIV %>%
  group_by(experience_level) %>%
  summarize(mean_salary = mean(salary_yearly))

average_salary_by_experience$experience_level <- factor(average_salary_by_experience$experience_level, levels = c("EN", "MI", "SE", "EX"))

average_salary_by_experience$experience_level <- factor(average_salary_by_experience$experience_level, labels = c("Junior", "Intermediate", "Senior", "Executive"))

ggplot(average_salary_by_experience, aes(x = experience_level, y = mean_salary, fill = experience_level)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Salary by Experience Level",
       x = "Experience Level",
       y = "Average Salary",
       fill = "Experience Level") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
average_salary_by_experience_monthly <- salariesIV %>%
  group_by(experience_level) %>%
  summarize(mean_salary = mean(salary_monthly))

average_salary_by_experience_monthly$experience_level <- factor(average_salary_by_experience_monthly$experience_level, levels = c("EN", "MI", "SE", "EX"))

average_salary_by_experience_monthly$experience_level <- factor(average_salary_by_experience_monthly$experience_level, labels = c("Junior", "Intermediate", "Senior", "Executive"))

ggplot(average_salary_by_experience_monthly, aes(x = experience_level, y = mean_salary, fill = experience_level)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Salary by Experience Level - Monthly",
       x = "Experience Level",
       y = "Average Salary",
       fill = "Experience Level") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.3 Highest-paying job titles
average_salary_by_job <- salariesIV %>%
  group_by(job_title) %>%
  summarize(mean_salary = mean(salary_yearly)) %>%
  arrange(desc(mean_salary)) %>%
  top_n(10)

ggplot(average_salary_by_job, aes(x = reorder(job_title, mean_salary), y = mean_salary, fill = job_title)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 10 Highest Paid Jobs - Annually",
       x = "Job Title",
       y = "Average Yearly Salary") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  scale_y_continuous(labels = scales::number_format(scale = 1e-3, suffix = "k"))
  
average_salary_by_job_monthly <- salariesIV %>%
  group_by(job_title) %>%
  summarize(mean_salary = mean(salary_monthly)) %>%
  arrange(desc(mean_salary)) %>%
  top_n(10)

ggplot(average_salary_by_job_monthly, aes(x = reorder(job_title, mean_salary), y = mean_salary, fill = job_title)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 10 Highest Paid Jobs - Monthly",
       x = "Job Title",
       y = "Average Monthly Salary") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  scale_y_continuous(labels = scales::number_format(scale = 1e-3, suffix = "k"))

# 4.2.4 Positions with the highest percentage growth (2023-2024)
positions_with_10_occurrences <- salariesIV %>%
  filter(work_year %in% c(2023, 2024)) %>%
  group_by(job_title, work_year) %>%
  summarize(occurrences = n()) %>%
  filter(occurrences >= 10) %>%
  pull(job_title)

filtered_salaries <- salariesIV %>%
  filter(job_title %in% positions_with_10_occurrences, work_year %in% c(2023, 2024))

growth_by_position <- filtered_salaries %>%
  group_by(job_title) %>%
  summarize(percent_growth = ((mean(salary_yearly[work_year == 2024]) - mean(salary_yearly[work_year == 2023])) / mean(salary_yearly[work_year == 2023])) * 100) %>%
  arrange(desc(percent_growth)) %>%
  head(10)

ggplot(growth_by_position, aes(x = reorder(job_title, desc(percent_growth)), y = percent_growth)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(title = "Top 10 Positions with Highest Growth % in Payment (2023-2024)*",
       x = "Position",
       y = "Percentage Growth") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.5 Salary difference between modalities (In-person and Remote)
```r
salariesIV$experience_level <- factor(salariesIV$experience_level, levels = c("EN", "MI", "SE", "EX"))

salaries_filtered <- salariesIV %>%
  filter(remote_ratio %in% c(0, 100))

mean_salary_by_experience_and_mode <- salaries_filtered %>%
  group_by(experience_level, remote_ratio) %>%
  summarize(mean_salary = mean(salary_yearly))

mean_salary_by_experience_and_mode$mode <- ifelse(mean_salary_by_experience_and_mode$remote_ratio == 0, "In-Person", "Remote")

ggplot(mean_salary_by_experience_and_mode, aes(x = experience_level, y = mean_salary, fill = mode)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Salary by Experience Level and Mode - Yearly",
       x = "Experience Level",
       y = "Average Salary - Year",
       fill = "Mode") +
  theme_minimal()

salariesIV$experience_level <- factor(salariesIV$experience_level, levels = c("EN", "MI", "SE", "EX"))

salaries_filtered <- salariesIV %>%
  filter(remote_ratio %in% c(0, 100))

mean_salary_by_experience_and_mode <- salaries_filtered %>%
  group_by(experience_level, remote_ratio) %>%
  summarize(mean_salary = mean(salary_monthly))

mean_salary_by_experience_and_mode$mode <- ifelse(mean_salary_by_experience_and_mode$remote_ratio == 0, "In-Person", "Remote")

ggplot(mean_salary_by_experience_and_mode, aes(x = experience_level, y = mean_salary, fill = mode)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Salary by Experience Level and Mode - Monthly",
       x = "Experience Level",
       y = "Average Salary - Month",
       fill = "Mode") +
  theme_minimal()
  
  table(salariesIV$remote_ratio == "50")

# 4.2.6 Countries with the highest average salaries
average_salary_by_country <- salariesIV %>%
  group_by(employee_residence) %>%
  summarize(average_salary = mean(salary_yearly),
            occurrences = n()) %>%
  filter(occurrences >= 10) %>% 
  top_n(10, average_salary) %>%
  arrange(average_salary) 

ggplot(average_salary_by_country, aes(x = reorder(employee_residence, average_salary), y = average_salary)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Top 10 Highest Average Yearly Salaries by Country*",
       x = "Country of Residence",
       y = "Average Salary - Year",
       fill = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

average_salary_by_country <- salariesIV %>%
  group_by(employee_residence) %>%
  summarize(average_salary = mean(salary_monthly),
            occurrences = n()) %>%
  filter(occurrences >= 10) %>% 
  top_n(10, average_salary) %>%
  arrange(average_salary) 

ggplot(average_salary_by_country, aes(x = reorder(employee_residence, average_salary), y = average_salary)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Top 10 Highest Average Monthly Salaries by Country*",
       x = "Country of Residence",
       y = "Average Salary - Month",
       fill = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.7 Salary comparison by company location
average_salary_by_location <- salariesIV %>%
  group_by(company_location) %>%
  summarize(average_salary = mean(salary_yearly),
            occurrences = n()) %>%
  filter(occurrences >= 10) %>%  
  top_n(10, average_salary) %>%
  arrange(desc(average_salary)) 

ggplot(average_salary_by_location, aes(x = reorder(company_location, average_salary), y = average_salary)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(title = "Top 10 Highest Average Yearly Salaries by Company Location*",
       x = "Company Location",
       y = "Average Salary - Year",
       fill = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.8 Salary disparities between different company sizes
```r
average_salary_by_company_size_and_experience <- salariesIV %>%
  group_by(company_size, experience_level) %>%
  summarize(average_salary = mean(salary_yearly))

ggplot(average_salary_by_company_size_and_experience, aes(x = company_size, y = average_salary, fill = experience_level)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Salaries by Company Size - Yearly",
       x = "Company Size",
       y = "Average Salary - Year",
       fill = "Experience Level") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

average_salary_by_company_size_and_experience <- salariesIV %>%
  group_by(company_size, experience_level) %>%
  summarize(average_salary = mean(salary_monthly))

ggplot(average_salary_by_company_size_and_experience, aes(x = company_size, y = average_salary, fill = experience_level)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Salaries by Company Size - Monthly",
       x = "Company Size",
       y = "Average Salary - Month",
       fill = "Experience Level") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.9 Analysis of the relationship between company size and type of employment
salaries_small <- subset(salariesIV, company_size == "S")

contingency_table <- table(salaries_small$remote_ratio)

contingency_df <- as.data.frame(contingency_table)
names(contingency_df) <- c("Work Type", "Count")

contingency_df$Percentage <- contingency_df$Count / sum(contingency_df$Count) * 100

contingency_df$Remote_Ratio_Label <- ifelse(contingency_df$`Work Type` == 0, "On-site",
                                            ifelse(contingency_df$`Work Type` == 50, "Hybrid", "Remote"))

pie_chart <- ggplot(contingency_df, aes(x = "", y = Percentage, fill = factor(Remote_Ratio_Label))) +
  geom_bar(stat = "identity", width = 1) +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), position = position_stack(vjust = 0.5), size = 3) +
  coord_polar("y", start = 0) +
  labs(title = "Proportion of Work Type for SMALL Companies",
       fill = "Work Type") +
  theme_void() +
  theme(legend.position = "right")

print(pie_chart)

table(salariesIV$company_size == "S")

salaries_medium <- subset(salariesIV, company_size == "M")

contingency_table <- table(salaries_medium$remote_ratio)

contingency_df <- as.data.frame(contingency_table)
names(contingency_df) <- c("Work Type", "Count")

contingency_df$Percentage <- contingency_df$Count / sum(contingency_df$Count) * 100

contingency_df$Remote_Ratio_Label <- ifelse(contingency_df$`Work Type` == 0, "On-site",
                                            ifelse(contingency_df$`Work Type` == 50, "Hybrid", "Remote"))

pie_chart <- ggplot(contingency_df, aes(x = "", y = Percentage, fill = factor(Remote_Ratio_Label))) +
  geom_bar(stat = "identity", width = 1) +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), position = position_stack(vjust = 0.5), size = 3) +
  coord_polar("y", start = 0) +
  labs(title = "Proportion of Work Type for MEDIUM Companies",
       fill = "Work Type") +
  theme_void() +
  theme(legend.position = "right")

print(pie_chart)

table(salariesIV$company_size == "M")

salaries_large <- subset(salariesIV, company_size == "L")

contingency_table <- table(salaries_large$remote_ratio)

contingency_df <- as.data.frame(contingency_table)
names(contingency_df) <- c("Work Type", "Count")

contingency_df$Percentage <- contingency_df$Count / sum(contingency_df$Count) * 100

contingency_df$Remote_Ratio_Label <- ifelse(contingency_df$`Work Type` == 0, "On-site",
                                            ifelse(contingency_df$`Work Type` == 50, "Hybrid", "Remote"))

pie_chart <- ggplot(contingency_df, aes(x = "", y = Percentage, fill = factor(Remote_Ratio_Label))) +
  geom_bar(stat = "identity", width = 1) +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), position = position_stack(vjust = 0.5), size = 3) +
  coord_polar("y", start = 0) +
  labs(title = "Proportion of Work Type for LARGE Companies",
       fill = "Work Type") +
  theme_void() +
  theme(legend.position = "right")

print(pie_chart)

table(salariesIV$company_size == "L")