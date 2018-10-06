#############################################################################
# 1. Step (asset-elixir-dependencies)                                       #
# ========================================================================= #
# This download the elixir dependencies for the node compilation stage.     #
# E.g. phoenix and phoenix_html elixir depdencies contain JavaScript        #
# files. These are referenced in the package.json file like this:           #
# "phoenix": "file:../deps/phoenix"                                         #
#                                                                           #
#############################################################################
FROM elixir:1.7-alpine as asset-elixir-dependencies

ENV MIX_ENV=prod
ENV HOME=/opt/app

RUN apk add --no-cache git openssh
RUN mix do local.hex --force, local.rebar --force

# Cache elixir deps
COPY mix.exs mix.lock $HOME/

WORKDIR $HOME
RUN mix deps.get --only $MIX_ENV

########################################################################
FROM node:8 as asset-builder

ENV HOME=/opt/app
WORKDIR $HOME

COPY --from=asset-elixir-dependencies $HOME/deps/phoenix $HOME/deps/phoenix
COPY --from=asset-elixir-dependencies $HOME/deps/phoenix_html $HOME/deps/phoenix_html
COPY assets/package.json $HOME/assets/package.json
COPY assets/package-lock.json $HOME/assets/package-lock.json

WORKDIR $HOME/assets
RUN npm install && npm rebuild node-sass
COPY assets/ ./
RUN npm run deploy

########################################################################
FROM elixir:1.7-alpine as releaser

ENV MIX_ENV=prod
ENV HOME=/opt/app

ARG ERLANG_COOKIE
ENV ERLANG_COOKIE $ERLANG_COOKIE

WORKDIR $HOME

# dependencies for comeonin
RUN apk add --no-cache build-base cmake

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# Cache & compile elixir deps
COPY config/ $HOME/config/
COPY mix.exs mix.lock $HOME/
COPY --from=asset-elixir-dependencies $HOME/deps $HOME/deps
RUN mix deps.compile

# Get rest of application and compile
COPY . $HOME/
RUN mix compile --no-deps-check

# Digest precompiled assets
COPY --from=asset-builder $HOME/priv/static/ $HOME/priv/static/

WORKDIR $HOME
RUN mix do deps.loadpaths --no-deps-check, phx.digest

EXPOSE 4000
ENV PORT=4000

CMD ["mix", "phx.server", "--no-deps-check"]
