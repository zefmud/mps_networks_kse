# mps_networks_kse
Shiny app visualizing mps networks for the lecture in Kyiv School of Economics

### Libraries used
* shiny
* dplyr
* tidyr
* networkD3
* igraph
* stringr

###To run application in RStudio:
shiny::runGitHub("mps_networks_kse", "zefmud")
or clone repository and open app.R in RStudio.

### To update data used in visualization
1. Download files [bills-skl8.json](https://data.rada.gov.ua/ogd/zpr/skl8/bills-skl8.json) and [mp-posts.json](https://data.rada.gov.ua/open/data/mps-posts_skl8) in the app folder.
2. Run script create_data.R 

### To display presentation correctly
...you need to have bills-skl8.json and mp-posts.json in the same folder and knit KSE_groups_presentation.Rmd in RStudio.
But you should be able to see the chunks of code in RStudio or in notepad without any additional efforts.

### Contact me if you have any questions
paul.myronov@gmail.com