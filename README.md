# Deep Security and Workload Security with Ansible<!-- omit in toc -->

- [Objective](#objective)
  - [Deploy DSA](#deploy-dsa)
  - [Module Demos](#module-demos)
- [Support](#support)
- [Contribute](#contribute)

## Objective

This repo does contain some Ansible playbooks and modules to ease handling Deep- or Workload Security with the use of Ansible.

> ***Note:*** Take these playbooks and scripts as proofs-of-concept, not to be used in production. Adapt them to your needs, e.g. integrate approval workflows before assigning rules to a policy.

### Deploy DSA

The playbook `deploy_dsa.yaml` allows you to deploy the Deep Security Agent on Linux and Windows platforms. A sample hosts.yaml is provided.

Within the `vars`-directory are three yaml files. Within the `vars.yml` you need to define if you're using a Deep Security or Workload Security environment. Set the variable to either `dsm` or `ws`. Depending on your environment you need to define the variables within the files `vars_dsm.yml` or `vars_ws.yaml`. In a real environment these variables should be set as secrets, of course.

Run it with

```sh
ansible-playbook ds_deploy_dsa.yaml
```

To query the status of Linux DSAs a custom fact is provided. Query it with

```sh
ansible labenv -m setup -a "filter=ansible_local"
```

```json
ubuntudev | SUCCESS => {
    "ansible_facts": {
        "ansible_local": {
            "dsa_status": {
                "Component.AM.cap.Qrestore": "true",
                "Component.AM.cap.realtime": "true",
                "Component.AM.cap.spyware": "false",
                "Component.AM.configurations": "3",
                "Component.AM.driverOffline": "false",
                "Component.AM.licenseExpiry": "1686780000",
                "Component.AM.mode": "on",
                "Component.AM.moduleStatus": "0",
                "Component.AM.scan.Manual": "2",
                "Component.AM.scan.Quick": "2",
                "Component.AM.scan.Realtime": "1",
                "Component.AM.scan.Scheduled": "3",
                "Component.AM.scanStatus": "4",
                "Component.AM.scanType": "0",
                "Component.AM.version.engine.ATSE": "21.600.1005",
                "Component.AM.version.pattern.1.name": "Trusted Certificate Authorities Pattern",
                "Component.AM.version.pattern.1.version": "1.00007.00",
                "Component.AM.version.pattern.2.name": "Advanced Threat Correlation Pattern",
                "Component.AM.version.pattern.2.version": "1.276.00",
                "Component.AM.version.pattern.3.name": "IntelliTrap Exception Pattern",
                "Component.AM.version.pattern.3.version": "2.133.00",
                "Component.AM.version.pattern.4.name": "Smart Scan Agent Pattern",
                "Component.AM.version.pattern.4.version": "18.489.00",
                "Component.AM.version.pattern.5.name": "IntelliTrap Pattern",
                "Component.AM.version.pattern.5.version": "0.253.00",
                "Component.AM.version.pattern.6.name": "Behavior Monitoring Event Filtering Pattern",
                "Component.AM.version.pattern.6.version": "1.2.1503",
                "Component.CORE.version": "12.5",
                "Component.FWDPI.dpiRules": "10",
                "Component.FWDPI.driverState": "7",
                "Component.FWDPI.firewallMode": "on-prevent",
                "Component.FWDPI.firewallRules": "17",
                "Component.FWDPI.mode": "on-prevent",
                "Component.FWDPI.statefulRules": "1",
                "Component.IM.eventMode": "1",
                "Component.IM.highestEntityId": "5093",
                "Component.IM.imCapabilityMask": "3",
                "Component.IM.imScanType": "0",
                "Component.IM.mode": "on",
                "Component.IM.pendingScanBitmask": "0",
                "Component.IM.percentComplete": "0",
                "Component.IM.rules": "52",
                "Component.IM.scanStatus": "4",
                "Component.IM.scanType": "1",
                "Component.LI.decoders": "1",
                "Component.LI.mode": "on",
                "Component.LI.rules": "3",
                "Component.WRS.mode": "off"
            }
        },
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false
}
```

### Module Demos

Next to the `ds_deploy_dsa.yaml`-playbook there are Ansible Playbooks, which either query information of or modify computer instances within Deep- or Workload Security. They utilize modules located within the `library` folder.

Currently, the following demos are available:

- `ds_computer_cve_protection.yml` - Ensures protection against a specific CVE on a named computer.
- `ds_computers_cve_protection.yml` - Ensures protection against a specific CVE on all computers.
- `ds_protection_status.yml` - Returns CVE protection status for a named computer.
- `ds_protection_status_all.yml` - Returns CVE protection status for all computers.
- `ds_query_cve.yml` - Queries IPS rules available for a CVE.
- `ds_query_cves.yml` - Queries IPS rules available for a list of CVEs.
- `ds_rule_review_assignment.yml` - Queries for unassigned IPS rules which are recommended to be assigned.
- `ds_computer_create.yml` - Creates a computer object.
- `ds_computer_delete.yml` - Deletes a computer object.

***Examples:***

*Query Protection Status of a Computer:*

```sh
ansible-playbook ds_protection_status.yml --extra-vars "dsm_url=<DSM_URL> api_key=<API KEY> hostname=ubuntudev.localdomain"
```

```sh
PLAY [localhost] *********************************************************************************************************************************************************************

TASK [Query Deep Security Protection Status] *****************************************************************************************************************************************
ok: [localhost]

TASK [Print result] ******************************************************************************************************************************************************************
ok: [localhost] => 
  msg:
    cves_covered:
    - CVE-2014-3568
    - CVE-2015-0138
    - CVE-2015-1637
    - CVE-2015-4000
    - CVE-2014-3566
    - CVE-2015-0204
    - CVE-2015-1716
    rules_covering:
    - '1006561'
    - '1006740'
    - '1006296'

PLAY RECAP ***************************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

*Query IPS rule(s) for a given CVE:*

```sh
ansible-playbook ds_query_cve.yml --extra-vars "dsm_url=<DSM_URL> api_key=<API KEY> query=CVE-2023-25690"
```

```sh
PLAY [localhost] *********************************************************************************************************************************************************************

TASK [Query Deep Security for CVE covering IPS rules] ********************************************************************************************************************************
ok: [localhost]

TASK [Print result] ******************************************************************************************************************************************************************
ok: [localhost] => 
  msg:
    matched: true
    rules_covering:
    - '1011750'

PLAY RECAP ***************************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

*Ensure computer is protected against a specific CVE:*

```sh
ansible-playbook ds_computer_cve_protection.yml --extra-vars 'dsm_url=<DSM_URL> api_key=<API-KEY> hostname=ubuntudev.localdomain query=CVE-2023-24941}
````

```sh
PLAY [localhost] *********************************************************************************************************************************************************************

TASK [Query Deep Security for CVE covering IPS rules] ********************************************************************************************************************************
ok: [localhost]

TASK [Print result] ******************************************************************************************************************************************************************
ok: [localhost] => 
  msg:
    matched: true
    rules_covering:
    - '1011740'

TASK [Ensure that Computer Object in Deep Security is protected] *********************************************************************************************************************
changed: [localhost] => (item=1011740)

PLAY RECAP ***************************************************************************************************************************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

## Support

This is an Open Source community project. Project contributors may be able to help, depending on their time and availability. Please be specific about what you're trying to do, your system, and steps to reproduce the problem.

For bug reports or feature requests, please [open an issue](../../issues). You are welcome to [contribute](#contribute).

Official support from Trend Micro is not available. Individual contributors may be Trend Micro employees, but are not official support.

## Contribute

I do accept contributions from the community. To submit changes:

1. Fork this repository.
1. Create a new feature branch.
1. Make your changes.
1. Submit a pull request with an explanation of your changes or additions.

I will review and work with you to release the code.
