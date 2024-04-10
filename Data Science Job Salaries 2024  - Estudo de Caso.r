# 3.1.1 Instalando os pacotes e abrindo as bibliotecas
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

# 3.1.2 Importando os conjuntos de dados
salaries <- read_csv("...salaries.csv")

### 3.3.1 Dados distintos
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

### 3.3.2 Verificando se há valores nulos ou em branco
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

# 3.3.3 Garantindo que os dados numéricos que necessitam cálculos estejam como numerais
str(salariesIII)
salariesIII$salary <- as.numeric(salariesIII$salary)
salariesIII$salary_in_usd <- as.numeric(salariesIII$salary_in_usd)

# 3.3.4 Verificando e removendo linhas duplicadas
duplicadas <- sum(duplicated(salariesIII))
salariesIII <- salariesIII[!duplicated(salariesIII), ]

# 3.3.5 Verificação de valores mínimos, máximos e médios dos salários em USD
min_salary_in_usd <- min(salariesIII$salary_in_usd)
max_salary_in_usd <- max(salariesIII$salary_in_usd)
mean_salary_in_usd <- mean(salariesIII$salary_in_usd)

# 3.3.6 Criando a coluna de salários em USD por mês
salariesIII$salary_monthly <- salariesIII$salary_in_usd/12

# 3.3.7 Removendo as colunas salary e salary_currency
salariesIV <- subset(salariesIII, select = -c(salary, salary_currency))
colnames(salariesIV)

# 3.3.8 Contextualizando o nome da coluna
colnames(salariesIV)[colnames(salariesIV) == "salary_in_usd"] <- "salary_yearly"
colnames(salariesIV)

# 3.3.9 Reorganizando as colunas na maneira desejada
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

# 4.1.1 Ano de trabalho
contagem_anos <- table(salariesIV$work_year)

df_contagem_anos <- as.data.frame(contagem_anos)
names(df_contagem_anos) <- c("Ano", "Ocorrências")

df_contagem_anos <- df_contagem_anos[order(df_contagem_anos$Ano), ]

