# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.3
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    PATH="/usr/local/node/bin:$PATH"

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and node modules
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

# Install Node.js and Yarn
ARG NODE_VERSION=20.14.0
ARG YARN_VERSION=1.22.22
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "$NODE_VERSION" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules and clean up yarn cache
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile && \
    yarn cache clean

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Install packages needed for deployment and cron, then clean up
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libvips \
      postgresql-client \
      imagemagick \
      cron && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Ensure /var/run exists and has appropriate permissions
RUN mkdir -p /var/run && chmod -R 777 /var/run

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Set up a non-root user for security and set permissions on required folders
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp && \
    mkdir -p /rails/public/uploads/tmp && \
    chown -R rails:rails /rails/public/uploads && \
    chmod -R 755 /rails/public/uploads && \
    chmod -R 700 /rails/public/uploads/tmp
USER rails:rails

# Copy the entrypoint script and set permissions
COPY --chmod=0755 docker-entrypoint.sh /usr/bin/

# Entrypoint prepares the database.
ENTRYPOINT ["docker-entrypoint.sh"]

# Start cron and the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bash", "-c", "cron && ./bin/rails server -b 0.0.0.0 -p 3000"]
