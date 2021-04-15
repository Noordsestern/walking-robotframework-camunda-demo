*** Settings ***
Library    CamundaLibrary   ${CAMUNDA_HOST}
Library    OcrService    bcp_url=${bcp}[url]    bcp_key=${bcp}[key]    texel_url=${texel}[url]


*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${TOPIC}    ocr
@{ERROR_CHANCE}    ${True}    ${False}    ${False}    ${False}    ${False}


*** Tasks ***
Apply OCR
    FOR    ${i}    IN RANGE    ${MAX_WORKLOAD_PROCESSED}
        ${workload}    fetch workload    ${TOPIC}    lock_duration=1000    async_response_timeout=5000
        Pass execution if    not ${workload}    ${i} workloads processed
        ${result}    Process workload    ${workload}
        complete task    ${result}
    END


*** Keywords ***
Process workload
    [Arguments]    ${workload}
    ${image_file}    Download file from variable    image_binary
    ${text}    read text from image    ${image_file}
    [Return]    ${{ {'text' : '${text}'} }}
