## 05.28.2019
## created by susana wilson hawken
## R shiny app that allows user to examine protein sequences, intrinsically disordered 
## regions of proteins, composition of any sequence, and mutational data for any 
## protein depending on datasource

## load dplyr library
library(dplyr)
## load shiny library
library(shiny)

#------------------------------------------------------------------------------------------------------#

#                 Read in and clean dataset for entire proteome sequences,                             # 
#                 entire proteome intrinsically disordered regions coordinates,                        #
#                 and map protein ids from entire proteome sequences to IDRs                           #
#                 dataset                                                                              #

#------------------------------------------------------------------------------------------------------#

# set working directory to local path
#setwd("Documents/Grad_folder2018/young_lab_rotation/Data/IDR-project/")

# read in proteome-wide fasta sequence data and list of proteome-wide IDR coordinates
proteome_seqs <- read.csv("entire.proteome.fastafile", sep = "\t", header = TRUE)
idr_coords <- read.csv("dis_consensus_assignment.human.Ensembl.known.075.bed", sep = "\t", header = FALSE)

print("done reading...")

# convert all datasets to dataframes
# rename important columns -- especially ID names of proteins that shoult match between datasets

proteome_seqs <-  as.data.frame(proteome_seqs) %>%
  rename(.,protein_id = ensembl) %>% 
  rename(.,gene_name = genenames) %>% 
  rename(.,sequences = sequences)
  
idr_coords <-  as.data.frame(idr_coords) %>%
  rename(.,protein_id = V1) %>%
  rename(.,idr_start = V2) %>%
  rename(.,idr_end = V3) %>%
  rename(.,hgnc_gene_name = V5)

 idr_coords <- idr_coords[,-4]

# Merge the two datasets
 
data_clean <- left_join(proteome_seqs, idr_coords, by = "protein_id")


#------------------------------------------------------------------------------------------------------#

#                Build Shiny App functionality to display protein sequneces                            #
#                                                                                                      #                

#------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------#

#                               UI                                  #
#                                                                   #

#-------------------------------------------------------------------#


ui <- fluidPage(
  
  titlePanel("Protein Sequence Analysis"),
  
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput(inputId = "dataset",
                  label = "Choose an IDR dataset",
                  choices = c("D2P2")),
      
      numericInput(inputId = "obs",
                   label = "Number of observations to view:",
                   value = 10)
    ),
    
    mainPanel = (
      
      tableOutput("view")
      
    )
    
  )
  
)


server <- function(input,output){
  
  datasetInput <- reactive({
    switch(input$dataset,
           "D2P2" = data_clean)
  })
  
  output$view <- renderTable({
    head(datasetInput(),n = input$obs)
  })
  
}

shinyApp(ui=ui, server=server)


