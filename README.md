<div align="center">
  <img src="logo.png" width="150" height="150" alt="Project Logo">
  <h1>FuckGamesDailyMissions</h1>
  <p>自动化任务调度与关机助手</p>
</div>

这是一个基于 Windows Batch 脚本的轻量级自动化工具，旨在按预定顺序启动一系列应用程序，并在任务完成后根据设定的时间表自动关闭计算机。特别适合需要长时间挂机运行自动化程序并在夜间自动关机的场景。

## ✨ 主要功能

*   **智能时间检测**：
    *   **夜间模式 (22:00 - 04:00)**：如果在深夜启动，脚本会自动挂起并等待至次日凌晨 **04:15** 再开始执行任务（你见过凌晨4点的手提箱/提瓦特/星穹列车/索拉里斯吗？）。
    *   **日间模式**：如果在其他时间启动，则立即执行任务。
*   **顺序任务调度**：支持依次启动多个任务，每个任务之间自动等待 30 分钟（可配置），确保前一个任务有足够时间完成。
*   **实时体力监控与推送**：
    *   **针对鸣潮 (Wuthering Waves)**：由于 `ok-ww` 项目目前没有自带的自动通知功能，本项目通过调用**库街区 API** 获取实时数据，并配合**飞书群机器人**实现任务完成后的体力、活跃度自动推送。
*   **灵活的关机策略**：
*   在一些情况下，您可能希望设备在完成任务后自动关机，因此本项目设计了：
    *   可视化的自动关机配置工具 (`configure_schedule.bat`)。
    *   支持为一周中的每一天单独设置是否自动关机。
*   **隐私保护**：通过独立的任务脚本管理路径，方便分享而不暴露个人隐私。

## 🎮 支持的游戏与项目

本项目预设了以下自动化工具的启动脚本：

