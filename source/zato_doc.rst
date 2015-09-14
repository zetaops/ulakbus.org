======================================
**ESB ve SOA ne anlama geliyor yani?**
======================================

::

  Sistemlerin sistemini düşünmek hakkında harika bir özet olmuş.

  Nick Coghlan, Core Python Geliştiricisi

Aşağıdaki dillerde okuyabilirsiniz. `Català <https://zato.io/docs/intro/esb-soa-ca.html>`_, `Deutsch <https://zato.io/docs/intro/esb-soa-de.html>`_, `Français <https://zato.io/docs/intro/esb-soa-fr.html>`_, `Português <https://zato.io/docs/intro/esb-soa-pt.html>`_, `ру́сский <https://zato.io/docs/intro/esb-soa-ru.html>`_ `İngilizce <https://zato.io/docs/intro/esb-soa.html>`_ ve `中文 <https://zato.io/docs/intro/esb-soa-cn.html>`_.

ESB tanımının SOA ile bağlantılı oluşu kafa karışıklığına neden oluyor. ESB Kurumsal Veri Yolu (KVY) şeklinde ifade edilebilir. SOA kavramı ise Servis Odaklı Mimari şeklinde kullanılabilir.

Ama bu kavramlar da, sürü sepet kurumsal gevezelik olmadan, sade bir Türkçe ile bile yeterince açık olmuyor maalesef.

Tüm gerçek
----------

Bankanızın uygulamasına girdiğinizde neler olduğunu bir düşünün:

1. Adınız görüntülenir
2. Hesabınızdaki para oradadır
3. Kredi kartlarınız ve kart borcu görüntülenir
4. Varsa aldığınız krediler görüntülenir
5. İlgilenebileceğiniz kredilerin bir listesi de oradadır

Tüm bu bilgi, birbirinden farklı sistemler ve uygulamalardan gelmektedir ve her biri veriyi (HTTP, JSON, AMQP, XML, SOAP, FTP, CSV, ve aslında çok da önemli olmayan): değişik bağlantı şekillerinden görünür hale getirmektedir.

1. CRM uygulaması Linux ve Oracle ile çalışıyor
2. z/OS mainframe sistem üzerinde COBOL ile yazılmış
3. Mainframe dedik ama size herşeyi söylemek için pek ağzı sıkı olan bu sistemler size sadece CSV verisi gönderirler
4. Windows üznerinde PHP ve Ruby çalışmaktadır.
5. PostgreSQL, Python ve Java Linux ve Solaris üzerinde çalışmaktadır

Şimdi sorumuz arayüz uygulamasını 1-5 arası çalışan tüm bu uygulamalarla nasıl konuşur hale getireceksiniz? **Bittabiki bunu yapmayacaksınız**

**Bu ayrı mimarilerin birbiriyle doğrudan konuşmasına izin vermeyeceksiniz.** Bu, zaten başa çıkılması zor olan mimarilerin her birinin, kendi içinde ölçekli çalışabilmesini sağlayabilmek için temel bir ilkedir.

Aşağıdaki çizimde, sistemin yaptığı her bir servis çağrısı değişik boyut ve stilde belirtilmiştir.

.. figure:: _static/mess1.png
   :scale: 100 %
   :align: center

   Resimler şu adresten alınmıştır. https://zato.io/docs/intro/esb-soa-tr.html

Lütfen dikkat ediniz, daha üst seviye süreçleri bu çizimde göstermedik bile. Mesela App1, App6’nın daha önce verdiği cevaba göre App2 veya App3 ya da App5’i çağırır ve böylece App4 daha sonra App2 tarafından üretilen veriyi alır ve fakat sadece App1 veri çekmeye izin veriyorsa ;_;

Ayrıca not ediniz, daha sunucuların birbirleriyle olan iletişiminden hiç bahsetmedik misal her bir sistem 10 adet fiziki sunucuda çalışıyor olabilir ve bu durumda 60 adet fiziki sunucu birbiriyle konuşuyor olabilir.

Ve fakat, hala bazı sorularımız kalıyor geriye.

