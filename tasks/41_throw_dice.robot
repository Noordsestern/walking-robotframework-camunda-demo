*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}
Library    Collections
Library    RequestsLibrary

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
    [Teardown]    Run Keyword If Test Failed    Raise BPMN Error

*** Keywords ***
Process workload
    [Arguments]    ${workload}
    ${dice_result}    Evaluate    random.randint(1, 6)    modules=random
    Run keyword If    $dice_result < 3    Fail   Bad luck!
    ${result}    Create Dictionary    dice=${dice_result}
    [Return]    ${result}

Raise BPMN Error
    ${external_task_object}    Get fetch response
    ${headers}    Create Dictionary
    ...    Content-Type=application/json
    Create Session    camunda    ${CAMUNDA_HOST}
    ${body}    Create Dictionary
    ...    workerId=${external_task_object}[worker_id]
    ...    errorMessage=${TEST_MESSAGE}
    ...    errorCode=dice-error
    Post On Session
    ...    alias=camunda
    ...    url=/engine-rest/external-task/${external_task_object}[id]/bpmnError
    ...    json=${body}
    ...    headers=${headers}