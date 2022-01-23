FROM java:8
EXPOSE 8080

VOLUME /tmp
ADD *.jar /app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-jar","-Dfile.encoding=utf-8","/app.jar"]
