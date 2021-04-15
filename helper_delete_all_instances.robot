*** Settings ***
Library    CamundaLibrary    ${CAMUNDA_HOST}

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${PROCESS}    robot_demo

*** Tasks ***
Delete all instances
    ${all_instances}    Get all active process instances    ${PROCESS}
    FOR    ${instance}    IN    @{all_instances}
        delete process instance    ${instance}[id]
    END