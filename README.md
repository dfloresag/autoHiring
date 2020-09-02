autoHiring
================

This is a bricks and mortar skeleton of an idea on how to automatise the
production of the documents needed in the hiring process.

The most simple way to generate a form consists in generating
[*parametrized
reports*](https://rmarkdown.rstudio.com/developer_parameterized_reports.html%23parameter_types%2F#Passing_Parameters)
by extracting the data from the excel file and passing it to the
`rmarkdown::render()` function as the `params` argument.

To do this, one can start by extracting the data from the properly
formatted Excel sheet. Here, we are only interested in the fields and
their. We have the data stored in the form `form_master.xlsx`.

We can extract the contents of the sheets `CdC` and `Proposition
d'engagement`.

``` r
extract_and_clean_sheet <- function(file_path, which_sheet){
  readxl::read_xlsx(path = file_path, skip = 1, 
                     sheet = which_sheet, 
                     col_names = FALSE) %>% 
    janitor::clean_names() %>% 
    pivot_wider(names_from = x1, values_from = x2) %>% 
    janitor::clean_names() %>% 
    as.list()
}

set_date_origin <-  function(x) {
  if(!is.na(x) ){
    if(x==0){
      x <- NA
    } else {
      x <- x %>% 
        as.numeric() %>% 
        as.Date(origin = "1899-12-30")
      lubridate::dmy(x)
    }
  }
}


render_cdc <- function(file_path){
  
  params_cdc <- 
    extract_and_clean_sheet(file_path=file_path, which_sheet = 2)
   
  params_cdc$entree_dans_loffice<- set_date_origin(params_cdc$entree_dans_loffice)
  params_cdc$a_partir_du <- set_date_origin(params_cdc$a_partir_du) 
  params_cdc$annee_de_naiss <- set_date_origin(params_cdc$annee_de_naiss)
  
  rmarkdown::render(
    input = "CDC/README.Rmd", 
    params = params_cdc, 
    output_format = c("pdf_document", "github_document")
  )
  params_cdc
}


render_pde <- function(file_path){
  
  params_pde <- 
    extract_and_clean_sheet(file_path=file_path, which_sheet =3)
  
  params_pde$engagement_du <- 
  set_date_origin(params_pde$engagement_du)
  
  params_pde$engagement_au <- 
  set_date_origin(params_pde$engagement_au)
  
  params_pde$date_de_naissance <- 
  set_date_origin(params_pde$date_de_naissance)
  
  params_pde$date_du_diplome <- 
  set_date_origin(params_pde$date_du_diplome)
  
  params_pde$date_du_doctorat <- 
  set_date_origin(params_pde$date_du_doctorat) 
  
  
  rmarkdown::render(
    input = "PDE/README.Rmd", 
    params = params_pde, 
    output_format = c("pdf_document", "github_document")
  )
  params_pde
}
```

``` r
file_path  <- "data/EPFL Extension School-Personal Details-MASTER-for Daniel-02SEP2020.xlsx"

render_cdc(file_path)
```

    ##   |                                                                              |                                                                      |   0%  |                                                                              |......................................................................| 100%
    ##    inline R code fragments
    ## 
    ## 
    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS README.utf8.md --to latex --from markdown+autolink_bare_uris+tex_math_single_backslash --output README.tex --self-contained --highlight-style tango --pdf-engine pdflatex --variable graphics --lua-filter /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmd/lua/pagebreak.lua --lua-filter /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmd/lua/latex-div.lua --variable 'geometry:margin=1in'

    ## Error: LaTeX failed to compile README.tex. See https://yihui.org/tinytex/r/#debugging for debugging tips. See README.log for more info.

``` r
render_pde(file_path)
```

    ## Warning: All formats failed to parse. No formats found.

    ##   |                                                                              |                                                                      |   0%  |                                                                              |......................................................................| 100%
    ##    inline R code fragments
    ## 
    ## 
    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS README.utf8.md --to latex --from markdown+autolink_bare_uris+tex_math_single_backslash --output README.tex --self-contained --highlight-style tango --pdf-engine pdflatex --variable graphics --lua-filter /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmd/lua/pagebreak.lua --lua-filter /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmd/lua/latex-div.lua --variable 'geometry:margin=1in' 
    ##   |                                                                              |                                                                      |   0%  |                                                                              |......................................................................| 100%
    ##    inline R code fragments
    ## 
    ## 
    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS README.utf8.md --to gfm --from markdown+autolink_bare_uris+tex_math_single_backslash --output README.md --standalone --template /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/default.md 
    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS README.md --to html4 --from gfm --output README.html --standalone --self-contained --highlight-style pygments --template /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/preview.html --variable 'github-markdown-css:/Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/github.css' --email-obfuscation none --metadata pagetitle=PREVIEW

    ## $fonction
    ## [1] "Support"
    ## 
    ## $engagement_du
    ## [1] NA
    ## 
    ## $engagement_au
    ## [1] NA
    ## 
    ## $support_type
    ## [1] "Technique"
    ## 
    ## $type_of_contract
    ## [1] "CDD"
    ## 
    ## $fianncement_percent
    ## [1] "1"
    ## 
    ## $financial_funds
    ## [1] "11262"
    ## 
    ## $nom
    ## [1] "SMITH"
    ## 
    ## $prenom
    ## [1] "Francesca"
    ## 
    ## $n_avs
    ## [1] "0"
    ## 
    ## $address_line_1
    ## [1] "0"
    ## 
    ## $address_line_2
    ## [1] "0"
    ## 
    ## $city
    ## [1] "0"
    ## 
    ## $canton
    ## [1] "0"
    ## 
    ## $country
    ## [1] "0"
    ## 
    ## $date_de_naissance
    ## [1] NA
    ## 
    ## $etat_civil
    ## [1] "0"
    ## 
    ## $nombre_denfants
    ## [1] "0"
    ## 
    ## $lieu_d_origine
    ## [1] "0"
    ## 
    ## $nationalite
    ## [1] "0"
    ## 
    ## $profession
    ## [1] "0"
    ## 
    ## $doctorat
    ## [1] "0"
    ## 
    ## $date_du_diplome
    ## [1] NA
    ## 
    ## $date_du_doctorat
    ## [1] NA
    ## 
    ## $taux_doccupation
    ## [1] "0"
    ## 
    ## $lieu_de_travail
    ## [1] "0"
    ## 
    ## $permis_de_travail
    ## [1] "0"
    ## 
    ## $cv
    ## [1] NA
    ## 
    ## $permis
    ## [1] NA
    ## 
    ## $id
    ## [1] NA
    ## 
    ## $avs_card
    ## [1] NA
    ## 
    ## $diplomes
    ## [1] "YES"
    ## 
    ## $cd_c
    ## [1] NA
    ## 
    ## $cdt
    ## [1] NA

The second step consists in storing the extracted values in two
parameters lists.

``` r
params_cdc <- 
  extract_and_clean_sheet(path_file=path_file, which_sheet = 2)
```

    ## Error in extract_and_clean_sheet(path_file = path_file, which_sheet = 2): unused argument (path_file = path_file)

``` r
params_pde <- 
  extract_and_clean_sheet(path_file=path_file, which_sheet = 3)
```

    ## Error in extract_and_clean_sheet(path_file = path_file, which_sheet = 3): unused argument (path_file = path_file)

There’s some tweaking to be done with the dates as, when imported from
Excel, they provide the ‘days since’ an origin set in “1899-12-30”.
(Just to say that there has to be a more elegant way to do this.)

Then, the third step, consists in rendering the CDC and PDE files with
the previous list of parameters using `rmarkdown::render()` with `params
= params_list`, as in:

``` r
rmarkdown::render(
  input = "PDE/README.Rmd",
  params = params_pde, 
  output_format = c("pdf_document", "github_document")
  )
```

    ## Error in knit_params_get(input_lines, params): object 'params_pde' not found

  - The YAML of the generating documents contain a `params` argument
    with initial values set to `NA`.

<!-- end list -->

``` yaml
---
title: "Proposition d'Engagement"
output: github_document
params:
  last_name         : NA
  first_name        : NA
  avs_number        : NA
  date_of_birth     : NA
  ...
  ...
  
---
```

  - The [body of the generating document](PDE/README.Rmd) contains
    *inline* placeholders for the values contained in the `params` list,
    e.g. `params$first_name`, etc. Rendering them on their own produces
    a document with `NA`’s instead of the data, but through the `params`
    argument we can fill them in. Check [this example](PDE/README.md)
    based on [this form](data/form_master.xlsx)

The next step consists in small function and testing all the scenarios
with a variety of forms.
