pipeline {
  agent any

  stages {
    stage('Prepare env') {
      steps {
        withPythonEnv('python') {
	   sh 'pip install -r src/requirements.txt'
        }
      }
    }
    stage('Build B3 Specification') {
      steps {
        withPythonEnv('python') {
          sh 'make -C src/b3 html latexpdf'
	}
      }
    }
    stage('Build B3.1 Specification') {
      steps {
        withPythonEnv('python') {
          sh 'make -C src/b3.1 html latexpdf'
	}
      }
    }
    stage('Publish Website') {
      steps {
        sh 'rsync -avh --delete website/ /var/www/html/wishbone'
	sh 'mkdir /var/www/html/wishbone/assets /var/www/html/wishbone/specs'
        sh 'cp src/b3/build/latex/wishbone-b3.pdf /var/www/html/wishbone/assets'
        sh 'cp src/b3.1/build/latex/wishbone-b3-1.pdf /var/www/html/wishbone/assets'
	sh 'rsync -avh --delete src/b3/build/html/ /var/www/html/wishbone/specs/b3'
	sh 'rsync -avh --delete src/b3/build/html/ /var/www/html/wishbone/specs/b3.1'
      }
    }
  }
}