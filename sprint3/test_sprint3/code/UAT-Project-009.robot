* Settings *
Documentation    UAT-009: Test Role Staff to Switch Language.
Library           SeleniumLibrary
Library    String

* Variables *
${SERVER}                    https://csgroup568.cpkkuhost.com
${USER_USERNAME}             staff@gmail.com
${USER_PASSWORD}             123456789
${LOGIN URL}                  ${SERVER}/login
${USER URL}                  ${SERVER}/dashboard
${CHROME_BROWSER_PATH}    C:/Users/ACER/testing/chrome.exe  
${CHROME_DRIVER_PATH}    C:/Users/ACER/testing/chromedriver.exe  
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
...    staff
...    Dashboard
...    Profile
...    User Profile
...    Option
...    Manage Fund
...    Research Project
...    Research Group
...    Manage Publications
...    Published Research
...    Book
...    Patents
...    Departments
...    Manage Programs
...    Logout


@{EXPECTED_WORDS_DASHBOARD_TH}
...    ระบบจัดการข้อมูลการวิจัย
...    ยินดีต้อนรับเข้าสู่ระบบจัดการข้อมูลวิจัยของสาขาวิชาวิทยาการคอมพิวเตอร์
...    สวัสดี
...    เจ้าหน้าที่
...    แดชบอร์ด
...    โปรไฟล์
...    โปรไฟล์ผู้ใช้
...    ตัวเลือก
...    จัดการทุน
...    โครงการวิจัย
...    กลุ่มวิจัย
...    จัดการผลงานวิจัย
...    ผลงานวิจัยที่เผยแพร่
...    หนังสือ
...    ผลงานวิชาการอื่นๆ
...    ออกจากระบบ
       
        

@{EXPECTED_WORDS_USER_CN}
...    研究信息管理系统
...    欢迎来到计算机科学系的研究信息管理系统
...    你好
...    员工
...    仪表板
...    个人资料
...    用户资料
...    选项
...    管理资金
...    研究项目
...    研究小组
...    管理出版物
...    已发布的研究
...    书籍
...    专利
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
    [Arguments]    ${lang_code}    ${expected_language}    ${expected_button_text}=${EMPTY}
    
    # ตรวจสอบภาษาปัจจุบันก่อน
    ${current_lang}=    Get Text    id=navbarDropdownMenuLink
    Log    Current Language: ${current_lang}
    
    # ถ้าภาษาปัจจุบันตรงกับที่ต้องการแล้ว ไม่ต้องเปลี่ยน
    IF    '${current_lang}' == '${expected_language}'
        Log    Language already set to ${expected_language}, skipping switch
    ELSE
        # รอให้ปุ่ม dropdown แสดงผล
        Wait Until Element Is Visible    id=navbarDropdownMenuLink    15s
        Mouse Over    id=navbarDropdownMenuLink
        Click Element    id=navbarDropdownMenuLink
        
        # ใช้ JavaScript เพื่อบังคับคลิก ถ้าการคลิกปกติไม่ทำงาน
        Execute JavaScript    document.querySelector('#navbarDropdownMenuLink').click()
        
        # รอ dropdown menu และตรวจสอบด้วย XPath ที่แม่นยำขึ้น
        Wait Until Element Is Visible    xpath=//div[contains(@class, 'dropdown-menu') and contains(@class, 'show')]    15s
        ${dropdown_html}=    Get Element Attribute    xpath=//div[contains(@class, 'dropdown-menu') and contains(@class, 'show')]    innerHTML
        
        # คลิกเปลี่ยนภาษา
        Wait Until Element Is Visible    xpath=//a[contains(@href, '/lang/${lang_code}')]    10s
        Click Element    xpath=//a[contains(@href, '/lang/${lang_code}')]
        Sleep    5s
        
        # ตรวจสอบว่าภาษาเปลี่ยนแล้ว
        ${new_lang}=    Get Text    id=navbarDropdownMenuLink
        Should Contain    ${new_lang}    ${expected_language}
    END
    
    # ถ้ามีการระบุ expected_button_text ให้ตรวจสอบปุ่ม
    IF    '${expected_button_text}' != '${EMPTY}'
        Wait Until Element Is Visible    id=change_picture_btn    10s
        ${button_text}=    Get Text    id=change_picture_btn
        Should Contain    ${button_text}    ${expected_button_text}
        
    END

SweetAlert Should Be Visible With Success Message
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-text') and contains(text(), 'ลบสำเร็จแล้ว')]    10s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm')]    10s    

Check InCo User
    Scroll Element Into View    //span[@id="select2-selUser0-container"]
    Wait Until Element Is Visible    //span[@id="select2-selUser0-container"]    timeout=10s
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    เลือกผู้ใช้
    ${html_source}=    Get Source
    Should Contain    ${html_source}    งามนิจ

* Test Cases *
TC1:Dashboard and Profile Page Switch Language To TH
    # Dashboard Page Switch Language To TH
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    5s
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    FOR    ${word}    IN    @{EXPECTED_WORDS_DASHBOARD_TH}
        Should Contain    ${html_source}    ${word}
    END

TC2:Profile Page Switch Language To TH
    #Open profile
    Go To    ${SERVER}/profile
    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='บัญชีผู้ใช้']
    Sleep    1s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    การตั้งค่าโปรไฟล์
    Should Contain    ${html_source}    คำนำหน้า (ภาษาอังกฤษ)
    Should Contain    ${html_source}    ชื่อ (ภาษาอังกฤษ)
    Should Contain    ${html_source}    นามสกุล (ภาษาอังกฤษ)
    Should Contain    ${html_source}    ชื่อ (ภาษาไทย)
    Should Contain    ${html_source}    นามสกุล (ภาษาไทย)
    Should Contain    ${html_source}    อีเมล
    ${update_button_text}=    Get Text    xpath=//button[@type='submit' and contains(@class, 'btn-primary')]
    Should Contain    ${update_button_text}    อัปเดต

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='รหัสผ่าน']
    Sleep    1s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    การตั้งค่ารหัสผ่าน
    Should Contain    ${html_source}    รหัสผ่านเก่า
    Should Contain    ${html_source}    รหัสผ่านใหม่
    Should Contain    ${html_source}    ยืนยันรหัสผ่านใหม่
    Wait Until Element Is Visible    xpath=//form[@id='changePasswordAdminForm']//button[contains(@class, 'btn') and contains(@class, 'btn-primary')]    10s
    ${update_button_text}=    Get Text    xpath=//form[@id='changePasswordAdminForm']//button[contains(@class, 'btn') and contains(@class, 'btn-primary')]
    Should Contain    ${update_button_text}    อัปเดต!!
    Close Browser

TC3:Fund Page TH
    # Open Fund Page TH
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/funds
    Sleep    2s
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    ทุนวิจัย
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    ประเภททุน
    Should Contain    ${html_source}    ระดับทุน
    Should Match Regexp   ${html_source}    .*Statistical Thai*.
    Should Contain    ${html_source}    ทุนภายใน
    Should Contain    ${html_source}    ไม่ระบุ


    # View Fund TH
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=1s
    Click Element    ${VIEW_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    รายละเอียดทุน
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    ปี
    Should Contain    ${html_source}    รายละเอียดทุน
    Should Contain    ${html_source}    ประเภททุน
    Should Contain    ${html_source}    ระดับทุน
    Should Contain    ${html_source}    หน่วยงานที่ให้ทุน
    Should Contain    ${html_source}    เพิ่มรายละเอียดโดย
    Should Contain    ${html_source}    ย้อนกลับ
    ${fund_type}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'ทุนภายใน')]
    Should Be Equal As Strings    ${fund_type}    ทุนภายใน
    ${added_by}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'พุธษดี ศิริแสงตระกูล')]
    Should Be Equal As Strings    ${added_by}    พุธษดี ศิริแสงตระกูล

    # Add Fund TH
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and contains(@href, '/funds/create')]    timeout=2s
    ${add_button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and contains(@href, '/funds/create')]
    Should Contain    ${add_button_text}    เพิ่ม
    Click Element    xpath=//a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and contains(@href, '/funds/create')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    เพิ่มทุนวิจัย
    Should Contain    ${html_source}    กรอกรายละเอียดทุนวิจัย
    Should Contain    ${html_source}    ประเภททุนวิจัย
    Should Contain    ${html_source}    โปรดระบุประเภททุน
    Should Contain    ${html_source}    ทุนภายใน
    Should Contain    ${html_source}    ทุนภายนอก
    Should Contain    ${html_source}    ระดับทุน
    Should Contain    ${html_source}    โปรดระบุระดับทุน
    Should Contain    ${html_source}    ไม่ระบุ
    Should Contain    ${html_source}    สูง
    Should Contain    ${html_source}    กลาง
    Should Contain    ${html_source}    ต่ำ
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    หน่วยงานที่สนับสนุน / โครงการวิจัย

    Click Element       xpath=//*[@id="fund_type"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    โปรดระบุประเภททุน
    Should Contain    ${options}    ทุนภายใน
    Should Contain    ${options}    ทุนภายนอก
    Sleep    1s

    Click Element       xpath=//*[@id="fund_level"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    โปรดระบุระดับทุน
    Should Contain    ${options}    ไม่ระบุ
    Should Contain    ${options}    สูง
    Should Contain    ${options}    กลาง
    Should Contain    ${options}    ต่ำ
    Sleep    1s

    ${submit_button_text}=    Get Text    xpath=//button[@type='submit' and contains(@class, 'btn-primary')]
    Should Contain    ${submit_button_text}    ส่ง
    Log    Submit Button Text: ${submit_button_text}
    ${cancel_button_text}=    Get Text    xpath=//a[contains(@class, 'btn-light')]
    Should Contain    ${cancel_button_text}    ยกเลิก
    Log    Cancel Button Text: ${cancel_button_text}

    # Edit Fund TH
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    ${EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${EDIT_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    แก้ไขกองทุน
    Should Contain    ${html_source}    กรอกข้อมูลแก้ไขรายละเอียดทุนงานวิจัย
    Should Contain    ${html_source}    ประเภททุนวิจัย
    Should Contain    ${html_source}    ระดับทุน
    Should Contain    ${html_source}    ชื่อทุน
    Should Contain    ${html_source}    หน่วยงานที่ให้ทุน
    Sleep    2s  # รอให้หน้าโหลด

    Click Element       xpath=//*[@id="fund_type"]
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    ทุนภายใน
    Should Contain    ${options}    ทุนภายนอก

    Click Element       xpath=//*[@id="fund_level"]
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    ไม่ระบุ
    Should Contain    ${options}    สูง
    Should Contain    ${options}    กลาง
    Should Contain    ${options}    ต่ำ

    # Delete Fund TH
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    title
    Should Contain    ${delete_button_title}    ลบ
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s  # รอ SweetAlert ปรากฏ
    Wait Until Element Is Visible    xpath=//table[@id='example1']    timeout=2s 
    ${row_count}=    Get Element Count    xpath=//table[@id='example1']/tbody/tr
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    คุณแน่ใจหรือไม่?
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    หากคุณลบสิ่งนี้ จะไม่สามารถกู้คืนได้อีก
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    ยกเลิก
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    ตกลง

    # จำลองกด "ตกลง" (ลบจริง)
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]
    Sleep    1s

    # ตรวจสอบ SweetAlert ที่แสดงข้อความ "ลบสำเร็จแล้ว"
    SweetAlert Should Be Visible With Success Message
    Sleep    1s
    Close Browser

TC4:Research Projects Page TH
    # Open Research Projects Page TH
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchProjects
    Sleep    5s
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    โครงการวิจัย
    Should Contain    ${html_source}    ปี
    Should Contain    ${html_source}    ชื่อโครงการ
    Should Contain    ${html_source}    หัวหน้ากลุ่มวิจัย
    Should Contain    ${html_source}    สมาชิก
    Should Contain    ${html_source}    การกระทำ
    Should Match Regexp   ${html_source}    .*นวัตกรรมดัชนีสุขภาพของประชากรไทยโดยวิทยาการข้อมูลเพื่อประโยชน์*.
    Should Match Regexp   ${html_source}    .*สุมณฑา*.
    Should Match Regexp   ${html_source}    .* *.
    Should Contain    ${html_source}    ค้นหา

    # View Research Project TH
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=2s
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
    Should Contain    ${html_source}    สมาชิก

    # Add Research Project TH
    Go To    ${SERVER}/researchProjects
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}

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
    Should Contain    ${html_source}    สถานะ
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

    Go To    ${SERVER}/researchProjects
    Sleep    2s
    
    # Edit Research Project TH
    Wait Until Element Is Visible    ${EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${EDIT_BUTTON_XPATH}
    Sleep    5s
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

    Click Element       xpath=//*[@id="fund"]
    Sleep    1s
    Click Element       xpath=//*[@id="dep"]
    Sleep    1s

    Scroll Element Into View    //select[@class="custom-select my-select" and @id="status"]
    Click Element    //select[@class="custom-select my-select" and @id="status"]
    Sleep    1s


    # Delete Research Project TH
    Scroll Element Into View    //span[@id="select2-head0-container"]
    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=2s
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    พุธษดี ศิริแสงตระกูล
    ${html_source}=    Get Source
    Should Contain    ${html_source}    พุธษดี ศิริแสงตระกูล

    ${inco_count}=    Get Element Count    xpath=//table[@id="dynamicAddRemove"]/tbody/tr
    Run Keyword If    ${inco_count} > 1    Check InCo User  
    Go To    ${SERVER}/researchProjects

    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    title
    Should Contain    ${delete_button_title}    ลบ
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s  # รอ SweetAlert ปรากฏ
    Wait Until Element Is Visible    xpath=//table[@id='example1']    timeout=2s 
    ${row_count}=    Get Element Count    xpath=//table[@id='example1']/tbody/tr
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    คุณแน่ใจหรือไม่?
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    หากคุณลบสิ่งนี้ จะไม่สามารถกู้คืนได้อีก
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    ยกเลิก
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    ตกลง

    # จำลองกด "ยกเลิก" (ไม่ลบจริง)
    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]

    # จำลองกด "ตกลง" (ลบจริง)
    Go To    ${SERVER}/researchProjects
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]
    Sleep    2s

    # ตรวจสอบ SweetAlert ที่แสดงข้อความ "ลบสำเร็จแล้ว"
    SweetAlert Should Be Visible With Success Message
    Close Browser

