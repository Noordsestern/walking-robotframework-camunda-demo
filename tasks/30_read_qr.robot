*** Settings ***
Library    CamundaLibrary.ExternalTask    ${CAMUNDA_HOST}

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    read_qr_code
@{ERROR_CHANCE}    ${True}    ${False}

*** Tasks ***
Read QR Code
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
    ${qr_code}    Evaluate    random.randint(0,999999999)    modules=random
    [Return]    ${{ {'qr' : ${qr_code}} }}
