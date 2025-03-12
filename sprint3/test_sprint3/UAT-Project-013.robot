* Settings *
Library           SeleniumLibrary
Library    String

* Variables *
${SERVER}                    http://127.0.0.1:8000
${USER_USERNAME}             pusadee@kku.ac.th
${USER_PASSWORD}             123456789
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
...    Manage Fund
...    Research Project
...    Research Group
...    Manage Publications
...    Logout


@{EXPECTED_WORDS_DASHBOARD_TH}
...    ระบบจัดการข้อมูลการวิจัย
...    ยินดีต้อนรับเข้าสู่ระบบจัดการข้อมูลวิจัยของสาขาวิชาวิทยาการคอมพิวเตอร์
...    สวัสดี
...    แดชบอร์ด
...    โปรไฟล์
...    โปรไฟล์ผู้ใช้
...    ตัวเลือก
...    จัดการทุน
...    โครงการวิจัย
...    กลุ่มวิจัย
...    จัดการผลงานวิจัย
...    ออกจากระบบ
       
        

@{EXPECTED_WORDS_USER_CN}
...    研究信息管理系统
...    欢迎来到计算机科学系的研究信息管理系统
...    你好
...    仪表板
...    个人资料
...    用户资料
...    选项
...    管理资金
...    研究项目
...    研究小组
...    管理出版物
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
    Should Contain    ${html_source}    ความเชี่ยวชาญ
    Should Contain    ${html_source}    การศึกษา

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='บัญชีผู้ใช้']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    การตั้งค่าโปรไฟล์
    Should Contain    ${html_source}    คำนำหน้า
    Should Contain    ${html_source}    ชื่อ (ภาษาอังกฤษ)
    Should Contain    ${html_source}    นามสกุล (ภาษาอังกฤษ)

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='รหัสผ่าน']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    รหัสผ่านเก่า
    Should Contain    ${html_source}    รหัสผ่านใหม่
    Should Contain    ${html_source}    ยืนยันรหัสผ่านใหม่
    Should Contain    ${html_source}    การตั้งค่ารหัสผ่าน
    ${placeholder_value}=    Get Element Attribute    id=inputpassword    placeholder
    Should Be Equal    ${placeholder_value}    กรอกรหัสผ่านปัจจุบัน

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='ความเชี่ยวชาญ']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    ความเชี่ยวชาญ
    Wait Until Element Is Visible    xpath=//button[contains(@data-target, '#crud-modal') and contains(., 'เพิ่มความเชี่ยวชาญ')]    2s
    ${button_text}=    Get Text    xpath=//button[contains(@data-target, '#crud-modal')]
    Should Contain    ${button_text}    เพิ่มความเชี่ยวชาญ

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='การศึกษา']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    ประวัติการศึกษา
    Should Contain    ${html_source}    ปริญญาตรี
    Should Contain    ${html_source}    ชื่อมหาวิทยาลัย
    Should Contain    ${html_source}    ชื่อวุฒิปริญญา
    Should Contain    ${html_source}    ปี พ.ศ. ที่จบ
    Should Contain    ${html_source}    ปริญญาโท
    Should Contain    ${html_source}    ปริญญาเอก
    Close Browser