TC5:Research Groups Page Switch Language To TH
    # Open Research Groups Page TH
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchGroups
    Sleep    2s
    Switch Language To    th    ไทย
    ${html_source}=    Get Source
    Should Contain    ${html_source}    กลุ่มวิจัย
    Should Contain    ${html_source}    ลำดับที่
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    หัวหน้ากลุ่มวิจัย
    Should Contain    ${html_source}    สมาชิก
    Should Contain    ${html_source}    การกระทำ
    Should Match Regexp   ${html_source}    .*เทคโนโลยี GIS ขั้นสูง (AGT)*.
    Should Match Regexp   ${html_source}    พิพัธน์
    Should Match Regexp   ${html_source}    .*ชัยพล*.
    Should Contain    ${html_source}    ค้นหา
    
    # View Research Groups TH
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=2s
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
    Click Element    xpath=//a[@class='btn btn-primary mt-5']
    Sleep    2s


    # Add Research Groups TH
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
    Sleep    1s

    Scroll Element Into View    xpath=//button[@id='add-btn2']
    Wait Until Element Is Visible    xpath=//button[@id='add-btn2']    timeout=2s
    Click Button    xpath=//button[@id='add-btn2']
    Sleep    2s
    Scroll Element Into View    //span[@id="select2-selUser1-container"]
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    เลือกผู้ใช้
    Sleep    2s
    Scroll Element Into View    xpath=//a[@class='btn btn-light mt-5']
    Click Element    xpath=//a[@class='btn btn-light mt-5']
    Sleep    2s

    # Edit Research Groups TH
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    แก้ไขข้อมูลกลุ่มวิจัย
    Should Contain    ${html_source}    กรอกข้อมูลแก้ไขรายละเอียดกลุ่มวิจัย
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    ชื่อกลุ่มวิจัย (English)
    Should Contain    ${html_source}    คำอธิบายกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    คำอธิบายกลุ่มวิจัย (English)
    Should Contain    ${html_source}    รายละเอียดกลุ่มวิจัย (ภาษาไทย)
    Should Contain    ${html_source}    รายละเอียดกลุ่มวิจัย (English)
    Should Contain    ${html_source}    รูปภาพ
    Should Contain    ${html_source}    หัวหน้ากลุ่มวิจัย
    Should Contain    ${html_source}    สมาชิกกลุ่มวิจัย
    Sleep    2s

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=2s
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    พิพัธน์ เรืองแสง
    Click Element    //span[@id="select2-head0-container"]
    
    Scroll Element Into View    //span[@id="select2-selUser1-container"]
    Wait Until Element Is Visible    //span[@id="select2-selUser1-container"]    timeout=3s
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    ชัยพล กีรติกสิกร
    Click Element    //span[@id="select2-selUser1-container"]  # Re-click to collapse
    Sleep    1s  # Give it time to close

    Scroll Element Into View    //span[@id="select2-selUser2-container"]
    Wait Until Element Is Visible    //span[@id="select2-selUser2-container"]    timeout=3s
    Click Element    //span[@id="select2-selUser2-container"]
    Element Should Contain    //span[@id="select2-selUser2-container"]    ณกร วัฒนกิจ
    Sleep    2s
    Close Browser    

TC6:Manage Publications Page TH
    # Open Published Research Page TH
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/dashboard
    Sleep    2s
    Switch Language To    th    ไทย
    Click Element    xpath=//span[contains(text(), 'จัดการผลงานวิจัย')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/papers') and contains(text(), 'ผลงานวิจัยที่เผยแพร่')]    timeout=5s
    Click Element    xpath=//a[contains(@href, '/papers') and contains(text(), 'ผลงานวิจัยที่เผยแพร่')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    งานวิจัยที่ตีพิมพ์
    Should Contain    ${html_source}    ชื่อเรื่อง
    Should Contain    ${html_source}    ลำดับ
    Should Contain    ${html_source}    ประเภท
    Should Contain    ${html_source}    ปีที่ตีพิมพ์
    Should Contain    ${html_source}    การกระทำ
    Should Contain    ${html_source}    ค้นหา 
    Should Contain    ${html_source}    วารสาร
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
    ${keyword_note}=    Get Text    //p[@class="text-danger"]
    Should Be Equal    ${keyword_note}    ***แต่ละคําต้องคั่นด้วยเครื่องหมายเซมิโคลอน (;) แล้วเว้นวรรคหนึ่งครั้ง
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="selectpicker"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Scopus
    Should Contain    ${options}    Web Of Science
    Should Contain    ${options}    TCI
    Scroll Element Into View    //select[@class="custom-select my-select" and @name="paper_type"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    วารสาร
    Should Contain    ${options}    รายงานการประชุมวิชาการ
    Should Contain    ${options}    ชุดหนังสือ 
    Should Contain    ${options}    หนังสือ
    Scroll Element Into View    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    โปรดเลือกประเภทย่อย
    Should Contain    ${options}    บทความ
    Should Contain    ${options}    บทความในการประชุมวิชาการ
    Should Contain    ${options}    บรรณาธิการ
    Should Contain    ${options}    บทวิจารณ์
    Should Contain    ${options}    คำแก้ไข
    Should Contain    ${options}    บทในหนังสือ
    Scroll Element Into View    //select[@class="custom-select my-select" and @name="publication"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    โปรดเลือกประเภท 
    Should Contain    ${options}    วารสารนานาชาติ
    Should Contain    ${options}    หนังสือนานาชาติ
    Should Contain    ${options}    การประชุมวิชาการนานาชาติ
    Should Contain    ${options}    การประชุมวิชาการในประเทศ
    Should Contain    ${options}    วารสารในประเทศ
    Should Contain    ${options}    หนังสือในประเทศ
    Should Contain    ${options}    นิตยสารในประเทศ
    Should Contain    ${options}    บทในหนังสือ
    Scroll Element Into View    //select[@id="selUser0"]
    Wait Until Element Is Visible    //select[@id="selUser0"]    timeout=3s
    Click Element    //select[@id="selUser0"]
    Element Should Contain    //select[@id="selUser0"]    เลือกผู้ประพันธ์
    Sleep    1s
    Scroll Element Into View    //select[@id="pos"]
    Wait Until Element Is Visible    //select[@id="pos"]    timeout=3s
    Click Element    //select[@id="pos"]
    Element Should Contain    //select[@id="pos"]    ผู้ประพันธ์อันดับแรก
    Sleep    1s
    Scroll Element Into View    //input[@name="fname[]"]
    Wait Until Element Is Visible    //input[@name="fname[]"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="fname[]"]    placeholder
    Should Be Equal    ${placeholder}    ชื่อ
    Scroll Element Into View    //input[@name="lname[]"]
    Wait Until Element Is Visible    //input[@name="lname[]"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="lname[]"]    placeholder
    Should Be Equal    ${placeholder}    นามสกุล
    Scroll Element Into View    //select[@id="pos2"]
    Wait Until Element Is Visible    //select[@id="pos2"]    timeout=3s
    Click Element    //select[@id="pos2"]
    Element Should Contain    //select[@id="pos2"]    ผู้ประพันธ์อันดับแรก
    Sleep    1s
    Scroll Element Into View    xpath=//a[@class='btn btn-light']
    Click Element    xpath=//a[@class='btn btn-light']
    Sleep    1s
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=5s
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
    Should Contain    ${html_source}    วารสาร
    Should Contain    ${html_source}    บทความ
    Should Contain    ${html_source}    ผู้ประพันธ์อันดับแรก:
    Should Contain    ${html_source}    Loan Thi-Thuy Ho
    Should Contain    ${html_source}    ผู้ประพันธ์ร่วม:
    Should Contain    ${html_source}    สมจิตร อาจอินทร์
    Should Contain    ${html_source}    ผู้ประพันธ์บรรณกิจ:
    Should Contain    ${html_source}    งามนิจ อาจอินทร์
    Scroll Element Into View    xpath=//a[@class='btn btn-primary mt-5']
    Click Element    xpath=//a[@class='btn btn-primary mt-5']
    Sleep    1s

    # Open Books Page TH
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
    Should Contain    ${html_source}    หน้าหนังสือ
    Should Contain    ${html_source}    การกระทำ
    Should Contain    ${html_source}    ไม่พบข้อมูลที่ตรงกัน
    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    เพิ่มหนังสือ
    Should Contain    ${html_source}    กรอกรายละเอียดหนังสือ
    Should Contain    ${html_source}    ชื่อหนังสือ
    Should Contain    ${html_source}    สถานที่เผยแพร่
    Should Contain    ${html_source}    ปี (โฆษณา)
    Should Contain    ${html_source}    จำนวนหน้า
    Scroll Element Into View    xpath=//a[@class='btn btn-light']
    Click Element    xpath=//a[@class='btn btn-light']
    Sleep    1s

    # Open Other Academic Works Page TH
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/patents') and contains(text(), 'ผลงานวิชาการอื่นๆ')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/patents') and contains(text(), 'ผลงานวิชาการอื่นๆ')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    ผลงานวิชาการอื่นๆ (สิทธิบัตร, อนุสิทธิบัตร, ลิขสิทธิ์)
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
    Should Contain    ${full_text}    การศึกษาสภาพแวดล้อมเมืองด้วยข้อมูลภาพถ่ายดาวเทียม
    ${text}=    Get Text    xpath=//td[contains(text(), 'หนังสือ')]
    Should Contain    ${text}    หนังสือ
    ${name}=    Get Text    xpath=//td[contains(text(), 'ชัยพล กีรติกสิกร')]
    Should Contain    ${name}    ชัยพล กีรติกสิกร
    Sleep    1s
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=3s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep   3s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    ผลงานวิชาการอื่นๆ (สิทธิบัตร, อนุสิทธิบัตร, ลิขสิทธิ์)
    Should Contain    ${html_source}    กรอกข้อมูลรายละเอียดงานสิทธิบัตร, อนุสิทธิบัตร, ลิขสิทธิ์
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ประเภท
    Should Contain    ${html_source}    หนังสือ
    Should Contain    ${html_source}    วันที่ได้รับลิขสิทธิ์
    Should Contain    ${html_source}    เลขทะเบียน
    Should Contain    ${html_source}    ชัยพล กีรติกสิกร
    Should Contain    ${html_source}    ผู้จัดทำ
    Should Contain    ${html_source}    ผู้จัดทำ (ร่วม)
    Should Contain    ${html_source}    หนังสือ
    Should Contain    ${html_source}    เลขที่
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary btn-sm') and contains(., 'กลับ')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary btn-sm')]
    Should Contain    ${button_text}    กลับ
    Click Element    xpath=//a[contains(@class, 'btn btn-primary btn-sm')]
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    เพิ่ม
    Should Contain    ${html_source}    กรอกข้อมูลรายละเอียดงานสิทธิบัตร, อนุสิทธิบัตร, ลิขสิทธิ์
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ประเภท
    Should Contain    ${html_source}    หนังสือ
    Should Contain    ${html_source}    วันที่ได้รับลิขสิทธิ์
    Should Contain    ${html_source}    เลขทะเบียน
    Should Contain    ${html_source}    อาจารย์ในสาขา
    Should Contain    ${html_source}    บุคคลภายนอก
    Should Contain    ${html_source}    กรอกชื่อ (First name)
    Should Contain    ${html_source}    กรอกนามสกุล (Last name)
    Scroll Element Into View    //select[@name="ac_type"]
    Click Element    //select[@name="ac_type"]
    Element Should Contain    //select[@name="ac_type"]    โปรดเลือกประเภท
    Sleep    2s
    Scroll Element Into View    xpath=//button[@id='add-btn2']
    Wait Until Element Is Visible    xpath=//button[@id='add-btn2']    timeout=5s
    Click Button    xpath=//button[@id='add-btn2']
    Sleep    5s
    Scroll Element Into View    //select[@id="selUser1"]
    Click Element    //select[@id="selUser1"]
    Element Should Contain    //select[@id="selUser1"]    เลือกสมาชิก
    Sleep    2s
    Scroll Element Into View    xpath=//button[contains(@class, 'btn btn-primary me-2') and contains(., 'บันทึก')]
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary me-2') and contains(., 'บันทึก')]    timeout=5s
    ${button}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary me-2')]
    Should Contain    ${button}    บันทึก
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-light') and contains(., 'ยกเลิก')]    timeout=5s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-light')]
    Should Contain    ${button_text}    ยกเลิก
    Scroll Element Into View    xpath=//a[contains(@class, 'btn btn-light') and contains(., 'ยกเลิก')]
    Click Element    xpath=//a[contains(@class, 'btn btn-light')]
    Close Browser

