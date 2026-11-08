#!/usr/bin/env bash
# 刷新 live/ 下的 M3U 镜像
#
# 这些直播列表在源站是动态生成的（文件里自带「列表更新时间」），
# 频道地址几小时就会变。镜像只作为「源站挂掉时的兜底」，
# subscription.json 默认指向源站实时地址。
#
# 用法：bash live/update_live.sh
set -u

cd "$(dirname "$0")" || exit 1

fetch() {
  local out="$1" url="$2"
  local tmp="${out}.tmp"
  local code
  code=$(curl -s -L --max-time 90 -o "$tmp" -w '%{http_code}' "$url")

  if [ "$code" = "200" ] && head -c 7 "$tmp" | grep -q '#EXTM3U'; then
    mv "$tmp" "$out"
    echo "OK   $out  $(wc -c < "$out") bytes  $(grep -c '^#EXTINF' "$out") channels"
  else
    rm -f "$tmp"
    echo "FAIL $out  (HTTP $code)"
    return 1
  fi
}

fail=0
fetch huyayqk.m3u          "https://sub.ottiptv.cc/huyayqk.m3u"          || fail=1
fetch douyuyqk.m3u         "https://sub.ottiptv.cc/douyuyqk.m3u"         || fail=1
fetch yylunbo.m3u          "https://sub.ottiptv.cc/yylunbo.m3u"          || fail=1
fetch bililive.m3u         "https://sub.ottiptv.cc/bililive.m3u"         || fail=1
fetch fanmingming_ipv6.m3u "https://cdn.jsdelivr.net/gh/fanmingming/live@refs/heads/main/tv/m3u/ipv6.m3u" || fail=1
fetch guovin_result.m3u    "https://cdn.jsdelivr.net/gh/Guovin/iptv-api@gd/output/result.m3u"            || fail=1

exit "$fail"
