*** Settings ***
Library    CamundaLibrary.ExternalTask    ${CAMUNDA_HOST}

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    load_scan

*** Tasks ***
Load scan from next envelope
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch and lock workloads    ${TOPIC}
        Pass execution if    not ${workload}    ${i} workloads processed
        ${result}    Process workload    ${workload}
        complete task    ${result}    ${{ {'scan_file' : '${CURDIR}/resources/robot-framework.png' }}}
    END

*** Keywords ***
Process workload
    [Arguments]    ${workload}
    [Return]    ${{ {'scanned' : True} }}