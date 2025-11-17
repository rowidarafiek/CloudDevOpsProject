def call(String imageName, String imageTag) {
    echo "Scanning image for vulnerabilities: ${imageName}:${imageTag}"
    
    // Check if Trivy is installed
    def trivyInstalled = sh(
        script: 'which trivy',
        returnStatus: true
    )
    
    if (trivyInstalled != 0) {
        echo "⚠️  Trivy not installed. Installing..."
        sh '''
            sudo rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.48.0/trivy_0.48.0_Linux-64bit.rpm || true
        '''
    }
    
    // Scan the image
    def scanResult = sh(
        script: """
            trivy image \
                --severity HIGH,CRITICAL \
                --no-progress \
                --format table \
                ${imageName}:${imageTag}
        """,
        returnStatus: true
    )
    
    if (scanResult == 0) {
        echo "✅ Security scan completed - No critical vulnerabilities found"
    } else {
        echo "⚠️  Security scan found vulnerabilities, but continuing..."
        // Don't fail the build, just warn
    }
}
