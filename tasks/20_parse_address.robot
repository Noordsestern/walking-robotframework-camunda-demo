*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}
Library    FakerLibrary    locale=fi_FI
Library    Collections

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    identify_champion

*** Tasks ***
Parse Address
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch workload    ${TOPIC}    lock_duration=1000
        Pass execution if    not ${workload}    ${i} workloads processed
        ${result}    Process workload    ${workload}
        complete task    ${result}
    END

*** Keywords ***
Process workload
    [Arguments]    ${workload}
    ${is_known_automation_champion}    Evaluate    '${workload}[text]' in ['Robot Framework', 'Robocorp']
    ${result}    Create Dictionary    known_champion=${is_known_automation_champion}
    [Return]    ${result}