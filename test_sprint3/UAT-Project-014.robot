* Settings *
Library           SeleniumLibrary

* Variables *
${SERVER}                    http://127.0.0.1:8000
${USER_USERNAME}             admin@gmail.com
${USER_PASSWORD}             12345678
${LOGIN URL}                  ${SERVER}/login
${USER URL}                  ${SERVER}/dashboard
${CHROME_BROWSER_PATH}    E:/Software Engineering/chromefortesting/chrome.exe
${CHROME_DRIVER_PATH}    E:/Software Engineering/chromefortesting/chromedriver.exe

${VIEW_BUTTON_XPATH}    //a[contains(@class, 'btn-outline-primary')]/i[contains(@class, 'mdi-eye')]
${EDIT_BUTTON_XPATH}    //a[contains(@class, 'btn-outline-success') and @title='แก้ไข']
${ADD_BUTTON_XPATH}     //a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and .//i[contains(@class, 'mdi-plus')]]
${DELETE_BUTTON_XPATH}    //button[contains(@class, 'btn-outline-danger') and contains(@class, 'btn-sm') and contains(@class, 'show_confirm')]/i[contains(@class, 'mdi-delete')]

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
    Go To    ${LOGIN URL}
    Login Page Should Be Open
    Maximize Browser Window

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
    [Tags]    OpenUserPage
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    FOR    ${word}    IN    @{EXPECTED_WORDS_DASHBOARD_TH}
        Should Contain    ${html_source}    ${word}
    END

Profile Page by thai
    #[tags]      Profile
    Go To    ${SERVER}/profile
    Sleep    2s
    #Switch Language To    th    ไทย
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

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='รหัสผ่าน']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    รหัสผ่านเก่า
    Should Contain    ${html_source}    รหัสผ่านใหม่
    Should Contain    ${html_source}    ยืนยันรหัสผ่านใหม่
    Should Contain    ${html_source}    การตั้งค่ารหัสผ่าน
    ${placeholder_value}=    Get Element Attribute    id=inputpassword    placeholder
    Should Be Equal    ${placeholder_value}    กรอกรหัสผ่านปัจจุบัน

Funds Page By Thai
    Go To    ${SERVER}/funds
    Sleep    2s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    ทุนวิจัย
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    ประเภททุน
    Should Contain    ${html_source}    ระดับทุน
    Should Match Regexp   ${html_source}    .*Statistical Thai*.
    Should Contain    ${html_source}    ทุนภายใน
    Should Contain    ${html_source}    ไม่ระบุ

    # View
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

    #Edit
    Go To    ${SERVER}/funds
    Sleep    1s
    
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
    Sleep    1s

    #ADD
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    ประเภททุนวิจัย
    Should Contain    ${html_source}    ระดับทุน
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    โครงการวิจัย
    Sleep    2s

Research Projects Page By Thai
    Go To    ${SERVER}/researchProjects
    Sleep    1s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    โครงการวิจัย
    Should Contain    ${html_source}    ปี
    Should Contain    ${html_source}    ชื่อโครงการ
    Should Contain    ${html_source}    หัวหน้ากลุ่มวิจัย
    Should Contain    ${html_source}    สมาชิก
    Should Contain    ${html_source}    การกระทำ
    Should Contain    ${html_source}    ค้นหา

    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s

    # View
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
    Sleep    1s

    #Add
    Go To    ${SERVER}/researchProjects
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    ชื่อโครงการวิจัย
    Should Contain    ${html_source}    วันที่เริ่มต้น
    Should Contain    ${html_source}    วันที่สิ้นสุด
    Should Contain    ${html_source}    เลือกทุน
    Should Contain    ${html_source}    ปีที่ยื่น (ค.ศ.)
    Should Contain    ${html_source}    งบประมาณ
    Should Contain    ${html_source}    หน่วยงานที่รับผิดชอบ
    Should Contain    ${html_source}    รายละเอียดโครงการ
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
    Should Contain    ${html_source}    งามนิจ
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-selUser0-container"]
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    เลือกผู้ใช้
    Should Contain    ${html_source}    งามนิจ

    Sleep    2s


