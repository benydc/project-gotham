FROM ruby:2.5.7-alpine
RUN apk add alpine-sdk libpq postgresql-dev \
    libc6-compat git gcc make cmake libc-dev \
    linux-headers bash wget libc6-compat \
    autoconf automake libtool curl make g++ \
    unzip sqlite sqlite-dev

RUN apk add --update tzdata nodejs yarn shared-mime-info

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

ENV RAILS_ENV=production
ENV RAKE_ENV=production

ADD Gemfile ./Gemfile
RUN gem install bundler

ADD Gemfile.lock ./Gemfile.lock
RUN bundle install --jobs=4 --deployment --without development test

ADD . /usr/src/app

RUN yarn install --check-files
RUN yarn upgrade

ENTRYPOINT ["bin/docker-entrypoint"]

CMD ["bundle", "exec", "rails", "s"]