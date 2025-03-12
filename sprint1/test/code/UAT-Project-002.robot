*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}             http://127.0.0.1:8000
${BROWSER}         Chrome
${LOGIN_URL}       ${URL}/login
${INVALID_ADMIN}    admin@gmail.com
${ERROR_MESSAGE}    Login Failed: Your user ID or password is incorrect
${WAIT_TIME}        5s

*** Keywords ***
Open Browser To App
    Open Browser    ${URL}    ${BROWSER}

Go To Login Page
    Go To    ${LOGIN_URL}

Enter Invalid Credentials
    Input Text    id=username    ${INVALID_ADMIN}
    Input Text    id=password    123456789
    Wait Until Element Is Visible    xpath=//button[@type='submit']    ${WAIT_TIME} 
    Click Button    xpath=//button[@type='submit'] 

Verify Login Error
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'alert-danger')]    ${WAIT_TIME}
    Page Should Contain    ${ERROR_MESSAGE}

Close Browser
    Run Keyword If    '${BROWSER}' == 'Chrome'    Close All Browsers

*** Test Cases ***
Invalid Login Test
    Open Browser To App
    Go To Login Page
    Enter Invalid Credentials
    Verify Login Error
    [Teardown]    Close Browser
