+++++++++++++++++++++
Veri Erişim Seçimleri
+++++++++++++++++++++


==============================
**Neden RDBMS Kullanmıyoruz?**
==============================


İncelenen veri setlerine bakıldığında son derece kompleks ilişkilere sahip ve bütünleşik olarak tasarlanması gereken bu verinin, RDBMS (relational database management system) ile geliştirilmesinde aşağıdaki sorunların ortaya çıkacağı öngörülmüştür;

- Veritabanı normalizasyonu (database normalization) yapmak için, ilerleyen proje sürecinde daha büyük karmaşa yaratacak geçici çözümler (workaround) üretmek gerekmektedir.
- Yazılımda ortaya çıkan iş kuralları, veri erişimi desenleri (data access pattern) gibi geliştirme bileşenlerinin takip edilebilir bir sınıf hiyerarşisi içinde değil, uygulamanın farklı bölümlerinde parçalı olarak yer alması proje bütünlüğünü bozmaktadır. Ayrıca proje süresini, hayli uzatmaktadır. Bu bileşenler;

  - Veritabanında "stored procedures" kullanımı
  - Her veritabanında, kolaylaştırıcı gibi görünen ancak süreç içinde vendor lock-in yaratan ek özelliklerin kullanımı,
  - ORM (Object-relational mapping) kullanılsa bile veride bulunan normalizasyon sorunları yüzünden raw sql yazma ihtiyacı,
  - DDL (Data Definition Language) yönetimi,
  - DML (Data Manipulation Language) yönetimi,
  - Data migration süreçlerinin yönetimi şeklinde özetlenebilir.


- Proje isterleri detaylı olarak incelendiğinde farklı yeteneklerde personel ihtiyacı ve birbirine bağımlı çalışma zorunluluğu nedeniyle süreçler zor ve verimsiz olmaktadır. Sonu gelmeyen toplantılarda, sadece gereken uyumun sağlanabilmesi için, anlamsızca zaman heba edilmektedir. Geçmişten gelen tecrübelerimiz, bu türden uzun vadeli projelerde verimliliğin yukarıdaki sebeplerden ciddi bir şekilde düştüğünü göstermiştir.
- Geliştirici, veri yapılarını tıpkı RDBMS yönetir gibi yönetebilmeli ancak dağıtık uygulama ihtiyaçlarına göre eklenmiş özellikleri de (caching, full text search index vb.) kolaylıkla uygulayabilmelidir. 
- Veri ACID  (Atomicity, Consistency, Isolation, Durability) özellikleri korunarak saklanabilmeli ancak dağıtık yapıda tutulabilmelidir.
- Dağıtık bulut uygulamalarında minimum five nine [2]_ yüksek bulunurluk sağlanmalıdır. Birden fazla instance üzerinde ve dağıtık çalışan uygulamanın kullanacağı veritabanı da dağıtık çalışmaya uygun olmalıdır. 
- Veri en az 10 yıl boyunca silinmemeli ve her değişikliğin versiyonları silinmiş olarak mark edilip tutulmalıdır. Silme işlemi ancak kontrollü olarak yapılabilmelidir.
- Geliştiricilerin modeller üzerinde yaptığı değişiklikler sistemin genel bütünlüğünü bozacak sıralı hatalar oluşturmamalıdır.

Yukarıda sadece temel soruları bulunan incelemenin sonucu olarak, Riak veritabanı kullanımına karar verilmiştir. Riak veritabanı ile tüm geliştirme süreçlerini istenen şekilde yürütebilmek için Pyoko ORM [1]_ geliştirilmiştir. Bu ORM ile istenen RDBMS davranışları ve daha fazlası sağlanabilmekte, ayrıca entegre olarak SOLR AKKY kullanılarak da full text search yetenekleri kullanılabilmektedir. Yine Pyoko ORM içinde Redis AKKY cache ile kullanım sağlanmış ve gereken alanların cache üzerinden uygulamaya sunulması sağlanmıştır. ORM uygulamalarının olgunlaşmaları için zaman gerekmektedir ve bu zaman da kullanılmıştır. Pyoko, şu anda 2,5 yıllık bir geliştirme ve test sürecinin sonucu olarak her tür veri operasyonunda güvenle kullanılmaktadır.

Pyoko ORM, piyasada bulunan pek çok ORM aracından çok daha güçlü özellikler sunmaktadır. Bunlardan bazıları;

- Link(): Link any object to any object. More possibility then many to many. Unions etc. Modellerde bulunan tüm nesneler birbirlerine many to many, unions gibi bağlantı türlerinden çok daha esnek bir şekilde bağlanabilirler.
- Nested class based data models (schemas).
- Link(one_to_one): One to one connections, İki model arasında birebir bağlantı yapılabilir.
- List Node: One to many connections, Bire çok bağlantı kurulabilir.
- Link Proxy: Self referenced models, Modeller kendilerini referans olarak kullanabilir. 
- Sorgu için, and, or, range, exact, contains, startswith, endswith, lte, gte, order by kullanılabilir. 
- Solr magic: full text search index on ALL data, function queries, range queries.
- AND queries by using filter() and exclude() methods. 
- Or, in, greater than, lower than queries.
- Query chaining and caching.
- Automatic Solr schema creation / update (one way migration).
- Row level access control, permission based cell filtering.
- Self referencing model relations.
- Automatic versioning on write-once buckets.
- Customizable activity logging to write-once buckets.
- Custom migrations with migration history.

Bir sonraki bölümde Riak ile ilgili alınmış bulunan tasarım kararlarını takip edebilirsiniz. 
  

==============================================
**Neden Eventually Consistent Kullanmıyoruz?**
==============================================

