++++++++++++++++
RIAK KV Kurulumu
++++++++++++++++
Riak production ortamında en az 5 node, mümkünse 7 node çalışması önerilen dağıtık bir veritabanı sistemidir.
Belli başlı özellikleri ve avantajları şu bağlantıdan okunabilir:

http://www.ulakbus.org/wiki/yazilim_tasarim_analizi_belgesi.html#riak

Bu dökümanda 5 node riak ve yük dengelemek için haproxy kurulum ve konfigürasyonu anlatılacaktır.

5 makinada üzerinde başka bir uygulama kurulmamış bulunan Ubuntu 14.10 (trusty) dağıtımının kurulu olduğu varsayılmıştır. 

Kurulum için tavsiyemiz en az 2 CPU/VCPU ile 8 GB RAM bulunan sanal ya da gerçek sunucular kullanmanız yönündedir.

Bu kurulumu, geliştirme ortamınız için, 1 CPU ve 1 GB RAM ile 3 node olarak VirtualBox veya benzeri bir sanallaştırma ortamı üzerinde yapabilirsiniz.

Ön Hazırlıklar
--------------
Öncelikle her bir makinenin hostname ve IP adreslerinin düzgün şekilde ayarlandığından emin olalım. Bizim örneğimizde
IP adresleri ve hostnamelerin şu şekilde olduğu kabul edilmiştir.
::

   10.0.0.10    node1.example.org
   10.0.0.11    node2.example.org
   10.0.0.12    node3.example.org
   10.0.0.13    node4.example.org
   10.0.0.14    node5.example.org

Hostname ayarlamak için
::

   # sudo hostnamectl set-hostname node1

komutunu kullanabilirsiniz.

Fully qualified domain name için de /etc/hosts dosyasına aşağıdaki gibi bir girdiyi eklememiz gerekmektedir.
::

   # sudo vim /etc/hosts

   ...
   10.0.0.10   node1.example.org   node1

İlgili değişikliği yaptıktan sonra
::

   $ hostname -f

çıktısınının ``node1.example.org`` şeklinde alan adı ve hostname ile birlikte olduğundan emin oluyoruz.

Bu işlemleri yaptıktan sonra eğer sisteminizde yoksa bazı yardımcı paketlerin kurulması gereklidir:
::

   apt-get install -y curl wget


Java Kurulumu
-------------
Riak Search için java gerekmektedir. Aşağıdaki komutlarla sistemimize Java kuruyoruz.
::

   apt-get update -qq && apt-get install -y software-properties-common && \
        apt-add-repository ppa:webupd8team/java -y && apt-get update -qq && \
        echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
        apt-get install -y oracle-java8-installer

Kurulumu aşağıdaki komut ile doğrulayabiliriz:
::

   $ java -version
   java version "1.8.0_60"
   Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
   Java HotSpot(TM) 64-Bit Server VM (build 25.60-b23, mixed mode)

Riak Kurulumu
-------------
Riak kurulumu birkaç yol ile yapılabilir. Kaynak kod derlemek bunlardan birisidir. Fakat bu pek pratik değildir. Biz
kaynak koddan kendimiz derleyerek elde ettiğimiz deb paketlerini kullanacağız. Packagecloud.io da tuttuğumuz paketleri
sisteminize yüklemek için
::

   $ curl -s https://packagecloud.io/install/repositories/zetaops/riak/script.deb.sh | sudo bash
   $ apt-get install -y riak

komutlarını kullanabilirsiniz.

Riak'ın düzgün çalışabilmesi için dosya limitlerini değiştirmemiz gerekmektedir. Bunu kalıcı şekilde yapmak için
::

   echo '* soft nofile 65536' >>   /etc/security/limits.conf
   echo '* hard nofile 65536' >>   /etc/security/limits.conf
   echo "session required        pam_limits.so" >> /etc/pam.d/common-session-noninteractive
   echo "session required        pam_limits.so" >> /etc/pam.d/common-session

komutlarını kullanabilirsiniz.

Riak kurulumunu

::

    $ sudo riak-admin status
    Node is not running!

komutuyla doğrulayabilirsiniz.

Paketlerin kurulumunun ardından riak servisi başlamayabilir. Bu durumda yukarıdaki gibi ``Node is not running!`` çıktısı
alırsınız. Servisi başlatmak için
::

   $ sudo service riak start

komutunu kullanabilirsiniz. Bu komut hiçbir çıktı üretmeyebilir. Servisin başladığından emin olmak için yeniden
::

    $ riak-admin status
    1-minute stats for 'riak@127.0.0.1'
    -------------------------------------------
    connected_nodes : []
    consistent_get_objsize_100 : 0
    consistent_get_objsize_95 : 0
    consistent_get_objsize_99 : 0
    consistent_get_objsize_mean : 0
    consistent_get_objsize_median : 0
    ....

komutunu çalıştırabiliriz. Eğer riak çalıştıysa, konfigürasyonuyla ilgili oldukça uzun bir çıktı üretecektir.

