# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.2.3
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    PATH="/usr/local/node/bin:$PATH"

FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      libpq-dev \
      libvips \
      node-gyp \
      pkg-config \
      python-is-python3 \
      imagemagick && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

ARG NODE_VERSION=20.14.0
ARG YARN_VERSION=1.22.22
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "$NODE_VERSION" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile && \
    yarn cache clean

COPY . .

RUN bundle exec bootsnap precompile app/ lib/
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libvips \
      postgresql-client \
      imagemagick \
      cron && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN mkdir -p /var/run && chmod -R 777 /var/run

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# USER rails:rails の行は削除

COPY --chmod=0755 docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000
CMD bash -c "service cron start && ./bin/rails server -b 0.0.0.0 -p 3000"

