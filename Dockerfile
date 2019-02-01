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

FROM alpine
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /yildiz-online
RUN mkdir /dist
COPY --from=build /app/target/media/ /yildiz-online/media/
COPY --from=build /app/target/game-client.jar /yildiz-online/game-client.jar
COPY --from=build /app/target/yildiz-online.exe /yildiz-online/yildiz-online.exe
