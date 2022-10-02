# Build stage
FROM klakegg/hugo:ext-ubuntu as builder
WORKDIR /app
RUN go version
# copy Go modules and dependencies to image
COPY go.* ./
# download Go modules and dependencies
RUN go mod download
# copy npm modules and dependencies to image
COPY package.json ./package.json
# download npm modules and dependencies
RUN npm install
RUN npm install -g @fullhuman/postcss-purgecss rtlcss
# copy directory files
COPY ./ ./

ARG HUGO_BASEURL=/
ENV HUGO_BASEURL=${HUGO_BASEURL}

RUN hugo version
RUN hugo --minify --buildDrafts --buildFuture --destination  ./public

# Final stage
FROM nginx
COPY --from=builder /app/public /app
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

