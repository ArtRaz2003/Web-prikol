# Указываем версию Ruby (можешь поменять на свою, если у тебя другая, например 3.2.0)
ARG RUBY_VERSION=3.2.10
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Устанавливаем базовые системные пакеты, нужные для Rails и базы данных
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 libpq-dev postgresql-client nodejs cmake make build-essential git pkg-config  libyaml-dev&& \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Настраиваем переменные окружения для production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Копируем файлы гемов и устанавливаем зависимости
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Копируем весь код приложения
COPY . .

# Предкомпиляция bootsnap для быстрого запуска
RUN bundle exec bootsnap precompile app/ lib/

# Исправляем проблемы Windows
RUN sed -i 's/ruby\.exe/ruby/g' bin/* && \
    sed -i 's/\r$//' bin/* && \
    chmod +x bin/*


# Предкомпиляция ассетов (картинок, стилей, JS)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Запуск сервера
CMD ["sh", "-c", "./bin/rails db:migrate RAILS_ENV=production && ./bin/rails db:seed RAILS_ENV=production && ./bin/rails server -b 0.0.0.0"]
