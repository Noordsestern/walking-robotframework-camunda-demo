*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}
Library    Collections

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    throw_dice

*** Tasks ***
Throw Dice
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch workload    ${TOPIC}    lock_duration=1000    async_response_timeout=5000
        Pass execution if    not ${workload}    ${i} workloads processed
        ${result}    Process workload    ${workload}
        complete task    ${result}
    END

*** Keywords ***
Process workload
    [Arguments]    ${workload}
    ${dice_result}    Evaluate    random.randint(1, 6)    modules=random
    ${result}    Create Dictionary    dice=${dice_result}
    [Return]    ${result}