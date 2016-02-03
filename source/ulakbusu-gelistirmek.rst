.. highlight:: python
   :linenothreshold: 3

++++++++++++++++++++++++++++++++++++++++++++++++
Ulakbüs'ü Geliştirelim
++++++++++++++++++++++++++++++++++++++++++++++++

Aşağıdaki adımları izleyerek Ulakbüs projesine öğrencilerin ön kayıt yaptırmasını ve sonrasında
öğrenci işleri personelinin gerekli belgeleri kontrol edip kayıt işlemini tamamlamasını içeren
bir iş akışı için gerekli işlevleri ekleyeceğiz.

* Doğrulaması için öğrenciye "Önceki Eğitim Bilgileri" gösterilir.
* Doğrulaması için Puan Türü ve Puanı gösterilir.
* Öğrencinin kişisel bilgilerini girebileceği bir form gösterilir.
* Öğrenciye ön kayıt işleminin başarıyla tamamlandığını gösteren bilgi mesajı gösterilir.
* Öğrenci işleri personeli tarafından öğrencinin getirdiği belgelerin kontrol edilerek teslim
alındığı bilgisinin sisteme girileceği "Belge Kabul" ekranı gösterilir.
* Tüm belgeler tamamlanınca personelin "Onayla" düğmesine basmasıyla iş akışı tamamlanmış olur.

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
    ++**ogrenci**
    +++~__init__.py
    +++on_kayit.py
    ++dashboard.py
    ++system.py
    +**tasks**
    ++~__init__.py
    }
    }

    @endsalt




İş akışlarının tasarlanması.
***********************************************************************************

Ulakbüs projesinin üzerine inşa edildiği ZEngine frameworkü BPMN 2.0 standardıyla tanımlanmış olan
iş akışı ögelerinin uygulama işlevselliği için elzem olan kısımlarını desteklemektedir.
Bunlardan UserTask, ServiceTask ve Exclusive (XOR) Gateway'ler en çok kullanacağımız ögelerin başında gelmektedir.

BPMN standardı bu öglerin temel işlev ve ilişkilerini tanımlamış olsa da, iş akışlarının işletilmesi noktasında birçok tercihi uygulama geliştiricilere bırakmıştır.

Yukarıda maddelendirdiğimiz iş akışının BPMN 2.0 uyumlu bir diagram şekline getirilmiş halini aşağıda görebilirsiniz.


.. thumbnail:: _static/du_bpmn_onkayit.png



Öğrenci (ogrenci) lane'inin boş bir yerine tıklayarak bu lane'in özelliklerini görüntüleyebilirsiniz.
Extensions bölümüne girebileceğiniz parametereler ve işlevleri aşağıda listelenmiştir.


.. thumbnail:: _static/du_bpmn_lane_properties.png


``relations`` parametresi iş akışında rol alan kullanıcıların birbirleri ile olan ilişkilerini kısıtlayıcı şekilde tanımlamak için kullanılır. Yukarıdaki örnekte **advisor** laneninin kullanıcısının student lane'inin kullanıcısının **danisman** ı olması gerektiği belirtilmiştir. Bu alana girilen parametrelerin geçerli Python kodu olması ve True mantıksal değerini döndürmesi gerekmektedir. Tanımlanması isteğe bağlıdır.

``owners`` parametresi tanımlandığı lane'in olası kullanıcılarını ifade etmek için kullanılır. İş akışı bir lane'den diğerine geçtiğinde, iş akışı motoru bu tanımlamanın işaret ettiği kullanıcılara bir ileti göndererek akışa katılmalarını sağlar.

Örneğimizde advisor lane'ini işletecek kişinin student lane'ini işleten kişinin danışmanı olması gerektiği kesin olarak belirtilmiştir. Bununla birlikte, bu alana birden fazla nesne döndürebilecek geçerli bir Python ifadesi girilmesi gerektiğinden, **[student.ogrenci.danisman.personel]** şeklinde tek ögeli bir liste şeklinde girilmiştir. Bu listenin elemanları ya **User** nesnesi olmalı ya da geriye ilgili user nesnesini döndüren bir **get_user()** metoduna sahip olmalıdırlar.



``permissions`` parametresi virgülle ayrılmış şekilde yetki kodları kabul etmektedir. İlgili lane'i işletecek kullanıcının bu yetkilere sahip olması koşulu aranacaktır. Sistemde halihazırda tanımlı olmayan yetkiler burada doğrudan kullanılıp update_permissions komutu ile otomatik olarak yetki tablosuna eklenebilir. ``:: TODO ::``






Modellerin tanımlanması.
***********************************************************************************

Yukarıda gösterdiğimiz "Önkayıy / Kayıt " akışı için  "ogrenci_kayit.py" gibi geçerli bir isimle models dizinine kaydedip,
``models/__init__.py`` içine import etmemiz yeterli olacaktır.