TC7:Department Page TH
    # Open Department Page TH
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    th    ไทย
    Click Element    xpath=//span[contains(text(), 'แผนก')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    แผนกทั้งหมด
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    สาขาวิชาวิทยาการคอมพิวเตอร์
    Should Contain    ${html_source}    การกระทำ
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'เพิ่มแผนกใหม่')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    เพิ่มแผนกใหม่
    Sleep    2s

    # View Department TH
    Click Element    xpath=//i[contains(@class, 'mdi mdi-eye')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    แผนก
    Should Contain    ${html_source}    ชื่อแผนก (ภาษาไทย):
    Should Contain    ${html_source}    ชื่อแผนก (ภาษาอังกฤษ):
    Should Contain    ${html_source}    สาขาวิชาวิทยาการคอมพิวเตอร์
    Should Contain    ${html_source}    Department of Computer Science
    Sleep    1s
    Go To    ${SERVER}/departments


    # Add Department TH
    Click Element    xpath=//a[contains(@class, 'btn btn-primary')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    สร้างแผนก
    Should Contain    ${html_source}    ชื่อแผนก (ภาษาไทย):
    Should Contain    ${html_source}    ชื่อแผนก (ภาษาอังกฤษ):
    Wait Until Element Is Visible    //input[@name="department_name_th"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="department_name_th"]    placeholder
    Should Be Equal    ${placeholder}    ชื่อแผนกภาษาไทย
    Wait Until Element Is Visible    //input[@name="department_name_en"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="department_name_en"]    placeholder
    Should Be Equal    ${placeholder}    ชื่อแผนกภาษาอังกฤษ
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary') and contains(., 'ยืนยัน')]    2s
    ${button_text}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    ยืนยัน
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'แผนกทั้งหมด')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    แผนกทั้งหมด
    Sleep    1s
    Click Element    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'แผนกทั้งหมด')]

    # Edit Department TH
    Wait Until Element Is Visible    //a[contains(@class, 'btn btn-outline-primary btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn btn-outline-primary btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    แก้ไขแผนก
    Should Contain    ${html_source}    ชื่อแผนก (ภาษาไทย):
    Should Contain    ${html_source}    ชื่อแผนก (ภาษาอังกฤษ):
    Wait Until Element Is Visible    //input[@name="department_name_th"]    timeout=3s
    ${value}=    Get Element Attribute    //input[@name="department_name_th"]    value
    Should Be Equal    ${value}    สาขาวิชาวิทยาการคอมพิวเตอร์
    Wait Until Element Is Visible    //input[@name="department_name_en"]    timeout=3s
    ${value}=    Get Element Attribute    //input[@name="department_name_en"]    value
    Should Be Equal    ${value}    Department of Computer Science
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary') and contains(., 'ยืนยัน')]    2s
    ${button_text}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    ยืนยัน
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'แผนกทั้งหมด')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    แผนกทั้งหมด
    Sleep    1s
    Click Element    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'แผนกทั้งหมด')]
    Sleep    1s

    # Delete Department TH
    Go To    ${SERVER}/departments
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    title
    Should Contain    ${delete_button_title}    ลบ
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    คุณแน่ใจไหม?
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    หากคุณลบข้อมูลนี้ มันจะหายไปตลอดกาล
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    ยกเลิก
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    ตกลง

    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]
    Wait Until Element Is Not Visible    xpath=//div[contains(@class, 'swal-overlay')]    timeout=2s
    Wait Until Element Is Visible    xpath=//table[contains(@class, 'table table-hover')]    timeout=2s
    Close Browser

TC8:Manage Programs Page TH
    # Open Manage Programs TH
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    th    ไทย
    Click Element    xpath=//span[contains(text(), 'จัดการโปรแกรม')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    หลักสูตร
    Should Contain    ${html_source}    รหัส
    Should Contain    ${html_source}    ชื่อ
    Should Contain    ${html_source}    ระดับ
    Should Contain    ${html_source}    การกระทำ
    Should Contain    ${html_source}    ค้นหา
    Should Contain    ${html_source}    สาขาวิชาวิทยาการคอมพิวเตอร์
    Should Contain    ${html_source}    หลักสูตรวิทยาศาสตรบัณฑิต (วท.บ.)
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(., 'เพิ่ม')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary')]
    Should Contain    ${button_text}    เพิ่ม
    Sleep    2s

    # Add Program TH
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary btn-menu btn-icon-text btn-sm mb-3')]/i[contains(@class, 'mdi mdi-plus btn-icon-prepend')]    timeout=2s
    Click Element    xpath=//a[contains(@class, 'btn btn-primary btn-menu btn-icon-text btn-sm mb-3')]/i[contains(@class, 'mdi mdi-plus btn-icon-prepend')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'modal')]    timeout=2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    เพิ่มโปรแกรมใหม่
    Should Contain    ${html_source}    ระดับการศึกษา
    Should Contain    ${html_source}    สาขาวิชา
    Should Contain    ${html_source}    ชื่อภาษาไทย
    Should Contain    ${html_source}    ชื่อภาษาอังกฤษ
    Scroll Element Into View    //select[@id="degree"]
    Wait Until Element Is Visible    //select[@id="degree"]    timeout=2s
    Click Element    //select[@id="degree"]
    Element Should Contain    //select[@id="degree"]    หลักสูตรวิทยาศาสตรบัณฑิต (วท.บ.)
    Sleep    1s
    Scroll Element Into View    //select[@id="department"]
    Wait Until Element Is Visible    //select[@id="department"]    timeout=2s
    Click Element    //select[@id="department"]
    Element Should Contain    //select[@id="department"]    สาขาวิชาวิทยาการคอมพิวเตอร์
    Sleep    1s
    Scroll Element Into View    //input[@name="program_name_th"]
    Wait Until Element Is Visible    //input[@name="program_name_th"]    timeout=2s
    ${placeholder}=    Get Element Attribute    //input[@name="program_name_th"]    placeholder
    Should Be Equal    ${placeholder}    ชื่อโปรแกรมภาษาไทย
    Scroll Element Into View    //input[@name="program_name_en"]
    Wait Until Element Is Visible    //input[@name="program_name_en"]    timeout=2s
    ${placeholder}=    Get Element Attribute    //input[@name="program_name_en"]    placeholder
    Should Be Equal    ${placeholder}    ชื่อโปรแกรมภาษาอังกฤษ
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-danger') and contains(., 'ยกเลิก')]    timeout=2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-danger')]
    Should Contain    ${button_text}    ยกเลิก
    Click Element    xpath=//a[contains(@class, 'btn btn-danger')]


    # Edit Program TH
    Wait Until Element Is Visible    //a[contains(@class, 'btn btn-outline-success btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn btn-outline-success btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'modal')]    timeout=2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    แก้ไข
    Should Contain    ${html_source}    ระดับการศึกษา
    Should Contain    ${html_source}    สาขาวิชา
    Should Contain    ${html_source}    ชื่อภาษาไทย
    Should Contain    ${html_source}    ชื่อภาษาอังกฤษ
    Scroll Element Into View    //select[@id="degree"]
    Wait Until Element Is Visible    //select[@id="degree"]    timeout=2s
    Click Element    //select[@id="degree"]
    Element Should Contain    //select[@id="degree"]    หลักสูตรวิทยาศาสตรบัณฑิต (วท.บ.)
    Sleep    1s
    Scroll Element Into View    //select[@id="department"]
    Wait Until Element Is Visible    //select[@id="department"]    timeout=2s
    Click Element    //select[@id="department"]
    Element Should Contain    //select[@id="department"]    สาขาวิชาวิทยาการคอมพิวเตอร์
    Sleep    1s
    Scroll Element Into View    //input[@name="program_name_th"]
    Wait Until Element Is Visible    //input[@name="program_name_th"]    timeout=2s
    ${value_th}=    Get Element Attribute    //input[@name="program_name_th"]    value
    ${value_th}=    Strip String    ${value_th} 
    ${expected_th}=    Set Variable    สาขาวิชาวิทยาการคอมพิวเตอร์
    ${expected_th}=    Strip String    ${expected_th}
    Should Be Equal    ${value_th}    ${expected_th}
    Scroll Element Into View    //input[@name="program_name_en"]
    Wait Until Element Is Visible    //input[@name="program_name_en"]    timeout=2s
    ${value_en}=    Get Element Attribute    //input[@name="program_name_en"]    value
    ${value_en}=    Strip String    ${value_en}
    Should Be Equal    ${value_en}    Computer Science
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-danger') and contains(., 'ยกเลิก')]    timeout=2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-danger')]
    Should Contain    ${button_text}    ยกเลิก
    Click Element    xpath=//a[contains(@class, 'btn btn-danger')]
    

    # Delete Program TH
    Go To    ${SERVER}/programs
    Wait Until Element Is Visible    //button[contains(@class, 'btn btn-outline-danger btn-sm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    //button[contains(@class, 'btn btn-outline-danger btn-sm')]    title
    Should Contain    ${delete_button_title}    ลบ
    Click Element    //button[contains(@class, 'btn btn-outline-danger btn-sm')]
    Sleep    2s  # รอ SweetAlert ปรากฏ
    Wait Until Element Is Visible    xpath=//table[@id='example1']    timeout=2s 
    ${row_count}=    Get Element Count    xpath=//table[@id='example1']/tbody/tr
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    คุณแน่ใจไหม?
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    หากคุณลบข้อมูลนี้ มันจะหายไปตลอดกาล
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    ยกเลิก
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    ตกลง

    # จำลองกด "ยกเลิก" (ไม่ลบจริง)
    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]

    # จำลองกด "ตกลง" (ลบจริง)
    Wait Until Element Is Visible    //button[contains(@class, 'btn btn-outline-danger btn-sm')]    timeout=2s
    Click Element    //button[contains(@class, 'btn btn-outline-danger btn-sm')]
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]
    Sleep    2s

    # ตรวจสอบ SweetAlert ที่แสดงข้อความ "ลบสำเร็จ"
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-icon--success')]    timeout=2s
    ${success_message}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${success_message}    ลบสำเร็จ
    Close Browser


