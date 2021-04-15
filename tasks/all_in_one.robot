*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${PROCESS}    robot_demo

*** Tasks ***
Start Process
    FOR    ${i}    IN RANGE    0    1
        Start process once
    END

Upload file to process
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch workload    ${TOPIC}
        Pass execution if    not ${workload}    ${i} workloads processed
        ${files}    Create Dictionary    image_binary=${workload}[test_file]
        complete task    files=${files}
    END

Apply OCR
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch workload    ${TOPIC}    lock_duration=1000    async_response_timeout=5000
        Pass execution if    not ${workload}    ${i} workloads processed
        ${result}    Process workload    ${workload}
        complete task    ${result}
    END

Validate champion
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch workload    ${TOPIC}    lock_duration=1000    async_response_timeout=10000
        Pass execution if    not ${workload}    ${i} workloads processed
        ${result}    Process workload    ${workload}
        complete task    ${result}
    END

Throw Dice
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch workload    ${TOPIC}    lock_duration=1000    async_response_timeout=5000
        Pass execution if    not ${workload}    ${i} workloads processed
        ${result}    Process workload    ${workload}
        complete task    ${result}
    END

*** Keywords **
Start process once
    ${test_files}    Create List    ${CURDIR}/resources/ocr-camunda.png    ${CURDIR}/resources/ocr-robocorp.png    ${CURDIR}/resources/ocr-robotframework.png
    FOR     ${test_file}    IN    @{test_files}
        ${variables}    Create Dictionary
        ...    test_file=${test_file}
        start process    ${PROCESS}    ${variables}
    END