Research Groups Page By Thai
    [tags]  researchGroups
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchGroups
    Switch Language To    th    ไทย
    Sleep    2s
    
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
    Element Should Contain    //span[@id="select2-head0-container"]    พิพัธน์ เรืองแสง
    Click Element    //span[@id="select2-head0-container"]
    Sleep    1s

    Wait Until Element Is Visible    //span[@id="select2-selUser1-container"]    timeout=5s
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    ชัยพล กีรติกสิกร
    Sleep    1s

    #Add
    Go To    ${SERVER}/researchGroups
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    สร้างกลุ่มวิจัย
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย (English)
    Should Contain    ${html_source}    คำอธิบายกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    คำอธิบายกลุ่มวิจัย (English)
    Should Contain    ${html_source}    รายละเอียดกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    รายละเอียดกลุ่มวิจัย (English)
    Should Contain    ${html_source}    รูปภาพ
    Should Contain    ${html_source}    หัวหน้ากลุ่มวิจัย
    Should Contain    ${html_source}    สมาชิกกลุ่มวิจัย

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    งามนิจ อาจอินทร์
    Should Contain    ${html_source}    งามนิจ
    Sleep    1s

Manage Publications
    [tags]  ManagePublications
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Switch Language To    th    ไทย
    Sleep    2s

    #Papers
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


    Scroll Element Into View    id=paper_type
    Click Element    id=paper_type
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    วารสาร
    Sleep    0.5s



    Scroll Element Into View    id=paper_subtype
    Click Element    id=paper_subtype
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    โปรดเลือกประเภทย่อย
    Should Contain    ${options}    บทความ
    Should Contain    ${options}    บทความในการประชุมวิชาการ
    Should Contain    ${options}    บรรณาธิการ
    Should Contain    ${options}    บทวิจารณ์
    Should Contain    ${options}    คำแก้ไข
    Should Contain    ${options}    บทในหนังสือ


    Sleep    0.5s
    Scroll Element Into View    id=publication
    Click Element    id=publication
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    หนังสือนานาชาติ

    Scroll Element Into View    xpath=//*[contains(text(),'ประเภทเอกสาร')]
    Should Contain              ${html_source}    ประเภทเอกสาร

    Scroll Element Into View    xpath=//*[contains(text(),'ประเภทย่อย')]
    Should Contain              ${html_source}    ประเภทย่อย

    Scroll Element Into View    xpath=//*[contains(text(),'การตีพิมพ์')]
    Should Contain              ${html_source}    การตีพิมพ์

    Scroll Element Into View    xpath=//*[contains(text(),'การอ้างอิง')]
    Should Contain              ${html_source}    การอ้างอิง

    Scroll Element Into View    xpath=//*[contains(text(),'เลขหน้า')]
    Should Contain              ${html_source}    เลขหน้า

    Scroll Element Into View    xpath=//*[contains(text(),'ทุนสนับสนุน')]
    Should Contain              ${html_source}    ทุนสนับสนุน

    Scroll Element Into View    xpath=//*[contains(text(),'บุคคลภายในสาขา')]
    Should Contain              ${html_source}    บุคคลภายในสาขา
    Scroll Element Into View    id=selUser0
    Click Element               id=selUser0
    Click Element               id=pos

    Scroll Element Into View    id=submit

    Scroll Element Into View    xpath=//*[contains(text(),'บุคคลภายนอก')]
    Should Contain              ${html_source}    บุคคลภายนอก
    Scroll Element Into View    id=pos2
    Click Element               id=pos2


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
    Scroll Element Into View    xpath=//a[contains(text(),'กลับ')]
    Click Element    xpath=//a[contains(text(),'กลับ')]

#books
    Click Element    xpath=//span[contains(text(), 'จัดการผลงานวิจัย')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/books') and contains(text(), 'หนังสือ')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/books') and contains(text(), 'หนังสือ')]
    Sleep    2s

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