TC9:Dashboard Page Switch Language To CN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    FOR    ${word}    IN    @{EXPECTED_WORDS_USER_CN}
        Should Contain    ${html_source}    ${word}
    END
    Sleep    2s

TC10:Profile Page Switch Language To CN
    Go To    ${SERVER}/profile
    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='账户']
    Sleep    1s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    个人资料设置
    Should Contain    ${html_source}    称谓 (英语)
    Should Contain    ${html_source}    名字 (英文)
    Should Contain    ${html_source}    姓氏 (英文)
    Should Contain    ${html_source}    名字 (泰文)
    Should Contain    ${html_source}    姓氏 (泰文)
    Should Contain    ${html_source}    电子邮件
    ${update_button_text}=    Get Text    xpath=//button[@type='submit' and contains(@class, 'btn-primary')]
    Should Contain    ${update_button_text}    更新

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='密码']
    Sleep    1s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    密码设置
    Should Contain    ${html_source}    旧密码
    Should Contain    ${html_source}    新密码
    Should Contain    ${html_source}    确认新密码
    Wait Until Element Is Visible    xpath=//form[@id='changePasswordAdminForm']//button[contains(@class, 'btn') and contains(@class, 'btn-primary')]    10s
    ${update_button_text}=    Get Text    xpath=//form[@id='changePasswordAdminForm']//button[contains(@class, 'btn') and contains(@class, 'btn-primary')]
    Should Contain    ${update_button_text}    更新!!
    Close Browser

TC11:Fund Page CN
    # Open Fund Page CN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/funds
    Sleep    2s
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究基金
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    资本类型
    Should Contain    ${html_source}    资金级别
    Should Match Regexp   ${html_source}    .*Statistical Thai*.
    Should Contain    ${html_source}    操作
    Should Contain    ${html_source}    内部资金
    Should Contain    ${html_source}    未知

    # View Fund CN
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=1s
    Click Element    ${VIEW_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    资金详情
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    资金年份
    Should Contain    ${html_source}    资金详情
    Should Contain    ${html_source}    资本类型
    Should Contain    ${html_source}    资金级别
    Should Contain    ${html_source}    资助机构
    Should Contain    ${html_source}    资金来源
    Should Contain    ${html_source}    返回
    ${fund_type}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), '内部资金')]
    Should Be Equal As Strings    ${fund_type}    内部资金
    ${added_by}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'Pusadee Seresangtakul')]
    Should Be Equal As Strings    ${added_by}    Pusadee Seresangtakul

    # Add Fund CN
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and contains(@href, '/funds/create')]    timeout=2s
    ${add_button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and contains(@href, '/funds/create')]
    Should Contain    ${add_button_text}    添加
    Click Element    xpath=//a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and contains(@href, '/funds/create')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    增加研究基金
    Should Contain    ${html_source}    填写研究资金详情
    Should Contain    ${html_source}    资金类型
    Should Contain    ${html_source}    请定义资金类型
    Should Contain    ${html_source}    内部资金
    Should Contain    ${html_source}    外部资金
    Should Contain    ${html_source}    资金级别
    Should Contain    ${html_source}    请定义资金级别
    Should Contain    ${html_source}    未知
    Should Contain    ${html_source}    高
    Should Contain    ${html_source}    中等
    Should Contain    ${html_source}    低
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    支持机构 / 研究项目

    Click Element       xpath=//*[@id="fund_type"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    请定义资金类型
    Should Contain    ${options}    内部资金
    Should Contain    ${options}    外部资金
    Sleep    1s

    Click Element       xpath=//*[@id="fund_level"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    请定义资金级别
    Should Contain    ${options}    未知
    Should Contain    ${options}    高
    Should Contain    ${options}    中等
    Should Contain    ${options}    低
    Sleep    1s

    ${submit_button_text}=    Get Text    xpath=//button[@type='submit' and contains(@class, 'btn-primary')]
    Should Contain    ${submit_button_text}    提交
    Log    Submit Button Text: ${submit_button_text}
    ${cancel_button_text}=    Get Text    xpath=//a[contains(@class, 'btn-light')]
    Should Contain    ${cancel_button_text}    取消
    Log    Cancel Button Text: ${cancel_button_text}

    # Edit Fund CN
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-outline-success') and @title='编辑']    timeout=2s
    Click Element    xpath=//a[contains(@class, 'btn-outline-success') and @title='编辑']
    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑基金
    Should Contain    ${html_source}    编辑研究资金详情
    Should Contain    ${html_source}    资金类型
    Should Contain    ${html_source}    资金级别
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    资助机构
    Sleep    1s  # รอให้หน้าโหลด

    Click Element       xpath=//*[@id="fund_type"]
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    内部资金
    Should Contain    ${options}    外部资金

    Click Element       xpath=//*[@id="fund_level"]
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    未知
    Should Contain    ${options}    高
    Should Contain    ${options}    中等
    Should Contain    ${options}    低

    # Delete Fund CN
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    title
    Should Contain    ${delete_button_title}    删除
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    你确定吗    # Verify Chinese text
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    如果删除，它将永远消失。
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    取消
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    确定

    # Simulate clicking "Cancel" 
    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Wait Until Element Is Not Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=3s    # Wait for modal to disappear
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]    # Confirm modal is gone

    # Simulate clicking "Confirm"
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-text') and contains(text(), '删除成功')]    timeout=2s    # Verify success message
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm')]    timeout=2s
    Close Browser


TC12:Research Projects Page CN
    # Open Research Projects Page CN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchProjects
    Sleep    5s
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究项目
    Should Contain    ${html_source}    年份
    Should Contain    ${html_source}    项目名称
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    成员
    Should Match Regexp   ${html_source}    .*นวัตกรรมดัชนีสุขภาพของประชากรไทยโดยวิทยาการข้อมูลเพื่อประโยชน์*.
    Should Match Regexp   ${html_source}    .*Sumonta*.
    Should Match Regexp   ${html_source}    .* *.
    Should Contain    ${html_source}    搜索

    # View Research Project CN
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=2s
    Click Element    ${VIEW_BUTTON_XPATH}
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
    Should Contain    ${html_source}    成员

    # Add Research Project CN
    Go To    ${SERVER}/researchProjects
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}

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
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-selUser0-container"]
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    选择用户
    Go To    ${SERVER}/researchProjects
    Sleep    2s
    
    # Edit Research Project CN
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-outline-success') and @title='编辑']    timeout=2s
    Click Element    xpath=//a[contains(@class, 'btn-outline-success') and @title='编辑']
    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑研究项目信息
    Should Contain    ${html_source}    填写信息以编辑研究项目的详细信息。
    Should Contain    ${html_source}    项目名称
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

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="responsible_department"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    计算机科学

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="status"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    申请
    Should Contain    ${options}    进行中
    Should Contain    ${options}    关闭项目

    Click Element       xpath=//*[@id="fund"]
    Sleep    1s
    Click Element       xpath=//*[@id="dep"]
    Sleep    1s

    Scroll Element Into View    //select[@class="custom-select my-select" and @id="status"]
    Click Element    //select[@class="custom-select my-select" and @id="status"]
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=2s
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    Pusadee Seresangtakul
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Pusadee Seresangtakul

    # Delete Research Project CN
    ${inco_count}=    Get Element Count    xpath=//table[@id="dynamicAddRemove"]/tbody/tr
    Run Keyword If    ${inco_count} > 1    Check InCo User  
    Go To    ${SERVER}/researchProjects

    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    title
    Should Contain    ${delete_button_title}    删除
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s  # รอ SweetAlert ปรากฏ
    Wait Until Element Is Visible    xpath=//table[@id='example1']    timeout=2s 
    ${row_count}=    Get Element Count    xpath=//table[@id='example1']/tbody/tr
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    你确定吗
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    如果删除，它将永远消失。
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    取消
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    确定

    # จำลองกด "ยกเลิก" (ไม่ลบจริง)
    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]

    # จำลองกด "ตกลง" (ลบจริง)
    Go To    ${SERVER}/researchProjects
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]
    Sleep    2s

    # ตรวจสอบ SweetAlert ที่แสดงข้อความ "ลบสำเร็จแล้ว"
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-text') and contains(text(), '删除成功')]    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm')]    2s 
    Close Browser

TC13:Research Groups Page Switch Language To CN
    # Open Research Groups Page CN
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
    Should Contain    ${html_source}    成员
    Should Contain    ${html_source}    操作
    Should Match Regexp   ${html_source}    .*เทคโนโลยี GIS ขั้นสูง (AGT)*.
    Should Match Regexp   ${html_source}    Pipat
    Should Match Regexp   ${html_source}    .*Chaiyapon*.
    Should Contain    ${html_source}    搜索
    
    # View Research Groups CN
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=2s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究小组详情
    Should Contain    ${html_source}    研究小组详细信息
    Should Contain    ${html_source}    小组名称（泰语）
    Should Contain    ${html_source}    小组名称（英语）
    Should Contain    ${html_source}    小组描述（泰语）
    Should Contain    ${html_source}    小组描述（英语
    Should Contain    ${html_source}    小组详情（泰语）
    Should Contain    ${html_source}    小组详情（英语）
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    研究小组成员
    Should Contain    ${html_source}    Asst. Prof. Dr.Pipat Reungsang
    Should Contain    ${html_source}    Assoc. Prof. Dr.Chaiyapon Keeratikasikorn
    Should Contain    ${html_source}    Asst. Prof. Dr.Nagon Watanakij
    Click Element    xpath=//a[@class='btn btn-primary mt-5']
    Sleep    2s


    # Add Research Groups CN
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    创建研究小组
    Should Contain    ${html_source}    小组名称（泰语）
    Should Contain    ${html_source}    小组名称（英语）
    Should Contain    ${html_source}    小组描述（泰语）
    Should Contain    ${html_source}    小组描述（英语）
    Should Contain    ${html_source}    小组详情（泰语）
    Should Contain    ${html_source}    小组详情（英语）
    Should Contain    ${html_source}    图片
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    研究小组成员

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Click Element    //span[@id="select2-head0-container"]
    Sleep    1s

    Scroll Element Into View    xpath=//button[@id='add-btn2']
    Wait Until Element Is Visible    xpath=//button[@id='add-btn2']    timeout=2s
    Click Button    xpath=//button[@id='add-btn2']
    Sleep    2s
    Scroll Element Into View    //span[@id="select2-selUser1-container"]
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    选择用户
    Sleep    2s
    Scroll Element Into View    xpath=//a[@class='btn btn-light mt-5']
    Click Element    xpath=//a[@class='btn btn-light mt-5']
    Sleep    2s

    # Edit Research Groups CN
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑研究小组
    Should Contain    ${html_source}    小组名称（泰语）
    Should Contain    ${html_source}    小组名称（英语）
    Should Contain    ${html_source}    小组描述（泰语）
    Should Contain    ${html_source}    小组描述（英语）
    Should Contain    ${html_source}    小组详情（泰语）
    Should Contain    ${html_source}    小组详情（英语）
    Should Contain    ${html_source}    图片
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    研究小组成员

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=2s
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    Pipat Reungsang
    Click Element    //span[@id="select2-head0-container"]
    
    Scroll Element Into View    //span[@id="select2-selUser1-container"]
    Wait Until Element Is Visible    //span[@id="select2-selUser1-container"]    timeout=3s
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    Chaiyapon Keeratikasikorn
    Click Element    //span[@id="select2-selUser1-container"]  # Re-click to collapse
    Sleep    1s  # Give it time to close

    Scroll Element Into View    //span[@id="select2-selUser2-container"]
    Wait Until Element Is Visible    //span[@id="select2-selUser2-container"]    timeout=3s
    Click Element    //span[@id="select2-selUser2-container"]
    Element Should Contain    //span[@id="select2-selUser2-container"]    Nagon Watanakij
    Sleep    2s
    Close Browser 

