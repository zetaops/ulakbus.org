.. highlight:: python
   :linenothreshold: 3

++++++++++++++++++++++++++++++++++++++++++++++++
ZEngine ile İş Akışı Temelli Uygulama Geliştirme
++++++++++++++++++++++++++++++++++++++++++++++++


.. - İş akışı ve iş akışı temelli uygulama.
.. - ZEngine: İş akışı tabanlı web çatısı
..	- Falcon
..	- SpiffWorkflow
..	- Pyoko
..	- Modeller
..	- Ekranlar (Activities)
..	- Görevler (Jobs)
..	- Yetkiler ve Rol tabanlı erişim kontrolü.
.. - Adım adım bir web uygulamasının geliştirilmesi
..	- Geliştirme ortamının kurulumu
..	- Dizin & dosya yapısının oluşturulması
..	- İş akışlarının tasarlanması.
..	- Modellerin tanımlanması.
..	- Ekleme, görüntüleme, düzenleme ve silme işlemleri için CrudView kullanımı.
..	- Özelleştirilmiş ekranların oluşturulması.

İş akışı ve iş akışı temelli uygulama
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

İş akışları bir kurumun yürüttüğü işlerin belirli bir notasyona göre görselleştirilmesi amacıyla kullanılırlar. İşlerin kim tarafından, hangi sırayla, hangi koşullara bağlı olarak yürütüleceğinin ilgili personel tarafından üzerinde uzlaşılmış bir standartta ifade edilmesi, iş süreçlerinin kişiler arasında daha kolay ve doğru biçimde anlatılabilmesini sağladığı gibi sürecin iyileştirilmesi için yapılacak değişiklikleri tasarlamayı da kolaylaştırmaktadır.

.. image:: _static/workflow_ornek.png
    :width: 600px

İş akışı tabanlı uygulamalar, belirli bir dilde yazılmış akış diagramlarının, iş akışı motoru (workflow engine) tarafından işletilmesi temeline dayanırlar. İş akış motoru kullanıcı girdileri ve çevre değişkenlerini, iş akışında tanımlanmış koşullara karşı işletir. İlgili koşulun yönlendirdiği adımının (workflow step) etkinleştirilmesi, bu adımla ilişkilendilimiş uygulama metodlarının çalıştırılması ve kullanıcı etkileşimleri arasında akışın durumunun (workflow state) saklanması yine iş akışı motorunun görevidir.


ZEngine Web Çatısı
%%%%%%%%%%%%%%%%%%

ZEngine, Zetaops tarafından Python dili kullanılarak geliştirilen, Ulakbüs projesinin de üzerine inşa edildiği, BPMN 2.0 iş akışlarını destekleyen servis odaklı bir web çatısıdır. Falcon, SpiffWorkflow ve Pyoko olmak üzere üç temel öge üzerine kurulmuş olan ZEngine, iş akışı tabanlı web servislerinin Python nesneleri ile kolayca inşa edilmesini sağlayan, ölçeklenebilir ve güvenli bir platform sunar.

Falcon
******
Falcon, WSGI standardını destekleyen, REST mimarisinde servisler oluşturmak için geliştirilmiş aşırı hızlı ve hafif bir web çatısıdır.

SpiffWorkflow
*************
Spiffworkflow Python ile yazılmış BPMN 2 notasyonunu destekleyen güçlü bir iş akışı motorudur. ZEngine altında kullanılan sürümüne ihtiyaç duyulan ek işlevlerin eklenmesi ve bakımı Zetaops tarafından yapılmaktadır.

Pyoko
*****
Riak KV için tasarlanmış bir ORM (Object Relational Mapper) aracı olan Pyoko, Riak KV'nin Solr arama motoru ile olan entegrasyonunu tümüyle desteklemekte ve bu iki ürünün tek bir API üzerinden ilişkisel bir veri tabanı rahatlığında kullanılabilmesini olanaklı kılmaktadır.

Uygulamanın konusunu oluşturan varlıklar (entities) Pyoko modelleri olarak tasarlanmakta, bu modeller altında saklanan verilere erişim yine modellerde tanımlanan yetki koşullarına uygun olarak yönetilmektedir. Bir varlıkla doğrudan ilişkili metodlar kendi modelinin altında tanımlanebilmekte, böylece uygulamanın kod organizasyonu kolaylaşmaktadır.

Pyoko, veritabanında saklanacak verilerin Python nesneleri olarak tanımlanmasına imkan vermenin yanı sıra, bu veri varlıkları arasında ilişkisel veritabanlarındakine benzer bağlantılar oluşturmasını sağlar. Veri girdilerinin model tanımına uygunluğunun kontrolü ve kullanıcıların bu verilerle yetkileri dahilinde etkileşime geçebilmelerini garanti edilmesi de Pyoko sayesinde veri katmanı seviyesinde çözülebilen uygulama ihtiyaçlarıdır.

Modellerde iç içe sınıflar şeklinde ifade edilen veri varlıkları, veritabanına JSON biçiminde kaydedilir, okunurken tekrar Python nesnelerine dönüştürlürler.

NoSQL olarak da anılan Anahtar/Değer (K/V) tipindeki veri tabanlarında, ilişkisel veri tabanlarındaki (RDBMS) join kavramı olmadığından, henüz tasarım aşamasındayken verilerin nasıl sorgulanacağı iyi düşünülmeli ve mümkün mertebe tek sorguda ihtiyaç duyulan tüm verinin alınabileceği bir veri varlığı yapısı tasarlanmalıdır. Bu işlemin kolaylaştırılması ve uygulamanın iş mantığının veri senkronizasyonu amaçlı kodlarla dolmasını engellemek için Pyoko verileri yazma anında birleştirir (write-time join, auto-denormalization).

