# elm-skeleton

A simple skeleton for getting started building Elm web apps.

## Features

- Automatic compilation of Jade, SASS, and Elm files
- Automatic compression for HTML, CSS, and Javascript files
- Automatic gzip compression with `zopfli` for all files
- Automatic offline caching using Service Workers and `sw-precache`
- BrowserSync to see changes immediately
- Easy deployment to GitHub pages with `npm run gh-pages`
- EditorConfig config for style consistency

## Getting started

```shell
git clone https://github.com/liamcurry/elm-skeleton.git
cd elm-skeleton
elm package install -y
npm install
npm start
```

## TODO

- Compress images
- Spritesheets?
- npm script for S3 deployment
