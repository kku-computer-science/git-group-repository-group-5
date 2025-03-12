*** Settings ***  
Documentation    Test suite for verifying language switching functionality on the Research Group page.
Library          SeleniumLibrary
Library          String
Test Teardown    Close Browser

*** Variables ***
${BROWSER}    chrome
${URL}        https://csgroup568.cpkkuhost.com/researchgroup  
${WAIT_TIME}  3s

# Research Group Name (AGT)
${EXPECTED_GROUPNAME_TH}    เทคโนโลยี GIS ขั้นสูง (AGT)
${EXPECTED_GROUPNAME_EN}    Advanced GIS Technology (AGT)
${EXPECTED_GROUPNAME_CN}    高级 GIS 技术 （AGT）

# Research Group Description (AGT)
${EXPECTED_GROUPDESC_TH}    เพื่อดำเนินการวิจัยและให้บริการวิชาการในสาขาอินเทอร์เน็ต GIS สุขภาพ GIS และแบบจำลองทางอุทกวิทยาด้วย GIS
${EXPECTED_GROUPDESC_EN}    To conduct research and provide academic services in the fields of Internet, GIS, Health GIS, and Hydrologic modeling with GIS.
${EXPECTED_GROUPDESC_CN}    使用 GIS 在 Internet GIS、GIS 健康和水文建模领域进行研究并提供学术服务

@{EXPECTED_GROUPDETAIL_TH}    
...    เพื่อดำเนินการวิจัยและให้บริการวิชาการในสาขาอินเทอร์เน็ต GIS สุขภาพ GIS และแบบจำลองทางอุทกวิทยาด้วย GIS
...    นักศึกษา

@{EXPECTED_GROUPDETAIL_EN}    
...    To conduct research and provide academic services in the fields of Internet, GIS, Health GIS, and Hydrologic modeling with GIS.
...    Student

@{EXPECTED_GROUPDETAIL_CN}   
...    使用 GIS 在 Internet GIS、GIS 健康和水文建模领域进行研究并提供学术服务
...    学生

# Project Supervisor
@{EXPECTED_LABSUPERVISOR_TH}    
...    ผศ.ดร. พิพัธน์ เรืองแสง
...    รศ.ดร. ชัยพล กีรติกสิกร        
...    ผศ.ดร. ณกร วัฒนกิจ

@{EXPECTED_LABSUPERVISOR_EN}    
...    Asst. Prof. Pipat Reungsang, Ph.D.    
...    Assoc. Prof. Chaiyapon Keeratikasikorn, Ph.D.    
...    Asst. Prof. Nagon Watanakij, Ph.D.

@{EXPECTED_LABSUPERVISOR_CN}    
...    Asst. Prof. Pipat Reungsang, Ph.D.    
...    Assoc. Prof. Chaiyapon Keeratikasikorn, Ph.D.    
...    Asst. Prof. Nagon Watanakij, Ph.D.

# Expected Static Texts (Header ของหน้า)
@{EXPECTED_THAI_TEXTS}    
...    กลุ่มวิจัย    
...    หัวหน้าห้องปฏิบัติการ    
...    ข้อมูลเพิ่มเติม

@{EXPECTED_ENGLISH_TEXTS}    
...    Research Group    
...    Laboratory Supervisor    
...    More details

@{EXPECTED_CHINESE_TEXTS}    
...    研究小组    
...    实验室负责人    
...    更多详情

# Language Switchers (จาก dropdown)
${LANG_DROPDOWN_TOGGLE}    xpath=//a[@id="navbarDropdownMenuLink"]
${LANG_TO_THAI}       xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(., 'ไทย')]
${LANG_TO_ENGLISH}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(., 'English')]
${LANG_TO_CHINESE}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(., '中文')]

*** Keywords ***
Open Browser To Research Group Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Wait And Click
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}

Switch Language From Dropdown
    [Arguments]    ${lang_locator}
    # คลิกปุ่ม dropdown เพื่อแสดงตัวเลือกภาษา
    Wait Until Element Is Visible    ${LANG_DROPDOWN_TOGGLE}    timeout=10s
    Click Element    ${LANG_DROPDOWN_TOGGLE}
    Sleep    1s
    # รอให้ตัวเลือกภาษาปรากฏ แล้วคลิกเลือกภาษาที่ต้องการ
    Wait Until Element Is Visible    ${lang_locator}    timeout=10s
    Click Element    ${lang_locator}
    Sleep    ${WAIT_TIME}

Verify Page Contains Texts
    [Arguments]    @{expected_texts}
    ${html_source}=    Get Source
    Log    HTML Source: ${html_source}
    FOR    ${text}    IN    @{expected_texts}
        Should Contain    ${html_source}    ${text}
    END

Click More Details
    Wait Until Element Is Visible    xpath=//a[contains(@href, 'researchgroupdetail')]    timeout=10s
    Click Element    xpath=//a[contains(@href, 'researchgroupdetail')]
    Sleep    ${WAIT_TIME}

