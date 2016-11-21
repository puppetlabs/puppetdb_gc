class puppetdb_gc (
  Enum['absent', 'present'] $puppetdb_gc_cron_ensure     = 'present',
  Array[Puppetdb_gc::Gc_api_payload_and_schedule] $gc_api_payload_and_schedule =
  [
    {
      'gc_api_payload' => 'expire_nodes',
      'schedule'       => { 'minute' => 3 },
    },
    {
      'gc_api_payload' => 'purge_nodes',
      'schedule'       => { 'minute' => 5 },
    },
    {
      'gc_api_payload' => 'purge_reports',
      'schedule'       => { 'minute' => [0,15,30,45], }
    },
    {
      'gc_api_payload' => 'other',
      'schedule'       => { 'minute'   => 55,
                            'monthday' => 20, }
    },
  ]
) {

  $gc_api_payload_and_schedule.each | Hash $gc_api_payload_and_schedule | {

    $gc_api_payload = $gc_api_payload_and_schedule['gc_api_payload']
    $schedule       = $gc_api_payload_and_schedule['schedule']

    puppetdb_gc::gc_cron { $gc_api_payload :
      gc_cron_ensure => $puppetdb_gc_cron_ensure,
      cron_schedule  => $schedule,
    }
  }
}
