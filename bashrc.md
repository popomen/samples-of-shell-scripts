Bash 的初始化配置文件：.bashrc

# 什么是 `.bashrc` ？
Linux 终端允许多种类型的 shell，其中最为常见的就是 Bash（Bourne shell command）。而 Bash 允许通过配置每个用户目录下的 `~/.bashrc` 文件，进行个人偏好的设置（如：终端配色、将常用软件加入到PATH等等）。

# 如何让docker容器执行 `.bashrc` 后再执行命令？

当我们直接使用 `docker run 34bec48141b4 bash` 命令来启动容器时候，会发现 `~/.bashrc` 初始化工作已经进行完成。这是完全符合预期的。

但是，当我们通过以下的方式来执行容器内的某个脚本的时候，`~/.bashrc` 却未被执行到。
```Bash
docker run 34bec48141b4 bash -c 'test.sh'

docker run 34bec48141b4 bash -c 'bash test.sh'

docker run 34bec48141b4 bash -c 'bash -c test.sh'
```

同样都是通过 `bash` 命令启动容器，为什么会有所区别？
带着疑问我找到了有着同样疑问的人： https://stackoverflow.com/questions/55206227/why-bashrc-is-not-executed-when-run-docker-container/74017557

最高赞回答说了句“正确的废话”，把 `source ~/.bashrc` 加入到启动命令前面：
> Each command runs a separate sub-shell, so the environment variables are not preserved and `.bashrc` is not sourced (see [this answer](https://stackoverflow.com/questions/54961370/dockerfile-an-appended-variable-is-not-persisted-between-run-instructions/54961726#54961726)).
> 
> You have to source your script manually **in the same process** where you run your command so it would be:
> 
> ```bash
> CMD source /root/.bashrc && /workspace/launch.sh
> ```
> 
> provided your `launch.sh` is an executable.
> 
> As per [documentation](https://docs.docker.com/v17.09/engine/reference/builder/#cmd) `exec` form you are using does not invoke a command shell, so it won't work with your `.bashrc`.

最后在文末，我看到了我想要的答案。

# Bash --login

Bash 作为一种交互式的 shell 工具，只有在交互式启动的情况下才会加载 `.bashrc` ，否则不会。

如果想通过 `bash` 来执行一个脚本的同时，又希望类似交互式那样加载 `.bashrc`， 可以通过添加 `-l` 或 `--login` 参数来实现。

```
docker run 34bec48141b4 bash -l test.sh
```

这一次 `.bashrc` 被执行成功了。


# 参考
- Why `~/.bashrc` is not executed when run docker container?： https://stackoverflow.com/questions/55206227/why-bashrc-is-not-executed-when-run-docker-container/74017557
- bash(1) - Linux man page： https://linux.die.net/man/1/bash

  
看看这篇回答，Use login shell


