.. Ulakbus Documents documentation master file, created by
   sphinx-quickstart on Tue Jul 28 14:30:19 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.


Geliştirmeye Yeni Başlayanlar
=============================
Yeni geliştiriciler, ilk olarak `Geliştirme Ortamının Kurulumu
<http://www.ulakbus.org/wiki/development_environment_setup.html>`_ belgesiyle
başlayabilirler. Bu belgede geliştirme ortamının Vagrant üzerinde kurulması
detaylı şekilde anlatılmaktadır.

Geliştirmeye başlamadan önce geliştiriciler için hazırladığımız `Yazılım Tasarım
Analizi Belgesi <http://www.ulakbus.org/wiki/yazilim_tasarim_analizi_belgesi.html>`_
belgesi, sistemin genel görünüşü ve tek tek bileşenleri hakkında detaylı bilgiler
içermektedir ve geliştirme sürecinin daha hızlı anlaşılmasına yardımcı olacaktır.

ULAKBUS, iş akışı temelli bir web çatısı olan ZEngine üzerine kuruludur. Bu sebeple
`ZEngine ile İş Akışı Temelli Uygulama Geliştirme
<http://www.ulakbus.org/wiki/zengine-ile-is-akisi-temelli-uygulama-gelistirme.html>`_
başlıklı belge, iş akışı kavramları ile tanışmak ve web çatısının genel özellikleri
hakkında temel bilgiler için oldukça faydalı olacaktır.

`Ulakbüs’ü Geliştirelim <http://www.ulakbus.org/wiki/ulakbusu-gelistirmek.html>`_
belgesi ise örnek bir uygulama içermektedir. Web çatısınının üzerine ULAKBUS
kodunun nasıl yerleştiği, iş akışı diyagramının nasıl çizildiği, modellerin nasıl
tanımlandığı, iş akışı adımlarına karşılık gelen view / task veya servislerin
nasıl yazıldığı hakkında açıklamalar ve örnek kodlar içermektedir.

Geliştirme yaparken ilgileneceğimiz diğer önemli bir konu ise arka ve önuç
ilişkisinin kavranmasıdır. Bu ilişkiyi ve önucun nasıl çalıştığını tüm detayları
ile `ULAKBUS UI–API İlişkisi <http://www.ulakbus.org/wiki/ulakbus-api-ui-iliskisi.html>`_
belgesinde bulabilirsiniz.

Diğer yardımcı belgeler:

* `Komut Satırı Yönetim Aracı <http://www.ulakbus.org/wiki/komut_satiri_yonetim_araci.html>`_
   Komut satırı yönetim aracı, ULAKBÜS uygulamasının hem yönetimi hem de geliştirilmesi için
   basit ve etkili bir arayüzdür. Komut satırından veritabanı yönetimi, model şema göçü,
   fake data üretimi, veri aktarımı ve daha birçok işlem kolaylıkla yapılabilmektedir.

* `Zato <http://www.ulakbus.org/wiki/zato_doc.html>`_
   Zato, ULAKBUS projesinin temel bileşenlerinden birisidir. Bu belge hem Zato hakkında hem
   de genel olarak ESB (Kurumsal Veriyolu) / SOA (Servis Temelli Uygulama) kavramları
   hakkında bilgi içerir.

* `Zato İpuçları <http://www.ulakbus.org/wiki/zato_ipuclari.html>`_
   Zato'nun yönetimi ile ilgili ipuçları içerir.

* `Veri Erişim Seçenekleri <http://www.ulakbus.org/wiki/veri_erisim_secenekleri.html>`_
   Veritabanı seçimin ne şekilde yaptığımızı ve alınan kararları içerir.
  
Bu belgelere ek olarak, geliştirme faaliyetinizi toplulukla paylaşmak ve ULAKBUS depolarına
göndermek isterseniz GitHub ve Git iş akışımızı detaylı şekilde tarif ettiğimiz `Ulakbus
Depolarına Katkı Yapmak <http://www.ulakbus.org/wiki/git_workflow.html>`_ belgemize göz
atabilirsiniz.

Eğer bir sorunla karşılaşırsanız, `destek sayfamızda <http://www.ulakbus.org/destek.html>`_ yer alan
kanallardan destek alabilirsiniz. Destek için iletişim kurmadan önce lütfen sorununuzun ne olduğunu
**açık ve sarih olarak** bildirmeniz gerektiğini unutmayınız. "- Bu çalışmıyor" şeklindeki
sorularınıza alabileceğiniz en iyi cevap **sessizlik** olacaktır.

Nasıl soru sorulacağını `akıllıca soru sorma yolları belgesinden
<http://belgeler.org/howto/smart-questions.html>`_ öğrenebilirsiniz.

Aşağıda API belgelerini geliştirme için gereken tüm belgeleri bulabilirsiniz.


API Belgeleri
=============

.. toctree::
   :maxdepth: 2

   Ulakbus <http://www.ulakbus.org/ulakbus/ulakbus.html>
   Zengine <http://zengine.readthedocs.org/en/latest/>
   Pyoko <http://pyoko.readthedocs.org/en/latest/>

Ulakbus Wiki
============

.. toctree::
   :maxdepth: 2

   developers
   devops
   users




Kolay gelsin \o/
