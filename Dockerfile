FROM python:3-alpine

WORKDIR /app

COPY ./requirements.txt .
RUN apk update \
    && apk add --virtual .build-deps build-base gcc \
    && pip install -r requirements.txt \
    && apk del .build-deps build-base gcc

COPY . .

RUN addgroup -S nonroot && adduser -Ss /bin/sh -h /app -G nonroot nonroot && \
    chown -R nonroot.nonroot /app

USER nonroot
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["help"]
