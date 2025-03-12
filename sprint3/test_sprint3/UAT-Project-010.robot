* Settings *
Library           SeleniumLibrary
Library    String

* Variables *
${SERVER}                    https://csgroup568.cpkkuhost.com
${USER_USERNAME}             615020084-7
${USER_PASSWORD}             615020084-7
${LOGIN URL}                  ${SERVER}/login
${USER URL}                  ${SERVER}/dashboard
${CHROME_BROWSER_PATH}    /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
${CHROME_DRIVER_PATH}    /usr/local/bin/chromedriver
${VIEW_BUTTON_XPATH}    //a[contains(@class, 'btn-outline-primary')]/i[contains(@class, 'mdi-eye')]
${EDIT_BUTTON_XPATH}    //a[contains(@class, 'btn-outline-success') or @title='Edit']
${ADD_BUTTON_XPATH}     //a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and .//i[contains(@class, 'mdi-plus')]]

@{LANGUAGES}
...    en
...    th
...    zh

@{EXPECTED_WORDS_USER_EN}
...    Research Information Management System
...    Welcome to the Research Information Management System of the Computer Science Department
...    Hello
...    Dashboard
...    Profile
...    User Profile
...    Option
...    Logout


@{EXPECTED_WORDS_DASHBOARD_TH}
...    ระบบจัดการข้อมูลการวิจัย
...    ยินดีต้อนรับเข้าสู่ระบบจัดการข้อมูลวิจัยของสาขาวิชาวิทยาการคอมพิวเตอร์
...    สวัสดี
...    แดชบอร์ด
...    โปรไฟล์
...    โปรไฟล์ผู้ใช้
...    ตัวเลือก
...    วชรพล เกตวงษา
...    ออกจากระบบ
       
        

@{EXPECTED_WORDS_USER_CN}
...    研究信息管理系统
...    欢迎来到计算机科学系的研究信息管理系统
...    你好
...    仪表板
...    个人资料
...    用户资料
...    选项
...    退出系统  



* Keywords *
Open Browser To Login Page
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    
    # ปิด Headless Mode เพื่อให้ Chrome แสดง UI
    # Call Method    ${chrome_options}    add_argument    --headless   (ลบบรรทัดนี้ออก)

    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage

    # เปิด Chrome แบบเต็มจอ
    Call Method    ${chrome_options}    add_argument    --start-maximized

    # ปิด Extension, Popup และ Infobars เพื่อลดเวลาโหลด
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-popup-blocking
    Call Method    ${chrome_options}    add_argument    --disable-infobars

    # ตั้งค่าตำแหน่ง Chrome และ Chrome Driver
    ${chrome_options.binary_location}=    Set Variable    ${CHROME_BROWSER_PATH}
    ${service}=    Evaluate    sys.modules["selenium.webdriver.chrome.service"].Service(executable_path=r"${CHROME_DRIVER_PATH}")

    # เปิด Browser ด้วย Chrome แบบ UI Mode
    Create Webdriver    Chrome    options=${chrome_options}    service=${service}
    Go To    ${LOGIN URL}
    Login Page Should Be Open
    Maximize Browser Window



Login Page Should Be Open
    Location Should Be    ${LOGIN URL}

User Login
    Input Text      id=username    ${USER_USERNAME}
    Input Text      id=password    ${USER_PASSWORD}
    Click Button    xpath=//button[@type='submit']
    Sleep    2s 
    Location Should Be    ${USER URL} 

Switch Language To
    [Arguments]    ${lang_code}    ${expected_language}
    
    # ถ้าเป็นภาษาอังกฤษ ข้ามการเลือก dropdown และกลับเลย
    IF    '${lang_code}' == 'en'
        ${new_lang}=    Get Text    id=navbarDropdownMenuLink
        Should Contain    ${new_lang}    ${expected_language}
        RETURN
    END

    # รอให้ปุ่ม dropdown แสดงผล
    Wait Until Element Is Visible    id=navbarDropdownMenuLink    10s
    Mouse Over    id=navbarDropdownMenuLink
    Click Element    id=navbarDropdownMenuLink

    # ใช้ JavaScript เพื่อบังคับ dropdown แสดง (ถ้ามันไม่เปิดเอง)
    Execute JavaScript    document.querySelector('#navbarDropdownMenuLink').click();

    # รอ dropdown menu (ใช้ contains เพื่อให้เจาะจงมากขึ้น)
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'dropdown-menu')]    10s

    # ตรวจสอบ dropdown menu มีตัวเลือกภาษา
    ${dropdown_html}=    Get Element Attribute    xpath=//div[contains(@class, 'dropdown-menu')]    innerHTML
    Log    Dropdown HTML: ${dropdown_html}

    # คลิกเปลี่ยนภาษา
    Click Element    xpath=//a[contains(@href, "/lang/${lang_code}")]
    Sleep    5s
    
    # ตรวจสอบว่าภาษาเปลี่ยนแล้ว
    ${new_lang}=    Get Text    id=navbarDropdownMenuLink
    Should Contain    ${new_lang}    ${expected_language}