#Patents
    Click Element    xpath=//span[contains(text(), 'จัดการผลงานวิจัย')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/patents') and contains(text(), 'ผลงานวิชาการอื่นๆ')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/patents') and contains(text(), 'ผลงานวิชาการอื่นๆ')]
















Menu User By Thai
    [tags]  userByTHAI
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/users
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    แผนก
    Should Contain    ${html_source}    อีเมล์
    Should Contain    ${html_source}    บทบาท
    Should Contain    ${html_source}    การกระทำ

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ภาษาไทย
    Should Contain    ${html_source}    English
    Should Contain    ${html_source}    อีเมล์
    Should Contain    ${html_source}    บทบาท
    Should Contain    ${html_source}    การกระทำ
    Sleep    2s
    Go To    ${SERVER}/users
    Sleep    1s

    #Edit
    Go To    ${SERVER}/users/2/edit
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ภาษาไทย
    Should Contain    ${html_source}    English
    Should Contain    ${html_source}    อีเมล์
    Should Contain    ${html_source}    บทบาท
    Should Contain    ${html_source}    แผนก
    Should Contain    ${html_source}    โปรแกรม
    Execute JavaScript    window.scrollTo(0,1500)
    Sleep    1s
    Element Text Should Be    xpath=//button[contains(@class, "btn btn-primary mt-5")]    ส่งข้อมูล
    Wait Until Element Is Visible    xpath=//div[@class='filter-option-inner-inner' and text()='teacher']    10 seconds
    Click Element    xpath=//div[@class='filter-option-inner-inner' and text()='teacher']
    Sleep    1s
    Execute JavaScript    window.scrollTo(0,1500)
    Click Element    xpath=//*[@id="cat"]
    Sleep    1s
    Click Element    xpath=//*[@id="subcat"]

    Go To    ${SERVER}/users

    #New User
    Go To    ${SERVER}/users/create
    ${html_source}=    Get Source
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ภาษาไทย
    Should Contain    ${html_source}    นามสกุล
    Should Contain    ${html_source}    English
    Should Contain    ${html_source}    อีเมล์
    Should Contain    ${html_source}    รหัสผ่าน:
    Should Contain    ${html_source}    ยืนยันรหัสผ่าน
    Should Contain    ${html_source}    บทบาท:
    Should Contain    ${html_source}    แผนก
    Should Contain    ${html_source}    โปรแกรม
    Sleep    1s
    Execute JavaScript    window.scrollTo(0,1500)
    Click Element    xpath=//*[@id="cat"]
    Sleep    1s
    Click Element    xpath=//*[@id="subcat"]
    Go To    ${SERVER}/users

    #importfiles
    Go To    ${SERVER}/importfiles
    ${html_source}=    Get Source
    Page Should Contain    นำเข้าข้อมูลไฟล์


Roles By Thai
    [tags]  RoleByThai
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/roles
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    การดำเนินการ

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    สิทธิ์
    Sleep    2s
    Go To    ${SERVER}/roles

    #Edit
    Go To    ${SERVER}/roles/5/edit
    Page Should Contain    แก้ไขบทบาท
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    สิทธิ์
    Sleep    1s
    Execute JavaScript    window.scrollTo(0,1500)
    Sleep    1s
    Page Should Contain Element    //button[@class="btn btn-primary mt-5" and text()="ส่งข้อมูล"]
    Page Should Contain    กลับ
    Go To    ${SERVER}/roles

    #Delete
    Wait Until Element Is Visible   ${DELETE_BUTTON_XPATH}     timeout=10s
    Click Element    ${DELETE_BUTTON_XPATH}
    Sleep    1s
    Page Should Contain    คุณแน่ใจไหม?
    Page Should Contain    หากคุณลบข้อมูลนี้ มันจะหายไปตลอดกาล
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='ยกเลิก']
    Page Should Contain Element    //button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger') and text()='ตกลง']
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='ยกเลิก']

    #Add
    Wait Until Element Is Visible   ${ADD_BUTTON_XPATH}     timeout=10s
    Click Element    ${ADD_BUTTON_XPATH}
    Page Should Contain    สร้างบทบาท
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    สิทธิ์
    Execute JavaScript    window.scrollTo(0,1500)
    Sleep    1s
    Page Should Contain Element    //button[@class="btn btn-primary" and text()="ส่งข้อมูล"]

