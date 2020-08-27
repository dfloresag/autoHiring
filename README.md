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

(There’s some tweaking to be done with de dates. I’ll find a more
elegant way to do this)

``` r
params_list$date_of_birth <- 
  params_list$date_of_birth %>% 
  as.numeric()%>% as.Date(origin = "1904-01-01")

params_list$date_of_ph_d <- 
  params_list$date_of_ph_d %>% 
  as.numeric() %>% as.Date(origin = "1904-01-01")

params_list$date_of_diploma <- 
  params_list$date_of_diploma%>% 
  as.numeric() %>% as.Date(origin = "1904-01-01")
```

Then, the third step, consists in rendering the CDC and PDE files with
the previous list of parameters using `rmarkdown::render()` with `params
= params_list`, as in:

``` r
rmarkdown::render(
  input = "CDC/README.Rmd", 
  params = params_list
  )

rmarkdown::render(
  input = "PDE/README.Rmd",
  params = params_list
  )
```

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
