def call(String imageName, String imageTag) {
    echo "Building Docker image: ${imageName}:${imageTag}"
    
    sh """
        # Build the image
        docker build -t ${imageName}:${imageTag} .
        
        # Also tag as latest
        docker tag ${imageName}:${imageTag} ${imageName}:latest
        
        # Verify image was created
        docker images | grep ${imageName}
    """
    
    echo "✅ Image built successfully: ${imageName}:${imageTag}"
}
