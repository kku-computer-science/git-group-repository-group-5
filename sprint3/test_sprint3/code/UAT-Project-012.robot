* Settings *
Library           SeleniumLibrary

* Variables *
${SERVER}                    https://csgroup568.cpkkuhost.com
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
    Close Browser

Profile Page by eng
    [tags]      ProfileByEng
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
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
    Close Browser

Funds Page By Eng
    #Go To    ${SERVER}/funds
    [tags]    FundPageByEng
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
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
    Close Browser

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

    Scroll Element Into View    //span[@id="select2-head0-container"]
    Click Element    //span[@id="select2-head0-container"]
    Element Should Contain    //span[@id="select2-head0-container"]    Select User
    Should Contain    ${html_source}    Ngamnij

    Scroll Element Into View    //span[@id="select2-selUser0-container"]
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    Select User
    Should Contain    ${html_source}    Ngamnij
    Sleep    1s

    Scroll Element Into View    xpath=//a[@href='${SERVER}/researchProjects' and contains(text(),'Cancel')]
    Click Element    xpath=//a[@href='${SERVER}/researchProjects' and contains(text(),'Cancel')]

    #Delete
    Wait Until Element Is Visible    ${DELETE_BUTTON_XPATH}    timeout=2s
    Click Element    ${DELETE_BUTTON_XPATH}
    Page Should Contain    Are you sure?
    Page Should Contain    If you delete this, it will be gone forever.
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='Cancel']
    Sleep    0.5s
    Close Browser

Research Groups Page By Eng
    [tags]  researchGroups
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchGroups
    Switch Language To    en    English
    Sleep    2s
    
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Research Group
    Should Contain    ${html_source}    Group name (Thai)
    Should Contain    ${html_source}    No.
    Should Contain    ${html_source}    Research Groups
    Should Contain    ${html_source}    Research group head
    Should Contain    ${html_source}    Member
    Should Contain    ${html_source}    Action
    Should Contain    ${html_source}    Search

     # View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
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
    Element Should Contain    //span[@id="select2-head0-container"]    Pipat Reungsang
    Click Element    //span[@id="select2-head0-container"]
    Sleep    1s

    Wait Until Element Is Visible    //span[@id="select2-selUser1-container"]    timeout=5s
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    Chaiyapon Keeratikasikorn
    Sleep    1s
    Scroll Element Into View    xpath=//a[@href='${SERVER}/researchGroups' and contains(text(),'Back')]
    Click Element    xpath=//a[@href='${SERVER}/researchGroups' and contains(text(),'Back')]   

    #Add
    Go To    ${SERVER}/researchGroups
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
    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=5s

    Sleep    1s

    
    Scroll Element Into View    xpath=//a[@href='${SERVER}/researchGroups' and contains(text(),'Back')]
    Click Element    xpath=//a[@href='${SERVER}/researchGroups' and contains(text(),'Back')] 


    #Delete
    Wait Until Element Is Visible    ${DELETE_BUTTON_XPATH}    timeout=2s
    Click Element    ${DELETE_BUTTON_XPATH}
    Page Should Contain    Are you sure?
    Page Should Contain    If you delete this, it will be gone forever.
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='Cancel']
    Sleep    0.5s
    Close Browser