Bu arayüzleri nasıl birbirinden ayıracağız? Yeni sürümü nasıl planlayabilirsiniz? Her biri değişik ekipler, satıcılar veya bölümler tarafından yönetilen uygulamaların güncellemelerini ya da sürüm indirimlerini nasıl koordine edeceksiniz? Üstelik işin başındaki ekibin yarısı çoktan işten ayrılmışken?

Eğer 6 değişik uygulamayla başa çıkabileceğinizi düşünüyorsanız, 30 taneye ne dersiniz?

.. figure:: _static/mess2.png
   :scale: 100 %
   :align: center

   Resimler şu adresten alınmıştır. https://zato.io/docs/intro/esb-soa-tr.html


Peki 400 ayrı uygulama ile başa çıkabilir misiniz? Ya 2000? Her bir uygulamanın 10 sunucu gerektiren tekil bir ortamda koştuğunu ve bu 20K’lık sistemin parçalarının kıtalara dağıtık olduğunu ve arada her türlü teknik ve kültürel sınırlar olduğunu, üstelik sistemin her bir parçasının hiç bir kesinti olmadan son derece geveze bir şekilde, diğer parçalarla sürekli olarak durmadan mesaj alıp verdiğini? (Bu durumun çizimini paylaşmayacağız korkmayın)

Bu duruma gayet uyan bir tanımımız var. Buna karmaşa diyoruz.

Bu karmaşayı nasıl düzelteceksiniz?
-----------------------------------

Yapılacak ilk şey, durumun kontrolden çıktığını kabul etmektir. Bu da size çok fazla suçluluk hissetmeden vaziyeti kurtarma şansı verir. Tamam, oldu bir kere, daha iyisini bilmiyordunuz, ama şimdi düzeltmek için bir çare var.

Bu, belki de kurumun IT yaklaşımında yapısal bir değişiklik anlamına gelebilir fakat başka bir adım da, sadece etrafa veri basmak için yaratılmamış sistem ve uygulamaları feshetmek olabilir. Bunların hepsinin amacı, bulunduğunuz sektörün ne olduğuna bakılmaksızın iş süreçleriniz olmalıdır. Bankacılık, ses kaydı tutma, muhasebe, telsizle yer bulma cihazları, web uygulamaları vb. her tür iş.

Bu ikisini açıklıkla belirlediğiniz zaman sisteminizi servisler etrafında kurmak üzere düşünmeye başlayabilirsiniz.

Servis, diğer uygulamaların kullandıklarında mutlu olacakları, “ilginç olan”, “tekrar kullanılabilir (reusable)” ve “atomik” bir şeydir ve asla iki endpoint arasında noktadan noktaya erişime açılmaz. Bu, servis hakkında olası en kısa anlamlı açıklamadır.

Eğer bir sistemdeki işlevsellik şu 3 ihtiyacı karşılıyorsa;

- **İ** lginç
- **T** ekrar kullanılabilir
- **A** tomik

bu sistem, diğer sistemlere asla doğrudan olmamak üzere açılabilir. (expose edilebilir)

Buyrun bu İTA yaklaşımını bir kaç örnek üzerinden tartışalım.

+--------------------------+--------------------------------------------------------------------+
| Değişken                 | Notlar                                                             |
|                          |                                                                    |
+==========================+====================================================================+
| Ortam                    | Elektrik şirketi CRM uygulaması                                    |
|                          |                                                                    |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| İşlev                    | 2012 3. çeyreğinden beri self                                      |
|                          | servis portalinde aktif olan müşterilerin listesini döndür.        |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| İlginç mi?               | Evet gayet ilginç. Bu pek çok değişik rapor ve istatistikte        |
|                          | kullanılabilir.                                                    |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| Tekrar kullanılabilir mi?| Hayır, pek sayılmaz. Ancak tüm yılın istatistikleri gibi daha      |
|                          | üst seviye kurgular yapmaya izin verir, ancak açıktır ki 2018      |
|                          | yılı için kullanmaya pek de olanak yok.                            |
+--------------------------+--------------------------------------------------------------------+
| Atomik mi?               | Büyük bir olasılıkla evet. Eğer yılın diğer çeyrekleriyle ilgili   |
|                          | bilgi veren başka servisler de varsa, tüm yıl için bir fikre       |
|                          | varılabilir.                                                       |
+--------------------------+--------------------------------------------------------------------+
| Nasıl İTA olacak?        | Sadece bir çeyrek zaman aralığı yerine, rastgele başlama           |
|                          | ve bitiş tarihlerini kabul edecek hale getirmek.                   |
|                          | Sadece portal değil, başka herhangi bir sebeple sisteme            |
|                          | bağlanacak olan uygulamaların da kullanımını sağlamak. Uygulamanın |
|                          | input param gibi girilmesini ve sadece portal şeklinde sabit olarak|
|                          | kodlanmış (hard coded) olmasını sağlamak.                          |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+




