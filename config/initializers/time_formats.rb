

Time::DATE_FORMATS[:db_datetime] = ->(time) { time.strftime('%Y-%m-%d %H:%M:%S') }