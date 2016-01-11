#!/usr/bin/env python

'''
Dynamic inventory of libvirt script for Ansible, in Python.
'''

import sys
import argparse
import libvirt

try:
    import json
except ImportError:
    import simplejson as json

class LibvirtInventory(object):

    def __init__(self):
        self.inventory = {'_meta': {'hostvars': {}}}
        self.read_cli_args()
        self.conn = libvirt.open()
        if self.conn == None:
            print 'Failed to connect to hypervisor'
            sys.exit(1)

        # Called with `--list`.
        if self.args.list:
            self.inventory = self.get_inv()
        # Called with `--host [hostname]`.
        elif self.args.host:
            self.inventory = self.inventory

        print json.dumps(self.inventory);

    def get_inv(self):

        domains = self.conn.listDomainsID()
        if len(domains) == 0:
            return self.inventory
        else:
            return self.get_domains(domains)


    def get_domains(self, domains):
        for dom in domains:
            domain = self.conn.lookupByID(dom)
            try:
                dom_inv = json.loads(domain.metadata(0, None))
            except (ValueError,libvirt.libvirtError):
                dom_inv = {}
            finally:
                if 'groups' in dom_inv:
                    for group in dom_inv['groups']:
                        if group in self.inventory:
                            self.inventory[group]['hosts'].append(domain.name())
                        else:
                            self.inventory.update({group: {'hosts': [domain.name()]}})
                dom_host_vars = {}
                dom_host_vars['ansible_ssh_user'] = 'root'
                try:
                    dom_ifaces = domain.interfaceAddresses(libvirt.VIR_DOMAIN_INTERFACE_ADDRESSES_SRC_AGENT)
                    if dom_ifaces != None:
                        for iface in dom_ifaces:
                            if iface == 'lo':
                                continue
                            for addr in dom_ifaces[iface]['addrs']:
                                if addr['type'] == 0:
                                    dom_host_vars['ansible_ssh_host'] =  addr['addr']
                except (TypeError,libvirt.libvirtError):
                    pass
                if 'hostvars' in dom_inv:
                    dom_host_vars.update(dom_inv['hostvars'])
                self.inventory['_meta']['hostvars'].update({domain.name(): dom_host_vars })
        return self.inventory

    # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action = 'store_true')
        parser.add_argument('--host', action = 'store')
        self.args = parser.parse_args()

# Get the inventory.
LibvirtInventory()
