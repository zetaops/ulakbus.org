++++++++++++++++++++++++
ULAKBUS UI--API İlişkisi
++++++++++++++++++++++++

========================
ULAKBUS UI--API İlişkisi
========================

| Bu belge **Ulakbus UI ve API** bileşenlerinin etkileşimini göstermek için hazırlanmıştır.
| API kullanılarak hazırlanan view, model ve jenerik fonksiyonlarda hangi tip verinin kullanıcı arayüzünde nasıl gösterildiğini bu belgede bulabilirsiniz.

UI Nasıl Başlar?
~~~~~~~~~~~~~~~~

| Ulakbus kullanıcı arayüzü tek sayfalı bir tarayıcı uygulamasıdır.
| Sayfadaki data dinamik olarak `Ulakbus API` tarafından sağlanır ve arayüzde işlenir.
| Veri sunucu tarafında render edilmez, yani bir html dosyasına işlenerek gönderilmez.
|
| Bu iş için angularjs_ tercih edilmiştir.
|
| UI sunucudan istendiğinde bağımlı olduğu statik dosyalar edinildikten sonra ``app.js`` dosyasının yorumlanmasıyla başlar. Bu dosyada ``ulakbus`` modülü başlatılır.
| AngularJS DI_ (dependency injection) modeline göre bağımlılıklar işlenir.
|
| ``app_routes.js`` dosyasında uygulamanın sayfaları ve kullanacakları controller'lar ve template'leri düzenlenmiştir.
| Bu dosyaya göre istenen sayfa ilgili template ve controller ile yorumlanır.
|
| CRUD işlemleri ``crud_controller.js`` dosyasında tanımlanan CRUDListFormCtrl isimli controller ve ``form_service.js`` dosyasında tanımlanan form_service isimli servisle gerçekleştirilir.
|
| Kullanıcı arayüzü başlatıldığında ilk olarak API'dan menu sorgusu çekilir.
| Bunun nedeni giriş yapan kullanıcı bilgilerinin de bu sorguda dönmesidir.
| Eğer http-401 hata kodu dönerse kullanıcı girişi yapılmamış anlamına gelir ve UI login sayfasına yönlendirir.

.. _angularjs: https://angularjs.org
.. _DI: https://docs.angularjs.org/guide/di

Veri - UI ilişkisi
~~~~~~~~~~~~~~~~~~

| Kullanıcı arayüzü veriyi API'a yaptığı rest sorgular üzerinden alır ve gönderir. Veriyle doğrudan ilişkisi yoktur.
| Bir kullanıcı giriş yaptığında onun erişebileceği veriler Ulakbus API'da düzenlenip kullanıcı arayüzüne sunulur.

Genel
~~~~~

| Ulakbus kullanıcı arayüzü yapacağı işlemlerle ilgili komutları API'dan alacak şekilde kurgulanmıştır.
| Kullanıcı arayüzü Ulakbus API tarafından kullanılan bir araç olarak düşünülebilir.
| API o anda kullanıcının neler yapabileceğini, sayfa öğelerini, sayfa öğelerinin konumlandırılmalarını belirleyici veriyi arayüze sağlar ve arayüz bu veriye göre yorumlanır.
| Kullanıcı arayüzü dummy bir uygulama olarak tasarlanmıştır, mevcut yazılan arayüz fonksiyonları Ulakbus API tarafından yollanan veri ile kullanılır.
|
| Ulakbus uygulaması iş akışı tabanlı bir uygulamadır. BPMN 2.0 standartlarını kullanır.
| İş akış şemaları yani *workflow* lar bpmn formatında backend API'da oluşturulur.
| Bu iş akış şemaları kendilerine ait model ve view metotlarını kullanarak tanımlanan işi belirlenen adımlarla gerçekleştirirler.
|
| İş akışının arayüzde akışa uygun şekilde gerçekleştirilmesi için kullanılacak anahtar-değerler ( *key-value* ) API
| tarafından ``response`` nesnesinde arayüze gönderilir ve arayüz tarafından yorumlanır.
|
| API'ın ``Response`` nesnesinde sayfaların yorumladığı datanın (``forms``, ``objects``, ``object``) dışında kullanıcı arayüzünü şekillendiren, işlev ekleyen bazı anahtarlar bulunmaktadır.
| Bunlar aşağıdaki örnekte sıralanmıştır;

