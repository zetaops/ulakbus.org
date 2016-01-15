:tocdepth: 2

++++++++++++++++++++++++
manage.py nasıl çalışır?
++++++++++++++++++++++++

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

Bütün model verilerini standart çıktıya ya da belirtilen dosyaya dökümünü alır.

-----
usage
-----

::

     $ ./manage.py dump_data [-h] [--timeit] --model [MODEL] [--path [PATH]]
                           [--type [{csv,json,json_tree,pretty}]]
                           [--batch_size [BATCH_SIZE]]

Zorunlu olan argüman:
---------------------

- **model [MODEL]** Dökümü alınacak model isimleri yazılır. Bütün modellerin dökümü alınacaksa 'all' yazılır.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**   Yardım mesajını gösteririr ve çıkış yapar.

- **--timeit**    İşlemin süresini ölçer.

- **--path [PATH]** Standart çıktı yerine,verilen dosyaya yazar.

- **--type [{csv,json,json_tree,pretty}]**

                                    1.  **csv:** csv varsayılan formattır.Her satıra bir tane kayıt yazar.csv,diğerlerinden
                                        daha hızlıdır ve belleği daha verimli kullanır çünkü JSON şifreleme/şifre çözme'yi atlar.

                                    2.  **json:** Her satırı ayrı bir json dökümanı olarak yazar.json-tree'nin aksine,bellek
                                        kullanımı bir çok kayıt ile artmıyor.

                                    3.  **json_tree:** Büyük veritabanlarında kullanmayın.Bütün dökümü büyük bir JSON nesnesi
                                        olarak yazar.

                                    4.  **pretty:** Büyük veritabanlarında kullanmayın.json_tree'nin formatlanmış versiyonu.



load_data
+++++++++

Json verisini belirtilen dosyadan okur ve modelleri doldurur.

-----
usage
-----

::

   $ ./manage.py load_data [-h] [--timeit] --path [PATH] [--update]
                           [--type [{csv,json,json_tree,pretty}]]
                           [--batch_size [BATCH_SIZE]]

Zorunlu olan argüman:
---------------------

- **--path [PATH]** Veri dosyası ya da  fixture dizininin yoludur. Bir dizinden veri yükleyeceği zaman, .js ve .csv uzantılı
dosyaları yükleyecek.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**   Yardım mesajını gösteririr ve çıkış yapar.

- **--timeit**    İşlemin süresini ölçer.

- **--update**    Varolan kayıtların üzerine yazar.Objenin varlığını kontrol etmeyecek bu yüzden daha hızlı çalışacak.

- **--type [{csv,json,json_tree,pretty}]**

                                    1.  **csv:** csv varsayılan formattır.Her satıra bir tane kayıt yazar.csv,daha hızlıdır
                                        belleği daha verimli kullanır çünkü JSON şifreleme/şifre çözme'yi atlar.

                                    2.  **json:** Her satırı ayrı bir json dökümanı olarak yazar.json-tree'nin aksine,bellek
                                        kullanımı bir çok kayıt ile artmıyor.

                                    3.  **json_tree:** Büyük veritabanlarında kullanmayın.Bütün dökümü büyük bir JSON nesnesi
                                        olarak yazar.

                                    4.  **pretty:** Büyük veritabanlarında kullanmayın.json_tree'nin formatlanmış versiyonu.

**-batch_size [BATCH_SIZE]** Solr'dan varsayılan miktardaki(1000) nesneleri tek seferde bulup getirir.


load_fixture
++++++++++++

Fixture'ları verilen json dosyasından ya da verilen dizindeki json dosyalarından yukler. ulakbus_settings_fixtures bucket'a
bütün mevcut keylerin verisini üzerine yazar.

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

Verilen model ya da modeller için SOLR şemaları üretir/günceller.

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

Bucket'ların içeriğini siliyor.

-----
usage
-----

::

  $ ./manage.py flush_model [-h] [--timeit] --model [MODEL]

Zorunlu olan argüman:
---------------------

- **--model [MODEL]** Silinecek olan model isimleridir.Bütün modelleri silmek için 'all' yazılmalı.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.


update_permissions
++++++++++++++++++

İzinleri veritabanı ile senkronize ediyor.

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

IPython shell'ini çalıştırır.

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

- **--addr [ADDR]** Adresi dinler.Varsayılan 127.0.0.1'dir.

- **--port [PORT]** Portu  dinler. Varsayılan 9001'dir.



random_personel
+++++++++++++++

Rastgele kişi oluşturur.

-----
usage
-----

::

  $ ./manage.py random_personel [-h] [--timeit] --length [LENGTH]

Zorunlu olan argümanlar:
------------------------

- **--length [LENGTH]** Rastgele kişilerin sayısıdır.


Zorunlu olmayan argümanlar:
---------------------------


- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.




random_harici_okutman
+++++++++++++++++++++

Kişi nesnelerinden rastgele Okutman yaratır.

-----
usage
-----

::

   $ ./manage.py random_harici_okutman [-h] [--timeit] --length [LENGTH]


Zorunlu olan argüman:
---------------------

- **--length [LENGTH]** Rastgele okutmanın sayısıdır.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.


random_ogrencı
++++++++++++++

Rastgele Ogrencı model nesneleri oluşturur.


-----
usage
-----

::

  $ ./manage.py random_ogrenci [-h] [--timeit] --length [LENGTH]

Zorunlu olan argüman:
---------------------

- **--length [LENGTH]** Rastgele öğrenci miktarıdır.


Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**     Yardım mesajını gösterir.

- **--timeit**      İşlemin süresini ölçer.


random_okutman
++++++++++++++

Kişi nesnelerinden rastgele okutman oluşturur.

-----
usage
-----

::

   $ ./manage.py random_okutman [-h] [--timeit] --length [LENGTH]

Zorunlu olan argüman:
---------------------

- **--length [LENGTH]** Rastgele okutmanın sayıdır.



Zorunlu olmayan argümanlar:
---------------------------

- **-h,--help**   Yardım mesajını gösterir.

- **--timeit**    İşlemin süresini ölçer.


create_user
+++++++++++

Yeni kullanıcı yaratır.

-----
usage
-----

::

  manage.py create_user [-h] [--timeit] --username [USERNAME] --password
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

- **--permission_query [PERMISSION_QUERY]** Bu query'den "code:crud* OR code:login* OR code:logout*" dönecek izinleri kullanıcıya onaylatacak.

























