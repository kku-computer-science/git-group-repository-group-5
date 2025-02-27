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
	Sleep    2s

Change Language To Chinese
    Click Element    id=navbarDropdownMenuLink
    Click Element    link=中文
    Wait Until Page Contains    首页
    Wait Until Page Contains    研究人员
    Wait Until Page Contains    研究项目
    Wait Until Page Contains    研究小组
    Wait Until Page Contains    报告
    Wait Until Page Contains    中文
	
Verify Chinese Homepage
    Wait Until Page Contains    首页
    Wait Until Page Contains    研究人员
    Wait Until Page Contains    研究项目
    Wait Until Page Contains    研究小组
    Wait Until Page Contains    报告
    Wait Until Page Contains    中文
	Click Element    id=navbarDropdown
	Page Should Contain		计算机科学
	
*** Test Cases ***
TC1-Homepage English
	Open Homepage
	Sleep    2s

TC2-Change to chinese
	Change Language To Chinese
	Verify Chinese Homepage
	Sleep    2s