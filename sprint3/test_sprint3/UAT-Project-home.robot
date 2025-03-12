*** Settings ***
Documentation    Test suite for verifying translation on the home page including Banner image.
Library          SeleniumLibrary
Library          String
Test Teardown    Close Browser

*** Variables ***
${BROWSER}       Chrome
${URL}           https://csgroup568.cpkkuhost.com/
${WAIT_TIME}     5s

# ✅ Locator สำหรับ Dropdown และเมนูภาษา
${LANG_DROPDOWN}        xpath=//a[@id="navbarDropdownMenuLink"]
${LANG_TO_THAI}         xpath=//a[contains(text(), 'ไทย')]
${LANG_TO_ENGLISH}      xpath=//a[contains(text(), 'English')]
${LANG_TO_CHINESE}      xpath=//a[contains(text(), '中文')]

# ✅ คำที่ใช้ตรวจสอบว่าเปลี่ยนภาษาแล้ว
${EXPECTED_THAI_TEXT}    รายงานจำนวนบทความทั้งหมด (สะสมตลอด 5 ปี) 
${EXPECTED_ENGLISH_TEXT}    Report the total number of articles (5 years : cumulative)
${EXPECTED_CHINESE_TEXT}    报告总文章数 (5年累计)

@{EXPECTED_THAI_TEXTS}        
...    รายงานจำนวนบทความทั้งหมด (สะสมตลอด 5 ปี)    
...    สิ่งตีพิมพ์ (ในช่วง 5 ปีที่ผ่านมา)
...    ปี    
...    จำนวนบทความ    
...    ก่อน
...    [อ้างอิง]

@{EXPECTED_ENGLISH_TEXTS}       
...    Report the total number of articles (5 years : cumulative)   
...    Publications (In the Last 5 Years) 
...    year    
...    Number    
...    Before
...    [refer]

@{EXPECTED_CHINESE_TEXTS}       
...    报告总文章数 (5年累计)  
...    过去五年内的出版物  
...    年    
...    文章数量    
...    之前
...    [参考]

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Wait And Click
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}

Select Language
    [Arguments]    ${language_locator}    ${expected_text}
    Wait And Click    ${LANG_DROPDOWN} 
    Sleep    2s 
    Wait And Click    ${language_locator}  
    Wait Until Page Contains    ${expected_text}    timeout=10s  
    Reload Page  
    Sleep    2s 
    Wait Until Page Contains    ${expected_text}    timeout=10s  

Verify Page Contains Texts
    [Arguments]    @{expected_texts}
    ${html_source}=    Get Source
    Log    HTML Source: ${html_source}
    FOR    ${text}    IN    @{expected_texts}
        Should Contain    ${html_source}    ${text}
    END

Verify Banner For Language
    [Arguments]    ${lang_code}
    ${banner_src}=    Get Element Attribute    xpath=//div[@class="carousel-inner"]/div[1]/img    src
    Log    Banner src is: ${banner_src}
    Should Contain    ${banner_src}    /img/${lang_code}

*** Test Cases ***
English To Thai
    [Documentation]    Starting from English, switch to Thai and verify texts and banner.
    Open Browser To Home Page
    Sleep    ${WAIT_TIME}
    Verify Page Contains Texts    @{EXPECTED_ENGLISH_TEXTS}
    Verify Banner For Language    p1_en
    Select Language    ${LANG_TO_THAI}    ${EXPECTED_THAI_TEXT}
    Verify Page Contains Texts    @{EXPECTED_THAI_TEXTS}
    Verify Banner For Language    p1_th

English To Chinese
    [Documentation]    Starting from English, switch to Chinese and verify texts and banner.
    Open Browser To Home Page
    Sleep    ${WAIT_TIME}
    Verify Page Contains Texts    @{EXPECTED_ENGLISH_TEXTS}
    Verify Banner For Language    p1_en
    Select Language    ${LANG_TO_CHINESE}    ${EXPECTED_CHINESE_TEXT}
    Verify Page Contains Texts    @{EXPECTED_CHINESE_TEXTS}
    Verify Banner For Language    p1_cn
