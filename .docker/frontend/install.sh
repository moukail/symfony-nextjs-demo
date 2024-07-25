#!/usr/bin/env bash

npx create-next-app --typescript --eslint --tailwind --use-npm --src-dir /var/www --import-alias "@/*" --app frontend <<< 'y'

npm install @mui/material-nextjs @emotion/cache @mui/x-data-grid
npm install axios swr