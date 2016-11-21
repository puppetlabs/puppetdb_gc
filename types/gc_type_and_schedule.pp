type Puppetdb_gc::Gc_type_and_schedule = Struct[{
  gc_type  => String,
  schedule => Puppetdb_gc::Cron_schedule,
}]
