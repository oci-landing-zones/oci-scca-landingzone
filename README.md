# SCCA Landing Zone

Oracle Cloud Infrastructure (OCI) has introduced a new Secure Cloud Computing Architecture (SCCA) for the U.S. Department of Defense (DoD). The solution helps make security compliance and cloud adoption for mission-critical workloads easier, faster, and more cost effective by using a framework of cloud native services.

SCCA is a [DoD security framework](https://www.disa.mil/-/media/Files/DISA/Fact-Sheets/071822-D-LLNNN-1001-Secure-Cloud-Computing-Architecture.ashx) designed to provide a standard approach for boundary and application-level security for the Defense Information Systems Agency (DISA) Impact Level 4 and 5 data hosted in commercial cloud environments. Historically, SCCA compliance has required significant investment from DoD mission owners in the form of independent development efforts and third-party software licensing. The cost and time result in a significant challenge during cloud migrations.

Oracle Cloud Native SCCA Landing Zone provides a framework for securely running DoD mission workloads and storing Impact Level 2, 4, and 5 data in OCI government regions. The automation provided by the solution enables DoD mission owners to establish a compliant security architecture in just a few hours or days, instead of months. It uses cloud native infrastructure services, significantly accelerating the time to deployment of mission critical workloads by reducing architecture time and minimizing decision points.

Access the Administrator Guide [here](https://www.oracle.com/a/ocom/docs/industries/public-sector/oci-scca-architecture-guide.pdf) to review prerequisites and more details.

Read more about SCCA on Oracle Cloud [here](https://www.oracle.com/government/federal/dod-scca/)

## Testing Locally
install the dependencies in a virtual enviroment
```bash
python -m venv scca-venv
. scca-venv/bin/activate
pip install -r test/requirements.txt
```

run the tests
```
pytest -v -k terraform test
```


## Style

### Locals
* Locals exist to reduce duplication and preform computations and transformation on inputs. 
* Name local vars after the module it is used by and each variable by the corresponding module input 
* Minimize data in locals - it further abstracts and convolutes the flow. This means using module outputs directly in module call rather than copying them into locals (exception being if you are tranforming the output).
* Default values that are not user inputs can be hardcoded into the module call.
* Locals and module calls do not need to be generic or dynamic - you can hardcode and reference any value.

### Modules
- Modules are used to create lightweight abstractions, so that you can describe your infrastructure in terms of its architecture. Do not use modules as thin wrappers - put multiple resources in a modules to form a logical unit.
- It is better to create nested structures in the locals and loop in the module call rather than looping in the module itself.
- Nested resources are looped over in the module and require nested locals but this is still better than creating a seperate module for the single nested resource (eg. subnets)
