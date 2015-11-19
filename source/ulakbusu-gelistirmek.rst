.. highlight:: python
   :linenothreshold: 3

++++++++++++++++++++++++++++++++++++++++++++++++
Ulakbüs'ü Geliştirelim
++++++++++++++++++++++++++++++++++++++++++++++++

Aşağıdaki adımları izleyerek Ulakbüs projesine öğrencilerin ders seçmesini sağlayan bir işlev eklemiş olacağız.

* Öğrenci seçebileceği derslerin listesini görüntüler.
* Almak istediği dersleri seçer ve "kaydet" düğmesine basar.
* Seçtiği derslerin listesini tekrar gözden geçirir ve "onay" düğmesine basar.
* Dersleri onaylaması için öğrencinin danışmanına bir ileti gönderilir.
* Danışman iletideki bağlantıya tıklayarak iş akışına katılır ve öğrencinin seçtiği dersleri görüntüler.
* Onayla düğmesine basması durumunda, ders listesi onaylanmış olarak kaydedilir ve öğrenciye ders seçiminin danışmanı tarafından onaylandığı mesajı gider. İş akışı tamamlanmış olur.
* Danışmanın bir dersi listeden çıkarması durumunda öğrenciye ileti gönderilerek tekrar ders seçmesi istenir.
* Öğrenci ders listesini günceller ve tekrar onaylar.
* Danışmana tekrar inceler, onaylama durumuna bağlı olarak akış sonlanır ya da başa döner.


Geliştirme ortamının kurulumu
***********************************************************************************

Geliştirmeye başlamak için öncelikle **Camunda Modeller**, **git** ve **Vagrant** araçlarına ihtiyacımız olacak.
Camunda Modeller ile iş akışı diagramlarımızı hazırlayacağız. (link eklenecek)
Ulakbüs projesinin parçası olarak, geliştiriciler için hazırlanan vagrant sanal makinası ile gerekli ortam hazır olarak gelmektedir. (belgeye link verilecek)


View, Task ve Model dosyalarının konumları
***********************************************************************************

View, task ve model modülleri, proje kök dizininde yer alan ``views``, ``tasks`` ve ``models``  dizinleri altında konumlanırlar.

.. uml::

    @startsalt

    {
    {T
    +manage.py
    +settings.py
    +**models**
    ++~__init__.py
    ++ogrenci.py
    ++personel.py
    ++auth.py
    ++hitap.py
    +**views**
    ++~__init__.py
    ++personel
    +++~__init__.py
    +++atama.py
    +++kadro.py
    ++auth.py
    ++dashboard.py
    ++system.py
    +**tasks**
    ++~__init__.py
    }
    }

    @endsalt




İş akışlarının tasarlanması.
***********************************************************************************

Ulakbüs projesinin üzerine inşa edildiği ZEngine frameworkü BPMN 2.0 standardıyla tanımlanmış olan iş akışı ögelerinin uygulama işlevselliği için elzem olan kısımlarını desteklemektedir. Bunlardan UserTask, ServiceTask ve Exclusive (XOR) Gateway'ler en çok kullanacağımız ögelerin başında gelmektedir.

BPMN standardı bu öglerin temel işlev ve ilişkilerini tanımlamış olsa da, iş akışlarının işletilmesi noktasında birçok tercihi uygulama geliştiricilere bırakmıştır.

Yukarıda maddelendirdiğimiz iş akışının BPMN 2.0 uyumlu bir diagram şekline getirilmiş halini aşağıda görebilirsiniz.


.. image:: _static/du_bpmn_lecture_selection.png



Advisor lane'inin boş bir yerine tıklayarak bu lane'in özelliklerini görüntüleyebilirsiniz. Extensions bölümüne girebileceğiniz parametereler ve işlevleri aşağıda listelenmiştir.


.. image:: _static/du_bpmn_lane_properties.png


``relations`` parametresi iş akışında rol alan kullanıcıların birbirleri ile olan ilişkilerini kısıtlayıcı şekilde tanımlamak için kullanılır. Yukarıdaki örnekte **advisor** laneninin kullanıcısının student lane'inin kullanıcısının **danisman** ı olması gerektiği belirtilmiştir. Bu alana girilen parametrelerin geçerli Python kodu olması ve True mantıksal değerini döndürmesi gerekmektedir. Tanımlanması isteğe bağlıdır.

``owners`` parametresi tanımlandığı lane'in olası kullanıcılarını ifade etmek için kullanılır. İş akışı bir lane'den diğerine geçtiğinde, iş akışı motoru bu tanımlamanın işaret ettiği kullanıcılara bir ileti göndererek akışa katılmalarını sağlar.

Örneğimizde advisor lane'ini işletecek kişinin student lane'ini işleten kişinin danışmanı olması gerektiği kesin olarak belirtilmiştir. Bununla birlikte, bu alana birden fazla nesne döndürebilecek geçerli bir Python ifadesi girilmesi gerektiğinden, **[student.ogrenci.danisman.personel]** şeklinde tek ögeli bir liste şeklinde girilmiştir. Bu listenin elemanları ya **User** nesnesi olmalı ya da geriye ilgili user nesnesini döndüren bir **get_user()** metoduna sahip olmalıdırlar.



``permissions`` parametresi virgülle ayrılmış şekilde yetki kodları kabul etmektedir. İlgili lane'i işletecek kullanıcının bu yetkilere sahip olması koşulu aranacaktır. Sistemde halihazırda tanımlı olmayan yetkiler burada doğrudan kullanılıp update_permissions komutu ile otomatik olarak yetki tablosuna eklenebilir. ``:: TODO ::``






Modellerin tanımlanması.
***********************************************************************************

Yukarıda gösterdiğimiz "Öğrenci Ders Seçme" akışı için önceki bölümde ele aldığımız Student, Lecture ve Lecturer modellerini "lectures.py" gibi geçerli bir isimle models dizinine kaydedip, ``models/__init__.py`` içine import etmemiz yeterli olacaktır.

.. literalinclude:: ../../ulakbus/ulakbus/models/lectures.py
    :linenos:
    :lines: 1, 6-


.. literalinclude:: ../../ulakbus/ulakbus/models/__init__.py
    :linenos:
    :lines: 1, 6-


Basit bir view fonksiyonu hazırlayalım
***********************************************************************************



Ekleme, görüntüleme, düzenleme ve silme işlemleri için CrudView kullanımı.
***********************************************************************************

sdsd

CrudView'ı genişletmek
***********************************************************************************

.. literalinclude:: ../../ulakbus/ulakbus/views/lectures/select.py
    :linenos:
    :lines: 1, 6-


.. literalinclude:: ../../ulakbus/ulakbus/views/lectures/student_review.py
    :linenos:
    :lines: 1, 6-


.. literalinclude:: ../../ulakbus/ulakbus/views/lectures/advisor_review.py
    :linenos:
    :lines: 1, 6-
