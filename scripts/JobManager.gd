class_name JobManager
extends Node

var active_jobs: Array = []
var max_active_jobs: int = 5

func generate_daily_jobs() -> void:
	var new_job_count = randi_range(0, 2)
	for i in new_job_count:
		if active_jobs.size() >= max_active_jobs:
			break
		var job = Job.new()
		var type = randi_range(0, 2)
		job.setup(type)
		active_jobs.append(job)
		print("Nová zakázka: ", job.get_label(), " deadline: ", job.deadline, " dní")

func process_day() -> Array:
	var expired_jobs: Array = []
	for job in active_jobs:
		if not job.is_assigned:
			job.days_remaining -= 1
			if job.days_remaining <= 0:
				expired_jobs.append(job)
	for job in expired_jobs:
		active_jobs.erase(job)
	return expired_jobs

func assign_job(job, team) -> void:
	job.is_assigned = true
	team.is_busy = true
	team.days_until_free = 1
	active_jobs.erase(job)
