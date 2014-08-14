Hello-OBP-OAuth1.0a-Mac
========================

This is a basic app to demonstrate the integration of the OpenBankProject with OAuth1.0-Authentication into an OS X application. The app will run through OAuth authentication, and then make an OAuth signed API request that retrieves the list of [private accounts](https://github.com/OpenBankProject/OBP-API/wiki/REST-API-V1.2#accounts-private) on the sandbox API and show them in the UI (see below for example accounts to log in). 

You can then use this demonstration as an example of how to use the Open Bank Project (OBP) API to create apps that allow user to access to their bank data, and create Banking, Accounting, ERM, or other financial applications utilizing this OBP JSON API. Documentation about the latest OBP API specifications here: [Version: 1.2.1](https://github.com/OpenBankProject/OBP-API/wiki/REST-API-V1.2.1)

Though this particular API call does not require OAuth, this project uses OAuth to do so anyways, in order to demonstrate the process. 


Current list of supported banks:  [https://api.openbankproject.com/connectors-status/](https://api.openbankproject.com/connectors-status/)

## SETUP

If you want to work with your own credentials, there are a couple of things you need to do to get this project set up.

1. Get consumer key / secret:  
-register your client at  https://apisandbox.openbankproject.com/consumer-registration

2. Enter your app's your of register:  
-set OAUTH_CONSUMER_KEY, OAUTH_CONSUMER_SECRET_KEY and OAUTH_URL_SCHEME (yourappname) in OAuth.m

3. Add your callback URL scheme to your app's (yourappname) `Info.plist` file (in the URL types field).

## Login credentials

You will need to login to the OBP Sandbox API (unless you change the API instance) when running the app. This can be done using any the following credentials:

username: joe.bloggs@example.com
password: qwerty

username: jane.bloggs@example.com
password: qwerty

username: john.bloggs@example.com
password: qwerty

## LICENSE

This project is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).
