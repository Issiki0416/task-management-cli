## 概要
作業時間を管理するツール

## 仕様
 ``` ruby time_tracking_tool.rb [option] ```  
 【option】    
     [-s <task_name>] / [--start <task_name>] : タスク開始の時間を記録   
     [-f <task_name>] / [--finish <task_name>] : タスク終了の時間を記録  
     [-vt] / [--view-today] : 本日のタスク一覧（タスク名、開始時間、終了時間、実績時間）と本日の作業合計時間を表示  
     [-vw] / [--view-week] : 直近7日間の日別作業時間を表示


## その他
- 実行時のパラメータが適切ではない場合はusageを表示
- バッチ実行
