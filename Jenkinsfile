node {
  stage 'Checkout'
  git url: 'https://github.com/jamsheer/wordpress-ecs.git'

  stage 'Docker Build'
  def image = docker.build('jamsheer/wordpress:latest', '.')

  stage 'Docker Push'
  withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-credentials',
                    usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
      sh("docker login -u $USERNAME -p $PASSWORD")
      image.push()
    }
}