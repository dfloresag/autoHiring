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
  readxl::read_excel(path = "data/form1.xlsx", skip = 3) %>% 
  select(`FIELD`,`YOUR DETAILS`) %>% 
  pivot_wider(names_from = `FIELD`, values_from = `YOUR DETAILS`)
```

The second step consists in storing the extracted values in a `list`.

``` r
params_list  <-  list(
  Last_Name         = person$`Last Name`,
  First_Name        = person$`First Name`,
  AVS_Number        = person$`AVS Number`,
  Date_of_Birth     = as.Date(as.numeric(person$`Date of Birth`), 
                              origin = "1904-01-01"),
  Address_line_1    = person$`Address line 1`,
  Address_line_2    = person$`Address line 2`,
  City              = person$City,
  Canton            = person$Canton,
  Country           = person$Country,
  Marital_status    = person$`Marital status`,
  Count_of_children = person$`Count of children`,
  PhD               = person$PhD,
  Date_of_PhD       = as.Date(as.numeric(person$`Date of PhD`), 
                              origin = "1900-01-01"),
  Highest_Degree    = person$`Highest Degree`,
  Date_of_Diploma   = as.Date(as.numeric(person$`Date of Diploma`), 
                              origin = "1900-01-01"),
  Profession        = person$`Profession/Academic Focus`,
  Nationality       = person$Nationality,
  Swiss_Origin      = person$Origin,
  Work_permit       = person$`Work Permit`,
  Type_of_permit    = person$`Type of Permit`,
  Start_date        = as.Date(as.numeric(person$`Start date availability`), 
                          origin = "1900-01-01"),
  Role              = person$Role,
  Team              = person$Team,
  Hiring_Percentage = person$`Hiring Percentage` ,
  Place_of_Work     = person$`Place of work`
  )
```

Profession\_Academic\_Focus, Type\_of\_work\_permit,
Start\_date\_availability Then, the third step, consists in rendering
the CDC and PDE files with the previous list of parameters using
`rmarkdown::render()` with `params = params_list`, as in:

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
  Last_Name         : NA
  First_Name        : NA
  AVS_Number        : NA
  Date_of_Birth     : NA
  ...
  ...
  
---
```

  - The [body of the generating document](PDE/README.Rmd) contains
    *inline* placeholders for the values contained in the `params` list,
    e.g. `params$First_Name`, etc. Rendering them on their own produces
    a document with `NA`’s instead of the data, but through the `params`
    argument we can fill them in. Check [this example](PDE/README.md)
    based on [this form](data/form1.xlsx)

The next step consists in small function and testing all the scenarios
with a variety of forms.
