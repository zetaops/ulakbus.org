+++++++++++++++++++++++
UniTime Entegrasyonları
+++++++++++++++++++++++

UniTime Nedir?
++++++++++++++

UniTime, bir araştırma sahası olan "akademik takvimleme problemleri"ni çözmek üzere geliştirilen,
açık kaynaklı bir yazılım projesidir. Ulakbüs projesi kapsamında, bu alanda geliştirilmiş diğer
projeler incelendiğinde, UniTime'ın daha kararlı bir proje olduğu ortaya çıkmıştır.

Aşağıdaki listede, incelenen diğer projeler ve algoritmalar listelenmektedir:

   - `FET (Free Timetabling Software) <http://lalescu.ro/liviu/fet/>`_
   - `OptaPlanner <http://http://www.optaplanner.org>`_
   - `Making a Class Schedule Using a Genetic Algorithm <http://www.codeproject.com/Articles/23111/Making-a-Class-Schedule-Using-a-Genetic-Algorithm>`_
   - `Greedy Algorithms <https://en.wikibooks.org/wiki/Algorithms/Greedy_Algorithms>`_

UniTime hakkında daha detaylı bilgiye aşağıdaki link üzerinden erişebilirsiniz:

http://www.unitime.org


Kavram Şeması
+++++++++++++

UniTime ve Ulakbüs yazılımı arasında veri akışını sağlayacak olan entegrasyonları yaparken, iki ayrı
projenin farklı terminolojilerinden kaynaklanan bir harita dosyası ihtiyacı duyulmuştur.

Aşağıdaki tabloda Ulakbus modellerinin UniTime projesindeki kavramlara karşılıkları listelenmiştir:

+--------------------------+-----------------------------+
| Ulakbüs                  | UniTime                     |
+==========================+=============================+
| Building                 | Building                    |
+--------------------------+-----------------------------+
| Campus                   | Campus                      |
+--------------------------+-----------------------------+
| Ders                     | Course                      |
+--------------------------+-----------------------------+
| Donem                    | Academic Session            |
+--------------------------+-----------------------------+
| Okutman                  | Instructors                 |
+--------------------------+-----------------------------+
| Ogrenci                  | Student                     |
+--------------------------+-----------------------------+
| Personel                 | Staff                       |
+--------------------------+-----------------------------+
| Program                  | Subject Area                |
+--------------------------+-----------------------------+
| Room                     | Room                        |
+--------------------------+-----------------------------+
| RoomType                 | Room Type                   |
+--------------------------+-----------------------------+
| Sinav                    | Exam                        |
+--------------------------+-----------------------------+
| Unit (unit_type="Bölüm") | Department                  |
+--------------------------+-----------------------------+
| ?                        | Classes                     |
+--------------------------+-----------------------------+
| ?                        | Academic Classifications    |
+--------------------------+-----------------------------+
| ?                        | Academic Areas              |
+--------------------------+-----------------------------+
| ?                        | Majors                      |
+--------------------------+-----------------------------+
| ?                        | Minors                      |
+--------------------------+-----------------------------+
| ?                        | Student Accommodations      |
+--------------------------+-----------------------------+
| ?                        | Curriculum Projection Rules |
+--------------------------+-----------------------------+
| ?                        | Last-like Enrollments       |
+--------------------------+-----------------------------+

Entegrasyon Yöntemi
+++++++++++++++++++

UniTime ve Ulakbüs yazılımı arasında veri akışını sağlayacak olan entegrasyonları yaparken, UniTime
projesinin veri giriş/çıkış (data export import) imkan sağlayan XML arabirimi (Data Exchanger)
kullanılmıştır. UniTime projesi ile birlikte sunulan örnek Data Exchanger XML dosyalarına aşağıdaki
adresten ulaşmanız mümkündür:

https://github.com/UniTime/unitime/tree/master/Documentation/Interfaces/Examples

Entegrasyon kapsamında,

   - Akademik Dönem, Kampüs, Bina, Oda
   - Okutman, Öğrenci, Personel
   - Bölüm, Program, Ders, Öğrenci

Modellerine ait verilerin Ulakbüs üzerinden UniTime'a aktarılması hedeflenmektedir.

Verilerin aktarılmasının ardından hedeflenen işlevsellikler aşağıdaki kapsamdadır:

1. **Güncel** akademik dönem boyunca verilecek olan ders programlarının takvimlendirilmesi
   (ders programlarının varolan dersliklere ve tarih - saatlere dağılımının hesaplanması).
2. **Güncel** akademik dönem boyunca yapılacak olan sınavların takvimlendirilmesi (sınavların
   varolan dersliklere ve tarih - saatlere dağılımının hesaplanması).
3. **Unitime** üzerinde hesaplaması biten akademik ders takviminin Ulakbüs üzerinde bulunan
   **DersProgrami** modeline kayıt edilmesi.
4. **Unitime** üzerinde hesaplaması biten sınav takvimlerinin Ulakbüs üzerinde bulunan
   **Sınav** modeline kayıt edilmesi.

    Önemli Not: Entegrasyon sırasında dışarıya aktarılan verinin, Ulakbüs üzerinde **güncel** olarak
    görünen akademik döneme ait olması hedeflenmiştir. Geçmiş dönemlere ait veriler dışarıya
    **aktarılamaz**.

    Geçmiş dönemlere ait verilerin dışarıya aktarıma kısıtlanmasının nedeni; bu dönemlere ait
    işlemlerin **Ulakbüs** tarafında yeni döneme (güncel akademik döneme) aktarılarak işlenmesidir.


Örnek Entegrasyon
+++++++++++++++++

Bu örnekte UniTime üzerinde **Department** olarak adlandırılan ve Ulakbüs üzerinde **Bölüm**'e denk
düşen kayıtların aktarılması için gerekli XML dosyasının yaratılacağı bir fonksiyon
örneklendirilmiştir. Örnek XML şemasına aşağıdaki adreten ulaşılabilir:

https://github.com/UniTime/unitime/blob/master/Documentation%2FInterfaces%2FExamples%2FdepartmentImport.xml

::

    class DepartmanAktar(Command):
        CMD_NAME = 'departman_aktar'
        HELP = 'Akademik bölüm listesi için UniTime XML import dosyası oluşturur.'
        PARAMS = []

        def run(self):
            import os
            import datetime
            from lxml import etree
            from ulakbus.models import Donem, Unit, Campus
            root_directory = os.path.dirname(os.path.abspath(__file__))

            # Güncel akademik dönemi seç
            term = Donem.objects.filter(guncel=True)[0]

            # Unit modeli üzerinden üniversite seç
            uni = Unit.objects.filter(parent_unit_no=0)[0].yoksis_no

            # Unit modeli üzerinden bölümleri seç
            units = Unit.objects.filter(unit_type='Bölüm')

            # Campus modeli üzerinden kampüs listesini al
            campuses = Campus.objects.filter()

            doc_type = '<!DOCTYPE departments PUBLIC "-//UniTime//DTD University Course Timetabling/EN" "http://www.unitime.org/interface/Department.dtd">'

            # XML ağacını oluştur (create XML tree)
            for campus in campuses:
                if campus:
                    root = etree.Element('departments', campus="%s" % uni, term="%s" % term.ad,
                                         year="%s" % term.baslangic_tarihi.year)
                for unit in units:
                    etree.SubElement(root, 'department', externalId="%s" % unit.key,
                                     abbreviation="%s" % unit.yoksis_no, name="%s" % unit.name,
                                     deptCode="%s" % unit.yoksis_no, allowEvents="true")

            # Stringi düzgünleştir (string prettify)
            s = etree.tostring(root, pretty_print=True, xml_declaration=True, encoding='UTF-8',
                               doctype="%s" % doc_type)

            # Güncel tarih-saat tabanlı export klasörü yarat
            current_date = datetime.datetime.now()
            directory_name = current_date.strftime('%d_%m_%Y_%H_%M_%S')
            export_directory = root_directory + '/bin/dphs/data_exchange/' + directory_name
            if not os.path.exists(export_directory):
                os.makedirs(export_directory)

            # Stringi dosyaya yazdır
            out_file = open(export_directory + '/departmentImport.xml', 'w+')
            out_file.write("%s" % s)
            print("Dosya %s dizini altina kayit edilmistir" % export_directory)
            
 
 Oluşturulan XML dosyası, UniTime üzerinde **Administration** -> **Academic Sessions** -> **Data Exchange** menüsü ile ulaşabileceğiniz form aracığılığı ile sisteme import edilebilir.