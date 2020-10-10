

#### docker/fluentd/conf/http_lsl_to_es.conf

This config uses the http input and reads the live syslog file from the docker host via a volume mapping. It dumpe messages to stdout and to elasticsearch

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

This config uses the http input and loads the contents of the sample syslog file: docker/fluentd/sample_data/syslog 

It uses the read_from_head and comments out the pos_file option so the whole file is loaded when fluentd starts. The data is 7AM to 8AM on 10/3/2020 so you won't see anything unless your search range goes back that far -  or just replace the file with more recent static data.

 To use thus config:
 


copy the config file:
```shell script
cp docker/fluentd/conf/http_sample_to_es.conf docker/fluentd/conf/fluent.conf

```
and change the docker-compose mount to point to the live syslog
```yaml

  fluentd:
    build: ./docker/fluentd
    environment:
      TZ: "America/New_York" # CRITICAL!  fluentd uses localtime as default
    volumes:
      - "./docker/fluentd/conf/fluent.conf:/fluentd/etc/fluent.conf:rw"
      - "./docker/fluentd/sample_data/syslog:/tmp/syslog:ro"
#      - "/var/log/syslog:/tmp/syslog:ro"
```

now restart fluentd:
```shell script
docker-compose stop fluentd && docker-compose up -d fluentd

```