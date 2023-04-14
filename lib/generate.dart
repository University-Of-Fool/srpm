import 'package:srpm/data_process.dart';

String makeSslConfig(Target target) {
  return """
# This block is auto-generated using srpm
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name ${target.sourceDomain};

    ssl_certificate "${target.sslCert}";
    ssl_certificate_key "${target.sslCertKey}";
    ssl_session_cache shared:SSL:1m;
    ssl_session_timeout 10m;
    ssl_ciphers PROFILE=SYSTEM;
    ssl_prefer_server_ciphers on;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    location / {
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host ${target.sourceDomain};
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header Range \$http_range;
        proxy_set_header If-Range \$http_if_range;
        proxy_redirect off;
        proxy_pass ${target.targetAddress};
        # the max size of file to upload
        client_max_body_size 20m;
    }
}
""";
}

String makePlainConfig(Target target) {
  return """
# This block is auto-generated using srpm
server {
    listen 80;
    listen [::]:80;
    server_name ${target.sourceDomain};
    location / {
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host ${target.sourceDomain};
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header Range \$http_range;
        proxy_set_header If-Range \$http_if_range;
        proxy_redirect off;
        proxy_pass ${target.targetAddress};
        # the max size of file to upload
        client_max_body_size 20m;
    }
}
""";
}
