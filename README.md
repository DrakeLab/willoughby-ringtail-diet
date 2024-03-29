# PROTOCOL FOR: 
# A review of the diet flexibility of a common omnivore, the ringtail (Bassariscus astutus)

_Last updated: September 14, 2023_

## Authors: 

* Anna Willoughby
* Sydney Speir (CURO/ECOL4960R Spring 2021)
* John Drake
* Sonia Altizer 

### Background: 

Like many generalist species, the diverse foraging strategies of ringtails (*Bassariscus astutus*) allow them to inhabit a wide range of habitats across North America. Ringtails are exceptional omnivores, known to eat plants, insects, small mammals, birds, and human-provided foods like fig bars or pet food. In this study, we conduct a literature review of ringtail diet studies (n=40) to describe the various plants, prey, and inorganic items consumed by ringtails. From these population-level diet surveys, we explore how ringtail dependence on different diet items is dictated by habitat features, such as location, resource availability, overlap with people, and competition. We describe for each ringtail population a value of diet generalism (sp50) at different taxonomic resolutions. 

### Research questions:
 1) What is the diet of ringtails?
   *Predictions*
    - Ringtails will exhibit the hollow curve common of vertebrate diets, however, we expect variation in the dimensions of this trend based on study location and methods.
     
 2) Do environmental factors modify ringtail diet generalism?
    *Predictions*
    - Indiscriminate eaters: Ringtails will exhibit increased generalism in more resource-rich environments
    - Niche Specialism: Ringtails will exhibit decreased generalism when competitors are high.
    - Staples and Supplements: Ringtails will exhibit decreased generalism when competitors are high.
     
  3)  Do environmental factors modify ringtail diet omnivory?
      *Predictions*
    - Diet switching: The dominant diet class will be dependent on environmental factors
    - Ringtails will always exhibit the same dominance of diet class, regardless of location. 
      
### Study design: 
*Data Collation*
We identified ringtail diet studies through a systematic literature review, then supplemented this corpus with other scholarly publications identified though targeted repository reviews and citation diving (Supplementary Figure 1). For each study, we extracted identified diet items, assessed metrics, relative abundance values, study methods, sample size, and location. Each diet items' taxonomy was harmonized to the ITIS authority and assigned a taxonomic rank. 

*Population-level diet metric calculations*
For each ringtail population, we constructed diet abundance-rank relationships based on reported values and metrics. These data were then fit to a negative exponential curve, from which we could calculate a measure of diet generalism, (sp50, see Hutchinson et al. 2021). 

*Environmental correlates*
To assess the habitat traits that may influence ringtail diet generalism, we first assembled potential variables from several biogeographic, ecological, and anthropogenic datasets. 

## Analysis 
As these correlates greatly outnumber the sample of ringtail populations and may be subject to collinearity, we analyzed data using an elastic-net regression. 

$$
\begin{aligned}
sp50 = latitude + resource richness + competitors + anthropogenic 
\end{aligned}
$$

### Caveats
- need to limit variables due to small sample size
- Can I control for study size or duration, since this will bias results? 
- how to calculate resource availability?
- how to calculate competitors?
- more appropriate to do a lot of correlations 

---

### Data Collection 
Data input takes place on the following [Google Sheet](https://docs.google.com/spreadsheets/d/1M-M2E0h1CC5UlUgtnll5JIhjpUP0AiiO4tX1FLaAR6w/edit?usp=sharing). Static versions are then kept in this repository. 

Data  | Progress
------------- | -------------
metadata  | ![Progress](https://progress-bar.dev/64)
studies  | ![Progress](https://progress-bar.dev/85)
populations  | ![Progress](https://progress-bar.dev/53)
population_summaries  | ![Progress](https://progress-bar.dev/35)
interactions  | ![Progress](https://progress-bar.dev/53)

---

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
│   ├── raw/
│   │    ├── interactions.csv                          | diet item database
│   │    ├── pop_summaries.csv                         | diet category database
│   │    ├── studies.csv                               | study database for those that are included in this analysis
│   │    ├── populations.csv                           | population database for those that are included in this analysis
│   │    ├── metadata.csv                              | listing of variables in all databases
│   │    └── references.csv                            | listing of reference sources for all discovered literature
│   ├── processed/                                     | calculated population diet abundance distributions and traits
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


### Checklist: 

### Products 

* Speir, S, Willoughby AR, Altizer S. (2021) Expansion and comparison of ringtail (Bassariscus astutus) 
      diet in Zion National Park. UGA CURO Symposium. 13 Apr. (poster). Recipient of 1st Place UGA Libraries       
      Undergraduate Award for 1st-3rd Year Division. [[link](https://drive.google.com/file/d/1uog78t_9qbTmkgbjhhkKwqNYvKBuPipg/view?usp=share_link)]

* Willoughby AR, Speir S*, Altizer S. (2022). Expansion and comparison of ringtail (Bassariscus astutus) diet across the Southwest. 69th Annual Meeting of 
      the Southwestern Association of Naturalists. 23 April. [[link](https://drive.google.com/file/d/18I4sBirtLM6235FNXiWogi__qJcVE6yf/view?usp=share_link)]

* Speir, S, Willoughby AR, Altizer S. (2022) Examining methodologies and dietary diversity across the 
      ringtail (Bassariscus astutus) distribution 102nd meeting of the American Society of Mammalogists. 
      Tucson, AZ. 20 Jun. (poster) [[link](https://drive.google.com/file/d/1EpAuf-Gjyz7FhBcxAP9w4rcuqfJkcekL/view?usp=share_link)]


### Important background papers: 

Pringle RM, Hutchinson MC. Resolving food-web structure. Annual Review of Ecology, Evolution, and Systematics. 2020 Nov 2;51:55-80.
https://www.annualreviews.org/doi/full/10.1146/annurev-ecolsys-110218-024908#_i3

### CHANGE-LOG:
