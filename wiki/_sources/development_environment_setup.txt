+++++++++++++++++++++++++++++++++++
Geliştirme Ortamı Kurulumu(Backend)
+++++++++++++++++++++++++++++++++++

===========
**Vagrant**
===========

Geliştiriciler için hazırladığımız vagrant box'ı kullanarak hızlıca kurulum yapabilirsiniz. Ulakbus'e ait tüm bileşenler box içinde bulunmaktadır. Ortamı kurabilmek için aşağıdaki komutları kullanabilirsiniz.

::

    mkdir ulakbus
    cd ulakbus
    wget https://raw.githubusercontent.com/zetaops/zcloud/master/development-environment/Vagrantfile
    vagrant up


Bu işlem bitince ``vagrant ssh`` komutu ile geliştirme ortamına bağlanabilirsiniz.

Bağlandıktan sonra aşağıdaki komutlarla öncelikle repoları güncelleyin.

::

     sudo su - ulakbus
     cd ulakbus
     git pull https://github.com/zetaops/ulakbus.git

Aynı yöntemle pyoko, ulakbus-ui, zengine depolarını da güncelleyin.

================
**Elle Kurulum**
================

İlk olarak bilgisayarınızı güncel hale getirin.

::

    sudo apt-get update
    sudo apt-get upgrade



Riak için dosya limitini 65536 olarak değiştirin.

``ulimit -n`` kalıcı olarak değiştirmek için;


::

    sudo vi /etc/security/limits.conf



ve aşağıdaki satırları dosyanın sonuna ekleyin.

::

    * soft nofile 65536
    * hard nofile 65536


Riak'ı ve bağımlılıklarını kurun.


::

    #Önce Riak bağımlılıklarını kurunuz.

    apt-get install libssl-dev
    apt-get install libffi-dev

::

    #Ardından Java'yı kurunuz.

    apt-add-repository ppa:webupd8team/java -y && apt-get update
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
    apt-get install -y oracle-java8-installer


::

    #Riak kurulumu

    curl -s https://packagecloud.io/install/repositories/zetaops/riak/script.deb.sh |sudo bash
    apt-get install riak=2.1.1-1


::


    # Aramayı aktifleştiriniz.

    sed -i "s/search = off/search = on/" /etc/riak/riak.conf

::

    # Riak servisini yeniden başlatın

    service riak restart

::

    # Redis-Server'ı kurunuz.

    apt-get install redis-server


Zato için tüm gerekli kurulumları gerçekleşiriniz.

::

    apt-get install apt-transport-https
    curl -s https://zato.io/repo/zato-0CBD7F72.pgp.asc | sudo apt-key add -
    apt-add-repository https://zato.io/repo/stable/2.0/ubuntu
    apt-get update
    apt-get install zato



Zato kurulumunun ardından, *zato* kullanıcısına geçiniz ve *ulakbus* adında bir dizin oluşturunuz.
::

    sudo su - zato
    mkdir ~/ulakbus





Zato Cluster oluşturunuz. Aşağıdaki komut, Sertifika, Web-Admin, Load-Balancer ve Zato server kurulumunu gerçekleştirecektir.

::

    zato quickstart create ~/ulakbus sqlite localhost 6379 --kvdb_password='' --verbose


``~/ulakbus`` klasörünün altına *pwzato.config* adında bir dosya oluşturunuz ve aşağıdaki script'i dosyanın içine yazınız.

Bu script'i kullanmak için de ``zato from-config ~/ulakbus/pwzato.config`` komutunuz çalıştırıyor olmalısınız.

::

    command=update_password
    path=/opt/zato/ulakbus/web-admin
    store_config=True
    username=admin
    password=ulakbus


Zato Servislerini başlatmak için tekrardan *root* kullanıcısına geçiniz.

Zato bileşeni için sembolik bağlantı oluşturunuz.

::

    ln -s /opt/zato/ulakbus/load-balancer /etc/zato/components-enabled/ulakbus.load-balancer
    ln -s /opt/zato/ulakbus/server1 /etc/zato/components-enabled/ulakbus.server1
    ln -s /opt/zato/ulakbus/server2 /etc/zato/components-enabled/ulakbus.server2
    ln -s /opt/zato/ulakbus/web-admin /etc/zato/components-enabled/ulakbus.web-admin



