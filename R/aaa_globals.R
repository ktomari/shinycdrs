# aaa_globals.R

# This script initializes global objects and environments used throughout
# the shinycdrs package. It is sourced early in the app's lifecycle to ensure
# that these objects are available wherever needed within the app.

# `env_dat` is a custom environment used to store and manage data
# centrally within the app. This approach helps isolate app data from the
# global environment, reducing the risk of conflicts and making the data
# management more modular and maintainable.

# Initialize the custom environment for storing app data
env_dat <- new.env(parent = emptyenv())
