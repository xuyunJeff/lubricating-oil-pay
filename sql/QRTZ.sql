# 数据库字符集如果区分大小写，定时任务表一定要大写
RENAME table qrtz_calendars to QRTZ_CALENDARS;
RENAME table qrtz_fired_triggers to QRTZ_FIRED_TRIGGERS;
RENAME table qrtz_job_details to QRTZ_JOB_DETAILS;
RENAME table qrtz_locks to QRTZ_LOCKS;
RENAME table qrtz_paused_trigger_grps to QRTZ_PAUSED_TRIGGER_GRPS;
RENAME table qrtz_scheduler_state to QRTZ_SCHEDULER_STATE;
RENAME table qrtz_triggers to QRTZ_TRIGGERS;