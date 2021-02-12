*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}

*** Tasks ***
Deploy process
    ${response}    deploy model from file    ${CURDIR}/bpmn/identify_address.bpmn
    Should Not Be Empty     ${response}
    log    ${response}