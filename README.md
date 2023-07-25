# SCCA Landing Zone

SCCA Landing Zone repo

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
