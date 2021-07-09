FROM ruby:2.7.2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -y nodejs postgresql-client vim yarn

ENV APP_PATH=/app
RUN mkdir $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile $APP_PATH
COPY Gemfile.lock $APP_PATH

RUN bundle install --jobs 5

COPY . $APP_PATH

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "80"]
