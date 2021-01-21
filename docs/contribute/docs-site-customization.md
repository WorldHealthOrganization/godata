# Documentation Site Customization

## Docs Site Theme
The documentation site was built using the `Jekyll` static site generator and the `Just the Docs` theme. 
- See here for customization guidance: https://pmarsceill.github.io/just-the-docs/
- To modify basic `css` attributes like color scheme, see `_sass` folder and file `tweaks.css`: https://github.com/WorldHealthOrganization/godata/blob/master/docs/_sass/color_schemes/tweaks.scss
- The site is configured to run off the `/docs` directory source. See the repo `Settings` page: https://github.com/WorldHealthOrganization/godata/tree/master/docs/assets

## Docs Pages
All docs pages are written in `Markdown`. See here for basic syntax guide: https://www.markdownguide.org/basic-syntax/
- When creating a new Github page, make sure you name your file to include the `.md` suffix (e.g., `newPage.md`). Otherwise the page may not render on the Github docs site properly. 
- See `Navigation Structure` docs for how to configure pages, set titles, and assign parent pages: https://pmarsceill.github.io/just-the-docs/docs/navigation-structure/
- Upload all media files & screenshots to the `docs/assets` directory: https://github.com/WorldHealthOrganization/godata/tree/master/docs/assets

## Deploying Docs Changes
Any changes made to the `master` branch will be automatically deployed to the docs site: https://worldhealthorganization.github.io/godata/
- Consider that changes may sometimes take a couple of minutes to build, but are usually fast. 
- If the docs site is not refreshing to reflect your changes, check [`Settings`](https://github.com/WorldHealthOrganization/godata/settings) > `Github Pages` to confirm that your site has successfully published and there were no errors when re-building the site. 
See screenshot: https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/github-pages.png

## Questions? 
Mention @aleksa-krolls in Github, or post on the Go.Data Slack channel: [link]
