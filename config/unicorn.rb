# coding: utf-8

# ワーカー数
worker_processes 2
 
# ソケットパス
listen "#{File.expand_path('../../tmp/sockets', __FILE__)}/test_manager.sock"

# PID
pid "#{File.expand_path('../../tmp/pids', __FILE__)}/unicorn.pid"

