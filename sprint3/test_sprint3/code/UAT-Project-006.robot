*** Settings ***  
Documentation    UAT: Home -> Researcher -> ResearcherProfile
Library          SeleniumLibrary
Test Teardown    Close Browser

*** Variables ***
${BROWSER}           chrome
${HOME_URL}          https://csgroup568.cpkkuhost.com/
${WAIT_TIME}        5s
${CHROME_BROWSER_PATH}    E:/Software Engineering/chromefortesting/chrome.exe
${CHROME_DRIVER_PATH}    E:/Software Engineering/chromefortesting/chromedriver.exe

# ตัวแปรของเมนูและ dropdown
${RESEARCHER_MENU}    xpath=//a[@id='navbarDropdown']
${DROPDOWN_MENU}      xpath=//ul[contains(@class, 'dropdown-menu show')]
${COMPUTER_SCIENCE}   xpath=//ul[contains(@class, 'dropdown-menu show')]//a[contains(@href, '/researchers/1')]

# ตัวแปรสำหรับ dropdown เปลี่ยนภาษา (ใช้ id จาก element ใน Blade)
${LANG_DROPDOWN_TOGGLE}    xpath=//a[@id="navbarDropdownMenuLink"]

# เปลี่ยนภาษา (ตัวเลือกใน dropdown)
${LANG_TO_THAI}       xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), 'ไทย')]
${LANG_TO_ENGLISH}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), 'English')]
${LANG_TO_CHINESE}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), '中文')]

# Locator สำหรับลิงก์ไปหน้า Researcher Profile
${RESEARCHER_DETAIL}    xpath=//a[contains(@href, '/detail/') and (contains(., 'ปัญญาพล') or contains(., 'Horata'))]    

*** Variables ***
@{EXPECTED_PROFILE_TH}
...    ลำดับ
...    ปี
...    ชื่องานวิจัย
...    ชื่อผู้แต่ง
...    ประเภทงานวิจัย
...    หน้า
...    ตีพิมพ์ที่
...    จำนวนการอ้างอิง
...    Doi
...    แหล่งข้อมูล
...    ทั้งหมด
...    ส่งออกไปยัง Excel
...    ภาณุวัฒน์ แก้วบ่อ
...    รศ.ดร. ปัญญาพล หอระตะ
...    Punyaphol Horata, Ph.D.
...    ปัญญาพล หอระตะ
...    รองศาสตราจารย์
...    อีเมล
...    การศึกษา
...    2528 วท.บ. (คณิตศาสตร์) มหาวิทยาลัยขอนแก่น
...    งานตีพิมพ์
...    แสดง
...    รายการ
...    ค้นหา
...    แสดง 
...    ถึง
...    จาก
...    ก่อนหน้า
...    ถัดไป

@{EXPECTED_PROFILE_EN}
...    No.
...    Year
...    Paper Name
...    Author
...    Document Type
...    Page
...    Journals/Transactions
...    Citations
...    Doi
...    Source
...    Export To Excel
...    Panuwat Keawbor
...    Punyaphol Horata
...    รศ.ดร. ปัญญาพล หอระตะ
...    Associate Professor
...    Email
...    Education
...    1985 B.Sc. (Mathematics) Khon Kaen University
...    Publications
...    summary
...    Show
...    entries
...    Search
...    Showing 
...    to
...    of
...    Previous
...    Next

@{EXPECTED_PROFILE_CN}
...    编号
...    年份
...    文章名称
...    作者
...    文档类型
...    页码
...    期刊/交易
...    引用
...    Doi
...    来源
...    总结
...    导出到Excel
...    Panuwat Keawbor
...    Punyaphol Horata
...    รศ.ดร. ปัญญาพล หอระตะ
...    电子邮件
...    教育
...    1985 B.Sc. (Mathematics) Khon Kaen University
...    出版物
...    总结
...    显示 
...    条目
...    搜索
...    显示第
...    至 
...    项结果
...    共
...    项
...    上页
...    下页

# ตัวแปรใหม่สำหรับเก็บหัวข้อวิจัย
@{RESEARCH_TOPICS}
...    Enhanced Local Receptive Fields based Extreme Learning Machine using Dominant Patterns Selection
...    An Incremental Kernel Extreme Learning Machine for Multi-Label Learning with Emerging New Labels

*** Keywords ***
Open Browser By Testing
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    ${chrome_options.binary_location}=    Set Variable    ${CHROME_BROWSER_PATH}
	Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Call Method    ${chrome_options}    add_argument    --start-maximized
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-popup-blocking
    Call Method    ${chrome_options}    add_argument    --disable-infobars
    ${service}=    Evaluate    sys.modules["selenium.webdriver.chrome.service"].Service(executable_path=r"${CHROME_DRIVER_PATH}")
	Create Webdriver    Chrome    options=${chrome_options}    service=${service}
    Maximize Browser Window

