++++++++++++++++++++++++++++++++++++
Geliştirme Ortamı Kurulumu(Frontend)
++++++++++++++++++++++++++++++++++++

============================
**Geliştirmeye Hazır Olun!**
============================

1. ``git clone git@github.com:zetaops/ulakbus-ui.git`` reposunu indirin.

    *git kullanımını bilmiyorsanız, aşağıdaki bağlantılardan yardım alabilirsiniz.*

    - https://git-scm.com/doc
    - https://try.github.io/levels/1/challenges/1

2. Nodejs'yi indirin ve kurun.

    - https://nodejs.org/download/

3. Bower'ı kurunuz ``npm install bower``

4. *bower.json* içinde listelenen paketleri yüklemek için ``bower install`` komutunu çalıştırınız.

5. *package.json* içinde listelenen paketleri yüklemek için ``npm install`` komutunu çalıştırınız.

6. Tüm paketlerin yüklenmesininin ardından aşağıdaki komut sayesinde *http server* 'ı çalıştırabilirsiniz.

    ``npm start``

*Uygulamayı sunmak için başka http server kullanabilirsiniz.*

======================
**Geliştirme Döngüsü**
======================

Şu an gerekli repo'ya sahipsiniz, npm ve bower kurulumunu gerçekleştirdiniz ve geliştirmeye başladınız.


Güçlü programlama teknikleri için, http://www.extremeprogramming.org/introduction.html sitesinde gösterilen geliştirme döngülerini takip etmenizi öneririz.

.. image:: _static/planning_feedback_loops.png
   :scale: 100 %
   :align: center


Kodlarken aşağıdaki adımları izleyiniz.

* Yeni bir tane branch oluşturun. Örnek olarak(e.g: search_func)

* ``git checkout <branch>``

* ``git pull --rebase``

* Verilen görev için bir branch oluşturup master branch’i rebase ettikten sonra, kodunuzu yazabilirsiniz.

* Kodunuzu denemek için testler yazınız.

* Testlerinizi çalıştırınız.

* Push yapmadan önce tekrardan master branch'i rebase edin ``git pull --rebase``

* Şimdi push yapabilirsiniz ``git push origin <branch>``

==========
**Deneme**
==========

~/_test.js dosyaları Jasmine içindeki birim test dosyalarıdır , çalıştırmak için aşağıdaki komutları çalıştırabilirsiniz:

::

    npm test

Bu komut testleri bulacak ve sonucu ekrana yazdıracak.

e2e-tests klasörü altındaki e2e-testlerini çalıştırmak için protractor kullanınız. Aşağıdaki komutu çalıştırabilirsiniz.

::

    protractor e2e-tests/protractor.conf.js

==============
**Prensipler**
==============

--------
**Git:**
--------

* Her zaman branchler ile çalışır.

* **Hiçbir zaman MASTER BRANCH'e karışmayınız(müdahele etmeyiniz)!!**

* Küçük değişiklikleri commitleyiniz.

--------
**Kod:**
--------

* DRY - don't repeat yourself(kendini tekrarlama)!!! Bunu okuyunuz https://en.wikipedia.org/wiki/Don%27t_repeat_yourself

* Kodunuzu yazarken açıklamalarda bulununuz.

* Kodunuz düzenli ve açık olsun.

* Değişken isimleri ve nesneleri açıklayıcı şekilde olmalıdır.

---------
**Test:**
---------

Daha etkili testler yazmak için http://www.softwaretestinghelp.com/how-to-write-effective-test-cases-test-cases-procedures-and-definitions/ sitesinden yardım alabilirsiniz.

Testler olabildiğince kodunuzu kapsamalı.

------------------------
**Okunması Gerekenler:**
------------------------

* https://google-styleguide.googlecode.com/svn/trunk/angularjs-google-style.html

* https://github.com/angular/angular.js/wiki/Best-Practices

* https://angular.github.io/protractor/#/tutorial

* https://docs.angularjs.org/guide

* http://en.wikipedia.org/wiki/Iterative_and_incremental_development