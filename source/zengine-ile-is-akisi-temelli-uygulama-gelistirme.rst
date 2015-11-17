.. highlight:: python
   :linenothreshold: 3

++++++++++++++++++++++++++++++++++++++++++++++++
ZEngine ile İş Akışı Temelli Uygulama Geliştirme
++++++++++++++++++++++++++++++++++++++++++++++++


.. - İş akışı ve iş akışı temelli uygulama.
.. - ZEngine: İş akışı tabanlı web çatısı
.. - Falcon
.. - SpiffWorkflow
.. - Pyoko
.. - Modeller
.. - Ekranlar (Activities)
.. - Görevler (Jobs)
.. - Yetkiler ve Rol tabanlı erişim kontrolü.
.. - Adım adım bir web uygulamasının geliştirilmesi
.. - Geliştirme ortamının kurulumu
.. - Dizin & dosya yapısının oluşturulması
.. - İş akışlarının tasarlanması.
.. - Modellerin tanımlanması.
.. - Ekleme, görüntüleme, düzenleme ve silme işlemleri için CrudView kullanımı.
.. - Özelleştirilmiş ekranların oluşturulması.

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
**************
Pyoko karmaşık veri yapılarının nesnel şekilde ifade edilebilmesi için Model, Node ve ListNode adında üç temel nesne tipi sunmaktadır. Bu nesneleri, ihtiyacımız doğrultusunda iç içe ya da birbirleriyle ilişkilendirerek kullanabiliriz. Bu nesneler üzerinde saklanacak verileri tanımlamak için ise String, Boolean, Integer, Date gibi çeşitli veri alanları tanımlanmıştır.

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

Bu modeller üzerinde kayıt ekleme, sorgulama, silme, güncelleme işlemlerinin
nasıl yapılacağını belgenin devamında "özelleştirilmiş ekranların oluşturulması" bölümünde inceleyebilirsiniz.

Workflow Metodları (Views & Tasks)
**********************************
Workflow tabanlı bir uygulamada, uygulamanın tüm işlevselliği iş akışı adımları üzerinden çalıştırılacak şekilde hazırlanır. Bu işlevler BPMN diagramında UserTask ve ServiceTask adımlarının ilgili alanlarına girilen metod ve sınıf çağrıları ile yerine getirilir. İş akışı motoru, kullanıcı girdilerini (TaskData), o an işlettiği akış diagramında tanımlı ExclusiveGateway gibi karar kapılarına karşı işleterek akışı yönlendirir. Etkinleştirilen akış adımlarıyla ilişkili metod çağrıları sonucuna göre akış sonraki adıma devam edebilir ya da akışın durumu kaydedilip işlem çıktısı akışı tetikleyen kullanıcıya geri döndürülebilir.


Bir web uygulamasının işlevlerini yerine getirmesi için yazılan kodların büyük bir kısmı istemci (web tarayıcı) ile etkileşimi sağlayan API çağrıları üzerinden çağırılırken (views), bazı işlemler de arkaplanda çalışan görevler (tasks) ile yürütülür. Bu belgede *task* olarak anılacak bu arkaplan görevleri, doğası gereği tamamlanması uzun sürebilecek çeşitli hesaplamalar olabileceği gibi, dış servislere bağımlı olduklarından, kullanıcı deneyimini etkilememeleri için arkaplanda çalıştırılması gereken anlık görevler de olabilirer.

İster view ister task tipinde olsunlar, workflow metodarının tüm girdi & çıktı işlemleri current.input ve current.output sözlükleri üzerinden yapılır.


::

    def say_hello(current):
        if current.user.first_login:
            current.output["msg"] = ("Welcome %s, Thank you for registering "
                                     "to our site." % current.input['name'])
            current.user.first_login = False
            current.user.save()

Current Nesnesi
---------------
İş akışı motoru bir view ya da task metodunu "Current" adını verdiğimiz merkezi bir nesneyi parametre olarak vererek çağırır. Current nesnesi akışın durumu (workflow state), kullanıcı oturumu, girdi ve çıktı kapıları gibi bir workflow metodunun ihtiyaç duyabileceği tüm ögeleri barındırır.

Current nesnesi, workflow metodlarından işimize yarayabilecek aşağıdaki ögeleri içerir. Bunlardan *session, user, auth* gibi sadece view metodlarında işlevsel olanlar arkaplanda çalışan task metodlarında geçersizdirler.

``input`` İstemciden gelen JSON verisinin çözümlenip (decode) Python sözlüğü şekline getirilmiş hali.

``output`` İstemciye gönderilecek veri sözlüğü. Bu sözlük otomatik olarak JSON verisi şekline dönüştürülür.

