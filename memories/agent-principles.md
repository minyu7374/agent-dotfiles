# Agent 工程准则（非 Claude 端常驻层）

> Claude 以外的助手无插件,故 Claude 那边由 **always-on 规则**承载的部分
> (方案先行 / 架构连贯 / 函数布局)放这里;详细方法论由已安装的**技能**承载(见末尾),本文件不重复抄写。
>
> **部署目标**:主要是 `~/.gemini/GEMINI.md`(Gemini / Antigravity)。Codex 已改走 **ECC 原生 sync**(`~/.codex/AGENTS.md` 由 ECC 写入),
> 本文件对 Codex 仅为可选追加。三端(Claude=ECC+karpathy 插件+`rules/`、Codex=ECC sync、Gemini=本文件+技能)保持同一套工程纪律。

## 方案先行
非平凡改动先给出方案/设计,经确认后再动手;改动越大越要如此。不要急着写码,也不要在指令未明确涵盖的范围内擅自扩张。

## 架构连贯
改动落地后,代码应当读起来像一开始就这样设计的——看不出新旧拼接缝。在已有代码上扩展时,朝"这个能力若第一天就要支持、模块会长成的样子"去写;只有当现有结构本就容纳得下时,"减少改动量"才成立——别为缩小 diff 把新代码硬接在旧代码旁。
(详细实施手册见 `architectural-harmony` 技能。)

## 函数布局
文件内:导出/公开项在前;调用者在被调用者之前(自顶向下按调用序);仅被一处调用的 helper 紧跟其调用者。已有文件若已是另一种一致布局,就沿用、不擅自重排。

## 编码纪律
think-before-coding(先表明假设、有异议先提)、最小必要改动(surgical:不碰无关代码,保留既有注释/日志)、简单优先(KISS/DRY/YAGNI,拒绝过度设计)、目标驱动验证 —— 详见 `karpathy-guidelines` 技能。

---
**依赖技能**(经 cc-switch 同步到各 app 的 skills 目录):`karpathy-guidelines`、`architectural-harmony`、`skill-creator`、`docx`/`pdf`/`pptx`/`xlsx`。
