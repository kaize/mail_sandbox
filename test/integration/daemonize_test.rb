require "test_helper"

class DaemonizeTest < MiniTest::Unit::TestCase
  include SpawnHelper

  def teardown
    kill_server
  end

  def test_daemonize
    pid = spawn command("-D -P #{PID_FILE}")

    assert wait_pid_file, "Pid file doesn't exist."
    assert !alive?, "Server didn't daemonize."

    real_pid = File.read(PID_FILE).to_i
    assert pid != real_pid

    @pid = real_pid
    assert alive?, "Real server doesn't alive."
  end


end
