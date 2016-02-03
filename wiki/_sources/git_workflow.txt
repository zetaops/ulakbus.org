++++++++++++++++++++++++++
Ulakbus'e Katkıda Bulunmak
++++++++++++++++++++++++++

Ulakbus kaynak kod depoları, geliştiriciler tarafından yaygın şekilde kullanılan Github üzerinde
bulunmaktadır. Github ``git`` kaynak kod ve sürüm takip sisteminin yanısıra, oldukça etkili proje
yönetim ve geliştrici topluluğu inşa etme araçları sunmaktadır. Kolay kullanılabilir arayüzeyi
sayesinde dağıtık, çok aktörlü bir yazılım geliştirme faaliyetini kolaylıkla sürdürülebilir hale
getirmektedir.

Github hesabınıza giriş yaptıktan sonra, Ulakbus depolarımızı fork ederek geliştirmeye
başlayabilirsiniz. Bir Github hesabınız yoksa, `github.com <https://www.github.com>`_
adresinden edinebilirsiniz.

Github İş Akışı
+++++++++++++++

Başlangıç için Github İş Akışı hakkında şu belgeye göz atmanızı şiddetle tavsiye ederiz:
`Understanding the GitHub Flow <https://guides.github.com/introduction/flow/>`_

Bu belgede Github üzerinde açık kaynak kodlu projelere nasıl katkı sağlayacağınıza dair bilgiler
bulunmaktadır. Konua yabancı olanlar için karmaşık gözükse de, aslında oldukça basit olan süreç,
bu belgede görsel bir şekilde anlatılmıştır.

Belgede adı geçen ``fork & pull request`` yöntemi, bizim de Ulakbus projesine katkı kabul etme
yöntemimizdir. Bu yönteme göre geliştirme döngüsü adımları şu şekildedir:

    * Depoyu fork et,
    * Uygun bir branch açıp geliştir,
    * Pull request ile Ulakbus depolarına gönder

Birinci adım arayüzeyde bulunan ``Fork`` butonu yardımıyla kolaylıkla gerkeçleştirilir. Böylelikle
Ulakbus kod deposunun o anki halini kendi depolarınız arasına girer. Kendinize ait bir depo olduğu
için dilediğiniz gibi yönetme ve yazma hakkına sahip olursunuz.

Geliştirme faaliyeti bu adımdan sonra başlar. Aşağıda ``Git İpuçları`` ve ``Kod Yazma İpuçları``
bölümlerinde geliştirme faaliyeti süresince dikkat etmeniz gereken hususları ve Ulakbus projesi
olarak beklentilerimizi okuyabilirsiniz. Bu bölümlerde yer alan kimi maddeler, genel yazılım
geliştirme prensipleri ile ilgili hatırlatmalardır. Bazıları ise Ulakbus projesinin çekirdek
ekibi tarafından da uygulanan, projemize özel hususlardır.

Geliştirme aşaması tamamlanan kod, fork edilen kod deposuna, başka bir ifadeyle ``upstream depo``ya
yani Ulakbus'e ``pull request`` ile gönderilir.

Github üzerinde çalışmak ile ilgili daha fazla detayı şu bağlantılarda bulabilirsiniz:
    * https://guides.github.com/activities/hello-world/
    * https://help.github.com/desktop/guides/contributing/working-with-your-remote-repository-on-github-or-github-enterprise/
    * http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1


Git İpuçları
++++++++++++
Git'in dağıtık yapısı birlikte çalışabilirliği kolaylaştırmaktır. Öte yandan git kullanırken commit
mesajları, branch isimleri, commit sıklığı ve içeriği, merge / rebase alışkanlıkları gibi usüle
ilişlin konularda mümkün olduğunca ortak olmak proje yönetimini kolaylaştırmaktadır. Bu sebeple
Ulakbus projesine katkı yaparken sizlere yardımcı olacak aşağıdaki ipuçlarını dikkatle okumanızı
öneririz.

Git Kurulumu
------------
    * Linux (Ubuntu):    sudo apt-get install git
    * MacOS X:           http://help.github.com/mac-git-installation/

İlk kurulumun hemen arından git'e kendinizi tanıtmayı unutmayınız:

::

    git config --global user.name "Emo Coder"
    git config --global user.email "emo@zetaops.io"


Git hakkında şu bağlantılardan detaylı bilgi alabilirsiniz:
    * http://git-scm.com/book/en/v2/Getting-Started-About-Version-Control
    * https://try.github.io/levels/1/challenges/1
    * http://gitref.org
    * http://www.slideshare.net/kunthar/git-101-15229948
    * http://www.sbf5.com/~cduan/technical/git/

