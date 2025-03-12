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
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    FOR    ${word}    IN    @{EXPECTED_WORDS_USER_CN}
        Should Contain    ${html_source}    ${word}
    END

Profile Page by Chinese
    [tags]      Profile
    Click Element               xpath=//a[@href='${SERVER}/profile']
    Sleep    1s
    #Switch Language To    th    ไทย
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

    Click Element    xpath=//span[contains(@class, 'menu-title') and text()='密码']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    旧密码
    Should Contain    ${html_source}    新密码
    Should Contain    ${html_source}    确认新密码
    Should Contain    ${html_source}    密码设置
    ${placeholder_value}=    Get Element Attribute    id=inputpassword    placeholder
    Should Be Equal    ${placeholder_value}    请输入当前密码

Funds Page By Chinese
    #Go To    ${SERVER}/funds
    [tags]    FundPageByChinese
    Click Element               xpath=//a[@href='${SERVER}/funds']
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究基金
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    资本类型
    Should Contain    ${html_source}    资金级别
    Should Contain    ${html_source}    未知
    Should Contain    ${html_source}    内部资金

    # View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=1s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
    ${html_source}=    Get Source
    Should Contain    ${html_source}    资金详情
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    资金年份
    Should Contain    ${html_source}    资助机构
    Should Contain    ${html_source}    资金来源
    Should Contain    ${html_source}    返回
    Click Element    xpath=//a[@href='${SERVER}/funds' and contains(text(),'返回')]


    #Edit
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='编辑']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='编辑']
    ${html_source}=    Get Source
    Should Contain    ${html_source}    编辑基金
    Should Contain    ${html_source}    资金类型
    Should Contain    ${html_source}    资金级别
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    资助机构
    Sleep    2s  # รอให้หน้าโหลด


    Click Element    id=fund_type
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@id="fund_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    内部资金
    Should Contain    ${options}    外部资金

    Click Element    id=fund_level
    Sleep    1s
    ${DROPDOWN_XPATH}=    Set Variable    //select[@name="fund_level"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}

    Should Contain    ${options}    未知
    Should Contain    ${options}    高
    Should Contain    ${options}    中等
    Should Contain    ${options}    低
    Sleep    1s
    Click Element    xpath=//a[@href='${SERVER}/funds' and contains(text(),'取消')]

    # ADD
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    资金类型
    Should Contain    ${html_source}    资金级别
    Should Contain    ${html_source}    基金名称
    Should Contain    ${html_source}    支持机构 / 研究项目
    Click Element     id=fund_type
    Sleep    0.5s
    Click Element     id=fund_level
    Sleep    0.5s
    Click Element    xpath=//a[@href='${SERVER}/funds' and contains(text(),'取消')]

    #Delete
    Wait Until Element Is Visible    ${DELETE_BUTTON_XPATH}    timeout=2s
    Click Element    ${DELETE_BUTTON_XPATH}
    Page Should Contain    你确定吗
    Page Should Contain    如果删除，它将永远消失。
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Sleep    0.5s
    Close Browser


