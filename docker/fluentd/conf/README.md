

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

now restart fluentd and drop some easily searchable test messages into syslog
```shell script
docker-compose stop fluentd && docker-compose up -d fluentd
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



#### docker/fluentd/conf/nginx_access_json.conf

This config uses the http input and loads the contents of the sample nginx access of file in json format

It uses the read_from_head and comments out the pos_file option so the whole file is loaded when fluentd starts.

The parsing seciton is just json, but it specifics the seconds format for time and the time_key

nginx doens't emit json by default, but versions1.11.8+ can be configured to emit json as in the example we used.

NOTE: we had to match the time format and time_key

```
    log_format json_combined escape=json
      '{'
        '"msec":"$msec",'
        '"remote_addr":"$remote_addr",'
        '"remote_user":"$remote_user",'
        '"request":"$request",'
        '"status": "$status",'
        '"body_bytes_sent":"$body_bytes_sent",'
        '"request_time":"$request_time",'
        '"http_referrer":"$http_referer",'
        '"http_user_agent":"$http_user_agent"'
      '}';


    access_log  /var/log/nginx/access.log  json_combined;
```
 
 The sample data is between 4 and 6 am on Oct 11, 2020

 To use thus config:
 

copy the config file:
```shell script
cp docker/fluentd/conf/nginx_access_json.conf docker/fluentd/conf/fluent.conf
```


The file shoudl already be mounted to /tmp/nginx_access_log_json
```yaml
  fluentd:
    build: ./docker/fluentd
    environment:
      TZ: "America/New_York" # CRITICAL!  fluentd uses localtime as default
    volumes:
      - "./docker/fluentd/conf/fluent.conf:/fluentd/etc/fluent.conf:rw"
#      - "./docker/fluentd/sample_data/syslog:/tmp/syslog:ro"
      - "/var/log/syslog:/tmp/syslog:ro"
      - "./docker/fluentd/sample_data/nginx_access_log_json:/tmp/nginx_access_log_json:ro"
#      - "/var/log/syslog:/tmp/syslog:ro"
```

now restart fluentd:
```shell script
docker-compose stop fluentd && docker-compose up -d fluentd

```