+--------------------------+--------------------------------------------------------------------+
| Değişken                 | Notlar                                                             |
|                          |                                                                    |
+==========================+====================================================================+
| Ortam                    | E-ticaret sitesi                                                   |
|                          |                                                                    |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| İşlev                    | Verilen müşteriye ait toplanmış her tür bilgiyi döndürmek.         |
|                          |                                                                    |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| İlginç mi?               | Evet kesinlikle. Eğer tüm veriyi okuyabiliyorsanız, sadece lazım   |
|                          | olan kısmını alabilirsiniz.                                        |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| Tekrar kullanılabilir mi?| Komik ama tam olarak değil. Çok az sayıda, tüm bu veriyle          |
|                          | ilgilenen uygulama olacaktır.                                      |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| Atomik mi?               | Kesinlikle değil. Bu canavar işlevsellik, mantık olarak            |
|                          | birbirine eklemlenmiş düzinelerce küçük parçadan oluşmaktadır.     |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| Nasıl İTA olacak?        | Küçük parçalara bölerek. Müşteriyi neyin özetlediğini düşünün      |
|                          | (adres bilgisi, telefonlar, favori ürünleri, seçtiği iletişim      |
|                          | yöntemleri vb. bilgiler) bunların her biri bağımsız birer servise  |
|                          | dönüştürülmelidir.                                                 |
|                          | Atomik olanlar dışında ESB (Kurumsal Servis Veriyolu) kullanarak   |
|                          | bileşik servisler yaratmak                                         |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+


+--------------------------+--------------------------------------------------------------------+
| Değişken                 | Notlar                                                             |
|                          |                                                                    |
+==========================+====================================================================+
| Ortam                    | Herhangi bir yerdeki CRM uygulaması                                |
|                          |                                                                    |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| İşlev                    | Birisi bir hesap yarattıktan sonra C_NAZ_AJ tablosundaki CUST_AR_ZN|
|                          | kolonunu güncellemek.                                              |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| İlginç mi?               | Kesinlikle hayır. Bu CRM uygulamasının iç bir fonksiyonu. Şu       |
|                          | mantıklı dünyada hiç kimse böyle alt kademe bir fonksiyonla        |
|                          | uğraşmak istemez.                                                  |
+--------------------------+--------------------------------------------------------------------+
| Tekrar kullanılabilir mi?| Muhtemelen evet. Hesap değişik kanallardan yaratılabiliyorsa       |
|                          | tekrar kullanılabilir.                                             |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| Atomik mi?               | Evet öyle görünüyor. Bu sadece bir tablodaki bir kolonun           |
|                          | güncellenmesi işi.                                                 |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| Nasıl İTA olacak?        | Bunu sakın servise çevirmeye çalışmayın. İlginç değil bir kere.    |
|                          | Hiç kimse bir sistemde yer alan belirli bir tablolar ve kolonların |
|                          | güncellenmesiyle uğraşmaz. Bu CRM uygulamasının karmaşık bir       |
|                          | detayıdır ve zaten kendi kendine hem tekrar kullanılabilir ve      |
|                          | hem de atomik durumdadır. İş bu sebeple servis yapmaya çalışmamak  |
|                          | lazımdır. Bunu CRM uygulamasını yazan düşünsün siz değil.          |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+



