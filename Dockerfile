# Official Nginx Proxy Manager + CrowdSec OpenResty bouncer (IP bans + AppSec).
# Replaces the abandoned lepresidente fork (2026-09-26). Rebuild with ./build.sh <npm> <bouncer>.
ARG NPM_VERSION=2.16.0
FROM jc21/nginx-proxy-manager:${NPM_VERSION}
ARG CS_BOUNCER_VERSION=v1.2.3
ARG LUA_RESTY_HTTP_VERSION=v0.17.1
RUN set -eux; cd /tmp; \
    curl -fsSL "https://github.com/crowdsecurity/cs-openresty-bouncer/releases/download/${CS_BOUNCER_VERSION}/crowdsec-openresty-bouncer.tgz" | tar xz; \
    cd "crowdsec-openresty-bouncer-${CS_BOUNCER_VERSION}"; \
    cp -r lua/lib/* /etc/nginx/lualib/; \
    mkdir -p /var/lib/crowdsec/lua/templates; cp templates/* /var/lib/crowdsec/lua/templates/; \
    sed -e "s|\${SSL_CERTS_PATH}|/etc/ssl/certs/ca-certificates.crt|" \
        -e "s|/etc/crowdsec/bouncers/|/data/crowdsec/|" \
        openresty/crowdsec_openresty.conf > /etc/nginx/conf.d/crowdsec_openresty.conf; \
    cp config/config_example.conf /etc/nginx/crowdsec-openresty-bouncer.conf.example; \
    cd /tmp; curl -fsSL "https://github.com/ledgetech/lua-resty-http/archive/refs/tags/${LUA_RESTY_HTTP_VERSION}.tar.gz" | tar xz; \
    cp lua-resty-http-*/lib/resty/*.lua /etc/nginx/lualib/resty/; \
    rm -rf /tmp/crowdsec-openresty-bouncer-* /tmp/lua-resty-http-*; \
    grep -q "/data/crowdsec/crowdsec-openresty-bouncer.conf" /etc/nginx/conf.d/crowdsec_openresty.conf