Funds Page Switch Language To TH
    [Tags]    Fund
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/funds
    Sleep    2s
    Switch Language To    th    ไทย
    Sleep   2s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    ทุนวิจัย
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    ประเภททุน
    Should Contain    ${html_source}    ระดับทุน
    Should Match Regexp   ${html_source}    .*Statistical Thai*.
    Should Contain    ${html_source}    ทุนภายใน
    Should Contain    ${html_source}    ไม่ระบุ

    Click Element   ${ADD_BUTTON_XPATH}
    Sleep   2s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    เพิ่มทุนวิจัย
    Should Contain    ${html_source}    กรอกรายละเอียดทุนวิจัย
    Should Contain    ${html_source}    ประเภททุนวิจัย
    Should Contain    ${html_source}    ระดับทุน
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    หน่วยงานที่สนับสนุน / โครงการวิจัย
    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    โปรดระบุประเภททุน
    Should Contain    ${options}    ทุนภายใน
    Should Contain    ${options}    ทุนภายนอก

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    โปรดระบุระดับทุน
    Should Contain    ${options}    ไม่ระบุ
    Should Contain    ${options}    สูง
    Should Contain    ${options}    กลาง
    Should Contain    ${options}    ต่ำ

    # View
    Go To    ${SERVER}/funds
    Sleep   1s
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=1s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
    ${html_source}=    Get Source
    Should Contain    ${html_source}    รายละเอียดทุน
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    รายละเอียดทุน
    Should Contain    ${html_source}    หน่วยงานที่ให้ทุน
    Should Contain    ${html_source}    เพิ่มรายละเอียดโดย
    Should Contain    ${html_source}    ย้อนกลับ
    ${fund_type}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'ทุนภายใน')]
    Should Be Equal As Strings    ${fund_type}    ทุนภายใน
    ${added_by}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'พุธษดี ศิริแสงตระกูล')]
    Should Be Equal As Strings    ${added_by}    พุธษดี ศิริแสงตระกูล

    # Edit
    Go To    ${SERVER}/funds
    Sleep    2s
    
    Wait Until Element Is Visible    ${EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${EDIT_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    แก้ไขกองทุน
    Should Contain    ${html_source}    ประเภททุนวิจัย
    Should Contain    ${html_source}    ระดับทุน
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    หน่วยงานที่ให้ทุน
    Sleep    2s  # รอให้หน้าโหลด

    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    ทุนภายใน
    Should Contain    ${options}    ทุนภายนอก

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    ไม่ระบุ
    Should Contain    ${options}    สูง
    Should Contain    ${options}    กลาง
    Should Contain    ${options}    ต่ำ

    Close Browser


Research Projects Page Switch Language To TH
    [Tags]      ResearchProjects
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchProjects
    Sleep    2s
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    โครงการวิจัย
    Should Contain    ${html_source}    ปี
    Should Contain    ${html_source}    ชื่อโครงการ
    Should Contain    ${html_source}    หัวหน้ากลุ่มวิจัย
    Should Contain    ${html_source}    สมาชิก
    Should Contain    ${html_source}    การกระทำ
    Should Contain    ${html_source}    ค้นหา

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    เพิ่มข้อมูลโครงการวิจัย
    Should Contain    ${html_source}    กรอกข้อมูลรายละเอียดโครงการวิจัย
    Should Contain    ${html_source}    ชื่อโครงการวิจัย
    Should Contain    ${html_source}    วันที่เริ่มต้น
    Should Contain    ${html_source}    วันที่สิ้นสุด
    Should Contain    ${html_source}    เลือกทุน
    Should Contain    ${html_source}    ปีที่ยื่น (ค.ศ.)
    Should Contain    ${html_source}    งบประมาณ
    Should Contain    ${html_source}    หน่วยงานที่รับผิดชอบ
    Should Contain    ${html_source}    รายละเอียดโครงการ
    Should Contain    ${html_source}    status
    Should Contain    ${html_source}    ผู้รับผิดชอบโครงการ
    Should Contain    ${html_source}    ผู้รับผิดชอบโครงการ (ร่วม) ภายใน
    Should Contain    ${html_source}    ผู้รับผิดชอบโครงการ (ร่วม) ภายนอก

    Click Element       xpath=//*[@id="fund"]
    Sleep    1s
    Click Element       xpath=//*[@id="dep"]
    Sleep    1s

    Scroll Element Into View    //select[@class="custom-select my-select" and @id="status"]
    Click Element    //select[@class="custom-select my-select" and @id="status"]
    Sleep    1s


    Scroll Element Into View    //span[@id="select2-head0-container"]
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    เลือกผู้ใช้
    Should Contain    ${html_source}    อดิศร
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-selUser0-container"]
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    เลือกผู้ใช้
    Should Contain    ${html_source}    อดิศร

    # View
    Go To    ${SERVER}/researchProjects
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
    ${html_source}=    Get Source
    Should Contain    ${html_source}    รายละเอียดโครงการวิจัย
    Should Contain    ${html_source}    ชื่อโครงการ
    Should Contain    ${html_source}    วันที่เริ่มต้น
    Should Contain    ${html_source}    วันที่สิ้นสุด
    Should Contain    ${html_source}    แหล่งทุนวิจัย
    Should Contain    ${html_source}    จำนวนเงิน
    Should Contain    ${html_source}    รายละเอียดโครงการ
    Should Contain    ${html_source}    สถานะโครงการ
    Should Contain    ${html_source}    ปิดโครงการ
    Should Contain    ${html_source}    ผู้จัดการโครงการ
    Should Contain    ${html_source}    ผศ.ดร. พุธษดี ศิริแสงตระกูล
    Should Contain    ${html_source}    สมาชิก

    Go To    ${SERVER}/researchProjects
    Sleep    2s
    
    # Edit
    Wait Until Element Is Visible    ${EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${EDIT_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    แก้ไขข้อมูลโครงการวิจัย
    Should Contain    ${html_source}    กรอกข้อมูลเพื่อแก้ไขรายละเอียดโครงการวิจัย
    Should Contain    ${html_source}    ชื่อโครงการ
    Should Contain    ${html_source}    วันที่เริ่มต้น
    Should Contain    ${html_source}    วันที่สิ้นสุด
    Should Contain    ${html_source}    เลือกทุน
    Should Contain    ${html_source}    ปีที่ยื่น
    Should Contain    ${html_source}    งบประมาณ
    Should Contain    ${html_source}    หน่วยงานที่รับผิดชอบ
    Should Contain    ${html_source}    รายละเอียดโครงการ
    Should Contain    ${html_source}    สถานะ
    Should Contain    ${html_source}    ผู้รับผิดชอบโครงการ
    Should Contain    ${html_source}    ผู้รับผิดชอบโครงการ (ร่วม) ภายใน

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="responsible_department"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    สาขาวิชาวิทยาการคอมพิวเตอร์

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="status"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    ปิดโครงการ
    Should Contain    ${options}    ดำเนินการ
    Should Contain    ${options}    ยื่นขอ

    Close Browser



Research Groups Page Switch Language To TH
    [tags]  researchGroups
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchGroups
    Sleep    2s
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    กลุ่มวิจัย
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ลำดับที่
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย
    Should Contain    ${html_source}    หัวหน้ากลุ่มวิจัย
    Should Contain    ${html_source}    สมาชิก
    Should Contain    ${html_source}    การกระทำ
    Should Contain    ${html_source}    ค้นหา
    
    # View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
    ${html_source}=    Get Source
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย (English)
    Should Contain    ${html_source}    คำอธิบายกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    คำอธิบายกลุ่มวิจัย (English)
    Should Contain    ${html_source}    รายละเอียดกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    รายละเอียดกลุ่มวิจัย (English)
    Should Contain    ${html_source}    หัวหน้ากลุ่มวิจัย
    Should Contain    ${html_source}    สมาชิกกลุ่มวิจัย
    Should Contain    ${html_source}    ผศ.ดร.พิพัธน์ เรืองแสง
    Should Contain    ${html_source}    รศ.ดร.ชัยพล กีรติกสิกร
    Should Contain    ${html_source}    ผศ.ดร.ณกร วัฒนกิจ


    # Edit
    Go To    ${SERVER}/researchGroups
    Sleep    2s
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย (English)
    Should Contain    ${html_source}    คำอธิบายกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    คำอธิบายกลุ่มวิจัย (English)
    Should Contain    ${html_source}    รายละเอียดกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    รายละเอียดกลุ่มวิจัย (English)
    Should Contain    ${html_source}    รูปภาพ
    Should Contain    ${html_source}    หัวหน้ากลุ่มวิจัย
    Should Contain    ${html_source}    สมาชิกกลุ่มวิจัย

    Execute JavaScript    window.scrollTo(0,500) 
    Sleep    2s

    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=5s
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    พุธษดี ศิริแสงตระกูล
    Click Element    //span[@id="select2-head0-container"]

    Wait Until Element Is Visible    //span[@id="select2-selUser1-container"]    timeout=5s
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    พงษ์ศธร จันทรย้อย

    Close Browser    

Navigate To Research Publications
    [tags]    research
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/dashboard
    Sleep    2s
    Switch Language To    th    ไทย
    Sleep    2s
    # คลิกที่เมนู "จัดการผลงานวิจัย"
    Click Element    xpath=//span[contains(text(), 'จัดการผลงานวิจัย')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/papers') and contains(text(), 'ผลงานวิจัยที่เผยแพร่')]    timeout=5s
    
    # "ผลงานวิจัยที่เผยแพร่"
    Click Element    xpath=//a[contains(@href, '/papers') and contains(text(), 'ผลงานวิจัยที่เผยแพร่')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    งานวิจัยที่ตีพิมพ์
    Should Contain    ${html_source}    ชื่อเรื่อง
    Should Contain    ${html_source}    ลำดับ
    Should Contain    ${html_source}    ประเภท
    Should Contain    ${html_source}    ปีที่ตีพิมพ์
    Should Contain    ${html_source}    การกระทำ
    Should Contain    ${html_source}    ค้นหา
     
    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    เพิ่มผลงานตีพิมพ์
    Should Contain    ${html_source}    กรอกข้อมูลรายละเอียดงานวิจัย
    Should Contain    ${html_source}    แหล่งเผยแพร่งานวิจัย
    Should Contain    ${html_source}    ชื่องานวิจัย
    Should Contain    ${html_source}    บทคัดย่อ
    Should Contain    ${html_source}    คำสำคัญ
    Should Contain    ${html_source}    ประเภทเอกสาร
    Should Contain    ${html_source}    ประเภทย่อย
    Should Contain    ${html_source}    การตีพิมพ์
    Should Contain    ${html_source}    ชื่องานวารสาร
    Should Contain    ${html_source}    ปีที่ตีพิมพ์
    Should Contain    ${html_source}    เล่มที่
    Should Contain    ${html_source}    ฉบับที่
    Should Contain    ${html_source}    การอ้างอิง
    Should Contain    ${html_source}    เลขหน้า
    Should Contain    ${html_source}    ทุนสนับสนุน
    Should Contain    ${html_source}    บุคคลภายในสาขา
    Should Contain    ${html_source}    บุคคลภายนอก
    
    Should Contain    ${html_source}    โปรดเลือกแหล่งข้อมูล

    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="selectpicker"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Scopus
    Should Contain    ${options}    Web Of Science
    Should Contain    ${options}    TCI
    
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    วารสาร


    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    โปรดเลือกประเภทย่อย
    Should Contain    ${options}    บทความ
    Should Contain    ${options}    บทความในการประชุมวิชาการ
    Should Contain    ${options}    บรรณาธิการ
    Should Contain    ${options}    บทวิจารณ์
    Should Contain    ${options}    คำแก้ไข
    Should Contain    ${options}    บทในหนังสือ

    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    หนังสือนานาชาติ


    # View
    Go To    ${SERVER}/papers
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    รายละเอียดงานวารสาร
    Should Contain    ${html_source}    ชื่อเรื่อง
    Should Contain    ${html_source}    บทคัดย่อ
    Should Contain    ${html_source}    คำสำคัญ
    Should Contain    ${html_source}    ประเภท
    Should Contain    ${html_source}    ประเภทเอกสาร
    Should Contain    ${html_source}    การตีพิมพ์
    Should Contain    ${html_source}    ผู้เขียน
    Should Contain    ${html_source}    ชื่องานวารสาร
    Should Contain    ${html_source}    ปีที่ตีพิมพ์
    Should Contain    ${html_source}    เล่มที่
    Should Contain    ${html_source}    ฉบับที่
    Should Contain    ${html_source}    เลขหน้า

    #Edit
    Go To   ${SERVER}/papers
    Sleep    2s
    
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='Edit']

    ${html_source}=    Get Source
    Should Contain    ${html_source}    แก้ไขผลงานตีพิมพ์
    Should Contain    ${html_source}    แหล่งเผยแพร่งานวิจัย
    Should Contain    ${html_source}    ชื่องานวิจัย
    Should Contain    ${html_source}    บทคัดย่อ
    Should Contain    ${html_source}    คำสำคัญ
    Should Contain    ${html_source}    ประเภท
    Should Contain    ${html_source}    ประเภทเอกสาร
    Should Contain    ${html_source}    การตีพิมพ์
    Should Contain    ${html_source}    ปีที่ตีพิมพ์
    Should Contain    ${html_source}    เล่มที่
    Should Contain    ${html_source}    ฉบับที่
    Should Contain    ${html_source}    เลขหน้า
    Should Contain    ${html_source}    การอ้างอิง
    Should Contain    ${html_source}    ทุนสนับสนุน
    Should Contain    ${html_source}    บุคคลภายในสาขา
    Should Contain    ${html_source}    บุคคลภายนอก

    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    วารสาร
    Should Contain    ${options}    การประชุมวิชาการ
    Should Contain    ${options}    ชุดหนังสือ
    Should Contain    ${options}    หนังสือ


    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    บทความ
    Should Contain    ${options}    บทความในการประชุมวิชาการ
    Should Contain    ${options}    บรรณาธิการ
    Should Contain    ${options}    บทในหนังสือ
    Should Contain    ${options}    คำแก้ไข
    Should Contain    ${options}    บทวิจารณ์

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    วารสารนานาชาติ
    Should Contain    ${options}    หนังสือนานาชาติ
    Should Contain    ${options}    การประชุมวิชาการนานาชาติ
    Should Contain    ${options}    การประชุมวิชาการในประเทศ
    Should Contain    ${options}    วารสารในประเทศ
    Should Contain    ${options}    หนังสือในประเทศ
    Should Contain    ${options}    นิตยสารในประเทศ
    Should Contain    ${options}    บทในหนังสือ


    Execute JavaScript    window.scrollTo(0,1200) 
    Sleep    2s

    Wait Until Element Is Visible    //span[@id="select2-selUser0-container"]    timeout=5s
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    พุธษดี ศิริแสงตระกูล
    Click Element    //span[@id="select2-selUser0-container"]

    #books
    Execute JavaScript    window.scrollTo(0,-1200) 
    Sleep    2s
    Click Element    xpath=//span[contains(text(), 'จัดการผลงานวิจัย')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/books') and contains(text(), 'หนังสือ')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/books') and contains(text(), 'หนังสือ')]
    Sleep    5s

    ${html_source}=    Get Source
    Log    ${html_source}
    Should Contain    ${html_source}    หนังสือ
    Should Contain    ${html_source}    แสดง
    Get Text    xpath=//th[contains(text(), 'เลขที่')]
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ปี
    Get Text    xpath=//th[contains(text(), 'แหล่งข่าว')]
    Should Contain    ${html_source}    หนังสือ

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    เพิ่มหนังสือ
    Should Contain    ${html_source}    กรอกรายละเอียดหนังสือ
    Should Contain    ${html_source}    สถานที่เผยแพร่
    Should Contain    ${html_source}    ปี (โฆษณา)
    Should Contain    ${html_source}    จำนวนหน้า

    # View
    Go To   ${SERVER}/books
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
    ${html_source}=    Get Source
    Should Contain    ${html_source}    รายละเอียดหนังสือปฏิบัติการ
    Should Contain    ${html_source}    ข้อมูลรายละเอียดหนังสือ
    Should Contain    ${html_source}    ชื่อหนังสือ
    Should Contain    ${html_source}    ปี
    Should Contain    ${html_source}    แหล่งข่าว
    Should Contain    ${html_source}    หน้าหนังสือ
    Should Contain    ${html_source}    กลับ

    #Edit
    Go To   ${SERVER}/books

    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='Edit']
    Sleep   2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    แก้ไขรายละเอียดหนังสือ
    Should Contain    ${html_source}    กรอกรายละเอียดหนังสือ
    Should Contain    ${html_source}    ชื่อหนังสือ
    Should Contain    ${html_source}    สถานที่เผยแพร่
    Should Contain    ${html_source}    ปีที่เผยแพร่ (B.E. )
    Should Contain    ${html_source}    จำนวนหน้า (หน้า)

    #Other Academic Works
    Click Element    xpath=//span[contains(text(), 'จัดการผลงานวิจัย')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/patents') and contains(text(), 'ผลงานวิชาการอื่นๆ')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/patents') and contains(text(), 'ผลงานวิชาการอื่นๆ')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    ผลงานวิชาการอื่นๆ
    Should Contain    ${html_source}    แสดง
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(., 'เพิ่ม')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary')]
    Should Contain    ${button_text}    เพิ่ม
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ลำดับ
    Should Contain    ${html_source}    ประเภท
    ${text}=    Get Text    xpath=//th[contains(text(), 'วันที่ได้รับลิขสิทธิ์')]
    Should Contain    ${text}    วันที่ได้รับลิขสิทธิ์
    ${text}=    Get Text    xpath=//th[contains(text(), 'เลขทะเบียน')]
    Should Contain    ${text}    เลขทะเบียน
    ${text}=    Get Text    xpath=//th[contains(text(), 'ผู้จัดทำ')]
    Should Contain    ${text}    ผู้จัดทำ
    Should Contain    ${html_source}    การกระทำ
    ${full_text}=    Execute JavaScript    return document.querySelector("td:nth-child(2)").textContent.trim();
    Log    ${full_text}
    Should Contain    ${full_text}    เอกสารประกอบการสอนการเขียนโปรแกรมเบื้องต้น
    ${text}=    Get Text    xpath=//td[contains(text(), 'ลิขสิทธิ์')]
    Should Contain    ${text}    ลิขสิทธิ์

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    เพิ่ม
    Should Contain    ${html_source}    กรอกข้อมูลรายละเอียดงานสิทธิบัตร, อนุสิทธิบัตร, ลิขสิทธิ์
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ประเภท
    Should Contain    ${html_source}    วันที่ได้รับลิขสิทธิ์
    Should Contain    ${html_source}    เลขทะเบียน
    Should Contain    ${html_source}    อาจารย์ในสาขา
    Should Contain    ${html_source}    บุคคลภายนอก  

    Click Element   //button[@id='add-btn2']
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="form-control"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    วัชระ ศรีต้นวงศ์

    Capture Page Screenshot

    #View
    Go To   ${SERVER}/patents
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=3s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep   3s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    ผลงานวิชาการอื่นๆ (สิทธิบัตร, อนุสิทธิบัตร, ลิขสิทธิ์)
    Should Contain    ${html_source}    กรอกข้อมูลรายละเอียดงานสิทธิบัตร, อนุสิทธิบัตร, ลิขสิทธิ์
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ประเภท
    Should Contain    ${html_source}    วันที่ได้รับลิขสิทธิ์
    Should Contain    ${html_source}    เลขทะเบียน
    Should Contain    ${html_source}    ผู้จัดทำ
    Should Contain    ${html_source}    ผู้จัดทำ (ร่วม)
    Should Contain    ${html_source}    หนังสือ
    Should Contain    ${html_source}    เลขที่
    Should Contain    ${html_source}    พุธษดี ศิริแสงตระกูล
    
    #Edit
    Go To    ${SERVER}/patents
    Sleep    2s
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='Edit']
    ${html_source}=    Get Source
    Should Contain    ${html_source}    แก้ไขรายละเอียดผลงานวิชาการอื่นๆ
    Should Contain    ${html_source}    กรอกข้อมูลรายละเอียดงานสิทธิบัตร, อนุสิทธิบัตร, ลิขสิทธิ์
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ประเภท
    Should Contain    ${html_source}    วันที่ได้รับลิขสิทธิ์
    Should Contain    ${html_source}    เลขทะเบียน
    Should Contain    ${html_source}    อาจารย์ในสาขา
    Should Contain    ${html_source}    บุคลภายนอก
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    พุธษดี ศิริแสงตระกูล
    Click Element    //span[@id="select2-selUser0-container"]


    Close Browser

   #English
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
    Should Contain    ${html_source}    Expertise
    Should Contain    ${html_source}    Education

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
    Should Contain    ${html_source}    Academic Ranks
    Should Contain    ${html_source}    Academic Ranks (Thai)
    Should Contain    ${html_source}    For lecturers without a doctoral degree, please specify

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='Password']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Old password
    Should Contain    ${html_source}    New password
    Should Contain    ${html_source}    Confirm new password
    Should Contain    ${html_source}    Password Settings
    ${placeholder_value}=    Get Element Attribute    id=inputpassword    placeholder
    Should Be Equal    ${placeholder_value}   Enter current password

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='Expertise']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Expertise
    Wait Until Element Is Visible    xpath=//button[contains(@data-target, '#crud-modal') and contains(., 'Add Expertise')]    2s
    ${button_text}=    Get Text    xpath=//button[contains(@data-target, '#crud-modal')]
    Should Contain    ${button_text}    Add Expertise

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='Education']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Education History
    Should Contain    ${html_source}    Bachelor Degree
    Should Contain    ${html_source}    University Name
    Should Contain    ${html_source}    Degree Name
    Should Contain    ${html_source}    Graduation Year
    Should Contain    ${html_source}    Master Degree
    Should Contain    ${html_source}    PhD Degree
    Close Browser

