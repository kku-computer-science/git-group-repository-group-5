*** Settings ***   
Library          SeleniumLibrary
Test Teardown    Close Browser

*** Variables ***
${BROWSER}           chrome
${HOME_URL}          https://csgroup568.cpkkuhost.com/
${WAIT_TIME}        3s

# ตัวแปรสำหรับเมนู Report
${REPORT_MENU}       xpath=//a[contains(@href, '/reports')]

# ตัวแปรสำหรับ dropdown เปลี่ยนภาษา (ใช้ id จาก element ใน Blade)
${LANG_DROPDOWN_TOGGLE}    xpath=//a[@id="navbarDropdownMenuLink"]

# เปลี่ยนภาษา (ตัวเลือกใน dropdown)
${LANG_TO_THAI}       xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), 'ไทย')]
${LANG_TO_ENGLISH}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), 'English')]
${LANG_TO_CHINESE}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), '中文')]

# ตรวจสอบข้อความทั่วไปของหน้า Report
@{EXPECTED_REPORT_EN}    
...    Statistics on the total number of articles for 5 years    
...    Statistics on the number of articles that have been cited    
...    source
@{EXPECTED_REPORT_TH}    
...    สถิติจำนวนบทความทั้งหมด 5 ปี    
...    สถิติจำนวนบทความที่ได้รับการอ้างอิง    
...    แหล่งที่มา
@{EXPECTED_REPORT_CN}    
...    过去五年内文章总数统计  
...    引用文章数统计    
...    来源

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${HOME_URL}    ${BROWSER}
    Maximize Browser Window

Wait And Click
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}

Navigate To Report Page
    # คลิกเมนู Report
    Click Element    ${REPORT_MENU}
    # รอจนกว่าหน้า Report จะมีข้อความ "Report" (default เป็นภาษาอังกฤษ)
    Wait Until Page Contains    Report    10s

Verify Page Contains Multiple Texts
    [Arguments]    @{expected_texts}
    ${html_source}=    Get Source
    Log    HTML Source: ${html_source}
    FOR    ${text}    IN    @{expected_texts}
        Should Contain    ${html_source}    ${text}
    END

Switch Language And Verify
    [Arguments]    ${lang_button}    @{expected_texts}
    # คลิกเปิด dropdown เพื่อแสดงตัวเลือกภาษาที่ต้องการ
    Click Element    ${LANG_DROPDOWN_TOGGLE}
    Sleep    1s
    # ลองคลิกตัวเลือกภาษาที่ต้องการ (ใช้ Run Keyword And Ignore Error หากไม่พบ)
    Run Keyword And Ignore Error    Click Element    ${lang_button}
    Sleep    3s
    Verify Page Contains Multiple Texts    @{expected_texts}

*** Test Cases ***
Navigate To Report Page And Switch To Chinese
    Open Browser To Home Page
    Navigate To Report Page
    Switch Language And Verify    ${LANG_TO_CHINESE}    @{EXPECTED_REPORT_CN}
    Close Browser

Navigate To Report Page And Switch To English
    Open Browser To Home Page
    Navigate To Report Page
    # แม้ว่าเว็บจะเปิดมาเป็นภาษาอังกฤษอยู่แล้ว ให้กด dropdown เพื่อยืนยัน
    Switch Language And Verify    ${LANG_TO_ENGLISH}    @{EXPECTED_REPORT_EN}
    Close Browser

Navigate To Report Page And Switch To Thai
    Open Browser To Home Page
    Navigate To Report Page
    Switch Language And Verify    ${LANG_TO_THAI}    @{EXPECTED_REPORT_TH}
    Close Browser
