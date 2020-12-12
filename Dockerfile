FROM python:3.7
LABEL maintainer="Sony Huynh <hpsony94@gmail.com>"
RUN apt update && apt install -y curl jq vim

WORKDIR /app/
ADD kafka-conn .env /app/
ADD funcs /app/funcs
ADD env/dev /app/dev
ENV PATH="$PATH:/app"

CMD ["kafka-conn", "--help"]