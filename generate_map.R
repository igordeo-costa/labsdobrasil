# Pacotes necessários
require(rgdal)
require(leaflet)
require(dplyr)
require(tidyr)
require(RColorBrewer)
require(htmlwidgets)
require(shiny)

# Diretório de trabalho
setwd(getwd())

# Importanto arquivos de dados do IBGE com as shapes
# Disponíveis aqui: https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html?=&t=downloads
shp <- readOGR("./map-data/BR_UF_2020.shp", stringsAsFactors=FALSE, encoding="UTF-8")

# Ler os arquivos com os dados dos laboratórios
labs <- read.csv("./data/LabsTable.csv")

# Mesclar os shapes com os arquivos dos laboratórios by UF
labs <- merge(shp, labs, by.x = "SIGLA_UF", by.y = "UF", duplicateGeoms = TRUE)

# Plotar o mapa
labs_map <- leaflet(data = labs) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addMarkers(lat = labs@data[["lat"]],
             lng = labs@data[["lng"]],
             popup = paste(labs@data[["Sigla"]], "-",
                           labs@data[["Lab"]], "-",
                           labs@data[["Universidade"]], "-",
                           labs@data[["Coordenador"]], "-",
                           labs@data[["Link"]]),
             clusterOptions = markerClusterOptions(freezeAtZoom = 12))

# Ver o mapa
labs_map

# Salvar o mapa como HTML
saveWidget(labs_map, "./LabsDoBrasil.html")