Riak'ın üzerinde çalışacağı sistemin performansı ile ilgili daha birçok parametre vardır. Oldukça detaylı bu
ayarlar ayrı bir belgede ele alınacaktır. Başlangıç için bu düzenlemeler yeterlidir ve Riak kararlı şekilde çalışabilir.


Riak Konfigürasyonu
-------------------
Riak standart bir kurulumda /etc/riak dizini altındaki riak.conf dosyası ile konfigüre edilir. Bazı özellikler ise hala
eski tip konfigürasyon dosyaları olan advanaced.config ve app.config dosyaları ile yapılır. Riak başlama esnasında bu
dosyalara bakıp validasyon yapar ve tek bir nihayi konfigürasyon üretir. Dolayısı ile bu dosyalarda yapılacak her
değişikliğin ardından riak servisi yeniden başlatılmalıdır.
::

   sudo service riak restart

komutuyla Ubuntu üzerinde Riak servisini yeniden başlatabilirsiniz.

Konfigürasyon için ilk adım nodename değiştirmektir. riak.conf içindeki ``nodename = riak@127.0.0.1`` değerini ``nodename = riak@10.0.0.10`` şeklinde makine IP adresi ile değiştirmek gerekir. Bunu bir editör yardımı ile
yapabilirsiniz. Ya da basitçe aşağıdaki komut ile de ilgili değişikliği yapabilirsiniz.
::

   sed -i.bak "s/riak@127.0.0.1/riak@10.0.0.10/" /etc/riak/riak.conf

Riak servislerinin bağlandığı IP adreslerini de düzenlememiz gerekmektedir. Farklı bir hosttan haproxy ile erişeceğimiz
bu servislerin bağlandığı IP adresleri host makinenin IP adresi 10.0.0.10 veya 0.0.0.0 şeklinde ayarlanabilir. Bu amaçla
riak.conf dosyasındaki
::

   listener.http.internal = 127.0.0.1:8098
   listener.protobuf.internal = 0.0.0.0:8087

değerleri
::

   listener.http.internal = 10.0.0.10:8098
   listener.protobuf.internal = 10.0.0.10:8087

şeklinde değiştirilmelidir.

Riak Search için yine riak.conf dosyasındaki ``search = off`` değerini ``search=on`` şeklinde değiştirmemiz gereklidir.

Bu değişikliklerin ardından riak servisi yeniden başlatılmalıdır.

Buraya kadar yapılan işlemler 5 node için tekrar edilmelidir.

Cluster Oluşturma
-----------------
5 node düzgün bir şekilde yapılandırıldıktan sonra Riak nodelar cluster olmak için hazırdır. Cluster oluşturmak için bir
node seçilmeli ve diğer nodelardan bu node'a clustera katılma isteği gönderilmelidir.

Birinci node'u (10.0.0.10) seçtiğimizi varsayarsak diğer nodelarda sırayla
::

   riak-admin cluster join riak@10.0.0.10

komutu çalıştırılır.


Diğer 4 node'da bu komut sırayla çalıştırılır. Cluster'a katılma talebi başarıyla gerçekleştiyse şöyle bir mesaj ile
karşılaşırız:
::

   Success: staged join request for 'riak@10.0.0.11' to 'riak@10.0.0.10'

Bütün nodlarda başarıyla cluster katılım talebini yaptıktan sonra, herhangi bir node'da sırasıyla şu komutlar
çalıştırılarak yeni cluster değişiklikleri uygulanır:
::

   riak-admin cluster plan
   riak-admin cluster commit

Birinci komut cluster ile ilgili yeni değişiklikleri bize gösterir. Bu komutun çıktısı aşağıdaki gibidir:
::

    =============================== Staged Changes ================================
    Action         Nodes(s)
    -------------------------------------------------------------------------------
    join           'riak@10.0.0.10'
    join           'riak@10.0.0.10'
    join           'riak@10.0.0.10'
    join           'riak@10.0.0.10'
    -------------------------------------------------------------------------------


    NOTE: Applying these changes will result in 1 cluster transition

    ###############################################################################
                             After cluster transition 1/1
    ###############################################################################

    ================================= Membership ==================================
    Status     Ring    Pending    Node
    -------------------------------------------------------------------------------
    valid     100.0%     20.3%    'riak@10.0.0.10'
    valid       0.0%     20.3%    'riak@10.0.0.11'
    valid       0.0%     20.3%    'riak@10.0.0.12'
    valid       0.0%     20.3%    'riak@10.0.0.13'
    valid       0.0%     18.8%    'riak@10.0.0.14'
    -------------------------------------------------------------------------------
    Valid:5 / Leaving:0 / Exiting:0 / Joining:0 / Down:0

    Transfers resulting from cluster changes: 51
      12 transfers from 'riak@10.0.0.10' to 'riak@10.0.0.11'
      13 transfers from 'riak@10.0.0.10' to 'riak@10.0.0.12'
      13 transfers from 'riak@10.0.0.10' to 'riak@10.0.0.13'
      13 transfers from 'riak@10.0.0.10' to 'riak@10.0.0.14'

Bu tablolar bize cluster değişikliğinin ardından ring dağılımını ve clusterin yeni üyelerini gösterir.

Sonuncu commit komutuyla da bu değişikler aktif hale getirilir.
