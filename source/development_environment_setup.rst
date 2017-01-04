+++++++++++++++++++++++++++++++++++++
ULAKBUS Geliştirme Ortamının Kurulumu
+++++++++++++++++++++++++++++++++++++

Ulakbus için geliştirme ortamının kurulması aşağıdaki bileşenlerin herbirinin ayrı ayrı
kurulup yapılandırılmasını kapsar:

    * Pythton Virtualenv
    * Riak KV
    * Zato ESB
    * Redis
    * Git CVS

Bu servislerin elle kurulumu ve yapılandırılması yeni başlayanlar için biraz karmaşık
gelebilir. Ayrıca biraz uzun bir süreçtir. Bu amaçla hızlı başlangıç için bir
Vagrant[1] box hazırladık. Bunu indirip kullanmaya başlayabilirsiniz:

[1] https://www.vagrantup.com/

::

    mkdir ulakbus-devbox
    cd ulakbus-devbox
    vagrant init zetaops/ulakbus


Vagrant box(sanal makine, guest) temel olarak iki türlü kullanılabilir:
    - Vagrant ile yaratılmış sanal makine içinde geliştirme
    - Sanal makine servislerini kullanarak kendi makinenizde geliştirme

Birincisinde backend sunucusu ve python ortamı box içindedir. Tüm geliştirme işlemleri
box içinden yürütülür.

İkinci kullanımda ise box sadece Riak, Redis ve Zato gibi servisler için kullanılır. Servis
portları Vagrantfile konfigürasyonu ile host makine ile paylaşılır. Böylelikle box içinde
çalışan servislere host makineden erişmek mümkün hale gelir.

Python ortamı ise host makinede (kendi işletim sisteminiz üzerinde) bulunur. Bu hız
ve üretkenlik açısından birincisine göre daha verimlidir. Eğer PyCharm gibi bir IDE
kullanıyorsanız host makinede çalışmak, özellikle detaylı DEBUG için avantajlıdır.

Git depolarınıza her durumda host makine üzerinden erişmenizi öneririz. Host makinedeki
depolarınızı box ile paylaşarak ilgili dizinlere bağlayabilirsiniz. ```git pull```
```git push``` gibi git operasyonları da bu durumda host makine üzerinden gerçekleştirilmelidir.

    Host makine üzerindeki bir git deposu üzerinde box içerisinden işlem yaptığınızda doğrulama,
    yetkilendirme hataları almanız olasıdır.

Hem git depolarının hem de portların nasıl paylaşılacağı aşağıda bağlantısı verilen örnek
Vagrantfile icinde mevcuttur. Bu dosyada çok küçük değişiklikler yaparak istediğiniz gibi
bir vagrant box (sanal makine, guest) elde edebilirsiniz. Örnek Vagrantfile:

::

    https://raw.githubusercontent.com/zetaops/ulakbus.org/master/source/Vagrantfile.sample

Yukarıdaki komutları kullanarak bir box oluşturduğunuzda ilgili dizin altına - örnekte
``ulakbus-devbox`` - bir Vagranfile yazılır. Bu dosyayı bir text düzenleme aracı ile açıp
düzenleyebilirsiniz.

Port yönlendirmek için Vagrantfile içinde aşağıdaki satırlara benzeyen bölümü bulup, istediğiniz
portları ekleyip çıkarabilirsiniz:

::

    # config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "forwarded_port", guest: 9001, host: 9001

Örnek dosyada hangi portun ne için kullanıldığı yorum satırları olarak eklenmiştir.

Dizinleri paylaşmak için ise Vagrantfile içerisinde aşağıdakine benzeyen bölümleri bulup
düzenleyebilirsiniz:

::

    # config.vm.synced_folder "../data", "/vagrant_data"
    config.vm.synced_folder "~/dev/zetaops/ulakbus", "/app/ulakbus", owner: "ulakbus", group: "ulakbus"

Bu satır host makinenizde kullanıcı dizininiz altında, dev/zetaops/ulakbus yolunda bulunan
``ulakbus`` dizinini box içerisinde /app/ulakbus yolunda bulunan ``ulakbus`` dizinine bağlar.
Box içindeki dizinin sahibi ve grubunu ``ulakbus`` yapar.


Gerekli düzenlemeleri yaptıktan sonra Vagrantbox **oluşturduğunuz dizin içerisinde** şu komut ile
başlatabilirsiniz:

::

    vagrant up


Başlayan makineye giriş yapmak için şu komutu kullanabilirsiniz:

::

    vagrant ssh


Giriş yaptıktan sonra servislerin başlayıp başlamadığını, bağlanan dizinlerin güncel olup
olmadığını kontrol edebilisiniz:

::

    sudo service redis-server status
    sudo service riak ping
    sudo service zato status


Eğer geliştirme işlemlerini box içerisinde yapacaksanız, ulakbus kullanıcısına geçip python
ortamınızı etkinleştirerek başlayabilirsiniz. En başından sırasıyla komutlar (# ile başlayan yorum
kısımları olmadan):

