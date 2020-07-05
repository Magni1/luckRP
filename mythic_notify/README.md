# Mythic Notifications
Basit bir bildirim sistemi.

![Örnek Resim](https://i.imgur.com/shT1XWc.png)

## Kullanımı
Client-Side için en basitinden Alert triggerlama

```lua
exports['mythic_notify']:SendAlert('type', 'message')
```

### Bildirim Stilleri
* Bilgilendirme - 'inform'
* Hata - 'error'
* Başarılı - 'success'

### Client-Side Fonksiyonları
* SendAlert ( type, text, length, style ) | Ekranda basit bir alert gösterir, süresi ayarlanmazsa varsayılan olarak 2500 milisaniye kalır. Style ise opsiyoneldir ve isterseniz değiştirebilirsiniz.
* SendUniqueAlert ( id, type, text, length, style ) | Ekranda birdan fazla alert göstermek yerine süresini sıfırlar. Ekranda ki bildirim spamına engel olabilirsiniz.
* PersistentAlert ( action, id, type, text, style ) | End action ile tekrar triggerlanana kadar ekranda kalır. Süresi yoktur ve sonsuzdur.

### Client Events (Bildirimi Server Side üzerinden Triggerlama)
* mythic_notify:client:SendAlert OBJECT { type, text, duration } - Duration verilmez ise varsayılan olarak 2500 milisaniye ekranda kalır.
* mythic_notify:client:PersistentAlert OBJECT { action, id, type, text } - Note: End actionını kullanacaksanız Type ve Text kısımlarını boş bırakmalısınız.

### Persistent Bildirim aksiyonları -
* start - ( id, type, text, style ) - Yeni bir bildirim oluşturur veya aynı IDye sahip bir bildirim varsa süresini sıfırlar.
* end - ( id ) - Persistent bildirimini bitirir.

> ID hakkında küçük bir not: Birdan fazla scirpt aynı IDyi kullanabilir, bunun önüne geçmek için scriptlerinize daha önce verilmemiş IDler verin.

### Özelleştirilmiş Stilli Bildirimler -
Bildirimlerinizi özelleştirme imkanınıza sahipsiniz, 

#### Örnekler -
##### Client:
```LUA
exports['mythic_notify']:SendAlert('inform', 'Hype! Custom Styling!', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
```

##### Server:
```LUA
TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Hype! Custom Styling!', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
```

> Not: Eğer length parametresini girmezseniz varsayılan olarak ekranda 2500 milsaniye durur.

##### Sonuç:
![Custom Styling](https://i.imgur.com/FClWCqm.png)
