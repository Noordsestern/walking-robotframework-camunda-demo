*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    read_qr_code
@{ERROR_CHANCE}    ${True}    ${False}

*** Tasks ***
Read QR Code
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch workload    ${TOPIC}    lock_duration=1000
        Pass execution if    not ${workload}    ${i} workloads processed
        ${result}    Process workload    ${workload}
        complete task    ${result}
    END

*** Keywords ***
Process workload
    [Arguments]    ${workload}
    sleep    1s
    ${qr_code}    Evaluate    random.randint(1,6)    modules=random
    [Return]    ${{ {'dice' : ${qr_code}} }}
