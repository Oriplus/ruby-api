FROM ruby:3.1.3

RUN apt-get update -qq && apt-get install -y build-essential

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

CMD ["rackup", "config.ru", "-o", "0.0.0.0", "-p", "3000"]
