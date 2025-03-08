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

Change Language To Chinese
    Click Element    id=navbarDropdownMenuLink
    Click Element    link=中文
    Wait Until Page Contains    首页
    Wait Until Page Contains    研究人员
    Wait Until Page Contains    研究项目
    Wait Until Page Contains    研究小组
    Wait Until Page Contains    报告
    Wait Until Page Contains    中文
	
Verify Chinese Dashboard
    Wait Until Page Contains    首页
    Wait Until Page Contains    研究人员
    Wait Until Page Contains    研究项目
    Wait Until Page Contains    研究小组
    Wait Until Page Contains    报告
    Wait Until Page Contains    中文
	Click Element    id=navbarDropdown
	Page Should Contain		计算机科学
	
Login
    Click Element    xpath=//a[contains(@class, 'btn-solid-sm') and contains(text(), '登录')]
    Sleep    2s  
    ${handles}=    Get Window Handles  
    Switch Window    ${handles}[-1]  
	Page Should Contain		账户登录
	Page Should Contain		用户名
	Page Should Contain		密码
    Input Text    id=username    admin@gmail.com
    Input Text    id=password    12345678
    Click Button  xpath=//button[@type='submit']
    Sleep    3s  # Sleep added to allow time for login

Check chinese dashboard
	Page Should Contain		研究信息管理系统
	Page Should Contain		欢迎来到计算机科学系的研究信息管理系统
	Page Should Contain		你好
	Page Should Contain		仪表板
	Page Should Contain		用户资料
	Page Should Contain		管理资金
	Page Should Contain		研究项目
	Page Should Contain		研究小组
	Page Should Contain		用户
	Page Should Contain		角色
	Page Should Contain		管理程序
	
*** Test Cases ***
TC1-Homepage English
	Open Homepage
	Sleep    2s

TC2-Change to chinese
	Change Language To Chinese
	Verify Chinese Dashboard

TC3-Login with chinese
	Login
	
TC4-Check chinese dashboard
	Check chinese dashboard