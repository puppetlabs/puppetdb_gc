class puppetdb_gc (
  Enum['absent', 'present'] $puppetdb_gc_cron_ensure = 'present',
  String                    $puppetdb_host           = $fqdn,
  Integer                   $puppetdb_port           = 8081,
) {

  Puppetdb_gc::Gc_cron {
    gc_cron_ensure => $puppetdb_gc_cron_ensure,
    puppetdb_host  => $puppetdb_host,
    puppetdb_port  => $puppetdb_port,
  }

  puppetdb_gc::gc_cron { 'expire_nodes' :
    cron_minute    => 3,
  }

  puppetdb_gc::gc_cron { 'purge_nodes' :
    cron_minute    => 5,
  }

  puppetdb_gc::gc_cron { 'purge_reports' :
    cron_minute    => [0,15,30,45],
  }

  puppetdb_gc::gc_cron { 'other' :
    cron_minute    => 55,
    cron_hour      => 0,
    cron_day       => 20,
  }

}
