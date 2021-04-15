*** Settings ***
Library     CamundaLibrary    ${CAMUNDA_HOST}

*** Variables ***
${CAMUNDA_HOST}     http://localhost:8080
${PROCESS}    robot_demo
${TOPIC}    apply_ocr

*** Tasks ***
Full tour
    deploy model from file    ${CURDIR}/bpmn/identify_address.bpmn

    start process    ${PROCESS}

   ${variables}    fetch workload    ${TOPIC}

    ${result_variables}    Do some processing    ${variables}

    complete task    ${result_variables}

*** Keywords ***
Do some processing
    [Arguments]    ${variables}
    No Operation
    [Return]    ${{ {'test_value' : 1} }}