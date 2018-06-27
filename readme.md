# HTTP/2 demo

Ce repository rassemble des exemples d'implémentation de HTTP/2. 
Il sert pour les démonstrations de la présentation [HTTP/2 en pratique](http://prez.sewatech.fr/http2/).
Elle ont été conçues pour fonctionner sous Linux.

## Initialisation

Tous les exemples s'appuient sur des conteneurs docker, qui utilisent un réseau dédié.

Ce réseau est initialisé par le script scripts/init-network.sh.

Pour finaliser la configuration, il faut ajouter ces 3 lignes dans /etc/hosts :

```
172.44.0.99     slide.server
172.44.0.100    demo.server
172.44.0.101    demo.proxy
```

## Demo #0 : multiplexing

Cette démonstration préliminaire est intégrée aux slides.
Il faut donc lancer le serveur avant la présentation.

```
./scripts/run-httpd-slide.sh
```

Résumé :

* hostname : slide.server
* port 8001 : HTTP/1.x, sans TLS
* port 8003 : HTTP/2, TLS

## Demo #1 : nghttp2

Le but de cette démo est de montrer qu'en démarrant un serveur sans TLS, on peut lui envoyer des requêtes en ligne de commande, mais pas depuis un navigateur.
C'est une introduction à h2 avec ALPN et h2c en accès direct ou par upgrade.

C'est la seule démo sans docker.

Serveur :

```
nghttpd --no-tls -d ./images/80 8888
```

Client :

```
nghttp http://localhost:8888/hello
```

Par contre, en appelant cette URL depuis Chrome, ça ne marche pas.

## Demo #2 : Apache HTTP Server

Le but de cette démo est de montrer la simplicité d'implémentation d'HTTP/2 dans httpd.

Démarrer le serveur :

```
./scripts/run-httpd.sh
```

Depuis Chrome, on accède au port 8001 (http://demo.server:8001/).
Dans les dev tools, on voit que c'est un accès en HTTP/1.x.

Puis on accède au port 8002 (http://demo.server:8002/).
C'est aussi de l'HTTP/1.x.
En effet, il n'y a pas d'upgrade car le client ne supporte pas h2c.
Si on avait testé avec Nginx, ça n'aurait pas mamrché du tout car il ne supporte que h2c-direct.

Enfin, on accède au port 8003 (https://demo.server:8003/), en HTTP/2.

*Résumé* :

* hostname : demo.server
* port 8001 : HTTP/1.x
* port 8002 : HTTP/2, h2c
* port 8003 : HTTP/2, h2

## Demo #3 : Java

On commence par démarrer Tomcat 9 avec Java 8 :

```
./scripts/run-tomcat.sh 8
```

Pas besoin de tester le port 8001, il sera forcément en HTTP/1.x.
Idem pour le port 8002.
Pour le port 8003, on reste aussi en HTTP/1.x, mais cette fois-ci c'est à cause du serveur qui ne supporte pas ALPN.
Les ports 8004 et 8005 sont bien en HTTP/2 car le TLS est géré par OpenSSL.

On redémarre Tomcat 9 avec Java 9 :

```
./scripts/run-tomcat.sh 9
```

Maintenant le port 8003 est bien en HTTP/2.

*Résumé* :

* hostname : demo.server
* port 8001 : HTTP/1.x
* port 8002 : HTTP/2, h2c
* port 8003 : HTTP/2, h2 avec JSSE
* port 8004 : HTTP/2, h2 avec OpenSSL
* port 8005 : HTTP/2, h2 avec APR/OpenSSL

## Demo #4 : Push

Depuis le même serveur, on appelle la JSP au lieu de la page HTML, pour voir le push (https://demo.server:8003/push.jsp).
Normalement, lorsqu'on accède à la page par un port HTTP/2, dev tools doit indiquer dans la colonne _initiator_ que les images sont récupérées par push.

NOTE: l'information du push n'apparait pas dans Chrome 65.

## Demo #5 : Reverse Proxy

A cette étape, on conserve notre serveur Tomcat sur demo.server auquel on accèdera via un reverse proxy httpd :

```
./scripts/run-httpd-proxy.sh
```

L'URL la plus intéressante est https://demo.proxy:8003/h2/push.jsp car bien qu'on soit en HTTP/2 de bout en bout, 
le push de la JSP ne marche plus.
C'est dû au fait que le mod_proxy_http2 désactive le push dans le frame de settings.

*Résumé (réseau)* :

* hostname : demo.proxy
* port 8001 : HTTP/1.x
* port 8002 : HTTP/2, h2c
* port 8003 : HTTP/2, h2

*Résumé (reverse proxy)* :

* https://demo.proxy:8003/ : HTTP/1
* https://demo.proxy:8003/tls : HTTP/1, TLS
* https://demo.proxy:8003/h2 : HTTP/2, h2
* https://demo.proxy:8003/h2c : HTTP/2, h2c

Références :
* http://httpwg.org/specs/rfc7540.html#SETTINGS

## Autre demo

**NodeJS**

```
./scripts/run-node.sh
```

* hostname : demo.server
* port 8001 : HTTP/1.x
* port 8002 : HTTP/2 h2c, uniquemement en direct sans fallback HTTP/1
* port 8003 : HTTP/2 h2

**Vert.x**

```
./scripts/run-vertx.sh
./scripts/run-vertx.sh 8
```

NOTE: ne marche pas avec Java 9, à cause d'un bug dans l'image Docker ; par contre en Java 10, ça marche

* hostname : demo.server
* port 8001 : HTTP/1.x
* port 8002 : HTTP/2 h2c, uniquement en direct avec fallback HTTP/1
* port 8003 : HTTP/2 h2

**nginx**

```
./scripts/run-nginx.sh
```

* hostname : demo.server
* port 8001 : HTTP/1.x
* port 8002 : HTTP/2 h2c, uniquement en direct sans fallback HTTP/1
* port 8003 : HTTP/2 h2
* https://demo.server:8003/push : HTTP/2 avec push

**Akka HTTP**

_WIP_

```
./scripts/run-akka-http.sh
```

* hostname : demo.server
* port 8001 : HTTP/1.x
* port 8002 : rien, h2c n'est pas supporté
* port 8003 : HTTP/2 h2
* HTTP/2 n'est qu'en preview pour akka-http 10.1
