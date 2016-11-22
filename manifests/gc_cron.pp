define puppetdb_gc::gc_cron (
  Enum['absent', 'present']  $gc_cron_ensure = 'present',
  String                     $puppetdb_host  = '127.0.0.1',
  Integer                    $puppetdb_port  = 8080,
  String                     $api_command    = 'clean',
  Integer                    $api_version    = 1,
  Variant[String,Array[String]] $api_payload = $title,
  Puppetdb_gc::Cron_schedule $cron_schedule,
)
{

  $_api_payload_formatted = type_of($api_payload) ? {
    Array[String] => join($api_payload, ' "],[ "'),
    String        => $api_payload,
  }
  $_api_payload = '[ "' + $_api_payload_formatted + '" ]'

  cron { "puppet_db_gc_${title}" :
      ensure  => $gc_cron_ensure,
      command => epp( 'puppetdb_gc/puppetdb_cmd_curl.epp',
                    { puppetdb_host => $puppetdb_host,
                      puppetdb_port => $puppetdb_port,
                      api_command   => $api_command,
                      api_version   => $api_version,
                      api_payload   => $_api_payload,
                    } ),
      user    => 'root',
      *       => $cron_schedule,
    }

}
