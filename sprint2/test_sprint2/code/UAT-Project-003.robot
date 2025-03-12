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

Change Language To Thai
    Click Element    id=navbarDropdownMenuLink
    Click Element    link=ไทย
    Wait Until Page Contains    หน้าหลัก
    Wait Until Page Contains    นักวิจัย
    Wait Until Page Contains    โครงการวิจัย
    Wait Until Page Contains    กลุ่มวิจัย
    Wait Until Page Contains    รายงาน
    Wait Until Page Contains    ไทย

Change Language To Chinese
    Click Element    id=navbarDropdownMenuLink
    Click Element    link=中文
    Wait Until Page Contains    首页
    Wait Until Page Contains    研究人员
    Wait Until Page Contains    研究项目
    Wait Until Page Contains    研究小组
    Wait Until Page Contains    报告
    Wait Until Page Contains    中文
	

Verify Thai Homepage
    Wait Until Page Contains    หน้าหลัก
    Wait Until Page Contains    นักวิจัย
    Wait Until Page Contains    โครงการวิจัย
    Wait Until Page Contains    กลุ่มวิจัย
    Wait Until Page Contains    รายงาน
    Wait Until Page Contains    ไทย
	Click Element    id=navbarDropdown
	Page Should Contain    สาขาวิชาวิทยาการคอมพิวเตอร์
	


*** Test Cases ***
TC1-Homepage English
    [Setup]  
    Open Homepage
    Sleep    2s

    # คลิกเมนูภาษาไทย
    Change Language To Thai
    Sleep    2s
	
TC2-Homepage Thai
    Verify Thai Homepage
    Sleep    2s
    [Teardown]  
    Close Browser
