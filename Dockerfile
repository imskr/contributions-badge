FROM ruby:3.2

COPY . /app
WORKDIR /app

ENTRYPOINT ["ruby", "/app/contributions.rb"]
