FROM trenpixster/elixir:latest

ENV LANG=en_US.UTF-8

WORKDIR /app

COPY . /app

ENV MIX_ENV prod
RUN mix do deps.get, deps.compile

RUN mix compile

CMD ["mix", "run", "--no-halt"]