``session`` Kullanıcı oturumunu içeren sözlük benzeri bir nesnedir. Bu nesne üzerinde herhangi bir yazma/okuma işlemi yapıldığında, değişiklikler otomatik olarak oturuma kaydedilir. Kullanıcı henüz sisteme giriş yapmamış olsa bile oturumu mevcuttur ve giriş yaptıktan sonra aynı oturum devam eder.

``auth`` Kullanıcı yetkilendirmesi ile ilgili metodları barındıran AuthBackend nesnesidir. *get_user(), get_permissions(), has_permission(), authenticate()* metodlarını içerir. ZEngine bu nesnenin referans sürümünü içerir ancak kendi uygulamamızda kullanıcı ve yetki sistemimize uygun şekilde özelleştirilmiş bir AuthBackend nesnesi kullanmamıza izin verir.

``user`` Sisteme giriş yapmış kullanıcıyı veren vekil (lazy proxy) kullanıcı nesnesidir. Asıl kullanıcı bilgileri, bu nesneye erişildiği anda veritabanından çekilir.

``task_data`` İş akışının karar adımlarında tanımlı koşullar bu sözlüğün içerdiği veriler ile işletilir.

``workflow_name`` İşletilmekte olan iş akışının adı.

``workflow`` İşletilmekte olan iş akışı nesnesi.

``task`` Etkin durumdaki iş akışı adımı (Task) nesnesi.

``is_auth`` Kullanıcının sisteme giriş yapma durumunu belirten bool tipinde bir özelliktir.

``has_permission(perm_code_name)`` Kullanıcının adı verilen yetkiye sahip olup olmadığını boolean tipinde döndürür.

``get_permissions()`` Kullanıcının sahip olduğu tüm yetkileri döndürür.

Yetkiler ve Rol Tabanlı Erişim Kontrolü
***************************************
ZEngine Pyoko'dan miras aldığı *satır ve hücre seviyesinde erişim kontrolüne* ek olarak, sisteme yüklenmiş iş akışlarının tüm adımlarını birer yetki olarak tanımlar. Otomatik olarak türetilen iş akışı yetkilerine ek olarak, CustomPermission nesnesi ile, kendi view metodlarımızda kontrol edebileceğimiz ek yetkiler de tanımlayabilirz. Tüm bu yetkiler *Role* ve *AbstractRole* modelleri ile ifade edilen kullanıcı rolleri üzerinden ilgili User'a tanımlanır.

.. note::
    ZEngine web çatısı User ve Permission nesnelerinden ibaret basit bir referans yetki sistemi ile gelmektedir. Bu belgede, Ulakbüs projesi kapsamında geliştirmekte olduğumuz rol ve özellik tabanlı gelişmiş yetkilendirme sisteminden bahsedilecektir.

.. uml::
    skinparam classBackgroundColor #ffffff
    skinparam shadowing false

    class LimitedPermissions {
    restrictive     Boolean(False)
    time_start      String
    time_end        String
    --
    **IPList(ListNode)**
    |_ ip           String
    }
    User "1" -- "1" Student
    User "1" -- "1" Employee
    User "0..*" o-- "1" Role
    Role "1" --o "0..*" AbstractRole
    AbstractRole "0..*" o-- "0..*" Permission
    Role "0..*" o-- "0..*" Permission
    LimitedPermissions "0..*" -- "0..*" Permission
    LimitedPermissions "0..*" -- "0..*" Role
    LimitedPermissions "0..*" -- "0..*" AbstractRole

Ulakbüs projesinde ihtiyaç duyulan kapsamlı yetkilendirme ihtiyaçlarını karşılayabilmek için yukarıda ilişkisel şekilde görselleştirilmiş yetki modelleri tanımlanmıştır.

AbstractRole nesnesi "Tıp Fakültesi Öğrenci İşleri Müdürü" gibi belirli bir makamı temsil ederken, Role nesnesi ise AbstractRole'ün bir kullanıcı ile ilişkilendirilmesi sonucu bu makamı fiilen işgal eden bir kişiyi ifade etmektedir.

Permission nesnesinin hem Role ile hem de AbstractRole ile ManyToMany tipinde ilişkili olması sayesinde, bir kullanıcıya sahip olduğu makamın getirdiği standart yetkilere ek yetkilerin tanıması da mümkün olabilmektedir.

LimitedPermissions nesnesi IP adres ve saat bazlı olarak Permission, Role ve AbstractRole nesneleri ile ManyToMany tipinde ilişkilidir. Bu ilişki sayesinde seçilen rol ya da makamın, seçilen yetkileri belirli saatlere, istemci IP'lerine yada belirli saatlerler için belirli IP'lere göre kısıtlanabilir ya da verilebilir.