TC14:Manage Publications Page CN
    # Open Published Research Page CN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    4s
    Switch Language To    zh    中文
    Click Element    xpath=//span[contains(text(), '管理出版物')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/papers') and contains(text(), '已发布的研究')]    timeout=5s
    Click Element    xpath=//a[contains(@href, '/papers') and contains(text(), '已发布的研究')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    已发表研究
    Should Contain    ${html_source}    编号
    Should Contain    ${html_source}    论文名
    Should Contain    ${html_source}    论文类型
    Should Contain    ${html_source}    发表年份
    Should Contain    ${html_source}    操作
    Should Contain    ${html_source}    搜索 
    Should Contain    ${html_source}    期刊

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
    Should Contain    ${html_source}    支持基金
    Should Contain    ${html_source}    部门内作者姓名
    Should Contain    ${html_source}    部门外作者姓名
    Should Contain    ${html_source}    请选择来源标题
    ${keyword_note}=    Get Text    //p[@class="text-danger"]
    Should Be Equal    ${keyword_note}    ***每个词必须用分号（;）和一个空格分隔开。
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="selectpicker"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Scopus
    Should Contain    ${options}    Web Of Science
    Should Contain    ${options}    TCI
    Scroll Element Into View    //select[@class="custom-select my-select" and @name="paper_type"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    期刊
    Should Contain    ${options}    会议论文集
    Should Contain    ${options}    书籍系列 
    Should Contain    ${options}    书籍
    Scroll Element Into View    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    请选择子类型
    Should Contain    ${options}    文章
    Should Contain    ${options}    会议论文
    Should Contain    ${options}    社论
    Should Contain    ${options}    评论
    Should Contain    ${options}    勘误
    Should Contain    ${options}    书中章节
    Scroll Element Into View    //select[@class="custom-select my-select" and @name="publication"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    请选择出版类型  
    Should Contain    ${options}    国际期刊
    Should Contain    ${options}    国际书籍
    Should Contain    ${options}    国际会议
    Should Contain    ${options}    国内会议
    Should Contain    ${options}    国内期刊
    Should Contain    ${options}    国内书籍
    Should Contain    ${options}    国内杂志
    Should Contain    ${options}    书中章节
    Scroll Element Into View    //select[@id="selUser0"]
    Wait Until Element Is Visible    //select[@id="selUser0"]    timeout=3s
    Click Element    //select[@id="selUser0"]
    Element Should Contain    //select[@id="selUser0"]    选择用户
    Sleep    1s
    Scroll Element Into View    //select[@id="pos"]
    Wait Until Element Is Visible    //select[@id="pos"]    timeout=3s
    Click Element    //select[@id="pos"]
    Element Should Contain    //select[@id="pos"]    第一作者
    Sleep    1s
    Scroll Element Into View    //input[@name="fname[]"]
    Wait Until Element Is Visible    //input[@name="fname[]"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="fname[]"]    placeholder
    Should Be Equal    ${placeholder}    名
    Scroll Element Into View    //input[@name="lname[]"]
    Wait Until Element Is Visible    //input[@name="lname[]"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="lname[]"]    placeholder
    Should Be Equal    ${placeholder}    姓
    Scroll Element Into View    //select[@id="pos2"]
    Wait Until Element Is Visible    //select[@id="pos2"]    timeout=3s
    Click Element    //select[@id="pos2"]
    Element Should Contain    //select[@id="pos2"]    第一作者
    Sleep    1s
    Scroll Element Into View    xpath=//a[@class='btn btn-light']
    Click Element    xpath=//a[@class='btn btn-light']
    Sleep    1s
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=5s
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
    Should Contain    ${html_source}    期刊
    Should Contain    ${html_source}    文章
    Should Contain    ${html_source}    第一作者:
    Should Contain    ${html_source}    Loan Thi-Thuy Ho
    Should Contain    ${html_source}    共同作者:
    Should Contain    ${html_source}    Somjit Arch-int
    Should Contain    ${html_source}    通讯作者:
    Should Contain    ${html_source}    Ngamnij Arch-int
    Scroll Element Into View    xpath=//a[@class='btn btn-primary mt-5']
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary mt-5') and contains(., '返回')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary mt-5')]
    Should Contain    ${button_text}    返回
    Click Element    xpath=//a[@class='btn btn-primary mt-5']
    Sleep    1s

    # Open Books Page CN
    Click Element    xpath=//span[contains(text(), '管理出版物')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/books') and contains(text(), '书籍')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/books') and contains(text(), '书籍')]
    Sleep    5s
    ${html_source}=    Get Source
    Log    ${html_source}
    Should Contain    ${html_source}    书
    Should Contain    ${html_source}    显示 
    Get Text    xpath=//th[contains(text(), '不。')]
    Should Contain    ${html_source}    姓名
    Should Contain    ${html_source}    年
    Get Text    xpath=//th[contains(text(), '出版物来源')]
    Should Contain    ${html_source}    页
    Should Contain    ${html_source}    行动
    Should Contain    ${html_source}    未找到匹配的记录
    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    添加一本书
    Should Contain    ${html_source}    填写详细信息
    Should Contain    ${html_source}    书名
    Should Contain    ${html_source}    出版地
    Should Contain    ${html_source}    年（广告）
    Should Contain    ${html_source}    页数
    Scroll Element Into View    xpath=//button[contains(@class, 'btn btn-primary me-2') and contains(., '提交')]
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary me-2') and contains(., '提交')]    timeout=5s
    ${button}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary me-2')]
    Should Contain    ${button}    提交
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-light') and contains(., '取消')]    timeout=5s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-light')]
    Should Contain    ${button_text}    取消
    Click Element    xpath=//a[contains(@class, 'btn btn-light')]
    Sleep    1s

    # Open Other Academic Works Page CN
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/patents') and contains(text(), '专利')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/patents') and contains(text(), '专利')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    其他学术作品 (专利, 实用新型, 版权)
    Should Contain    ${html_source}    显示 
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(., '添加')]    2s
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
    Should Contain    ${full_text}    การศึกษาสภาพแวดล้อมเมืองด้วยข้อมูลภาพถ่ายดาวเทียม
    ${text}=    Get Text    xpath=//td[contains(text(), '书籍')]
    Should Contain    ${text}    书籍
    ${name}=    Get Text    xpath=//td[contains(text(), 'Chaiyapon Keeratikasikorn')]
    Should Contain    ${name}    Chaiyapon Keeratikasikorn
    Sleep    1s
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=3s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep   3s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    其他学术作品 (专利, 实用新型, 版权)
    Should Contain    ${html_source}    输入专利、实用新型或版权的详细信息
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    类别
    Should Contain    ${html_source}    书籍
    Should Contain    ${html_source}    注册日期
    Should Contain    ${html_source}    注册编号
    Should Contain    ${html_source}    Chaiyapon Keeratikasikorn
    Should Contain    ${html_source}    创建者
    Should Contain    ${html_source}    共同创建者
    Should Contain    ${html_source}    注册号:
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary btn-sm') and contains(., '返回')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary btn-sm')]
    Should Contain    ${button_text}    返回
    Click Element    xpath=//a[contains(@class, 'btn btn-primary btn-sm')]
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    添加
    Should Contain    ${html_source}    输入专利、实用新型或版权的详细信息
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    类别
    Should Contain    ${html_source}    注册日期
    Should Contain    ${html_source}    注册编号
    Should Contain    ${html_source}    内部作者
    Should Contain    ${html_source}    外部作者
    Should Contain    ${html_source}    输入名字
    Should Contain    ${html_source}    输入姓氏
    Scroll Element Into View    //select[@name="ac_type"]
    Click Element    //select[@name="ac_type"]
    Element Should Contain    //select[@name="ac_type"]    请选择类别
    Sleep    2s
    Scroll Element Into View    xpath=//button[@id='add-btn2']
    Wait Until Element Is Visible    xpath=//button[@id='add-btn2']    timeout=5s
    Click Button    xpath=//button[@id='add-btn2']
    Sleep    5s
    Scroll Element Into View    //select[@id="selUser1"]
    Click Element    //select[@id="selUser1"]
    Element Should Contain    //select[@id="selUser1"]    选择成员
    Sleep    2s
    Scroll Element Into View    xpath=//button[contains(@class, 'btn btn-primary me-2') and contains(., '提交')]
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary me-2') and contains(., '提交')]    timeout=5s
    ${button}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary me-2')]
    Should Contain    ${button}    提交
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-light') and contains(., '取消')]    timeout=5s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-light')]
    Should Contain    ${button_text}    取消
    Click Element    xpath=//a[contains(@class, 'btn btn-light')]
    Close Browser   

TC15:Department Page CN
    # Open Department Page CN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    zh    中文
    Click Element    xpath=//span[contains(text(), '部门')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    所有部门
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    计算机科学
    Should Contain    ${html_source}    操作
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary') and contains(., '新增部门')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    新增部门
    Sleep    2s

    # View Department CN
    Click Element    xpath=//i[contains(@class, 'mdi mdi-eye')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    部门
    Should Contain    ${html_source}    部门名称（泰语）:
    Should Contain    ${html_source}    部门名称（英语）:
    Should Contain    ${html_source}    สาขาวิชาวิทยาการคอมพิวเตอร์
    Should Contain    ${html_source}    Department of Computer Science
    Sleep    1s
    Go To    ${SERVER}/departments

    # Add Department CN
    Click Element    xpath=//a[contains(@class, 'btn btn-primary')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    创建部门
    Should Contain    ${html_source}    部门名称（泰语）:
    Should Contain    ${html_source}    部门名称（英语）:
    Wait Until Element Is Visible    //input[@name="department_name_th"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="department_name_th"]    placeholder
    Should Be Equal    ${placeholder}    泰文部门名称
    Wait Until Element Is Visible    //input[@name="department_name_en"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="department_name_en"]    placeholder
    Should Be Equal    ${placeholder}    英文部门名称
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary') and contains(., '提交')]    2s
    ${button_text}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    提交
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary') and contains(., '所有部门')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    所有部门
    Sleep    1s
    Click Element    xpath=//a[contains(@class, 'btn btn-primary') and contains(., '所有部门')]

    # Edit Department CN
    Wait Until Element Is Visible    //a[contains(@class, 'btn btn-outline-primary btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn btn-outline-primary btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    修改部门
    Should Contain    ${html_source}    部门名称（泰语）:
    Should Contain    ${html_source}    部门名称（英语）:
    Wait Until Element Is Visible    //input[@name="department_name_th"]    timeout=3s
    ${value}=    Get Element Attribute    //input[@name="department_name_th"]    value
    Should Be Equal    ${value}    สาขาวิชาวิทยาการคอมพิวเตอร์
    Wait Until Element Is Visible    //input[@name="department_name_en"]    timeout=3s
    ${value}=    Get Element Attribute    //input[@name="department_name_en"]    value
    Should Be Equal    ${value}    Department of Computer Science
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary') and contains(., '提交')]    2s
    ${button_text}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    提交
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary') and contains(., '所有部门')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    所有部门
    Click Element    xpath=//a[contains(@class, 'btn btn-primary') and contains(., '所有部门')]
    Sleep    1s

    # Delete Department CN
    Go To    ${SERVER}/departments
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    title
    Should Contain    ${delete_button_title}    删除
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    您确定吗？
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    如果您删除它，它将永远消失。
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    取消
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    好的

    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]
    Wait Until Element Is Not Visible    xpath=//div[contains(@class, 'swal-overlay')]    timeout=2s
    Wait Until Element Is Visible    xpath=//table[contains(@class, 'table table-hover')]    timeout=2s
    Close Browser

