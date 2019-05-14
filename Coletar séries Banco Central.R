#Rotina para coletar e apresentar em gráficos algumas séries do banco central
#Feito por: Felipe Simplício Ferreira
#última atualização: 02/01/2019


#Definindo diretórios a serem utilizados

getwd()
setwd("C:/Users/User/Documents")

#Carregando pacotes que serão utilizados
#library("dplyr")

#Definindo data incial  e final (padrão usar a data de hoje) das séries que serão coletadas
datainicial = "02/01/1990"
datafinal = format(Sys.time(), "%d/%m/%Y")

#Definindo códigos das séries a serem coletadas
serie = c("1", "7", "7802")

#Repetição para coletar e juntar séries em um arquivo
for (i in 1:length(serie)){
  dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
  dados$data = as.Date(dados$data, "%d/%m/%Y")
  nome = paste("serie", i, sep = "")
  assign(nome, dados)
  if(i==1)
    base = serie1
  else
    base = merge(base, dados, by = "data", all = T)
}

#Nomeando colunas do dataframe com todas as séries
names(base) = c("Data", "Dólar", "Ibovespa", "Swap DI")

#Removendo resíduos
rm(dados)
rm(list=objects(pattern="^serie"))
