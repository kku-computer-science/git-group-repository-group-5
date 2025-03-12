*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${BROWSER}                Firefox
${DELAY}                  0.01
${VALID USER}             admin@gmail.com
${VALID PASSWORD}         12345678
${LOGIN URL}              http://127.0.0.1:8000/login
${WELCOME URL}            http://127.0.0.1:8000/dashboard

*** Test Cases ***
Show Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}

Input username and password
    Input Text    id=username    ${VALID USER}
    Input Text    id=password    ${VALID PASSWORD}