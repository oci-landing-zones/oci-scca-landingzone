import pytest
from pytest_terraform import terraform


@pytest.mark.integration
@terraform("main", scope="session")
def test_all(main):
    print("TEST WORKING")
    assert True
