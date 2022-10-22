
# 关于 `history` 命令
首先，我们在 Linux 中执行 history 命令以及敲击 `↑ ↓`和 `Ctrl+R` 看到的命令历史记录都是记录在内存里面的，其背后都是 `history` 工具。

- 另外，环境变量 `HISTSIZE` 还能限制 `history` 命令能够查看的行数。如果你设置了较小的值，再重新设置为一个较大的值，那么 `history` 命令只会记住较小值范围内的命令，但整个过程中 `~/.bash_history` 文件中的内容不会被清除。
- 命令 `!!` 可以重复上一个命令。

# 关于 `history` 命令的持久化
当我们建立一个bash会话（包括ssh、docker exec、kubectl exec等）时候，当前会话先从历史记录文件（默认值：~/.bash_history）中读取历史值到内存中，因此我们也能看到之前一些别的会话记录下来的历史命令。  
  
内存中的历史记录持久化到历史记录文件（~/.bash_history）的三种方式：  
- BASH 将关闭会话时所运行的所有命令并写入你的历史记录文件 ~/.bash_history。  
- BASH 实时地将命令追加到历史记录文件 ~/.bash_history。  
- 手动执行 `history -w` 记录“内存”中的历史命令记录到历史记录文件 ~/.bash_history。  

无论是实时写入还是仅在退出时写入 ~/.bash_history，读取仅在会话创建时候执行，因此两个会话之间不会相互影响history命令的结果。

# 实时更新 `~/.bash_history` 文件的方法

```Bash
shopt -s histappend  
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"  
```
  
- 第一个命令将 .history 文件模式更改为追加模式。
- 第二个命令将 history -a 命令设置为每次执行命令后执行。此处 `-a` 立即将当前/新行写入历史文件。

这样无论 Bash 是否被异常中断，我们执行的命令都会被正常记录到 `~/.bash_history`，下一次执行 Bash 的时候也能够通过 history 命令看到所有的历史命令执行记录了。

# 附录
- Is it possible to make writing to .bash_history immediate?： https://askubuntu.com/questions/67283/is-it-possible-to-make-writing-to-bash-history-immediate
- 如何在 Linux 中有效地使用 history 命令： https://linuxstory.org/how-to-use-history-command-effectively-in-linux/