.. code:: json

    {
        "client_cmd":["form"],
        "reload_cmd":"add_edit_form",
        "token":"zxcv4321",
        "meta":{
            "allow_search":true,
            "allow_selection":false
        },
        "_debug_queries":[
            {
                "TIMESTAMP":1453289218.893847,
                "BUCKET":"models_user",
                "KEY":"7890yuhjk",
                "TIME":0.00275
            }
        ],
        "is_login":true,
        "notify": "ornek bildirim text"
    }

client_cmd
^^^^^^^^^^

| ``client_cmd`` anahtarı arayüzün yapması istenen komutu taşır. Bu komutlar şunları kapsar; **list**, **form**, **show**, **reload**, **reset**.

- **form** gönderilen datanın `forms` nesnesi taşıdığı ve kullanıcı arayüzünün bunu form olarak yorumlaması gerektiği durumlarda kullanılır.
- **list** sayfada listelenmesi istenen bir data olduğunda kullanılır. Bu data *table* olarak listelenir.
- **show** komutu sayfada detay bilgileriyle gösterilmek istenen bır data olduğunda kullanılır.
- **reload** komutu sayfada gösterilen datada bir değişiklik olduğu ve datanın API'dan yeniden istenmesi gerektiği durumlarda kullanılır.
- **reset** komutu datanın ek parametreler olmadan yeniden çekilmesi için kullanılır.

| Bu komutlar oluşturulan workflow'ların ilgili adımlarında kullanılarak arayüzün istenen şekilde davranması için gereklidir.

    **form**, **list** ve **show** komutları birer liste öğesi olarak bir arada gönderilebilir.


reload_cmd
^^^^^^^^^^

| ``reload_cmd`` anahtarı ``"client_cmd": "reload"`` olması durumunda arayüzün backend API'dan isteyeceği komutu taşır.
| UI post datası içinde ``cmd`` anahtarında bu değeri gönderir.

token
^^^^^

| ``token`` anahtarında iş akış şemasının ( *workflow* ) redis'te tutulan token değeri vardır.
| İş akışı tamamlanmadığı sürece bu token `request` nesnesinde API'a gönderilir.

meta
^^^^

| ``meta`` anahtarında arayüzde istenen yapılandırmalar yer alır. Boolean değer taşırlar. Bunlar şunlardır;

- **allow_search** Listeleme ekranında arama kutusunun gösterilmesi için kullanılır.
- **allow_selection** Listeleme ekranında tablonun solunda selectBox yer alması için kullanılır.
- **allow_sort** Listeleme ekranındaki sıralama özelliği için kullanılır.
- **allow_filter** Listelenen datanın filtrelemesi için kullanılır.
- **allow_actions** ListNode tipinde listelenen data için en sağdaki işlemler kolonunun gösterilmesi için kullanılır.
- **translate_widget** Katalod verilerin düzenleneceği ekran için oluşturulan widget'dır. Aynı zamanda çeviri işlemleri için kullanılacaktır. Boolean tipinde değer alır.

_debug_queries
^^^^^^^^^^^^^^

| ``_debug_queries`` anahtarı geliştiriciler için yardımcı bir anahtardır.
| Veritabanına yapılan sorguların süresi ve kaç adet sorgu yapıldığı gibi değerler bu anahtarda yer alır.
| Aktif olması için API ortamında çevre değişkeni DEBUG=1 olarak set edilmelidir.

is_login
^^^^^^^^

| ``is_login`` anahtarı kullanıcının giriş yapıp yapmadığını gösteren bir anahtardır.
| Bu anahtar *false* değer taşıdığında arayüz login sayfasına yönlendirir.

notify
^^^^^^

| ``notify`` anahtarı ile gönderilen bildirimler pencerenin sağ üstünde yer alır ve bir süre sonra kaybolur.


Ulakbüs UI Sayfa Tipleri
------------------------

| Ulakbüs kullanıcı arayüzünde sunulan temel içerik türleri şunlardır;

