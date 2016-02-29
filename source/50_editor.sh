# Editing
nano_location=$(which nano)

if [ -x "nano_location" ]; then
  export EDITOR='nano'
