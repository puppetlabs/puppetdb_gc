define puppetdb_gc::gc_cron (
  Enum['absent', 'present'] $gc_cron_ensure = 'present',
  String                    $puppetdb_host  = '127.0.0.1',
  Integer                   $puppetdb_port  = 8080,
  String                    $api_command    = 'clean',
  Integer                   $api_version    = 1,
  String                    $api_payload    = $title,
  Hash                      $cron_schedule,
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
                    } ),
      user     => 'root',
      *        => $cron_schedule,
    }

}