Veri Modelleri
***************
Pyoko karmaşık veri yapılarının nesnel şekilde ifade edilebilmesi için Model, Node ve ListNode adında üç temel nesne tipi sunmaktadır. Bu nesneleri, ihtiyacımız doğrultusunda iç içe ya da bir birleriyle ilişkilendirerek kullanabiliriz. Bu nesneler üzerinde saklanacak verileri tanımlamak için ise String, Boolean, Integer, Date gibi çeşitli veri alanları tanımlanmıştır.

Aşağıda, bu belgenin devamında birlikte hazırlayacağımız ve konusu "öğrencinin ders seçmesi, danışman öğretmeninin bu dersi onaylaması" olan bir iş akışın gerektirdiği veri modelinin minimal bir örneği listelenmiştir.

``15.`` Satırda olduğu gibi bir modelden başka bir modele referans verdiğimizde bu iki model arasında *OneToMany* tipinde bir bağ kurmuş oluruz.

``17.`` Satırda öğrencinin aldığı dersler ListNode tipindeki Lectures nesnesi ile ifade edilmiştir. ListNode, liste benzeri veri yapılarını ifade etmek için kullanılan, yinelenebilir (iterable) bir nesnedir.

``18.`` Satırda olduğu gibi ListNode içinde başka bir modele referans verildiğimizde, iki model arasında ilişkisel veritabanlarındaki *ManyToMany* benzeri bir ilişki tanımlamış oluruz.

::

    from pyoko import Model, ListNode, field

    class Lecturer(Model):
        name = field.String("Adı", index=True)


    class Lecture(Model):
        name = field.String("Ders adı", index=True)
        credit = field.Integer("Kredisi", default=0, index=True)


    class Student(Model):
        name = field.String("Adı", index=True)
        join_date = field.Date("Kayıt tarihi", index=True)
        advisor = Lecturer()

        class Lectures(ListNode):
            lecture = Lecture()
            confirmed = field.Boolean("Onaylandı", default=False)

Workflow Metodları (Views & Tasks)
**********************************
Workflow tabanlı bir uygulamada, uygulamanın tüm işlevselliği iş akışı adımları üzerinden çalıştırılacak şekilde hazırlanır. Bu işlevler BPMN diagramında UserTask ve ServiceTask adımlarının ilgili alanlarına girilen metod ve sınıf çağrıları ile yerine getirilir. İş akışı motoru, kullanıcı girdilerini (TaskData), o an işlettiği akış diagramında tanımlı ExclusiveGateway gibi karar kapılarına karşı işleterek akışı yönlendirir. Etkinleştirilen akış adımlarıyla ilişkili metod çağrıları sonucuna göre akış sonraki adıma devam edebilir ya da akışın durumu kaydedilip işlem çıktısı akışı tetikleyen kullanıcıya geri döndürülebilir.


Bir web uygulamasının işlevlerini yerine getirmesi için yazılan kodların büyük bir kısmı istemci (web tarayıcı) ile etkileşimi sağlayan API çağrıları üzerinden çağırılırken (views), bazı işlemler de arkaplanda çalışan görevler (tasks) ile yürütülür. Bu belgede *task* olarak anılacak bu arkaplan görevleri, doğası gereği tamamlanması uzun sürebilecek çeşitli hesaplamalar olabileceği gibi, dış servislere bağımlı olduklarından, kullanıcı deneyimini etkilememeleri için arkaplanda çalıştırılması gereken anlık görevler de olabilirer.

Current Nesnesi
----------------
İş akışı motoru bir view ya da task metodunu "Current" adını verdiğimiz merkezi bir nesneyi parametre olarak vererek çağırır. Current nesnesi akışın durumu (workflow state), kullanıcı oturumu, girdi ve çıtkı kapıları gibi bir workflow metodunun ihtiyaç duyabileceği tüm ögeleri barındırır.

::

    def say_hello(current):
        if current.user.first_login:
            current.output["msg"] = ("Welcome %s, Thank you for registering "
                                     "to our site." % current.input['name'])
            current.user.first_login = False
            current.user.save()

**Current nesnesi aşağıdaki ögeleri içerir;**

``input`` İstemciden gelen JSON verisinin çözümlenip (decode) Python sözlüğü şekline getirilmiş hali.

``output`` İstemciye gönderilecek veri sözlüğü. Bu sözlük otomatik olarak JSON verisi şekline dönüştürülür.

``session`` Kullanıcı oturumunu içeren sözlük benzeri bir nesnedir. Bu nesne üzerinde herhangi bir yazma/okuma işlemi yapıldığında, değişikliker otomatik olarak oturuma kaydedilir. Kullanıcı henüz sisteme giriş yapmamış olsa bile oturumu mevcuttur ve giriş yaptıktan sonra aynı oturum devam eder.

``auth`` Kullanıcı yetkilendirmesi ile ilgili metodları barındıran AuthBackend nesnesidir. *get_user(), get_permissions(), has_permission(), authenticate()* metodlarını içerir. ZEngine bu nesnenin referans sürümünü içerir ancak kendi uygulamamızda kullanıcı ve yetki sistemimize uygun şekilde özelleştirilmiş bir AuthBackend nesnesi kullanmamıza izin verir.

``user``

``workflow_name``

``workflow``

``task``

``task_data``

``is_auth``

``has_permission()``

``get_permissions()``