Manage Publications
    [tags]  ManagePublications
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Switch Language To    en    English
    Sleep    2s

    #Papers
    Click Element    xpath=//span[contains(text(), 'Manage Publications')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/papers') and contains(text(), 'Published Research')]    timeout=5s
    
    #Published Research
    Click Element    xpath=//a[contains(@href, '/papers') and contains(text(), 'Published Research')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Published Research
    Should Contain    ${html_source}    Paper Name
    Should Contain    ${html_source}    No
    Should Contain    ${html_source}    Paper Type
    Should Contain    ${html_source}    Publish Year
    Should Contain    ${html_source}    Action
    Should Contain    ${html_source}    Search

    #Add
    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add publication research
    Should Contain    ${html_source}    Fill research detail
    Should Contain    ${html_source}    Research publication source
    Should Contain    ${html_source}    Research Name
    Should Contain    ${html_source}    Abstract
    Should Contain    ${html_source}    Keyword

    Scroll Element Into View    id=paper_type
    Click Element    id=paper_type
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Journal
    Sleep    0.5s

    Scroll Element Into View    id=paper_subtype
    Click Element    id=paper_subtype
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    Please select subtype
    Should Contain    ${options}    Article
    Should Contain    ${options}    Conference Paper
    Should Contain    ${options}    Editorial
    Should Contain    ${options}    Review
    Should Contain    ${options}    Erratum
    Should Contain    ${options}    Book Chapter

    Sleep    0.5s
    Scroll Element Into View    id=publication
    Click Element    id=publication
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    International Book

    Scroll Element Into View    xpath=//*[contains(text(),'Document Type')]
    Should Contain              ${html_source}    Document Type

    Scroll Element Into View    xpath=//*[contains(text(),'Subtype')]
    Should Contain              ${html_source}    Subtype

    Scroll Element Into View    xpath=//*[contains(text(),'Publication')]
    Should Contain              ${html_source}    Publication

    Scroll Element Into View    xpath=//*[contains(text(),'Citation')]
    Should Contain              ${html_source}    Citation

    Scroll Element Into View    xpath=//*[contains(text(),'Page')]
    Should Contain              ${html_source}    Page

    Scroll Element Into View    xpath=//*[contains(text(),'Support Fund')]
    Should Contain              ${html_source}    Support Fund

    Scroll Element Into View    xpath=//*[contains(text(),'Author name (in department)')]
    Should Contain              ${html_source}    Author name (in department)
    Scroll Element Into View    id=selUser0
    Click Element               id=selUser0
    Click Element               id=pos

    Scroll Element Into View    id=submit

    Scroll Element Into View    xpath=//*[contains(text(),'Author name (in addition to department)')]
    Should Contain              ${html_source}    Author name (in addition to department)
    Scroll Element Into View    id=pos2
    Click Element               id=pos2

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
    Scroll Element Into View    xpath=//a[contains(text(),'Back')]
    Click Element    xpath=//a[contains(text(),'Back')]

#books
    Click Element    xpath=//span[contains(text(), 'Manage Publications')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/books') and contains(text(), 'Book')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/books') and contains(text(), 'Book')]
    Sleep    2s

    ${html_source}=    Get Source
    Log    ${html_source}
    Should Contain    ${html_source}    Book
    Should Contain    ${html_source}    Show
    Page Should Contain    name
    Page Should Contain    Year
    Page Should Contain    Publication source

    #Add
    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add a book
    Should Contain    ${html_source}    Fill in book details
    Should Contain    ${html_source}    Place of publication
    Should Contain    ${html_source}    Year (AD)
    Should Contain    ${html_source}    Number of pages
    Sleep    1s
    Click Element               xpath=//a[@href='${SERVER}/books' and contains(text(),'Cancel')]

#Patents
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/patents') and contains(text(), 'Patents')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/patents') and contains(text(), 'Patents')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    Patents
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

    #Add
    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Add
    Should Contain    ${html_source}    Enter details of patents, utility models, or copyrights
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Type
    Scroll Element Into View    xpath=//select[@name='ac_type']
    Click Element               xpath=//select[@name='ac_type']

    Should Contain    ${html_source}    Registration Date
    Should Contain    ${html_source}    Registration Number
    Should Contain    ${html_source}    Internal Authors
    Scroll Element Into View    id=add-btn2
    Click Element               id=add-btn2
    Sleep    1s
    Wait Until Element Is Visible    xpath=//select[@id='selUser1']    10s
    Click Element    id=selUser1

    Scroll Element Into View    xpath=//label[contains(text(),'External Authors')]
    
    Scroll Element Into View    xpath=//a[@href='${SERVER}/patents' and contains(text(),'Cancel')]

    Page Should Contain Element    xpath=//a[@href='${SERVER}/patents' and contains(text(),'Cancel')]
    Click Element    xpath=//a[@href='${SERVER}/patents' and contains(text(),'Cancel')]
    Sleep    1s

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Type
    Should Contain    ${html_source}    Registration Date
    Should Contain    ${html_source}    Registration Number
    Should Contain    ${html_source}    Creator
    Should Contain    ${html_source}    Co-Creator
    Sleep    3s
    Click Element               xpath=//a[@href='${SERVER}/patents' and contains(@class,'btn-primary')]
    Close Browser

