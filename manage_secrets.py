#!/usr/bin/env python3
"""
Update Kubernetes secret file

Requirement:
Python >~ 3
Ansible ~> 2
"ansible-vault" password file placed in home directory of the user executing the script named "ansible-vault"

Usage
./manage_secrets.py --key <secret_key> --value <secret_value> --service <service_name> [--existing]

How it works
1. If its a new service, it will create a secrets.yaml with secrets (key: value(in base64)) file in the service location
2. If the service already exist, and "--existing" is passed, it will check:
    a. if the secret already exist, if yes update the encdid value.
    b. if the secret is new, add the secret in secret.yaml file
3. Do the ansible encyption/decryption on the fly.

NOTE: Save "ansible-vault" password in the home location of current user.

To Do:
Add encyption/decryption utility from .gitarrtributes using git-crypt

"""

import argparse
import yaml
import base64
import logging
import os

def create_secrets(key, value, service, file):

    dict_file = {'apiVersion':'v1', 'kind':'Secret', 'metadata': {'name': service}, 'type':'opaque', 'data': {key:value}}

    try:
        with open(file, 'w') as f:
            yaml.safe_dump(dict_file, f, default_flow_style=False, sort_keys=False)
    except (IOError, ValueError, OSError) as e:
        logging.error("Service or location not found: ", e)

def update_secrets(key, value, file):
    newSecrets = {key : value}

    try:
        with open(file) as f:
            document = yaml.safe_load(f)
    except FileNotFoundError as e:
        logging.error(e)

    if key in document['data']:
        document['data'][key] = value
    else:
        document['data'].update(newSecrets)

    try:
        with open(file, 'w') as wf:
            yaml.safe_dump(document, wf, default_flow_style=False, sort_keys=False)
    except FileNotFoundError as e:
        logging.error(e)

if __name__ == "__main__":

    argparser = argparse.ArgumentParser(description='Manages Kubernetes Secrets')
    argparser.add_argument('--key', '-k', required=True, help='Secret Key')
    argparser.add_argument('--value', '-v', required=True, help='Secret Value')
    argparser.add_argument('--service', '-s', required=True, help='Name of the service')
    argparser.add_argument('--existing', action="store_true", help='Whether to create a new secret')
    args = argparser.parse_args()

    FILE = "helm/charts/" + args.service + "/templates/secrets.yaml"
    ENCODEDVALUE = base64.b64encode(args.value.encode('ascii'))

    if args.existing and os.path.isfile(FILE):
        os.system("ansible-vault decrypt --vault-password-file ~/ansible-vault {}".format(FILE))
        update_secrets(args.key, ENCODEDVALUE.decode('ascii'), FILE)
        os.system("ansible-vault encrypt --vault-password-file ~/ansible-vault {}".format(FILE))
    else:
        if os.path.isdir("helm/charts/" + args.service):
            create_secrets(args.key, ENCODEDVALUE.decode('ascii'), args.service, FILE)
            os.system("ansible-vault encrypt --vault-password-file ~/ansible-vault {}".format(FILE))
        else:
            print("Helm chart for %s does not exist" % args.service)
