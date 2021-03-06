# coding: utf-8

# ---------- 環境別定義 ---------- #
if Rails.env.production?
  #----------------#
  # Production環境 #
  #----------------#
  DEFAULT_PROVIDER = "github"
#  DEFAULT_PROVIDER = "twitter"
else
  #--------------------#
  # Production環境以外 #
  #--------------------#
  DEFAULT_PROVIDER = "developer"
#  DEFAULT_PROVIDER = "github"
#  DEFAULT_PROVIDER = "twitter"
end

# 定数
WDAYS = [ "日", "月", "火", "水", "木", "金", "土" ]
STATUS = [ "未対応", "修正中", "検討中", "対応中", "修正済", "対応済", "重複" ]
SPEC_FLAG = [ "未作成", "作成済", "要修正", "不要", "保留" ]
OS = [ "Mac OS X 10.6", "Mac OS X 10.6.8", "Mac OS X 10.7", "Win XP", "Win 7" ]
BROWSER = [ "IE", "Firefox", "Safari", "Chrome", "Opera" ]
CATEGORY = [ "正常系", "準正常系", "異常系", "バグ", "データ不備", "仕様漏れ", "設定漏れ", "未実装", "気付いた点", "要望", "質問", "検討課題" ]
JUDGE = [ "OK", "Pending", "NG" ]
TICKET_NO = [ "有り", "無し" ]

SEARCH_JUDGE_LIST = [ "OK", "Pending", "NG", "Pending／NG" ]
SEARCH_TRAGET_LIST = [ "id", "title", "page", "operation", "result", "ticket_no", "note" ]
SEARCH_DATE_LIST = [ "operation_at", "check_at" ]

PER_PAGE = 50
