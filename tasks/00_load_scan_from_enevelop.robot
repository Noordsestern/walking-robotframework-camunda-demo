*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}
Library    Collections

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    load_scan

*** Tasks ***
Load scan from next envelope
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch workload    ${TOPIC}
        Pass execution if    not ${workload}    ${i} workloads processed
        ${files}    Create Dictionary    image_binary=${workload}[test_file]
        complete task    files=${files}
    END