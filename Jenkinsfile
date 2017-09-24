node {
  stage 'Checkout'
  git url: 'https://github.com/jamsheer/wordpress-ecs.git'

  stage 'Docker build and push'
  docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials') {
    def image = docker.build('jamsheer/wordpress:latest', '.')
    image.push()
  }
}