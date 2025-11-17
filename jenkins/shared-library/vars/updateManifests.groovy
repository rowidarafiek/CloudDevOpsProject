def call(String imageName, String imageTag) {
    echo "Updating Kubernetes manifests with new image..."
    
    sh """
        # Update deployment.yaml with new image tag
        sed -i 's|image:.*|image: ${imageName}:${imageTag}|g' deployment.yaml
        
        # Show the changes
        echo "Updated deployment.yaml:"
        grep "image:" k8s/deployment.yaml
    """
    
    echo "✅ Manifests updated with image: ${imageName}:${imageTag}"
}
