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
formatted Excel sheet. Here, we are only interested in the sheets 2 and
3, which contain the things .

``` r
extract_and_clean_sheet <- function(file_path, which_sheet){
  readxl::read_xlsx(path = file_path, skip = 1, 
                     sheet = which_sheet, 
                     col_names = FALSE) %>% 
    janitor::clean_names() %>% 
    pivot_wider(names_from = x1, values_from = x2) %>% 
    janitor::clean_names()
}
```

There’s some tweaking to be done with the dates as, when imported from
Excel, they provide the ‘days since’ an origin set in “1899-12-30”.
(Just to say that there has to be a more elegant way to do this.) For
this, we create the function `set_date_origins()`.

``` r
set_date_origin <-  function(x) {
  if(!is.na(x) ){
    if(x==0){
      x <- NA
    } else {
      x <- x %>% 
        as.numeric() %>% 
        as.Date(origin = "1899-12-30") %>% 
        format("%d %b %Y")
      x
    }
  }
}
```

With these elements, we construct the function that renders the
documents in two formats: `.pdf` and `.md`.

### `render_cdc()`

``` r
render_cdc <- function(file_path){
  
  params_cdc <- 
    extract_and_clean_sheet(file_path=file_path, which_sheet = 2) %>% 
    mutate(
      entree_dans_loffice = set_date_origin(entree_dans_loffice), 
      a_partir_du = set_date_origin(a_partir_du), 
      annee_de_naiss = set_date_origin(annee_de_naiss)
      ) %>%
    as.list()
  
  
  rmarkdown::render(
    input = "CDC/README.Rmd", 
    params = params_cdc, 
    output_format = c("pdf_document", "github_document")
  )
  
  rmarkdown::render(
    input = "CDC/index.Rmd", 
    params = params_cdc
    )
  
  # params_cdc
}
```

### `render_pde()`

``` r
render_pde <- function(file_path){
  
  params_pde <- 
    extract_and_clean_sheet(file_path=file_path, which_sheet =3) %>%
    mutate(
      engagement_du     = set_date_origin(engagement_du),
      engagement_au     = set_date_origin(engagement_au), 
      date_de_naissance = set_date_origin(date_de_naissance), 
      date_du_diplome   = set_date_origin(date_du_diplome),
      date_du_doctorat  = set_date_origin(date_du_doctorat) 
    ) %>% 
    as.list()
  
  rmarkdown::render(
    input = "PDE/README.Rmd", 
    params = params_pde, 
    output_format = c("pdf_document", "github_document")
  )
  rmarkdown::render(
    input = "PDE/index.Rmd", 
    params = params_pde
    )
  # params_pde
}
```

  - We set the `file_path`

<!-- end list -->

``` r
file_path  <- "data/EPFL Extension School-Personal Details-MASTER-for Daniel-02SEP2020.xlsx"
```

  - Render the *Cahier des charges* with `render_cdc()`

<!-- end list -->

``` r
render_cdc(file_path)
```

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

    ## Error in parse_block(g[-1], g[1], params.src, markdown_mode): Duplicate chunk label 'unnamed-chunk-1', which has been used for the chunk:
    ## extract_and_clean_sheet <- function(file_path, which_sheet){
    ##   readxl::read_xlsx(path = file_path, skip = 1, 
    ##                      sheet = which_sheet, 
    ##                      col_names = FALSE) %>% 
    ##     janitor::clean_names() %>% 
    ##     pivot_wider(names_from = x1, values_from = x2) %>% 
    ##     janitor::clean_names()
    ## }

  - And the *Proposition d’Engagement* with `render_pde()`

<!-- end list -->

``` r
render_pde(file_path)
```

    ## Warning: Problem with `mutate()` input `date_du_doctorat`.
    ## ℹ NAs introduced by coercion
    ## ℹ Input `date_du_doctorat` is `set_date_origin(date_du_doctorat)`.

    ## Warning in function_list[[i]](value): NAs introduced by coercion

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
    ##   |                                                                              |                                                                      |   0%  |                                                                              |......................................................................| 100%
    ##    inline R code fragments
    ## 
    ## 
    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS index.utf8.md --to html4 --from markdown-hard_line_breaks+superscript+tex_math_dollars+raw_html+markdown_in_html_blocks-implicit_figures --output index.html -H /var/folders/0r/lz5zqtk16jzfphyl_nphc2hr0000gp/T//Rtmp3Q82QM/knitr_bootstrap_full.html

### A word on the principle

  - The basic principle consists in having a YAML of the generating
    documents contain a `params` argument with initial values set to
    `NA`.

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
