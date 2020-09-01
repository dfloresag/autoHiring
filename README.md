autoHiring
================

This is a bricks and mortar skeleton of an idea on how to automatise the
production of the documents needed in the hiring process.

The most simple way to generate a form consists in generating a
[*parametrized
report*](https://rmarkdown.rstudio.com/developer_parameterized_reports.html%23parameter_types%2F#Passing_Parameters)
by extracting the data from the excel file and passing it to the
`rmarkdown::render()` function as the `params` argument.

To do this, one can start by extracting the data from the properly
formatted Excel sheet. Here, we are only interested in the fields and
their. We have the data stored in the form `form_master.xlsx`.

We can extract the contents of the sheets `CdC` and `Proposition
d'engagement`

``` r
cdc <- 
  readxl::read_excel(path = "data/form_master.xlsx", skip = 1, sheet = 2, col_names = FALSE) %>% 
  janitor::clean_names() %>% 
  pivot_wider(names_from = x1, values_from = x2) %>% 
  janitor::clean_names()

pde <- 
  readxl::read_excel(path = "data/form_master.xlsx", skip = 1, sheet = 3, col_names = FALSE) %>% 
  janitor::clean_names() %>% 
  pivot_wider(names_from = x1, values_from = x2) %>% 
  janitor::clean_names()
```

The second step consists in storing the extracted values in a `list`.

``` r
params_cdc <-  as.list(cdc)
params_pde <-  as.list(pde)
```

There’s some tweaking to be done with the dates as, when imported from
Excel, they provide the ‘days since’ an origin set in “1899-12-30”.
(Just to say that there has to be a more elegant way to do this.)

``` r
set_date_origin <-  function(x) {
  if(!is.na(x) ){
    if(x==0){
      x <- NA
    } else {
      x <- x %>% 
        as.numeric() %>% 
        as.Date(origin = "1899-12-30")
    }
  }
  x
}

params_cdc$entree_dans_loffice<- 
  set_date_origin(params_cdc$entree_dans_loffice)

params_cdc$a_partir_du <- 
  set_date_origin(params_cdc$a_partir_du) 
  
params_cdc$annee_de_naiss <- 
  set_date_origin(params_cdc$annee_de_naiss)
  
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
```

Then, the third step, consists in rendering the CDC and PDE files with
the previous list of parameters using `rmarkdown::render()` with `params
= params_list`, as in:

``` r
rmarkdown::render(
  input = "CDC/README.Rmd", 
  params = params_cdc
  )
```

    ## 
    ## 
    ## processing file: README.Rmd

    ##   |                                                                              |                                                                      |   0%  |                                                                              |......................................................................| 100%
    ##    inline R code fragments

    ## output file: README.knit.md

    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS README.utf8.md --to gfm --from markdown+autolink_bare_uris+tex_math_single_backslash --output README.md --standalone --template /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/default.md 
    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS README.md --to html4 --from gfm --output README.html --standalone --self-contained --highlight-style pygments --template /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/preview.html --variable 'github-markdown-css:/Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/github.css' --email-obfuscation none --metadata pagetitle=PREVIEW

    ## 
    ## Preview created: /var/folders/0r/lz5zqtk16jzfphyl_nphc2hr0000gp/T//RtmpEjZjkU/preview-31e0401d465b.html

    ## 
    ## Output created: README.md

``` r
rmarkdown::render(
  input = "PDE/README.Rmd",
  params = params_pde
  )
```

    ## 
    ## 
    ## processing file: README.Rmd

    ##   |                                                                              |                                                                      |   0%  |                                                                              |......................................................................| 100%
    ##    inline R code fragments

    ## output file: README.knit.md

    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS README.utf8.md --to gfm --from markdown+autolink_bare_uris+tex_math_single_backslash --output README.md --standalone --template /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/default.md 
    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS README.md --to html4 --from gfm --output README.html --standalone --self-contained --highlight-style pygments --template /Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/preview.html --variable 'github-markdown-css:/Library/Frameworks/R.framework/Versions/4.0/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/github.css' --email-obfuscation none --metadata pagetitle=PREVIEW

    ## 
    ## Preview created: /var/folders/0r/lz5zqtk16jzfphyl_nphc2hr0000gp/T//RtmpEjZjkU/preview-31e041f6213f.html
    ## 
    ## Output created: README.md

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
    based on [this form](data/form2.xlsx)

The next step consists in small function and testing all the scenarios
with a variety of forms.

# Second Approach: One master file - Three sheets

To fill the missing fields, one can think of constructing.

``` r
person <- 
  readxl::read_excel(path = "data/form_master.xlsx", skip = 3, sheet = 1) %>% 
  janitor::clean_names() %>% 
  select(x1,your_details) %>%
  pivot_wider(names_from = x1, values_from = your_details) %>% 
  janitor::clean_names()
```
