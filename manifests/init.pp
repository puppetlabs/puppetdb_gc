class pe_puppetdb_gc (
  Enum['absent', 'present'] $puppetdb_gc_cron_ensure = 'present',
) {

  pe_puppetdb_gc::gc_cron { 'expire_nodes' :
    gc_cron_ensure => $puppetdb_gc_cron_ensure,
    cron_minute    => 1,
  }

  pe_puppetdb_gc::gc_cron { 'purge_nodes' :
    gc_cron_ensure => $puppetdb_gc_cron_ensure,
    cron_minute    => 5,
  }

  pe_puppetdb_gc::gc_cron { 'purge_reports' :
    gc_cron_ensure => $puppetdb_gc_cron_ensure,
    cron_minute    => [15,45],
  }

  pe_puppetdb_gc::gc_cron { 'other' :
    gc_cron_ensure => $puppetdb_gc_cron_ensure,
    cron_minute    => 55,
    cron_day       => 20,
  }

}
