# docker build . -o target/

FROM maven:3.8-adoptopenjdk-15 AS builder

ARG ELASTICSEARCH_VERSION=7.14.0

RUN mkdir -p /build
WORKDIR /build

# Download depenencies
COPY pom.xml ./
RUN mvn -Delasticsearch.version=${ELASTICSEARCH_VERSION} clean verify package --fail-never

# Build plugin
COPY src ./src
RUN mvn -Delasticsearch.version=${ELASTICSEARCH_VERSION} clean package

##############################################################################
# Run stage (containing only website result)
##############################################################################
FROM scratch
COPY --from=builder /build/target/releases/elasticsearch-concatenate-*.zip /
