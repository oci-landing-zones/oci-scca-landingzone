import hcl2
from pathlib import Path
import pytest
from pytest_terraform import terraform

# VDSS
@pytest.mark.unit
@terraform("network", scope="session")
def test_vdss_vcn_display_name(network):
    tfvar_path = Path(__file__).parent.absolute() / 'terraform/network/terraform.tfvars'
    with open(tfvar_path) as f:
        tfvars = hcl2.load(f)

    expected_vdss_vcn_display_name = tfvars["vdss_vcn_display_name"]
    actual_vdss_vcn_display_name = network["oci_core_vcn.vcn.display_name"]
    assert expected_vdss_vcn_display_name == actual_vdss_vcn_display_name

@pytest.mark.unit
@terraform("network", scope="session")
def test_vdss_vcn_cidr_block(network):
    tfvar_path = Path(__file__).parent.absolute() / 'terraform/network/terraform.tfvars'
    with open(tfvar_path) as f:
        tfvars = hcl2.load(f)

    expected_vdss_vcn_cidr_block = tfvars["vdss_cidr_block"]
    actual_vdss_vcn_cidr_block = network["oci_core_vcn.vcn.cidr_block"]
    assert expected_vdss_vcn_cidr_block == actual_vdss_vcn_cidr_block

@pytest.mark.unit
@terraform("network", scope="session")
def test_vdss_vcn_dns_label(network):
    tfvar_path = Path(__file__).parent.absolute() / 'terraform/network/terraform.tfvars'
    with open(tfvar_path) as f:
        tfvars = hcl2.load(f)

    expected_vdss_vcn_dns_label = tfvars["vdss_dns_label"]
    actual_vdss_vcn_dns_label = network["oci_core_vcn.vcn.dns_label"]
    assert expected_vdss_vcn_dns_label == actual_vdss_vcn_dns_label

# TODO: Subnet test

# VDMS
@pytest.mark.unit
@terraform("network", scope="session")
def test_vdms_vcn_display_name(network):
    tfvar_path = Path(__file__).parent.absolute() / 'terraform/network/terraform.tfvars'
    with open(tfvar_path) as f:
        tfvars = hcl2.load(f)

    expected_vdms_vcn_display_name = tfvars["vdms_vcn_display_name"]
    actual_vdms_vcn_display_name = network["oci_core_vcn.vcn.display_name"]
    assert expected_vdms_vcn_display_name == actual_vdms_vcn_display_name

@pytest.mark.unit
@terraform("network", scope="session")
def test_vdms_vcn_cidr_block(network):
    tfvar_path = Path(__file__).parent.absolute() / 'terraform/network/terraform.tfvars'
    with open(tfvar_path) as f:
        tfvars = hcl2.load(f)

    expected_vdms_vcn_cidr_block = tfvars["vdms_cidr_block"]
    actual_vdss_vcn_cidr_block = network["oci_core_vcn.vcn.cidr_block"]
    assert expected_vdms_vcn_cidr_block == actual_vdss_vcn_cidr_block

@pytest.mark.unit
@terraform("network", scope="session")
def test_vdss_vcn_dns_label(network):
    tfvar_path = Path(__file__).parent.absolute() / 'terraform/network/terraform.tfvars'
    with open(tfvar_path) as f:
        tfvars = hcl2.load(f)

    expected_vdss_vcn_dns_label = tfvars["vdms_dns_label"]
    actual_vdss_vcn_dns_label = network["oci_core_vcn.vcn.dns_label"]
    assert expected_vdss_vcn_dns_label == actual_vdss_vcn_dns_label

# TODO: Subnet test

@pytest.mark.integration
@terraform("network_2", scope="session")
def test_vdss_vcn_dns_label(network_2):

    assert True