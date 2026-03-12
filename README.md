<div align="center">
  <img src="logo.png" width="150" height="150" alt="Project Logo">
  <h1>FuckGamesDailyMissions</h1>
  <p>自动化任务调度与关机助手</p>
</div>

这是一个基于 Windows Batch 脚本的轻量级自动化工具，旨在按预定顺序启动一系列应用程序，并在任务完成后根据设定的时间表自动关闭计算机。特别适合需要长时间挂机运行自动化程序并在夜间自动关机的场景。

## ✨ 主要功能

*   **智能时间检测**：
    *   **夜间模式 (22:00 - 04:00)**：如果在深夜启动，脚本会自动挂起并等待至次日凌晨 **04:15** 再开始执行任务（避开高峰期或等待服务器刷新）。
    *   **日间模式**：如果在其他时间启动，则立即执行任务。
*   **顺序任务调度**：支持依次启动多个任务，每个任务之间自动等待 30 分钟（可配置），确保前一个任务有足够时间完成。
*   **灵活的关机策略**：
    *   提供可视化的配置工具 (`configure_schedule.bat`)。
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

> **注意**：本项目仅作为启动器，不包含上述任何自动化软件。请自行前往对应 GitHub 仓库下载并安装。**本项目与以上项目没有任何关联，也不提供任何形式的技术支持。**

## 🚀 快速开始

### 1. 初始化配置

首次使用前，你需要根据自己的软件安装路径配置任务脚本。

1.  将 `task_1_mfa.bat.example` 重命名为 `task_1_mfa.bat`。
2.  将 `task_2_bettergi.bat.example` 重命名为 `task_2_bettergi.bat`。
3.  ...以此类推，处理所有 4 个任务脚本。

### 2. 设置软件路径

右键点击每个 `task_*.bat` 文件，选择“编辑”，找到以下部分并修改为你实际的软件安装路径：

```batch
REM ========================================================
REM CONFIGURATION REQUIRED
REM ========================================================
set "APP_DIR=E:\YourAutomationTool"       <-- 修改这里：软件所在文件夹
set "APP_EXE=AutomationTool.exe"        <-- 修改这里：可执行文件名
```

### 3. 配置关机计划

双击运行 **`configure_schedule.bat`**。
脚本会依次询问你周一至周日是否需要关机：
*   输入 `1`：启用自动关机 (True)
*   输入 `2`：禁用自动关机 (False)

设置完成后，配置会自动保存到 `shutdown_schedule.ini`。

## ⚙️ 详细设置指南

### 如何设置项目启动时间？

项目启动逻辑位于主脚本 `auto_launcher.bat` 的 `CheckTimeMode` 模块中。
默认逻辑如下：
*   如果当前时间在 **晚上 22:00** 到 **凌晨 04:00** 之间：脚本会计算时间差，一直**等待到 04:15** 才开始运行第一个任务。
*   如果你想修改这个等待时间（例如改为 05:00），请编辑 `auto_launcher.bat`，搜索 `04:15` 并修改相关逻辑。

### 如何设置任务间隔时间？

默认每个任务之间等待 **30 分钟**。
如果你想修改等待时间，请编辑 `auto_launcher.bat`，找到类似以下的代码：

```batch
echo [Wait] Waiting 30 minutes (1800 seconds) before next task...
timeout /t 1800 /nobreak >nul
```

将 `1800` 修改为你需要的秒数即可（例如 600 秒 = 10 分钟）。

### 如何添加或删除任务？

如果你想添加第 5 个、第 6 个任务，或者删除现有任务，请参考以下步骤：

#### 1. 添加新任务

1.  复制 **`task_n_template.bat.example`** 文件，并重命名为 `task_5_custom.bat`（或任何你喜欢的名字）。
2.  编辑新文件，设置 `APP_DIR`（安装路径）和 `APP_EXE`（程序名）。如果有启动参数，可以设置 `APP_ARGS`。
3.  编辑 **`auto_launcher.bat`** 主脚本，找到 **MODULE 2** 区域，在末尾添加新的任务调用代码：

```batch
REM --- Task 5: Custom Task ---
echo.
echo [Step 5] Launching Custom Task...
call "%~dp0task_5_custom.bat"

if errorlevel 1 (
    echo [WARNING] Task 5 reported an error. Continuing...
)

echo.
echo [Wait] Waiting 30 minutes (1800 seconds) before next task...
timeout /t 1800 /nobreak >nul
```

#### 2. 删除任务

直接在 `auto_launcher.bat` 中删除对应的 `call` 命令和 `timeout` 等待代码块即可。

## 📂 文件结构说明

*   `auto_launcher.bat`: **主程序**，负责整体流程控制（时间检查 -> 任务调度 -> 关机检查）。
*   `configure_schedule.bat`: **配置工具**，用于交互式设置每周的关机计划。
*   `shutdown_schedule.ini`: **配置文件**，存储关机计划（由工具生成，手动修改亦可）。
*   `task_n_template.bat.example`: **通用任务模板**，用于创建新任务。
*   `task_*.bat`: **子任务脚本**，负责启动具体的应用程序。
    *   `task_1_mfa.bat`: 任务 1 (MFAAvalonia)
    *   `task_2_bettergi.bat`: 任务 2 (BetterGI)
    *   `task_3_march7th.bat`: 任务 3 (March7th Assistant)
    *   `task_4_okww.bat`: 任务 4 (ok-ww)

## ⚠️ 注意事项

*   **路径中的空格**：如果你的软件安装路径包含空格（如 `C:\Program Files`），请确保在脚本中保持双引号包裹，例如 `set "APP_DIR=C:\Program Files\App"`。
*   **管理员权限**：部分自动化软件可能需要管理员权限才能正常运行。建议尝试以管理员身份运行 `auto_launcher.bat`。
*   **取消关机**：如果脚本触发了关机倒计时（60秒），你可以随时按下 `Win+R` 输入 `shutdown /a` 来取消关机。

## ⚖️ 免责声明

1.  本项目仅作为一个**本地批处理启动脚本**，用于自动化调度程序的启动与关闭，**不包含**任何游戏客户端、外挂、破解或侵权代码。
2.  文档中提到的第三方自动化项目仅作为示例，本项目与这些第三方项目**无任何关联**。请遵循各第三方项目的开源协议与使用条款。
3.  使用自动化工具（脚本/宏）可能违反部分游戏的服务条款（ToS），存在封号风险。**请自行评估风险**。作者不对因使用本项目或相关第三方工具导致的任何账号损失、数据丢失或硬件损坏承担责任。
4.  本项目仅供学习交流使用，请勿用于非法用途。
5.  本项目使用了人工智能生成的代码，可能存在错误或不完整的部分。请谨慎使用。


