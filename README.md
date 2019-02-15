# docker-sg02-nginx-proxy
sg02 服务器的 Nginx 反向代理，通过 SSL 证书目录、虚拟主机配置、站点目录映射达到一个 Nginx Docker 代理服务器中多个服务。

## 目录映射

- `DOCKER_NGINX_VHOST_DIR` - Nginx 虚拟主机目录，在 `nginx.conf` 里直接加载：`include vhost/*.conf` ，或者使用变量 `DOCKER_NGINX_VHOST_DIR`
- `DOCKER_NGINX_CA_DIR` - Nginx SSL 证书目录，在 Nginx 配置文件里可以直接使用 `ca/domain/xxx` 引用，或者使用变量 `DOCKER_NGINX_CA_DIR`
- `WWWROOT_DIR` - 网站目录，以域名为子目录存放，在 Nginx 配置文件中使用 `/usr/share/nginx/html/子目录` 引用，或者使用变量 `WWWROOT_DIR`

> 注意：以上变量是在 sg02 服务器中定义。

## 通用配置引用

- `inc/favicon.conf` - Favicon 图标
- `inc/robots.txt` - 蜘蛛配置
- `inc/robots.disallow.txt` - 蜘蛛配置，禁止抓取
- `inc/ssl.conf` - 公用 SSL 配置

## 变量使用

```nginx
server {
    set_by_lua $WWWROOT_DIR 'return os.getenv("WWWROOT_DIR")';

    root $WWWROOT_DIR/xxx;
}
```

## 刷新 Nginx 命令

```bash
/bin/sh $DOCKER_NGINX_DIR/reload.sh
```