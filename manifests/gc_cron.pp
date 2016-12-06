define puppetdb_gc::gc_cron (
  Enum['absent', 'present'] $gc_cron_ensure = 'present',
  String                    $puppetdb_host  = $fqdn,
  Integer                   $puppetdb_port  = 8081,
  String                    $api_command    = 'clean',
  Integer                   $api_version    = 1,
  String                    $api_payload    = $title,
  Optional[Variant[Integer, Array[Integer]]] $cron_minute = undef,
  Optional[Variant[Integer, Array[Integer]]] $cron_hour   = undef,
  Optional[Variant[Integer, Array[Integer]]] $cron_day    = undef,
  String                    $postgresql_host = $puppetdb_host,
)
{

  cron { "puppet_db_gc_${title}" :
      ensure  => $gc_cron_ensure,
      command => epp( 'puppetdb_gc/puppetdb_cmd_curl.epp',
                    { puppetdb_host => $puppetdb_host,
                      puppetdb_port => $puppetdb_port,
                      api_command   => $api_command,
                      api_version   => $api_version,
                      api_payload   => $api_payload,
                      postgresql_host => $postgresql_host,
                    } ),
      user     => 'root',
      minute   => $cron_minute,
      hour     => $cron_hour,
      monthday => $cron_day,
    }

}
