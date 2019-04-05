upstream concierge {
  server localhost:280;
}

upstream couchdb {
  server couch:5984;
}

upstream medic-api {
  server medic:5988;
}

server {
    listen 80;
    server_name _;
    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;

    gzip                on;
    gzip_disable        "msie6";
    gzip_vary           on;
    gzip_proxied        any;
    gzip_comp_level     6;
    gzip_buffers        16 8k;
    gzip_http_version   1.1;

    gzip_types                  text/plain text/css text/csv text/xml text/javascript
                                application/json application/x-javascript application/xml
                                application/vnd.ms-fontobject application/octet-stream
                                application/x-font-woff multipart/related image/svg+xml;

    # Prevent "clickjacking" attacks:
    #   This disallows external sites from embedding any of our pages in
    #   an <iframe>. Since medic-reporter currently uses an <iframe>, we've
    #   set the value to SAMEORIGIN instead of DENY. If we ever stop using
    #   <iframes>s, we should probably switch this back to DENY.

    add_header X-Frame-Options  SAMEORIGIN;

    location = / {
        proxy_pass              http://concierge;
        error_page              502 503 504 = @app-redirect;
        proxy_set_header        Host  $host;
        proxy_set_header        X-Real-IP  $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto https;
    }

    location @app-redirect {
        return 302 /medic/_design/medic/_rewrite;
    }

    location ~ ^/_utils/(.*) {
        deny all;
    }

    location / {
        proxy_pass              http://concierge;
        error_page              502 503 504 = @fallback;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto http;
    }

    location @fallback {
        proxy_pass              http://medic-api;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto http;
    }

    location /dashboard {
        proxy_pass              http://concierge;
        error_page              502 503 504 = @fallback;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto http;
    }

    location /_users {
        proxy_pass              http://concierge;
        error_page              502 503 504 = @fallback;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto http;
    }

    location /_log {
        proxy_pass              http://concierge;
        error_page              502 503 504 = @fallback;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto http;
    }

    location /_replicate {
        proxy_pass              http://concierge;
        error_page              502 503 504 = @fallback;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto http;
    }

    location /db {
      proxy_pass              http://couchdb;
      error_page              502 503 504 = @fallback;
      proxy_set_header        Host            $host;
      proxy_set_header        X-Real-IP       $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto http;
    }

    error_page   500 502 503 504  /50x.html;

    location = /50x.html {
        root html;
    }
}
