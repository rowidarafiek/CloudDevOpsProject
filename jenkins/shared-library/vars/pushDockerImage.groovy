def call(String imageName, String imageTag) {
    echo "Pushing image to DockerHub: ${imageName}:${imageTag}"
    
    sh """
        # Login to DockerHub
        echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin
        
        # Push versioned tag
        docker push ${imageName}:${imageTag}
        
        # Push latest tag
        docker push ${imageName}:latest
        
        # Logout
        docker logout
    """
    
    echo "✅ Image pushed successfully to DockerHub"
    echo "   - ${imageName}:${imageTag}"
    echo "   - ${imageName}:latest"
}