Menu User By Eng
    [tags]  userByENG
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/users
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Users
    Should Contain    ${html_source}    Department
    Should Contain    ${html_source}    Email
    Should Contain    ${html_source}    Roles
    Should Contain    ${html_source}    Action

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Page Should Contain    Name (Thai)
    Page Should Contain    Name (English)
    Page Should Contain    Email
    Page Should Contain    Role
    Page Should Contain    Password
    Sleep    2s
    Go To    ${SERVER}/users
    Sleep    1s

    #Edit
    Go To    ${SERVER}/users/2/edit
    Page Should Contain    First Name (Thai)
    Page Should Contain    Last Name (Thai)
    Page Should Contain    First Name (English)
    Page Should Contain    Last Name (English)
    Page Should Contain    Email
    Page Should Contain    Role
    Page Should Contain    Department
    Page Should Contain    Program
    Execute JavaScript    window.scrollTo(0,1500)
    Sleep    1s
    Element Text Should Be    xpath=//button[contains(@class, "btn btn-primary mt-5")]    Submit
    Wait Until Element Is Visible    xpath=//div[@class='filter-option-inner-inner' and text()='teacher']    10 seconds
    Click Element    xpath=//div[@class='filter-option-inner-inner' and text()='teacher']
    Sleep    1s
    Execute JavaScript    window.scrollTo(0,1500)
    Click Element    xpath=//*[@id="cat"]
    Sleep    1s
    Click Element    xpath=//*[@id="subcat"]
    Page Should Contain Element    xpath=//a[@href='${SERVER}/users' and contains(text(),'Cancel')]
    Click Element    xpath=//a[@href='${SERVER}/users' and contains(text(),'Cancel')]

    #Delete
    Wait Until Element Is Visible    ${DELETE_BUTTON_XPATH}    timeout=2s
    Click Element    ${DELETE_BUTTON_XPATH}
    Page Should Contain    Are you sure?
    Page Should Contain    If you delete this, it will be gone forever.
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='cancel']

    #New User
    Sleep    1s
    Go To    ${SERVER}/users/create
    ${html_source}=    Get Source
    Page Should Contain    First Name (Thai)
    Page Should Contain    Last Name (Thai)
    Page Should Contain    First Name (English)
    Page Should Contain    Last Name (English)
    Page Should Contain    Email
    Page Should Contain    Password:
    Page Should Contain    Confirm Password
    Page Should Contain    Role
    Page Should Contain    Department
    Page Should Contain    Program 
    Sleep    1s
    Execute JavaScript    window.scrollTo(0,1500)
    Click Element    xpath=//*[@id="cat"]
    Sleep    1s
    Click Element    xpath=//*[@id="subcat"]
    Go To    ${SERVER}/users
    Scroll Element Into View    xpath=//a[@href='${SERVER}/users']

    Click Element    xpath=//a[@href='${SERVER}/users']

    #importfiles
    Click Element    xpath=//a[@href='${SERVER}/importfiles']
    ${html_source}=    Get Source
    Page Should Contain    Import
    Sleep    1s
    Close Browser

Roles By ENG
    [tags]  RoleByENG
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Click Element    xpath=//a[@href='${SERVER}/roles']
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Action

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Should Contain    ${html_source}    Name
    Sleep    2s
    Go To    ${SERVER}/roles

    #Edit
    Go To    ${SERVER}/roles/5/edit
    Page Should Contain    Edit role
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Permission
    Sleep    1s
    Execute JavaScript    window.scrollTo(0,1500)
    Sleep    1s
    Page Should Contain Element    //button[@class="btn btn-primary mt-5" and text()="Submit"]
    Page Should Contain    Back
    Go To    ${SERVER}/roles

    #Delete
    Wait Until Element Is Visible   ${DELETE_BUTTON_XPATH}     timeout=10s
    Click Element    ${DELETE_BUTTON_XPATH}
    Sleep    1s
    Page Should Contain    Are you sure?
    Page Should Contain    If you delete this, it will be gone forever.
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='cancel']
    Page Should Contain Element    //button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger') and text()='ok']
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='cancel']
    Sleep    1s

    #Add
    Wait Until Element Is Visible   ${ADD_BUTTON_XPATH}     timeout=10s
    Click Element    ${ADD_BUTTON_XPATH}
    Page Should Contain    Create role
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Permission
    Execute JavaScript    window.scrollTo(0,1500)
    Sleep    1s
    Page Should Contain Element    //button[@class="btn btn-primary" and text()="Submit"]
    Scroll Element Into View    xpath=//a[@href='${SERVER}/roles']
    Click Element    xpath=//a[@href='${SERVER}/roles']
    Close Browser

