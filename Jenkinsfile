node {
  stage 'Checkout'
  git url: 'https://github.com/jamsheer/wordpress-ecs.git'

  stage 'Docker Build'
  def image = docker.build('jamsheer/wordpress:latest', '.')

  stage 'Docker Push'
  docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials') {
    image.push()
  }
}