* Test Cases *
Dashboard Page Switch Language To TH
    [Tags]    UAT001-OpenUserPage
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    FOR    ${word}    IN    @{EXPECTED_WORDS_DASHBOARD_TH}
        Should Contain    ${html_source}    ${word}
    END
    Close Browser

Dashboard Page Switch Language To EN
    [Tags]    UAT001-OpenUserPage
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    en    English
    ${html_source}=    Get Source
    FOR    ${word}    IN    @{EXPECTED_WORDS_USER_EN}
        Should Contain    ${html_source}    ${word}
    END
    Close Browser

Dashboard Page Switch Language To ZH
    [Tags]    UAT001-OpenUserPage
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    FOR    ${word}    IN    @{EXPECTED_WORDS_USER_CN}
        Should Contain    ${html_source}    ${word}
    END
    Close Browser


Profile Page Switch Language To TH
    [tags]      Profile
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/profile
    Sleep    2s
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    บัญชีผู้ใช้
    Should Contain    ${html_source}    รหัสผ่าน


    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='บัญชีผู้ใช้']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    การตั้งค่าโปรไฟล์
    Should Contain    ${html_source}    คำนำหน้า
    Should Contain    ${html_source}    ชื่อ (ภาษาอังกฤษ)
    Should Contain    ${html_source}    นามสกุล (ภาษาอังกฤษ)
    Should Contain    ${html_source}    ชื่อ (ภาษาไทย)
    Should Contain    ${html_source}    นามสกุล (ภาษาไทย)
    Should Contain    ${html_source}    อีเมล

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='รหัสผ่าน']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    รหัสผ่านเก่า
    Should Contain    ${html_source}    รหัสผ่านใหม่
    Should Contain    ${html_source}    ยืนยันรหัสผ่านใหม่
    Should Contain    ${html_source}    การตั้งค่ารหัสผ่าน
    ${placeholder_value}=    Get Element Attribute    id=inputpassword    placeholder
    Should Be Equal    ${placeholder_value}    กรอกรหัสผ่านปัจจุบัน
    Close Browser

Profile Page Switch Language To EN
    [tags]      Profile_ENG
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/profile
    Sleep    2s
    Switch Language To    en    English
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Account
    Should Contain    ${html_source}    Password

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='Account']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Profile Settings
    Should Contain    ${html_source}    Name title (English)
    Should Contain    ${html_source}    First name (English)
    Should Contain    ${html_source}    Last name (English)
    Should Contain    ${html_source}    First name (Thai)
    Should Contain    ${html_source}    Last name (Thai)
    Should Contain    ${html_source}    Email

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='Password']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Old password
    Should Contain    ${html_source}    New password
    Should Contain    ${html_source}    Confirm new password
    Should Contain    ${html_source}    Password Settings
    ${placeholder_value}=    Get Element Attribute    id=inputpassword    placeholder
    Should Be Equal    ${placeholder_value}   Enter current password
    Close Browser

#ZH 
Profile Page Switch Language To zh
    [tags]      Profile_zh
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/profile
    Sleep    2s
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    Should Contain    ${html_source}    账户
    Should Contain    ${html_source}    密码

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='账户']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    个人资料设置
    Should Contain    ${html_source}    称谓 (英语)
    Should Contain    ${html_source}    名字 (英文)
    Should Contain    ${html_source}    姓氏 (英文)
    Should Contain    ${html_source}    名字 (泰文)
    Should Contain    ${html_source}    姓氏 (泰文)
    Should Contain    ${html_source}    电子邮件



    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='密码']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    旧密码
    Should Contain    ${html_source}    新密码
    Should Contain    ${html_source}    确认新密码
    Should Contain    ${html_source}    密码设置
    ${placeholder_value}=    Get Element Attribute    id=inputpassword    placeholder
    Should Be Equal    ${placeholder_value}   请输入当前密码
    Close Browser