class puppetdb_gc (
  Enum['absent', 'present'] $puppetdb_gc_cron_ensure = 'present',
) {

  puppetdb_gc::gc_cron { 'expire_nodes' :
    gc_cron_ensure => $puppetdb_gc_cron_ensure,
    cron_minute    => 3,
  }

  puppetdb_gc::gc_cron { 'purge_nodes' :
    gc_cron_ensure => $puppetdb_gc_cron_ensure,
    cron_minute    => 5,
  }

  puppetdb_gc::gc_cron { 'purge_reports' :
    gc_cron_ensure => $puppetdb_gc_cron_ensure,
    cron_minute    => [0,15,30,45],
  }

  puppetdb_gc::gc_cron { 'other' :
    gc_cron_ensure => $puppetdb_gc_cron_ensure,
    cron_minute    => 55,
    cron_day       => 20,
  }

}
