+++++++++++++++++++++
Veri Erişim Seçimleri
+++++++++++++++++++++

* Sözlük

* Bucket

* Conflict

* Eventually Consistent

* Sibling

* application = uygulama

* nested

* entity

* rdbms

------------------------------
**Neden RDBMS Kullanmıyoruz?**
------------------------------

Bu uygulamada ortaya çıkan entity yapıları, geleneksel rdbms ile

----------------------------------------------
**Neden Eventually Consistent Kullanmıyoruz?**
----------------------------------------------

Riak'ı Eventually Consistent modunda kullandığımızda, concurrent yazma işlemleri sonucu verinin birden fazla değişik versiyonu oluşabiliyor. (Sibling) Çünkü veri, farklı nodelardaki kopyalarının durumu gözetilmeksizin yazılıyor. Oluşan conflictler ise daha sonra çözüme kavuşturuluyor.(`link <http://docs.basho.com/riak/latest/dev/using/conflict-resolution/>`_). Bu da ayrıca yönetilmesi gereken oldukça karmaşık bir problemi beraberinde getiriyor.

Oluşan conflictler birkaç yolla çözüme bağlanabiliyor. (`link <http://docs.basho.com/riak/latest/dev/using/conflict-resolution/#Client-and-Server-side-Conflict-Resolution/>`_) Bu çözümlerin bir kısmı Riak tarafından otomatik olarak yapılabiliyor. Riak'ın sağladığı iki temel çözüm time-based ve last-write-wins şeklinde. Riak'ın internal çözümleri dışında uygulama katmanından bu çözümleri uygulamak da mümkün. Fakat aynı bucket üzerinde hem Riak internal hem de application taraflı çözümleri kullanamıyoruz. Bir bucketdaki conflictlerin nasıl çözüleceği bucket metadataları ile kontrol ediliyor. Riak internallar için allow_mult parametresi false olması gerekirken, uygulama taraflı çözümler için true olması gerekiyor.

Yani hem Riak internal çözümlerini hem de uygulama çözümlerini tek bir bucket üzerinde birlikte kullanmakta mümkün değil. Bizim durumumuzda bu tür conflictlerin uygulama katmanında çözüme bağlanması kaçınılmaz. Bu da birçok bucketta Riak'ın last-write-wins veya timestamp gibi çözümlerini kullanamayacağımız anlamına geliyor. Çünkü aynı verinin farklı kesitlerine farklı kullanıcılar erişiyor. Uygulama katmanında conflict resolution ise data layerinda daha fazla complexity demek.

----------------------------------
**Neden Data Type kullanmıyoruz?**
----------------------------------

Veri tipleri sadece eventually consistent sistemlerde `kullanılabiliyor.
<http://docs.basho.com/riak/latest/ops/advanced/strong-consistency/#Important-Caveats>`_
Veri tipleri, yukarıdaki problemi herbir data type için Riak tarafından farkli tanımlanmış kurallar dahilinde çözüyorlar ve buna uygulama katmanında müdahale etmek mümkün değil. Kararı Riak veriyor. Eventually consistent ortamda, uygulama katmanında conflict resolution mümkün olmadığı için veri tipleri kullanamıyoruz.

Riak veri tipleri sayesinde sınırlı da olsa search (arama) imkanı sağlıyor. Bunu da register, flag gibi belirli tipleri solr şemasında dynamicField olarak tanımlayarak `yapıyor.
<https://github.com/basho/yokozuna/blob/develop/priv/default_schema.xml#L100>`_
Bizim register, flag şeklinde işaretlediğimiz her veri, dynamicField tanımlaması sayesinde solr da indexleniyor. Riak'ın bu veri tipleri sayesinde search için eklediği ekstra bir özelliğe dair dökümanlarda altı çizilen bilgi  yok. Bizim verimize uyacak nested bicimde register, counter ve setler iceren maplere bağlı olarak dynamic field ı bu şekilde kullanmak, sayısız ve kontrolsüz biçimde artan index ve `inverted index <https://en.wikipedia.org/wiki/Inverted_index>`_ lere yol açacaktır.

-----------------------------------
**Neden Write Once kullanmıyoruz?**
-----------------------------------

Write once kullandığımızda sistem sürekli farklı keylere yazacağı için conflict oluşmaz. Fakat uygulama katmanında verinin bütünlüğü için alacağımız önlem, yani verinin yazılmadan önce okunması, farklı nodelardan okuma ve sistemde oluşabilecek gecikmelerden dolayı yüzde yüz garanti sağlamaz. Yazma isteğinin doğrulanması için yapılacak okuma ve yazma farklı nodelardan yapılacağı için burada da verinin bir öncekini baz alan iki farklı kopyası oluşacaktır.

Bunun yanısıra arama işini daha karmaşık hale getirmekte, çok kopyalı sonuçlar arasında en son kopyaya ulaşma gibi ekstra bir zorluk eklemektedir.

