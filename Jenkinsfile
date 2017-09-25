node {
  giturl = 'https://github.com/jamsheer/wordpress-ecs.git'
  stage 'Checkout'
  git url: giturl

  stage 'Docker Build'
  def image = docker.build('jamsheer/wordpress:latest', '.')

  stage 'Docker Push'
  withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-credentials',
                    usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
      sh("docker login -u $USERNAME -p $PASSWORD")
      image.push()
    }

  stage 'Code Deploy'
  shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%H'").trim()
  repository = giturl
  sh("aws deploy create-deployment --application-name wordpress --deployment-config-name CodeDeployDefault.OneAtATime --deployment-group-name Wordpress_Group --description 'My GitHub deployment demo' --github-location repository=$repository,commitId=$shortCommit")
}