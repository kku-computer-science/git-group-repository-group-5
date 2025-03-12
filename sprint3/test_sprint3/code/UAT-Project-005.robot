*** Settings ***  
Library          SeleniumLibrary
Test Teardown    Close Browser

*** Variables ***
${BROWSER}           chrome
${HOME_URL}          https://csgroup568.cpkkuhost.com/
${WAIT_TIME}        3s
${CHROME_BROWSER_PATH}    E:/Software Engineering/chromefortesting/chrome.exe
${CHROME_DRIVER_PATH}    E:/Software Engineering/chromefortesting/chromedriver.exe

# ตัวแปรของเมนูและ dropdown
${RESEARCHER_MENU}    xpath=//a[@id='navbarDropdown']
${DROPDOWN_MENU}      xpath=//ul[contains(@class, 'dropdown-menu') and contains(@class, 'show')]
${COMPUTER_SCIENCE}   xpath=//ul[contains(@class, 'dropdown-menu') and contains(@class, 'show')]//a[contains(@href, '/researchers/1')]

# ตัวแปรสำหรับ dropdown เปลี่ยนภาษา (ใช้ id จาก element ใน Blade)
${LANG_DROPDOWN_TOGGLE}    xpath=//a[@id="navbarDropdownMenuLink"]

# เปลี่ยนภาษา (ตัวเลือกใน dropdown)
${LANG_TO_THAI}       xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), 'ไทย')]
${LANG_TO_ENGLISH}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), 'English')]
${LANG_TO_CHINESE}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), '中文')]

# ตรวจสอบข้อความทั่วไปของหน้า Researcher
@{EXPECTED_TH}    
...    นักวิจัย    
...    ค้นหา    
...    งานวิจัยที่สนใจ    
...    สาขาวิชาวิทยาการคอมพิวเตอร์    
@{EXPECTED_CN}    
...    研究人员    
...    搜索    
...    计算机科学
...    研究兴趣        
@{EXPECTED_EN}    
...    Researchers    
...    Search    
...    Research interests    
...    Computer Science

# ตรวจสอบข้อมูลของนักวิจัย
@{EXPECTED_RESEARCHER_CN}    
...    Punyaphol Horata    
@{EXPECTED_RESEARCHER_EN}    
...    Punyaphol Horata, Ph.D. 
@{EXPECTED_RESEARCHER_TH}    
...    รศ.ดร.    
...    ปัญญาพล หอระตะ

@{EXPECTED_RESEARCHER_EXPERTISES_TH}    
...    การเรียนรู้ของเครื่องและระบบอัจฉริยะ    
...    ภาษาการเขียนโปรแกรมเชิงวัตถุ    
...    ซอฟท์คอมพิวเตอร์    
...    วิศวกรรมซอฟต์แวร์    

@{EXPECTED_RESEARCHER_EXPERTISES_EN}
...    Machine Learning and Intelligent Systems    
...    Object-Oriented Programming Languages    
...    Soft computing    
...    Software Engineering
@{EXPECTED_RESEARCHER_EXPERTISES_CN}    
...    机器学习和智能系统    
...    面向对象的编程语言    
...    软计算    
...    软件工程

${EXPECTED_RESEARCHER_INTEREST_TH}    ความเชี่ยวชาญ
${EXPECTED_RESEARCHER_INTEREST_EN}    Research interests
${EXPECTED_RESEARCHER_INTEREST_CN}    技能

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
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}

Navigate To Researcher Page
    # กดเมนู Researchers แล้วเลือกสาขา Computer Science
    Click Element    ${RESEARCHER_MENU}
    Wait Until Element Is Visible    ${DROPDOWN_MENU}    ${WAIT_TIME}
    Click Element    ${COMPUTER_SCIENCE}
    # รอจนกว่าหน้า Researchers จะมีข้อความ "Researchers" (default เป็นภาษาอังกฤษ)
    Wait Until Page Contains    Researchers    10s

Verify Page Contains Multiple Texts
    [Arguments]    @{expected_texts}
    ${html_source}=    Get Source
    Log    HTML Source: ${html_source}
    FOR    ${text}    IN    @{expected_texts}
        Should Contain    ${html_source}    ${text}
    END

Switch Language And Verify
    [Arguments]    ${lang_button}    @{expected_texts}
    # กดปุ่ม dropdown เพื่อเปิดเมนูเลือกภาษา
    Click Element    ${LANG_DROPDOWN_TOGGLE}
    Sleep    1s
    # ลองคลิกตัวเลือกภาษาที่ต้องการ (ใช้ Run Keyword And Ignore Error หากไม่พบ)
    Run Keyword And Ignore Error    Click Element    ${lang_button}
    Sleep    3s
    Verify Page Contains Multiple Texts    @{expected_texts}

*** Test Cases ***
# ทดสอบการเปลี่ยนภาษาด้วย dropdown
Navigate To Researcher Page And Switch To Chinese
    Open Browser To Home Page
    Navigate To Researcher Page
    Switch Language And Verify    ${LANG_TO_CHINESE}    @{EXPECTED_CN}
    Close Browser
Navigate To Researcher Page And Switch To Thai
    Open Browser To Home Page
    Navigate To Researcher Page
    Switch Language And Verify    ${LANG_TO_THAI}    @{EXPECTED_TH}
    Close Browser

Navigate To Researcher Page And Switch To English
    Open Browser To Home Page
    Navigate To Researcher Page
    # แม้ว่าเว็บจะเปิดมาเป็นภาษาอังกฤษอยู่แล้ว ให้กด dropdown เพื่อยืนยัน
    Switch Language And Verify    ${LANG_TO_ENGLISH}    @{EXPECTED_EN}
    Close Browser

# ทดสอบว่าชื่อผู้วิจัยแสดงถูกต้องตามภาษา
Test Researcher Name In Chinese
    Open Browser To Home Page
    Navigate To Researcher Page
    Switch Language And Verify    ${LANG_TO_CHINESE}    @{EXPECTED_RESEARCHER_CN}
    Close Browser

Test Researcher Name In English
    Open Browser To Home Page
    Navigate To Researcher Page
    Switch Language And Verify    ${LANG_TO_ENGLISH}    @{EXPECTED_RESEARCHER_EN}
    Close Browser

Test Researcher Name In Thai
    Open Browser To Home Page
    Navigate To Researcher Page
    Switch Language And Verify    ${LANG_TO_THAI}    @{EXPECTED_RESEARCHER_TH}
    Close Browser

# ทดสอบว่าความเชี่ยวชาญของนักวิจัยแสดงถูกต้องตามภาษา
Test Researcher Expertise In Chinese
    Open Browser To Home Page
    Navigate To Researcher Page
    Switch Language And Verify    ${LANG_TO_CHINESE}    @{EXPECTED_RESEARCHER_EXPERTISES_CN}
    Close Browser

Test Researcher Expertise In English
    Open Browser To Home Page
    Navigate To Researcher Page
    Switch Language And Verify    ${LANG_TO_ENGLISH}    @{EXPECTED_RESEARCHER_EXPERTISES_EN}
    Close Browser

Test Researcher Expertise In Thai
    Open Browser To Home Page
    Navigate To Researcher Page
    Switch Language And Verify    ${LANG_TO_THAI}    @{EXPECTED_RESEARCHER_EXPERTISES_TH}
    Close Browser
