# Replication package for "Comparative Effects of Recreational and Medical Marijuana Laws On Drug Use Among Adults and Adolescents"
-------------
Alex Hollingsworth, Coady Wing, and Ashley Bradford
Journal of Law and Economics

You can cite this replication package using zenodo, where an archival version of this repository is stored. 
 [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.6588013.svg)](https://doi.org/10.5281/zenodo.6588013)
 
## Overview
-------------

The code and data in this replication package will replicate all tables and figures from raw data using Stata, R, and a few unix shell commands. 

The entire project can be replicated by opening the stata project file `rec-mj.stpr` and then by running the `code/00-run-file.do` do file. This file will also run the necessary R code. The paper can be rebuilt using the latex file `manuscript.tex`. 

Using a 2019 MacBook Pro with a  2.3 GHz 8-Core Intel Core i9 processor and 32 GB of RAM, the entire replication takes a little more than 4 hours. The majority of this time is spent on two randomization inference procedures. In `code/00-run-file.do`, the user can choose to not run the randomization inference code by altering line 107 to be `global slow_code 0`. If this is done the entire replication will take less than 15 minutes. 

Note: The github version of this replication package only contains the code and output. The zenodo version of this replication package contains all raw data and data used in analysis (as well as the code). 

The zenodo replication package is available here: https://doi.org/10.5281/zenodo.6588013

The github version (only code and output) is available here: https://github.com/hollina/recreational-marijuana-legalization-and-use


## Legalization and dispensary opening dates

- See file `raw_data/marijuana_laws/state-marijuana-laws-12-11-20.xlsx` for key legalization and dispensary opening dates. 
- A zipped folder with source pdfs for each of these dates can be found in `raw_data/marijuana_laws/SourcePDFs.zip`


## Software Requirements

- Stata (code was last run with version 15.1)
	- the program `code/00-run-file.do` will install all stata dependencies locally if line 61 is set to `local install_stata_packages 1`
	- All user-written stata programs used in this project can be found in `stata_packages` directory

R 4.1 
- We use the package `renv` for this project
	- The `renv.lock` file has the version of each R package used in this project. 

Portions of the code use shell commands, which may require Unix (the analysis was done on a mac).


## Instructions to Replicators
- Edit line 43 of `code/00-run-file.do` to R executible path
	- e.g., `global r_path "/usr/local/bin/R"`
- Edit line 61 of `code/00-run-file.do`  if you'd like to install stata code again rather than running code using `stata_packages` folder
- Edit line 103 of `code/00-run-file.do`  if you want to build analytic data from raw data
- Edit line 107 of `code/00-run-file.do`  if you want to run slow code (randomization inference)
- Compile `latex/manuscript.tex` to recreate paper.


The provided code reproduces all tables, figures, and results in the paper. 

## Acknowledgements
This code is based on AEA data editor's readme guidelines. (https://aeadataeditor.github.io/posts/2020-12-08-template-readme). Some content on this page was copied from [Hindawi](https://www.hindawi.com/research.data/#statement.templates). Other content was adapted  from [Fort (2016)](https://doi.org/10.1093/restud/rdw057), Supplementary data, with the author's permission. 