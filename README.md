# HXVIDEO 网盘订阅

自托管网盘 JS + 订阅文件。全部 `api` 指向本仓库，走 jsDelivr。

## 目录结构

```
HXVIDEO/
├── README.md              # 本文件
├── subscription.json      # 订阅文件（播放器导入这个）
├── panjs/                 # 6 个网盘资源站解析脚本
│   ├── Pan_wogg.js        # 玩偶、花卷
│   ├── Pan_mogg.js        # 木偶
│   ├── Pan_labipan.js     # 蜡笔
│   ├── Pan_shandian.js    # 闪电
│   ├── Pan_duoduo.js      # 多多
│   └── Pan_ouge.js        # 欧哥
└── pantools/
    └── panTools2.js       # 网盘解析工具（夸克/UC/天翼/123/百度/移动/pikpak/115）
```

## 播放器里添加（订阅这一条即可）

```
https://cdn.jsdelivr.net/gh/HongTxian/HXVIDEO@main/subscription.json
```

uz / HX 影视 → 设置 → 数据管理 → 订阅 → 添加 → 粘贴上面链接 → 确定。

导入后自动获得：
- **17 个网盘资源站**（玩偶 / 木偶 / 蜡笔 / 闪电 / 多多 / 欧哥 / 花卷）→ 进「视频源」
- **1 个网盘解析工具**（type 300）→ 进「网盘工具扩展」

无需再单独导入任何 JS。

## 说明

- **订阅链接和所有 api 都用 `cdn.jsdelivr.net`**（直连 raw 在国内不通）。
- **必须保持仓库 Public**。私有仓库 jsDelivr / raw 一律 404。
- **默认分支必须是 `main`**（链接里的 `@main`）。若是 `master`，全改成 `@master`。
- 站点换域名：只改 `subscription.json` 里对应条的 `webSite`，不用动 JS。
- 改了 JS 后 jsDelivr 有缓存，可把 `@main` 换成 commit 哈希强制刷新。

## 站点改版怎么修

`panjs/Pan_xxx.js` 里改两处：
- `appConfig._webSite` 默认域名（会被订阅的 `webSite` 覆盖）
- `getVideoList` / `getVideoDetail` 里的 URL 拼接与 HTML 解析