Research Projects Page By Chinese
    [tags]    ResearchProjectsPageByChinese
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    zh    中文
    Click Element               xpath=//a[@href='${SERVER}/researchProjects']
    Sleep    1s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究项目
    Should Contain    ${html_source}    年份
    Should Contain    ${html_source}    项目名称
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    成员
    Should Contain    ${html_source}    操作
    Should Contain    ${html_source}    搜索

    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s

    # View
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

    # Edit
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='编辑']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='编辑']

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
    Scroll Element Into View    xpath=//a[@href='${SERVER}/researchProjects' and contains(text(),'返回')]
    Click Element    xpath=//a[@href='${SERVER}/researchProjects' and contains(text(),'返回')]

    # Add
    Go To    ${SERVER}/researchProjects
    Wait Until Element Is Visible       ${ADD_BUTTON_XPATH}     timeout=2s
    Click Element    ${ADD_BUTTON_XPATH}

    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究项目名称
    Should Contain    ${html_source}    开始日期
    Should Contain    ${html_source}    结束日期
    Should Contain    ${html_source}    选择资金来源
    Should Contain    ${html_source}    提交年份 (公元)
    Should Contain    ${html_source}    预算
    Should Contain    ${html_source}    负责单位
    Should Contain    ${html_source}    项目详情
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
    Should Contain    ${html_source}    Ngamnij

    Scroll Element Into View    //span[@id="select2-selUser0-container"]
    Click Element    //span[@id="select2-selUser0-container"]
    Element Should Contain    //span[@id="select2-selUser0-container"]    选择用户
    Should Contain    ${html_source}    Ngamnij
    Sleep    1s

    Scroll Element Into View    xpath=//a[@href='${SERVER}/researchProjects' and contains(text(),'取消')]
    Click Element    xpath=//a[@href='${SERVER}/researchProjects' and contains(text(),'取消')]

    #Delete
    Wait Until Element Is Visible    ${DELETE_BUTTON_XPATH}    timeout=2s
    Click Element    ${DELETE_BUTTON_XPATH}
    Page Should Contain    你确定吗
    Page Should Contain    如果删除，它将永远消失。
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Sleep    0.5s
    Close Browser

Research Groups Page By Chinese
    [tags]  researchGroups
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/researchGroups
    Switch Language To    zh    中文
    Sleep    2s
    
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究小组
    Should Contain    ${html_source}    编号
    Should Contain    ${html_source}    小组名称（泰语）
    Should Contain    ${html_source}    研究小组负责人
    Should Contain    ${html_source}    成员
    Should Contain    ${html_source}    操作
    Should Contain    ${html_source}    搜索

    # View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s  # รอให้หน้าโหลด
    ${html_source}=    Get Source
    Should Contain    ${html_source}    研究小组详情
    Should Contain    ${html_source}    小组名称（泰语）
    Should Contain    ${html_source}    小组名称（英语）
    Should Contain    ${html_source}    小组描述（泰语）
    Should Contain    ${html_source}    小组描述（英语）
    Should Contain    ${html_source}    小组详情（泰语）
    Should Contain    ${html_source}    小组详情（英语）
    Should Contain    ${html_source}    研究小组负责人
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
    Element Should Contain    //span[@id="select2-head0-container"]    Pipat Reungsang
    Click Element    //span[@id="select2-head0-container"]
    Sleep    1s

    Wait Until Element Is Visible    //span[@id="select2-selUser1-container"]    timeout=5s
    Click Element    //span[@id="select2-selUser1-container"]
    Element Should Contain    //span[@id="select2-selUser1-container"]    Chaiyapon Keeratikasikorn
    Sleep    1s
    Scroll Element Into View    xpath=//a[@href='${SERVER}/researchGroups' and contains(text(),'返回')]
    Click Element    xpath=//a[@href='${SERVER}/researchGroups' and contains(text(),'返回')]   

    # Add
    Go To    ${SERVER}/researchGroups
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
    Wait Until Element Is Visible    //span[@id="select2-head0-container"]    timeout=5s

    Sleep    1s


    Scroll Element Into View    xpath=//a[@href='${SERVER}/researchGroups' and contains(text(),'返回')]
    Click Element    xpath=//a[@href='${SERVER}/researchGroups' and contains(text(),'返回')] 


    #Delete
    Wait Until Element Is Visible    ${DELETE_BUTTON_XPATH}    timeout=2s
    Click Element    ${DELETE_BUTTON_XPATH}
    Page Should Contain    你确定吗
    Page Should Contain    如果删除，它将永远消失。
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Sleep    0.5s
    Close Browser