| 任务脚本 | 对应游戏 | 自动化项目 (GitHub) | 说明 |
| :--- | :--- | :--- | :--- |
| `task_1_mfa.bat` | **重返未来：1999** (Reverse: 1999) | [M9A (MAA1999)](https://github.com/MAA1999/M9A) | 使用 MFAAvalonia 作为 GUI 的 M9A 助手 |
| `task_2_bettergi.bat` | **原神** (Genshin Impact) | [BetterGI](https://github.com/babalae/better-genshin-impact) | 更好的原神 - 自动化辅助工具 |
| `task_3_march7th.bat` | **崩坏：星穹铁道** (Honkai: Star Rail) | [March7thAssistant](https://github.com/moesnow/March7thAssistant) | 三月七小助手 |
| `task_4_okww.bat` | **鸣潮** (Wuthering Waves) | [ok-ww](https://github.com/ok-oldking/ok-wuthering-waves) | 鸣潮后台自动化助手 |
| `task_5_ww_monitor.bat` | **鸣潮** (Wuthering Waves) | **本项目内置** | 通过库街区 API 推送体力/活跃度到飞书 |

## 🚀 快速开始

### 0. 配置自动化程序

本质上，这些任务脚本只是**通过命令行来启动了对应的应用程序**，并且可以通过**命令行参数**来指定启动后的任务——它们并没有其他特殊功能。
因此，在使用脚本前，您需要先对每个自动化程序进行设置和调试（如队伍在战斗类任务中携带足够强力的生存位以维持续航），保证它们都能正常地完成每日任务，并且在完成后自动关闭以避免干扰下一个脚本的执行。

以下是各个自动化程序的命令行参数和推荐设置说明：
*   1. **M9A (MAA1999)**：
    *   `M9A` 并没有提供基于命令行的参数，但是可以在`设置`界面的`启动设置`中设置`启动后操作：启动游戏并启动脚本`，推荐同时设置`结束后操作：关闭模拟器和本程序`。（请确保在“设置”界面中配置了正确的游戏路径）
*   2. **BetterGI (Genshin Impact)**：
    *    `task_2_bettergi` 在启动 `BetterGI` 时会在末尾附加 `startOneDragon` 参数以启动`一条龙`任务。推荐同时在`一条龙`中设置`任务完成后执行的操作：关闭游戏和软件`。
*   3. **March7thAssistant (Honkai: Star Rail)**：
    *   `March7thAssistant` 没有提供基于命令行的参数，但默认在通过命令行方式启动时会执行`完整运行`任务。推荐只保留执行`日常`任务，关闭其他任务的执行，并在`程序`中设置`任务完成后：退出`。
*   4. **ok-ww (Wuthering Waves)**：
    *    `task_4_okww.bat` 在启动 `ok-ww` 时会在末尾附加 `-t 1 -e` 参数以启动`一条龙`任务，其中`-t 1`表示执行第1个任务（一条龙），`-e`表示在任务完成后自动关闭。推荐在`周常日常`下的`日常一条龙`中设置`完成后退出：是`。

### 1. 初始化配置

首次使用前，你需要根据自己的软件安装路径配置任务脚本。

1.  将 `task_1_mfa.bat.example` 重命名为 `task_1_mfa.bat`。
2.  将 `task_2_bettergi.bat.example` 重命名为 `task_2_bettergi.bat`。
3.  ...以此类推，处理所有任务脚本。
4.  特别地：将 `ww_monitor.py.example` 重命名为 `ww_monitor.py`。

### 2. 设置软件路径与认证

*   **对于任务 1-4**：右键点击 `task_*.bat` 文件，选择“编辑”，修改 **`APP_DIR`** 和 **`APP_EXE`** 为你的自动化程序的实际路径。
*   **对于任务 5 (鸣潮监控)**：
    *   编辑 `ww_monitor.py`。
    *   填入从库街区抓包获取的 `token`、`roleId` 等信息（参考 [此教程](https://xn--ntsp09fr3m.com/kurobbs.html)）。
    *   填入飞书机器人的 `FEISHU_WEBHOOK` 地址（参考 [飞书官方教程](https://www.feishu.cn/hc/zh-CN/articles/360024984973)）。
    *   确保安装了依赖：`pip install requests`。

### 3. 配置关机计划

双击运行 **`configure_schedule.bat`**。
脚本会依次询问你周一至周日是否需要关机：
*   输入 `1`：启用自动关机 (True)
*   输入 `2`：禁用自动关机 (False)

## ⚙️ 详细设置指南

### 如何设置项目启动时间？

项目启动逻辑位于主脚本 `auto_launcher.bat` 的 `CheckTimeMode` 模块中。
默认逻辑如下：
*   如果当前时间在 **晚上 22:00** 到 **凌晨 04:00** 之间：脚本会计算时间差，一直**等待到 04:15** 才开始运行第一个任务。
*   在其他时间段内，脚本会立刻执行任务。

### 如何设置任务间隔时间？

默认每个任务之间等待 **30 分钟**。
如果你想修改等待时间，请编辑 `auto_launcher.bat`，找到类似以下的代码并修改 `timeout` 数值：

```batch
echo [Wait] Waiting 30 minutes (1800 seconds) before next task...
timeout /t 1800 /nobreak >nul
```

## 📂 文件结构说明

*   `auto_launcher.bat`: **主程序**，负责整体流程控制。
*   `configure_schedule.bat`: **配置工具**，用于交互式设置关机计划。
*   `ww_monitor.py`: **鸣潮体力监控脚本**，负责推送数据。
*   `task_*.bat`: **子任务脚本**，负责启动具体的应用程序。
    *   `task_1_mfa.bat`: 重返未来1999
    *   `task_2_bettergi.bat`: 原神
    *   `task_3_march7th.bat`: 星穹铁道
    *   `task_4_okww.bat`: 鸣潮助手
    *   `task_5_ww_monitor.bat`: 鸣潮体力推送

## ⚠️ 注意事项

*   **路径中的空格**：请确保在脚本中保持双引号包裹路径。
*   **管理员权限**：部分自动化软件可能需要管理员权限才能正常运行。
*   **Python 环境**：运行任务 5 需要安装 Python 3 及 `requests` 库。

## 🙇‍ 鸣谢 
*   鸣潮体力监控功能的实现基于[该API收集项目](https://github.com/TomyJan/Kuro-API-Collection/tree/master)，抓包信息的获取则参考了[此教程](https://xn--ntsp09fr3m.com/kurobbs.html)。没有它们，这项功能不可能实现。

## ⚖️ 免责声明

1.  本项目仅作为一个**本地批处理启动脚本**，用于自动化调度程序的启动与关闭。
2.  文档中提到的第三方自动化项目仅作为示例，本项目与这些第三方项目**无任何关联**。
3.  使用自动化工具可能违反部分游戏的服务条款（ToS），存在封号风险。**请自行评估风险**。
4.  本项目使用了人工智能生成的代码，可能存在错误或不完整的部分。请谨慎使用。
