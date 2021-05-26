# actions-easyconnect
Run code within EasyConnect VPN !


## Action inputs

| Name | Description | Default |
| --- | --- | --- |
| `CLI_OPTS` | VPN 的地址和账号密码，格式应符合 `-d {vpnUrl} -u {username} -p {password}` |  |
| `SCRIPT`             | 要运行的代码                                                 |         |
| `SLEEP_AFTER_LOGIN`  | 登录后等待的描述                                             | 5       |
| `RETRY`              | 失败重试次数（比如 VPN 有时能连上有时不能，连上了没法用）    | 1       |
| `EXPECTED_EXIT_CODE` | 可能期望的异常退出码，用于和程序网络连接失败的异常区分开     | 0       |

## Usage

举例（完整例子在 [zhangt2333/actions-SduElectricityReminder](https://github.com/zhangt2333/actions-SduElectricityReminder/blob/26d9c37a231f2bea89b2eb8117c0b0d2717a0f2e/.github/workflows/SduElectricityReminder.yml#L28-L38)，一个使用 [actions-easyconnect](https://github.com/zhangt2333/actions-easyconnect) 让校外服务器查询校内宿舍电量，低电提醒的 Github Actions）：

```
      - name: Run Spider in VPN
        uses: zhangt2333/actions-easyconnect@main
        with:
          CLI_OPTS: ${{ secrets.CLI_OPTS }}
          RETRY: 2
          SLEEP_AFTER_LOGIN: 1
          EXPECTED_EXIT_CODE: 66
          SCRIPT: |
            curl -m 3 --retry 3 -s -o /dev/null http://10.100.1.24:8988/web/Common/Tsm.html
            python main.py
```

## Contribution

* 欢迎使用，欢迎贡献代码！

## Credits

- https://github.com/Hagb/docker-easyconnect 提供 docker 封装的 easyconnect，本项目从中抽离出代码


