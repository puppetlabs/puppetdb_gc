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
) {

  Puppetdb_gc::Gc_cron {
    gc_cron_ensure  => $puppetdb_gc_cron_ensure,
    use_ssl         => $use_ssl,
    puppetdb_host   => $puppetdb_host,
    puppetdb_port   => $puppetdb_port,
    postgresql_host => $postgresql_host
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

  #this is GC for a PE only feature
  if versioncmp( pick( $facts['pe_server_version'], '0.0.0'), '2017.2.0' ) >= 0 {
    puppetdb_gc::gc_cron { 'gc_packages' :
      cron_minute    => 50,
      cron_hour      => 0,
      cron_day       => 10,
    }
  }
}
