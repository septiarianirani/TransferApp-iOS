//
//  LoginTests.swift
//  OCBC MobileTests
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import XCTest
@testable import OCBC_Mobile

class LoginTests: XCTestCase {

    var loginUnitTest: LoginDataModel!
    let username = "test"
    let password = "asdasd"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        loginUnitTest = nil
    }
    
    func testLoginDataModelStruct() {
        loginUnitTest = LoginDataModel(username: username, password: password)
        
        XCTAssertNotNil(loginUnitTest)
    }
    
    func testLoginWithoutUsername() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let _ = vc.view
        
        vc.usernameField.text = ""
        vc.loginBtnDidPressed()
        
        XCTAssertFalse(vc.usernameErrLabel.isHidden)
        XCTAssertEqual("Username is required", vc.usernameErrLabel.text)
    }
    
    func testLoginWithUsernameWithoutPassword() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let _ = vc.view
        
        vc.usernameField.text = username
        vc.passwordField.text = ""
        vc.loginBtnDidPressed()
        
        XCTAssertFalse(vc.passwordErrLabel.isHidden)
        XCTAssertEqual("Password is required", vc.passwordErrLabel.text)
    }
    
    func testLoginWithUsernameWithPassword() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let _ = vc.view
        
        vc.usernameField.text = username
        vc.passwordField.text = password
        vc.loginBtnDidPressed()
        
        XCTAssertTrue(!vc.usernameErrLabel.isHidden && !vc.passwordErrLabel.isHidden)
        XCTAssertEqual("", vc.usernameErrLabel.text)
        XCTAssertEqual("", vc.passwordErrLabel.text)
    }

}
