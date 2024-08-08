# aaa_globals.R

# This script initializes global objects and environments used throughout
# the shinycdrs package. It is sourced early in the app's lifecycle to ensure
# that these objects are available wherever needed within the app.

# `env_dat` is a custom environment used to store and manage data
# centrally within the app. This approach helps isolate app data from the
# global environment, reducing the risk of conflicts and making the data
# management more modular and maintainable.

# If you're looking for other startup scripts, see R/zzz.R

# Initialize the custom environment for storing app data
env_dat <- new.env(parent = emptyenv())

# This code was used to install google fonts
# gfonts::setup_font(id = "roboto-slab", output_dir = "inst/app/www")
# gfonts::setup_font(id = "montserrat", output_dir = "inst/app/www")
