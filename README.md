# HXVIDEO 网盘订阅

自托管网盘 JS + 订阅文件。全部 `api` 指向本仓库，走 jsDelivr。

## 为什么每个线路一个 JS 文件

播放器安装源时，扩展 id 由 **`api` 地址的哈希**生成（HX 源码
`source_registry.dart:741`：`sub_${type}_${url.hashCode}`）。
若多条线路共用同一个 `api` 地址，会生成相同 id → 互相覆盖 → 只生效一条。

所以这里把 6 个模板拆成 17 个文件，**每条线路一个独立文件**：
内容完全相同，只有文件名不同，从而 `api` 地址各不相同，17 条全部生效。

```
Pan_wogg_wogg1.js  ← 玩偶1
Pan_wogg_wogg2.js  ← 玩偶2
Pan_wogg_huajuan.js ← 花卷
Pan_mogg_mogg1..4.js ← 木偶1..4
Pan_labipan_labi1..2.js ← 蜡笔1..2
Pan_shandian_sd1..2.js ← 闪电1..2
Pan_duoduo_dd1..4.js ← 多多1..4
Pan_ouge_og1..2.js ← 欧哥1..2
```

## 目录结构

```
HXVIDEO/
├── README.md
├── subscription.json          # 订阅文件（播放器导入这个）
├── panjs/                     # 17 个网盘资源站脚本（每线路一份）
├── pantools/
│   └── panTools2.js           # 网盘解析工具（type 300）
└── live/                      # 6 个直播源 M3U 镜像（type 10）
    ├── huyayqk.m3u            # 虎牙一起看
    ├── douyuyqk.m3u           # 斗鱼一起看
    ├── yylunbo.m3u            # YY 轮播
    ├── bililive.m3u           # 哔哩直播
    ├── fanmingming_ipv6.m3u   # 范明明 IPv6
    ├── guovin_result.m3u      # Guovin IPTV
    └── update_live.sh         # 刷新上面 6 个镜像
```

## 播放器里添加

```
https://cdn.jsdelivr.net/gh/HongTxian/HXVIDEO@main/subscription.json
```

HX 影视 → 设置 → 数据管理 → 订阅 → 添加 → 粘贴 → 确定。

导入后应得到 **17 个视频源 + 6 个直播源 + 1 个网盘工具**（共 24 条可装）。

## 直播源为什么写在 `vod` 里

`subscription.json` 的 `vod` 数组里最后 6 条是 `"type": 10` 的直播源，
**不能**写成顶层 `"live": [...]`。

HX 解析订阅时只遍历 `vod` / `recommend` / `panTools` / `sites` 四个顶层键
（`lib/data/subscription.dart:361-380`），顶层 `live` 键会被整个忽略——
写成 `"live"` 时订阅页仍显示 17 条，6 个直播源静默消失。
放进 `vod` 后由 `type: 10` 分流到 `sub.live`，直播页才能看到。

直播条目的 `api` 是 M3U 地址，安装时**不下载源码**，只在直播页按需拉取解析
（`lib/data/live_source.dart`）。

## 直播源与 live/ 镜像

`live/` 里是 6 个 M3U 的**快照**，`subscription.json` 默认指向**源站实时地址**：

| 名称 | 订阅里的地址 |
|---|---|
| 🐯虎牙一起看 | `https://sub.ottiptv.cc/huyayqk.m3u` |
| 🐟斗鱼一起看 | `https://sub.ottiptv.cc/douyuyqk.m3u` |
| 🔄YY轮播 | `https://sub.ottiptv.cc/yylunbo.m3u` |
| 📺哔哩直播 | `https://sub.ottiptv.cc/bililive.m3u` |
| 📡范明明IPv6 | `https://cdn.jsdelivr.net/gh/fanmingming/live@refs/heads/main/tv/m3u/ipv6.m3u` |
| 🛰️Govin | `https://cdn.jsdelivr.net/gh/Guovin/iptv-api@gd/output/result.m3u` |

这些列表由源站动态生成（文件里带「列表更新时间」，实测几小时刷新一次），
所以订阅用实时地址而不是仓库快照 —— 快照里的频道地址很快会失效。
`live/` 里的镜像只作离线备份/参考，需要更新时跑：

```bash
bash live/update_live.sh
```

脚本会校验 HTTP 200 + `#EXTM3U` 头，失败的文件保持原样不动。

## 注意事项

- **仓库必须 Public**，默认分支必须 `main`（链接里的 `@main`）。
- 订阅链接和所有 api 都用 `cdn.jsdelivr.net`（直连 raw 在国内不通）。
- jsDelivr 有缓存，改 JS 后可把 `@main` 换成 commit 哈希强制刷新。
- 站点换域名：只改 `subscription.json` 对应条的 `webSite`。

## 增删线路

- **加**：从已有文件复制一份（如 `Pan_mogg_mogg1.js` → `Pan_mogg_mogg5.js`），
  在 `subscription.json` 里加一条，`api` 指向新文件、`webSite` 填新域名。
- **删**：删掉 JSON 里那条即可（JS 文件可留可删）。
- 切勿让两条线路的 `api` 完全相同。

## 增删直播源

- **加**：在 `vod` 数组里加一条 `"type": 10`，`api` 填 M3U 地址；
  想留镜像就在 `live/` 放一份并加进 `update_live.sh`。
- **删**：删掉那条即可。
- 直播源不受 `api` 哈希碰撞影响（它不生成 extId），多个源可以共用同一个 M3U 地址。
