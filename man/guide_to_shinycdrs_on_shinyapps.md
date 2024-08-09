
## Introduction

This is a guide to running shinycdrs 0.5.1 (August 2024) on a shinyapps.io server. This guide has not been tested and should be understood to be provisional.

The shinycdrs app does not function by way of a basic install. The reason for this is that the data necessary to run the app is derived from the [ICPSR database](https://doi.org/10.3886/E195447V2), which requires data users to agree to terms of use before downloading the data set. As such, we don't want a copy of the data on shinycdrs github repository. At some point in the future, we may submit a data package to CRAN with the full public DRS dataset, but this is not planned at the time of this writing.

## Steps

### Cloning shinycdrs

First, instead of using `devtools::install_github` to install the development version of shinycdrs (as you might do with other packages like 'cdrs'), we're instead going to **clone the repository** to a local directory on your machine.

Assuming your machine has git already installed, you can go to your command line interface, eg. the Terminal on macOS, and navigate to a directory you plan to use as the parent directory of the cloned repository. For example, on macOS, I might open Terminal and run `cd ~/Documents/github`.

Once you're in the directory, you can run the git command.

```
git clone https://github.com/ktomari/shinycdrs.git
```

### Running it on your local machine

Once you've cloned the shinycdrs repository, we need to get the app running on your local machine in order to publish it on shinyapps.io. Start by opening Rstudio and open the shinycdrs [R project](https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects). 

#### Installing dependencies

There are a number of packages that shinycdrs depends on. Fortunately, shinycdrs is set up to use the package 'renv' to manage most of this. If you don't have 'renv' already installed on your machine, open R and run `install.packages('renv')`. Now you can install all the necessary dependencies.

```
renv::restore()
```

#### Setting up the data

This is where we run into an idiosyncrasy of this package. The CDRS data set has to be placed directly into the cloned repository on your machine. Open up your file explorer and navigate to your shinycdrs repository on your machine. Find or create the `/data-raw` directory. Place a copy of the data, `DRS public data_2023_12_01.zip`, in this directory.

Next, run the [internal data](https://r-pkgs.org/data.html#sec-data-sysdata) making script `/data-raw/internal_data.R`. This script has a few packages it depends upon, so you may need to install those first. This script will create a `R/sysdata.rda` file (inside your local shinycdrs directory, in the `R` folder). This is the data shinycdrs (lazy) loads on start up. (You may now delete `DRS public data_2023_12_01.zip` if you so choose.)

#### Run the app.

You can now do a local install of shinycdrs using `devtools::install_local()` while inside the shinycdrs R project. Now, the function `shinycdrs::run_app()` should function properly. If you have not already set up your shinyapps.io credentials in Rstudio, then you should close the app. Otherwise skip to the section "[Final Push to shinyapps.io](#final-push-to-shinyapps.io)"

### Shinyapps Credentials

Assuming you already have shinyapps.io credentials, follow the regular shinyapps.io setup as discussed [here](https://docs.posit.co/shinyapps.io/guide/getting_started/#configure-rsconnect). Generally, this involves this code:

```
rsconnect::setAccountInfo(
  name="<ACCOUNT>", 
  token="<TOKEN>", 
  secret="<SECRET>"
  )
```

### Final Push to shinyapps.io

Run the shinycdrs app using `shinycdrs::run_app()`. In the new window this opens, there should be a button to publish the app in the top right corner. From there follow instructions. 

One suggestion I might make is that when you're offered the opportunity to create the url extension for this app, that you use something intuitive like "cdrs" or "deltasurvey2023", instead of the default "shinycdrs".