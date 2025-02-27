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
	Click Element    xpath=//span[@class="menu-title" and text()="Research Group"]
	
Verify Research Group
	Page Should Contain		Research Groups
	Page Should Contain		No.
	Page Should Contain		Group name (Thai)
	Page Should Contain		Research group head
	Page Should Contain		Member
	Page Should Contain		Pipat
	Page Should Contain		Chaiyapon
	
Click research group thai language
	Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/th"]').click()
	
Click research group chinese language
	Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/zh"]').click()
	
Click research group english language
	Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/en"]').click()
	
Check thai
	Page Should Contain		กลุ่มวิจัย
	Page Should Contain		ชื่อกลุ่มวิจัย

Check zh
	Page Should Contain		研究小组
	Page Should Contain		小组名称

*** Test Cases ***
TC1-Homepage English
    Open Homepage
    Sleep    1s
	
TC2-Login
    Login

TC3-Verify English dashboard
    Verify English dashboard page

TC4-Click Manage Fund
	Click Manage Fund

TC5-Verify Research Group
	Verify Research Group

TC6-Click research group thai language
	Click research group thai language
	Check thai
	
TC7-Click research group chinese language
	Click research group chinese language
	Check zh