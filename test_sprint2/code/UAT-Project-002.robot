*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${SERVER}    https://csgroup568.cpkkuhost.com/
${CHROME_BROWSER_PATH}    E:/Software Engineering/LAB7/ChromeDriverANDChromeTesting/chrome.exe
${CHROME_DRIVER_PATH}     E:/Software Engineering/LAB7/ChromeDriverANDChromeTesting/chromedriver.exe
${BROWSER}                Chrome

*** Keywords ***
Open Homepage
    Open Browser   ${SERVER}  Chrome
	Maximize Browser Window
    Wait Until Page Contains    Home
    Wait Until Page Contains    Researcher
    Wait Until Page Contains    Research Project
    Wait Until Page Contains    Research Group
    Wait Until Page Contains    Report
    Wait Until Page Contains    English
    Click Element    id=navbarDropdown
    Page Should Contain    Computer Science
    Sleep   1s  # Sleep added for waiting for the menu to load
	
Login
    Click Element    xpath=//a[contains(@class, 'btn-solid-sm') and contains(text(), 'Login')]
    Sleep    1s  
    ${handles}=    Get Window Handles  
    Switch Window    ${handles}[-1]  
	Page Should Contain		Account Login
	Page Should Contain		Username
	Page Should Contain		Password
    Input Text    id=username    admin@gmail.com
    Input Text    id=password    12345678
    Click Button  xpath=//button[@type='submit']
    Sleep    3s  # Sleep added to allow time for login

Verify English Dashboard Page
	Wait Until Page Contains    Welcome to the Research Information Management System
	Wait Until Page Contains    Computer Science Department
	Wait Until Page Contains    Hello admin

	
*** Test Cases ***
TC1-Homepage English
	Open Homepage
	Sleep    1s
	
TC2-Login with english
	Login
	
