* Settings *
Library           SeleniumLibrary

* Variables *
${SERVER}                    http://127.0.0.1:8000
${USER_USERNAME}             pusadee@kku.ac.th
${USER_PASSWORD}             123456789
${LOGIN URL}                  ${SERVER}/login
${USER URL}                  ${SERVER}/dashboard
${CHROME_BROWSER_PATH}    /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
${CHROME_DRIVER_PATH}    /usr/local/bin/chromedriver
${VIEW_BUTTON_XPATH}    //a[contains(@class, 'btn-outline-primary')]/i[contains(@class, 'mdi-eye')]
${EDIT_BUTTON_XPATH}    //a[contains(@class, 'btn-outline-success') and @title='แก้ไข']
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
    Should Contain    ${html_source}    เพิ่มวารผลงานตีพิมพ์
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
    Element Should Contain    //span[@id="select2-selUser0-container"]    ชิตสุธา สุ่มเล็ก
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

    # View
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

    
    #View
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
    Capture Page Screenshot
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

    Capture Page Screenshot

    Close Browser
