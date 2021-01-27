*** Settings ***
Library    CamundaLibrary.ExternalTask    ${CAMUNDA_HOST}
Library    FakerLibrary    locale=fi_FI
Library    Collections

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    parse_address
@{ERROR_CHANCE}    ${True}    ${False}

*** Tasks ***
Parse Address
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
    Return from Keyword if    ${workload}[error]    ${{ {} }}
    ${random_address}    Address
    ${address}    Create Dictionary    address=${random_address}
    [Return]    ${address}