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

Verify Thai Homepage
    Wait Until Page Contains    หน้าหลัก
    Wait Until Page Contains    นักวิจัย
    Wait Until Page Contains    โครงการวิจัย
    Wait Until Page Contains    กลุ่มวิจัย
    Wait Until Page Contains    รายงาน
    Wait Until Page Contains    ไทย
	Click Element    id=navbarDropdown
	Page Should Contain    สาขาวิชาวิทยาการคอมพิวเตอร์

Login
    Click Element    xpath=//a[contains(@class, 'btn-solid-sm') and contains(text(), 'เข้าสู่ระบบ')]
    Sleep    2s  
    ${handles}=    Get Window Handles  
    Switch Window    ${handles}[-1]  
	Page Should Contain		เข้าสู่ระบบบัญชี
	Page Should Contain		ชื่อผู้ใช้
	Page Should Contain		รหัสผ่าน
    Input Text    id=username    admin@gmail.com
    Input Text    id=password    12345678
    Click Button  xpath=//button[@type='submit']
    Sleep    3s  # Sleep added to allow time for login

Check thai dashboard
	Page Should Contain		ระบบจัดการข้อมูลการวิจัย
	Page Should Contain		ยินดีต้อนรับเข้าสู่ระบบจัดการข้อมูลวิจัยของสาขาวิชาวิทยาการคอมพิวเตอร์
	Page Should Contain		ผู้ดูแล
	Page Should Contain		แดชบอร์ด
	Page Should Contain		โปรไฟล์ผู้ใช้
	Page Should Contain		จัดการทุน
	Page Should Contain		โครงการวิจัย
	Page Should Contain		กลุ่มวิจัย
	Page Should Contain		จัดการผลงานวิจัย
	Page Should Contain		ผู้ใช้
	Page Should Contain		บทบาท
	Page Should Contain		สิทธิ์
	Page Should Contain		แผนก
	Page Should Contain		จัดการโปรแกรม

	

*** Test Cases ***
TC1-Homepage English
	Open Homepage
	Sleep    2s

TC2-Change to thai
	Change Language To Thai
	Verify Thai Homepage

TC3-Login with thai
	Login
	
TC4-Check thai dashboard
	Check thai dashboard