

#### docker/fluentd/conf/http_lsl_to_es.conf

This config uses the http input and reads the live syslog file from the docker host via a volume mapping. My host is ubuntu 2020.4 and the timezone is not in the RFC3164 syslog format so fluentd uses the local timezome as the default. The local timezone is the docker container timezone, so it's important that I configure docker compose so the container timezone is the same as my host timezone or things get confusing


to use this config:

copy the config file:
```shell script
cp docker/fluentd/conf/http_lsl_to_es.conf docker/fluentd/conf/fluent.conf

# make the syslog file world readable
sudo chmod 755 /var/log/syslog
```
and change the docker-compose mount to point to the live syslog
```yaml

  fluentd:
    build: ./docker/fluentd
    environment:
      TZ: "America/New_York" # CRITICAL!  fluentd uses localtime as default
    volumes:
      - "./docker/fluentd/conf/fluent.conf:/fluentd/etc/fluent.conf:rw"
#      - "./docker/fluentd/sample_data/syslog:/tmp/syslog:ro"
      - "/var/log/syslog:/tmp/syslog:ro"
```

now restart everything and drop some easily searchable test messages into syslog
```shell script
make restart
logger "generous carrots-1"
logger "generous carrots-2"
logger "generous carrots-3"
```


#### docker/fluentd/conf/http_sample_to_es.conf