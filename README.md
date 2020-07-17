# presupuestochile

## Overview
This package has been designed to download and consolidate JSON files from the webpage 'presupuestoabierto.gob.cl'.

## Installation
``` r
install.packages("devtools")
devtools::install_github("hugomansilla/presupuestochile")
```
## Usage
``` r
# load library 
library(presupuestochile)

# config parameters
ruts <- c("70005600-7","81591900-9","70892200-5","72109700-5")
years <- c(2016,2017,2018,2019,2020)

# call function 
descargar_datos_receptor(ruts,years)
```
## GIT
To download the latest source from the Git server do this:

``` r
git clone https://github.com/hugomansilla/presupuestochile.git
```
(you'll get a directory named presupuestochile, filled with the source code)

## Contact
If you have problems, questions, ideas or suggestions, please contact me at this email: hugomansilla@gmail.com
