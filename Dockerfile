FROM node:10.15.0

ENV NODE_ENV=development
ENV ENV=development

RUN npm i -g npm@latest

RUN npm i -g grunt-cli kanso concurrently node-gyp

COPY . /srv/
WORKDIR /srv/
RUN yarn install

WORKDIR /srv/webapp/
RUN yarn install
WORKDIR /srv/

WORKDIR /srv/admin/
RUN yarn install
WORKDIR /srv/

WORKDIR /srv/api/
RUN yarn install
WORKDIR /srv/

RUN cd sentinel && yarn install
WORKDIR /srv/

RUN ./node_modules/.bin/grunt build-dev

CMD ["npm", "run" , "dev"]