Permission By Thai
    [tags]  PermissionByThai
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/permissions
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    สิทธิ์
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    การกระทำ
    Page Should Contain    สิทธิ์ใหม่

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    สิทธิ์
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/permissions
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']

    #Edit
    Click Element    ${EDIT_BUTTON_XPATH}
    Page Should Contain    แก้ไขสิทธิ์
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    สิทธิ์
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/permissions
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']
    Should Contain    ${html_source}    สิทธิ์
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    การกระทำ
    Sleep    1s

    #Delete
    Wait Until Element Is Visible   ${DELETE_BUTTON_XPATH}     timeout=10s
    Click Element    ${DELETE_BUTTON_XPATH}
    Sleep    1s
    Page Should Contain    คุณแน่ใจไหม?
    Page Should Contain    หากคุณลบข้อมูลนี้ มันจะหายไปตลอดกาล
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='ยกเลิก']
    Page Should Contain Element    //button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger') and text()='ตกลง']
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='ยกเลิก']
    Sleep    1s

    #Add
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${SERVER}/permissions/create']
    Page Should Contain    สร้างสิทธิ์
    Page Should Contain    ชื่อ
    Page Should Contain    ส่ง
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/permissions
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']

Department By Thai
    [tags]  DepartmentByThai
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/departments
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    แผนกทั้งหมด
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    การกระทำ

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Page Should Contain    แผนก
    Page Should Contain    ชื่อแผนก (ภาษาไทย)
    Page Should Contain    ชื่อแผนก (ภาษาอังกฤษ)
    Page Should Contain    สาขาวิชาวิทยาการคอมพิวเตอร์
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/departments
    Sleep    1s
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']

    #Edit
    Click Element    ${EDIT_BUTTON_XPATH}
    Page Should Contain    แก้ไขแผนก
    Page Should Contain    ชื่อแผนก (ภาษาไทย)
    Page Should Contain    ชื่อแผนก (ภาษาอังกฤษ)
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/departments
    Sleep    1s
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']
    Sleep    1s

    #Delete
    Wait Until Element Is Visible   ${DELETE_BUTTON_XPATH}     timeout=10s
    Click Element    ${DELETE_BUTTON_XPATH}
    Sleep    1s
    Page Should Contain    คุณแน่ใจไหม?
    Page Should Contain    หากคุณลบข้อมูลนี้ มันจะหายไปตลอดกาล
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='ยกเลิก']
    Page Should Contain Element    //button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger') and text()='ตกลง']
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='ยกเลิก']
    Sleep    1s

Experts By Thai
    [tags]  ExpertsByThai
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Switch Language To    th    ไทย
    Scroll Element Into View    xpath=//a[@href='${SERVER}/experts']
    Sleep    1s
    Click Element    xpath=//a[@href='${SERVER}/experts']
    Sleep    1s
    Page Should Contain    หมายเลขประจำตัว
    Page Should Contain    ชื่ออาจารย์
    Page Should Contain    ชื่อ
    Page Should Contain    การกระทำ
    Page Should Contain    ความเชี่ยวชาญของอาจารย์
    Page Should Contain    คำรณ สุนัติ

    #Edit
    Click Element    xpath=//a[@id='edit-expertise']
    Sleep    1s
    Page Should Contain    แก้ไขความเชี่ยวชาญ
    Page Should Contain    ชื่อ
    Page Should Contain    ส่ง
    Page Should Contain    ยกเลิก
    ${URL}    Set Variable    ${SERVER}/experts
    Click Element    xpath=//a[@class='btn btn-danger' and @href='${URL}']
    Sleep    1s

    #Delete
    Click Element    xpath=//button[@id='delete-expertise']
    Page Should Contain    คุณแน่ใจหรือไม่?
    Page Should Contain    หากลบข้อมูลนี้จะไม่สามารถกู้คืนได้
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='ยกเลิก']
    Sleep    1s
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='ยกเลิก']
