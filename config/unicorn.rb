# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/home/dostup/alaveteli"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/tmp/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/home/dostup/alaveteli/log/unicorn.log"
stdout_path "/home/dostup/alaveteli/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.dostup.sock"


# Number of processes
# worker_processes 4
worker_processes 2
preload_app true

# Time-out
timeout 20

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
   begin
    uid, gid = Process.euid, Process.egid
    user, group = 'dostup', 'dostup'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
     Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    if RAILS_ENV == 'development'
      STDERR.puts "couldn't change user, oh well"
    else
      raise e
    end
  end
end
