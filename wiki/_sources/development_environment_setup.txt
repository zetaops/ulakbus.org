+++++++++++++++++++++++++++++++++++
Geliştirme Ortamı Kurulumu(Backend)
+++++++++++++++++++++++++++++++++++

Kullanıcılar, kuruluma başlamadan önce Ubuntu işletim sistemini kullanmalıdır. Biz, işletim sistemi olarak Ubuntu 14.04 kullanıyoruz.

===========
**Vagrant**
===========

Vagrant Nedir?
--------------

Vagrant'la ilgili başlıca bilgilere aşağıdaki linklerden ulaşabilirsiniz:

https://scotch.io/tutorials/get-vagrant-up-and-running-in-no-time

http://www.cyberciti.biz/cloud-computing/use-vagrant-to-create-small-virtual-lab-on-linux-osx/

Geliştiriciler için hazırladığımız vagrant box'ı kullanarak hızlıca kurulum yapabilirsiniz. Ulakbus'e ait tüm bileşenler box içinde bulunmaktadır. Ortamı kurabilmek için aşağıdaki komutları kullanabilirsiniz.

::

    mkdir ulakbus
    cd ulakbus
    vagrant init zetaops/ulakbus

Bu komutlar vagrantfile dosyası yaratır. Bu dosyayı açıp RAM'ı 2 GB yapmanızı öneririz. Ancak bu işlemle kendiniz uğraşmak istemiyorsanız aşağıdaki işlemi yapabilirsiniz:


::

    wget https://raw.githubusercontent.com/zetaops/ulakbus-development-box/master/Vagrantfile.sample

Bu komut bulunduğunuz dizine örnek bir Vagrantfile indirecektir. İhtiyaçlarınıza uygun şekilde düzenleyip kullanabilirsiniz.

Vagrantfile'ı düzenledikten sonra:


::

    vagrant up

komutuyla makinenizi başlatabilirsiniz.

Bu işlem bitince ``vagrant ssh`` komutu ile geliştirme ortamına bağlanabilirsiniz.


``Eğer depolarınızı sanal makinaya mount ederek dışardan paylaşıyorsanız, git ile ilgili işlemleri ana makinada yapmanızı öneriyoruz.``

Bizim sunduğumuz Vagrantbox'ta, git depoları sanal makina içerisinde yer almaktadır. Git depolarının host makine
üzerinde saklanması ve sanal makineye bağlanarak kullanılması, Vagrantbox'ın güncellenmesi, kaldırılması gibi işlemlerde
veri kayıplarının önüne geçecektir.

Yukarıda verilen örnek Vagrantfile içerisinde, kod depolarınızın sanal makineye bağlanmak üzere nasıl konfigüre
edileceği bulunmaktadır. Kısaca

::

  # ulakbus
   config.vm.synced_folder "/home/yerel_makinadaki_benim_adim/zetaops/repos/github/ulakbus", "/app/ulakbus", owner: "ulakbus", group: "ulakbus"

  # zengine
   config.vm.synced_folder "/home/yerel_makinadaki_benim_adim/zetaops/repos/github/zengine", "/app/zengine", owner: "ulakbus", group: "ulakbus"

  # pyoko
   config.vm.synced_folder "/home/yerel_makinadaki_benim_adim/zetaops/repos/github/pyoko", "/app/pyoko", owner: "ulakbus", group: "ulakbus"

  # ulakbus-ui
   config.vm.synced_folder "/home/yerel_makinadaki_benim_adim/zetaops/repos/github/ulakbus-ui", "/app/ulakbus-ui", owner: "ulakbus", group: "ulakbus"


Geliştirme Sanal Makinasının Güncellenmesi
------------------------------------------

- Ulakbus klasörü içine gidin. Klasörde Vagrantfile bulunduğundan emin olun.
- Sürüm kontrolü yapın

::

  vagrant box outdated

Eğer sanal makina sürümü eski ise aşağıdaki gibi bir mesaj alacaksınız.

::

  A newer version of the box 'zetaops/ulakbus' is available! You currently
  have version '0.1.9'. The latest is version '0.2.2'. Run
  `vagrant box update` to update.

Gene ulakbus klasörü içindeyken

::

  vagrant box update

komutu güncelleme işlemini yapacaktır.

Kontrol edilmesi gereken servisler
----------------------------------

Vagrant sanal makinasına ```vagrant ssh``` ile bağlandıktan sonra, aşağıdaki servislerin çalıştığından emin olunuz.

::

  sudo su
  service redis-server status
  service riak ping
  service zato status

ulakbus kullanıcısına ait klasör altında aşağıdaki alt klasörler yer almaktadır.

::

  pyoko  pyokoenv  pyoko_postactivate  ulakbus  ulakbusenv  ulakbus_postactivate  ulakbus-ui  zengine  zengineenv  zengine_postactivate

ulakbus projesi ile çalışmak için 

::

  source ulakbusenv/bin/activate

Virtualenv aktif hale getiriniz. 

::

  (ulakbusenv)ulakbus@ulakbus:~$

yukarıdaki komut satırını gördüğünüzde virtualenv set edilmiş demektir. virtualenv hakkında detaylı bilgi için:

   http://istihza.com/forum/viewtopic.php?t=2164

   http://docs.python-guide.org/en/latest/dev/virtualenvs/

daha sonra **ipython** komutu ile konsolda çalışmalar yapabilirsiniz. 


