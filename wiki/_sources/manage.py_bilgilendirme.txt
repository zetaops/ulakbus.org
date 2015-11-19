+++++++++++++++++++++++
Manage.py Nasıl Çalışır
+++++++++++++++++++++++

Belge, sisteme kaydı yapılan bir kullanıcının kendi hesabına ulaşma bilgilerini içermektedir. Başlıca parametreler ve açıklamaları şu şekildedir:

**username:** "Login username" ekrana gelir. Kullanıcıdan kendi kullanım adını girmesi istenir. Kullanıcı adı output olarak görünür.

**password:** "Login password" ekrana gelir. Kullanıcıdan kendisine ait şifresini girmesi istenir. Kullanıcı şifresini output ekranında görür.

**abstract_role:** "Name of the AbstractRole" ekrana gelir. Kullanıcının sistemdeki rolünü sorgular.

**super:** "This is a super user" ekranda görünür. Bu, özel yetkisi olan kullanıcılar içindir.

**permission_query:** Giriş yapan kişinin sistemde izni olup olmadığını sorgular. Eğer giriş yapmak isteyen kişi kayıtlı değilse login ekranı hata verir.

**help:** Kullanıcıya yardımcı olabilecek ekranı output olarak verir.

Eğer sistemde girilen kullanıcı adı sistemde kayıtlı değilse, sistem yeni bir kullanıcı yaratır.
Yeni kullanıcının bilgileri; kullanıcı adı, şifresi, atanan rol, özel yetkiler ve izin verilen işlemler şeklinde sisteme kaydedilir.

Sistemde 'load fixtures' adında datalar tutulmaktadır.
Bu dataların içeriği, eldeki json dosyası veya dosyalarında biriken verilerin yenilenmiş versiyonlarını ve dosyaların path'lerini kapsamaktadır.

**path:** Bu parametre bize elimizdeki json dosyalarının depolandığı yeri 'Load fixture file or directory' şeklinde output olarak verir.

- json dosyalarının path'lerini alabilmek için ilk önce import etmemiz gerekmektedir.

json dosyalarını bulundukları path içinde çalıştırdığımızda sistem o dosyaları depolar.
Dosya depolandığında
::

 "%s: %s stored.."

uyarısı ekranda görülür.

Depolanan dosyayı

::

 "please validate your json file: %s"

komutunun ekrana gelmesiyle onaylamamız gerekmektedir. Aksi takdirde dosya sisteme kaydedilmez ve sonraki işlemler için arattığımızda sistemde bulunamaz.

Sistemde bulunmayan dosya

::

 "file not found: %s"

şeklinde uyarı verir.