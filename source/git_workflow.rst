++++++++++++++++++++++++++
Ulakbus'e Katkıda Bulunmak
++++++++++++++++++++++++++

Ulakbus kaynak kod depoları, geliştiriciler tarafından yaygın şekilde kullanılan Github üzerinde
bulunmaktadır. Github ``git`` kaynak kod ve sürüm takip sisteminin yanısıra, oldukça güçlü proje
yönetim ve geliştrici topluluğu inşa etme araçları sunmaktadır. Kolay kullanılabilir arayüzeyi
sayesinde dağıtık bir geliştirme faaliyetini kolaylıkla sürdürülebilir hale getirmektedir.

Hesabınıza giriş yaptıktan sonra, Ulakbus depolarımızı fork ederek geliştirmeye başlayabilirsiniz.
Bir Github hesabınız yoksa, `github.com <https://www.github.com>`_ adresinden edinebilirsiniz.

Github İş Akışı
+++++++++++++++

Başlangıç için Github İş Akışı hakkında şu belgeye göz atmanızı şiddetle tavsiye ederiz:
`Understanding the GitHub Flow <https://guides.github.com/introduction/flow/>`_

Projeye katkıları 'fork & pull request' metodu ile kabul ediyoruz. Bu yönteme göre geliştirme
döngüsü adımları şu şekildedir:

    * Depoyu fork et,
    * Uygun bir branch açıp geliştir
    * Pull request ile kodu Ulakbus depolarına gönder


Git İpuçları
++++++++++++
Git'in dağıtık yapısı birlikte çalışabilirliği kolaylaştırmaktır. Öte yandan git kullanırken commit
mesajları, branch isimleri, commit sıklığı ve içeriği, merge / rebase alışkanlıkları gibi usüle
ilişlin konularda mümkün olduğunca ortak olmak proje yönetimini kolaylaştırmaktadır. Bu sebeple
Ulakbus projesine katkı yaparken sizlere yardımcı olacak aşağıdaki ipuçlarını dikkatle okumanızı
öneririz.

Branch Kullanmak
----------------
  * Branch kullanmayı alışkanlık haline getirin. Ana branch'e (master) doğrudan push etmeyin.
  * Eğer bir özellik geliştirmesi yapıyorsanız `feature`, bir hata ile ilgileniyorsanız `bugfix`
    ön ekini taşımalı: `feature\yeni_ozellik`veya `bugfix\xyx_hatasi`
  

Kod Yazma İpuçları
++++++++++++++++++
İşlevselliğin yanısıra, kodun nasıl yazıldığı, ne kadar optimize yazıldığı ve dökümantasyonu
oldukça önemlidir. Bu amaçla aşağıdaki ipuçları Ulakbus depolarına kod katkısı yaparken işleri
herkez açısından kolaylaştıracaktır.

    * PEP8 python için

++++++++++++
Git İş-Akışı
++++++++++++

**HİÇBİR ZAMAN MASTER'A PUSH ETMEYİNİZ, DAİMA BRANCH KULLANINIZ.**

* Lütfen TÜM dökümanı okuyunuz.

* Paket bağımlılıklarını sürekli iki kere kontrol ediniz.

* PATH değişkenlerini sürekli iki kere kontrol ediniz.

* Depoya büyük değişiklikler göndermeyiniz.Küçük değişiklikler yaptıkça depoya gönderiniz.

* requirements.txt dosyasına yeni kütüphaneleri eklemeyi unutmayınız.

* Asla MASTER branch'i rebase etmeyi unutmayınız.

* Gelişim raporları düzenli olarak her gün Redmine'a yüklenmeli.

----------------
**Git kurulumu**
----------------

* Linux ->      sudo apt-get install git-core

* Mac OS X ->    bakınız http://help.github.com/mac-git-installation/

* Windows ->     bakınız http://help.github.com/win-git-installation/

Aşağıdaki komutları çalıştırınız. (Kendinize ait isim ve e-mail adresini değiştirmeyi unutmayınız.)