Open Browser To Home Page
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    ${chrome_options.binary_location}=    Set Variable    ${CHROME_BROWSER_PATH}
	Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Call Method    ${chrome_options}    add_argument    --start-maximized
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-popup-blocking
    Call Method    ${chrome_options}    add_argument    --disable-infobars
    ${service}=    Evaluate    sys.modules["selenium.webdriver.chrome.service"].Service(executable_path=r"${CHROME_DRIVER_PATH}")
	Create Webdriver    Chrome    options=${chrome_options}    service=${service}
    Go To    ${HOME_URL}
    Maximize Browser Window

Wait And Click
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    ${WAIT_TIME}
    Click Element    ${locator}

Navigate To Researcher Profile
    # 1) กด Researcher Menu
    Click Element    ${RESEARCHER_MENU}
    Wait Until Element Is Visible    ${DROPDOWN_MENU}    ${WAIT_TIME}
    # 2) เลือกสาขา Computer Science
    Click Element    ${COMPUTER_SCIENCE}
    # 3) รอจนกว่าหน้ารายชื่อนักวิจัยจะแสดง (รอ element ที่มี class "title")
    Wait Until Element Is Visible    xpath=//p[contains(@class, 'title')]    10s
    # 4) คลิกลิงก์เข้าไปที่หน้า Researcher Profile
    Click Element    ${RESEARCHER_DETAIL}
    # 5) รอจนกว่าหน้า Profile โหลดแล้ว (รอรูปภาพที่มีคลาส "card-image")
    Wait Until Element Is Visible    xpath=//img[contains(@class, 'card-image')]    10s

Switch Language
    [Arguments]    ${lang_button}
    # กดที่ dropdown toggle ก่อน
    Click Element    ${LANG_DROPDOWN_TOGGLE}
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'dropdown-menu')]    ${WAIT_TIME}
    Click Element    ${lang_button}
    Sleep    2s

Verify Page Contains Multiple Texts
    [Arguments]    @{expected_texts}
    ${html_source}=    Get Source
    Log    HTML Source: ${html_source}
    FOR    ${text}    IN    @{expected_texts}
        Should Contain    ${html_source}    ${text}
    END

*** Test Cases ***
# --- 1) ตรวจสอบหน้า Profile ภาษาไทย ---
Test Researcher Profile In Thai
    Open Browser To Home Page
    Navigate To Researcher Profile
    # เปลี่ยนเป็นภาษาไทย (เว็บเริ่มต้นเปิดเป็นภาษาอังกฤษ)
    Switch Language    ${LANG_TO_THAI}
    Verify Page Contains Multiple Texts    @{EXPECTED_PROFILE_TH}
    Close Browser

# --- 2) ตรวจสอบหน้า Profile ภาษาอังกฤษ ---
Test Researcher Profile In English
    Open Browser To Home Page
    Navigate To Researcher Profile
    # ไม่ต้องเปลี่ยนภาษา เพราะเว็บเปิดมาเป็นภาษาอังกฤษอยู่แล้ว
    Verify Page Contains Multiple Texts    @{EXPECTED_PROFILE_EN}
    Close Browser

# --- 3) ตรวจสอบหน้า Profile ภาษาจีน ---
Test Researcher Profile In Chinese
    Open Browser To Home Page
    Navigate To Researcher Profile
    Switch Language    ${LANG_TO_CHINESE}
    Verify Page Contains Multiple Texts    @{EXPECTED_PROFILE_CN}
    Close Browser

# --- 4) ตรวจสอบว่าหัวข้อวิจัยปรากฏในทุกภาษา ---
Test Research Topics Appear In All Languages
    Open Browser To Home Page
    Navigate To Researcher Profile
    # ตรวจสอบในหน้าเริ่มต้น (ภาษาอังกฤษ)
    Verify Page Contains Multiple Texts    @{RESEARCH_TOPICS}
    # เปลี่ยนเป็นภาษาไทยแล้วตรวจสอบ
    Switch Language    ${LANG_TO_THAI}
    Verify Page Contains Multiple Texts    @{RESEARCH_TOPICS}
    # เปลี่ยนเป็นภาษาจีนแล้วตรวจสอบ
    Switch Language    ${LANG_TO_CHINESE}
    Verify Page Contains Multiple Texts    @{RESEARCH_TOPICS}
    Close Browser
