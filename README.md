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
└── pantools/
    └── panTools2.js           # 网盘解析工具（type 300）
```

## 播放器里添加

```
https://cdn.jsdelivr.net/gh/HongTxian/HXVIDEO@main/subscription.json
```

HX 影视 → 设置 → 数据管理 → 订阅 → 添加 → 粘贴 → 确定。

导入后应得到 **17 个视频源 + 1 个网盘工具**。

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
