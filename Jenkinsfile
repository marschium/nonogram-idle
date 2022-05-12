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
                        python tools/generate.py
                    """
                }
            }            
        }
        stage ('Windows') {
            steps {
                dir("${env.WORKSPACE}") {
                    echo 'Building..'
                    sh "mkdir -p export/windows"
                    sh "godot --export 'Windows Desktop' export/windows/DOTS.exe"
                }
            }
        }
        stage ('Linux') {
            steps {
                dir("${env.WORKSPACE}") {
                    echo 'Building..'
                    sh "mkdir -p export/linux"
                    sh "godot --export 'Linux/X11' export/linux/DOTS.x86_64"
                }
            }
        }
        stage ('Html') {
            steps {
                dir("${env.WORKSPACE}") {
                    echo 'Building..'
                    sh "mkdir -p export/html"
                    sh "godot --export 'HTML5' export/html/DOTS.html"
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: "export/**", fingerprint: true
        }
    }
}
