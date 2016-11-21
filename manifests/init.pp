class puppetdb_gc (
  Enum['absent', 'present']         $puppetdb_gc_cron_ensure     = 'present',
  Array[Puppetdb_gc::Gc_type_and_schedule] $gc_type_and_schedule =
  [
    {
      'gc_type'  => 'expire_nodes',
      'schedule' => { 'minute' => 3 },
    },
    {
      'gc_type'  => 'purge_nodes',
      'schedule' => { 'minute' => 5 },
    },
    {
      'gc_type'  => 'purge_reports',
      'schedule' => { 'minute' => [0,15,30,45], }
    },
    {
      'gc_type'  => 'other',
      'schedule' => { 'minute'   => 55,
                      'monthday' => 20, }
    },
  ]
) {

  $gc_type_and_schedule.each | Hash $gc_type_and_schedule | {

    $gc_type  = $gc_type_and_schedule['gc_type']
    $schedule = $gc_type_and_schedule['schedule']

    puppetdb_gc::gc_cron { $gc_type :
      gc_cron_ensure => $puppetdb_gc_cron_ensure,
      cron_schedule  => $schedule,
    }
  }
}
