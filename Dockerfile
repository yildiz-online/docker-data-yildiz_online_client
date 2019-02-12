FROM alpine/git as clone
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
ARG GH_TOKEN
ARG REPO
WORKDIR /app
RUN git clone https://$GH_TOKEN@github.com/yildiz-online/$REPO.git

FROM moussavdb/build-java as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
ARG REPO
WORKDIR /app
COPY --from=clone /app/$REPO /app
RUN mvn package -s settings.xml -Denv=win64

FROM nginx
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
COPY --from=build /app/target/media/ /usr/share/nginx/html
COPY --from=build /app/target/game-client.jar /usr/share/nginx/html/game-client.jar
COPY --from=build /app/target/yildiz-online.exe /usr/share/nginx/html/yildiz-online.exe
RUN apt-get update \
&& apt-get install -y -q curl
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1
