#Rotina para coletar e apresentar em gr�ficos algumas s�ries do banco central
#Feito por: Felipe Simpl�cio Ferreira
#�ltima atualiza��o: 10/11/2020

#Definindo diret�rios a serem utilizados

getwd()
setwd("C:/Users/User/Documents")

#Poss�veis pacotes que podem ser utilizados
#library(rio) #Para exportar em formato xlsx

#Criando fun��o para coleta de s�ries
coleta_dados_sgs = function(series,datainicial="01/03/2011", datafinal = format(Sys.time(), "%d/%m/%Y")){
  #Argumentos: vetor de s�ries, datainicial que pode ser manualmente alterada e datafinal que automaticamente usa a data de hoje
  #Cria estrutura de repeti��o para percorrer vetor com c�digos de s�ries e depois juntar todas em um �nico dataframe
  for (i in 1:length(series)){
    dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",series[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
    dados[,-1] = as.numeric(gsub(",",".",dados[,-1])) #As colunas do dataframe em objetos num�ricos exceto a da data
    nome_coluna = series[i] #Nomeia cada coluna do dataframe com o c�digo da s�rie
    colnames(dados) = c('data', nome_coluna)
    nome_arquivo = paste("dados", i, sep = "") #Nomeia os v�rios arquivos intermedi�rios que s�o criados com cada s�rie
    assign(nome_arquivo, dados)
    
    if(i==1)
      base = dados1 #Primeira repeti��o cria o dataframe
    else
      base = merge(base, dados, by = "data", all = T) #Demais repeti��es agregam colunas ao dataframe criado
    print(paste(i, length(series), sep = '/')) #Printa o progresso da repeti��o
  }
  
  base$data = as.Date(base$data, "%d/%m/%Y") #Transforma coluna de data no formato de data
  base = base[order(base$data),] #Ordena o dataframe de acordo com a data
  return(base)
}

#Definida a fun��o, podemos criar objetos para guardar os resultados
serie = c(1,7) #Vetor com c�digo para o d�lar e o Ibovespa, respectivamente
ex = coleta_dados_sgs(serie) #Criando objeto em que ficam guardados as s�ries

write.csv2(ex, "Exemplo.csv", row.names = F) #Salvando arquivo csv em padr�o brasileiro
#export(ex, "Exemplo.xlsx") #Salvando em formato xlsx