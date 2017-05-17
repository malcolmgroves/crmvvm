pipeline {
  agent any
  environment {
    BDS = "C:\\PROGRA~2\\EMBARC~1\\Studio\\19.0"
  }
  stages {
    stage('Build') {
      steps {
        bat "C:\\Windows\\Microsoft.NET\\Framework\\v3.5\\msbuild.exe /v:diag /p:DCC_BuildAllUnits=true /p:config=Release src\\projects\\CRMVVM.dproj"
      }
    }
    stage('Unit Test') {
      steps {
        bat "C:\\Windows\\Microsoft.NET\\Framework\\v3.5\\msbuild.exe /v:diag /p:DCC_BuildAllUnits=true /p:config=Debug src\\projects\\CRMVVMTests.dproj"
        bat "bin\\Win32\\Debug\\CRMVVMTests.exe"
      }
    }
  }
  post {
    always {
      archive 'bin\\Win32\\Release\\CRMVVM.exe'
      nunit testResultsPattern: '**\\bin\\Win32\\Debug\\dunitx-results.xml'
    }
  }
}