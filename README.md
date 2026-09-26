# npm-crowdsec

The official [Nginx Proxy Manager](https://github.com/NginxProxyManager/nginx-proxy-manager) image plus the official
[CrowdSec OpenResty bouncer](https://github.com/crowdsecurity/cs-openresty-bouncer) (IP decisions + AppSec/WAF).
It replaces the unmaintained `lepresidente/nginx-proxy-manager` fork. Nothing in NPM itself is changed: the official
image already runs on OpenResty, so the bouncer's Lua files, `lua-resty-http` and one nginx include are added on top.

## Build
- Locally: `./build.sh 2.16.0 v1.2.3` → `local/npm-crowdsec:2.16.0-csv1.2.3`
- GitHub Actions: every push to `main`, weekly, or manually (choose versions) → `ghcr.io/<owner>/npm-crowdsec:<npm>-cs<bouncer>`

## Use
1. On the CrowdSec LAPI: `cscli bouncers add npm` and, for AppSec, see `examples/appsec-acquis.yaml`.
2. Put `examples/crowdsec-openresty-bouncer.conf` (filled in) at `<npm data>/crowdsec/crowdsec-openresty-bouncer.conf`.
3. Run the image exactly like the official one (`/data`, `/etc/letsencrypt`, ports 80/81/443).
4. Optional: `examples/http_top.conf` to skip AppSec for hosts with large uploads.

The bouncer checks `$remote_addr`, so make sure NPM restores the real client IP (for Cloudflare: `real_ip_header CF-Connecting-IP;`
in the host's advanced config). The bouncer fails open if the LAPI or AppSec is unreachable.

## Notes
- The official image fetches Cloudflare/CloudFront IP ranges after nginx starts and may not apply them until the next reload;
  mounting a static `/etc/nginx/conf.d/include/ip_ranges.conf` with `IP_RANGES_FETCH_ENABLED=false` avoids that. Do not mount it `:ro` (startup chowns it).
- "error loading captcha plugin" at startup is harmless when no captcha provider is configured.
