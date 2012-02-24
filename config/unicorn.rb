# coding: utf-8

# ワーカー数
worker_processes 2

# ワーキングディレクトリ
working_directory File.expand_path('../../', __FILE__)

# ソケットパス
listen "#{File.expand_path('../../tmp/sockets', __FILE__)}/test_manager.sock"

# プロセスID
pid "#{File.expand_path('../../tmp/pids', __FILE__)}/unicorn.pid"

# タイムアウト
timeout 10

# ログ
stdout_path "#{File.expand_path('../../log', __FILE__)}/unicorn_stdout.log"
stdout_path "#{File.expand_path('../../log', __FILE__)}/unicorn_stderr.log"
