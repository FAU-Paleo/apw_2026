# README

Currently built at [https://fau-paleo.github.io/apw_2026/](https://fau-paleo.github.io/apw_2026/). 

## About Jekyll

The site is built with jekyll, a very neat ruby program which translates markdown documents to html and builds these into static websites. It is insanely powerful. The building process is executed by GitHub itself, you make the changes, commit and push them to the repository and in 1 minute they should be visible - given that everything you have done is ok. If you want to learn more about this, check out [this page](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll). 

If you have Jekyll installed on your computer, you can also render and check out how the page looks offline - but the page is so simple that this is not necessary.  

## Sharing material

All actual files of the webpage are in the `docs` directory. **You are expected to edit the module-specific pages**, which are in the `docs/_posts` directory. These pages have a front matter (before the dashes), don't worry about those (I will update the dates!) - except for the title, which you are welcome to change. Here is a table of what files were supposed to be edited by whom:

| file                            | correspondent(s)      | link                                                                                                         |
|---------------------------------|-----------------------|--------------------------------------------------------------------------------------------------------------|
| 2026-08-17-toolset.md           | Adam                  | [https://fau-paleo.github.io/apw_2026/toolset/](https://fau-paleo.github.io/apw_2026/toolset/)               |
| 2026-08-18-paleodiversity.md    | Wolfgang and Adam     | [https://fau-paleo.github.io/apw_2026/paleodiversity/](https://fau-paleo.github.io/apw_2026/paleodiversity/) |
| 2026-08-30-paleogeography.md    | Adam (Liz)            | [https://fau-paleo.github.io/apw_2026/paleogeography/](https://fau-paleo.github.io/apw_2026/paleogeography/) |
| 2026-09-03-ssub-niches.md       | Erin (Cooper)         | [https://fau-paleo.github.io/apw_2026/ssub-niches/](https://fau-paleo.github.io/apw_2026/ssub-niches/)       |
| 2026-08-21-phylogenetics.md     | Rachel                | [https://fau-paleo.github.io/apw_2026/phylogenetics/](https://fau-paleo.github.io/apw_2026/phylogenetics/)   |
| 2026-08-26-morphometrics.md     | Ryan                  | [https://fau-paleo.github.io/apw_2026/morphometrics/](https://fau-paleo.github.io/apw_2026/morphometrics/)   |
| 2026-09-02-div-cmr.md           | Lee Hsiang and Isaiah | [https://fau-paleo.github.io/apw_2026/cmr/](https://fau-paleo.github.io/apw_2026/cmr/)                       |
| 2026-08-31-timeseries-traits.md | Kjetil                | [https://fau-paleo.github.io/apw_2026/timeseries/](https://fau-paleo.github.io/apw_2026/timeseries/)         |
| 2026-08-24-pyrate.md            | Daniele               | [https://fau-paleo.github.io/apw_2026/pyrate_ai/](https://fau-paleo.github.io/apw_2026/pyrate_ai/)           |

#### Notes

- I copied over the material from the previous year, assuming that you would like to start with them **but this should not discourage you from updating what is necesssary, and delete things you no longer need.** 

- The exact materials from the previous year are avaiable at this GitHub repo: [GitHub previous year](https://github.com/FAU-Paleo/apw_2025). 

- For novice git users: to avoid chaos please only edit the page that you are responsible for and use the GitHub interface. If all of this feels overwhelming, don't worry. I (Adam) am happy to put the material on the webpage for you if you need help!

- The data files (and scripts/slides) should be put in the `data` directory, then the format `{{site.baseurl}}/data/<your directory path>/filename.ext` is used to create the link to the file. The `{{site.baseurl}}` bit will become `/apw_2026`. The data files also need to be committed to the git repo. GitHub has a file size limit, if you want to share files that are bigger than 100MB, please use an external hosting service and provide the download links. 

- If you have sensitive files that you want to share with the students, please use private, external links to these (e.g. dropbox/google drive). Do not add them to the repo because that is relatively difficult to delete. Once the course is over, links to such sensitive files can be invalidated and nobody else will be able to access them.

- The dates of the posts control when they are visible: future posts are not visible, hence the past dates. The years are from last year, but the months and days are the coming ones. I will make the links to the material in the schedule table ([landing page](https://fau-paleo.github.io/apw_2026/)) available on the fly. Even though the links on the index page are not yet live (not to disorient the students), the URLs will be live. It is a good idea therefore to save the URL of the page that you are editing. 


## Suggested organisation scheme for files

To help keep everything organsied, you'll find subfolders within the main data directories under the name of your module(s). These should go in the `docs/data` directory: `{{site.baseurl}}/data/<your directory path>/filename.ext`
The file `{{site.baseurl}}/data/1_toolset/metadata.txt` is built as `https://fau-paleo.github.io/apw_2024/data/1_toolset/metadata.txt`


## Markdown

You can find a cheat sheet [here](https://www.markdownguide.org/cheat-sheet/).
