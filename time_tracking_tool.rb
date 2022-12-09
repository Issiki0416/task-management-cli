require 'time'

class TimeTrackingTool
  DATA_FILE_PATH = "./tasks.txt"

  @database

  def initialize
    @database = []
    unless File.exist?(DATA_FILE_PATH)
      File.open(DATA_FILE_PATH, "w") do |file|
        file.print("")
      end
    end
    File.open(DATA_FILE_PATH).each do |line|
      @database << line.split(/,|\n/)
    end
  end

  def file_update
    File.open(DATA_FILE_PATH, "w") do |file|
      @database.each do |line|
        line.each do |data|
          file.print("#{data},")
        end
        file.print("\n")
      end
    end
  end

  def run
    set_option
  end

  private

  # set_option: オプションから処理を選択
  def set_option
    case ARGV[0]
    when '-s', '--start'
      if ARGV[1].nil?
        puts "タスク名を入力してください"
        return
      end
      start_task(ARGV[1])
    when '-f', '--finish'
      if ARGV[1].nil?
        puts "タスク名を入力してください"
        return
      end
      finish_task(ARGV[1])
    when '-vt', '--view-today'
      view_today
    when '-vw', '--view-week'
      view_week
    when '-flush'
      flush_task
    else
      puts usage
    end
    file_update
  end

  def search_task(task_name)
    @database.each do |line|
      if line[0] == task_name
        return line
      end
    end
    nil
  end

  def start_task(task_name)
    if search_task(task_name)
      puts "既にタスクが存在します"
    else
      @database << [task_name,Time.now]
    end
  end

  def finish_task(task_name)
    if line = search_task(task_name)
      line[2] = Time.now
      line[3] = line[2] - Time.parse(line[1])
    else
      puts "タスクが存在しません"
    end
  end

  def secound_to_minites(total_time)
    total_time = total_time.to_i
    minites = total_time / 60
  end
  

  def view_today
    total_time = 0
    puts "本日のタスク一覧（タスク名、開始時間、終了時間、実績時間）と本日の作業合計時間を表示"
    # 今日の日付のタスクを抽出
    @database.each do |line|
      # line[1]から日付を抽出して、今日の日付と一致するか確認
      if line[1].split(" ")[0] == Time.now.strftime("%Y-%m-%d")
        duration = line[3].to_i / 60
        total_time += line[3].to_i
        puts "タスク名: #{line[0]} 開始時間: #{line[1]} 終了時間: #{line[2]} 実績時間: #{duration}"
      end
    end
    puts "本日の作業合計時間: #{secound_to_minites(total_time)}分"
  end

  def view_week
    puts "直近7日間の日別作業時間を表示"
    total_time = Array.new(7, 0)
    # 7日間の日付を格納する配列を作成
    date = []
    7.times do |i|
      date << (Time.now - 60 * 60 * 24 * i).strftime("%Y-%m-%d")
    end
    # それぞれの日付のタスクを抽出
    @database.each do |line|
      date.each_with_index do |d, i|
        if line[1].split(" ")[0] == d
          total_time[i] += line[3].to_i
        end
      end
    end
    # 合計時間を分に変換
    total_time.map! { |time| secound_to_minites(time) }
    # 各日付と合計時間を表示
    date.each_with_index do |d, i|
      puts "#{d} : #{total_time[i]}"
    end
  end

  def usage
    <<~TEXT
      Usage: ruby time_tracking_tool.rb [option]
      - option
          [-s <task_name>] / [--start <task_name>] : タスク開始の時間を記録
          [-f <task_name>] / [--finish <task_name>] : タスク終了の時間を記録
          [-vt] / [--view-today] : 本日のタスク一覧（タスク名、開始時間、終了時間、実績時間）と本日の作業合計時間を表示
          [-vw] / [--view-week] : 直近7日間の日別作業時間を表示
    TEXT
  end
end

time_tracking_tool = TimeTrackingTool.new
time_tracking_tool.run
