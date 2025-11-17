def call() {
    echo "Pushing updated manifests to Git repository..."
    
    sh """
        # Configure Git
        git config user.email "jenkins@clouddevops.com"
        git config user.name "Jenkins CI"
        
        # Add changes
        git add k8s/deployment.yaml
        
        # Commit with build info
        git commit -m "Update image to build ${BUILD_NUMBER}" || echo "No changes to commit"
        
        # Push to repository
        git push https://\${GIT_CREDENTIALS_USR}:\${GIT_CREDENTIALS_PSW}@github.com/rowidarafiek/CloudDevOpsProject.git HEAD:main
    """
    
    echo "✅ Manifests pushed to Git repository"
    echo "   ArgoCD will detect changes and auto-sync"
}
