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
    Sleep    2s  # Sleep added for waiting for the menu to load
	
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
	
Verify English dashboard page
    Wait Until Page Contains    Welcome to the Research Information Management System
    Wait Until Page Contains    Computer Science Department

Click Manage Fund
	Click Element    xpath=//span[@class="menu-title" and text()="Manage Fund"]

Verify Manage Fund
	Page Should Contain		Research Fund
	Page Should Contain		No.
	Page Should Contain		Fund Name
	Page Should Contain		Fund Type
	Page Should Contain		Fund Level
	Page Should Contain		Action
	Page Should Contain		Internal Capital
	Page Should Contain		Unknown
	Page Should Contain		การออกแบบและพัฒนาระบบการเรียนรู้การเขียนโปรแกรมแบบคู่ด้วยอาลิซ

Click manage fund thai language
    Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/th"]').click()

Click manage fund chinese language
    Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/zh"]').click()

Click manage fund english language
    Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/en"]').click()


*** Test Cases ***
TC1-Homepage English
    Open Homepage
    Sleep    1s
	
TC2-Login
    Login

TC3-Verify English dashboard
    Verify English dashboard page

TC4-Click manage fund
    Click Manage Fund
	
TC5-Veryfy manage fund
	Verify Manage Fund
	
TC6-Click manage fund thai language
	Click manage fund thai language

TC7-Click manage fund chinese language
	Click manage fund chinese language

TC8-Click manage fund english language
	Click manage fund english language

	