::

    git config --global user.name "Emo Coder"
    git config --global user.email "emo@zetaops.io"

**Git Temelleri**

Git temellerini öğrenmek için aşağıdaki kaynakları okuyunuz.

- http://git-scm.com/book/en/v2/Getting-Started-About-Version-Control
- https://try.github.io/levels/1/challenges/1
- http://gitref.org
- http://www.slideshare.net/kunthar/git-101-15229948
- http://www.sbf5.com/~cduan/technical/git/

Eğer tasarımcı iseniz :  http://www.webdesignerdepot.com/2009/03/intro-to-git-for-web-designers/

Eğer yazılım geliştirici değilseniz şu linkleri takip edebilirsiniz:

- http://oyun.mynet.com/okey
- https://aylak.com/batak-oyna/
- http://www.oyunoyna.com


-------------------
**Branch Yönetimi**
-------------------

* Master branch sadece gözden geçirilmiş ve test edilmiş kodu içerir. Sadece yetkili geliştiriciler master'a kod gönderebilir (commit).

* Her yeni özellik ve yazılım hatası düzeltimi, yeni bir branch içinde geliştirilir.

* Yeni branch en son master temel alınarak başlatılmalıdır.

* Her branch, master branch ile merge edilmeden önce en az bir başka geliştirici tarafından ve test edilmelidir.

* Her branch, master branch ile merge edilmeden önce en son master branch ile rebase edilmelidir.

* Her branch “feature/345/chat” veya “bug/415/crashing_on_stop” şeklinde adlandırılmalıdır. Redmine ya da github issue adı ve kısa açıklaması issue adından gelmelidir.


Tüm branchleri görüntülemek için:

::

    git branch -a

----------------
**Kodu edinmek**
----------------

Mevcut kod ile çalışmak için mutlaka "Geliştirme Ortamı Kurulumu" http://www.ulakbus.org/wiki/development_environment_setup.html belgesini inceleyiniz.
Bu belgede hem ortam kurulumu hem de depoların bağlanması detaylı olarak anlatılmaktadır.


------------------------------
**Günlük geliştirme iş akışı**
------------------------------

Depolarımızın tamamı Github üzerinde yer almaktadır. Bu sebeple Github üzerinde çalışmak konusunda kendinizi eğitiniz.

* https://guides.github.com/activities/hello-world/
* https://help.github.com/desktop/guides/contributing/working-with-your-remote-repository-on-github-or-github-enterprise/
* http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1

Github üzerinde kendinize bir kullanıcı hesabı açınız. Depolarımızı kendi Github hesabınız üzerinden fork ediniz.
Artık kendi github hesabınızda ulakbus ve ulakbus-ui temel depolarınız görülecektir.
Github üzerinde HTTPS clone URL ibaresi altındaki satırı kopyalayarak klonlama işlemine hazırlanın:

::

    mkdir -p ~/development/zetaops/
    cd ~/development/zetaops/
    mkdir repos
    mkdir vms
    cd repos
    git clone https://github.com/sizin_user_adınız/ulakbus
    git clone https://github.com/sizin_user_adınız/ulakbus-ui
    cd ulakbus
    git remote add origin https://github.com/zetaops/ulakbus.git
    cd ~/development/zetaops/repos/ulakbus-ui
    git remote add origin https://github.com/zetaops/ulakbus-ui.git


Bu şekilde kendi fork deponuz üzerinde çalışacaksınız ve bizim depomuz, sizin deponuza "upstream" depo olarak eklenecektir.
Her bir depo içinde ne olup bittiğini görsel olarak görmek isterseniz, konsolda tig kullanabilirsiniz. apt-get install tig, macports ile sudo port install tig
Eğer penceresel bir ortamdan geliyorsanız SourceTree kullanabilirsiniz. Tasarımcılar hariç, tüm geliştirme ortamı Ubuntu, Debian, Pardus, ArchLinux ya da MacOS gibi işletim
sistemine sahip bilgisayarlarda bulunmaktadır. Bu sebeple sinir sahibi olmak istemiyorsanız, w$ndoze üzerinde geliştirme yapmaya çalışmayınız.

