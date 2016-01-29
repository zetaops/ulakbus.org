:tocdepth: 2

+++++++++++++++++++++++
Zato İpuçları
+++++++++++++++++++++++


Zato Bileşenlerini Yeniden Başlatma
+++++++++++++++++++++++++++++++++++

Zato ile ilgili bileşenler `/etc/zato/components-enabled/` dizini altında bulunmaktadır.
Zato yeniden başlatıldığında, bu bileşenler yeniden başlatılmış olurlar.
Her bir bileşen istenirse diğerlerinden ayrı olarak da yeniden başlatılabilir.


--------------
örnek kullanım
--------------
::

   $ sudo service zato stop
   $ sudo service zato start
   veya
   $ sudo service zato restart


os_environ
++++++++++

Servislerin kullandığı çevre değişkenleri (environment variable) Zato tarafından erişilebilir olmalıdır.
Bunun için sunucu yapılandırma dosyasında (`/opt/zato/ulakbus/server1/config/repo/server.conf`) 
os_environ bölümüne çevre değişkenleri eklenmelidir.


--------------
örnek kullanım
--------------
::

   [os_environ]
   HITAP_USER='hitap_user_name'
   HITAP_PASS='hitap_password'


zato_extra_paths
++++++++++++++++

Zato servisleri tarafından kullanılan modül ve kütüphaneler,
Zato tarafından erişilebilir olmaları için `~/zato_version/zato_extra_paths/` dizini altında bulunmalıdır.
İlgili modül ve kütüphaneler için bu dizin altında sembolik link verilebilir.


-----
örnek
-----

.. image:: _static/zato_extra_paths.png
    :scale: 100 %
    :align: center


Geliştirilen servisleri Zato aracılığıyla kullanmak için, servis modüllerini
`/opt/zato/ulakbus/server1/pickup-dir/` dizini altına kopyalamak gerekmektedir.
Bu işlemi yapmadan önce çevre değişkenlerini (HITAP_USER, HITAP_PASS vb.) tanımladığınızdan emin olunuz.


--------------
örnek kullanım
--------------
::

   $ sudo cp /app/ulakbus/ulakbus/services/personel/hitap/*.py /opt/zato/ulakbus/server1/pickup-dir/


Bu işlemden sonra servisler için tanımlanmış kanalları (channels) ve giden bağlantıları (outgoing) içeren
bir yapılandırma dosyası varsa bu dosya içeriye aktarılmalıdır.


enmasse
++++++++++++

Zato servisleri için tanımlanmış kanalların (channels) ve giden bağlantıların (outgoing) 
bir yapılandırma dosyasına çıkartılarak saklanmasını veya içeriye aktarılmasını sağlar.


------
export
------
::

   $ zato enmasse ../server1/ --input input1.json --export-local --export-odb


Argümanlar:
---------------------

- **path** Zato server dizinini belirtir.

- **--input** Dışarıya aktarılacak dosya, bu JSON girdi dosyası kullanılarak oluşturulur.
  Bu yüzden dosya mevcut değilse, içerisine boş bir sözlük {} konularak oluşturulabilir.

- **--export-local --export-db** JSON ve ODB nesnelerini birleştirerek tek bir dosya halinde
  dışarıya aktarır.


------
import
------
::

   $ zato enmasse ../server1/ --input zato-export-2015-06-30T08_56_22_628706.json --import --replace-odb-objects


Argümanlar:
---------------------

- **path** Zato server dizinini belirtir.

- **--input** İçeriye aktarılacak JSON dosyası. Bu dosya yukarıdaki örnekte olduğu gibi
  Zato komut arayüzü üzerinden dışarıya aktarılmış olmalıdır.

- **--import --replace-odb-objects** Nesneleri, dışarıya aktarılmış 
  JSON dosyasından mevcut olanların üzerine yazılacak şekilde içeri aktarır.


