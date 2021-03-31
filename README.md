
# ShopInvader Kubernetes

## context

Set of helm packages that will allows you to deploy in production or in developpement context a working shop invader

## Overview

### Shopinvader


![shopinvader overview](doc/images/argo_shopinvader.png)

The service is composed of :
* a deployment
* a service that point statically to shopinvader-service
* a mono container pod
* a scerect definition who allows to store uri to mongodb

In the value file you will find following environment parameters:
``` yaml
envValues:
# rails env
  railsEnv: production
# Enables self registration on Locomotive admin backend.
  locomotiveEnableRegistration: "true"
# Force redirection of admin backend to HTTPS.
  locomotiveAdminSSLRedirect: "false"
# rails will serve static file instead of cache system
  railsServeStaticFiles: "true"
# Dev host only works with development rails env
  mongodbDevHost: "mongodb-service"
# if activated it will redirect content to the cdn
# only works with production rails_env
  cdnAssetHost: url
```

The secret are define as follwing:
``` yaml

data:
# a secret generated with rake or ruby SecureRandom.hex(10)
  SECRET_KEY_BASE: a secret
# a secret generated with rake or ruby SecureRandom.hex(10)
  DRAGON_FLY_SECRET: an other secret
# a peper to add to salt
  DEVISE_PEPPER: TGEgdmllIGVuIHJvc2UK
# a mongo uri. Only works if rails env is production
# the format is mongodb://username:password@host:port
  mongo-root-uri: bW9uZ29kYjovL3Nob3BfaW52YWRlcjp0b3RvQG1vbmdvZGItc2VydmljZToyNzAxNwo=
```

to acess the service use `minikube service --url shopinvader-service`

### Elastic search


![elastic overview](doc/images/argo_elasticsearch.png)

The service is composed of :
* a Sateful set
* a service that point statically to elasticsearch-service
* a mono container pod
* a host shared volume that mount /usr/share/elasticsearch/dataa to the node /data/elastic

that service is intended for development only

the default ports are internally defined like that
``` yaml
        ports:
        - containerPort: 9200
          name: client
        - containerPort: 9300
          name: nodes
```

There are no particular sercret defined.
There are no particular env values defined.

Watchout by default we have setup the following security context:
``` yaml

securityContext:
   runAsUser: 0
   runAsGroup: 0
   fsGroup: 0
```

It is due to an bug in minikube and similar setup with host shared volume

Also you may have to do a minikube ssh and chmod/chown /data/elastic


### Mongo DB


![mongodb overview](doc/images/argo_mongodb.png)

The service is composed of :
* a deployment (basic sharding is not configure)
* a service that point statically to mongodb-service
* a 2 container pod one containing mongdb and one containg mongodb express
* Volume are not set yet

that service is intended for development only

the default ports are internally defined like
``` yaml
  ports:
  # mongo db port to connect to internally
      port: 27017
  # mongo-express port to connect internally
      port: 8081

```

The following secret are defined:

``` yaml

data:
# root user name set at startup
  mongo-root-username: a user
# root user password
  mongo-root-password: a password
```

if you do a
``` bash
 minikube service --url mongodb-service
http://192.168.99.100:30565
http://192.168.99.100:31442
```

you will have an access to the monged service and the mongo-express UI

![mongo ui](doc/images/mongo_express_ui.png)

The service has no persitent storage yet.

### Kibana


![shopinvader kibana overview](doc/images/argo_kibana.png)

That is a service that is used to debug the content of the elastic search used by shop invader during development

The service is composed of :
* a deployment
* a service that point statically to shopinvader-kibana-service
* a mono container pod

In the value file you will find following environment parameters:
``` yaml
envValues:
# the uri to the elastic search only the service in the composition
# does not support security
  elasticURI: http://elasticsearch-service:9200
```
to acess the service use `minikube service --url shopinvader-kibana-service`


# Setup and deploy
TODO