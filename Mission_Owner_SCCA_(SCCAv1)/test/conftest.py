import pytest

@pytest.fixture(scope='session', autouse=True)
def session_setup_teardown():
    # setup code goes here if needed
    # copy common files to ./terraform/ subfolders

    yield
    # cleanup common files
