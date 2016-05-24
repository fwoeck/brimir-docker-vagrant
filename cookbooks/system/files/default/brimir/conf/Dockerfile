FROM ruby:2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /brimir
WORKDIR /brimir
ADD . /brimir
RUN bundle install --without sqlite mysql development test
