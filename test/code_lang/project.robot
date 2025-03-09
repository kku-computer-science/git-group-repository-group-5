*** Settings ***   
Library          SeleniumLibrary
Test Teardown    Close Browser

*** Variables ***
${BROWSER}           chrome
${HOME_URL}          http://127.0.0.1:8000/
${WAIT_TIME}        3s

# ตัวแปรสำหรับเมนู Research Project (ปรับ locator ให้ตรงกับหน้าเว็บของคุณ)
${RESEARCH_PROJECT_MENU}       xpath=//a[contains(@href, '/researchproject')]

# ตัวแปรสำหรับ dropdown เปลี่ยนภาษา (ใช้ id จาก element ใน Blade)
${LANG_DROPDOWN_TOGGLE}    xpath=//a[@id="navbarDropdownMenuLink"]

# เปลี่ยนภาษา (ตัวเลือกใน dropdown)
${LANG_TO_THAI}       xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), 'ไทย')]
${LANG_TO_ENGLISH}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), 'English')]
${LANG_TO_CHINESE}    xpath=//div[contains(@class, 'dropdown-menu')]//a[contains(text(), '中文')]

# ตรวจสอบข้อความทั่วไปของหน้า Research Project (Expected texts อาจต้องปรับให้ตรงกับข้อมูลจริง)
@{EXPECTED_RP_EN}    
...    Academic Services Project / Research Project
...    Show 
...    entries
...    Search
...    Number	
...    Year	
...    Project 
...    Name	
...    Details	
...    Project
...    Leader	
...    Status
...    Project Duration
...    Research Grant Type
...    Funding Agency 
...    Responsible Agency
...    Allocated Budget 
...    External funding
...    Office of the Permanent Secretary (OPS) , MHESI Thailand
...    Computer Science
...    Baht
...    Lecturer Thanaphon Tangchoopong
...    Close Project
...    Showing 
...    to 
...    of 
...   entries
...    Previous
...    Next
...    การจัดอบรมหลักสูตรประกาศนียบัตร (Non-Degree) โครงการพัฒนาทักษะกำลังคนของประเทศ (Reskill/Upskill/Newskill) เพื่อการมีงานทำและเตรียมความพร้อมรองรับการทำงานในอนาคตหลังวิกฤตการระบาดของไวรัสโคโรนา 2019 (COVID-19)


@{EXPECTED_RP_TH}    
...    โครงการบริการวิชาการ/ โครงการวิจัย
...    แสดง 
...    รายการ
...    ค้นหา
...    ลำดับ	
...    ปี	
...    ชื่อโครงการ	
...    รายละเอียด	
...    ผู้รับผิดชอบโครงการ	
...    สถานะ
...    ระยะเวลาโครงการ 
...    ประเภททุนวิจัย
...    หน่วยงานที่สนันสนุนทุน
...    หน่วยงานที่รับผิดชอบ 
...    งบประมาณที่ได้รับจัดสรร
...    ทุนภายนอก
...    สำนักงานปลัดกระทรวงอุดมศึกษา วิทยาศาสตร์ วิจัยและนวัตกรรม
...    สาขาวิชาวิทยาการคอมพิวเตอร์
...    บาท
...    อ. ธนพล ตั้งชูพงศ์
...    ปิดโครงการ
...    แสดง 
...    ถึง
...    จาก
...    รายการ
...    ก่อนหน้า
...    ถัดไป
...    การจัดอบรมหลักสูตรประกาศนียบัตร (Non-Degree) โครงการพัฒนาทักษะกำลังคนของประเทศ (Reskill/Upskill/Newskill) เพื่อการมีงานทำและเตรียมความพร้อมรองรับการทำงานในอนาคตหลังวิกฤตการระบาดของไวรัสโคโรนา 2019 (COVID-19)



@{EXPECTED_RP_CN}    
...    学术服务项目 / 研究项目
...    显示 
...    条目
...    搜索
...    编号	
...    年份
...    项目名称
...    详细信息
...    项目负责人
...    状态
...    项目期限
...    研究资助类型
...    资助机构
...    负责机构 
...    分配的预算
...    外部资本
...    高等教育、科研与创新部常务秘书办公室
...    计算机科学系
...    泰铢
...    Lecturer Thanaphon Tangchoopong
...    结束项目
...    显示第 
...    至 
...    项结果
...    共
...    项
...    上页
...    下页
...    การจัดอบรมหลักสูตรประกาศนียบัตร (Non-Degree) โครงการพัฒนาทักษะกำลังคนของประเทศ (Reskill/Upskill/Newskill) เพื่อการมีงานทำและเตรียมความพร้อมรองรับการทำงานในอนาคตหลังวิกฤตการระบาดของไวรัสโคโรนา 2019 (COVID-19)


*** Keywords ***
Open Browser To Home Page
    Open Browser    ${HOME_URL}    ${BROWSER}
    Maximize Browser Window

Wait And Click
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}

Navigate To Research Project Page
    # คลิกเมนู Research Project
    Click Element    ${RESEARCH_PROJECT_MENU}
    # รอจนกว่าหน้า Research Project จะมีข้อความ "Research Project" (default เป็นภาษาอังกฤษ)
    Wait Until Page Contains    Research Project    10s

Verify Page Contains Multiple Texts
    [Arguments]    @{expected_texts}
    ${html_source}=    Get Source
    Log    HTML Source: ${html_source}
    FOR    ${text}    IN    @{expected_texts}
        Should Contain    ${html_source}    ${text}
    END

Switch Language And Verify
    [Arguments]    ${lang_button}    @{expected_texts}
    # คลิกเปิด dropdown เพื่อแสดงตัวเลือกภาษาที่ต้องการ
    Click Element    ${LANG_DROPDOWN_TOGGLE}
    Sleep    1s
    # ลองคลิกตัวเลือกภาษาที่ต้องการ (ใช้ Run Keyword And Ignore Error หากไม่พบ)
    Run Keyword And Ignore Error    Click Element    ${lang_button}
    Sleep    ${WAIT_TIME}
    Verify Page Contains Multiple Texts    @{expected_texts}

*** Test Cases ***
Navigate To Research Project Page And Switch To Chinese
    Open Browser To Home Page
    Navigate To Research Project Page
    Switch Language And Verify    ${LANG_TO_CHINESE}    @{EXPECTED_RP_CN}
    Close Browser

Navigate To Research Project Page And Switch To English
    Open Browser To Home Page
    Navigate To Research Project Page
    # แม้ว่าเว็บจะเปิดมาเป็นภาษาอังกฤษอยู่แล้ว ให้กด dropdown เพื่อยืนยัน
    Switch Language And Verify    ${LANG_TO_ENGLISH}    @{EXPECTED_RP_EN}
    Close Browser

Navigate To Research Project Page And Switch To Thai
    Open Browser To Home Page
    Navigate To Research Project Page
    Switch Language And Verify    ${LANG_TO_THAI}    @{EXPECTED_RP_TH}
    Close Browser
