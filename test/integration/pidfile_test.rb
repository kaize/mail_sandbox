require "test_helper"

class PidfileTest < MiniTest::Unit::TestCase
  include SpawnHelper

  def teardown
    kill_server
  end

  def test_pidfile
    pid = spawn_server "-P #{PID_FILE}"
    assert wait_pid_file, "Pid file doesn't exist."

    pidfile_pid = File.read(PID_FILE).to_i
    assert_equal pid, pidfile_pid

    kill_server
    assert !File.exist?(PID_FILE)
  end


end
