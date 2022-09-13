from pathlib import Path
from typing import Dict, Optional

import pytest
from python_on_whales.components.container.cli_wrapper import Container
from python_on_whales.docker_client import DockerClient
from testinfra.host import Host, get_host

homedir = "/root"
testdir = Path(__file__).parent.resolve()
tmpdir = testdir.joinpath("tmp")
container_workspace_root = "$HOME/workspace"


class DockerTestSession:
    temptestdir: Path
    docker_client: DockerClient
    services: Dict[str, Container]

    @classmethod
    def create(cls, service: str):
        session = DockerTestSession()
        session.docker_client = client = DockerClient(
            compose_files=[testdir / "docker-compose.yml"],
        )
        session.docker_client.compose.up(detach=True)
        containers = client.compose.ps()
        session.services = {
            container.config.labels["com.docker.compose.service"]: container
            for container in containers
        }
        return session

    def dispose(self):
        self.docker_client.compose.down(remove_images="local")


session_state: Optional[DockerTestSession] = None

def pytest_sessionfinish(session):
    if session_state:
        session_state.dispose()


@pytest.fixture(scope="session")
def docker_service():
    global session_state
    if not session_state:
        session_state = DockerTestSession.create("devcontainer")
    yield session_state.services["devcontainer"]


@pytest.fixture(scope="session")
def devcontainer(docker_service: Container):
    return get_host(f"docker://root@{docker_service.name}")


@pytest.fixture(scope="session")
def assertCommand(devcontainer: Host):
    def handler(command: str):
        result = devcontainer.run(f'cd {container_workspace_root} && zsh -c "source {homedir}/.zshrc && {command}"')
        info = dict(
            command=command, result=dict(output=result.stdout, exit_status=result.rc)
        )
        print("Command info: ", info)

        assert result.rc == 0

    return handler
