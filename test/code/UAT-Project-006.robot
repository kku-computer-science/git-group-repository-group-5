*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}                Chrome
${DELAY}                  0.01
${VALID USER}             admin@gmail.com
${VALID PASSWORD}         12345678
${LOGIN URL}              http://127.0.0.1:8000/login
${WELCOME URL}            http://127.0.0.1:8000/dashboard
${LOGS_SYSTEM_BUTTON}     xpath=//span[@class='menu-title' and text()='Logs System']
${FILTER_BUTTON}          xpath=//button[@type='submit' and text()='Filter']
${SELECTED_DATE}          xpath=//input[@id='selected_date']

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
    Page Should Contain    Research Information Management System

Logs System Button
    Page Should Contain Element    ${LOGS_SYSTEM_BUTTON}
    Wait Until Element Is Visible    ${LOGS_SYSTEM_BUTTON}    10s
    Scroll Element Into View    ${LOGS_SYSTEM_BUTTON}  
    Click Element    ${LOGS_SYSTEM_BUTTON}
    Wait Until Page Contains    Logs System
    Sleep         3s

Filter System Logs by Date
    Wait Until Element Is Visible    ${SELECTED_DATE}    10s
    Input Text    ${SELECTED_DATE}    2025-02-13
    Sleep    2s
    Click Button    ${FILTER_BUTTON}
    Sleep    2s
    Wait Until Page Contains    2025-02-13    timeout=10s
