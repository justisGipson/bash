from crontab import CronTab

cron = CronTab(user="jgipson")

cron.remove_all(comment="daily_clean")
print("Job removed")

job = cron.new(command="bash /Users/jgipson/Cron/cleanit_job", comment="daily_clean")

job.setall(0, 10)

cron.write()

print("Job created")

for job in cron:
    print(job)
