# bugsnap-iOS

An iOS Library enabling users to report bugs directly from their mobile device.

# Integration

After you integrate the source code of the framework **bugsnap** you only need to setup your own parameters for connecting to JIRA and enable the shake gesture detection. In order to do that, you need to add the folllowing lines (it's preferrable in the AppDelegate):

`
import BugSnap

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    ...
    // Enable the shake gesture through UIApplication extension
    UIApplication.shared.enableShakeGestureSnap()
    ...
}
`

For configuring your connection with JIRA there're a few ways to achieve it:

1) Hard coding the connection URL and provide the credentials at runtime with the login form presented when you try to upload a ticket to JIRA:

`
import BugSnap
...

// At the application delegate 
// Configure your server here
JIRARestAPI.sharedInstance.serverURL = URL(string:"#put your jira server here")

// When the form appears, provide you user/API Token for JIRA
...
`

2) Hard coding the connection URL and the credentials in your source code. The API Key is generated in [JIRA API Tokens](https://id.atlassian.com/manage/api-tokens)

`
import BugSnap
...
// At the application delegate 
// Configure your server here
JIRARestAPI.sharedInstance.serverURL = URL(string:"#put your jira server here")
// Setup your credentails here
JIRARestAPI.sharedInstance.setupConnection(userName: "#your user email for JIRA", apiToken: "#Your API Key")
`

3) Use the Info.plist file for your build and setup the following lines (as strings):

JIRA.URL  = '#Your JIRA server'
JIRA.User = '#Your JIRA email for authentication'
JIRA.APIKey = '#Your JIRA API Token key'

Once you setup these keys in the Info.plist, you need to instruct the library to load them from there; achieving this is easy with the following line:

`
import BugSnap

...
// At the application delegate 
do {
    try JIRARestAPI.sharedInstance.loadConnectionParameters()
}
catch{
    print("Error while configuring JIRA connection \(error)")
}
...
`

In any case you'll be prompted with the user name/ api token to confirm the credentials and it will try to ping the projects names (fetching only one) in order to verify everything was successfully setup.

# Distribution
  * You need the Distribution Certificate in order to create a distribution build
  * Install fastlane by follow the [fastlane installation instructions](fastlane/README.md)
  * You have to add APPLE_ID to your environment (~/.bash_profile): `export APPLE_ID=user@domain.com`
  * See distrbution options by running `fastlane list`

