pipeline {
    agent any

    tools {
        maven 'maven 3.9.12' // Jenkins에 등록된 Maven 3.9.12을 사용
    }

    stages {
        stage('Git Checkout') {
            steps { //steps : stage 안에서 수행할 실제 명령어
                // Jenkins 에 연결된 Git 저장소에서 코드를 체크아웃
                checkout scm
            }
        }
    }
}