Yeni branch yaratmak için:

::

    cd path/to/project
    git checkout master
    git pull --rebase
    git branch (feature/bug)/some-new-feature/bug

Programlamadan önceki hazırlık:

::

    cd path/to/project

    git checkout master
    git pull --rebase
    git checkout feature/some-feature
    git rebase master



---------------------------------
**feature/bug Üzerinde Çalışmak**
---------------------------------

::

    git checkout feature/some-feature

Yeni branch üzerinde gereken düzenlemelerinizi yapınız. Daha sonra commit ile dosyalarınızı ekleyin.

::

   git add path/to/changed/file1    # commit edilecek her dosyayı
   git add path/to/another-file2    # bu şekilde ekleyin.
   git commit -m  "bu commit neden yapılıyor."      #lütfen fix, düzeltme, herşey gönderildi gibi saçma sapan açıklamalar yazmayın. ne yaptıysanız bunu düzgün bir şekilde ifade edin.


Her bir değişiklikte commit edin. Yüzlerce değişiklik yaptıktan sonra kocaman bir commit yapmayın!


Değişikliklerin geri gönderilmesi:
::

    git pull origin feature/some-featur     # make sure that push will be successful
                                            # by ensuring that local changes
                                            # are applicable on top of the
                                            # latest code; may result in conflicts

    git pull --rebase origin master         # rebase with master
    git push origin feature/some-feature	# pushes local changes to server, push may be
                                            # rejected if you haven't done previous step

---------------------------------
**Branch master ile merge etmek**
---------------------------------

::

    git checkout master         			    # prepare local master by
    git pull --rebase origin master	    	    # ensuring that your local master is up to date

    git checkout feature/some-feature
    git rebase master       				    # it ensure that following merge will be
                                                # successful AND that all merge conflicts are
                                                # handled in feature branch, not master
    git checkout master
    git merge --no-ff feature/some-feature		# use of --no-ff will ensure that merge
                                                # is visible in history graph as a
                                                # separate branch

    git push origin master		                # push changes to origin master( on the server )

EĞER NE YAPTIĞINIZIN FARKINDA DEĞİLSENİZ, BU KODLARDAN UZAK DURMANIZI ÖNERİRİZ.

::

    git branch -d feature/some-feature  		# delete local feature branch
    git branch -r -d feature/some-feature		# delete remote feature branch ( if needed, be aware to do this )

-------------
**Reverting**
-------------

::

    git checkout -- path/to/file	    # reverts changes in particular file
                                        # to last version in repo
    git reset --hard HEAD	        	# reverts ALL changes made in your working copy
                                        # handy if working copy is a mess
                                        # (e.g. failed merge, rm -rf *, etc)

---------
**Magit**
---------

Eğer emacs kullanıyorsanız, Magit kullanınız.

http://philjackson.github.com/magit/

Not: Magit sizin ihtiyacınızın olduğu kadar fonksiyoneldir, ama bazen Git'i komut satırından kullanmak akıllıcadır! (örn *git merge --no-ff* komutunu magitte kullanmak mümkün değildir.)

Okuyunuz:

http://philjackson.github.com/magit/magit.html

Eğer hala öğrenmek istiyorsanız:

http://daemianmack.com/magit-cheatsheet.html

--------------
**Code style**
--------------

Gereksiz boşluklara dikkat ediniz.

Boşlukları ve tabları karıştırmayınız.

80 karakterden daha uzun satırlar kullanmayınız.

Python kodları için harfiyen PEP8 kurallarını takip edin ve uygulayın.

---------------------------
**Writing Commit Messages**
---------------------------
Commitlerinizi böyle yapılandırınız:

Bir satırın özeti (50 karakterden az)

Uzun açıklamalar (72 karakterde sınırla)

-----------
**Summary**
-----------

* 50 karakterden daha az!

* Neler değişti.

* Zorunlu şimdiki zaman (fix, add, change)

- Fix bug 123
- Add 'foobar' komutu
- Change default timeout to 123

* No period