Permission By ENG
    [tags]  PermissionByENG
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/permissions
    ${html_source}=    Get Source
    Page Should Contain    Permissions
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Action
    Page Should Contain    New Permission

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Permission
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/permissions
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']

    #Edit
    Click Element    ${ENG_EDIT_BUTTON_XPATH}
    Page Should Contain    Edit Permission
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Permission
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/permissions
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Permission
    Should Contain    ${html_source}    Action
    Sleep    1s

    #Delete
    Wait Until Element Is Visible   ${DELETE_BUTTON_XPATH}     timeout=10s
    Click Element    ${DELETE_BUTTON_XPATH}
    Sleep    1s
    Page Should Contain    Are you sure?
    Page Should Contain    If you delete this, it will be gone forever.
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='cancel']
    Page Should Contain Element    //button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger') and text()='ok']
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='cancel']
    Sleep    1s

    #Add
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${SERVER}/permissions/create']
    Page Should Contain    Create Permission
    Page Should Contain    Name
    Page Should Contain    Submit
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/permissions
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']
    Close Browser


Department By ENG
    [tags]  DepartmentByENG
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/departments
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Departments
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Action
    
    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Page Should Contain    Department
    Page Should Contain    Department Name (Thai)
    Page Should Contain    Department Name (English)
    Page Should Contain    Department of Computer Science
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/departments
    Sleep    1s
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']


    #Edit
    #Click Element    ${ENG_EDIT_BUTTON_XPATH}
    Click Element    xpath=//a[@href='${SERVER}/departments/1/edit']

    Page Should Contain    Edit Department
    Page Should Contain    Department Name (Thai)
    Page Should Contain    Department Name (English)
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/departments
    Sleep    1s
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']
    Sleep    1s


    #Delete
    Wait Until Element Is Visible   ${DELETE_BUTTON_XPATH}     timeout=10s
    Click Element    ${DELETE_BUTTON_XPATH}
    Sleep    1s
    Page Should Contain    Are you sure?
    Page Should Contain    If you delete this, it will be gone forever.
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='cancel']
    Page Should Contain Element    //button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger') and text()='ok']
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='cancel']
    Sleep    1s
    Close Browser


Manage Programs Page ENG
    [tags]  ManageProgram
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Scroll Element Into View    xpath=//a[@href='${SERVER}/programs']
    Click Element    xpath=//a[@href='${SERVER}/programs']
    ${html_source}=    Get Source
    Should Contain    ${html_source}    Name
    Should Contain    ${html_source}    Degree
    Should Contain    ${html_source}    ID
    Should Contain    ${html_source}    Action
    Page Should Contain    Program
    Should Contain    ${html_source}    Bachelor of Science
    Should Contain    ${html_source}    Computer Science
    Should Contain    ${html_source}    Show
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(., 'Add')]    2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn-primary')]
    Should Contain    ${button_text}    Add
    Sleep    2s

    # Add Program ENG
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
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-danger') and contains(., 'Cancel')]    timeout=2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-danger')]
    Should Contain    ${button_text}    Cancel
    Click Element    xpath=//a[contains(@class, 'btn btn-danger')]


    # Edit Program ENG
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
    Sleep    1s
    Scroll Element Into View    //select[@id="department"]
    Wait Until Element Is Visible    //select[@id="department"]    timeout=2s
    Click Element    //select[@id="department"]
    Sleep    1s
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn btn-danger') and contains(., 'Cancel')]    timeout=2s
    ${button_text}=    Get Text    xpath=//a[contains(@class, 'btn btn-danger')]
    Should Contain    ${button_text}    Cancel
    Click Element    xpath=//a[contains(@class, 'btn btn-danger')]
    

    #Delete
    Click Element    id=delete-program
    Page Should Contain    Are you sure?
    Page Should Contain    If you delete this, it will be gone forever.
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='cancel']
    Sleep    0.5s
    Close Browser














Experts By ENG
    [tags]  ExpertsByENG
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Scroll Element Into View    xpath=//a[@href='${SERVER}/experts']
    Sleep    1s
    Click Element    xpath=//a[@href='${SERVER}/experts']
    Sleep    1s
    Page Should Contain    ID
    Page Should Contain    Teacher Name
    Page Should Contain    Name
    Page Should Contain    Action
    Page Should Contain    Expertise of the Teacher
    Page Should Contain    Boonsup Waikham

    #Edit
    Click Element    xpath=//a[@id='edit-expertise']
    Sleep    1s
    Page Should Contain    Edit Expertise
    Page Should Contain    Name
    Page Should Contain    Submit
    Page Should Contain    Cancel
    ${URL}    Set Variable    ${SERVER}/experts
    Click Element    xpath=//a[@class='btn btn-danger' and @href='${URL}']
    Sleep    1s

    #Delete
    Click Element    xpath=//button[@id='delete-expertise']
    Page Should Contain    Are you sure?
    Page Should Contain    You will not be able to recover this!
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='Cancel']
    Sleep    1s
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='Cancel']
    Close Browser
