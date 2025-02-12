*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${BROWSER}                Chrome
${DELAY}                  0.01
${VALID USER}             chakso@kku.ac.th
${VALID PASSWORD}         123456789
${LOGIN URL}              http://127.0.0.1:8000/login
${WELCOME URL}            http://127.0.0.1:8000/dashboard
${LOGS URL}              http://127.0.0.1:8000/logs/overall
${LOGS_SYSTEM_BUTTON}     xpath=//span[@class='menu-title' and text()='Logs System']

*** Test Cases ***
Show Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}

Input username and password
    Input Text    id=username    ${VALID USER}
    Input Text    id=password    ${VALID PASSWORD}
    Click Element    xpath=//button[text()='Log In']
    Sleep         3s  

Verify Login Success	
    Page Should Contain    สวัสดี รศ.ดร. จักรชัย โสอินทร์
	
Verify Not Show Logs System Button
    # Verify that Logs System button is not visible
    Page Should Not Contain Element    ${LOGS_SYSTEM_BUTTON}
    
    # Verify still on the same page
    Location Should Be    ${WELCOME URL}

Change Url Test
    # Try to access logs page by changing URL directly
    Go To    ${LOGS URL}
    Sleep    2s
    
    # Verify that user stays on dashboard page (not allowed to access logs page)
    Location Should Be    ${WELCOME URL}
    
    Close Browser