Manage Publications
    [tags]  ManagePublications
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Switch Language To    zh    中文
    Sleep    2s

    #Papers
    Click Element    xpath=//span[contains(text(), '管理出版物')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/papers') and contains(text(), '已发布的研究')]    timeout=5s
    
    # "ผลงานวิจัยที่เผยแพร่"
    Click Element    xpath=//a[contains(@href, '/papers') and contains(text(), '已发布的研究')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    已发表研究
    Should Contain    ${html_source}    编号
    Should Contain    ${html_source}    论文名
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


    Scroll Element Into View    id=paper_type
    Click Element    id=paper_type
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_type"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    期刊
    Sleep    0.5s


    Scroll Element Into View    id=paper_subtype
    Click Element    id=paper_subtype
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="paper_subtype"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    请选择子类型
    Should Contain    ${options}    文章
    Should Contain    ${options}    会议论文
    Should Contain    ${options}    社论
    Should Contain    ${options}    评论
    Should Contain    ${options}    勘误
    Should Contain    ${options}    书中章节


    Sleep    0.5s
    Scroll Element Into View    id=publication
    Click Element    id=publication
    ${DROPDOWN_XPATH}=    Set Variable    //select[@class="custom-select my-select" and @name="publication"]
    ${options}=    Get List Items    ${DROPDOWN_XPATH}
    Should Contain    ${options}    国际期刊

    Scroll Element Into View    xpath=//*[contains(text(),'文档类型')]
    Should Contain              ${html_source}    文档类型

    Scroll Element Into View    xpath=//*[contains(text(),'子类型')]
    Should Contain              ${html_source}    子类型

    Scroll Element Into View    xpath=//*[contains(text(),'出版')]
    Should Contain              ${html_source}    出版

    Scroll Element Into View    xpath=//*[contains(text(),'引用')]
    Should Contain              ${html_source}    引用

    Scroll Element Into View    xpath=//*[contains(text(),'页码')]
    Should Contain              ${html_source}    页码

    Scroll Element Into View    xpath=//*[contains(text(),'支持基金')]
    Should Contain              ${html_source}    支持基金

    Scroll Element Into View    xpath=//*[contains(text(),'部门内作者姓名')]
    Should Contain              ${html_source}    部门内作者姓名
    Scroll Element Into View    id=selUser0
    Click Element               id=selUser0
    Click Element               id=pos

    Scroll Element Into View    id=submit

    Scroll Element Into View    xpath=//*[contains(text(),'部门外作者姓名')]
    Should Contain              ${html_source}    部门外作者姓名
    Scroll Element Into View    id=pos2
    Click Element               id=pos2


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
    Scroll Element Into View    xpath=//a[contains(text(),'返回')]
    Click Element    xpath=//a[contains(text(),'返回')]

    #books
    Click Element    xpath=//span[contains(text(), '管理出版物')]
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/books') and contains(text(), '书籍')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/books') and contains(text(), '书籍')]
    Sleep    2s

    ${html_source}=    Get Source
    Log    ${html_source}
    Should Contain    ${html_source}    书
    Should Contain    ${html_source}    显示 
    Get Text    xpath=//th[contains(text(), '不。')]
    Should Contain    ${html_source}    姓名
    Should Contain    ${html_source}    年
    Get Text    xpath=//th[contains(text(), '出版物来源')]
    Should Contain    ${html_source}    页

    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    添加一本书
    Should Contain    ${html_source}    填写详细信息
    Should Contain    ${html_source}    出版地
    Should Contain    ${html_source}    年（广告）
    Should Contain    ${html_source}    页数

    Sleep    1s
    Click Element               xpath=//a[@href='${SERVER}/books' and contains(text(),'取消')]


    #Patents
    Wait Until Element Is Visible    xpath=//a[contains(@href, '/patents') and contains(text(), '专利')]    timeout=2s
    Click Element    xpath=//a[contains(@href, '/patents') and contains(text(), '专利')]

    ${html_source}=    Get Source
    Should Contain    ${html_source}    其他学术作品 (专利, 实用新型, 版权)
    Should Contain    ${html_source}    显示 
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn-primary') and contains(., '添加 ')]    2s
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

    # Add
    Click Element   ${ADD_BUTTON_XPATH}
    ${html_source}=    Get Source
    Should Contain    ${html_source}    添加
    Should Contain    ${html_source}    输入专利、实用新型或版权的详细信息
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    类别
    Scroll Element Into View    xpath=//select[@name='ac_type']
    Click Element               xpath=//select[@name='ac_type']

    Should Contain    ${html_source}    注册日期
    Should Contain    ${html_source}    注册编号
    Should Contain    ${html_source}    内部作者
    Scroll Element Into View    id=add-btn2
    Click Element               id=add-btn2
    Sleep    1s
    Wait Until Element Is Visible    xpath=//select[@id='selUser1']    10s
    Click Element    id=selUser1


    Scroll Element Into View    xpath=//label[contains(text(),'外部作者')]
    
    Scroll Element Into View    xpath=//a[@href='${SERVER}/patents' and contains(text(),'取消')]

    Page Should Contain Element    xpath=//a[@href='${SERVER}/patents' and contains(text(),'取消')]
    Click Element    xpath=//a[@href='${SERVER}/patents' and contains(text(),'取消')]
    Sleep    1s

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Sleep    2s
    ${html_source}=    Get Source
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    类别
    Should Contain    ${html_source}    注册日期
    Should Contain    ${html_source}    注册编号
    Should Contain    ${html_source}    创建者
    Should Contain    ${html_source}    共同创建者
    Sleep    3s
    Click Element               xpath=//a[@href='${SERVER}/patents' and contains(@class,'btn-primary')]
    Close Browser


