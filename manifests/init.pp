class pe_puppetdb_gc (
) {

  pe_puppetdb_gc::gc_cron { 'expire_nodes' :
    api_payload => 'expire_nodes',
    cron_minute => 1,
  }

  pe_puppetdb_gc::gc_cron { 'purge_nodes' :
    api_payload => 'purge_nodes',
    cron_minute => 5,
  }

  pe_puppetdb_gc::gc_cron { 'purge_reports' :
    api_payload => 'purge_nodes',
    cron_minute => [15,45],
  }

  pe_puppetdb_gc::gc_cron { 'other' :
    api_payload => 'other',
    cron_minute => 55,
    cron_day    => 20,
  }

}
