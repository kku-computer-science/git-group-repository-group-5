*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${BROWSER}          Chrome
${DELAY}            0.01
${VALID USER}       admin@gmail.com
${VALID PASSWORD}    12345678
${LOGIN URL}        http://127.0.0.1:8000/login
${WELCOME URL}      http://127.0.0.1:8000/dashboard
${LOGS_SYSTEM_BUTTON}  xpath=//span[@class='menu-title' and text()='Logs System']
${USER_DROPDOWN}      xpath=//select[@name='user_id']

*** Test Cases ***
Show Login Page
    Open Browser           ${LOGIN URL}         ${BROWSER}
    Set Selenium Speed      ${DELAY}

Input Username And Password
    Input Text           id=username          ${VALID USER}
    Input Text           id=password          ${VALID PASSWORD}
    Click Element        xpath=//button[text()='Log In']
    Sleep              3s

Verify Login Success
    Page Should Contain      Research Information Management System

Logs System Button
    Scroll Element Into View   ${LOGS_SYSTEM_BUTTON}
    Page Should Contain Element  ${LOGS_SYSTEM_BUTTON}
    Click Element        ${LOGS_SYSTEM_BUTTON}
    Sleep              5s

Filter User
    Wait Until Element Is Visible    ${USER_DROPDOWN}    timeout=10s

    Execute JavaScript    document.querySelector("select[name='user_id']").style.display = 'block';
    Execute JavaScript    document.querySelector("select[name='user_id']").style.visibility = 'visible';
    Execute JavaScript    document.querySelector("select[name='user_id']").style.opacity = '1';
    Select From List By Value    ${USER_DROPDOWN}    3

    Sleep    2s