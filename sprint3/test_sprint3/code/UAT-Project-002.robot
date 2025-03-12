*** Settings *** 
Documentation    Test suite for verifying dropdown functionality under "Researchers" and language switching
Library          SeleniumLibrary
Library          String
Test Teardown    Close Browser

*** Variables ***
${BROWSER}       Chrome
${URL}           https://csgroup568.cpkkuhost.com/
${WAIT_TIME}     5s

# ✅ Locator สำหรับ Dropdown Researchers
${RESEARCHERS_MENU}       xpath=//a[@id="navbarDropdown"]
${RESEARCHERS_DROPDOWN}   xpath=//ul[@aria-labelledby='navbarDropdown' and contains(@class, 'dropdown-menu')]

# ✅ Locator สำหรับ Dropdown ภาษา
${LANG_DROPDOWN}        xpath=//a[@id="navbarDropdownMenuLink"]
${LANG_TO_THAI}         xpath=//a[contains(text(), "ไทย")]
${LANG_TO_ENGLISH}      xpath=//a[contains(text(), "English")]
${LANG_TO_CHINESE}      xpath=//a[contains(text(), "中文")]

# ✅ เมนู Researchers แยกตามภาษา
@{EXPECTED_DROPDOWN_THAI}        
...    สาขาวิชาวิทยาการคอมพิวเตอร์
...    สาขาวิชาเทคโนโลยีสารสนเทศ
...    สาขาวิชาภูมิสารสนเทศศาสตร์ 

@{EXPECTED_DROPDOWN_ENGLISH}       
...    Computer Science    
...    Information Technology    
...    Geo-Informatics    

@{EXPECTED_DROPDOWN_CHINESE}       
...    计算机科学
...    信息技术系
...    地理信息学系

# ✅ ข้อความที่ต้องตรวจสอบบนหน้าเว็บแต่ละภาษา
@{EXPECTED_THAI_TEXTS}         
...    หน้าหลัก    
...    นักวิจัย
...    โครงการวิจัย    
...    กลุ่มวิจัย    
...    รายงาน
...    เข้าสู่ระบบ
...    สาขาวิชาวิทยาการคอมพิวเตอร์
...    สาขาวิชาเทคโนโลยีสารสนเทศ
...    สาขาวิชาภูมิสารสนเทศศาสตร์ 

@{EXPECTED_ENGLISH_TEXTS}       
...    Home   
...    Researchers 
...    Research Project    
...    Research Group    
...    Report
...    LOGIN
...    Computer Science
...    Information Technology
...    Geo-Informatics

@{EXPECTED_CHINESE_TEXTS}       
...    首页  
...    研究人员 
...    研究项目    
...    研究小组    
...    报告
...    登录
...    计算机科学
...    信息技术系
...    地理信息学系

# ✅ ใช้ Dictionary เพื่อเก็บค่าของแต่ละภาษา
&{EXPECTED_TEXTS}
...    th=@{EXPECTED_THAI_TEXTS}
...    en=@{EXPECTED_ENGLISH_TEXTS}
...    zh=@{EXPECTED_CHINESE_TEXTS}

&{EXPECTED_DROPDOWN}
...    th=@{EXPECTED_DROPDOWN_THAI}
...    en=@{EXPECTED_DROPDOWN_ENGLISH}
...    zh=@{EXPECTED_DROPDOWN_CHINESE}

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Wait And Click
    [Arguments]    ${locator}
    Scroll Element Into View    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}

Select Language And Verify
    [Arguments]    ${lang_code}    ${lang_locator}
    # หากไม่ใช่ภาษาอังกฤษ (default) ให้ทำการเปลี่ยนภาษา
    IF  '${lang_code}' != 'en'
        Scroll Element Into View    ${LANG_DROPDOWN}
        Wait And Click    ${LANG_DROPDOWN}
        Sleep    2s
        Wait And Click    ${lang_locator}
        Wait Until Page Contains    ${EXPECTED_TEXTS}[${lang_code}][0]    timeout=10s
        Reload Page
        Sleep    3s
    END
    Verify Page Contains Texts    @{EXPECTED_TEXTS}[${lang_code}]
    Verify Researchers Dropdown    @{EXPECTED_DROPDOWN}[${lang_code}]

Verify Researchers Dropdown
    [Arguments]    @{expected_items}
    Wait And Click    ${RESEARCHERS_MENU}
    Wait Until Element Is Visible    ${RESEARCHERS_DROPDOWN}    timeout=10s
    ${dropdown_state}=    Get Element Attribute    ${RESEARCHERS_MENU}    aria-expanded
    Should Be Equal As Strings    ${dropdown_state}    true
    Sleep    2s
    ${html_source}=    Get Source
    Log    HTML Source: ${html_source}
    FOR    ${item}    IN    @{expected_items}
        Run Keyword And Continue On Failure    Should Contain    ${html_source.lower()}    ${item.lower()}
    END

Verify Page Contains Texts
    [Arguments]    @{expected_texts}
    Sleep    2s
    ${html_source}=    Get Source
    Log    HTML Source: ${html_source}
    Log To Console    *** Checking for expected texts: ${expected_texts} ***
    FOR    ${text}    IN    @{expected_texts}
        Run Keyword And Continue On Failure    Should Contain    ${html_source.lower()}    ${text.lower()}
    END

*** Test Cases ***

## test droup
Test Researchers Dropdown In English
    [Documentation]    เปลี่ยนภาษาเป็นอังกฤษแล้วตรวจสอบเมนู Researchers และข้อความในหน้าเว็บ
    Open Browser To Home Page
    Sleep    ${WAIT_TIME}
    Select Language And Verify    en    ${LANG_TO_ENGLISH}

Test Researchers Dropdown In Thai
    [Documentation]    เปลี่ยนภาษาเป็นไทยแล้วตรวจสอบเมนู Researchers และข้อความในหน้าเว็บ
    Open Browser To Home Page
    Sleep    ${WAIT_TIME}
    Select Language And Verify    th    ${LANG_TO_THAI}

Test Researchers Dropdown In Chinese
    [Documentation]    เปลี่ยนภาษาเป็นจีนแล้วตรวจสอบเมนู Researchers และข้อความในหน้าเว็บ
    Open Browser To Home Page
    Sleep    ${WAIT_TIME}
    Select Language And Verify    zh    ${LANG_TO_CHINESE}




