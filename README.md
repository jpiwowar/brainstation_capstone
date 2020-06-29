# brainstation_capstone
Notebooks, data, and scripts to support capstone project for Brainstation 
Data Science program, Spring 2020.  

Project and repo both still WIP, but "done enough" for submission. :-)

## Directories
* _data/_  - Partial source data for the project (see below for more details); intermediate data files and model dump files; other artifacts to support notebook execution   
* _notebooks/_  - Jupyter notebooks  
* _scripts/_ - Data collection tools.  Okay, _tool_. I ended up only writing one script. The pluralization of the directory name was aspirational.

## Notebooks
* EDA.ipynb - Data import, scrubbing, and general poking around
* Modeling.ipynb - Summary of modeling efforts

## Data setup 
There are three main sources for the data used in the project.  Data for weather and sunrise/sunset timings are included in the _data/_ directory. Data for the Mobi system usage is not included in this repository, because while re-hosting _might_ be permitted under the terms of Mobi's [Data License agreement](https://www.mobibikes.ca/sites/default/files/ressources/vbs_data_license_agreement_00478531xc0163_0.pdf), a) it's better to be safe than sorry and b) why take up extra space?

### Staging the Mobi bikeshare data
1. Install [gdown](https://github.com/wkentaro/gdown/blob/master/README.md) in your python enviroment:  
```pip install gdown```
2. Ensure that gdown is in your path:  
```which gdown```
3. Download the files to the data directory:  
  ``` 
  cd data
  cut -f6 -d'/' mobi_datafiles.txt | xargs -I% gdown --id %
  ```
4. Wait a few minutes; these files aren't small.

Alternatively, you can visit Mobi's [system data](https://www.mobibikes.ca/en/system-data) page and click through a bunch of download links.  As long as the resulting datafiles end up in the data directory, you're good to go.

### (Re)staging weather data
Only really needed if you want to test the download script (an understandable instinct, of course). Otherwise, the files included in the repo should suffice.  Instructions below assume you're in the top-level directory of the repo.  
1. Ensure that wget is in your path:   
```which wget```
1.  If not, install it using your favorite OS package manager, or directly into your Python environment:  
```[conda|pip] install wget```
1. Run the script to download the hourly weather conditions by month.  Note that if you use a weather station ID other than 51442, you will get weather for a different part of Canada. Please don't. \<SPOILERS\>These models are bad enough as it is.\</SPOILERS\>  
```scripts/pull_weather.sh 2017 2020 51442 data/```
1. **IMPORTANT:** Remove weather data files after Feb 2020, because the code in the EDA notebook isn't robust enough to ignore it, and it will screw up joins:  
```rm data/en_climate_hourly_BC_110839_0[3-9]-2020*.csv data/en_climate_hourly_BC_1108395_1[0-2]-2020*.csv```

## (Re)staging sunrise/sunset data
Short form: Don't.  Between the start of this project and now, the [service](https://nrc.canada.ca/en/research-development/products-services/software-applications/sun-calculator/) which provides the data files has changed its output format, and while the new format is inarguably better, I didn't learn about the change until a few hours before the project due date.  So let's just leave the source file as-is. :-) 