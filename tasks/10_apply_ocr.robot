*** Settings ***
Library    CamundaLibrary.ExternalTask    ${CAMUNDA_HOST}

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    ocr
@{ERROR_CHANCE}    ${True}    ${False}    ${False}    ${False}    ${False}

*** Tasks ***
Apply OCR
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch and lock workloads    ${TOPIC}
        Pass execution if    not ${workload}    ${i} workloads processed
        ${result}    Process workload    ${workload}
        complete task    ${result}
    END

*** Keywords ***
Process workload
    [Arguments]    ${workload}
    sleep    1s
    ${error_index}    Evaluate    random.randint(0,4)    modules=random
    ${result}    Set Variable   ${ERROR_CHANCE}[${error_index}]
    [Return]    ${{ {'error' : ${result}} }}
