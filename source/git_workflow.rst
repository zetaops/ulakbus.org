++++++++++++
Git İş-Akışı
++++++++++++

**HİÇBİR ZAMAN MASTER'A DOĞRUDAN PUSH ETMEYİNİZ, BRANCH YARATARAK BURADA DEĞİŞİKLİK YAPINIZ.**

* Lütfen TÜM dökümanı okuyunuz.

* Bağımlılıklarınızı sürekli iki kere kontrol ediniz.

* PATH değişkenlerini sürekli iki kere kontrol ediniz.

* Asla repoya büyük commitlerde bulunmayınız. Commitler için sürekli küçük iterasyonlarda bulununuz. Yoksa KAFAYI YERSİNİZ!

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

Git, çok güçlü bir sistemdir. Önemsemek gerekmektedir. Hiçbir değişiklik asla kaybolmaz (eğer daima commitliyorsanız). Bu yüzden kendinizi özgür hissedebilir, özelliklerini rahatlıkla deneyebilirsiniz.Git'i iyi anlamak için, git'in arkasında yatan kavramları okumak iyi bir fikirdir. GIT, SVN ile aynı değildir! İkisi farklı soyut düşünüşlerdir.

Genel olarak, git biraz ayrıntılıdır ve basit işlemleri gerçekleştirmek için bir çok komut gereklidir.Korkmayın! Git'i anladıktan sonra, herşeyin ne kadar iyi düşünüldüğünü ve nedenlerinin olduğunu göreceksiniz.

Svn hakkında tecrübe kazanmak istiyorsanız, bu bağlantıyı okuyabilirsiniz.

http://git-scm.com/course/svn.html

Eğer programcı değilseniz, okuyunuz

http://www.webdesignerdepot.com/2009/03/intro-to-git-for-web-designers/

Boş zamanınızda git'in arkasında yatan temel kavramları anlamak için http://www.eecs.harvard.edu/~cduan/technical/git/ bağlantısını okuyunuz. Bu sizin geleceğe yönelik git kullanımına yönelmenize imkan sağlayacaktır.


--------------
**Branch'ler**
--------------

* Master branch sadece görüntülenen ve test edilen kodları içermektedir.

* Her özellik ve yazılım hatası düzeltilmesi ayrı ayrı branchlerde geliştirilir.

* Yeni branchler son master branch temel alınarak başlatılmalıdır.

* Her branch master branch'i ile merge edilmeden önce her kullanıcı tarafından görüntülenmeli ve test edilmelidir.

* Her branch master branch'i ile merge edilmeden önce en son master branch temel alınmalıdır.

* Her branch “feature/345/chat” veya “bug/415/crashing_on_stop” şeklinde adlandırılmalıdır. Redmine issue adı ve kısa açıklaması issue adından gelmelidir.


Tüm branch'leri görüntülemek için:

::

    git branch -a


----------------
**Getting code**
----------------

 ``~/.ssh/config`` dosyasını oluşturun.

*host zopstest.zetaops.io*
*port 99*

Tüm sistemi meta repository kullanarak klonlamak için aşağıdaki komutu kullanınız.

::

    git clone gitosis@test.zetaops.io:zops-ubys.git


-------------------------
**Basic day-to-day flow**
-------------------------

Eğer local ve uzak repoların durumunu anlamakta zorluk çekiyorsanız:

::

    git remote update
    gitk --all		            # yes, it’s not a typo - it’s a tool called gitK
    tig                         #you can also use tig from console. apt-get install tig, you can use SourceTree for mac if you are Mac coder

yeni branch yaratmak için:

::

    cd path/to/project
    git checkout master
    git pull --rebase
    git branch (feature/bug)/some-new-feature/bug

Programlamadan önceki hazırlık:

::

    cd path/to/project

    git checkout master
    git pull --rebase			# use this if your local code has no local changes, which has not been pushed to server
    git checkout feature/some-feature
    git rebase master

---------------------------
**Work on feature/bug fix**
---------------------------

::

    git checkout feature/some-feature

*Sourse File'ınızı düzenleyiniz ve ardından commitleyiniz.*

::

    git add path/to/changed/file1	# you need to mark each file you want to commit
    git add path/to/another-file2	# with this command

    git commit	        			# opens editor were you can write commit message, OR
    git commit -m "commit message"	# shortcut for one line commit messages

Düzenleme ve commitleme döngüsünü gerektiği kadar tekrar ediniz, hazırlayınız ve servise push ediniz.




::

    git pull origin feature/some-feature	# make sure that push will be successful
                                            # by ensuring that local changes
                                            # are applicable on top of the
                                            # latest code; may result in conflicts

     git pull --rebase origin master        # rebase with master
     git push origin feature/some-feature	# pushes local changes to server, push may be
                                            # rejected if you haven't done previous step

------------------------------
**Merging branch into master**
------------------------------

::

    git checkout master         			# prepare local master by
    git pull --rebase origin master	    	# ensuring that your local master is up to date

    git checkout feature/some-feature
    git rebase master       				# it ensure that following merge will be 								# successful AND that all merge conflicts are
                                            # handled in feature branch, not master
    git checkout master
    git merge --no-ff feature/some-feature		# use of --no-ff will ensure that merge
                                                # is visible in history graph as a
                                                # separate branch

    git push origin master		            # push changes to origin master( on the server )


EĞER NE YAPTIĞINIZIN FARKINDA DEĞİLSENİZ, BU KODLARDAN UZAK DURMANIZI ÖNERİRİZ.


::

    git branch -d feature/some-feature  		# delete local feature branch
    git branch -r -d feature/some-feature		# delete remote feature branch ( if needed, be aware to do this )

-------------
**Reverting**
-------------

::  git checkout -- path/to/file	    # reverts changes in particular file
                                        # to last version in repo
    git reset --hard HEAD	        	# reverts ALL changes made in your working copy
                                        # handy if working copy is a mess
                                        # (e.g. failed merge, rm -rf *, etc)
---------
**Magit**
---------

Eğer emacs kullanıyorsanız, Magit kullanınız.

http://philjackson.github.com/magit/

Not: Magit sizin ihtiyacınızın olduğu kadar fonksiyoneldir, ama bazen Git'i komut satırından kullanmak akıllıca olur! (örn *git merge --no-ff* komutunu magitte kullanmak mümkün değildir.)

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