Funds Page Switch Language To EN
    [Tags]    Fund_EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/funds
    Sleep    2s
    Switch Language To    en    English
    Sleep   2s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Fund
    Should Contain    ${html_source}    Fund Name
    Should Contain    ${html_source}    Fund Type
    Should Contain    ${html_source}    Fund Level
    Should Match Regexp   ${html_source}    .*Statistical Thai*.
    Should Contain    ${html_source}    Internal Capital
    Should Contain    ${html_source}    Unknown

    Click Element   ${ADD_BUTTON_XPATH}
    Sleep   2s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add Fund
    Should Contain    ${html_source}    Fill in the research fund details
    Should Contain    ${html_source}    Fund type
    Should Contain    ${html_source}    Fund level
    Should Contain    ${html_source}    Fund name
    Should Contain    ${html_source}    Fund Agency
    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    ----Defind fund type----
    Should Contain    ${options}    Internal Capital
    Should Contain    ${options}    External Capital

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    ----Defind fund level----
    Should Contain    ${options}    Unknown
    Should Contain    ${options}    High
    Should Contain    ${options}    Mid
    Should Contain    ${options}    Low

    # View
    Go To    ${SERVER}/funds
    Sleep   1s
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=1s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # Wait for page to load
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Fund Detail
    Should Contain    ${html_source}    Fund Name
    Should Contain    ${html_source}    Fund Year
    Should Contain    ${html_source}    Fund Agency
    Should Contain    ${html_source}    Fund Level
    Should Contain    ${html_source}    Fill fund by
    Should Contain    ${html_source}    Back
    ${fund_type}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'Internal Capital')]
    Should Be Equal As Strings    ${fund_type}    Internal Capital
    ${added_by}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'Pusadee Seresangtakul')]
    Should Be Equal As Strings    ${added_by}    Pusadee Seresangtakul

    # Edit
    Go To    ${SERVER}/funds
    Sleep    2s
    
    Wait Until Element Is Visible    ${EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${EDIT_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit Fund
    Should Contain    ${html_source}    Edit fund research details
    Should Contain    ${html_source}    Fund type
    Should Contain    ${html_source}    Fund level
    Should Contain    ${html_source}    Fund Name
    Should Contain    ${html_source}    Fund Agency
    Sleep    2s  # Wait for page to load

    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    Internal Capital
    Should Contain    ${options}    External Capital

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    Unknown
    Should Contain    ${options}    High
    Should Contain    ${options}    Mid
    Should Contain    ${options}    Low

    Close Browser

Research Projects Page Switch Language To EN
    [Tags]      ResearchProjects_EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchProjects
    Sleep    2s
    Switch Language To    en    English
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Project
    Should Contain    ${html_source}    Year
    Should Contain    ${html_source}    Project Name
    Should Contain    ${html_source}    Research Group Head
    Should Contain    ${html_source}    Member
    Should Contain    ${html_source}    Action
    Should Contain    ${html_source}    Search

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add research project information
    Should Contain    ${html_source}    Fill in the research project details
    Should Contain    ${html_source}    Research Project Name
    Should Contain    ${html_source}    Start Date
    Should Contain    ${html_source}    End Date
    Should Contain    ${html_source}    Select funding source
    Should Contain    ${html_source}    Year of submission (A.D.)
    Should Contain    ${html_source}    Budget
    Should Contain    ${html_source}    Responsible Agency
    Should Contain    ${html_source}    Project details
    Should Contain    ${html_source}    status
    Should Contain    ${html_source}    Project Manager
    Should Contain    ${html_source}    Internal Project Co-ordinator
    Should Contain    ${html_source}    External Project Co-ordinator

    Click Element       xpath=//*[@id="fund"]
    Sleep    1s
    Click Element       xpath=//*[@id="dep"]
    Sleep    1s

    Scroll Element Into View    //select[@class="custom-select my-select" and @id="status"]
    Click Element    //select[@class="custom-select my-select" and @id="status"]
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    Select User
    Should Contain    ${html_source}    Pongsathon
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-selUser0-container"]
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    Select User
    Should Contain    ${html_source}    Pongsathon

    # View
    Go To    ${SERVER}/researchProjects
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # Wait for page to load
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Project Details
    Should Contain    ${html_source}    Project Name
    Should Contain    ${html_source}    Start Date
    Should Contain    ${html_source}    End Date
    Should Contain    ${html_source}    Research Funding Source
    Should Contain    ${html_source}    Amount
    Should Contain    ${html_source}    Project Details
    Should Contain    ${html_source}    Project Status
    Should Contain    ${html_source}    Project Closed
    Should Contain    ${html_source}    Project Manager
    Should Contain    ${html_source}    Asst. Prof. Dr. Pusadee Seresangtakul
    Should Contain    ${html_source}    Member

    Go To    ${SERVER}/researchProjects
    Sleep    2s
    
    # Edit
    Wait Until Element Is Visible    ${EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${EDIT_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit research project information
    Should Contain    ${html_source}    Fill in the information to edit the research project details.
    Should Contain    ${html_source}    Project Name
    Should Contain    ${html_source}    Start Date
    Should Contain    ${html_source}    End Date
    Should Contain    ${html_source}    Select funding source
    Should Contain    ${html_source}    Year of submission (A.D.)
    Should Contain    ${html_source}    Budget
    Should Contain    ${html_source}    Responsible Agency
    Should Contain    ${html_source}    Project details
    Should Contain    ${html_source}    Status
    Should Contain    ${html_source}    Project Manager
    Should Contain    ${html_source}    Internal Project Co-ordinator

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="responsible_department"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    Department of Computer Science

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="status"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    Project Closed
    Should Contain    ${options}    Proceed
    Should Contain    ${options}    Apply for

    ${DROPDOWN_XPATH}=    Set Variable    //span[@class="select2-selection__rendered"]
    Wait Until Element Is Visible    ${DROPDOWN_XPATH}    timeout=5s
    ${selected_text}=    Get Text    ${DROPDOWN_XPATH}
    Log    Selected Text: ${selected_text}
    Should Contain    ${selected_text}    Pusadee Seresangtakul

    Close Browser

Research Groups Page Switch Language To EN
    [tags]  researchGroups_EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchGroups
    Sleep    2s
    Switch Language To    en    English
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Groups
    Should Contain    ${html_source}    No.
    Should Contain    ${html_source}    Group name (Thai)
    Should Contain    ${html_source}    Research group head
    Should Contain    ${html_source}    Member
    Should Contain    ${html_source}    Action
    Should Contain    ${html_source}    Search
    
    # View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # Wait for page to load
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Group name (Thai)
    Should Contain    ${html_source}    Group name (English)
    Should Contain    ${html_source}    Group description (Thai)
    Should Contain    ${html_source}    Group description (English)
    Should Contain    ${html_source}    Group details (Thai)
    Should Contain    ${html_source}    Group details (English)
    Should Contain    ${html_source}    Research group head
    Should Contain    ${html_source}    Research group members
    Should Contain    ${html_source}    Asst. Prof. Dr.Pipat Reungsang
    Should Contain    ${html_source}    Assoc. Prof. Dr.Chaiyapon Keeratikasikorn
    Should Contain    ${html_source}    Asst. Prof. Dr.Nagon Watanakij

    # Edit
    Go To    ${SERVER}/researchGroups
    Sleep    2s
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Group name (Thai)
    Should Contain    ${html_source}    Group name (English)
    Should Contain    ${html_source}    Group description (Thai)
    Should Contain    ${html_source}    Group description (English)
    Should Contain    ${html_source}    Group details (Thai)
    Should Contain    ${html_source}    Group details (English)
    Should Contain    ${html_source}    Image
    Should Contain    ${html_source}    Research Group Head
    Should Contain    ${html_source}    Research Group Members

    Execute JavaScript    window.scrollTo(0,500) 
    Sleep    2s

    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=5s
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    Pusadee Seresangtakul
    Click Element    //span[@id="select2-head0-container"]

    Wait Until Element Is Visible    //span[@id="select2-selUser1-container"]    timeout=5s
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    Pongsathon Janyoi

    Close Browser


Research Publications Page Switch Language To EN
    [tags]  researchPublications_EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/dashboard
    Sleep    2s
    Switch Language To    en    English
    Sleep    2s
    Click Element    xpath=//span[contains(text(), 'Manage Publications')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/papers') and contains(text(), 'Published Research')]    timeout=5s
    Click Element    xpath=//a[contains(@href, '/papers') and contains(text(), 'Published Research')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Published Research
    Should Contain    ${html_source}    Paper Name
    Should Contain    ${html_source}    No
    Should Contain    ${html_source}    Paper Type
    Should Contain    ${html_source}    Publish Year
    Should Contain    ${html_source}    Action
    Should Contain    ${html_source}    Search

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add publication research
    Should Contain    ${html_source}    Fill research detail
    Should Contain    ${html_source}    Research publication source
    Should Contain    ${html_source}    Research Name
    Should Contain    ${html_source}    Abstract
    Should Contain    ${html_source}    Keyword
    Should Contain    ${html_source}    Document Type
    Should Contain    ${html_source}    Subtype
    Should Contain    ${html_source}    Publication
    Should Contain    ${html_source}    Source Title
    Should Contain    ${html_source}    Publish Year
    Should Contain    ${html_source}    Volume
    Should Contain    ${html_source}    Issue
    Should Contain    ${html_source}    Citation
    Should Contain    ${html_source}    Page
    Should Contain    ${html_source}    DOI
    Should Contain    ${html_source}    Support Fund
    Should Contain    ${html_source}    URL
    Should Contain    ${html_source}    Author name (in department)
    Should Contain    ${html_source}    Author name (in addition to department)

    Should Contain    ${html_source}    Please select source title

    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="selUser0"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    watchara sritonwong


    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="selectpicker"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Scopus
    Should Contain    ${options}    Web Of Science
    Should Contain    ${options}    TCI

    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Journal

    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Please select subtype
    Should Contain    ${options}    Article
    Should Contain    ${options}    Conference Paper
    Should Contain    ${options}    Editorial
    Should Contain    ${options}    Review
    Should Contain    ${options}    Erratum
    Should Contain    ${options}    Book Chapter

    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    International Book

    # View
    Go To    ${SERVER}/papers
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Detail
    Should Contain    ${html_source}    Paper Name
    Should Contain    ${html_source}    Abstract
    Should Contain    ${html_source}    Keyword
    Should Contain    ${html_source}    Paper Type
    Should Contain    ${html_source}    Document Type
    Should Contain    ${html_source}    Publication
    Should Contain    ${html_source}    Writer
    Should Contain    ${html_source}    Source Title
    Should Contain    ${html_source}    Publish Year
    Should Contain    ${html_source}    Volume
    Should Contain    ${html_source}    Issue
    Should Contain    ${html_source}    Page

    # Edit
    Go To   ${SERVER}/papers
    Sleep    2s
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='Edit']

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit research publication
    Should Contain    ${html_source}    Research publication source
    Should Contain    ${html_source}    Research Name
    Should Contain    ${html_source}    Abstract
    Should Contain    ${html_source}    Keyword
    Should Contain    ${html_source}    Source Title
    Should Contain    ${html_source}    Document Type
    Should Contain    ${html_source}    Publication
    Should Contain    ${html_source}    Publish Year
    Should Contain    ${html_source}    Subtype
    Should Contain    ${html_source}    Volume
    Should Contain    ${html_source}    Issue
    Should Contain    ${html_source}    Page
    Should Contain    ${html_source}    Citation
    Should Contain    ${html_source}    Support Fund
    Should Contain    ${html_source}    Author name (in department)
    Should Contain    ${html_source}    Author name (in addition to department)

    Execute JavaScript    window.scrollTo(0,1200) 
    Sleep    2s

    Wait Until Element Is Visible    //span[@id="select2-selUser0-container"]    timeout=5s
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    Chitsutha Soomlek
    Click Element    //span[@id="select2-selUser0-container"]

    #books
    Execute JavaScript    window.scrollTo(0,-1200) 
    Sleep    2s
    Click Element    xpath=//span[contains(text(), 'Manage Publications')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/books') and contains(text(), 'Book')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/books') and contains(text(), 'Book')]
    Sleep    5s

    ${html_source}=    Get Source
    Log    ${html_source}
    Should Contain    ${html_source}    Book
    Should Contain    ${html_source}    Show
    Get Text    xpath=//th[contains(text(), 'No.')]
    Should Contain    ${html_source}    name
    Should Contain    ${html_source}    Year
    Get Text    xpath=//th[contains(text(), 'Publication source')]

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add a book
    Should Contain    ${html_source}    Fill in book details
    Should Contain    ${html_source}    Book name
    Should Contain    ${html_source}    Place of publication
    Should Contain    ${html_source}    Year (AD)
    Should Contain    ${html_source}    Number of pages

    # View
    Go To   ${SERVER}/books
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # Wait for page load
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Book details information
    Should Contain    ${html_source}    ActionBook Detail
    Should Contain    ${html_source}    Book name
    Should Contain    ${html_source}    Year
    Should Contain    ${html_source}    Publication
    Should Contain    ${html_source}    page
    Should Contain    ${html_source}    Back

    # Edit
    Go To   ${SERVER}/books
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='Edit']
    Sleep   2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit book details
    Should Contain    ${html_source}   Fill in book details
    Should Contain    ${html_source}    Book name
    Should Contain    ${html_source}    Place of publication
    Should Contain    ${html_source}    Year published (B.E.)
    Should Contain    ${html_source}    Number of pages (Page)
        
    # Other Academic Works
    Click Element    xpath=//span[contains(text(), 'Manage Publications')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/patents') and contains(text(), 'Patents')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/patents') and contains(text(), 'Patents')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Other Academic Works
    Should Contain    ${html_source}    Show
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(., 'Add')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary')]
    Should Contain    ${button_text}    Add
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    No.
    Should Contain    ${html_source}    Type
    ${text}=    Get Text    xpath=//th[contains(text(), 'Registration Date')]
    Should Contain    ${text}    Registration Date
    ${text}=    Get Text    xpath=//th[contains(text(), 'Registration Number')]
    Should Contain    ${text}    Registration Number
    ${text}=    Get Text    xpath=//th[contains(text(), 'Creator')]
    Should Contain    ${text}    Creator
    Should Contain    ${html_source}    Action
    ${full_text}=    Execute JavaScript    return document.querySelector("td:nth-child(2)").textContent.trim();
    Log    ${full_text}
    Should Contain    ${full_text}    เอกสารประกอบการสอนการเขียนโปรแกรมเบื้องต้น
    ${text}=    Get Text    xpath=//td[contains(text(), 'Copyright')]
    Should Contain    ${text}    Copyright

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add
    Should Contain    ${html_source}    Enter details of patents, utility models, or copyrights
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Type
    Should Contain    ${html_source}    Registration Date
    Should Contain    ${html_source}    Registration Number
    Should Contain    ${html_source}    Internal Authors
    Should Contain    ${html_source}    External Authors

    Click Element   //button[@id='add-btn2']
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="form-control"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    watchara sritonwong

    Capture Page Screenshot

    # View
    Go To   ${SERVER}/patents
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=3s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep   3s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Other Academic Works (Patents, Utility Models, Copyrights)
    Should Contain    ${html_source}    Enter details of patents, utility models, or copyrights
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Type
    Should Contain    ${html_source}    Registration Date
    Should Contain    ${html_source}    Registration Number
    Should Contain    ${html_source}    Creator
    Should Contain    ${html_source}    Co-Creator
    Should Contain    ${html_source}    Book
    Should Contain    ${html_source}    No
    Should Contain    ${html_source}    Pusadee Seresangtakul

    # Edit
    Go To    ${SERVER}/patents
    Sleep    2s
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='Edit']
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit Other Academic Work Details
    Should Contain    ${html_source}    Enter details of patents, utility models, or copyrights
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Type
    Should Contain    ${html_source}    Registration Date
    Should Contain    ${html_source}    Registration Number
    Should Contain    ${html_source}    Internal Authors
    Should Contain    ${html_source}    External Authors
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    Pusadee Seresangtakul
    Click Element    //span[@id="select2-selUser0-container"]

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
    Should Contain    ${html_source}    专业领域
    Should Contain    ${html_source}    教育

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
    Should Contain    ${html_source}    学术职称
    Should Contain    ${html_source}    学术职称 (泰文)
    Should Contain    ${html_source}    对于没有博士学位的讲师，请指定

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='密码']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    旧密码
    Should Contain    ${html_source}    新密码
    Should Contain    ${html_source}    确认新密码
    Should Contain    ${html_source}    密码设置
    ${placeholder_value}=    Get Element Attribute    id=inputpassword    placeholder
    Should Be Equal    ${placeholder_value}   请输入当前密码

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='专业领域']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    专长
    Wait Until Element Is Visible    xpath=//button[contains(@data-target, '#crud-modal') and contains(., '添加专长')]    2s
    ${button_text}=    Get Text    xpath=//button[contains(@data-target, '#crud-modal')]
    Should Contain    ${button_text}    添加专长

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='教育']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    教育经历
    Should Contain    ${html_source}    本科
    Should Contain    ${html_source}    大学名称
    Should Contain    ${html_source}    学位名称
    Should Contain    ${html_source}    毕业年份
    Should Contain    ${html_source}    硕士
    Should Contain    ${html_source}    博士
    Close Browser

