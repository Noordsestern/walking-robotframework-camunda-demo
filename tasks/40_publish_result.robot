*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    load_scan

*** Tasks ***
Publish results
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch and lock workloads    ${TOPIC}
        Pass execution if    not ${workload}    ${i} workloads processed
        Process workload    ${workload}
        complete task
    END

*** Keywords ***
Process workload
    [Arguments]    ${workload}
    sleep    1s