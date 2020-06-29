#!/bin/bash
#    Purpose: Bulk-download of hourly weather station data from ECC Canada
# Background: Based on instructions provided by Environment and Climate Change 
#             Canada historical weather data search
#        Ref: https://climate.weather.gc.ca/historical_data/search_historic_data_e.html
#   See also: https://drive.google.com/drive/folders/1WJCDEU34c60IfOnG4rv5EPZ4IhhW9vZH/
#    Caveats: * Choose stations carefully. Not all weather stations report type 
#               of weather (Rain, sunny, cloudy, etc)
#             * Obtain the value of StationID from the source of the Historical 
#               Data page, or from its URL, if you're patient enough to scroll 
#               through that string
#             * This script passes the timeframe argument (=1) needed for 
#               hourly data; review comments on Google Drive documents for 
#               other download ranges


ECC_URL=https://climate.weather.gc.ca/climate_data/bulk_data_e.html

usage() {
  cat <<- EOF
  Usage: $0 <start_year> <end_year> <station_id> <target>
  <start|end_year>: Years for which to download data (inclusive)
  <station_id>: ECC Canada identifier for weather station; can be obtained
                from the HTML source of the Historical Data lookup page
                (search name="stationID")
  <target>: Location of downloaded files.  Absolute or relative paths.

  ERROR: $1

EOF
  exit 1
}

validate() {
  # Validations not meant to be comprehensive, just protecting myself from the
  # the _really_ stupid typos
  min_year=1840
  max_year=`date +%Y`
  not_num='[^0-9]+'

  #Year checks

  if [[ ${start_year} =~ $not_num || ${end_year} =~ $not_num ]]
  then
    usage "Start year (${start_year}) or end year (${end_year}) contains\
     non-digits"
  elif [[ ${start_year} -lt ${min_year} || ${end_year} -gt ${max_year} ]]
  then
    usage "Date range specified not between ${min_year} and ${max_year}"
  elif [[ ${start_year} -gt ${end_year} ]] 
  then
    usage "Start year (${start_year}) must not be after end year (${end_year})"
  fi

  # Station ID checks
  # Not going nuts here, just confirming the ID is actually a number. 
  # Validity of ID not in scope.

  if [[ ${station_id} =~ $not_num ]]
  then
    usage "The station ID provided (${station_id}) is non-numeric"
  fi

  # Target directory checks
  # We are not going to be clever enough to create non-existent directories
  # This is a silly helper script, not a robust utility.
  if [[ ! -d ${target} ]]
  then
    usage "Target directory ${target} does not exist or is not a directory"
  elif [[ ! -w ${target} ]]
  then
    usage "Target directory ${target} is not writable"
  fi
}

main() {
  if [[ $# -lt 3 ]]
  then
    usage "Not enough arguments supplied."
  fi
  
  read  start_year end_year station_id target <<< $@
  
  if [[ -z ${target} ]]
  then
    target=$(pwd)
  fi

  validate

  #Do the things

  for year in $(seq ${start_year} ${end_year})
  do 
    for month in $(seq 1 12)
    do
      url_params="format=csv&stationID=${station_id}&Year=${year}&Month=${month}&Day=14&timeframe=1&submit= Download+Data"     
      wget --content-disposition "${ECC_URL}?${url_params}" -P ${target}
    done
  done

}

main "$@"

