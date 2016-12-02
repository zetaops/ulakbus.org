:tocdepth: 2

+++++++++++++++++++++++
Temel Yönetim Komutları
+++++++++++++++++++++++
Komut satırı yönetim aracı ``manage.py`` ile kullanıcı ekleme, veritabanı yedekleme,
geliştirme sunucusu çalıştırma gibi birçok operasyon kolaylıkla yapılabilir.


-h or --help
++++++++++++

Yardım mesajını gösteririr ve çıkış yapar.

-----
usage
-----
::

   $ ./manage.py -h or $ ./manage.py -help



dump_data
+++++++++

Bütün modellere ait verileri standart çıktıya ya da belirtilen dosyaya yazar.

-----
usage
-----
::

     $ ./manage.py dump_data [-h] [--timeit] --model [MODEL] [--path [PATH]]
                             [--type [{csv,json,json_tree,pretty}]]
                             [--batch_size [BATCH_SIZE]]

Zorunlu olan argüman:
---------------------

- **model [MODEL]** Dökümü alınacak modellerin isimleri yazılır. Bütün modellerin
  dökümü alınacaksa 'all' yazılır.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**   Yardım mesajını gösteririr ve çıkış yapar.

- **--timeit**    İşlemin süresini ölçer.

- **--path [PATH]** Standart çıktı yerine, belirtilen dosyaya yazar.

- **--type [{csv,json,json_tree,pretty}]**

           1.  **csv:** csv varsayılan formattır. Her satıra bir tane kayıt yazar. csv,
               diğerlerinden daha hızlıdır ve belleği daha verimli kullanır çünkü JSON
               encoding/decoding işlemlerini yapmaz.

           2.  **json:** Her bir kayıt için,  ayrı bir json string içeren bir döküman yazar.
               Dökümandaki her satır bir kayda ait json stringidir. json-tree'nin aksine,
               bellek kullanımı kayıt başına artmaz.

           3.  **json_tree:** Büyük veritabanlarında kullanmayın. Bütün dökümü tek bir
               JSON nesnesi olarak yazar.

           4.  **pretty:** Büyük veritabanlarında kullanmayın. json_tree'nin formatlanmış
               versiyonu.


load_data
+++++++++

Belirtilen dosyadan verileri okur ve modelleri doldurur.

-----
usage
-----
::

   $ ./manage.py load_data [-h] [--timeit] --path [PATH] [--update]
                           [--type [{csv,json,json_tree,pretty}]]
                           [--batch_size [BATCH_SIZE]]

Zorunlu olan argüman:
---------------------

- **--path [PATH]** Veri dosyası ya da fixture dizininin yoludur. Bir dizinden veri
  yükleyeceği zaman, .js ve .csv uzantılı dosyaları kullanır.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**   Yardım mesajını gösteririr ve çıkış yapar.

- **--timeit**    İşlemin süresini ölçer.

- **--update**    Varolan kayıtların üzerine yazar.Objenin varlığını kontrol
  etmeyecek bu yüzden daha hızlı çalışacak.

- **-batch_size [BATCH_SIZE]** Solr'dan varsayılan miktardaki(1000) nesneleri
  tek seferde bulup getirir.

- **--type [{csv,json,json_tree,pretty}]**

           1.  **csv:** csv varsayılan formattır. dump_data ile elde edilmiş veya geçerli
               bir csv dosyası olabilir.

           2.  **json:** dump_data ile elde edilmiş veya geçerli bir json dosyası olabilir.

           3.  **json_tree:** dump_data ile elde edilmiş veya geçerli bir json_tree dosyası
               olabilir.

           4.  **pretty:** dump_data ile elde edilmiş veya geçerli bir pretty json_tree
               dosyası olabilir.


load_fixture
++++++++++++

Fixture'ları verilen json dosyasından ya da verilen dizindeki json dosyalarından yükler. Verileri,
ulakbus_settings_fixtures isimli bucket içine, mevcut keylerin üzerine yazarak doldurur.

-----
usage
-----
::

  $ ./manage.py load_fixture [-h] [--timeit] --path [PATH]

Zorunlu olan argüman:
---------------------

- **--path [PATH]** Fixture dosyasını ya da dizinini yükler.


Zorunlu olmayan argümanlar:
---------------------------


- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.


migrate
+++++++

Verilen model ya da modeller için yeni SOLR şemaları üretir veya mevcutları günceller.

-----
usage
-----
::

   $ ./manage.py migrate [-h] [--timeit] --model [MODEL] [--threads [THREADS]]
                         [--force]

Zorunlu olan argüman:
---------------------

- **model [MODEL]** Dökümü alınacak model isimleridir. Bütün modellerin dökümü alınacaksa 'all' yazılır.

Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.

- **--threads [THREADS]** Threadler'in maksimum sayısıdır.Varsayılan deger 1'dir.

- **--force** Şema yaratımını zorunlu kılar.



flush_model
+++++++++++

Modellere ait bucket'ların içeriğini siler.

-----
usage
-----
::

  $ ./manage.py flush_model [-h] [--timeit] --model [MODEL]

Zorunlu olan argüman:
---------------------

- **--model [MODEL]** Silinecek olan model isimleridir. Bütün modelleri silmek için 'all' yazılmalıdır.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.


update_permissions
++++++++++++++++++

İzinleri veritabanı ile senkronize eder.

-----
usage
-----
::

  $ ./manage.py update_permissions [-h] [--timeit] [--dry]

Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**   Yardım mesajını gösterir.

- **--timeit**    İşlemin süresini ölçer.

- **--dry**       Degişiklik yapmaz sadece listeler.


shell
+++++

