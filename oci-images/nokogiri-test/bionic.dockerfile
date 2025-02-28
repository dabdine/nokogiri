FROM ubuntu:bionic

# -*- dockerfile -*-

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y apt-utils


# -*- dockerfile -*-

RUN apt-get install -y libxslt-dev libxml2-dev pkg-config


# -*- dockerfile -*-

RUN apt-get install -y ruby ruby-dev bundler


# -*- dockerfile -*-

COPY Gemfile nokogiri/
COPY Gemfile.lock nokogiri/
COPY nokogiri.gemspec nokogiri/

RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" nokogiri/Gemfile.lock | tail -n 1)"
RUN cd nokogiri && bundle install

