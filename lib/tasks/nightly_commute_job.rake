task :nightly_commute_job do
    CommuteJob.perform_later
end