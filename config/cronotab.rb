# cronotab.rb — Crono configuration file
#
# Here you can specify periodic jobs and schedule.
# You can use ActiveJob's jobs from `app/jobs/`
# You can use any class. The only requirement is that
# class should have a method `perform` without arguments.
#
# class TestJob
#   def perform
#     puts 'Test!'
#   end
# end
 Crono.perform(RecommendationJob).every 1.days, at: '21:33'
 Crono.perform(FeaturedCheckJob).every 1.days, at: '15:16'
#bundle exec crono RAILS_ENV=development