ggplot(df_contagem_anos, aes(x = Ano, y = Ocorrências)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(title = "Contagem de Ocorrências por Ano", x = "Ano", y = "Ocorrências") +
  theme_minimal()

# 4.1.2 Nível de experiência
contagem_xp <- table(salariesIV$experience_level)

df_contagem_xp <- as.data.frame(contagem_xp)
names(df_contagem_xp) <- c("Nível de Experiência", "Ocorrências")

df_contagem_xp$"Nível de Experiência" <- factor(df_contagem_xp$"Nível de Experiência", levels = c("EN", "MI", "SE", "EX"),
    labels = c("Júnior", "Intermediário", "Senior", "Diretor"))

df_contagem_xp <- df_contagem_xp[order(match(df_contagem_xp$"Nível de Experiência", c("Júnior", "Intermediário", "Senior", "Diretor"))), ]

ggplot(df_contagem_xp, aes(x = reorder(`Nível de Experiência`, Ocorrências), y = Ocorrências)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(title = "Contagem de Ocorrências por Nível de Experiência", x = "Nível de Experiência", y = "Ocorrências") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.1.3 Tipo de emprego
contagem_emprego <- table(salariesIV$employment_type)

df_contagem_emprego <- as.data.frame(contagem_emprego)
names(df_contagem_emprego) <- c("Tipo de Emprego", "Ocorrências")

df_contagem_emprego$"Tipo de Emprego" <- factor(df_contagem_emprego$"Tipo de Emprego", levels = c("PT", "FT", "CT", "FL"),
  labels = c("Part-time", "Full-time", "Contract", "Freelance"))

df_contagem_emprego <- df_contagem_emprego[order(match(df_contagem_emprego$"Tipo de Emprego", c("Part-time", "Full-time", "Contract", "Freelance"))), ]

ggplot(df_contagem_emprego, aes(x = reorder(`Tipo de Emprego`, Ocorrências), y = Ocorrências)) +
  geom_bar(stat = "identity", fill = "lightsalmon") +
  labs(title = "Contagem de Ocorrências por Tipo de Emprego", x = "Tipo de Emprego", y = "Ocorrências") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  table(salariesIV$employment_type=="FT")

# 4.1.4 Título do cargo
contagem_cargo <- table(salariesIV$job_title)

df_contagem_cargo <- as.data.frame(contagem_cargo)
names(df_contagem_cargo) <- c("Título do Cargo", "Ocorrências")

df_contagem_cargo <- df_contagem_cargo[order(-df_contagem_cargo$Ocorrências), ]

df_contagem_cargo <- head(df_contagem_cargo, 10)

ggplot(df_contagem_cargo, aes(x = reorder(`Título do Cargo`, -Ocorrências), y = Ocorrências)) +
  geom_bar(stat = "identity", fill = "lightcoral") +
  labs(title = "Top 10 Títulos de Cargo por Contagem de Ocorrências", x = "Título de Cargo", y = "Ocorrências") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.1.5 País de residência do funcionário
contagem_residencia <- table(salariesIV$employee_residence)

df_contagem_residencia <- as.data.frame(contagem_residencia)
names(df_contagem_residencia) <- c("País de Residência", "Ocorrências")

df_contagem_residencia <- df_contagem_residencia[order(-df_contagem_residencia$Ocorrências), ]

df_contagem_residencia <- head(df_contagem_residencia, 5)

ggplot(df_contagem_residencia, aes(x = reorder(`País de Residência`, -Ocorrências), y = Ocorrências)) +
  geom_bar(stat = "identity", fill = "yellow") +
  labs(title = "Top 5 Países de Residência dos Funcionários", x = "País de Residência", y = "Ocorrências") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
table(salariesIV$employee_residence =="US")
table(salariesIV$employee_residence =="GB")

# 4.1.6 Proporção de trabalho remoto
contagem_remoto <- table(salariesIV$remote_ratio)

df_contagem_remoto <- as.data.frame(contagem_remoto)
names(df_contagem_remoto) <- c("Proporção de Trabalho Remoto", "Ocorrências")

df_contagem_remoto$`Proporção de Trabalho Remoto` <- factor(df_contagem_remoto$`Proporção de Trabalho Remoto`, levels = c("0", "50", "100"))

ggplot(df_contagem_remoto, aes(x = `Proporção de Trabalho Remoto`, y = Ocorrências, fill = `Proporção de Trabalho Remoto`)) +
  geom_bar(stat = "identity") +
  labs(title = "Proporção de Trabalho Remoto", x = "Proporção de Trabalho Remoto", y = "Ocorrências", fill = "Proporção de Trabalho Remoto") +
  scale_fill_manual(values = c("lightblue", "lightgreen", "lightcoral"),
                    labels = c("Sem trabalho remoto", "Parcialmente remoto", "Totalmente remoto")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.1.7 Localização da empresa
contagem_localizacao <- table(salariesIV$company_location)

df_contagem_localizacao <- as.data.frame(contagem_localizacao)
names(df_contagem_localizacao) <- c("País de Localização da Empresa", "Ocorrências")

df_contagem_localizacao <- df_contagem_localizacao[order(-df_contagem_localizacao$Ocorrências), ]

df_contagem_localizacao <- head(df_contagem_localizacao, 5)

ggplot(df_contagem_localizacao, aes(x = reorder(`País de Localização da Empresa`, -Ocorrências), y = Ocorrências)) +
  geom_bar(stat = "identity", fill = "green") +
  labs(title = "Top 5 Países de Localização da Empresa", x = "País de Localização da Empresa", y = "Ocorrências") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

table(salariesIV$company_location == "US")
table(salariesIV$company_location == "GB")

# 4.1.8 Tamanho da empresa
contagem_tamanho_empresa <- table(salariesIV$company_size)

df_contagem_tamanho_empresa <- as.data.frame(contagem_tamanho_empresa)
names(df_contagem_tamanho_empresa) <- c("Tamanho da Empresa", "Ocorrências")

df_contagem_tamanho_empresa$`Tamanho da Empresa` <- factor(df_contagem_tamanho_empresa$`Tamanho da Empresa`, levels = c("S", "M", "L"))

ggplot(df_contagem_tamanho_empresa, aes(x = `Tamanho da Empresa`, y = Ocorrências, fill = `Tamanho da Empresa`)) +
  geom_bar(stat = "identity") +
  labs(title = "Distribuição do Tamanho da Empresa", x = "Tamanho da Empresa", y = "Ocorrências", fill = "Tamanho da Empresa") +
  scale_fill_manual(values = c("lightblue", "lightgreen", "lightcoral"),
    labels = c("Pequena", "Média", "Grande")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.1 Percentual de funcionários trabalhando para empresas estrangeiras
ocorrencias_diferentes_paises <- sum(salariesIV$employee_residence != salariesIV$company_location)

# 4.2.2 Média dos salários por nível de experiência
media_salario_por_experiencia <- salariesIV %>%
  group_by(experience_level) %>%
  summarize(media_salario = mean(salary_yearly))

media_salario_por_experiencia$experience_level <- factor(media_salario_por_experiencia$experience_level, levels = c("EN", "MI", "SE", "EX"))

media_salario_por_experiencia$experience_level <- factor(media_salario_por_experiencia$experience_level, labels = c("Júnior", "Intermediário", "Senior", "Diretor"))

ggplot(media_salario_por_experiencia, aes(x = experience_level, y = media_salario, fill = experience_level)) +
  geom_bar(stat = "identity") +
  labs(title = "Média de Salário por Nível de Experiência",
       x = "Nível de Experiência",
       y = "Média de Salário",
       fill = "Nível de Experiência") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  
  media_salario_por_experiencia <- salariesIV %>%
  group_by(experience_level) %>%
  summarize(media_salario = mean(salary_monthly))

media_salario_por_experiencia$experience_level <- factor(media_salario_por_experiencia$experience_level, levels = c("EN", "MI", "SE", "EX"))

media_salario_por_experiencia$experience_level <- factor(media_salario_por_experiencia$experience_level, labels = c("Júnior", "Intermediário", "Senior", "Diretor"))

ggplot(media_salario_por_experiencia, aes(x = experience_level, y = media_salario, fill = experience_level)) +
  geom_bar(stat = "identity") +
  labs(title = "Média de Salário por Nível de Experiência - Mensal",
       x = "Nível de Experiência",
       y = "Média de Salário",
       fill = "Nível de Experiência") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.3 Títulos dos cargos mais bem pagos
media_salario_por_cargo <- salariesIV %>%
  group_by(job_title) %>%
  summarize(media_salario = mean(salary_yearly)) %>%
  arrange(desc(media_salario)) %>%
  top_n(10)

ggplot(media_salario_por_cargo, aes(x = reorder(job_title, media_salario), y = media_salario, fill = job_title)) +
  geom_bar(stat = "identity") +
  labs(title = "10 Cargos Mais Bem Pagos - Anualmente",
       x = "Título do Cargo",
       y = "Média de Salário Anual") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")  +
  scale_y_continuous(labels = scales::number_format(scale = 1e-3, suffix = "k"))
  
  media_salario_por_cargo <- salariesIV %>%
  group_by(job_title) %>%
  summarize(media_salario = mean(salary_monthly)) %>%
  arrange(desc(media_salario)) %>%
  top_n(10)

ggplot(media_salario_por_cargo, aes(x = reorder(job_title, media_salario), y = media_salario, fill = job_title)) +
  geom_bar(stat = "identity") +
  labs(title = "10 Cargos Mais Bem Pagos - Mensalmente",
       x = "Título do Cargo",
       y = "Média de Salário Mensal") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")  +
  scale_y_continuous(labels = scales::number_format(scale = 1e-3, suffix = "k"))

# 4.2.4 Cargos com maior crescimento percentual (2023-2024)
cargos_com_10_ocorrencias <- salariesIV %>%
  filter(work_year %in% c(2023, 2024)) %>%
  group_by(job_title, work_year) %>%
  summarize(ocorrencias = n()) %>%
  filter(ocorrencias >= 10) %>%
  pull(job_title)

salaries_filtrados <- salariesIV %>%
  filter(job_title %in% cargos_com_10_ocorrencias, work_year %in% c(2023, 2024))

crescimento_por_cargo <- salaries_filtrados %>%
  group_by(job_title) %>%
  summarize(percentual_crescimento = ((mean(salary_yearly[work_year == 2024]) - mean(salary_yearly[work_year == 2023])) / mean(salary_yearly[work_year == 2023])) * 100) %>%
  arrange(desc(percentual_crescimento)) %>%
  head(10)

ggplot(crescimento_por_cargo, aes(x = reorder(job_title, desc(percentual_crescimento)), y = percentual_crescimento)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(title = "10 Cargos com Maior Crescimento % de Pagamento (2023-2024)*",
       x = "Cargo",
       y = "Percentual de Crescimento") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.5 Diferença salarial entre as modalidades (Presencial e Remoto)
salariesIV$experience_level <- factor(salariesIV$experience_level, levels = c("EN", "MI", "SE", "EX"))

salaries_filtered <- salariesIV %>%
  filter(remote_ratio %in% c(0, 100))

media_salario_por_senioridade_e_modalidade <- salaries_filtered %>%
  group_by(experience_level, remote_ratio) %>%
  summarize(media_salario = mean(salary_yearly))

media_salario_por_senioridade_e_modalidade$modalidade <- ifelse(media_salario_por_senioridade_e_modalidade$remote_ratio == 0, "Presencial", "Remoto")

ggplot(media_salario_por_senioridade_e_modalidade, aes(x = experience_level, y = media_salario, fill = modalidade)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Média Salarial por Nível de Experiência e Modalidade - Anual",
       x = "Nível de Experiência",
       y = "Média Salarial - Ano",
       fill = "Modalidade") +
  theme_minimal()
  
  salariesIV$experience_level <- factor(salariesIV$experience_level, levels = c("EN", "MI", "SE", "EX"))

salaries_filtered <- salariesIV %>%
  filter(remote_ratio %in% c(0, 100))

media_salario_por_senioridade_e_modalidade <- salaries_filtered %>%
  group_by(experience_level, remote_ratio) %>%
  summarize(media_salario = mean(salary_monthly))

media_salario_por_senioridade_e_modalidade$modalidade <- ifelse(media_salario_por_senioridade_e_modalidade$remote_ratio == 0, "Presencial", "Remoto")

ggplot(media_salario_por_senioridade_e_modalidade, aes(x = experience_level, y = media_salario, fill = modalidade)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Média Salarial por Nível de Experiência e Modalidade - Mensal",
       x = "Nível de Experiência",
       y = "Média Salarial - Mês",
       fill = "Modalidade") +
  theme_minimal()
  
  table(salariesIV$remote_ratio == "50")

# 4.2.6 Países com as maiores médias salariais
media_salarial_por_pais <- salariesIV %>%
  group_by(employee_residence) %>%
  summarize(media_salarial = mean(salary_yearly),
            ocorrencias = n()) %>%
  filter(ocorrencias >= 10) %>% 
  top_n(10, media_salarial) %>%
  arrange(media_salarial) 

ggplot(media_salarial_por_pais, aes(x = reorder(employee_residence, media_salarial), y = media_salarial)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "10 Médias Salariais Mais Altas por País - Anual*",
       x = "País de Residência",
       y = "Média Salarial - Ano",
       fill = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  media_salarial_por_pais <- salariesIV %>%
  group_by(employee_residence) %>%
  summarize(media_salarial = mean(salary_monthly),
            ocorrencias = n()) %>%
  filter(ocorrencias >= 10) %>% 
  top_n(10, media_salarial) %>%
  arrange(media_salarial) 

ggplot(media_salarial_por_pais, aes(x = reorder(employee_residence, media_salarial), y = media_salarial)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "10 Médias Salariais Mais Altas por País - Mensal*",
       x = "País de Residência",
       y = "Média Salarial - Mês",
       fill = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.7 Comparação de salários por localização da empresa
media_salarial_por_localizacao <- salariesIV %>%
  group_by(company_location) %>%
  summarize(media_salarial = mean(salary_yearly),
            ocorrencias = n()) %>%
  filter(ocorrencias >= 10) %>%  
  top_n(10, media_salarial) %>%
  arrange(desc(media_salarial)) 

ggplot(media_salarial_por_localizacao, aes(x = reorder(company_location, media_salarial), y = media_salarial)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(title = "10 Médias Salariais Mais Altas por Localização da Empresa - Anual*",
       x = "Localização da Empresa",
       y = "Média Salarial - Ano",
       fill = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.8 Disparidades salariais entre diferentes tamanhos de empresa
media_salarial_por_tamanho_empresa_e_senioridade <- salariesIV %>%
  group_by(company_size, experience_level) %>%
  summarize(media_salarial = mean(salary_yearly))

ggplot(media_salarial_por_tamanho_empresa_e_senioridade, aes(x = company_size, y = media_salarial, fill = experience_level)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Médias Salariais por Tamanho de Empresa - Anual",
       x = "Tamanho da Empresa",
       y = "Média Salarial - Ano",
       fill = "Nível de Experiência") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

media_salarial_por_tamanho_empresa_e_senioridade <- salariesIV %>%
  group_by(company_size, experience_level) %>%
  summarize(media_salarial = mean(salary_monthly))

ggplot(media_salarial_por_tamanho_empresa_e_senioridade, aes(x = company_size, y = media_salarial, fill = experience_level)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Médias Salariais por Tamanho de Empresa - Mensal",
       x = "Tamanho da Empresa",
       y = "Média Salarial - Mês",
       fill = "Nível de Experiência") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4.2.9 Análise da relação entre tamanho da empresa e modalidade de emprego
```r
salaries_small <- subset(salariesIV, company_size == "S")

contingency_table <- table(salaries_small$remote_ratio)

contingency_df <- as.data.frame(contingency_table)
names(contingency_df) <- c("Tipo de Trabalho", "Count")

contingency_df$Percentage <- contingency_df$Count / sum(contingency_df$Count) * 100

contingency_df$Remote_Ratio_Label <- ifelse(contingency_df$"Tipo de Trabalho" == 0, "Presencial",
                                            ifelse(contingency_df$"Tipo de Trabalho" == 50, "Semi-Presencial", "Remoto"))

pie_chart <- ggplot(contingency_df, aes(x = "", y = Percentage, fill = factor(Remote_Ratio_Label))) +
  geom_bar(stat = "identity", width = 1) +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), position = position_stack(vjust = 0.5), size = 3) +
  coord_polar("y", start = 0) +
  labs(title = "Proporção de Tipo Trabalho para Empresas PEQUENAS",
       fill = "Tipo de Trabalho") +
  theme_void() +
  theme(legend.position = "right")

print(pie_chart)

table(salariesIV$company_size == "S")

salaries_medium <- subset(salariesIV, company_size == "M")

contingency_table <- table(salaries_medium$remote_ratio)

contingency_df <- as.data.frame(contingency_table)
names(contingency_df) <- c("Tipo de Trabalho", "Count")

contingency_df$Percentage <- contingency_df$Count / sum(contingency_df$Count) * 100

contingency_df$Remote_Ratio_Label <- ifelse(contingency_df$"Tipo de Trabalho" == 0, "Presencial",
                                            ifelse(contingency_df$"Tipo de Trabalho" == 50, "Semi-Presencial", "Remoto"))

pie_chart <- ggplot(contingency_df, aes(x = "", y = Percentage, fill = factor(Remote_Ratio_Label))) +
  geom_bar(stat = "identity", width = 1) +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), position = position_stack(vjust = 0.5), size = 3) +
  coord_polar("y", start = 0) +
  labs(title = "Proporção de Tipo Trabalho para Empresas MÉDIAS",
       fill = "Tipo de Trabalho") +
  theme_void() +
  theme(legend.position = "right")

print(pie_chart)

table(salariesIV$company_size == "M")

salaries_large <- subset(salariesIV, company_size == "L")

contingency_table <- table(salaries_large$remote_ratio)

contingency_df <- as.data.frame(contingency_table)
names(contingency_df) <- c("Tipo de Trabalho", "Count")

contingency_df$Percentage <- contingency_df$Count / sum(contingency_df$Count) * 100

contingency_df$Remote_Ratio_Label <- ifelse(contingency_df$"Tipo de Trabalho" == 0, "Presencial",
                                            ifelse(contingency_df$"Tipo de Trabalho" == 50, "Semi-Presencial", "Remoto"))

pie_chart <- ggplot(contingency_df, aes(x = "", y = Percentage, fill = factor(Remote_Ratio_Label))) +
  geom_bar(stat = "identity", width = 1) +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), position = position_stack(vjust = 0.5), size = 3) +
  coord_polar("y", start = 0) +
  labs(title = "Proporção de Tipo Trabalho para Empresas GRANDES",
       fill = "Tipo de Trabalho") +
  theme_void() +
  theme(legend.position = "right")

print(pie_chart)

table(salariesIV$company_size == "L")