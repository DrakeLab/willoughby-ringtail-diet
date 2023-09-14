# PROTOCOL FOR: 
# A review of the diet flexibility of a common carnivore, the ringtail (Bassariscus astutus)

_Last updated: September 14, 2023_

## Authors: 

* Anna Willoughby
* Sydney Speir (CURO/ECOL4960R Spring 2021)
* Sonia Altizer 

### Background: 

Like many generalist species, the diverse foraging strategies of ringtails (*Bassariscus astutus*) allow them to inhabit a wide range of ecoregions across North America. As omnivores, ringtails are known to eat a range of plants, insects, small mammals, and other food items. In this study, we conduct a literature review of ringtail diet studies (n=40) to describe the various plants, prey, and inorganic items consumed by ringtails, describe ringtail dietary diversity across ecoregions, and highlight gaps in the current understanding of ringtail diet. Studies were found through a systematic literature review and supplemented by other scholarly publications. Within each study, we documented identified diet items, their taxonomic rank, methods, sample size, and location. We hypothesize that fresh scat analysis will show the highest taxonomic richness, as it experiences less environmental degradation than other physical examination methods. We also document unique diet items found in observational studies to describe their usefulness in dietary analysis studies. Finally, we conduct a comparison of diets to understand differences in ringtail diet composition. This study sheds light informs the dietary diversity of a flexible mesocarnivore and the factors that influence omniviry.


### Research questions:
 1) What is the diet of ringtails? 
 2) How flexibile is ringtail omnivory? 

### Study design: 

#### Study 

### Data Collection 
Data input takes place on the following [Google Sheet](https://docs.google.com/spreadsheets/d/1M-M2E0h1CC5UlUgtnll5JIhjpUP0AiiO4tX1FLaAR6w/edit?usp=sharing). Static versions are then kept in this repository. 

Data  | Progress
------------- | -------------
metadata  | ![Progress](https://progress-bar.dev/59)
studies  | ![Progress](https://progress-bar.dev/78)
populations  | ![Progress](https://progress-bar.dev/59)
population_summaries  | ![Progress](https://progress-bar.dev/59)
interactions  | ![Progress](https://progress-bar.dev/59)

### Repo Structure
-  `data/` contains data used in these analyses, including
    -   databases of diet items (`interactions.csv`) and categories (`pop_summaries.csv`)
    -   databases of study- (`studies.csv`) and population- (`pops.csv`) level traits
    -   full references for all studies discovered through systematic search (`references.csv`)
    -   A `metadata.csv` file that describes variables in my database
    -  look up tables to normalize diet metrics (`.csv`) and categories (`.csv`)
    -   `region_names.rds`, a list of zoogeographical region names used to describe cross-validation regions. 
-  `figures/` contains figures and tables in the paper
-   `scripts/` contains all the scripts used to fit the models and generate outputs
-   `R/` contains files with functions used in other scripts.    
-   `misc/` contains small scripts used for other calculations
-   `intermediates/` is a holding directory for
     intermediate data files and fitted model objects in
     `*.rds` R data form. These are re-created when the project is built
-   `shapefiles/` is an empty holding directory.  Large shapefiles used to generate
    maps and in analyses are stored separately on AWS to limit the size of this
    repository.  They are downloaded to this folder by the scripts when needed.
---

### Listing of files
```
├── README.md                                          | This file in .md format
├── README.txt                                         | This file in .txt format
├── willoughby-ringtail-diet.Rproj                     | Rstudio project organization file
├── data/
│   ├── interactions.csv                               | diet item database
│   ├── pop_summaries.csv                              | diet category database
│   ├── studies.csv                                    | study database for those that are included in this analysis
│   ├── populations.csv                                | population database for those that are included in this analysis
│   ├── metadata.csv                                   | listing of variables in all databases
│   ├── references.csv                                 | listing of reference sources for all discovered literature
│   └── lookup_tables/                                 | data files to normalise verbatim variables 
│
├── figures                                            | Figures and tables for  manuscript and supplements
│
├── scripts/                                           | Scripts to build project outputs
│
├── packrat/                                           | Holds all R package dependencies
└── .Rprofile                                          | Configures R to use packrat dependencies
```
---

### Analysis: 


### Checklist: 

### Products 

* Speir, S, Willoughby AR, Altizer S. (2021) Expansion and comparison of ringtail (Bassariscus astutus) 
      diet in Zion National Park. UGA CURO Symposium. 13 Apr. (poster). Recipient of 1st Place UGA Libraries       
      Undergraduate Award for 1st-3rd Year Division. [link](https://drive.google.com/file/d/1uog78t_9qbTmkgbjhhkKwqNYvKBuPipg/view?usp=share_link)

* Willoughby AR, Speir S*, Altizer S. (2022). Expansion and comparison of ringtail (Bassariscus astutus) diet across the Southwest. 69th Annual Meeting of 
      the Southwestern Association of Naturalists. 23 April. [link](https://drive.google.com/file/d/18I4sBirtLM6235FNXiWogi__qJcVE6yf/view?usp=share_link)

* Speir, S, Willoughby AR, Altizer S. (2022) Examining methodologies and dietary diversity across the 
      ringtail (Bassariscus astutus) distribution 102nd meeting of the American Society of Mammalogists. 
      Tucson, AZ. 20 Jun. (poster) [link](https://drive.google.com/file/d/1EpAuf-Gjyz7FhBcxAP9w4rcuqfJkcekL/view?usp=share_link)


### Important background papers: 

Pringle RM, Hutchinson MC. Resolving food-web structure. Annual Review of Ecology, Evolution, and Systematics. 2020 Nov 2;51:55-80.
https://www.annualreviews.org/doi/full/10.1146/annurev-ecolsys-110218-024908#_i3

### CHANGE-LOG:
