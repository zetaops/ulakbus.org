+++++++++++++++++++++++++
Ulakbüs UI - API ilişkisi
+++++++++++++++++++++++++

=========================
Ulakbüs UI - API ilişkisi
=========================

| Bu belge **Ulakbus UI ve API** bileşenlerinin etkileşimini göstermek için hazırlanmıştır.
| API kullanılarak hazırlanan view, model ve jenerik fonksiyonlarda hangi tip verinin kullanıcı arayüzünde nasıl gösterildiğini bu belgede bulabilirsiniz.

***********
UI hakkında
***********

| Ulakbus kullanıcı arayüzü tek sayfalı bir tarayıcı uygulamasıdır.
| Sayfadaki data dinamik olarak Ulakbus API tarafından sağlanır ve arayüzde işlenir.
| Veri sunucu tarafında render edilmez, yani bir html dosyasına işlenerek gönderilmez.
| Sunucu tarafından gönderilen tüm verilerin yapısı ``JSON``'dır.
|
| Kullanıcı arayüzünü hazırlamak için `AngularJS <https://angularjs.org/>`_ kütüphanesi kullanılmıştır.
| 
| UI tamamıyla statik dosyalardan oluşmaktadır. ``index.html`` dosyası tarayıcı tarafından işlendikten sonra uygulama başlar.
| 
| Sayfa hazır olduktan sonra ``app.js`` dosyası çalışıp gerekli modülleri ve bağımlılıkları tanımlar.
| Uygulamanın ana modülü ``ulakbus`` modülüdür.
| 
| ``app_routes.js`` dosyasında uygulamanın sayfaları ve kullanacakları ``controller``’lar ve ``template``’leri düzenlenmiştir.
| Bu dosyaya göre istenen sayfa ilgili ``template`` ve ``controller`` ile yorumlanır.


UI başlangıcı
=============

| Uygulamanın bağlandığı kararlı api sunucusu ``http://api.ulakbus.net`` adresinde bulunur. Geliştirme ortamı için ``http://nightly.api.ulakbus.net`` adresinde bulunur. 
| Kararlı api sunucusu varsayılan sunucudur.
| Yerel yada başka bir adresteki sunucuyu kullanmak için başlangıç adresinde “backendurl” parametresi ile adresi girmeniz gerekmektedir. Yerel geliştirme ortamında nightly sunucusuna bağlanmak için adres satırına ``http://localhost/?backendurl=http://nightly.api.ulakbus.net`` yazmanız yeterlidir.
| 
| Uygulama başlatılıp tüm modül tanımlarmaları yapıldıktan sonra tarayıcı kullanıcıyı ``/dashboard`` adresine yönlendirir. Uygulamanın en başında kullanıcının login durumu kontrol eder ve kullanıcı mevcut değil ise ``/login`` ekranına yönlendirilir.


Login işlemi
------------

| Login işlemi için ``http://api.ulakbus.net/login`` adresine kullanıcı parametreleriyle XHR istegi gönderilir.
| Gelen yanıt ``JSON`` nesnesinde ``cmd`` parametresini baz alarak işlemin sonucunu değerlendirilir. ``cmd``, ``upgrade`` veya ``retry`` gelebilir.
|
| ``upgrade`` yanıtıyla birlikte ``ws://api.ulakbus.net/ws`` adresinde websocket açılır. Kullanıcı ``/dashboard``'a yönlendirilir. Geri kalan tüm iletişim websocket üzerinden yönetilir.
|
| Yanlış bilgi girildiğinde ``retry`` yanıtı alınır ve kullanıcı tekrar ``/login`` sayfasına yönlendirilir. Başka aksiyon alınmaz.


Dashboard
---------

| Kullanıcı login olduktan sonra dashboard ekranına geldiği anda ``{view: 'dashboard'}`` isteği yapılır. bu isteğin yanıtında kullacının bilgisi ve de kulanıcı menüleri gelir.
| 
| Ulakbus uygulaması iş akışı tabanlı bir uygulamadır. BPMN 2.0 standartlarını kullanır.
| İş akış şemaları yani ``workflow`` lar bpmn formatında backend API’da oluşturulur.
| Bu iş akış şemaları kendilerine ait model ve view metotlarını kullanarak tanımlanan işi belirlenen adımlarla gerçekleştirirler.


Api response
------------

Kullanıcı kendine ait işakışlarına menüler aracılığıyla ulaşır.
Kullanıcı bir iş akışı başlattığında api ye başlattığı iş akışının model ve workflow bilgisini gönderir. Api den gelen bilgiler ile UI tarafından yorumlanır. Yorumlama işlemi ``CRUDListFormController`` tarafından yapılmaktadır. 

Gelen yanıt içerisinde yer alan ``client_cmd`` parametresine göre yorumlama tipi seçilir. 
``client_cmd`` değeri ``show``, ``list``, ``form``, ``reload`` veya ``reset`` olabilir.

+ ``form`` gönderilen datanın ``forms`` nesnesi taşıdığı ve kullanıcı arayüzünün bunu form olarak yorumlaması gerektiği durumlarda kullanılır.
+ ``list`` sayfada listelenmesi istenen bir data olduğunda kullanılır. Bu data table olarak listelenir.
+ ``show`` komutu sayfada detay bilgileriyle gösterilmek istenen bır data olduğunda kullanılır.
+ ``reload`` komutu sayfada gösterilen datada bir değişiklik olduğu ve datanın API’dan yeniden istenmesi gerektiği durumlarda kullanılır.
+ ``reset`` komutu datanın ek parametreler olmadan yeniden çekilmesi için kullanılır.

Bu komutlar oluşturulan iş akışlarının ilgili adımlarında kullanılarak arayüzün istenen şekilde davranması için gereklidir.

Diğer yanıt parametreleri forms, meta, objects, pagination, reload_cmd, token, callbackID, notify, is_login olabilir.

* ``reload_cmd`` anahtarı ``"client_cmd": "reload"`` olması durumunda arayüzün backend API’dan isteyeceği komutu taşır. UI post datası içinde cmd anahtarında bu değeri gönderir.

* ``token`` anahtarında iş akış şemasının (``workflow``) redis’te tutulan token değeri vardır. İş akışı tamamlanmadığı sürece bu token request nesnesinde API’a gönderilir.

* ``callbackID`` UI tarafından üretilip gönderilmektedir. Yanıt içerisinde bulunuyorsa UI tarafından yapılan bir isteğin yanıtı olduğu anlamına gelmektedir. Uygulama genelinde yapılan isteklerde Javascript Promise alt yapısı kullanılarak asenkron istek yapılmaktadır. Bekleyen promise resolve edilerek iş akışının devamı sağlanmaktadır.

* ``meta`` anahtarında arayüzde istenen yapılandırmalar yer alır. Boolean değer taşırlar. Bunlar şunlardır;
    - ``allow_search`` Listeleme ekranında arama kutusunun gösterilmesi için kullanılır.
    - ``allow_selection`` Listeleme ekranında tablonun solunda selectBox yer alması için kullanılır.
    - ``allow_sort`` Listeleme ekranındaki sıralama özelliği için kullanılır.
    - ``allow_filter`` Listelenen datanın filtrelemesi için kullanılır.
    - ``allow_actions`` ListNode tipinde listelenen data için en sağdaki işlemler kolonunun gösterilmesi için kullanılır.
    - ``translate_widget`` Katalog verilerin düzenleneceği ekran için oluşturulan widget’dır. Aynı zamanda çeviri işlemleri için kullanılacaktır. Boolean tipinde değer alır.

* ``_debug_queries`` anahtarı geliştiriciler için yardımcı bir anahtardır. Veritabanına yapılan sorguların süresi ve kaç adet sorgu yapıldığı gibi değerler bu anahtarda yer alır. Aktif olması için API ortamında çevre değişkeni ``DEBUG=1`` olarak atanmalıdır.

* ``is_login`` anahtarı kullanıcının giriş yapıp yapmadığını gösteren bir anahtardır. Bu anahtar ``false`` değer taşıdığında arayüz login sayfasına yönlendirir.

* ``notify`` ayayüzde bildirim göstermek için kullanılır. Gönderilen bildirimler pencerenin sağ üstünde yer alır ve bir süre sonra kaybolur.

* ``pagination`` anahtarı listeleme gösterimlarinde sayfalama bilgisini bulundurur.