::

    vagrant up                         # vagrantbox başlat
    vagrant ssh                        # vagrantbox giriş
    sudo su - ulakbus                  # ulakbus kullanıcısına geçip home dizinine geç
    source ulakbusenv/bin/activate     # ulakbus environment etkinleştir


Bu komutun ardından komut satırı promptu değişecek ve şu hale gelecektir:

::

    (ulakbusenv)ulakbus@ulakbus:~$


Eğer deneyiminiz yoksa virtualenv ile ilgili şu bağlantılara bakabilirsiniz:
virtualenv hakkında detaylı bilgi için:

   * http://istihza.com/forum/viewtopic.php?t=2164
   * http://docs.python-guide.org/en/latest/dev/virtualenvs/

Bu işlemlerin ardından ilk adım, modellerin db şemalarını senkronize etmek, belirtilen dizinden
fixture dosyalarını yüklemek ve iş akışları izinlerini güncellemektir.

::

    $ python manage.py migrate --model all



::

    $ python manage.py load_fixture --path fixtures/

Bu işlem uzun sürebilir. Komut satırı yönetim aracı hakkında detayları `ilgili
belgeden <http://www.ulakbus.org/wiki/komut_satiri_yonetim_araci.html>`_ öğrenebilirsiniz.

::

     python manage.py update_permissions

Eğer geliştirmeyi kendi makinenizde yapmayı tercih ederseniz şu adımları izleyebilirsiniz:

::

    $ virtualenv ulakbusenv                 # ulakbusenv python ortamı yarat
    $ source ulakbusenv/bin/activate        # python ortamını etkinleştir
    $ cd ~/ulakbus                          # ulakbus git deposuna gir
    $ git pull                              # son değişiklikleri uzak depodan çek
    $ pip install -r requirments.txt        # ulakbus bagimliliklarini kur
    # ulakbus python kutuphane dizinine ekle
    $ ln -s ~/ulakbus ~/ulakbusenv/lib/python2.7/site-packages/


Vagrant Box Güncellemek
+++++++++++++++++++++++
Ulakbus aktif olarak geliştirilmeye devam etmektedir. Bu sebeple vagrantbox içinde kullanılan
bileşenlerin sürümlerinin değişmesi, yenilerinin eklenmesi veya başka sebepler ile değişmektedir.
Bu değişiklikleri https://atlas.hashicorp.com/zetaops/boxes/ulakbus adresinden takip edebilirsiniz.

Vagrantbox güncellemek isterseniz öncelikle indirdiğiniz box imajını güncellemelisiniz:
Bunun için önce Vagrantfile bulunan dizine geçiniz. Bu dizinde

::

    $ vagrant box outdated

Komutunu çalıştırıp mevcut box eski mi değil mi kontrol edin. Daha sonra mevcut box destroy edip
yeniden init edebilirsiniz.

.. Dikkat:: Prensip olarak box içerisinde geliştirme süreçlerine ait herhangi bir veri
   **bulunmamalıdır**. Eğer varsa bu işlemden önce ilgili veriler host makinesine alınmalıdır.

::

    $ vagrant box destroy
    $ vagrant update

İşlem bitince
::

    $ vagrant up


Ayrıca mevcut box birden fazla sürüme sahip olabilir. ``--box-version`` ile yeni bir sürüm
ekleyebilir veya mevcut sürümleri kaldırabilirsiniz:

::

    $ vagrant box list                           # Vagrant için yüklü olan box listesi
    $ vagrant box remove --box-version 0.1.9 zetaops/ulakbus   # ulakbus isimli box'ın 0.1.9 sürümünü kaldırır.

Sonraki Adımlar
+++++++++++++++
Geliştirme ortamını başarıyla kurduktan sonra şu belgelerle devam edebilirsiniz:

    * `Ulakbus Geliştirelim <http://www.ulakbus.org/wiki/ulakbusu-gelistirmek.html>`_
    * `ZEngine ile İş Akışı Temelli Uygulama Geliştirme
      <http://www.ulakbus.org/wiki/zengine-ile-is-akisi-temelli-uygulama-gelistirme.html>`_

Ayrıca Git ve Github iş akışımız hakkında bilgi alabileceğiniz `Ulakbus Depolarına Katkı
Yapmak <http://www.ulakbus.org/wiki/git_workflow.html>`_ belgemize göz atabilir, geliştirme
sürecimizin aktif bir parçası olabilirsiniz.

Eğer bir sorunla karşılaşırsanız, `destek sayfamızda <http://www.ulakbus.org/destek.html>`_ yer alan
kanallardan destek alabilirsiniz. Destek için iletişim kurmadan önce lütfen sorununuzun ne olduğunu
**açık ve sarih olarak** bildirmeniz gerektiğini unutmayınız. "- Bu çalışmıyor" şeklindeki
sorularınıza alabileceğiniz en iyi cevap **sessizlik** olacaktır.

Nasıl soru sorulacağını `akıllıca soru sorma yolları belgesinden
<http://belgeler.org/howto/smart-questions.html>`_ öğrenebilirsiniz.

Kolay gelsin \o/
