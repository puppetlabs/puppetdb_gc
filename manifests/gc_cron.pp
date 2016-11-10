define pe_puppetdb_gc::gc_cron (
  String        $puppetdb_host = '127.0.0.1',
  Integer       $puppetdb_port = 8080,
  String        $api_command   = 'clean',
  Integer       $api_version   = 1,
  Array[String] $api_payload,
  Optional[Variant[Integer, Array[Integer]]] $cron_minute = undef,
  Optional[Variant[Integer, Array[Integer]]] $cron_hour   = undef,
  Optional[Variant[Integer, Array[Integer]]] $cron_day    = undef,
)
{

  cron { "puppet_db_gc_${title}" :
      ensure  => present,
      command => epp( 'pe_puppetdb_gc/puppetdb_cmd_curl.epp',
                    { puppetdb_host => $puppetdb_host,
                      puppetdb_port => $puppetdb_port,
                      api_command   => $api_command,
                      api_version   => $api_version,
                      api_payload   => $api_payload,
                    } ),
      user     => 'root',
      minute   => $cron_minute,
      hour     => $cron_hour,
      monthday => $cron_day,
    }

}
