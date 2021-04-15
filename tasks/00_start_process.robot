*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}
Library    Collections

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${PROCESS}    robot_demo

*** Tasks ***
Start Process
    FOR    ${i}    IN RANGE    0    1
        Start process once
    END


*** Keywords **
Start process once
    ${test_files}    Create List    ${CURDIR}/resources/ocr-camunda.png    ${CURDIR}/resources/ocr-robocorp.png    ${CURDIR}/resources/ocr-robotframework.png
    FOR     ${test_file}    IN    @{test_files}
        ${variables}    Create Dictionary
        ...    test_file=${test_file}
        start process    ${PROCESS}    ${variables}
    END