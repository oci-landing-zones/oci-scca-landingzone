import hcl2
from pathlib import Path
import pytest
from pytest_terraform import terraform

@pytest.mark.skip(reason="Compartment delete not working consistently")
@pytest.mark.unit
@terraform("compartment", scope="session")
def test_parent_compartment_name(compartment):
    tfvar_path = Path(__file__).parent.absolute() / 'terraform/compartment/terraform.tfvars'
    with open(tfvar_path) as f:
        tfvars = hcl2.load(f)

    expected_compartment_name = tfvars["compartment_name"]
    actual_compartment_name = compartment["oci_identity_compartment.compartment.name"]
    assert expected_compartment_name == actual_compartment_name