Ulakbüs UI Öğeleri
------------------

| Ulakbüs kullanıcı arayüzünde sunulan temel öğeler şunlardır;

- Form öğesi - Ekleme ve düzenleme işlemleri
- Liste öğesi - Listeleme, arama, filtre ve silme işlemleri
- Detay öğesi - Tek nesne detay ve rapor ekranları

| Bu öğe türleri API’ın iş akışlarında sunduğu temel içerik türleridir.
| Bu içerik türlerinin kullanıcı arayüzünde doğru biçimde yorumlanması için API yanıtı içerisinde gönderilecek anahtar değerler belirlenmiştir.
| Bu anahtarlar aşağıdaki tablodaki gibidir;

+---------------+---------------+
| İçerik türü   | Anahtar       |
+===============+===============+
| Form          | ``forms``     |
+---------------+---------------+
| Liste         | ``objects``   |
+---------------+---------------+
| Detay         | ``object``    |
+---------------+---------------+


| İçerik türleri aynı sayfa içerisinde bulunabilir. Bu koşulda

1. detay
2. form
3. liste

| sırasına uygun şekilde aynı sayfada listelenir


Form Öğesi
~~~~~~~~~~

| Ulakbus UI form işlemlerini gerçekleştirmek için angular-schema-form_ extend edilmiştir.
| Kullanılan form nesneleri angular-schema-form'un beklediği formatta olmalı ya da değilse extend edilerek `custom type` yaratılmalıdır.

.. _angular-schema-form: https://github.com/Textalk/angular-schema-form

Örnek bir ``forms`` nesnesi aşağıdaki gibidir:

.. code:: json

    {
        "forms":{
            "constraints":{},
            "model":{ "ad":null, "soyad":null },
            "grouping":{},
            "form":[
                { "helpvalue":null, "type":"help" },
                "ad",
                "soyad",
                {
                    "titleMap":[
                        { "name":"Bay", "value":1 },
                        { "name":"Bayan", "value":2 }
                    ],
                    "type":"select",
                    "key":"cinsiyet",
                    "title":"Cinsiyet"
                },
                "e_posta",
                "dogum_tarihi",
                "save_edit",
                "nufus_kayitlari_id",
            ],
            "schema":{
                "required":[ "ad", "soyad" ],
                "type":"object",
                "properties":{
                    "ad":{ "type":"string", "title":"Adı" },
                    "soyad":{ "type":"string", "title":"Soyadı" },
                    "e_posta":{ "type":"string", "title":"E-Posta" },
                    "save_edit":{ "cmd":"save::add_edit_form", "type":"button", "title":"Kaydet" },
                    "nufus_kayitlari_id":{
                        "list_cmd":"select_list",
                        "title":"Nüfus Bilgileri",
                        "wf":"crud",
                        "add_cmd":"add_edit_form",
                        "type":"model",
                        "model_name":"NufusKayitlari"
                    },
                    "dogum_tarihi":{ "type":"date", "title":"Doğum Tarihi" },
                    "cinsiyet":{ "type":"select", "title":"Cinsiyet" }
                },
                "title":"Personel"
            }
        }
    }


``forms``’un öğeler ise şunlardır:

- ``form``

Bu anahtar altında formda gösterilmesi istenen inputlar bir liste halinde yer alır.

- ``schema``

| ``schema`` anahtarının alt özellikleri vardır. Bunlardan ``required`` bir liste halinde doldurulması gerekli alanları gösterir.
| ``properties`` anahtarında ``form`` anahtarında belirtilen alanların özelliklerinin yer aldığı anahtardır.

.. code:: json

    {
        "e_posta":{ "type":"string", "title":"E-Posta" }
    }

| ``type`` alanında inputun tipi ve ``title`` alanında bu inputun başlığı yer alır.

    İlişkisel veri tipleri olan ListNode, Node ve Model için bu anahtarlarda ``wf``, ``add_cmd``, ``list_cmd``, ``model_name`` değerleri bulunmaktadır.
    Bu değerler form sayfası oluşturulurken dikkate alınır.

    Formlarda birden fazla buton değişik işleri yapabilsin diye bu input alanlarına ``cmd`` değeri eklenmiştir. Bu değer form submit edilirken ``cmd`` anahtarında API'a gönderilir.

    Ek işlevsellik isteyen alanlar için (`Node, ListNode, Model, select, file, submit, date, text_general`, etc.) template'ler oluşturulmuştur.

    Field tipleri şunlar olabilir:

    - ``button``
    - ``submit``
    - ``file``
    - ``select``
    - ``date``
    - ``int``
    - ``boolean``
    - ``string``
    - ``typeahead``
    - ``text_general``
    - ``float``
    - ``model``
    - ``Node``
    - ``ListNode``

- ``model``

| Bu anahtarda form alanlarının değerleri tutulmaktadır.
| Düzenlenecek form için bu anahtardaki değerler dolu olarak döner ve inputlara atanır.
| Boş değer dönmesi o anahtar için daha önceden bir kayıt yapılmadığını gösterir.


- ``grouping``

| Form inputlarının sayfa yerleşimlerini düzenleyebilmek için eklenmiş bir özelliktir.
| Grid sistem baz alınarak gruplanan elemanlara alan değerleri atanır. ``layout`` değeri 12 birimlik alanda kaç birim olarak yer alacağını gösterir.
| Aşağıda bu özelliğin bir örneği görülebilir:

.. code:: json

    {
        "grouping": [
            {
                "group_title": "Gorev",
                "items": ["gorev_tipi", "birim", "aciklama"],
                "layout": "4",
                "collapse": false
            }
        ]
    }

- ``constraints``

Form inputlarının birbirlerine göre bağımlılıklarının denetlendiği ve düzenlendiği anahtardır. Geliştirme aşamasındadır.


Liste öğesi
~~~~~~~~~~~

Liste öğesinde kaydedilen nesneler listelenir.

- Listelenecek öğeler ``objects`` anahtarında döner. Dönen listede ilk nesne listenin başlık değerlerini oluşturur.
- İkinci nesneden itibaren ``fields`` anahtarında liste halinde aynı sırayla ilk nesnedeki başlıkların karşılığı değerler yer almaktadır.
- ``actions`` anahtarında o satır için gerçekleştirilebilecek işlemler yer almaktadır. İşlemlerin gösterim şekilleri ``show_as`` anahtarında gönderilir.
- İşlemler varsayılan olarak satırın sonundaki işlemler alanında gösterilir.
- Eğer satırdaki bir hücreye uygulanması isteniyorsa hangi alana uygulanacağı bir liste içinde işlem nesnesinin ``fields`` anahtarında belitrilir.
- Gerçekleştirilecek işlemin ne olacağı işlemin ``cmd`` anahtarında yer alır. ``mode`` anahtarı `normal` (varsayılan), `new` (yeni sayfada) ve `modal` (bir modal içinde) değerlerini alabilir.
- ``pagination`` anahtarında sayfalama uygulandıysa sayfa başına kaç nesne olduğu ``per_page``, toplam nesne sayısı ``total_objects``, toplam sayfa sayısı ``total_pages``, ve o an hangi sayfada olunduğu ``page`` bilgisi yer alır.


    Liste sayfasıyla birlikte gönderilen ``"forms"`` anahtarında o sayfada ayrıca form işlemlerinin yapılması sağlanmaktadır. Aşağıdaki örnekte o anki modele yeni bir kayıt eklemek için forms anahtarının kullanıldığı görülmektedir.


.. code:: json

    {
        "forms":{
            "constraints":{},
            "model":{ "add": null },
            "grouping":{},
            "form":[ "add" ],
            "schema":{
                "required":[ "add" ],
                "type":"object",
                "properties":{
                    "add":{
                        "cmd":"add_edit_form",
                        "type":"button",
                        "title":"Ekle"
                    }
                },
                "title":"Personeller"
            }
        },
        "pagination":{
            "per_page":8,
            "total_objects":26,
            "total_pages":3,
            "page":1
        },
        "objects":[
            [ "Adı", "Soyadı", "TC No", "Durum" ],
            {
                "fields":[
                    "Işık",
                    "Ülker",
                    "19189958696",
                    null
                ],
                "actions":[
                    {
                        "fields":[
                            0
                        ],
                        "cmd":"show",
                        "mode":"normal",
                        "show_as":"link"
                    },
                    {
                        "cmd":"add_edit_form",
                        "name":"Düzenle",
                        "show_as":"button",
                        "mode":"normal"
                    },
                    {
                        "cmd":"delete",
                        "name":"Sil",
                        "show_as":"button",
                        "mode":"normal"
                    }
                ],
                "key":"1234qwer"
            }
        ]
    }


Detay öğesi
~~~~~~~~~~~

Detay öğesinde gösterilmek istenen nesne anahtar değer olarak sıralanır. Örnekte bir kişi kaydının anahtar değerleri görülmektedir.

.. code:: json

    {
        "object":{
            "Cep Telefonu":"+90 (259) 6925396",
            "Cinsiyet":"Erkek",
            "Soyadı":"Arsoy",
            "TC No":"63488661696",
            "Adı":"Kutun",
            "Doğum Tarihi":"03.04.1969",
            "E-Posta":"daslan@arsoy.com"
        }
    }


UI Menu ve Diğer Öğeler
~~~~~~~~~~~~~~~~~~~~~~~

| Kullanıcı arayüzündeki menüler API tarafından dinamik olarak giriş yapan kullanıcının yetkileri baz alınarak oluşturulur.
| ``/menu`` url'ine yapılan sorguda dönen ``ogrenci``, ``personel``, ``other`` anahtarlarındaki değerler kategorilerine göre ayıklanarak menüye eklenir.

- Ulakbus için iki ana işlem yapılacak kullanıcı tipi bulunmaktadır. Bunlar personel ve öğrencidir. Bu anahtarların sorguda dönme durumuna göre yönetim panelinde öğrenci ve personel arama inputları görüntülenir.
- ``quick_menu`` anahtarında dönen menu nesneleri yönetim panelinde hızlı erişim için yer alır.

| Menu sorgusunda ayrıca ``settings`` ve ``current_user`` anahtarları dönmektedir.

- ``settings`` anahtarı API tarafından kullanıcı arayüzü konfigürasyonu için kullanılacak değerleri içerir. Şu anda static url path bu ayarlarda yer almaktadır.
- ``current_user`` anahtarında giriş yapan kullanıcı bilgileri, rolleri, o anda hangi rolde işlem yaptığı ve kullanıcı avatarı yer almaktadır.

.. code:: json

    {
        "ogrenci":[
            {
                "kategori":"Seçime Uygun Görevler",
                "text":"Devam Durumu",
                "model":"DersKatilimi",
                "param":"ogrenci_id",
                "wf":"crud"
            }
        ],
        "personel":[
            {
                "kategori":"Seçime Uygun Görevler",
                "text":"Kimlik ve Iletisim Bilgileri",
                "model":"Personel",
                "param":"object_id",
                "wf":"kimlik_ve_iletisim_bilgileri"
            }
        ],
        "settings":{
            "static_url":"http://ulakbus.3s.ulakbus.net/"
        },
        "other":[
            {
                "kategori":"Genel",
                "text":"Personeller",
                "model":"Personel",
                "param":"other_id",
                "wf":"crud"
            }
        ],
        "current_user":{
            "username":"test_user",
            "is_staff":true,
            "surname":"Stallman",
            "name":"Richard",
            "roles":[
                {
                    "role":"Role BaseAbsRole | test_user"
                },
                {
                    "role":"Role W.C. Hero test_user"
                }
            ],
            "role":"BaseAbsRole",
            "is_student":false,
            "avatar":"http://ulakbus.3s.ulakbus.net/abcd.jpg"
        },
        "is_login":true,
        "quick_menu":[
            {
                "kategori":"Genel",
                "text":"Programlar",
                "model":"Program",
                "param":"other_id",
                "wf":"crud"
            }
        ]
    }


Logout İşlemi
-------------

| Logout işlemi de Ulakbüs için bir iş akışıdır. Logout için ``{wf: "logout"}`` bilgisi API'a gönderilir. Gelen yanıt ardından websoket kapatılır, oturum sonlanır.


Geliştirmeye Başlamak
---------------------

| Yukarıda anlatılan API-UI veri karşılıkları gözönünde bulundurularak geliştirme yapmaya başlayabilirsiniz.