Menu User By Chinese
    [tags]  userByChinese
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/users
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    Should Contain    ${html_source}    姓名
    Should Contain    ${html_source}    部门
    Should Contain    ${html_source}    电子邮件：
    Should Contain    ${html_source}    角色
    Should Contain    ${html_source}    操作

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Wait Until Page Contains    用户信息    timeout=5s    # Wait for the "View" page to load
    ${view_page_source}=    Get Source    # Get source after loading the "View" page
    Should Contain    ${view_page_source}    名字（泰语）
    Should Contain    ${view_page_source}    名字（英语）
    Should Contain    ${view_page_source}    电子邮件：
    Should Contain    ${view_page_source}    角色
    Should Contain    ${view_page_source}    密码：
    Should Contain    ${view_page_source}    用户信息
    Sleep    0.5s

    #Edit
    Go To    ${SERVER}/users/2/edit
    Wait Until Page Contains    编辑用户信息    timeout=5s    # Wait for the "Edit" page to load
    ${edit_page_source}=    Get Source    # Get source after loading the "Edit" page
    Should Contain    ${edit_page_source}    名字（泰语）
    Should Contain    ${edit_page_source}    名字（英文）
    Should Contain    ${edit_page_source}    电子邮件：
    Should Contain    ${edit_page_source}    密码：
    Should Contain    ${edit_page_source}    确认密码
    Should Contain    ${edit_page_source}    角色
    Should Contain    ${edit_page_source}    状态

    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn dropdown-toggle') and contains(@class, 'bs-placeholder')]    timeout=10s    # Wait for the dropdown button
    Click Element    xpath=//button[contains(@class, 'btn dropdown-toggle') and contains(@class, 'bs-placeholder')]    # Attempt to open the dropdown
    # Fallback JavaScript click if regular click fails
    Execute JavaScript    document.querySelector('button.btn.dropdown-toggle.bs-placeholder').click()
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'dropdown-menu') and contains(@class, 'show')]    timeout=10s    # Ensure dropdown is open
    ${dropdown_html}=    Get Element Attribute    xpath=//div[contains(@class, 'dropdown-menu') and contains(@class, 'show')]    innerHTML
    Log    Dropdown HTML: ${dropdown_html}    # Log dropdown contents for debugging
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(., '老师')]    timeout=10s    # Wait for "老师" option with broader text match
    Click Element    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(., '老师')]    # Select "teacher" (老师)
    Wait Until Element Contains    xpath=//div[@class='filter-option-inner-inner']    老师    timeout=5s    # Verify "teacher" is selected

    Execute JavaScript    window.scrollTo(0,1500)
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'btn btn-primary mt-5')]    timeout=5s
    Element Text Should Be    xpath=//button[contains(@class, 'btn btn-primary mt-5')]    提交
    Execute JavaScript    window.scrollTo(0,1500)
    Wait Until Element Is Visible    xpath=//*[@id="cat"]    timeout=5s
    Click Element    xpath=//*[@id="cat"]
    Wait Until Element Is Visible    xpath=//*[@id="subcat"]    timeout=5s
    Click Element    xpath=//*[@id="subcat"]
    Page Should Contain Element    xpath=//a[@href='${SERVER}/users' and contains(text(), '取消')]
    Click Element    xpath=//a[@href='${SERVER}/users' and contains(text(), '取消')]

    #New User
    Go To    ${SERVER}/users/create
    ${html_source}=    Get Source
    Should Contain    ${html_source}    名字（泰语）
    Should Contain    ${html_source}    名字（英文）
    Should Contain    ${html_source}    姓氏（泰语）
    Should Contain    ${html_source}    姓氏（英文）
    Should Contain    ${html_source}    电子邮件
    Should Contain    ${html_source}    密码
    Should Contain    ${html_source}    确认密码
    Should Contain    ${html_source}    角色
    Should Contain    ${html_source}    部门 
    Should Contain    ${html_source}    项目 
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
    Page Should Contain    导入Excel，CSV文件
    Sleep    1s
    Close Browser

