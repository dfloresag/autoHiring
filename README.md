autoHiring
================

This is a bricks and mortar skeleton

``` r
library(dplyr)
library(tidyr)
library(readxl)
library(stringr)
library(anytime)
```

``` r
person <- readxl::read_excel(path = "data/form1.xlsx", skip = 3) %>% 
  select(`FIELD`,`YOUR DETAILS`) %>% 
  pivot_wider(names_from = `FIELD`, values_from = `YOUR DETAILS`)
person
```

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
