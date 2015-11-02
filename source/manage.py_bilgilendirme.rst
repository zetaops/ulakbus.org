+++++++++++++++++++++++
Manage.py Nasıl Çalışır
+++++++++++++++++++++++

Belge, sisteme kaydı yapılan bir kullanıcının kendi hesabına ulaşma bilgilerini içermektedir. Başlıca parametreler ve açıklamaları şu şekildedir:

*username:* "Login username" ekrana gelir. Kullanıcıdan kendi kullanım adını girmesi istenir. Kullanıcı adı output olarak görünür.

*password:* "Login password" ekrana gelir. Kullanıcıdan kendisine ait şifresini girmesi istenir. Kullanıcı şifresini output ekranında görür.

*abstract_role:* "Name of the AbstractRole" ekrana gelir. Kullanıcının sistemdeki rolünü sorgular.

*super:* "This is a super user" ekranda görünür. Bu, özel yetkisi olan kullanıcılar içindir.

*permission_query:* Giriş yapan kişinin sistemde izni olup olmadığını sorgular. Eğer giriş yapmak isteyen kişi kayıtlı değilse login ekranı hata verir.

*help:* Kullanıcıya yardımcı olabilecek ekranı output olarak verir.