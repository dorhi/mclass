pipeline {
    agent any

    tools {
        maven 'maven 3.9.12' // Jenkins에 등록된 Maven 3.9.12을 사용
    }

    environment {
        //배포에 필요한 변수 설정
        DOCKER_IMAGE = "demo-app" // Docker 이미지 이름
        CONTAINER_NAME = "springboot-container"  // Docker 컨테이너 이름
        JAR_FILE_NAME = "app.jar" // 빌드된 JAR 파일 이름
        PORT = "8081" // 애플리케이션이 사용할 포트
        REMOTE_HOST = "43.200.75.214" // 원격 서버 IP 주소
        REMOTE_USER = "ec2-user" // 원격 서버 사용자 이름

        REMOTE_DIR = "/home/ec2-user/deploy" // 원격 서버에서 애플리케이션이 위치할 디렉토리
        SSH_CREDENTIALS_ID = "3dfbff18-576e-4bf5-837b-2b67e5ae8f13" // Jenkins에 등록된 SSH 자격 증명 ID

    }



    stages {
        stage('Git Checkout') {
            steps { //steps : stage 안에서 수행할 실제 명령어
                // Jenkins 에 연결된 Git 저장소에서 코드를 체크아웃
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                // Maven을 사용하여 프로젝트 빌드
                sh 'mvn clean package -DskipTests' // 테스트는 건너뛰고 빌드

            }
        }

        stage ('Prepare Jar') {
            steps {
                // 빌드 결과물인 JAR 파일을 지정한 이름(app.jar)으로 복사
                sh "cp target/demo-0.0.1-SNAPSHOT.jar ${JAR_FILE_NAME}"
            }
        }

        stage('Remote Doceker Build & Deploy') {
            steps {
                // Jenkins 가 원격 서버에 접속 할 수 있도록 sshagent 사용
                sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                    // 원격 서버에 배포 디렉토리 생성 (없으면 새로 만듦)
                    sh "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${REMOTE_USER}@${REMOTE_HOST} \"mkdir -p ${REMOTE_DIR}\""
                    // JAR 파일과 Dockerfile을 원격 서버에 복사
                    sh "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${JAR_FILE_NAME} Dockerfile ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"
                }
            }
        }

        stage('Deploy on Remote Server') {
            steps {
                sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                    // 원격 서버에 접속하여 Docker 이미지를 빌드하고 컨테이너 실행
                    sh """
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${REMOTE_USER}@${REMOTE_HOST} << ENDSSH
    cd ${REMOTE_DIR} || exit 1
    docker rm -f ${CONTAINER_NAME} || true
    docker build -t ${DOCKER_IMAGE} .
    docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${DOCKER_IMAGE}
ENDSSH
                   """
                }
            }
        }
    }
}