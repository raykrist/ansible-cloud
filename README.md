# ansible-cloud
Personal ansible setup to manage cloud instances

## Install

Install ansible and run:
```
ansible-galaxy install -r requirements.yaml
```

## Usage

First edit `group_vars/all.yaml` and other group files.

To use with cloud instances without DNS make sure to add

* `ansible_host`
* `ansible_user`

to `inventory` or `host_vars/`
