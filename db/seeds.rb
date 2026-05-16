Theme.delete_all
Image.delete_all


t1 = Theme.create(name: "Природа", qty_items: 5)

Image.create(name: "Лес", file: "1.jpg", theme_id: t1.id)
Image.create(name: "Река", file: "2.jpg", theme_id: t1.id)
Image.create(name: "Ле", file: "3.jpg", theme_id: t1.id)
Image.create(name: "Рка", file: "4.jpg", theme_id: t1.id)
Image.create(name: "ес", file: "5.jpg", theme_id: t1.id)

t2 = Theme.create(name: "Город", qty_items: 5)
Image.create(name: "Реа", file: "6.jpg", theme_id: t1.id)
Image.create(name: "Небоскреб", file: "7.jpg", theme_id: t2.id)
Image.create(name: "Метро", file: "8.jpg", theme_id: t2.id)
Image.create(name: "Л", file: "9.jpg", theme_id: t1.id)
Image.create(name: "ка", file: "default.jpg", theme_id: t1.id)


puts "База данных успешно наполнена!"