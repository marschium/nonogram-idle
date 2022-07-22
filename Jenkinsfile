pipeline {
    agent any
    stages {
        stage ('Clean') {
            steps {
                dir("${env.WORKSPACE}") {
                    sh "rm -rf ./export"
                }
            }
        }
        stage ('Generate') {
            steps {
                dir("${env.WORKSPACE}") {
                    echo 'Setting up python env..'
                    sh 'virtualenv .venv'
                    sh """
                        . .venv/bin/activate
                        pip install -r tools/requirements.txt
                        python generate.py
                    """
                }
            }            
        }
        stage ('Windows') {
            steps {
                dir("${env.WORKSPACE}/game") {
                    echo 'Building..'
                    sh "mkdir -p export/windows"
                    sh "godot --export 'Windows Desktop' export/windows/nonogram_idle.exe"
                }
            }
        }
        stage ('Linux') {
            steps {
                dir("${env.WORKSPACE}/game") {
                    echo 'Building..'
                    sh "mkdir -p export/linux"
                    sh "godot --export 'Linux/X11' export/linux/nonogram_idle.x86_64"
                }
            }
        }
        stage ('Html') {
            steps {
                dir("${env.WORKSPACE}/game") {
                    echo 'Building..'
                    sh "mkdir -p export/html"
                    sh "godot --export 'HTML5' export/html/nonogram_idle.html"
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: "game/export/**", fingerprint: true
        }
    }
}