(env)ulakbus@ulakbus:~/ulakbus/ulakbus$ dizini altında iken 


export ALLOWED_ORIGINS="http://localhost:8000"

python manage.py migrate --model all

bu işlem uzun sürecektir. 

**  Tüm modeller en son hallerine güncellenecektir. Geliştirme esnasında modellere yapılan değiştirme, silme v.b işlemlerden sonra mutlaka yapılması gerekmektedir.


Permission listesini güncelle.

(ulakbusenv)ulakbus@ulakbus:~/ulakbus/ulakbus$ python manage.py update_permissions

Yeni bir super user ekleyiniz. Sisteme girişi bu kullanıcı yapacaktır. 

python manage.py create_user --username ulakbus --password 123 --super


Son olarak 

(ulakbusenv)ulakbus@ulakbus:~/ulakbus/ulakbus$ python manage.py runserver --addr 0.0.0.0

şeklinde backendi çalıştırınız. 



Frontend ile backendi çalıştırmak
----------------------------------


https://github.com/zetaops/ulakbus-ui

adresinden frontend kısmını bilgisayarınızda bir dizine klonlayınız.

 ulakbus-ui/dist dizinine geçerek bu dizin altında:

 python -m SimpleHTTPServer

 komutu ile frontendi başlatınız. Bu komutla localhost:8000 portunda frontend çalışmaya başlayacaktır.


Frontend ilk kez browser ile çağrıldığında backendin adresini aşağıdaki gibi bildiriniz.

http://localhost:8000/?backendurl=http://localhost:9001/


Bu şekilde login ekranına ulaşabileceksiniz. 

Herhangi bir sebepten backend adres ve port bilgisi değiştirmek için menüdeki Ayarlar (Dev)
altındaki Backend Url: alanına 

http://localhost:9001/ 

şeklinde yazabilirsiniz.  



Geliştirme İçin Editör Ayarlanması
----------------------------------

Python ile geliştirme yaparkan değişik `IDE'ler <https://wiki.python.org/moin/IntegratedDevelopmentEnvironments>`_ kullanabilirsiniz. Ulakbüs geliştirmesi yaparken `PyCharm <https://www.jetbrains.com/pycharm/>`_ kullanıyor ve şiddetle öneriyoruz.
Öğrenciler ve AKK projeler için özel lisanslar sunan PyCharm sayesinde ücretsiz olarak kullanabilirsiniz.

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

Ve aşağıdaki satırları dosyanın sonuna ekleyin.

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

Zato için tüm gerekli kurulumları gerçekleştiriniz.

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

Bu script'i kullanmak için de ``zato from-config ~/ulakbus/pwzato.config`` komutunu çalıştırıyor olmalısınız.

::

    command=update_password
    path=/opt/zato/ulakbus/web-admin
    store_config=True
    username=admin
    password=ulakbus

Zato servislerini başlatmak için tekrardan *root* kullanıcısına geçiniz.

Zato bileşeni için sembolik bağlantı oluşturunuz.

::

    ln -s /opt/zato/ulakbus/load-balancer /etc/zato/components-enabled/ulakbus.load-balancer
    ln -s /opt/zato/ulakbus/server1 /etc/zato/components-enabled/ulakbus.server1
    ln -s /opt/zato/ulakbus/server2 /etc/zato/components-enabled/ulakbus.server2
    ln -s /opt/zato/ulakbus/web-admin /etc/zato/components-enabled/ulakbus.web-admin

Ve Zato servisini başlatınız.

::

    service zato start

Ulakbus uygulaması için python virtual environment hazırlayınız.

::

    apt-get install virtualenvwrapper

*app* adında bir dizin oluşturunuz ve *ulakbus* kullanıcısını *app* klasörü içine ekleyin.


::

    mkdir /app
    /usr/sbin/useradd --home-dir /app --shell /bin/bash --comment 'ulakbus operations' ulakbus

Ulakbus kullanıcısına *app* klasörü için yetki verin ve ulakbus kullanıcısına geçiniz.

::

    chown ulakbus:ulakbus /app -Rf
    su ulakbus
    cd ~

Virtual Environment yaratınız ve aktif ediniz.

::

    virtualenv --no-site-packages env
    source env/bin/activate

pip yükseltin(güncelleyin) ve ipython kurulumunu gerçekleştirin.

::

    pip install --upgrade pip
    pip install ipython

Pyoko'yu https://github.com/zetaops/pyoko.git adresinden çekiniz ve gereksinimleri kurunuz.

::

    pip install riak
    pip install enum34
    pip install six

    pip install git+https://github.com/zetaops/pyoko.git

Environment'a PYOKO_SETTINGS değişkeni ekleyiniz(*root* kullanıcısı iken)

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

    python runserver.py --help
    usage: manage.py [-h]
     {runserver,migrate,flush_model,update_permissions,create_user}
      ...

    optional arguments:
    -h, --help            show this help message and exit

    Possible commands:
    {runserver,migrate,flush_model,update_permissions,create_user}
    runserver           Run the development server
    migrate             Creates/Updates SOLR schemas for given model(s)
    flush_model         REALLY DELETES the contents of buckets
    update_permissions  Syncs permissions with DB
    create_user         Creates a new user

Uygulamayı geliştirmeye devam etmek için http://www.ulakbus.org/wiki/zengine-ile-is-akisi-temelli-uygulama-gelistirme.html sayfasına göz atabilirsiniz.
