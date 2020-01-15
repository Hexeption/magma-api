FROM alpine:edge
MAINTAINER magmafoundation.org
ARG REPO_USERNAME_VAR
ARG REPO_PASSWORD_VAR
RUN echo $(REPO_USERNAME)
RUN echo $REPO_PASSWORD
RUN apk add --no-cache openjdk11 curl
WORKDIR build/
RUN curl -fL https://getcli.jfrog.io | sh
RUN chmod +x jfrog
RUN ./jfrog rt config --user=$REPO_USERNAME_VAR --password=$REPO_PASSWORD_VAR --url=https://repo.hexeption.co.uk/artifactory
RUN ./jfrog rt dl "Magma/org/magmafoundation/magma/api/*.jar" "magma-api.jar" --sort-by=created --sort-order=desc  --limit=1
COPY org/magmafoundation/magma/api/**/**.jar /app/magma-api.jar
ENTRYPOINT ["/usr/bin/java"]
CMD ["-jar", "/app/magma-api.jar"]

EXPOSE 8080