Roles By Chinese
    [tags]  RoleByChinese
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Click Element    xpath=//a[@href='${SERVER}/roles']
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    操作

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    权限
    Sleep    2s
    Go To    ${SERVER}/roles

    #Edit
    Go To    ${SERVER}/roles/5/edit
    Page Should Contain    编辑角色
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    权限
    Sleep    1s
    Execute JavaScript    window.scrollTo(0,1500)
    Sleep    1s
    Page Should Contain Element    //button[@class="btn btn-primary mt-5" and text()="提交"]
    Page Should Contain    返回
    Go To    ${SERVER}/roles

    # Add
    Wait Until Element Is Visible   ${ADD_BUTTON_XPATH}     timeout=10s
    Click Element    ${ADD_BUTTON_XPATH}
    Page Should Contain    创建角色
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    权限
    Execute JavaScript    window.scrollTo(0,1500)
    Sleep    1s
    Page Should Contain Element    //button[@class="btn btn-primary" and text()="提交"]
    Go To    ${SERVER}/roles
    

    #Delete
    Wait Until Element Is Visible   ${DELETE_BUTTON_XPATH}     timeout=10s
    Click Element    ${DELETE_BUTTON_XPATH}
    Sleep    1s
    Page Should Contain    您确定吗？
    Page Should Contain    如果您删除它，它将永远消失。
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Page Should Contain Element    //button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger') and text()='好的']
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Sleep    1s
    Close Browser
    

Permission By Chinese
    [tags]  PermissionByChinese
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/permissions
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    Should Contain    ${html_source}    权限
    Should Contain    ${html_source}    名字
    Should Contain    ${html_source}    操作
    Page Should Contain    新权限

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Should Contain    ${html_source}    名字
    Should Contain    ${html_source}    权限
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/permissions
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']

    #Edit
    Wait Until Element Is Visible    //a[contains(@class, 'btn-outline-success') and @title='编辑']    timeout=2s
    Click Element    //a[contains(@class, 'btn-outline-success') and @title='编辑']
    Page Should Contain    编辑权限
    Should Contain    ${html_source}    名字
    Should Contain    ${html_source}    权限
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/permissions
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']

    # Add
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${SERVER}/permissions/create']
    Page Should Contain    创建权限
    Page Should Contain    名字
    Page Should Contain    提交
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/permissions
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']

    #Delete
    Wait Until Element Is Visible   ${DELETE_BUTTON_XPATH}     timeout=10s
    Click Element    ${DELETE_BUTTON_XPATH}
    Sleep    1s
    Page Should Contain    您确定吗？
    Page Should Contain    如果您删除它，它将永远消失。
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Page Should Contain Element    //button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger') and text()='好的']
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Sleep    1s
    Close Browser
    