Verify Research Group Name
    [Arguments]    ${expected_group_name}
    Wait Until Element Is Visible    xpath=//h5[contains(text(), '${expected_group_name}')]    timeout=10s
    ${actual_group_name}=    Get Text    xpath=//h5[contains(text(), '${expected_group_name}')]
    Should Be Equal    ${actual_group_name}    ${expected_group_name}

Verify Research Group Description
    [Arguments]    ${expected_group_desc}
    Wait Until Element Is Visible    xpath=//h3[contains(text(), '${expected_group_desc}')]    timeout=10s
    ${actual_group_desc}=    Get Text    xpath=//h3[contains(text(), '${expected_group_desc}')]
    Should Contain    ${actual_group_desc}    ${expected_group_desc}

Verify Project Supervisor
    [Arguments]    @{expected_supervisors}
    ${actual_supervisors}=    Get Text    xpath=//h2[@class='card-text-2']
    Log    Actual Supervisors: ${actual_supervisors}
    FOR    ${supervisor}    IN    @{expected_supervisors}
        Should Contain    ${actual_supervisors}    ${supervisor}
    END

Verify Research Group Detail
    [Arguments]    @{expected_group_detail}
    Sleep    ${WAIT_TIME}
    ${page_source}=    Get Source
    Log    ${page_source}
    FOR    ${detail}    IN    @{expected_group_detail}
        Should Contain    ${page_source}    ${detail}
    END

*** Test Cases ***
Verify Default Language Is English
    [Documentation]    เมื่อเปิดหน้าเว็บ default เป็นภาษาอังกฤษ
    Open Browser To Research Group Page
    Sleep    ${WAIT_TIME}
    Verify Page Contains Texts    @{EXPECTED_ENGLISH_TEXTS}
    Verify Research Group Name    ${EXPECTED_GROUPNAME_EN}
    Verify Research Group Description    ${EXPECTED_GROUPDESC_EN}
    Verify Project Supervisor    @{EXPECTED_LABSUPERVISOR_EN}

Switch To Thai And Verify
    [Documentation]    เปลี่ยนจากภาษาอังกฤษเป็นภาษาไทย
    Open Browser To Research Group Page
    Sleep    ${WAIT_TIME}
    Switch Language From Dropdown    ${LANG_TO_THAI}
    Verify Page Contains Texts    @{EXPECTED_THAI_TEXTS}
    Verify Research Group Name    ${EXPECTED_GROUPNAME_TH}
    Verify Research Group Description    ${EXPECTED_GROUPDESC_TH}
    Verify Project Supervisor    @{EXPECTED_LABSUPERVISOR_TH}

Switch To Chinese And Verify
    [Documentation]    เปลี่ยนจากภาษาอังกฤษเป็นภาษาจีน
    Open Browser To Research Group Page
    Sleep    ${WAIT_TIME}
    Switch Language From Dropdown    ${LANG_TO_CHINESE}
    Verify Page Contains Texts    @{EXPECTED_CHINESE_TEXTS}
    Verify Research Group Name    ${EXPECTED_GROUPNAME_CN}
    Verify Research Group Description    ${EXPECTED_GROUPDESC_CN}
    Verify Project Supervisor    @{EXPECTED_LABSUPERVISOR_CN}

Switch Back To English And Verify
    [Documentation]    เปลี่ยนจากภาษาอื่นกลับมาเป็นภาษาอังกฤษ
    Open Browser To Research Group Page
    Sleep    ${WAIT_TIME}
    # ตัวอย่าง: สลับไปเป็นภาษาไทยก่อน จากนั้นกลับมาเป็นอังกฤษ
    Switch Language From Dropdown    ${LANG_TO_THAI}
    Sleep    ${WAIT_TIME}
    Switch Language From Dropdown    ${LANG_TO_ENGLISH}
    Verify Page Contains Texts    @{EXPECTED_ENGLISH_TEXTS}
    Verify Research Group Name    ${EXPECTED_GROUPNAME_EN}
    Verify Research Group Description    ${EXPECTED_GROUPDESC_EN}
    Verify Project Supervisor    @{EXPECTED_LABSUPERVISOR_EN}

Verify Research Group Detail In English
    [Documentation]    ตรวจสอบรายละเอียดในหน้า Research Group (ภาษาอังกฤษ)
    Open Browser To Research Group Page
    Sleep    ${WAIT_TIME}
    Click More Details
    Verify Research Group Detail    @{EXPECTED_GROUPDETAIL_EN}

Verify Research Group Detail In Thai
    [Documentation]    ตรวจสอบรายละเอียดในหน้า Research Group (ภาษาไทย)
    Open Browser To Research Group Page
    Sleep    ${WAIT_TIME}
    Switch Language From Dropdown    ${LANG_TO_THAI}
    Click More Details
    Verify Research Group Detail    @{EXPECTED_GROUPDETAIL_TH}

Verify Research Group Detail In Chinese
    [Documentation]    ตรวจสอบรายละเอียดในหน้า Research Group (ภาษาจีน)
    Open Browser To Research Group Page
    Sleep    ${WAIT_TIME}
    Switch Language From Dropdown    ${LANG_TO_CHINESE}
    Click More Details
    Verify Research Group Detail    @{EXPECTED_GROUPDETAIL_CN}
