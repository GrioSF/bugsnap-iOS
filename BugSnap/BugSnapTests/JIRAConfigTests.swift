//
//  JIRAConfigTests.swift
//  JIRAConfigTests
//  Test the configuration of JIRA parameters
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import XCTest
@testable import BugSnap

class JIRAConfigTests: XCTestCase {


    /// Tests the user name and api token get saved in UserDefaults in this method
    func testSetupConnection() {
        let testUser = "test-user"
        let apiToken = "dummy-token"
        JIRARestAPI.sharedInstance.setupConnection(userName: testUser, apiToken: apiToken)
        assert(UserDefaults.standard.jiraUserName == testUser)
        assert(UserDefaults.standard.jiraApiToken == apiToken)
    }
    
    /// Tests that setting up the URL in the shared instance sets it as a base as the initial attachment request
    func testURL() {
        let dummyURL = "http://somedomain.org"
        JIRARestAPI.sharedInstance.serverURL = URL(string: dummyURL)
        assert(JIRARestAPI.sharedInstance.serverURL.absoluteString == dummyURL)
    }
    
    /// Tests the pingProjectCall with dummy parameters resulting in an error
    func testFailedPingProject() {
        let dummyURL = "http://somedomain.org"
        let apiToken = "dummy-token"
        let testUser = "test-user"
        var responseErrors = [String]()
        let errorExpectation = expectation(description: "errors")
        JIRARestAPI.sharedInstance.setupConnection(userName: testUser, apiToken: apiToken)
        JIRARestAPI.sharedInstance.serverURL = URL(string: dummyURL)
        
        JIRARestAPI.sharedInstance.pingProjectCall { (errors) in
            
            if errors != nil {
                responseErrors.append(contentsOf: errors!)
            }
            errorExpectation.fulfill()
        }
        wait(for: [errorExpectation], timeout: 5.0)
        assert(responseErrors.count > 0 )
    }
    
    /// Tests that loadConnectionParameters throws an error since it doesn't have the Info.plist keys set correctly
    func testFailedConfiguration() {
        XCTAssertThrowsError(try JIRARestAPI.sharedInstance.loadConnectionParameters())
    }

}
