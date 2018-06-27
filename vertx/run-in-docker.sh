adduser --disabled-password --gecos "" --no-create-home demo
chown -R demo:demo /home/demo
su -c "mvn clean package exec:exec -Dssl.home=/ssl/ $*" demo