+--------------------------+--------------------------------------------------------------------+
| Değişken                 | Notlar                                                             |
|                          |                                                                    |
+==========================+====================================================================+
| Ortam                    | Mobil telekomünikasyon şirketi                                     |
|                          |                                                                    |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| İşlev                    | Ödeme sistemine bağlı bir ön ödemeli kartı yeniden doldurmak.      |
|                          |                                                                    |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| İlginç mi?               | Had safhada evet. Herkes SMS, sesli yanıt sistemi, portal, hediye  |
|                          | kartı gibi değişik yollardan bunu kullanmak ister.                 |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| Tekrar kullanılabilir mi?| Hayli tekrar kullanılabilir. Daha üst seviye pek çok sürecin       |
|                          | parçası olabilir.                                                  |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+
| Atomik mi?               | Evet, kendisini çağıran uygulamalar açısından bakarsak kartı tekrar|
|                          | ya da dolduramaz. Bir dizi adımla bu işlevselleği uyarlayacak      |
|                          | ödeme sistemi burada konu dışıdır. İş açısından bakarsanız,        |
|                          | bu ödeme sistemi tarafından sunulan atomik ve bölünemez bir        |
|                          | servistir.                                                         |
+--------------------------+--------------------------------------------------------------------+
| Nasıl İTA olacak?        | Bunu sakın servise çevirmeye çalışmayın. İlginç değil bir kere.    |
|                          | Hiç kimse bir sistemde yer alan belirli bir tablolar ve kolonların |
|                          | güncellenmesiyle uğraşmaz. Bu CRM uygulamasının karmaşık bir       |
|                          | detayıdır ve zaten kendi kendine hem tekrar kullanılabilir ve      |
|                          | hem de atomik durumdadır. İş bu sebeple servis yapmaya çalışmamak  |
|                          | lazımdır. Bunu CRM uygulamasını yazan düşünsün siz değil.          |
|                          |                                                                    |
+--------------------------+--------------------------------------------------------------------+



Değişken	Notlar
Ortam	Mobil telekomünikasyon şirketi
İşlev	Ödeme sistemine bağlı bir ön ödemeli kartı yeniden doldurmak.
İlginç mi?	Had safhada evet. Herkes SMS, sesli yanıt sistemi, portal, hediye kartı gibi değişik yollardan bunu kullanmak ister.
Reusable?	Hayli tekrar kullanılabilir. Daha üst seviye pek çok sürecin parçası olabilir.
Atomik mi?	Evet, kendisini çağıran uygulamalar açısından bakarsak kartı tekrar doldurabilir ya da dolduramaz. Bir dizi adımla bu işlevselleği uyarlayacak ödeme sistemi burada konu dışıdır. İş açısından bakarsanız, bu ödeme sistemi tarafından sunulan atomik ve bölünemez bir servistir.
Nasıl İTA olacak?	E zaten öyle şu an.
Eğer son 50 yıl civarında programlama ile uğraştıysanız, kendi uygulamanızı servis olarak bir dış uygulamaya açmanın, başka biri tarafından yazılmış koda kendi kodunuzu API olarak açmakla kesinlikle benzediğini görebilirsiniz. Aradaki tek fark, tekil bir sistemdeki alt sistemlerle uğraşmak yerine, birbirinden tamamen ayrılmış sistemlerde çalışıyor oluşunuz.

ESB üzerinde SOA ile servis yaratmak
------------------------------------

Şimdi sistemlerin asla doğrudan bilgi alışverişi yapmadığını ve bir servisin ne olduğunu anladığınıza göre ESB’den faydalanmaya başlayabilirsiniz.


.. figure:: _static/esb-ok.png
   :scale: 100 %
   :align: center

   Resimler şu adresten alınmıştır. https://zato.io/docs/intro/esb-soa-tr.html

Tümleşik sistemlerde servisleri çağırmak ve kullanmak, artık Kurumsal Veri Yolu’nun (ESB) işine dönüşüyor. Bu şekilde, genellikle KVY kullanarak sadece bir arayüz ve bir erişim metodu yazmak yeterli oluyor.

Eğer yukarıdaki diyagramdaki gibi 8 sisteminiz varsa, yaratılacak, bakımı yapılacak ve idare edilecek, 16 adet ara birim oluşacaktır.

Eğer KVY olmasaydı, her sistemin birbiriyle konuştuğunu varsayacak olsak 56 adet ara biriminiz olması gerekirdi.

40 adet daha az ara birim demek daha az para ve zaman harcamak demek. Cuma günlerinizin neden daha kasıntılı geçtiğinin de bir sebebi aynı zamanda.

Sadece bu durum bile sizi KVY kullanmaya başlama konusunda özendirmeli.

Eğer bir gün sistem yeniden yazılsa, şirket el değiştirse, hatta kurum içi bölümler tekrardan bölünse bile değişime ayak uydurmak KVY ekibinin görevidir. Kurumdaki başka hiç bir sistemin bu değşikliklerden haberi bile olmaz çünkü KVY ile kullandıkları arabirim aynı kalacaktır.

Yukarıda anlattığımız İTA servislerini günlük olarak deneyimlediğinizde, artık bileşik servisleri de düşünmeye başlayabilirsiniz.

Az evvel yukarıdaki bahsettiğimiz ‘bana-müşteriyle-ilgili-her-şeyi-ver’ servisini hatırladınız mı?

Böyle bir servis yazmak iyi bir fikir değil ama zaman zaman istemci (client) uygulamaların bu türden toplanmış ve özetlenmiş bilgiye ihtiyacı oluyor. İşte bu belirli istemci için en iyi bileşik veriyi getirecek en kral atomik servisi seçecek olan da gene KVY ekibidir.

Bir zaman sonra tüm organizasyonun kafasına dank edecek gerçeklik şudur; Bu işin tablolar, dosyalar, fonksiyonlar, rutinler, kayıtlarla falan bir ilgisi kalmamıştır. Bu artık ilginç, tekrar kullanılabilir ve atomik servisleri merkeze alan bir mimari meselesidir.

İnsanlar artık uygulamaların ve sistemlerin birbirine nasıl bir şeyler göndereceği konusunda düşünmeyecekler. KVY sistemini, kendi sistemlerinde kullanabilecekleri ilginç servisler olarak görecekler. Ve bundan sonra hangi servisi kimin sunduğuyla ilgilenmeyecekler, kendi sistemleri sadece KVY ile ilgilenecek.

Bu, sabır, koordine bir çaba ve zaman alacak bir süreç ancak yapılabilir bir şey.

Aman dikkat edin...
-------------------

Servis odaklı uygulama (SOA) konseptini mahvetmenin en kolay yolu KVY hizmetini açıp ondan sonra olayların kendiliğinden düzelmesini beklemek olabilir. Hala harika bir fikir olmasına rağmen, sadece KVY sistemini kurmakla çok büyük bir kazanım sahibi olamazsınız maalesef.

En iyi halde, aşağıdaki diyagramdaki gibi bazı şeyleri halı altına süpürmek, size hiç bir şey kazandırmayacaktır.

.. figure:: _static/esb-mess.png
   :scale: 100 %
   :align: center

   Resimler şu adresten alınmıştır. https://zato.io/docs/intro/esb-soa-tr.html

IT ekibiniz ondan tiksinecek, yönetim ise önce bu yeni gelen çocuğa tolerans gösterecek ancak daha sonra KVY iyice alay konusu olacak. “Ney ney, sihirli değnek değil mi, Hahahaha”.

Eğer KVY işleri iyi hale getirmek üzere yapılan daha büyük bir planın parçası olamazsa, bu türden sonuçlar kaçınılmaz hale gelecektir.

KVY bankalar vb. kocaman kurumlar için uygun görünüyor, öyle mi?
------------------------------------------------------------------------------------------

Kesinlikle yanlış, öyle değildir. İlginç bir sonuç almak için her koşulda birden fazla erişim yöntemiyle birden fazla veri kaynağını işbirliği içinde kullanabilmek son derece iyi bir tercih.

Mesela, termal sensörlerden alınan en son okuma değerlerini, bir entegrasyon platformu içinde yer alan eposta alarmı ya da Iphone uygulaması gibi birbirinden farklı kanallara yayınlamak için son derece uygun bir yol KVY.

Kritik bir uygulamanın tüm bileşenlerinin ayakta olup olmadığını düzenli olarak denetleyen ve sorun varsa hemen sms gönderen bir betiği koşturmak ta çok iyi fikir.

Temiz ve iyi tanımlanmış bir ortamda bulunan ve entegrasyon ihtiyacı bulunan her şey KVY servisi için idealdir, ancak gene de en iyi adapte olan servisleri oluşturmak ta tecrübe işidir. Bu konuda Zato ekibinden yardım alabilirsiniz.