Department By Chinese
    [tags]  DepartmentByChinese
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Go To    ${SERVER}/departments
    Switch Language To    zh    中文
    ${html_source}=    Get Source
    Should Contain    ${html_source}    所有部门
    Should Contain    ${html_source}    名称
    Should Contain    ${html_source}    操作

    #View
    Wait Until Element Is Visible    ${VIEW_BUTTON_XPATH}    timeout=10s
    Click Element    ${VIEW_BUTTON_XPATH}
    Page Should Contain    部门
    Page Should Contain    部门名称（泰语）
    Page Should Contain    部门名称（英语）
    Page Should Contain    สาขาวิชาวิทยาการคอมพิวเตอร์
    Sleep    1s
    ${URL}    Set Variable    ${SERVER}/departments
    Sleep    1s
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']

    #Edit
    Wait Until Element Is Visible    xpath=//a[contains(@class, 'btn') and contains(@class, 'btn-sm') and contains(@href, '/departments') and contains(@href, '/edit')]/i[contains(@class, 'mdi-pencil')]    timeout=10s    # Updated XPath
    ${edit_button_html}=    Get Element Attribute    xpath=//a[contains(@class, 'btn') and contains(@class, 'btn-sm') and contains(@href, '/departments') and contains(@href, '/edit')]/i[contains(@class, 'mdi-pencil')]    outerHTML
    Log    Edit Button HTML: ${edit_button_html}    # Debug button presence
    Click Element    xpath=//a[contains(@class, 'btn') and contains(@class, 'btn-sm') and contains(@href, '/departments') and contains(@href, '/edit')]/i[contains(@class, 'mdi-pencil')]
    Wait Until Page Contains    修改部门    timeout=5s
    Page Should Contain    部门名称（泰语）:
    Page Should Contain    部门名称（英语）:
    ${URL}    Set Variable    ${SERVER}/departments
    Click Element    xpath=//a[@class='btn btn-primary' and @href='${URL}']
    Wait Until Location Is    ${URL}    timeout=5s


    #Delete
    Wait Until Element Is Visible   ${DELETE_BUTTON_XPATH}     timeout=10s
    Click Element    ${DELETE_BUTTON_XPATH}
    Sleep    1s
    Page Should Contain    您确定吗？
    Page Should Contain    如果您删除它，它将永远消失。
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Page Should Contain Element    //button[contains(@class, 'swal-button--confirm') and contains(@class, 'swal-button--danger') and text()='好的']
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Sleep    1s
    Close Browser

Manage Programs Page CN
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Sleep    2s
    Switch Language To    zh    中文
    Scroll Element Into View    xpath=//a[@href='${SERVER}/programs']
    Click Element    xpath=//a[@href='${SERVER}/programs']
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
    Sleep    1s
    Scroll Element Into View    //select[@id="department"]
    Wait Until Element Is Visible    //select[@id="department"]    timeout=2s
    Click Element    //select[@id="department"]
    Sleep    1s
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
    Close Browser

Experts By Chinese
    [tags]  ExpertsByChinese
    Open Browser To Login Page
    Login Page Should Be Open
    User Login
    Switch Language To    zh    中文
    Scroll Element Into View    xpath=//a[@href='${SERVER}/experts']
    Sleep    1s
    Click Element    xpath=//a[@href='${SERVER}/experts']
    Sleep    1s
    Page Should Contain    编号
    Page Should Contain    教师姓名
    Page Should Contain    名称
    Page Should Contain    操作
    Page Should Contain    教师的专长
    Page Should Contain    Boonsup Waikham

    #Edit
    Click Element    xpath=//a[@id='edit-expertise']
    Sleep    1s
    Page Should Contain    编辑专长
    Page Should Contain    名字
    Page Should Contain    提交
    Page Should Contain    取消
    ${URL}    Set Variable    ${SERVER}/experts
    Click Element    xpath=//a[@class='btn btn-danger' and @href='${URL}']
    Sleep    1s

    #Delete
    Click Element    xpath=//button[@id='delete-expertise']
    Page Should Contain    你确定吗？
    Page Should Contain    删除后将无法恢复!
    Page Should Contain Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']
    Sleep    1s
    Click Element    //button[contains(@class, 'swal-button--cancel') and text()='取消']