Table of Contents
=================

* [Overview](#overview)
  * [Usage](#usage)
  * [Reference](#reference)

# Overview

This module provides PuppetDB garbage collection of PostgreSQL data via cron.

> This module is maintained by Puppet, but we have no plans for future feature development. We will keep it working with current versions of Puppet, but new feature development will come from community contributions. It does not qualify for Puppet Support plans.
>
> [tier:maintenance-mode]

## Usage

Disable the internal garbage collection performed by the PuppetDB service via `gc-interval` on all of your PuppetDB nodes.
In PE, do that by setting the following in Hiera.

```yaml
---
puppet_enterprise::profile::puppetdb::gc_interval: 0
```

Classify the node running PuppetDB with the `puppetdb_gc` class.
That node is the Primary Master in a Monolithic installation, or the PE PuppetDB host in a Split install.  

```
include puppetdb_gc
```

> Note: If you setup PE HA, you should `include puppetdb_gc` on both the Primary Master and the Replica.
This is because PuppetDB Sync does not sync deletions, so garbage collection needs to be performed on both the Primary Master and the Replica.  

### What you get

```bash
puppet apply -e "include puppetdb_gc"

Notice: Compiled catalog for c02n54lfg3qd in environment production in 0.21 seconds
Notice: /Stage[main]/puppetdb_gc/puppetdb_gc::Gc_cron[expire_nodes]/Cron[puppet_db_gc_expire_nodes]/ensure: created
Notice: /Stage[main]/puppetdb_gc/puppetdb_gc::Gc_cron[purge_nodes]/Cron[puppet_db_gc_purge_nodes]/ensure: created
Notice: /Stage[main]/puppetdb_gc/puppetdb_gc::Gc_cron[purge_reports]/Cron[puppet_db_gc_purge_reports]/ensure: created
Notice: /Stage[main]/puppetdb_gc/puppetdb_gc::Gc_cron[other]/Cron[puppet_db_gc_other]/ensure: created
Notice: Applied catalog in 0.10 seconds
```

```bash
crontab -l -u root

# Puppet Name: puppet_db_gc_expire_nodes
1 * * * * curl -X POST http://127.0.0.1:8080/pdb/admin/v1/cmd -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"command": "clean", "version": 1, "payload": ["expire_nodes"] }'
# Puppet Name: puppet_db_gc_purge_nodes
5 * * * * curl -X POST http://127.0.0.1:8080/pdb/admin/v1/cmd -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"command": "clean", "version": 1, "payload": ["purge_nodes"] }'
# Puppet Name: puppet_db_gc_purge_reports
15,45 * * * * curl -X POST http://127.0.0.1:8080/pdb/admin/v1/cmd -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"command": "clean", "version": 1, "payload": ["purge_reports"] }'
# Puppet Name: puppet_db_gc_other
55 0 20 * * curl -X POST http://127.0.0.1:8080/pdb/admin/v1/cmd -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"command": "clean", "version": 1, "payload": ["other"] }'
```

## Reference

The standard usage of this module is to include the main class which will add all of the GC cron tab entries with the default schedules.

```
include puppetdb_gc
```

Additional parameters exist to configure how the module interacts with PuppetDB as well as individual job configuration.

**puppetdb_gc_cron_ensure** Ensure the presence of the GC cron tab entries. Allows for `absent` and `present`. Defaults to `present`

**expire_nodes_cron** Configuration settings for the `expire_nodes` cron tab entry. Allows for a hash of parameters for `puppetdb_gc::gc_cron`. Defaults to `{ cron_minute => 3 }`

**purge_nodes_cron** Configuration settings for the `purge_nodes` cron tab entry. Allows for a hash of parameters for `puppetdb_gc::gc_cron`. Defaults to `{ cron_minute => 5 }`

**purge_reports_cron** Configuration settings for the `purge_reports` cron tab entry. Allows for a hash of parameters for `puppetdb_gc::gc_cron`. Defaults to `{cron_minute => 55,vacuum_reports => false}`

**other_cron** Configuration settings for the `other` cron tab entry. Allows for a hash of parameters for `puppetdb_gc::gc_cron`. Defaults to `{cron_minute => 55,cron_hour => 0,cron_day => absent}`

**gc_packages_cron** Configuration settings for the `gc_packages` cron tab entry. Allows for a hash of parameters for `puppetdb_gc::gc_cron`. Defaults to `{cron_minute => 50,cron_hour => 0,cron_day => absent}`

### PuppetDB GC Interval

https://puppet.com/docs/puppetdb/latest/configure.html#gc-interval

### PuppetDB GC Admin API Documentation

https://docs.puppet.com/puppetdb/latest/api/admin/v1/cmd.html#post-pdbadminv1cmd