::

    from pyoko import Model, ListNode, field
    from ogrenci import Ogrenci
    from personel import Personel

    class OgrenciProgram(Model):
        ogrenci_no = field.String("Öğrenci Numarası", index=True)
        giris_tarihi = field.Date("Giriş Tarihi", index=True, format="%d.%m.%Y")
        mezuniyet_tarihi = field.Date("Mezuniyet Tarihi", index=True, format="%d.%m.%Y")
        giris_puan_turu = field.Integer("Puan Türü", index=True, choices="giris_puan_turleri")
        giris_puani = field.Float("Giriş Puani", index=True)
        aktif_donem = field.String("Dönem", index=True)
        durum = field.Integer("Durum", index=True, choices="ogrenci_program_durumlar")
        basari_durumu = field.String("Başarı Durumu", index=True)
        ders_programi = DersProgrami()
        danisman = Personel()
        program = Program()
        ogrenci = Ogrenci()


        class Meta:
            app = 'Ogrenci'
            verbose_name = "Öğrenci Programı"
            verbose_name_plural = "Öğrenci Programları"

        class Belgeler(ListNode):
            tip = field.Integer("Belge Tipi", choices="belge_tip", index=True)
            aciklama = field.String("Ek Açıklama", index=True, default="-", required=False)
            tamam = field.Boolean("Belge kontrol edildi", index=True, required=True)

        def __unicode__(self):
            return '%s %s - %s / %s' % (self.ogrenci.ad, self.ogrenci.soyad,
                                        self.program.adi, self.program.yil)


Puan Türü ve Puan Bilgileri Ekranı
***********************************

::

    class YerlestirmeBilgisiForm(forms.JsonForm):
        class Meta:
            include = ["giris_puan_turu", "giris_puani"]

        ileri_buton = fields.Button("İleri", cmd="save")

    class YerlestirmeBilgisi(CrudView):
        class Meta:
            model = "OgrenciProgram"

        def yerlestirme_bilgisi_form(self):
            ogrenci = Ogrenci.objects.get(user = self.current.user)
            ogrenci_program = OgrenciProgram.objects.get(ogrenci = ogrenci, durum = 1)
            self.form_out(YerlestirmeBilgisiForm(ogrenci_program, current = self.current))


Önceki Eğitim Bilgileri Ekranı
********************************

::

    class OncekiEgitimBilgileriForm(forms.JsonForm):
        class Meta:
            include = ["okul_adi", "diploma_notu", "mezuniyet_yili"]

        kaydet = fields.Button("Kaydet", cmd="save")


    class OncekiEgitimBilgileri(CrudView):
        class Meta:
            model = "OncekiEgitimBilgisi"

        def onceki_egitim_bilgileri(self):
            ogrenci = Ogrenci.objects.get(user = self.current.user)
            onceki_egitim_bilgisi = OncekiEgitimBilgisi.objects.filter(ogrenci = ogrenci)
            self.form_out(OncekiEgitimBilgileriForm(onceki_egitim_bilgisi[0], current=self.current))

        def kaydet(self):
            ogrenci = Ogrenci.objects.get(user = self.current.user)
            self.set_form_data_to_object()
            self.object.ogrenci = ogrenci
            self.object.save()



Öğrenci Önkayıt Ekranı
***********************************************************************************

::

    class OnKayitForm(forms.JsonForm):
        class Meta:
            include = ['kan_grubu', 'baba_aylik_kazanc', 'baba_ogrenim_durumu', 'baba_meslek',
                       'anne_ogrenim_durumu', 'anne_meslek', 'anne_aylik_kazanc', 'masraf_sponsor',
                       'emeklilik_durumu', 'kiz_kardes_sayisi', 'erkek_kardes_sayisi',
                       'ogrenim_goren_kardes_sayisi', 'burs_kredi_no', 'aile_tel', 'aile_gsm',
                       'aile_adres', 'ozur_durumu', 'ozur_oran']

        kaydet_buton = fields.Button("Kaydet", cmd="kaydet")

    class OnKayit(CrudView):
        class Meta:
            model = "Ogrenci"

        def on_kayit_form(self):
            ogrenci = Ogrenci.objects.get(user = self.current.user)
            self.form_out(OnKayitForm(ogrenci, current = self.current))


Belge Kayıt Ekranı
***********************************************************************************

::

    class BelgeForm(forms.JsonForm):
        class Meta:
            include = ["Belgeler"]

        kaydet = fields.Button("Kaydet", cmd="save")
        onayla = fields.Button("Ön Kayıt Onayla", cmd="onayla")

    class KayitBelgeler(CrudView):
        class Meta:
            model = "OgrenciProgram"

        def belge_form(self):
            ogrenci = Ogrenci.objects.get(user=self.current.user)
            ogrenci_program = OgrenciProgram.objects.get(ogrenci = ogrenci)
            self.form_out(BelgeForm(ogrenci_program, current = self.current))

        def onayla(self):
            ogrenci = Ogrenci.objects.get(user = self.current.user)
            ogrenci_program = OgrenciProgram.objects.get(ogrenci = ogrenci, durum = 1)
            ogrenci_program.durum = 2
            ogrenci_program.save()