Eğer tasarımcıysanız aşağıdaki bağlantıda tasarımcıların git kullanımı konusunda iyi bir makale
bulabilirsiniz: http://www.webdesignerdepot.com/2009/03/intro-to-git-for-web-designers/

Branch Kullanmak
----------------
    * Branch kullanmayı alışkanlık haline getirin. Ana branch'e (master) doğrudan push etmeyin.
    * Branch adları eğer bir özellik geliştirmesi yapıyorsanız `feature/`, bir hata ile
      ilgileniyorsanız `bugfix/` ön ekini taşımalıdır: ``feature/yeni_ozellik`` veya
      ``bugfix/xyz_hatasi``
    * Branchlerinizi düzenli şekilde rebase ederek, temel branchlerdeki değişikliklerden
      uzaklaşmamasını sağlayınız. Ulakbus resmi depoları **Git Flow** kullanmaktadır. Bu sebeple
      Ulakbus resmi deposu temel branch'i ``develop`` adını taşır. Eğer kendi deponuza Ulakbus
      projesini ``upstream`` olarak eklediyseniz ``upstream/develop`` ile bu branch'e
      erişebilirsiniz.

**Git Flow** Ulakbus projesinde kullanılan branch yönetim modeli ve aracıdır. Bu modeli
kullanmak yukarıda bahsedilenlerin yanısıra başka birçok faydayı beraberinde getirir.
Zorunlu olmamakla birlikte, ``git`` kullanım alışkanlıklarınızı pozitif şekilde
değiştireceğine inandığımız bu aracı ve metodu kullanmanı daha fazla uyumluluk için
öneririz. Git Flow konusunda detaylı bilgileri bu dökümanın en altında bulabilirsiniz.


Commit Mesajları
----------------
    * Mesajlarını yazarken aşağıdaki etiketlerden faydalanabilirsiniz (bakınız: http://keepachangelog.com/):

      * ADD - Yapılan değişiklik yeni bir özellik ekliyorsa,
      * CHANGE - Mevcut bir işlevsellikte değişiklik yapılıyorsa,
      * DEPRECATE - daha önce mevcut olan bir özelliğin geliştirilmesinden vazgeçiliyorsa,
      * REMOVE - Vazgeçilen özellikler tamamen çıkarılıyorsa,
      * FIX - Herhangi bir hata gideriliyorsa,
      * SECURITY - Güvenlik ile ilgili bir değişiklik yapılıyorsa.
      * REFACTOR - Kod işlevsellikler değiştirilmeden optimizasyon gibi amaçlar ile değiştiriliyorsa

    * Commit mesajlarınızın ilk satırı mümkün olduğunca kısa ve çalışmalarınızı özetlemelidir. 50 - 70
      karakter arası.
    * Detaylar commit summary bölümünde bulunmalıdır.
    * Geliştirme faaliyetleriniz için gereken tüm depolarda issue açıp, commit mesajlarınızda
      zetaops/ulakbusGH-145 şeklinde referanslar veriniz.


Upstream Depo Eklemek
---------------------
Fork ettiğiniz Ulakbus deposunu kendi git deponuzun ``upstream`` deposu olarak tanımlamak, ana depodaki
değişikliklere istenildiğinde daha kolay erişebilmek için faydalı olabilir. Örneğin:

::

    git remote add upstream https://github.com/zetaops/ulakbus.git

Kendi remote deponuza origin adiyla, ulakbus depolarına da upstream adıyla erişebilirsiniz. Upstream
branchleri kendi branchlerinizi rebase etmek, kod karşılaştırması yapmak, yeni geliştirilen özellikleri
gözden geçirmek amacıyla kullanabilirsiniz.

::

    git rebase upstream/master
    git diff upstream/master..master
    git checkout upstream/feature/yeni_ozellik

komutları ile upstream kullanabilirsiniz.

Kod Yazma İpuçları
++++++++++++++++++
İşlevselliğin yanısıra, kodun nasıl yazıldığı, ne kadar optimize yazıldığı ve dökümantasyonu
oldukça önemlidir. Bu amaçla aşağıdaki ipuçları Ulakbus depolarına kod katkısı yaparken işleri
herkez açısından kolaylaştıracaktır.

    * PEP8 Python dili için evrensel bir standarttır. Lütfen PEP8 klavuzuna uyunuz.
    * Kod içi dökümantasyonu ``Google Style Python Docstrings`` yönergeleri ile
      yapmaktayız. Nasıl kullanılacağı https://sphinxcontrib-napoleon.readthedocs.org/en/latest/example_google.html
      adresinde bulunmaktadır.