-  Form sayfası - `Ekleme ve düzenleme işlemleri`
-  Liste sayfası - `Listeleme, arama, filtreleme ve silme işlemleri`
-  Detay sayfası - `Tek nesne detay ve rapor ekranları`

| Bu içerik türleri API'ın iş akışlarında sunduğu temel içerik türleridir.
| Bu içerik türlerinin kullanıcı arayüzünde doğru biçimde yorumlanması için ``response`` nesnesinde gönderilecek anahtar değerler belirlenmiştir.
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

    Bu sayfa tipleri ``response`` nesnesinde aynı anda yer alırlarsa
    yukarıdan aşağıya doğru detay > form > liste olacak şekilde aynı
    sayfada yorumlanırlar.

Her sayfaya ait alt özellikler ilgili başlık altında anlatılacaktır.

Form sayfası
~~~~~~~~~~~~

| Ulakbus UI form işlemlerini gerçekleştirmek için angular-schema-form_ extend edilmiştir.
| Kullanılan form nesneleri angular-schema-form'un beklediği formatta olmalı ya da değilse extend edilerek `custom type` yaratılmalıdır.

Örnek bir ``forms`` nesnesi aşağıdaki gibidir:

.. _angular-schema-form: https://github.com/Textalk/angular-schema-form

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

``forms`` anahtarı aşağıdaki öğelerden oluşmaktadır;

form
^^^^

Bu anahtar altında formda gösterilmesi istenen inputlar bir liste halinde yer alır.