Fakat duydum ki SOA sadece XML, SOAP ve web servisleri hakkındaymış
------------------------------------------------------------------------------------------

Evet, bu belirli bir kısım insanın inanmak istediği şey.

Eğer çalıştığınız kişiler veya kurumlar BASE64-kodlanmış bir CSV dosyası yaratıp, bunu bir de SAML-secured SOAP mesajı halinde size gönderiyorlarsa nasıl bir izlenim bıraktığınız anlaşılabilir bir şey.

XML, SOAP ve web servislerinin kullanım alanları var ama her şey gibi onlar da yanlış şekilde kullanılabilirler.

SOA temiz ve yönetilebilir bir mimari içindir. Bir servisin SOA kullanıp kullanmadığı konu dışı. Bir tane bile SOAP servisi kullanılmasa bile, SOA hala geçerli bir mimari yaklaşım olarak geçerli olacaktır.

Bir mimar harika bir bina tasarlasa bile, binayı kullanacak kişilerin iç mekanlarda hangi rengi seçeceği hakkında yapabileceği çok da bir şey yok.

Kısaca hayır, SOA sadece XML, SOAP ve web servisleri hakkında değildir. Bu da kullanılabilir elbette ama tüm mesele bundan ibaret değil.

SOA hakkında gerçekleri öğrenmek isteyen ve yolunu kaybetmiş meslektaşlarınız varsa onları da bu makaleye yönlendirmenizi, SOA hakkındaki gerçekleri anlamaya davet ediyoruz.

Ve fazlası da var
-----------------

Bu bölüm sadece temelleri kapsıyor ancak size KVY ve SOA’nın neye benzediği ve nasıl başarıyla uygulayabileceğiniz hakkında sağlam bir anlayış verdiğini umuyoruz.

Burada ele almadığımız ve bununla sınırlı olmayan diğer konular;

- KVY geçişi için yönetimden nasıl destek istersiniz
- SOA mimarlarını ve analiz ekibini nasıl işe alırsınız (Varsa tabii)
- Kurumunuza Canonical Veri Modeli (CDM) nin tanıtılması
- Anahtar Performans Göstergesi (KPI) - artık sistemler arası kullanılacak servisler için ortak ve birleştirilmiş bir yönteme sahipsiniz. Şimdi bu sistemi gözlemleyerek ne elde ettiğinizi ölçümlemeniz gerekiyor.
- İş Süreci Yönetimi (BPM) - servisleri planlamak için ne zaman ve nasıl bir BPM platformu seçmelisiniz (cevap - düzgün çalışan ve tapılası servisleri nasıl yaratacağınızı anlamadan ve iyice yakınlaşmadan aman geçmeyiniz)
- Herhangi bir API’si olmayan sistemlerle ne yapacaksınız. Mesela KVY bunların veritabanına doğrudan erişmeli mi? (cevap - bu konuda belirlenmiş net bir kural yok)

Zato tam olarak nedir?
----------------------

Zato middleware ve backend sistemler inşa etmek için Python dili ile yazışmış bir KVY ve uygulama sunucusudur. Hem ticari hem de topluluk desteği bulunan açık kaynak kodlu bir yazılımdır. Ve Python da kullanım kolaylığı ve üretkenliği ile meşhur bir dil. Python ve Zato’yu birlikte kullanıyor olmanız demek, baş belası olan pek çok konuya daha az zaman harcamak ve daha verimli olmak anlamına gelir.

Zato **pragmatistler tarafından pragmatistler için** yazılmıştır. Herhangi bir tedarikçinin SOA/KVY pazarından pay kapmak amacıyla alelacele bitiştiriverdiği dingabak bir sistem değildir.

Aslında, tam olarak bu tür sistemlerde ortaya çıkan yangını söndürmek üzere pratik olarak yapılan çalışmaların bir sonucudur.

Zato bu tür sistemler üzerinde çok uzun süre çalışma sonucu ortaya çıktığından görünürde benzer olan sistemlere göre çok daha fazla verimlilik ve kullanım kolaylığı sunar.

Daha fazla bilgi `için! <https://zato.io/docs/index.html>`_

See you there!