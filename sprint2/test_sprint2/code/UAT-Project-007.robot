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
	
Verify English User Profile Page
    Wait Until Page Contains    Welcome to the Research Information Management System
    Wait Until Page Contains    Computer Science Department	

Click User Profile
    Click Element    xpath=//span[@class="menu-title" and text()="User Profile"]
	
Verify English User Profile
    Page Should Contain		Account
    Page Should Contain		Password
	
Click dashboard thai language
    Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/th"]').click()
	
Verify Thai User Profile
    Page Should Contain		บัญชีผู้ใช้
    Page Should Contain		รหัสผ่าน
	
Click dashboard chinese language
    Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/zh"]').click()
	
Verify Chinese User Profile
    Page Should Contain		账户
    Page Should Contain		密码
	
*** Test Cases ***
TC1-Homepage English
    Open Homepage
    Sleep    1s
	
TC2-Login
    Login
	
TC3-Verify English User
    Verify English User Profile Page
	
TC4-Click user profile
    Click User Profile
   
TC5-Click change language to thai
    Click dashboard thai language
    Sleep    3s

TC6-Verify Thai User Profile
    Verify Thai User Profile
	
TC7-Click change language to chinese
    Click dashboard chinese language
	Sleep 	3s
	
TC8-Verify Chinese User Profile
    Verify Chinese User Profile
