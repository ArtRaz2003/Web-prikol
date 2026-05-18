
ARG RUBY_VERSION=3.2.10
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

#  базовые системные пакеты для Rails и базы данных
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 libpq-dev postgresql-client nodejs cmake make build-essential git pkg-config  libyaml-dev&& \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# переменные окружения для production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# копируем файлы гемов и устанавливаем зависимости
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

#  код приложения
COPY . .

# предкомпиляция bootsnap
RUN bundle exec bootsnap precompile app/ lib/


RUN sed -i 's/ruby\.exe/ruby/g' bin/* && \
    sed -i 's/\r$//' bin/* && \
    chmod +x bin/*


# предкомпиляция ассетов
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# запуск сервера
CMD ["sh", "-c", "./bin/rails db:migrate RAILS_ENV=production ; ./bin/rails db:seed RAILS_ENV=production ; ./bin/rails server -b 0.0.0.0 -p ${PORT:-8080}"]
