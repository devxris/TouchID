# TouchID
LocalAuthentication: Login in with TouchID  
1. Get LAContext()  
2. Check if the device supports TouchID by canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)  
3. localAuthContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason:) { (success, error) in 
    switch error {
       case: LAErro.xxreason
    }
}  
