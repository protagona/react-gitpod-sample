import pytest
from conftest import container_workspace_root


@pytest.mark.parametrize(
    "dep",
    [
        "git --version",
        "tar --version",
        "make --version",
        "asdf --version",
        "docker --version",
        "docker buildx version",
        "docker compose version",
    ],
    scope="session",
)
def test_infra(dep, assertCommand):
    assertCommand(dep)

@pytest.mark.parametrize(
    "dep",
    [
        f"cat {container_workspace_root}/.tool-versions",
        "/resources/scripts/startup/init",
        "python --version",
        "go version",
        "node --version",
        "aws --version",
        "terraform --version"
    ],
    scope="session",
)
def test_init(dep, assertCommand):
    assertCommand(dep)
