FROM alpine:edge
MAINTAINER magmafoundation.org
RUN apk add --no-cache openjdk11
COPY build/libs/* /app/magma-api.jar
ENTRYPOINT ["/usr/bin/java"]
CMD ["-jar", "/app/magma-api.jar"]
EXPOSE 8080