TC16:Manage Programs Page CN
    # Open Manage Programs CN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    zh    中文
    Click Element    xpath=//span[contains(text(), '管理程序')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    课程
    Should Contain    ${html_source}    编号
    Should Contain    ${html_source}    专业
    Should Contain    ${html_source}    学位
    Should Contain    ${html_source}    操作
    Should Contain    ${html_source}    搜索
    Should Contain    ${html_source}    信息技术系
    Should Contain    ${html_source}    理学学士学位
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(., '添加')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary')]
    Should Contain    ${button_text}    添加
    Sleep    2s

    # Add Program CN
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary btn-menu btn-icon-text btn-sm mb-3')]/i[contains(@class, 'mdi mdi-plus btn-icon-prepend')]    timeout=2s
    Click Element    xpath=//a[contains(@class, 'btn btn-primary btn-menu btn-icon-text btn-sm mb-3')]/i[contains(@class, 'mdi mdi-plus btn-icon-prepend')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'modal')]    timeout=2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    添加新程序
    Should Contain    ${html_source}    学位
    Should Contain    ${html_source}    系
    Should Contain    ${html_source}    泰语名称
    Should Contain    ${html_source}    英语名称
    Scroll Element Into View    //select[@id="degree"]
    Wait Until Element Is Visible    //select[@id="degree"]    timeout=2s
    Click Element    //select[@id="degree"]
    Element Should Contain    //select[@id="degree"]    理学学士学位 
    Sleep    1s
    Scroll Element Into View    //select[@id="department"]
    Wait Until Element Is Visible    //select[@id="department"]    timeout=2s
    Click Element    //select[@id="department"]
    Element Should Contain    //select[@id="department"]    计算机科学
    Sleep    1s
    Scroll Element Into View    //input[@name="program_name_th"]
    Wait Until Element Is Visible    //input[@name="program_name_th"]    timeout=2s
    ${placeholder}=    Get Element Attribute    //input[@name="program_name_th"]    placeholder
    Should Be Equal    ${placeholder}    项目名称（泰语）
    Scroll Element Into View    //input[@name="program_name_en"]
    Wait Until Element Is Visible    //input[@name="program_name_en"]    timeout=2s
    ${placeholder}=    Get Element Attribute    //input[@name="program_name_en"]    placeholder
    Should Be Equal    ${placeholder}    项目名称（英语）
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-danger') and contains(., '取消')]    timeout=2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-danger')]
    Should Contain    ${button_text}    取消
    Click Element    xpath=//a[contains(@class, 'btn btn-danger')]


    # Edit Program CN
    Wait Until Element Is Visible    //a[contains(@class, 'btn btn-outline-success btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn btn-outline-success btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'modal')]    timeout=2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑
    Should Contain    ${html_source}    学位
    Should Contain    ${html_source}    系
    Should Contain    ${html_source}    泰语名称
    Should Contain    ${html_source}    英语名称
    Scroll Element Into View    //select[@id="degree"]
    Wait Until Element Is Visible    //select[@id="degree"]    timeout=2s
    Click Element    //select[@id="degree"]
    Element Should Contain    //select[@id="degree"]    理学学士学位 
    Sleep    1s
    Scroll Element Into View    //select[@id="department"]
    Wait Until Element Is Visible    //select[@id="department"]    timeout=2s
    Click Element    //select[@id="department"]
    Element Should Contain    //select[@id="department"]    计算机科学
    Sleep    1s
    Scroll Element Into View    //input[@name="program_name_th"]
    Wait Until Element Is Visible    //input[@name="program_name_th"]    timeout=2s
    ${value_th}=    Get Element Attribute    //input[@name="program_name_th"]    value
    ${value_th}=    Strip String    ${value_th} 
    ${expected_th}=    Set Variable    สาขาวิชาวิทยาการคอมพิวเตอร์
    ${expected_th}=    Strip String    ${expected_th}
    Should Be Equal    ${value_th}    ${expected_th}
    Scroll Element Into View    //input[@name="program_name_en"]
    Wait Until Element Is Visible    //input[@name="program_name_en"]    timeout=2s
    ${value_en}=    Get Element Attribute    //input[@name="program_name_en"]    value
    ${value_en}=    Strip String    ${value_en}
    Should Be Equal    ${value_en}    Computer Science
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-danger') and contains(., '取消')]    timeout=2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-danger')]
    Should Contain    ${button_text}    取消
    Click Element    xpath=//a[contains(@class, 'btn btn-danger')]
    

    # Delete Program CN
    Go To    ${SERVER}/programs
    Wait Until Element Is Visible    //button[contains(@class, 'btn btn-outline-danger btn-sm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    //button[contains(@class, 'btn btn-outline-danger btn-sm')]    title
    Should Contain    ${delete_button_title}    删除
    Click Element    //button[contains(@class, 'btn btn-outline-danger btn-sm')]
    Sleep    2s  # รอ SweetAlert ปรากฏ
    Wait Until Element Is Visible    xpath=//table[@id='example1']    timeout=2s 
    ${row_count}=    Get Element Count    xpath=//table[@id='example1']/tbody/tr
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    您确定吗？
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    如果您删除它，它将永远消失。
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    取消
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    好的

    # จำลองกด "ยกเลิก" (ไม่ลบจริง)
    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]

    # จำลองกด "ตกลง" (ลบจริง)
    Wait Until Element Is Visible    //button[contains(@class, 'btn btn-outline-danger btn-sm')]    timeout=2s
    Click Element    //button[contains(@class, 'btn btn-outline-danger btn-sm')]
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]
    Sleep    2s

    # ตรวจสอบ SweetAlert ที่แสดงข้อความ "ลบสำเร็จ"
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-icon--success')]    timeout=2s
    ${success_message}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${success_message}    删除成功
    Close Browser

TC17:Dashboard Page Switch Language To EN
    # Dashboard Page Switch Language To EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    th    ไทย
    Switch Language To    en    English
    ${html_source}=    Get Source
    FOR    ${word}    IN    @{EXPECTED_WORDS_USER_EN}
        Should Contain    ${html_source}    ${word}
    END

TC18:Profile Page Switch Language To EN
    Go To    ${SERVER}/profile
    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='Account']
    Sleep    1s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Profile Settings
    Should Contain    ${html_source}    Name title (English)
    Should Contain    ${html_source}    First name (English)
    Should Contain    ${html_source}    Last name (English)
    Should Contain    ${html_source}    First name (Thai)
    Should Contain    ${html_source}    Last name (Thai)
    Should Contain    ${html_source}    Email
    ${update_button_text}=    Get Text    xpath=//button[@type='submit' and contains(@class, 'btn-primary')]
    Should Contain    ${update_button_text}    Update

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='Password']
    Sleep    1s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Password Settings
    Should Contain    ${html_source}    Old password
    Should Contain    ${html_source}    New password
    Should Contain    ${html_source}    Confirm new password
    Wait Until Element Is Visible    xpath=//form[@id='changePasswordAdminForm']//button[contains(@class, 'btn') and contains(@class, 'btn-primary')]    10s
    ${update_button_text}=    Get Text    xpath=//form[@id='changePasswordAdminForm']//button[contains(@class, 'btn') and contains(@class, 'btn-primary')]
    Should Contain    ${update_button_text}    Update!!
    Close Browser

TC19:Fund Page EN
    # Open Fund Page EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/funds
    Sleep    2s
    Switch Language To    th    ไทย
    Switch Language To    en    English
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Fund
    Should Contain    ${html_source}    Fund Name
    Should Contain    ${html_source}    Fund Type
    Should Contain    ${html_source}    Fund Type
    Should Match Regexp   ${html_source}    .*Statistical Thai*.
    Should Contain    ${html_source}    Internal Capital
    Should Contain    ${html_source}    Unknown


    # View Fund EN
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=1s
    Click Element    ${VIEW_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Fund Detail
    Should Contain    ${html_source}    Fund Name
    Should Contain    ${html_source}    Fund Year
    Should Contain    ${html_source}    Fund Details
    Should Contain    ${html_source}    Fund Type
    Should Contain    ${html_source}    Fund Level
    Should Contain    ${html_source}    Fund Agency
    Should Contain    ${html_source}    Fill fund by
    Should Contain    ${html_source}    Back
    ${fund_type}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'Internal Capital')]
    Should Be Equal As Strings    ${fund_type}    Internal Capital
    ${added_by}=    Get Text    xpath=//p[contains(@class, 'card-text col-sm-9') and contains(text(), 'Pusadee Seresangtakul')]
    Should Be Equal As Strings    ${added_by}    Pusadee Seresangtakul

    # Add Fund EN
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and contains(@href, '/funds/create')]    timeout=2s
    ${add_button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and contains(@href, '/funds/create')]
    Should Contain    ${add_button_text}    ADD
    Click Element    xpath=//a[contains(@class, 'btn-primary') and contains(@class, 'btn-menu') and contains(@href, '/funds/create')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add Fund
    Should Contain    ${html_source}    Fill in the research fund details
    Should Contain    ${html_source}    Fund type
    Should Contain    ${html_source}    Fund name
    Should Contain    ${html_source}    Fund Agency

    Click Element       xpath=//*[@id="fund_type"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    ----Defind fund type----
    Should Contain    ${options}    Internal Capital
    Should Contain    ${options}    External Capital
    Sleep    1s

    Click Element       xpath=//*[@id="fund_level"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    ----Defind fund level----
    Should Contain    ${options}    Unknown
    Should Contain    ${options}    High
    Should Contain    ${options}    Mid
    Should Contain    ${options}    Low
    Sleep    1s

    ${submit_button_text}=    Get Text    xpath=//button[@type='submit' and contains(@class, 'btn-primary')]
    Should Contain    ${submit_button_text}    Submit
    Log    Submit Button Text: ${submit_button_text}
    ${cancel_button_text}=    Get Text    xpath=//a[contains(@class, 'btn-light')]
    Should Contain    ${cancel_button_text}    Cancel
    Log    Cancel Button Text: ${cancel_button_text}

    # Edit Fund TH
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    xpath=//a[contains(@class, 'btn-outline-success') and @title='Edit']
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit Fund
    Should Contain    ${html_source}    Edit fund research details
    Should Contain    ${html_source}    Fund type
    Should Contain    ${html_source}    Fund level
    Should Contain    ${html_source}    Fund Name
    Should Contain    ${html_source}    Fund Agency
    Sleep    1s  # รอให้หน้าโหลด

    Click Element       xpath=//*[@id="fund_type"]
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Internal Capital
    Should Contain    ${options}    External Capital

    Click Element       xpath=//*[@id="fund_level"]
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Unknown
    Should Contain    ${options}    High
    Should Contain    ${options}    Mid
    Should Contain    ${options}    Low

    # Delete Fund EN
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    title
    Should Contain    ${delete_button_title}    Delete
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    Are you sure?
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    If you delete this, it will be gone forever.
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    Cancel
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    OK

    # Simulate clicking "Cancel" (modal should close)
    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Wait Until Element Is Not Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=3s    # Wait for modal to disappear
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]    # Confirm modal is gone

    # Simulate clicking "OK" (delete action)
    Go To    ${SERVER}/funds
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-text') and contains(text(), 'Delete Successfully')]    timeout=2s    # Verify success message
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm')]    timeout=2s
    Close Browser

