def call(String imageName, String imageTag) {
    echo "Deleting local Docker images to save space..."
    
    sh """
        # Delete versioned tag
        docker rmi ${imageName}:${imageTag} || true
        
        # Delete latest tag
        docker rmi ${imageName}:latest || true
        
        # Clean up dangling images
        docker image prune -f || true
    """
    
    echo "✅ Local images deleted"
}
