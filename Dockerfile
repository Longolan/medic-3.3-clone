FROM node:10.15.0

ENV NODE_ENV=production
ENV ENV=production

RUN npm i -g npm@latest

RUN npm i -g grunt-cli kanso concurrently node-gyp

COPY . /srv/

CMD ["npm", "start"]
