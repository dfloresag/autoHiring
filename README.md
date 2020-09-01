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
their.

``` r
person <- 
  readxl::read_excel(path = "data/form2.xlsx", skip = 3) %>% 
  select(`FIELD`,`YOUR DETAILS`) %>% 
  janitor::clean_names() %>% 
  pivot_wider(names_from = field, values_from = your_details) %>% 
  janitor::clean_names()
```

The second step consists in storing the extracted values in a `list`.

``` r
params_list <-  as.list(person)
```

There’s some tweaking to be done with the dates as, when imported from
Excel, they provide the ‘days since’ an origin set in “1899-12-30”.
(Just to say that there has to be a more elegant way to do this.)

``` r
params_list$date_of_birth <- 
  params_list$date_of_birth %>% 
  as.numeric()%>% as.Date(origin = "1899-12-30")

params_list$date_of_ph_d <- 
  params_list$date_of_ph_d %>% 
  as.numeric() %>% as.Date(origin = "1899-12-30")

params_list$date_of_diploma <- 
  params_list$date_of_diploma%>% 
  as.numeric() %>% as.Date(origin = "1899-12-30")
```

Then, the third step, consists in rendering the CDC and PDE files with
the previous list of parameters using `rmarkdown::render()` with `params
= params_list`, as in:

``` r
rmarkdown::render(
  input = "CDC/README.Rmd", 
  params = params_list
  )
```

    ## 
    ## 
    ## processing file: README.Rmd

    ## Error in parse_block(g[-1], g[1], params.src, markdown_mode): Duplicate chunk label 'setup', which has been used for the chunk:
    ## knitr::opts_chunk$set(echo = TRUE, 
    ##                       error =TRUE, 
    ##                       eval = TRUE)

``` r
rmarkdown::render(
  input = "PDE/README.Rmd",
  params = params_list
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
    ## Preview created: /var/folders/0r/lz5zqtk16jzfphyl_nphc2hr0000gp/T//RtmpEjZjkU/preview-1ef65621fe81.html

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

## Using the Master document

``` r
person <- 
  readxl::read_excel(path = "data/form_master.xlsx", skip = 3, sheet = 1) %>% 
  janitor::clean_names() %>% 
  select(x1,your_details) %>%
  pivot_wider(names_from = x1, values_from = your_details) %>% 
  janitor::clean_names()

person
```

    ## # A tibble: 1 x 25
    ##   last_name first_name avs_number_leav… date_of_birth address_line_1
    ##   <lgl>     <lgl>      <lgl>            <lgl>         <lgl>         
    ## 1 NA        NA         NA               NA            NA            
    ## # … with 20 more variables: address_line_2 <lgl>, city <lgl>, canton <lgl>,
    ## #   country <lgl>, marital_status <lgl>, count_of_children_if_any <lgl>,
    ## #   ph_d <lgl>, date_of_ph_d <lgl>,
    ## #   if_you_do_not_have_a_ph_d_please_specify_your_highest_academic_credential <lgl>,
    ## #   date_of_diploma <lgl>, profession_academic_focus <lgl>, nationality <lgl>,
    ## #   origin_if_you_are_swiss <lgl>,
    ## #   if_you_are_not_swiss_do_you_have_a_work_permit <lgl>,
    ## #   if_yes_what_is_your_type_of_work_permit_b_c_b_avec_activite_l <lgl>,
    ## #   start_date_availability_1st_or_15th_of_the_month <lgl>, role <lgl>,
    ## #   team <lgl>, percent_worked <lgl>, place_of_work <lgl>

``` r
details_cdc <- 
  readxl::read_excel(path = "data/form_master.xlsx", skip = 1, sheet = 2, col_names = FALSE) %>% 
  janitor::clean_names() %>% 
  pivot_wider(names_from = x1, values_from = x2) %>% 
  janitor::clean_names()
details_cdc
```

    ## # A tibble: 1 x 15
    ##   nom   prenom annee_de_naiss prof_apprise_di… entree_dans_lof… office_federal
    ##   <chr> <chr>  <chr>          <chr>            <chr>            <chr>         
    ## 1 0     0      0              0                0                EPFL          
    ## # … with 9 more variables: secteur_unite <chr>, fonction <chr>, classe <chr>,
    ## #   a_partir_du <chr>, rapports_de_service_contract_duration <chr>,
    ## #   activites <chr>, percent <chr>, maniere_de_traiter_les_affaires <chr>,
    ## #   superieur_e_direct_e <chr>

``` r
details_pde <- 
  readxl::read_excel(path = "data/form_master.xlsx", skip = 1, sheet = 3, col_names = FALSE) %>% 
  janitor::clean_names() %>% 
  pivot_wider(names_from = x1, values_from = x2) %>% 
  janitor::clean_names()

details_pde
```

    ## # A tibble: 1 x 27
    ##   fonction engagement_du engagement_au support_type type_of_contract
    ##   <chr>    <chr>         <chr>         <chr>        <chr>           
    ## 1 Support  0             366           Technique    CDD             
    ## # … with 22 more variables: fianncement_percent <chr>, financial_funds <chr>,
    ## #   nom <chr>, prenom <chr>, n_avs <chr>, address_line_1 <chr>,
    ## #   address_line_2 <chr>, city <chr>, canton <chr>, country <chr>,
    ## #   date_de_naissance <chr>, etat_civil <chr>, nombre_denfants <chr>,
    ## #   lieu_d_origine <chr>, nationalite <chr>, profession <chr>, doctorat <chr>,
    ## #   date_du_diplome <chr>, date_du_doctorat <chr>, taux_doccupation <chr>,
    ## #   lieu_de_travail <chr>, permis_de_travail <chr>