schema
^^^^^^

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

    .. code:: json

        {
            "form": [ "ornekbutton" ],
            "schema": {
                properties: {
                    ornekbutton: {
                        type:   "button"
                        title:  (string) Field Başlığı,
                        style:  (string) Butonun alacağı class'lar,
                        cmd:    (string) Butonun cmd'si,
                        flow:   (string) Butonun flow'u
                        wf:     (string) Butonun yönlendirdiği workflow,
                        form_validate: (boolean) Buton basıldığında gecerlilik kontrolünün calışma durumu
                    }
                }
            }
        }

    - ``submit`` : butonla aynı yapıdadır. Tek farkı basıldığı anda submit işlemi gerçekleştirir. "type" özelligi "submit" olarak belirtilmelidir.
    - ``file``

    .. code:: json

        {
            "form": [ "ornekdosya" ],
            "schema": {
                properties: {
                    ornekdosya: {
                        title:  (string) Field Başlığı,
                        type: "file"
                    }
                }
            }
        }

    - ``select`` Kucuk capli secimler icin ideal field. TitleMap(secimler) statik olarak gonderilebilir.

    .. code:: json

        {
            "form": [ 'ornekselect'],
            "schema": {
                properties: {
                    "ornekselect":{
                        "type":"select",
                        "title":(string) Alan Basligi,
                        "titleMap":[
                            { "name":"Bay", "value":1 },
                            { "name":"Bayan", "value":2 }
                        ]
                    }
                }
            }
        }

    - ``confirm``: Onaylama mesaj kutusu acan buton görevi görür.

    .. code:: json

        {
            "form": [ "ornekconfirm" ],
            "schema": {
                properties: {
                    ornekconfirm: {
                        title: (string) Buton ve Pencere kutusu Basligi,
                        style:"btn-success",
                        type:'confirm',
                        confirm_message: (string) Onaylama Mesaji,
                        buttons: [
                            {   text: (string) Buton basligi , cmd:(string) Buton cmd'si, style: "btn-warning"}
                        ],
                        readonly:"true",
                        form_validate: (boolean) Buton basıldığında gecerlilik kontrolünün calışma durumu
                    }
                }
            }
        }



    - ``date``

    .. code:: json

        {
            "form": [ "ornekdate" ],
            "schema": {
                properties: {
                    ornekdate: {
                        title:  (string) Field Başlığı,
                        type: "date"
                    }
                }
            }
        }


    - ``int``

    .. code:: json

        {
            "form": [ "ornekint" ],
            "schema": {
                properties: {
                    ornekint: {
                        title:  (string) Field Başlığı,
                        type: "int"
                    }
                }
            }
        }


    - ``boolean``

    .. code:: json

        {
            "form": [ "ornekbool" ],
            "schema": {
                properties: {
                    ornekbool: {
                        title: (string) Field Başlığı,
                        type: "boolean"
                    }
                }
            }
        }


    - ``string``

    .. code:: json

        {
            "form": [ "ornekstring" ],
            "schema": {
                properties: {
                    ornekbool: {
                        title:  (string) Field Başlığı,
                        type: "boolean"
                    }
                }
            }
        }

    - ``typeahead`` select'in daha fazla veri tasiyan cinsidir. Yazilani filtreleyek, sunucu tarafindaki verilerle TitleMap(secimler)'i olusturur.

    .. code:: json

        {
            "form": [ "ornektypeahead" ],
            "schema": {
                properties: {
                    ornektypeahead: {
                        title:  (string) Field Başlığı,
                        titleMap : [
                        {name: (string) Secimin Adi, value: (int) Secimin degeri }
                        ]
                        type: "typeahead"
                    }
                }
            }
        }

    - ``text_general`` paragraf yazimi icin kullanilir.

    .. code:: json

        {
            "form": [ "ornektext_general" ],
            "schema": {
                properties: {
                    ornektext_general: {
                        title:  (string) Field Başlığı,
                        type: "text_general"
                    }
                }
            }
        }

    - ``float``: int ile aynı yapıdadır. "type" özelligi "float" olarak belirtilmelidir.


    - ``model``: gelismis select field'laridir. Genelde degisken listeli secimler icin kullanilir. Listeleme ve ekleme sirasinda kendisine verilen cmd'leri kullanir.

    .. code:: json

        {
            "form": [ "ornekmodel" ],
            "schema": {
                properties: {
                    ornekmodel: {
                        model_name: (string) Model ismi,
                        title:  (string) Field Başlığı,
                        type: "model"
                        wf: (string) Modelin sahip oldugu workflow,
                        list_cmd: (string) Listeleme aninda calisan cmd,
                        add_cmd: (string) Ekleme aninda calisan cmd
                    }
                }
            }
        }

    - ``ListNode``: model'in Array seklinde calisan versiyonudur. Birden fazla model elemani secmeye yarar.

    .. code:: json

        {
            "form": [ "ornekListNode" ],
            "schema": {
                properties: {
                    ornekListNode: {
                        schema: Bu sema, ekleme butonuna tiklandiginda acilacak pencerenin icindeki form elemanlarinin semasidir. Asagida bir tane model objesiyle orneklendirilmistir.
                        [{
                            model_name: (string) Modelin "+" tusuna basildiginda gosterilen model,
                            name:(string) Modelin ismi,
                            title: (string) Formun basligi,
                            type: "model"
                        }],
                        title: (string) ListNode Basligi,
                        type: "ListNode",
                    }
                }
            }
        }

model
^^^^^

| Bu anahtarda form alanlarının değerleri tutulmaktadır.
| Düzenlenecek form için bu anahtardaki değerler dolu olarak döner ve inputlara atanır.
| Boş değer dönmesi o anahtar için daha önceden bir kayıt yapılmadığını gösterir.


grouping
^^^^^^^^

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

constraints
^^^^^^^^^^^

Form inputlarının birbirlerine göre bağımlılıklarının denetlendiği ve düzenlendiği anahtardır. Geliştirme aşamasındadır.

Liste sayfası
~~~~~~~~~~~~~

Liste sayfasında kaydedilen öğeler listelenir.

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

Detay sayfası
~~~~~~~~~~~~~

Detay sayfasında gösterilmek istenen nesne anahtar değer olarak sıralanır.
Örnekte bir kişi kaydının anahtar değerleri görülmektedir.

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

Geliştirmeye Başlamak
~~~~~~~~~~~~~~~~~~~~~

| Yukarıda anlatılan API-UI veri karşılıkları gözönünde bulundurularak geliştirme yapmaya başlayabilirsiniz.
| Geliştirme konusunda rehber olarak kullanılmak üzere TDD geliştirme dokümanını hazırlamaktayız.