----------------------------
**Neden Strong Consistency**
----------------------------

Riak Strong Consistency modunda conflictlere izin vermez. Veri tüm nodelarda eşlenene kadar yazıldı olarak kabul edilmez. Concurrent işlemlerde tıpkı RDBMS lerdeki locklarda olduğu gibi yazma hataları döndürür. Bu da uygulama katmanında çok daha kolay yönetilebilir ve basit bir conflict resolution policy anlamına gelir.


----------------------------
**Neyi Nasıl Kullanacağız?**
----------------------------

Log, temporary datalar hariç Strong Consistent bucketlar kullanacağız. Tek kopya üzerinde çalışacağız. Datayı yapabildiğimiz kadar flat hale getirip, solr indexleri için mümkün olduğunca az dynamicfield içerek şemalar kullanacağız. Flat haline getirilmiş bucket arasında linkler ile relationlar kuracağız. Versiyonları ayrı bir writeonce bucket’ta tutacağız. Bunlara bir pk ve date fieldları ekleyip bu iki field ı solr da indexleyeceğiz.

-----------
**Caching**
-----------

* Redis nasıl kullanılacak?

* Okuma nasıl yapılacak?

* REDIS'ten Riak'a ve tersi akışta verinin bütünlüğü nasıl korunacak?

-----------
**Sorular**
-----------

Relationlar Pyoko tarafından kurulacak. Biz her bir bucket içinde, hiç ilgilenmeyeceğimiz riak key karşısına koyduğumuz rowlar -nested json values, as flat as possible- içinde relation keyleri ekleyeceğiz.

Verinin parçaları farklı bucket ve keylerde saklanacak. Biz hepsini veya bir kısmını ilgilendiren bir yazma/update işlemi yaptığımızda gereken tüm bucketlar dolaşılıp yazma işlemi tamamlanacak. Strong Consistency ile kazandığımız verinin bütünlüğü ve eşsizliği bu modelde tehlikeye girmiş olmuyor mu? Concurrent bağlantılarda henuz bizim zincirimizde sırası gelmemiş bir kayıt başka bir zincir tarafından biz yazmadan önce güncellenmiş ise bunu nasıl anlayacağız ya da bunun önüne nasıl geçeceğiz?

Pyoko’nun kendi gelişim seyri içerisinde ortaya çıkacak bugünden öngörülemeyen geliştirme ihtiyacı  bir yana, flat bucketlar arasında relational bir yapı kurmacanın öngörülemeyen zorlukları / sorunlarını da göze alıyoruz. Bunun tek sebebi dynamic field kullanmamak mıdır? Öyleyse 1 milyon solr documana yol açacak kadar çok kayıt  içinde birçok dynamic field testi yapmaya değmez miydi?

Aşağıdaki sorgu ve rapor örneklerinin nasıl yapılabileceği hakkında bugünden ne açıklıkla yanıtlar verebiliyoruz?

------------
**Sorgular**
------------

* Bilgisayar mühendisliği 1. sınıfta Math101 dersinin 2. dönem 2. vizesinden 60 - 80 almış öğrencilerin listesi

* Sosyal Bilimler Enstitüsünde 2010 - 2015 yılları arasında kademe cezası almış, kadın personellerin listesi. (kademe cezası önceki yıla göre kademe farklarına göre bulunabilir.)

* Tıp fakültesinde, en az lise mezunu, kadro derecesi 7 den büyük, askerlik engeli bulunmayan personeller.

* Bir öğrencinin seçmek istediği bir derse bağlı olan ön şartlı ders notu

* Bir dersin genel sınavına (final) girmeye hak kazanmış öğrencilerin listesi

* Belirli bir tarihe kadar sisteme not girmesi beklenen hocaların listesi. (sınavın yapıldığı tarihi takiben max 15 gün, sonraki sınav tarihinden min 7 gün önce gibi sabit birkaç kural söz konusu.)

------------------------------
**Create ve Update islemleri**
------------------------------

* Yeni ogrenci yarat

* Yeni personel yarat

* Ogrenci ozluk bilgisi guncelle

* Okul lokasyon bilgisi guncelle

------------
**Raporlar**
------------

* Fakülte, bölüm ve program başına beklenen harç miktarları

* Fakülte, bölüm ve program başına hocalara ödenecek beklenen ek ders ücretleri

* Bir akademik personelin performansına dair son iki yılda danışmanlığını yaptığı öğrencilerin not ortalaması

* Yıllara göre mezunların başarı ortalaması (her programın mezuniyet için öğrencilerin tutturması gereken asgari bir program mezuniyet ortalaması değeri vardır. öğrenciler bu değerin neresindedir?)

* Azami öğretim süresine gelmiş ve mezun olmayacak öğrencilerin listesi