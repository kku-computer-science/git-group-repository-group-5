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
	
Click Manage Publications
	Click Element    xpath=//span[@class="menu-title" and text()="Manage Publications"]
	
Click Published Research
	Click Element   xpath=//*[@id="ManagePublications"]/ul/li[1]/a
	
Verify Research Project
	Page Should Contain		Published Research
	Page Should Contain		Paper Name
	
Click publication thai language
	Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/th"]').click()
	
Click publication chinese language
	Execute JavaScript    document.querySelector('a[href="https://csgroup568.cpkkuhost.com/lang/zh"]').click()
	
Check thai
	Page Should Contain		งานวิจัยที่ตีพิมพ์
	Page Should Contain		ชื่อเรื่อง
	
Check zh
	Page Should Contain		已发表研究
	Page Should Contain		论文名
	
*** Test Cases ***
TC1-Homepage English
    Open Homepage
    Sleep    1s
	
TC2-Login
    Login
	
TC3-Verify English dashboard
    Verify English dashboard page
	
TC4-Click Manage Publications
	Click Manage Publications

TC5-Click Published Research
	Click Published Research

TC6-Verify Research Project
	Verify Research Project
	
TC7-Click publication thai language
	Click publication thai language
	Check thai
	
TC8-Click publication chinese language
	Click publication chinese language
	Check zh