Student ve Employee nesnelerinin User ile OneToOne şeklinde ilişkili olmaları, bir kullanıcının aynı anda hem öğrenci hem de personel statüsünde olabilmesine olanak vermektedir. Benzer şekilde User ile Role nesnesi arasındaki OneToMany tipindeki ilişki, bir kullanıcının birden fazla rolü yani makamı olabilmesine imkan vermektedir. Birden fazla rolü olan bir kullanıcı giriş yaptığında son çıkış yaptığı rolün ana ekranı ile karşılaşır, isterse kullanıcı menüsünden hesabına kayıtlı diğer bir role geçiş yapabilir. Kullanıcı belirli bir anda, sadece o anda etkin durumda olan rolünün yetkileri ile işlem yapabilir.

Satır ve Hücre Seviyesinde Erişim Kontrolü
------------------------------------------
Pyoko, model tanımları içerisinde satır ve hücre seviyesinde erişim kontrolü yapılmasına izin verir. Burada satır seviyesinden  kasıt, kullanıcının yetkisinin izin vermediği kayıtlara erişememesidir. Hücre seviyesinde ise, kullanıcının bir modelin altındaki kayıtların sadece bazı alanlarına erişimesine izin verip, bazı alanlardaki verilere erişimi kısıtlanabilir.

Satır ve hücre seviyesinde erişim kontrolünün veri katmanı seviyesinde çalışabilmesi için, model nesnelerinin kullanıcı yetkilerini içeren *Current* nesnesi ile ilklendirilmeleri gerekmektedir. Bu işlevler isteğe bağlı özellikler olduklarından, bu gereklilik sadece aşağıdaki gibi model içinde yetki kısıtlaması yapıldığı durumlarda geçerlidir.

::

    class Personel(Model):
        name = field.String(index=True)
        section = field.String(index=True)
        phone = field.String(index=True)
        address = field.String(index=True)

        @staticmethod
        def row_level_access(current, objects):
            if not current.has_permission("access_to_other_sections"):
                return objects.filter(section=current.user.section)

        class Meta:
            field_permissions = {
                'can_see_private_data': ['phone', 'address']
            }

Yukarıdaki Personel modelinin ``6.`` satırında tanımlanan **row_level_access()** metodu, modelin ilklendirilmesi (initialization) aşamasında çağırılır. ``7.`` satırda kullanıcının kendi bölümü dışındaki kullanıcı kayıtlarına erişim yetkisi olup olmadığı kontrol edilip, eğer yoksa ``8.`` satıda **objects** nesnesinin üzerine yazarak etkin kullanıcı tarafından bu model üzerinde yapılacak tüm sorguların sadece kendi bölümündeki kullanıcı kayıtlarıyla sınırlanması sağlanır.

Hücre seviyesinde erişim kısıtlaması yapmak için META sözlüğü içerisinde **field_permissions** adında bir sözlük tanımlayıp, anahtarı yetki adları, değeri de kısıtlanacak alan adlarını içeren bir liste tanımlamamız yeterlidir. Yukarıda ``12.`` satırda tanımlanan kısıtlama sayesinde, *can_see_private_data* yetkisine sahip olmayan kullanıcıların *phone* ve *address* alanlarını okuyup yazmaları engellenmiş olur.

Aşağıda veri tabanındaki tüm kişileri listelemeye çalışan view metodu, etkin kullanıcının gerekli yetkiye sahip olmaması durumunda, sadece kendi bölümündeki kullanıcıları görüntüleyebilecektir. Benzer şekilde kullanıcı kişilerin özel bilgilerini görüntüleme yetkisine sahip değilse de *person_list* listesinin *phone* sütunu boş kalacaktır.

::

    def show_person_list(current):
        for person in Person(current).objects.filter():
            current.output['person_list'].append({'name': person.name,
                                                  'id': person.key,
                                                  'phone': person.phone})

Adım adım bir web uygulamasının geliştirilmesi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Aşağıdaki adımları tamamlayınca kullanıcı yetkilerinin ayarlandığı bir ayar ekranı oluşturmuş olacağız.



Geliştirme ortamının kurulumu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Git ve Vagrant araçlarına ihtiyacınız var.
Vagrant box ile gerekli ortamı elde edebilirsiniz. (link eklenecek)


Dizin & dosya yapısının oluşturulması
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


İş akışlarının tasarlanması.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



Modellerin tanımlanması.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ekleme, görüntüleme, düzenleme ve silme işlemleri için CrudView kullanımı.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Özelleştirilmiş ekranların oluşturulması.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
