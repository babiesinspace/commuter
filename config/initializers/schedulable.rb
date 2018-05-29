Schedulable.configure do |config|
  # Build occurrences
  config.max_build_count = 0
  config.max_build_period = 1.year
  # SimpleForm
  # config.simple_form = {
  #   input_types: {
  #     date: :date_time,
  #     time: :date_time,
  #     datetime: :date_time
  #   }
  # }
  # Generic Form helper
  config.form_helper = {
    style: :default
  }
end