Funds Page Switch Language To zh
    [Tags]    Fund_zh
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/funds
    Sleep    2s
    Switch Language To    zh    中文
    Sleep   2s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究基金
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    资本类型
    Should Contain    ${html_source}    资金级别
    Should Match Regexp   ${html_source}    .*Statistical Thai*.
    Should Contain    ${html_source}    内部资金
    Should Contain    ${html_source}    未知

    Click Element   ${ADD_BUTTON_XPATH}
    Sleep   2s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    增加研究基金
    Should Contain    ${html_source}    填写研究资金详情
    Should Contain    ${html_source}    资金类型
    Should Contain    ${html_source}    资金级别
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    支持机构 / 研究项目
    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    请定义资金类型
    Should Contain    ${options}    内部资金
    Should Contain    ${options}    外部资金

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    请定义资金级别
    Should Contain    ${options}    未知
    Should Contain    ${options}    高
    Should Contain    ${options}    中等
    Should Contain    ${options}    低

    # View
    Go To    ${SERVER}/funds
    Sleep   1s
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=1s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # Wait for page to load
    ${html_source}=    Get Source
    Should Contain    ${html_source}    资金详情
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    资金年份
    Should Contain    ${html_source}    资助机构
    Should Contain    ${html_source}    资金级别
    Should Contain    ${html_source}    资金来源
    ${fund_type}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), '内部资金')]
    Should Be Equal As Strings    ${fund_type}    内部资金
    ${added_by}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'Pusadee Seresangtakul')]
    Should Be Equal As Strings    ${added_by}    Pusadee Seresangtakul

    # Edit
    Go To    ${SERVER}/funds
    Sleep    2s
    
    Wait Until Element Is Visible    ${EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${EDIT_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑基金
    Should Contain    ${html_source}    编辑研究资金详情
    Should Contain    ${html_source}    资金类型
    Should Contain    ${html_source}    资金级别
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    资助机构

    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    内部资金
    Should Contain    ${options}    外部资金

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    未知
    Should Contain    ${options}    高
    Should Contain    ${options}    中等
    Should Contain    ${options}    低

    Close Browser

Research Projects Page Switch Language To zh
    [Tags]      ResearchProjects_zh
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchProjects
    Sleep    2s
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究项目
    Should Contain    ${html_source}    年份
    Should Contain    ${html_source}    项目名称
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    成员
    Should Contain    ${html_source}    搜索

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    添加研究项目信息
    Should Contain    ${html_source}    填写研究项目详情
    Should Contain    ${html_source}    研究项目名称
    Should Contain    ${html_source}    开始日期
    Should Contain    ${html_source}    结束日期
    Should Contain    ${html_source}    选择资金来源
    Should Contain    ${html_source}    提交年份 (公元)
    Should Contain    ${html_source}    预算
    Should Contain    ${html_source}    负责单位
    Should Contain    ${html_source}    项目详情
    Should Contain    ${html_source}    状态
    Should Contain    ${html_source}    项目经理
    Should Contain    ${html_source}    内部项目协调员
    Should Contain    ${html_source}    外部项目协调员

    Click Element       xpath=//*[@id="fund"]
    Sleep    1s
    Click Element       xpath=//*[@id="dep"]
    Sleep    1s

    Scroll Element Into View    //select[@class="custom-select my-select" and @id="status"]
    Click Element    //select[@class="custom-select my-select" and @id="status"]
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    选择用户
    Should Contain    ${html_source}    Pongsathon
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-selUser0-container"]
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    选择用户
    Should Contain    ${html_source}    Pongsathon

    # View
    Go To    ${SERVER}/researchProjects
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # Wait for page to load
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究项目详情
    Should Contain    ${html_source}    项目名称
    Should Contain    ${html_source}    开始日期
    Should Contain    ${html_source}    结束日期
    Should Contain    ${html_source}    研究资金来源
    Should Contain    ${html_source}    金额
    Should Contain    ${html_source}    项目详情
    Should Contain    ${html_source}    项目状态
    Should Contain    ${html_source}    关闭项目
    Should Contain    ${html_source}    项目经理
    Should Contain    ${html_source}    Asst. Prof. Dr. Pusadee Seresangtakul
    Should Contain    ${html_source}    成员

    Go To    ${SERVER}/researchProjects
    Sleep    2s
    
    # Edit
    Wait Until Element Is Visible    ${EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${EDIT_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑研究项目信息
    Should Contain    ${html_source}    填写信息以编辑研究项目的详细信息。
    Should Contain    ${html_source}    项目名称
    Should Contain    ${html_source}    开始日期
    Should Contain    ${html_source}    结束日期
    Should Contain    ${html_source}    选择资金来源
    Should Contain    ${html_source}    提交年份
    Should Contain    ${html_source}    预算
    Should Contain    ${html_source}    负责单位
    Should Contain    ${html_source}    项目详情
    Should Contain    ${html_source}    状态
    Should Contain    ${html_source}    项目经理
    Should Contain    ${html_source}    内部项目协调员	

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="responsible_department"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    计算机科学

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="status"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    关闭项目
    Should Contain    ${options}    进行中
    Should Contain    ${options}    申请

    ${DROPDOWN_XPATH}=    Set Variable    //span[@class="select2-selection__rendered"]
    Wait Until Element Is Visible    ${DROPDOWN_XPATH}    timeout=5s
    ${selected_text}=    Get Text    ${DROPDOWN_XPATH}
    Log    Selected Text: ${selected_text}
    Should Contain    ${selected_text}    Pusadee Seresangtakul

    Close Browser

Research Groups Page Switch Language To zh
    [tags]  researchGroups_zh
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchGroups
    Sleep    2s
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究小组
    Should Contain    ${html_source}    编号
    Should Contain    ${html_source}    小组名称（泰语）
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    研究小组负责人
    
    # View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # Wait for page to load
    ${html_source}=    Get Source
    Should Contain    ${html_source}    小组名称（泰语）
    Should Contain    ${html_source}    小组名称（英语）
    Should Contain    ${html_source}    小组描述（泰语）
    Should Contain    ${html_source}    小组描述（英语）
    Should Contain    ${html_source}    小组详情（泰语）
    Should Contain    ${html_source}    小组详情（英语）
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    研究小组成员
    Should Contain    ${html_source}    Asst. Prof. Dr.Pipat Reungsang
    Should Contain    ${html_source}    Assoc. Prof. Dr.Chaiyapon Keeratikasikorn
    Should Contain    ${html_source}    Asst. Prof. Dr.Nagon Watanakij

    # Edit
    Go To    ${SERVER}/researchGroups
    Sleep    2s
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    小组名称（泰语）
    Should Contain    ${html_source}    小组名称（英语）
    Should Contain    ${html_source}    小组描述（泰语）
    Should Contain    ${html_source}    小组描述（英语）
    Should Contain    ${html_source}    小组详情（泰语）
    Should Contain    ${html_source}    小组详情（英语）
    Should Contain    ${html_source}    图片
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    研究小组成员

    Execute JavaScript    window.scrollTo(0,500) 
    Sleep    2s

    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=5s
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    Pusadee Seresangtakul
    Click Element    //span[@id="select2-head0-container"]

    Wait Until Element Is Visible    //span[@id="select2-selUser1-container"]    timeout=5s
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    Pongsathon Janyoi

    Close Browser

Research Publications Page Switch Language To zh
    [tags]  researchPublications_zh
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/dashboard
    Sleep    2s
    Switch Language To    zh    中文
    Sleep    2s
    Click Element    xpath=//span[contains(text(), '管理出版物')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/papers') and contains(text(), '已发布的研究')]    timeout=5s
    Click Element    xpath=//a[contains(@href, '/papers') and contains(text(), '已发布的研究')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    已发表研究
    Should Contain    ${html_source}    论文名
    Should Contain    ${html_source}    编号
    Should Contain    ${html_source}    论文类型
    Should Contain    ${html_source}    发表年份
    Should Contain    ${html_source}    操作
    Should Contain    ${html_source}    搜索

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    添加出版研究
    Should Contain    ${html_source}    填写研究详情
    Should Contain    ${html_source}    研究出版来源
    Should Contain    ${html_source}    研究名
    Should Contain    ${html_source}    摘要
    Should Contain    ${html_source}    关键词
    Should Contain    ${html_source}    文档类型
    Should Contain    ${html_source}    子类型
    Should Contain    ${html_source}    出版
    Should Contain    ${html_source}    来源标题
    Should Contain    ${html_source}    发表年份
    Should Contain    ${html_source}    卷
    Should Contain    ${html_source}    期
    Should Contain    ${html_source}    引用
    Should Contain    ${html_source}    页码
    Should Contain    ${html_source}    DOI
    Should Contain    ${html_source}    支持基金
    Should Contain    ${html_source}    URL
    Should Contain    ${html_source}    部门内作者姓名
    Should Contain    ${html_source}    部门外作者姓名

    Should Contain    ${html_source}    请选择来源标题

    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="selUser0"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    watchara sritonwong


    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="selectpicker"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Scopus
    Should Contain    ${options}    Web Of Science
    Should Contain    ${options}    TCI

    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    期刊
    Should Contain    ${options}    书籍
    Should Contain    ${options}    书籍系列
    Should Contain    ${options}    会议论文集

    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    请选择子类型
    Should Contain    ${options}    文章
    Should Contain    ${options}    会议论文
    Should Contain    ${options}    社论
    Should Contain    ${options}    评论
    Should Contain    ${options}    勘误
    Should Contain    ${options}    书中章节

    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    国际书籍
    Should Contain    ${options}    国际期刊
    Should Contain    ${options}    国际会议
    Should Contain    ${options}    国内会议
    Should Contain    ${options}    国内期刊
    Should Contain    ${options}    国内书籍
    Should Contain    ${options}    国内杂志
    Should Contain    ${options}    书中章节


    # View
    Go To    ${SERVER}/papers
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    详情
    Should Contain    ${html_source}    论文名
    Should Contain    ${html_source}    摘要
    Should Contain    ${html_source}    关键词
    Should Contain    ${html_source}    论文类型
    Should Contain    ${html_source}    文档类型
    Should Contain    ${html_source}    出版
    Should Contain    ${html_source}    作者
    Should Contain    ${html_source}    来源标题
    Should Contain    ${html_source}    发表年份
    Should Contain    ${html_source}    卷
    Should Contain    ${html_source}    期
    Should Contain    ${html_source}    页码

    # Edit
    Go To   ${SERVER}/papers
    Sleep    2s
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='Edit']

    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑研究出版
    Should Contain    ${html_source}    研究出版来源
    Should Contain    ${html_source}    研究名
    Should Contain    ${html_source}    摘要
    Should Contain    ${html_source}    关键词
    Should Contain    ${html_source}    来源标题
    Should Contain    ${html_source}    文档类型
    Should Contain    ${html_source}    出版
    Should Contain    ${html_source}    发表年份
    Should Contain    ${html_source}    子类型
    Should Contain    ${html_source}    卷
    Should Contain    ${html_source}    期
    Should Contain    ${html_source}    页码
    Should Contain    ${html_source}    出版
    Should Contain    ${html_source}    支持基金
    Should Contain    ${html_source}    部门内作者姓名
    Should Contain    ${html_source}    部门外作者姓名

    Execute JavaScript    window.scrollTo(0,1200) 
    Sleep    2s

    Wait Until Element Is Visible    //span[@id="select2-selUser0-container"]    timeout=5s
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    Chitsutha Soomlek
    Click Element    //span[@id="select2-selUser0-container"]

    #books
    Execute JavaScript    window.scrollTo(0,-1200) 
    Sleep    2s
    Click Element    xpath=//span[contains(text(), '管理出版物')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/books') and contains(text(), '书籍')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/books') and contains(text(), '书籍')]
    Sleep    5s

    ${html_source}=    Get Source
    Log    ${html_source}
    Should Contain    ${html_source}    书籍
    Should Contain    ${html_source}    显示
    Get Text    xpath=//th[contains(text(), '不。')]
    Should Contain    ${html_source}    姓名
    Should Contain    ${html_source}    年
    Get Text    xpath=//th[contains(text(), '出版物来源')]

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    添加一本书
    Should Contain    ${html_source}    填写详细信息
    Should Contain    ${html_source}    书名
    Should Contain    ${html_source}    出版地
    Should Contain    ${html_source}    年（广告）
    Should Contain    ${html_source}    页数

    # View
    Go To   ${SERVER}/books
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # Wait for page load
    ${html_source}=    Get Source
    Should Contain    ${html_source}    行动书详情
    Should Contain    ${html_source}    书籍详细信息信息
    Should Contain    ${html_source}    书名
    Should Contain    ${html_source}    年
    Should Contain    ${html_source}    出版物来源
    Should Contain    ${html_source}    页
    Should Contain    ${html_source}    后退

    # Edit
    Go To   ${SERVER}/books
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='Edit']
    Sleep   2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑书籍详细信息
    Should Contain    ${html_source}    填写详细信息
    Should Contain    ${html_source}    书名
    Should Contain    ${html_source}    出版地
    Should Contain    ${html_source}    出版年份（B.E.）
    Should Contain    ${html_source}    页数（页面）
        
    # Other Academic Works
    Click Element    xpath=//span[contains(text(), '管理出版物')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/patents') and contains(text(), '专利')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/patents') and contains(text(), '专利')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    其他学术作品 (专利, 实用新型, 版权)
    Should Contain    ${html_source}    显示
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(., ' 添加')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary')]
    Should Contain    ${button_text}    添加
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    编号
    Should Contain    ${html_source}    类别
    ${text}=    Get Text    xpath=//th[contains(text(), '注册日期')]
    Should Contain    ${text}    注册日期
    ${text}=    Get Text    xpath=//th[contains(text(), '注册编号')]
    Should Contain    ${text}    注册编号
    ${text}=    Get Text    xpath=//th[contains(text(), '创建者')]
    Should Contain    ${text}    创建者
    Should Contain    ${html_source}    操作
    ${full_text}=    Execute JavaScript    return document.querySelector("td:nth-child(2)").textContent.trim();
    Log    ${full_text}
    Should Contain    ${full_text}    เอกสารประกอบการสอนการเขียนโปรแกรมเบื้องต้น
    ${text}=    Get Text    xpath=//td[contains(text(), '版权')]
    Should Contain    ${text}    版权

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    添加
    Should Contain    ${html_source}    输入专利、实用新型或版权的详细信息
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    类别
    Should Contain    ${html_source}    注册日期
    Should Contain    ${html_source}    注册编号
    Should Contain    ${html_source}    内部作者
    Should Contain    ${html_source}    外部作者

    Click Element   //button[@id='add-btn2']
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="form-control"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    watchara sritonwong

    Capture Page Screenshot

    # View
    Go To   ${SERVER}/patents
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=3s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep   3s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    其他学术作品 (专利, 实用新型, 版权)
    Should Contain    ${html_source}    输入专利、实用新型或版权的详细信息
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    类别
    Should Contain    ${html_source}    注册日期
    Should Contain    ${html_source}    注册编号
    Should Contain    ${html_source}    创建者
    Should Contain    ${html_source}    共同创建者
    Should Contain    ${html_source}    书籍
    Should Contain    ${html_source}    Pusadee Seresangtakul

    # Edit
    Go To    ${SERVER}/patents
    Sleep    2s
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='Edit']
    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑其他学术作品详情
    Should Contain    ${html_source}    输入专利、实用新型或版权的详细信息
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    类别
    Should Contain    ${html_source}    注册日期
    Should Contain    ${html_source}    注册编号
    Should Contain    ${html_source}    内部作者
    Should Contain    ${html_source}    外部作者
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    Pusadee Seresangtakul
    Click Element    //span[@id="select2-selUser0-container"]

    Close Browser