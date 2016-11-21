type Puppetdb_gc::Gc_api_payload_and_schedule = Struct[{
  gc_api_payload => String,
  schedule       => Puppetdb_gc::Cron_schedule,
}]
