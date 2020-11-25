# @summary Manage PuppetDB (PostgreSQL data) garbage collection
#
# Manage PuppetDB (PostgreSQL data) garbage collection
#
# @example
#   include puppetdb_gc
class puppetdb_gc (
  Enum['absent', 'present'] $puppetdb_gc_cron_ensure = 'present',
  Boolean                   $use_ssl                 = true,
  String                    $puppetdb_host           = $use_ssl ? {
                                                          true  => $facts['networking']['fqdn'],
                                                          false => '127.0.0.1',
                                                        },
  Integer                   $puppetdb_port           = $use_ssl ? {
                                                          true  => 8081,
                                                          false => 8080,
                                                        },
  String                    $postgresql_host         = $puppetdb_host,
  Boolean                   $vacuum_reports          = false,
  Hash                      $expire_nodes_cron       = { cron_minute => 3 },
  Hash                      $purge_nodes_cron        = { cron_minute => 5 },
  Hash                      $purge_reports_cron      =  {
                                                          cron_minute    => [0,15,30,45],
                                                          vacuum_reports => $vacuum_reports
                                                        },
  Hash                      $other_cron              =  {
                                                          cron_minute => 55,
                                                          cron_hour   => 0,
                                                          cron_day    => absent
                                                        },
  Hash                     $gc_packages_cron         =  {
                                                          cron_minute => 50,
                                                          cron_hour   => 0,
                                                          cron_day    => absent
                                                        },
) {

  Puppetdb_gc::Gc_cron {
    gc_cron_ensure  => $puppetdb_gc_cron_ensure,
    use_ssl         => $use_ssl,
    puppetdb_host   => $puppetdb_host,
    puppetdb_port   => $puppetdb_port,
    postgresql_host => $postgresql_host
  }

  puppetdb_gc::gc_cron { 'expire_nodes' :
    * => $expire_nodes_cron,
  }

  puppetdb_gc::gc_cron { 'purge_nodes' :
    * => $purge_nodes_cron,
  }

  puppetdb_gc::gc_cron { 'purge_reports' :
    * => $purge_reports_cron,
  }

  puppetdb_gc::gc_cron { 'other' :
    * => $other_cron,
  }

  # This data for a feature specific to PE.
  if versioncmp(pick($facts['pe_server_version'], '0.0.0'), '2017.2.0') >= 0 {
    puppetdb_gc::gc_cron { 'gc_packages' :
      * => $gc_packages_cron,
    }
  }
}