TC20:Research Projects Page EN
    # Open Research Projects Page EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchProjects
    Sleep    5s
    Switch Language To    th    ไทย
    Switch Language To    en    English
    ${html_source}=    Get Source
    Should Contain    ${html_source}    esearch Project
    Should Contain    ${html_source}    Year
    Should Contain    ${html_source}    Project Name
    Should Contain    ${html_source}    Research Group Head
    Should Contain    ${html_source}    Member
    Should Contain    ${html_source}    Action
    Should Match Regexp   ${html_source}    .*นวัตกรรมดัชนีสุขภาพของประชากรไทยโดยวิทยาการข้อมูลเพื่อประโยชน์*.
    Should Match Regexp   ${html_source}    .*Sumonta*.
    Should Match Regexp   ${html_source}    .* *.
    Should Contain    ${html_source}    Search

    # View Research Project EN
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=2s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Project Details
    Should Contain    ${html_source}    Project Name
    Should Contain    ${html_source}    Start Date
    Should Contain    ${html_source}    End Date
    Should Contain    ${html_source}    Research Funding Source
    Should Contain    ${html_source}    Amount
    Should Contain    ${html_source}    Project Details
    Should Contain    ${html_source}    Project Status
    Should Contain    ${html_source}    Project Manager
    Should Contain    ${html_source}    Member
    Should Contain    ${html_source}    Project Closed

    # Add Research Project EN
    Go To    ${SERVER}/researchProjects
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}

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
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-selUser0-container"]
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    Select User
    Go To    ${SERVER}/researchProjects
    Sleep    2s
    
    # Edit Research Project EN
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-outline-success') and @title='Edit']    timeout=2s
    Click Element    xpath=//a[contains(@class, 'btn-outline-success') and @title='Edit']
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
    Should Contain    ${html_source}    External Project Co-ordinator
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="responsible_department"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Department of Computer Science

    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="status"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Apply for
    Should Contain    ${options}    Proceed
    Should Contain    ${options}    Project Closed

    Click Element       xpath=//*[@id="fund"]
    Sleep    1s
    Click Element       xpath=//*[@id="dep"]
    Sleep    1s

    Scroll Element Into View    //select[@class="custom-select my-select" and @id="status"]
    Click Element    //select[@class="custom-select my-select" and @id="status"]
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=2s
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    Pusadee Seresangtakul
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Pusadee Seresangtakul

    # Delete Research Project EN
    ${inco_count}=    Get Element Count    xpath=//table[@id="dynamicAddRemove"]/tbody/tr
    Run Keyword If    ${inco_count} > 1    Check InCo User  
    Go To    ${SERVER}/researchProjects
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    title
    Should Contain    ${delete_button_title}    Delete
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s  # รอ SweetAlert ปรากฏ
    Wait Until Element Is Visible    xpath=//table[@id='example1']    timeout=2s 
    ${row_count}=    Get Element Count    xpath=//table[@id='example1']/tbody/tr
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    Are you sure?
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    If you delete this, it will be gone forever.
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    Cancel
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    OK

    # จำลองกด "ยกเลิก" (ไม่ลบจริง)
    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]

    # จำลองกด "ตกลง" (ลบจริง)
    Go To    ${SERVER}/researchProjects
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]
    Sleep    2s

    # ตรวจสอบ SweetAlert ที่แสดงข้อความ "ลบสำเร็จแล้ว"
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-text') and contains(text(), 'Delete Successfully')]    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm')]    2s 
    Close Browser

TC21:Research Groups Page Switch Language To EN
    # Open Research Groups Page EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchGroups
    Sleep    2s
    Switch Language To    th    ไทย
    Switch Language To    en    English
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Groups
    Should Contain    ${html_source}    No.
    Should Contain    ${html_source}    Group name (Thai)
    Should Contain    ${html_source}    Research group head
    Should Contain    ${html_source}    Member
    Should Contain    ${html_source}    Action
    Should Match Regexp   ${html_source}    .*เทคโนโลยี GIS ขั้นสูง (AGT)*.
    Should Match Regexp   ${html_source}    Pipat
    Should Match Regexp   ${html_source}    .*Chaiyapon*.
    Should Contain    ${html_source}    Search
    
    # View Research Groups EN
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=2s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
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
    Click Element    xpath=//a[@class='btn btn-primary mt-5']
    Sleep    2s

    # Add Research Groups EN
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Create Research Group
    Should Contain    ${html_source}    Group name (Thai)
    Should Contain    ${html_source}    Group name (English)
    Should Contain    ${html_source}    Group description (Thai)
    Should Contain    ${html_source}    Group description (English)
    Should Contain    ${html_source}    Group details (Thai)
    Should Contain    ${html_source}    Group details (English)
    Should Contain    ${html_source}    Image
    Should Contain    ${html_source}    Research group head
    Should Contain    ${html_source}    Research group members

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Click Element    //span[@id="select2-head0-container"]
    Sleep    1s

    Scroll Element Into View    xpath=//button[@id='add-btn2']
    Wait Until Element Is Visible    xpath=//button[@id='add-btn2']    timeout=2s
    Click Button    xpath=//button[@id='add-btn2']
    Sleep    1s
    Scroll Element Into View    //span[@id="select2-selUser1-container"]
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    Select User

    Scroll Element Into View    xpath=//a[@class='btn btn-light mt-5']
    Click Element    xpath=//a[@class='btn btn-light mt-5']
    Sleep    1s

    # Edit Research Groups EN
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success')]/i[contains(@class, 'mdi-pencil')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit Research Group
    Should Contain    ${html_source}    Fill in the details to edit the research group
    Should Contain    ${html_source}    Group name (Thai)
    Should Contain    ${html_source}    Group name (English)
    Should Contain    ${html_source}    Group description (Thai)
    Should Contain    ${html_source}    Group description (English)
    Should Contain    ${html_source}    Group details (Thai)
    Should Contain    ${html_source}    Group details (English)
    Should Contain    ${html_source}    Image
    Should Contain    ${html_source}    Research Group Head
    Should Contain    ${html_source}    Research Group Members

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=2s
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    Pipat Reungsang
    Click Element    //span[@id="select2-head0-container"]
    
    Scroll Element Into View    //span[@id="select2-selUser1-container"]
    Wait Until Element Is Visible    //span[@id="select2-selUser1-container"]    timeout=3s
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    Chaiyapon Keeratikasikorn
    Click Element    //span[@id="select2-selUser1-container"]  # Re-click to collapse
    Sleep    1s  # Give it time to close

    Scroll Element Into View    //span[@id="select2-selUser2-container"]
    Wait Until Element Is Visible    //span[@id="select2-selUser2-container"]    timeout=3s
    Click Element    //span[@id="select2-selUser2-container"]
    Element Should Contain    //span[@id="select2-selUser2-container"]    Nagon Watanakij
    Sleep    2s
    Close Browser    

TC22:Manage Publications EN
    # Open Published Research Page EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
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
    Should Contain    ${html_source}    Journal

    # Add Published Research EN
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
    Should Contain    ${html_source}    Support Fund
    Should Contain    ${html_source}    Author name (in department)
    Should Contain    ${html_source}    Author name (in addition to department)
    Should Contain    ${html_source}    Please select source title
    ${keyword_note}=    Get Text    //p[@class="text-danger"]
    Should Be Equal    ${keyword_note}    ***Each word must be separated by a semicolon (;) followed by one space.
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="selectpicker"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Scopus
    Should Contain    ${options}    Web Of Science
    Should Contain    ${options}    TCI
    
    Scroll Element Into View    //select[@class="custom-select my-select" and @name="paper_type"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Journal
    Should Contain    ${options}    Conference Proceeding
    Should Contain    ${options}    Book Series 
    Should Contain    ${options}    Book

    Scroll Element Into View    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Please select subtype
    Should Contain    ${options}    Article
    Should Contain    ${options}    Conference Paper
    Should Contain    ${options}    Editorial
    Should Contain    ${options}    Review
    Should Contain    ${options}    Erratum
    Should Contain    ${options}    Book Chapter

    Scroll Element Into View    //select[@class="custom-select my-select" and @name="publication"]
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Please select publication  
    Should Contain    ${options}    International Journal
    Should Contain    ${options}    International Book
    Should Contain    ${options}    International Conference
    Should Contain    ${options}    NationalC onference
    Should Contain    ${options}    National Journal
    Should Contain    ${options}    National Book
    Should Contain    ${options}    National Magazine
    Should Contain    ${options}    Book Chapter


    Scroll Element Into View    //select[@id="selUser0"]
    Wait Until Element Is Visible    //select[@id="selUser0"]    timeout=3s
    Click Element    //select[@id="selUser0"]
    Element Should Contain    //select[@id="selUser0"]    Select User
    Sleep    1s
    Scroll Element Into View    //select[@id="pos"]
    Wait Until Element Is Visible    //select[@id="pos"]    timeout=3s
    Click Element    //select[@id="pos"]
    Element Should Contain    //select[@id="pos"]    First Author
    Sleep    1s

    Scroll Element Into View    //input[@name="fname[]"]
    Wait Until Element Is Visible    //input[@name="fname[]"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="fname[]"]    placeholder
    Should Be Equal    ${placeholder}    FirstName
    Scroll Element Into View    //input[@name="lname[]"]
    Wait Until Element Is Visible    //input[@name="lname[]"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="lname[]"]    placeholder
    Should Be Equal    ${placeholder}    LastName
    Scroll Element Into View    //select[@id="pos2"]
    Wait Until Element Is Visible    //select[@id="pos2"]    timeout=3s
    Click Element    //select[@id="pos2"]
    Element Should Contain    //select[@id="pos2"]    First Author
    Sleep    1s

    Scroll Element Into View    xpath=//a[@class='btn btn-light']
    Click Element    xpath=//a[@class='btn btn-light']
    Sleep    1s

    # View Published Research EN
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=5s
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
    Should Contain    ${html_source}    Journal
    Should Contain    ${html_source}    Article
    Should Contain    ${html_source}    First Author:
    Should Contain    ${html_source}    Loan Thi-Thuy Ho
    Should Contain    ${html_source}    Co Author:
    Should Contain    ${html_source}    Somjit Arch-int
    Should Contain    ${html_source}    Corresponding Author:
    Should Contain    ${html_source}    Ngamnij Arch-int
    Scroll Element Into View    xpath=//a[@class='btn btn-primary mt-5']
    Click Element    xpath=//a[@class='btn btn-primary mt-5']
    Sleep    1s

    # Open Books Page EN
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/books') and contains(text(), 'Book')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/books') and contains(text(), 'Book')]
    Sleep    5s

    ${html_source}=    Get Source
    Log    ${html_source}
    Should Contain    ${html_source}    Book
    Should Contain    ${html_source}    Show 
    Get Text    xpath=//th[contains(text(), 'No. ')]
    Should Contain    ${html_source}    name 
    Should Contain    ${html_source}    Year 
    Get Text    xpath=//th[contains(text(), 'Publication source ')]
    Should Contain    ${html_source}    page
    Should Contain    ${html_source}    Action 
    Should Contain    ${html_source}    No matching records found

    # Add Books EN
    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add a book
    Should Contain    ${html_source}    Fill in book details
    Should Contain    ${html_source}    Book name
    Should Contain    ${html_source}    Place of publication
    Should Contain    ${html_source}    Year (AD)
    Should Contain    ${html_source}    Number of pages
    Scroll Element Into View    xpath=//a[@class='btn btn-light']
    Click Element    xpath=//a[@class='btn btn-light']
    Sleep    1s

    # Open Other Academic Works Page EN
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/patents') and contains(text(), 'Patents')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/patents') and contains(text(), 'Patents')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Other Academic Works (Patents, Utility Models, Copyrights)
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
    Should Contain    ${full_text}    การศึกษาสภาพแวดล้อมเมืองด้วยข้อมูลภาพถ่ายดาวเทียม
    ${text}=    Get Text    xpath=//td[contains(text(), 'Book')]
    Should Contain    ${text}    Book
    ${name}=    Get Text    xpath=//td[contains(text(), 'Chaiyapon Keeratikasikorn')]
    Should Contain    ${name}    Chaiyapon Keeratikasikorn
    Sleep    1s

    # View Other Academic Work EN 
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=3s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep   3s

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Other Academic Works (Patents, Utility Models, Copyrights)
    Should Contain    ${html_source}    Enter details of patents, utility models, or copyrights
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Type
    Should Contain    ${html_source}    Book
    Should Contain    ${html_source}    Registration Date
    Should Contain    ${html_source}    Registration Number
    Should Contain    ${html_source}    Chaiyapon Keeratikasikorn
    Should Contain    ${html_source}    Creator
    Should Contain    ${html_source}    Co-Creator
    Should Contain    ${html_source}    Reg. No.
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary btn-sm') and contains(., 'Back')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary btn-sm')]
    Should Contain    ${button_text}    Back
    Click Element    xpath=//a[contains(@class, 'btn btn-primary btn-sm')]

    # Add Other Academic Work EN
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add
    Should Contain    ${html_source}    Enter details of patents, utility models, or copyrights
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Type
    Should Contain    ${html_source}    Registration Date
    Should Contain    ${html_source}    Registration Number
    Should Contain    ${html_source}    Internal Authors
    Should Contain    ${html_source}    External Authors
    Should Contain    ${html_source}    Enter First Name
    Should Contain    ${html_source}    Enter Last Name

    Scroll Element Into View    //select[@name="ac_type"]
    Click Element    //select[@name="ac_type"]
    Element Should Contain    //select[@name="ac_type"]    Please select a type
    Sleep    2s

    Scroll Element Into View    xpath=//button[@id='add-btn2']
    Wait Until Element Is Visible    xpath=//button[@id='add-btn2']    timeout=5s
    Click Button    xpath=//button[@id='add-btn2']
    Sleep    5s
    Scroll Element Into View    //select[@id="selUser1"]
    Click Element    //select[@id="selUser1"]
    Element Should Contain    //select[@id="selUser1"]    Select Member
    Sleep    2s
    
    Scroll Element Into View    xpath=//button[contains(@class, 'btn btn-primary me-2') and contains(., 'Submit')]
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary me-2') and contains(., 'Submit')]    timeout=5s
    ${button}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary me-2')]
    Should Contain    ${button}    Submit
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-light') and contains(., 'Cancel')]    timeout=5s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-light')]
    Should Contain    ${button_text}    Cancel
    Scroll Element Into View    xpath=//a[contains(@class, 'btn btn-light') and contains(., 'Cancel')]
    Click Element    xpath=//a[contains(@class, 'btn btn-light')]
    Close Browser

