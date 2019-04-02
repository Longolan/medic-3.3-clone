FROM node:10.15.0

ENV NODE_ENV=production
ENV ENV=production

RUN npm i -g npm@latest grunt-cli kanso concurrently node-gyp

COPY . /srv/

WORKDIR /srv/

RUN yarn install

RUN cd webapp && yarn install && cd ..
RUN cd admin && yarn install && cd ..
RUN cd api && yarn install && cd ..
RUN cd sentinel && yarn install && cd ..

RUN grunt build

CMD ["yarn", "start"]


