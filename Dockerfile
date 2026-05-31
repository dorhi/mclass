
# JDK 17을 기반으로 하는 Docker 이미지 사용
FROM eclipse-temurin:17-jdk
#JAR  파일이 저장될 작업 디렉토리 설정
WORKDIR /app

#Maven 또는 Gradle 빌드 후 생성된 JAR 파일을 컨테이너 내부 /app 디렉토리에 app.jar 이름으로 복사
COPY app.jar app.jar

#실행포트 지정
EXPOSE 8081

#컨테이너 실행 시 JAR 파일을 실행하는 명령어
ENTRYPOINT ["java", "-jar", "app.jar"]