TC23:Department Page EN
    # Open Department Page EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    th    ไทย
    Switch Language To    en    English
    Click Element    xpath=//span[contains(text(), 'Departments')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Departments
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Department of Computer Science
    Should Contain    ${html_source}    Action
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'New Department')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    New Department
    Sleep    2s

    # View Department EN
    Click Element    xpath=//i[contains(@class, 'mdi mdi-eye')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Department
    Should Contain    ${html_source}    Department Name (Thai):
    Should Contain    ${html_source}    Department Name (English):
    Should Contain    ${html_source}    สาขาวิชาวิทยาการคอมพิวเตอร์
    Should Contain    ${html_source}    Department of Computer Science
    Sleep    1s
    Go To    ${SERVER}/departments


    # Add Department TH
    Click Element    xpath=//a[contains(@class, 'btn btn-primary')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Create Department
    Should Contain    ${html_source}    Department Name (Thai):
    Should Contain    ${html_source}    Department Name (English):
    Wait Until Element Is Visible    //input[@name="department_name_th"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="department_name_th"]    placeholder
    Should Be Equal    ${placeholder}    Department Name in Thai
    Wait Until Element Is Visible    //input[@name="department_name_en"]    timeout=3s
    ${placeholder}=    Get Element Attribute    //input[@name="department_name_en"]    placeholder
    Should Be Equal    ${placeholder}    Department Name in English
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary') and contains(., 'Submit')]    2s
    ${button_text}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    Submit
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'Departments')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    Departments
    Sleep    1s
    Click Element    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'Departments')]

    # Edit Department EN
    Wait Until Element Is Visible    //a[contains(@class, 'btn btn-outline-primary btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn btn-outline-primary btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit Department
    Should Contain    ${html_source}    Department Name (Thai):
    Should Contain    ${html_source}    Department Name (English):
    Wait Until Element Is Visible    //input[@name="department_name_th"]    timeout=3s
    ${value}=    Get Element Attribute    //input[@name="department_name_th"]    value
    Should Be Equal    ${value}    สาขาวิชาวิทยาการคอมพิวเตอร์
    Wait Until Element Is Visible    //input[@name="department_name_en"]    timeout=3s
    ${value}=    Get Element Attribute    //input[@name="department_name_en"]    value
    Should Be Equal    ${value}    Department of Computer Science
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary') and contains(., 'Submit')]    2s
    ${button_text}=    Get Text    xpath=//button[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    Submit
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'Departments')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-primary')]
    Should Contain    ${button_text}    Departments
    Click Element    xpath=//a[contains(@class, 'btn btn-primary') and contains(., 'Departments')]
    Sleep    1s

    # Delete Department EN
    Go To    ${SERVER}/departments
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]    title
    Should Contain    ${delete_button_title}    Delete
    Click Element    xpath=//button[contains(@class, 'btn-outline-danger') and contains(@class, 'show_confirm')]
    Sleep    2s
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    Are you sure?
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    If you delete this, it will be gone forever.
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    cancel
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    ok

    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]
    Wait Until Element Is Not Visible    xpath=//div[contains(@class, 'swal-overlay')]    timeout=2s
    Wait Until Element Is Visible    xpath=//table[contains(@class, 'table table-hover')]    timeout=2s
    Close Browser

TC24:Manage Programs Page EN
    # Open Manage Programs EN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    th    ไทย
    Switch Language To    en    English
    Click Element    xpath=//span[contains(text(), 'Manage Programs')]
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Programs
    Should Contain    ${html_source}    ID
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Degree
    Should Contain    ${html_source}    Action
    Should Contain    ${html_source}    Search
    Should Contain    ${html_source}    Computer Science
    Should Contain    ${html_source}    Bachelor of Science
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(., 'Add')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary')]
    Should Contain    ${button_text}    Add
    Sleep    2s

    # Add Program EN
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-primary btn-menu btn-icon-text btn-sm mb-3')]/i[contains(@class, 'mdi mdi-plus btn-icon-prepend')]    timeout=2s
    Click Element    xpath=//a[contains(@class, 'btn btn-primary btn-menu btn-icon-text btn-sm mb-3')]/i[contains(@class, 'mdi mdi-plus btn-icon-prepend')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'modal')]    timeout=2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add New Program
    Should Contain    ${html_source}    Degree Level
    Should Contain    ${html_source}    Department
    Should Contain    ${html_source}    Name (Thai)
    Should Contain    ${html_source}    Name (English)
    Scroll Element Into View    //select[@id="degree"]
    Wait Until Element Is Visible    //select[@id="degree"]    timeout=2s
    Click Element    //select[@id="degree"]
    Element Should Contain    //select[@id="degree"]    Bachelor of Science
    Sleep    1s
    Scroll Element Into View    //select[@id="department"]
    Wait Until Element Is Visible    //select[@id="department"]    timeout=2s
    Click Element    //select[@id="department"]
    Element Should Contain    //select[@id="department"]    Department of Computer Science
    Sleep    1s
    Scroll Element Into View    //input[@name="program_name_th"]
    Wait Until Element Is Visible    //input[@name="program_name_th"]    timeout=2s
    ${placeholder}=    Get Element Attribute    //input[@name="program_name_th"]    placeholder
    Should Be Equal    ${placeholder}    Program Name (Thai)
    Scroll Element Into View    //input[@name="program_name_en"]
    Wait Until Element Is Visible    //input[@name="program_name_en"]    timeout=2s
    ${placeholder}=    Get Element Attribute    //input[@name="program_name_en"]    placeholder
    Should Be Equal    ${placeholder}    Program Name (English)
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-danger') and contains(., 'Cancel')]    timeout=2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-danger')]
    Should Contain    ${button_text}    Cancel
    Click Element    xpath=//a[contains(@class, 'btn btn-danger')]


    # Edit Program EN
    Wait Until Element Is Visible    //a[contains(@class, 'btn btn-outline-success btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]    timeout=2s
    Click Element    //a[contains(@class, 'btn btn-outline-success btn-sm')]/i[contains(@class, 'mdi mdi-pencil')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'modal')]    timeout=2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit
    Should Contain    ${html_source}    Degree Level
    Should Contain    ${html_source}    Department
    Should Contain    ${html_source}    Name (Thai)
    Should Contain    ${html_source}    Name (English)
    Scroll Element Into View    //select[@id="degree"]
    Wait Until Element Is Visible    //select[@id="degree"]    timeout=2s
    Click Element    //select[@id="degree"]
    Element Should Contain    //select[@id="degree"]    Bachelor of Science
    Sleep    1s
    Scroll Element Into View    //select[@id="department"]
    Wait Until Element Is Visible    //select[@id="department"]    timeout=2s
    Click Element    //select[@id="department"]
    Element Should Contain    //select[@id="department"]    Department of Computer Science
    Sleep    1s
    Scroll Element Into View    //input[@name="program_name_th"]
    Wait Until Element Is Visible    //input[@name="program_name_th"]    timeout=2s
    ${value_th}=    Get Element Attribute    //input[@name="program_name_th"]    value
    ${value_th}=    Strip String    ${value_th} 
    ${expected_th}=    Set Variable    สาขาวิชาวิทยาการคอมพิวเตอร์
    ${expected_th}=    Strip String    ${expected_th}
    Should Be Equal    ${value_th}    ${expected_th}
    Scroll Element Into View    //input[@name="program_name_en"]
    Wait Until Element Is Visible    //input[@name="program_name_en"]    timeout=2s
    ${value_en}=    Get Element Attribute    //input[@name="program_name_en"]    value
    ${value_en}=    Strip String    ${value_en}
    Should Be Equal    ${value_en}    Computer Science
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-danger') and contains(., 'Cancel')]    timeout=2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-danger')]
    Should Contain    ${button_text}    Cancel
    Click Element    xpath=//a[contains(@class, 'btn btn-danger')]
    
    # Delete Program EN
    Go To    ${SERVER}/programs
    Wait Until Element Is Visible    //button[contains(@class, 'btn btn-outline-danger btn-sm')]    timeout=2s
    ${delete_button_title}=    Get Element Attribute    //button[contains(@class, 'btn btn-outline-danger btn-sm')]    title
    Should Contain    ${delete_button_title}    Delete
    Click Element    //button[contains(@class, 'btn btn-outline-danger btn-sm')]
    Sleep    2s  # รอ SweetAlert ปรากฏ
    Wait Until Element Is Visible    xpath=//table[@id='example1']    timeout=2s 
    ${row_count}=    Get Element Count    xpath=//table[@id='example1']/tbody/tr
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-title')]    timeout=2s
    ${swal_title}=    Get Text    xpath=//div[contains(@class, 'swal-title')]
    Should Contain    ${swal_title}    Are you sure?
    ${swal_text}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${swal_text}    If you delete this, it will be gone forever.
    ${cancel_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--cancel')]
    Should Contain    ${cancel_button_text}    cancel
    ${confirm_button_text}=    Get Text    xpath=//button[contains(@class, 'swal-button--confirm')]
    Should Contain    ${confirm_button_text}    ok

    # จำลองกด "ยกเลิก" (ไม่ลบจริง)
    Click Element    xpath=//button[contains(@class, 'swal-button--cancel')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//div[contains(@class, 'swal-title')]

    # จำลองกด "ตกลง" (ลบจริง)
    Wait Until Element Is Visible    //button[contains(@class, 'btn btn-outline-danger btn-sm')]    timeout=2s
    Click Element    //button[contains(@class, 'btn btn-outline-danger btn-sm')]
    Sleep    2s
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]    timeout=2s
    Click Element    xpath=//button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger')]
    Sleep    2s

    # ตรวจสอบ SweetAlert ที่แสดงข้อความ "ลบสำเร็จ"
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal-icon--success')]    timeout=2s
    ${success_message}=    Get Text    xpath=//div[contains(@class, 'swal-text')]
    Should Contain    ${success_message}    Delete Successfully
    Close Browser