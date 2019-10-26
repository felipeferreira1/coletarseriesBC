#Rotina para coletar e apresentar em gráficos algumas séries do banco central
#Feito por: Felipe Simplício Ferreira
#última atualização: 26/10/2019

#Definindo diretórios a serem utilizados

getwd()
setwd("C:/Users/User/Documents")

#Criando função para coleta de séries
coleta_dados = function(series,datainicial="01/03/2011", datafinal = format(Sys.time(), "%d/%m/%Y")){
  #Argumentos: vetor de séries, datainicial que pode ser manualmente alterada e datafinal que automaticamente usa a data de hoje
  #Cria estrutura de repetição para percorrer vetor com códigos de séries e depois juntar todas em um único dataframe
  for (i in 1:length(series)){
    dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",series[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
    nome_coluna = series[i] #Nomeia cada coluna do dataframe com o código da série
    colnames(dados) = c('data', nome_coluna)
    nome_arquivo = paste("dados", i, sep = "") #Nomeia os vários arquivos intermediários que são criados com cada série
    assign(nome_arquivo, dados)
    
    if(i==1)
      base = dados1 #Primeira repetição cria o dataframe
    else
      base = merge(base, dados, by = "data", all = T) #Demais repetições agregam colunas ao dataframe criado
    print(paste(i, length(serie), sep = '/')) #Printa o progresso da repetição
  }
  
  base$data = as.Date(base$data, "%d/%m/%Y") #Transforma coluna de data no formato de data
  base = base[order(base$data),] #Ordena o dataframe de acordo com a data
  base[,-1]=apply(base[,-1],2,function(x)as.numeric(gsub(",",".",x))) #Transforma o resto do dataframe em objetos numéricos
  rm(list=objects(pattern="^nome")) #Exclui objetos intermediários criados
  rm(list=objects(pattern="^dados")) #Exclui objetos intermediários criados
  return(base)
}

#Definida a função, podemos criar objetos para guardar os resultados
serie = c(1,7) #Vetor com código para o dólar e o Ibovespa, respectivamente
ex = coleta_dados(serie) #Criando objeto em que ficam guardados as séries