IPython shell'ini çalıştırır. Bu shell projeye ait tüm modelleri yükler ve kullanıma hazır
hale getirir. Çalışma kolaylığı sağlar.

-----
usage
-----
::

   $ ./manage.py shell [-h] [--timeit] [--no_model]

Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**   Yardım mesajını gösterir.

- **--timeit**    İşlemin süresini ölçer.

- **--no_model**  Modelleri içe taşımaz(import).


runsever
++++++++

Geliştirme sunucusunu çalıştırır.

-----
usage
-----
::

   $ ./manage.py runserver [-h] [--timeit] [--addr [ADDR]] [--port [PORT]]

Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.

- **--addr [ADDR]** Sunucunun dinleyeceği adres. Varsayılan 127.0.0.1'dir.

- **--port [PORT]** Sunucunun dinleyeceği port. Varsayılan 9001'dir.


create_user
+++++++++++

Yeni kullanıcı yaratır.

-----
usage
-----
::

  $ ./manage.py create_user [-h] [--timeit] --username [USERNAME] --password
                            [PASSWORD] [--abstract_role [ABSTRACT_ROLE]]
                            [--super] [--permission_query [PERMISSION_QUERY]]


Zorunlu olan argümanlar:
------------------------

- **--username [USERNAME]**  Kullanıcı adı

- **--password [PASSWORD]**  Şifre

Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.

- **[--abstract_role [ABSTRACT_ROLE]]** AbstractRole

- **--super** Süper kullanıcı

- **--permission_query [PERMISSION_QUERY]** Bu sorgudan dönen izinler yenı eklenen kullanıcıya tanımlanır.
  Varsayılan: "code:crud* OR code:login* OR code:logout*"


generate_diagrams
+++++++++++++++++

Modellerden PlantUML diyagramları oluşturur.

-----
usage
-----
::

   $ ./ manage.py generate_diagrams [-h] [--timeit] [--daemonize]
                                    [--model [MODEL]] [--path [PATH]]
                                    [--split [{no,app,model}]]


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**   Yardım mesajını gösteririr ve çıkış yapar.

- **--timeit**    İşlemin süresini ölçer.

- **model [MODEL]** Diyagramı çizilecek modellerin adı buraya
  yazılarak seçilir. Tüm diyagramları seçmek için 'all'
  girilebilir. Eğer bu seçenek verilmediyse tüm modeller için diyagram
  oluşturulur.

- **--path [PATH]** Standart çıktı yerine, belirtilen dosyaya
  yazar. Eğer 'split' seçeneği 'app' veya 'model' seçilirse 'path'
  verilmesi zorunludur.

- **--split [{no,app,model}]**

           1.  **no:** Tüm modelleri tek bir diyagrama yerleştirir ve
               standart çıktıya ya da tek bir dosyaya yazar.

           2.  **app:** Modelleri, Metaclasslarındaki 'app' alanına
               göre gruplayarak ayrı dosyalara yazar. Bu seçenek
               seçilirse 'path' seçeneğiyle bir dosya adı
               verilmelidir. Dosyaları 'path' seçeneğindeki isim ve
               'app' isimleri ile kaydeder, örneğin '--path
               diagrams.puml' seçildiyse dosyaları 'diagrams.app.puml'
               şeklinde kaydeder.

           3.  **model:** Modellerin her birini ayrı dosyalara
               yazar. Bu seçenek seçilirse 'path' seçeneğiyle bir
               dosya adı verilmelidir. Dosyaları 'path' seçeneğindeki
               isim, 'app' isimleri ve model ismi ile
               kaydeder. Örneğin '--path diagrams.puml' seçildiyse
               dosyaları 'diagrams.app.model.puml' şeklinde kaydeder.


Bu komut ile oluşturulan diyagramlar PlantUML'in çizim sınırlarını
aşabilir. Oluşan diyagramların çizilirken yarım kalması durumunda
PlantUML'e bir çevre değişkeni verilerek diyagramları çizmesi
sağlanabilir:

::

   $ env PLANTUML_LIMIT_SIZE=8192 plantuml my-diagram.puml

+++++++++++++++
Veri Üreteçleri
+++++++++++++++
Aşağıda sıralanan komutlar geliştirme esnasında fake(uydurma) veriler üretmek amacıyla
eklenmiştir.

random_personel
+++++++++++++++

Rastgele Personel üretir.

-----
usage
-----
::

  $ ./manage.py random_personel [-h] [--timeit] --length [LENGTH]

Zorunlu olan argümanlar:
------------------------

- **--length [LENGTH]** Rastgele üretilecek personel sayısıdır.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.



random_harici_okutman
+++++++++++++++++++++

Rastgele Harici Okutman üretir.

-----
usage
-----
::

   $ ./manage.py random_harici_okutman [-h] [--timeit] --length [LENGTH]


Zorunlu olan argüman:
---------------------

- **--length [LENGTH]** Rastgele üretilecek okutmanın sayısıdır.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.


random_ogrenci
++++++++++++++

Rastgele Ögrenci üretir.


-----
usage
-----
::

  $ ./manage.py random_ogrenci [-h] [--timeit] --length [LENGTH]

Zorunlu olan argüman:
---------------------

- **--length [LENGTH]** Rastgele üretilecek öğrenci sayısıdır.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.


random_okutman
++++++++++++++

Personel veya HariciOkutman modellerinden rastgele Okutman üretir.

-----
usage
-----
::

   $ ./manage.py random_okutman [-h] [--timeit] --length [LENGTH]

Zorunlu olan argüman:
---------------------

- **--length [LENGTH]** Rastgele üretilecek okutmanın sayıdır.



Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**   Yardım mesajını gösterir.

- **--timeit**    İşlemin süresini ölçer.
