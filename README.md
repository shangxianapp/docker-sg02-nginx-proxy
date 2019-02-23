# docker-sg02-nginx-proxy
sg02 服务器的 Nginx 反向代理，通过 SSL 证书目录、虚拟主机配置、站点目录映射达到一个 Nginx Docker 代理服务器中多个服务。

## 目录映射

- `DOCKER_NGINX_VHOST_DIR` - Nginx 虚拟主机目录，在 `nginx.conf` 里直接加载：`include vhost/*.conf` ，如果有站点自定义公用文件，可以以站点名为目录存放，使用 `include vhost/站点名/demo.conf`
- `DOCKER_NGINX_CA_DIR` - Nginx SSL 证书目录，在 Nginx 配置文件里可以直接使用 `ca/domain/xxx` 引用
- `WWWROOT_DIR` - 网站目录，以域名为子目录存放，在 Nginx 配置文件中使用 `/usr/share/nginx/html/子目录` 引用，或者使用变量 `WWWROOT_DIR`

> 注意：以上变量是在 sg02 服务器中定义。

## 通用配置引用

- `inc/favicon.conf` - Favicon 图标，需要在 `server` 指令使用
- `inc/robots.conf` - 蜘蛛配置，需要在 `server` 指令使用
- `inc/robots.disallow.conf` - 蜘蛛配置，禁止抓取，需要在 `server` 指令使用
- `inc/ssl.conf` - 公用 SSL 配置，需要在 `server` 指令使用
- `inc/no-cache.conf` - 关闭浏览器缓存，每次都是 HTTP 200 ，注意：使用的 `add_header` 指令，在需要的地方进行 `include`
- `inc/security.conf` - 一些安全、优化相关的公用配置，注意：使用的 `add_header` 指令，在需要的地方进行 `include`
- `inc/sts.conf` - STS，注意：使用的 `add_header` 指令，在需要的地方进行 `include`

## Lua 文件支持

以 `./lua` 当前目录映射到 `/etc/nginx/lua` 目录，在配置里直接使用 `lua/xxx.lua` 引用。

## 示例

```nginx
server {
    set_by_lua $WWWROOT_DIR 'return os.getenv("WWWROOT_DIR")';
    root $WWWROOT_DIR/xxx;

    include inc/favicon.conf;

    include                         inc/ssl.conf;
    ssl_certificate                 ca/shangxian.app/fullchain.cer;
    ssl_certificate_key             ca/shangxian.app/shangxian.app.key;

    location / {
        add_header 'x-dns-prefetch-control' 'on';
        include inc/no-cache.conf;
        include inc/sts.conf;
        include inc/站点名/demo.conf;
    }

    location @webp {
        content_by_lua_file "lua/webp.lua";
    }
}
```

## 刷新 Nginx 命令

```bash
/bin/sh $DOCKER_NGINX_DIR/reload.sh
```