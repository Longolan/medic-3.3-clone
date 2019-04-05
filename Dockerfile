FROM node:10.15.0

ENV NODE_ENV=production
ENV ENV=production

RUN npm i -g npm@latest

RUN npm i -g grunt-cli kanso concurrently node-gyp

COPY . /srv/

WORKDIR /srv/

RUN cd webapp && yarn install && cd ..
RUN cd admin && yarn install && cd ..
RUN cd api && yarn install && cd ..
RUN cd sentinel && yarn install && cd ..

WORKDIR /srv/

RUN grunt build

CMD ["npm", "run" , "dev"]
