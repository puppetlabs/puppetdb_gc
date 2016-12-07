class puppetdb_gc (
  Enum['absent', 'present'] $puppetdb_gc_cron_ensure = 'present',
  Boolean                   $use_ssl                 = true,
  String                    $puppetdb_host           = $use_ssl ? {
                                                         true  => $fqdn,
                                                         false => '127.0.0.1',
                                                       },
  Integer                   $puppetdb_port           = $use_ssl ? {
                                                         true  => 8081,
                                                         false => 8080,
                                                       },
  String                    $postgresql_host         = $puppetdb_host,
  Puppetdb_gc::Cron_schedule $expire_nodes_schedule  = { 'minute' => 3 },
  Puppetdb_gc::Cron_schedule $purge_nodes_schedule   = { 'minute' => 5 },
  Puppetdb_gc::Cron_schedule $purge_reports_schedule = { 'minute' => [0,15,30,45] },
  Puppetdb_gc::Cron_schedule $other_schedule         = { 'minute'   => 55,
                                                         'hour'     => 0,
                                                         'monthday' => 20, },
) {

  Puppetdb_gc::Gc_cron {
    gc_cron_ensure  => $puppetdb_gc_cron_ensure,
    use_ssl         => $use_ssl,
    puppetdb_host   => $puppetdb_host,
    puppetdb_port   => $puppetdb_port,
    postgresql_host => $postgresql_host
  }

  puppetdb_gc::gc_cron { 'expire_nodes' :
    schedule => $expire_nodes_schedule,
  }

  puppetdb_gc::gc_cron { 'purge_nodes' :
    schedule => $purge_nodes_schedule,
  }

  puppetdb_gc::gc_cron { 'purge_reports' :
    schedule => $purge_reports_schedule,
  }

  puppetdb_gc::gc_cron { 'other' :
    schedule => $other_schedule,
  }

}
