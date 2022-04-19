Designed with an UI as per request, however it is kept basic in design.




To start with UI: 

-Open Powershell as admin

-Navigate to the Menu-ITOM directory.

	E.g:

	cd C:\Menu-ITOM\


-Initialize the Menu-ITOM.ps1 script like bellow:

	.\Menu-ITOM.ps1
	
	

Can also be used without the UI however it is limited to the main functionality (no need for them to be outside of UI really). Execute required .ps1 script individually from the /scripts folder.




Full functionality:


-Add an SSL certificate to a java truststore either by automatically downloading the certificate from the URL, or by downloading manually. 

-Enable Basic Auth for JBoss WEb Service and set up the credentials

-Change the password for a Agent Web Service and modify all the required depedencies to support non-default passwords

-Show .war files deployment status with refresh (Requires UI to use)

-Start-stop services required for ITOM (Requires UI to use)

-Save all existing logs to desktop location (Requires UI to use)

-test connection and credentials for both Web Services.


