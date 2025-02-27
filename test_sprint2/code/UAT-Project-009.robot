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
	
Click Research Project
	Click Element    xpath=//span[@class="menu-title" and text()="Research Project"]
	
Verify Research Project
	Page Should Contain		Research Project
	Page Should Contain		Project Name
	Page Should Contain		Research Group Head
	Page Should Contain		Member
	Page Should Contain		Action

Click research project thai language
	Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/th"]').click()
	
Click research project chinese language
	Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/zh"]').click()
	
Check thai
	Page Should Contain		ชื่อโครงการ
	Page Should Contain		หัวหน้า
	
Check zh
	Page Should Contain		研究项目
	Page Should Contain		项目名称
	
*** Test Cases ***
TC1-Homepage English
    Open Homepage
    Sleep    1s
	
TC2-Login
    Login
	
TC3-Verify English dashboard
    Verify English dashboard page

TC4-Click Research Project
	Click Research Project
	
TC5-Verify Research Project
	Verify Research Project
	
TC6-Click research project thai language
	Click research project thai language
	Check thai
	
TC7-Click research project chinese language
	Click research project chinese language
	Check zh