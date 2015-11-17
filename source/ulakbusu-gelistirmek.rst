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
    * Danışman iletideki bağlantıya tıklayarak iş akışına katılır.
    * Danışman seçili dersleri görür;
        * Onayla düğmesine basması durumunda, ders listesi onaylanmış olarak kaydedilir.
        * Bir dersi listeden çıkarması durumunda öğrenciye ileti gönderilerek tekrar ders seçmesi istenir.
    * Öğrenci ders listesini günceller ve tekrar onaylar.


Geliştirme ortamının kurulumu
***********************************************************************************

Geliştirmeye başlamak için **git** ve **vagrant** araçlarına ihtiyacımız olacak.
Ulakbüs projesinin parçası olarak, geliştiriciler için hazırlanan vagrant box ile gerekli ortam hazır olarak gelmektedir. (link eklenecek)


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

Örnek uygulamamızda


Modellerin tanımlanması.
***********************************************************************************

Yukarıda gösterdiğimiz "Öğrenci Ders Seçme" akışı için önceki bölümde ele aldığımız Student, Lecture ve Lecturer modellerini "dersler.py" gibi geçerli bir isimle models dizinine kaydedip, ``models/__init__.py`` içine import etmemiz yeterli olacaktır.

::

    # ulakbus/models/lectures.py

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


::

    # ulakbus/models/__init__.py

    from .personel import *
    from .auth import *
    from .ogrenci import *
    from .hitap import *
    from .lectures import *


Basit bir view fonksiyonu hazırlayalım
***********************************************************************************



Ekleme, görüntüleme, düzenleme ve silme işlemleri için CrudView kullanımı.
***********************************************************************************

sdsd

CrudView'ı genişletmek
***********************************************************************************