Riak'ı Eventually Consistent modunda kullandığımızda, concurrent yazma işlemleri sonucu verinin birden fazla değişik versiyonu oluşabiliyor. (Sibling) Çünkü veri, farklı nodelardaki kopyalarının durumu gözetilmeksizin yazılıyor. Oluşan conflictler ise daha sonra çözüme kavuşturuluyor. [3]_  Bu da ayrıca yönetilmesi gereken oldukça karmaşık bir problemi beraberinde getiriyor.

Oluşan conflictler birkaç yolla çözüme bağlanabiliyor.[4]_ Bu çözümlerin bir kısmı Riak tarafından otomatik olarak yapılabiliyor. Riak'ın sağladığı iki temel çözüm time-based ve last-write-wins şeklinde. Riak'ın internal çözümleri dışında uygulama katmanından bu çözümleri uygulamak da mümkün. Fakat aynı bucket üzerinde hem Riak internal hem de application taraflı çözümleri kullanamıyoruz. Bir bucketdaki conflictlerin nasıl çözüleceği bucket metadataları ile kontrol ediliyor. Riak internallar için allow_mult parametresi false olması gerekirken, uygulama taraflı çözümler için true olması gerekiyor. Yani hem Riak internal çözümlerini hem de uygulama çözümlerini tek bir bucket üzerinde birlikte kullanmak mümkün değil. Bizim durumumuzda bu tür conflictlerin uygulama katmanında çözüme bağlanması kaçınılmaz. Bu da birçok bucketta Riak'ın last-write-wins veya timestamp gibi çözümlerini kullanamayacağımız anlamına geliyor. Çünkü aynı verinin farklı kesitlerine farklı kullanıcılar erişiyor. Uygulama katmanında conflict resolution ise data layerında daha fazla complexity anlamına geliyor.


==================================
**Neden Data Type Kullanmıyoruz?**
==================================

Veri tipleri sadece eventually consistent sistemlerde kullanılabiliyor.[5]_ Veri tipleri, yukarıdaki problemi her bir data type için Riak tarafından farklı tanımlanmış kurallar dahilinde çözüyorlar[6]_ ve buna uygulama katmanında müdahale etmek mümkün değil. Kararı Riak veriyor. Eventually consistent ortamda, uygulama katmanında conflict resolution mümkün olmadığı için veri tipleri kullanamıyoruz.

Riak veri tipleri sayesinde sınırlı da olsa search (arama) imkanı sağlıyor. Bunu da register, flag gibi belirli tipleri solr şemasında dynamic field olarak tanımlayarak yapıyor.[7]_ Bizim register, flag şeklinde işaretlediğimiz her veri, dynamic field tanımlaması sayesinde solr da indexleniyor. Riak'ın bu veri tipleri sayesinde search için eklediği ekstra bir özelliğe dair dökümanlarda altı çizilen bilgi  yok. Bizim verimize uyacak nested biçimde register, counter ve setler içeren maplere bağlı olarak dynamic field ı bu şekilde kullanmak, sayısız ve kontrolsüz biçimde artan index ve inverted indexlere[8]_ yol açacaktır.

===================================
**Neden Write Once Kullanmıyoruz?**
===================================

Write Once kullandığımızda sistem sürekli farklı keylere yazacağı için conflict oluşmaz. Fakat uygulama katmanında verinin bütünlüğü için alacağımız önlem, yani verinin yazılmadan önce okunması, farklı nodelardan okuma ve sistemde oluşabilecek gecikmelerden dolayı yüzde yüz garanti sağlamaz. Yazma isteğinin doğrulanması için yapılacak okuma ve yazma farklı nodelardan yapılacağı için burada da verinin bir öncekini baz alan iki farklı kopyası oluşacaktır. Bunun yanı sıra arama işini daha karmaşık hale getirmekte, çok kopyalı sonuçlar arasında en son kopyaya ulaşma gibi ekstra bir zorluk eklemektedir.

=============================
**Neden Strong Consistency?**
=============================

Riak Strong Consistency modunda conflictlere izin vermez. Veri tüm nodelarda eşlenene kadar yazıldı olarak kabul edilmez. Concurrent işlemlerde tıpkı RDBMS’lerdeki locklarda olduğu gibi yazma hataları döndürür. Bu da uygulama katmanında çok daha kolay yönetilebilir ve basit bir conflict resolution policy kullanılabilir anlamına gelir.

============================
**Neyi Nasıl Kullanacağız?**
============================

- Hayati veriler için Strong Consistent bucketlar kullanacağız. Tek kopya üzerinde çalışacağız. Datayı yapabildiğimiz kadar flat hale getirip, solr indexleri için mümkün olduğunca az dynamic field içeren şemalar kullanacağız. Flat haline getirilmiş bucket arasında linkler ile relationlar kuracağız. 
- Verinin versiyonlarını ayrı bir Write Once Bucket’ta tutacağız. Bunlara bir pk ve date fieldları ekleyip bu iki field ı solr da indexleyeceğiz.
- Log, temporary dataları eventually consistent olarak tutacağız. 


============================
**Notlar**
============================

.. [1] https://en.wikipedia.org/wiki/Object-relational_mapping
.. [2] https://en.wikipedia.org/wiki/High_availability
.. [3] http://docs.basho.com/riak/latest/dev/using/conflict-resolution/
.. [4] http://docs.basho.com/riak/latest/dev/using/conflict-resolution/#Client-and-Server-side-Conflict-Resolution
.. [5] http://docs.basho.com/riak/latest/ops/advanced/strong-consistency/#Important-Caveats
.. [6] https://github.com/basho/yokozuna/blob/develop/priv/default_schema.xml#L100
.. [7] http://docs.basho.com/riak/latest/dev/using/conflict-resolution/
.. [8] https://en.wikipedia.org/wiki/Inverted_index