Ve Zato Servisini başlatınız.

::

    service zato start


Ulakbus uygulaması için python virtual environment hazırlayınız.

::

    apt-get install virtualenvwrapper


*app* adında bir dizin oluşturunuz ve *ulakbus* kullanıcısını *app* klasörü için ekleyin.


::

    mkdir /app
    /usr/sbin/useradd --home-dir /app --shell /bin/bash --comment 'ulakbus operations' ulakbus


Ulakbus kullanıcısına *app* klasörü için yetki verin ve ulakbus kullanıcısına geçiniz.

::

    chown ulakbus:ulakbus /app -Rf
    su ulakbus
    cd ~

Virtual Environment yaratınız ve actif ediniz.

::

    virtualenv --no-site-packages env
    source env/bin/activate

pip' yükseltin(güncelleyin) ve ipython kurulumunu gerçekleştirin.

::

    pip install --upgrade pip
    pip install ipython



Pyoko'yu https://github.com/zetaops/pyoko.git adresinden çekiniz ve gereksinimleri kurunuz.

::

    pip install riak
    pip install enum34
    pip install six

    pip install git+https://github.com/zetaops/pyoko.git


Environmet'e PYOKO_SETTINGS değişkeni ekleyiniz(*root* kullanıcısı iken)

::

    echo "export PYOKO_SETTINGS='ulakbus.settings'" >> /etc/profile



Ulakbus'u https://github.com/zetaops/pyoko.git adresinden çekiniz ve gereksinimleri kurunuz.

::

    pip install falcon
    pip install beaker
    pip install redis
    pip install passlib
    pip install git+https://github.com/didip/beaker_extensions.git#egg=beaker_extensions
    pip install git+https://github.com/zetaops/SpiffWorkflow.git#egg=SpiffWorkflow
    pip install git+https://github.com/zetaops/zengine.git#egg=zengine

    git clone https://github.com/zetaops/ulakbus.git



Ulakbus-ui'yi https://github.com/zetaops/pyoko.git adresinden çekiniz.

::

    git clone https://github.com/zetaops/ulakbus-ui.git


Ulakbus'u PYTHONPATH'a ekleyiniz.

::

    echo '/app/ulakbus' >> /app/env/lib/python2.7/site-packages/ulakbus.pth


Google kütüphanesinin çalışması için "__init__.py" adında dosya oluşturunuz(*ulakbus* kullanıcısı iken)

::

    touch /app/env/lib/python2.7/site-packages/google/__init__.py


Pyoko için *solr_schema_template* 'i indirin.(*ulakbus* kullanıcısı iken)

::

    cd ~/env/local/lib/python2.7/site-packages/pyoko/db
    wget https://raw.githubusercontent.com/zetaops/pyoko/master/pyoko/db/solr_schema_template.xml


Sembolik bağlantı oluşturunuz.(*zato* kullanıcısı iken)

::

    ln -s /app/pyoko/pyoko /opt/zato/2.0.5/zato_extra_paths/
    ln -s /app/env/lib/python2.7/site-packages/riak /opt/zato/2.0.5/zato_extra_paths/
    ln -s /app/env/lib/python2.7/site-packages/riak_pb /opt/zato/2.0.5/zato_extra_paths/
    ln -s /app/env/lib/python2.7/site-packages/google /opt/zato/2.0.5/zato_extra_paths/
    ln -s /app/env/lib/python2.7/site-packages/passlib /opt/zato/2.0.5/zato_extra_paths/


Bucket-type türünde modeller oluşturunuz ve aktif ediniz.(*root* kullanıcısı iken)

::

    riak-admin bucket-type create models '{"props":{"last_write_wins":true, "allow_mult":false}}'
    riak-admin bucket-type activate models


Aşağıdaki komutlar yardımı ile şemaları güncelleyin.(*ulakbus* kullanıcısı iken)
::

    source env/bin/activate
    cd ~/ulakbus/ulakbus
    python manage.py update_schema --bucket all


Server'ı 8000(default) portunda çalıştırınız.

::

    python runserver.py