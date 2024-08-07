---
layout: default
title: Site Customization
parent: How to contribute
nav_order: 1
permalink: /docs-customization/
---
# Documentation Site Customization

## Docs Site Theme
The documentation site was built using the `Jekyll` static site generator and the `Just the Docs` theme. 
- See here for customization guidance: [https://pmarsceill.github.io/just-the-docs/](https://pmarsceill.github.io/just-the-docs/)
- To modify basic `css` attributes like color scheme, see `_sass` folder and file `tweaks.css`: [https://github.com/WorldHealthOrganization/godata/blob/master/docs/_sass/color_schemes/tweaks.scss](https://github.com/WorldHealthOrganization/godata/blob/master/docs/_sass/color_schemes/tweaks.scss)
- The site is configured to run off the `/docs` directory source. See the repo `Settings` page: [https://github.com/WorldHealthOrganization/godata/tree/master/docs/assets](https://github.com/WorldHealthOrganization/godata/tree/master/docs/assets)

## Docs Pages
All docs pages are written in `Markdown`. See here for basic syntax guide: [https://www.markdownguide.org/basic-syntax/](https://www.markdownguide.org/basic-syntax/)
- When creating a new Github page, make sure you name your file to include the `.md` suffix (e.g., `newPage.md`). Otherwise the page may not render on the Github docs site properly. 
- See `Navigation Structure` docs for how to configure pages, set titles, and assign parent pages: [https://pmarsceill.github.io/just-the-docs/docs/navigation-structure/](https://pmarsceill.github.io/just-the-docs/docs/navigation-structure/)
- Upload all media files & screenshots to the `docs/assets` directory: [https://github.com/WorldHealthOrganization/godata/tree/master/docs/assets](https://github.com/WorldHealthOrganization/godata/tree/master/docs/assets)

### Code Blocks
[See Markdown](https://www.markdownguide.org/extended-syntax/#:~:text=The%20basic%20Markdown%20syntax%20allows,and%20after%20the%20code%20block.) guidance for basic code block syntax tips. 

**Note for R code blocks:** To ensure the site does not evaluate the R code, include the tags **r{% raw %}**  and **{% endraw %}** at the start and end of your code block next to the 3 ticks. For example...
![github-pages](../assets/r-code-block.png)

## Deploying Docs Changes
Any changes made to the `master` branch will be automatically deployed to the docs site: [https://worldhealthorganization.github.io/godata/](https://worldhealthorganization.github.io/godata/)
- Consider that changes may sometimes take a couple of minutes to build, but are usually fast. 
- If the docs site is not refreshing to reflect your changes, check [`Settings`](https://github.com/WorldHealthOrganization/godata/settings) > `Github Pages` to confirm that your site has successfully published and there were no errors when re-building the site. 

![github-pages](../assets/github-pages.png)


## Questions? 
Reach out to us at godata@who.int
