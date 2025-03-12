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
${ENG_EDIT_BUTTON_XPATH}    //a[contains(@class, 'btn-outline-success') and @title='Edit']
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
Dashboard Page Switch Language To ENG
    [Tags]    OpenUserPage
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    en    English
    ${html_source}=    Get Source
    FOR    ${word}    IN    @{EXPECTED_WORDS_USER_EN}
        Should Contain    ${html_source}    ${word}
    END

Profile Page by eng
    [tags]      ProfileByEng
    Click Element               xpath=//a[@href='${SERVER}/profile']
    Sleep    1s
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

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='Password']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Old password
    Should Contain    ${html_source}    New password
    Should Contain    ${html_source}    Confirm new password
    Should Contain    ${html_source}    Password Settings
    ${placeholder_value}=    Get Element Attribute    id=inputpassword    placeholder
    Should Be Equal    ${placeholder_value}    Enter current password

Funds Page By Eng
    #Go To    ${SERVER}/funds
    [tags]    FundPageByEng
    Click Element               xpath=//a[@href='${SERVER}/funds']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Fund
    Should Contain    ${html_source}    Fund Name
    Should Contain    ${html_source}    Fund Type
    Should Contain    ${html_source}    Fund Level
    Should Match Regexp   ${html_source}    .*Statistical Thai*.
    Should Contain    ${html_source}    Internal Capital
    Should Contain    ${html_source}    Unknown

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=1s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Fund Detail
    Should Contain    ${html_source}    Fund Name
    Should Contain    ${html_source}    Fund Details
    Should Contain    ${html_source}    Fund Agency
    Should Contain    ${html_source}    Fill fund by
    Should Contain    ${html_source}    Back
    Click Element    xpath=//a[@href='${SERVER}/funds' and contains(text(),'Back')]

    #Edit
    Wait Until Element Is Visible    ${ENG_EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${ENG_EDIT_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Edit Fund
    Should Contain    ${html_source}    Fund type
    Should Contain    ${html_source}    Fund level
    Should Contain    ${html_source}    Fund Name
    Should Contain    ${html_source}    Fund Agency
    Sleep    2s  # รอให้หน้าโหลด

    Click Element    id=fund_type
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    Internal Capital
    Should Contain    ${options}    External Capital

    Click Element    id=fund_level
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    Unknown
    Should Contain    ${options}    High
    Should Contain    ${options}    Mid
    Should Contain    ${options}    Low
    Sleep    1s
    Click Element    xpath=//a[@href='${SERVER}/funds' and contains(text(),'Cancel')]

    #ADD
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Fund type
    Should Contain    ${html_source}    Fund level
    Should Contain    ${html_source}    Fund name
    Should Contain    ${html_source}    Fund Agency
    Click Element     id=fund_type
    Sleep    0.5s
    Click Element     id=fund_level
    Sleep    0.5s
    Click Element    xpath=//a[@href='${SERVER}/funds' and contains(text(),'Cancel')]

    #Delete
    Wait Until Element Is Visible    ${DELETE_BUTTON_XPATH}    timeout=2s
    Click Element    ${DELETE_BUTTON_XPATH}
    Page Should Contain    Are you sure?
    Page Should Contain    If you delete this, it will be gone forever.
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='Cancel']
    Sleep    0.5s

Research Projects Page By Eng
    [tags]    ResearchProjectsPageByEng
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    en    English
    Click Element               xpath=//a[@href='${SERVER}/researchProjects']
    Sleep    1s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Project
    Should Contain    ${html_source}    Year
    Should Contain    ${html_source}    Project Name
    Should Contain    ${html_source}    Research Group Head
    Should Contain    ${html_source}    Member
    Should Contain    ${html_source}    Action
    Should Contain    ${html_source}    Search
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s

    #View
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

    # Edit
    Wait Until Element Is Visible    ${ENG_EDIT_BUTTON_XPATH}    timeout=2s
    Click Element    ${ENG_EDIT_BUTTON_XPATH}
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
    
    Click Element       xpath=//*[@id="fund"]
    Sleep    1s
    Click Element       xpath=//*[@id="dep"]
    Sleep    1s

    Scroll Element Into View    //select[@class="custom-select my-select" and @id="status"]
    Click Element    //select[@class="custom-select my-select" and @id="status"]
    Sleep    1s

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    Pusadee Seresangtakul
    Should Contain    ${html_source}    Ngamnij
    Sleep    1s
    Scroll Element Into View    xpath=//a[@href='${SERVER}/researchProjects' and contains(text(),'Back')]
    Click Element    xpath=//a[@href='${SERVER}/researchProjects' and contains(text(),'Back')]

    #Add
    Go To    ${SERVER}/researchProjects
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Project Name
    Should Contain    ${html_source}    Start Date
    Should Contain    ${html_source}    End Date
    Should Contain    ${html_source}    Select funding source
    Should Contain    ${html_source}    Year of submission (A.D.)
    Should Contain    ${html_source}    Budget
    Should Contain    ${html_source}    Responsible Agency
    Should Contain    ${html_source}    Project details
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