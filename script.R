# Pacotes necessários
require(rgdal)
require(leaflet)
require(dplyr)
require(tidyr)
require(RColorBrewer)
require(htmlwidgets)

# Diretório de trabalho
setwd("/home/dados/LabsBrasil/BR_UF_2020")

# Importanto arquivos de dados do IBGE com as shapes
# Disponíveis aqui: https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html?=&t=downloads
shp <- readOGR("BR_UF_2020.shp", stringsAsFactors=FALSE, encoding="UTF-8")

# Ler os arquivos com os dados dos laboratórios
labs <- read.csv("/home/dados/LabsBrasil/BR_UF_2020/Labs.csv")

# Mesclar os shapes com os arquivos dos laboratórios by UF
teste <- merge(shp, labs, by.x = "SIGLA_UF", by.y = "UF", duplicateGeoms = TRUE)

# Definir uma paleta de cores
pal <- colorBin("Greens", domain = NULL, n=5)

# Plotar o mapa
x <- leaflet(data = teste) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(teste$UF), 
              fillOpacity = 0.1, 
              color = "#bae4b3", 
              weight = 1) %>%
  addMarkers(lat = teste@data[["lat"]],
             lng = teste@data[["lng"]],
             popup = teste@data[["Lab"]],
             clusterOptions = markerClusterOptions(freezeAtZoom = 10))

# Ver o mapa
x

# Salvar o mapa como HTML
saveWidget(x, "LabsDoBrasil.html")
