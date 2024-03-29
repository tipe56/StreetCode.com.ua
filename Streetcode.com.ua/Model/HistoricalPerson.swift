//
//  HistoricalPerson.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import Foundation

struct HistoricalPerson: Identifiable {
    let id: Int
    let title: String
    let aliasTitle: String?
    let activityTitle: String
    let imageBundle: String
    let description: String
}


struct MockData {
    
    static let sampleHistoricalPerson =  HistoricalPerson(id: 0007,
                                      title: "Юрій Дадак",
                                      aliasTitle: "Руф",
                                      activityTitle: "Поет, підприємець, військовий",
                                      imageBundle: "Yurіj-Dadak",
                                      description: "Людина, сталева у своїх помислах та своєму тілі. Особистість, цілісна в багатьох проявах. В цивільному житті — викладач, доцент університету, ведучий. Засновник бренду одягу «Ґwear» та літературно-просвітницького проєкту «Дух нації». Волонтер та поет, по-лицарськи відданий служінню українській національній справі. Доброволець у буремні часи російсько-української війни. З тих, хто будував Україну — вільну, непокірну, самостійну. Ту, яка не здається і не відступає.")
    
    static let Persons = [
        HistoricalPerson(id: 2,
               title: "Роман Рáтушний",
               aliasTitle: "Сенека",
               activityTitle: "Активіст, журналіст, доброволець)",
               imageBundle: "Roman-Ratushnij",
               description: "Роман був з тих, кому не байдуже. Небайдуже до свого Протасового Яру та своєї України. Талановитий, щедрий, запальний. З нового покоління українців, народжених за незалежності, мета яких — краща Україна. Інтелектуал, активіст, громадський діяч. Бунтар проти несправедливості: корупції, свавілля. Невтомний як у боротьбі з незаконною забудовою, так і в захисті рідної країни від ворога. Учасник Помаранчевої революції 2004 року та Революції гідності 2013–2014-го. Воїн, який заради України пожертвував власним життям."),
        
        
        HistoricalPerson(id: 3,
               title: "Олекса (Олексій) Алмазов (Алмазів)",
               aliasTitle: nil,
               activityTitle: "Генерал-хорунжий Армії УНР",
               imageBundle: "Oleksіj-Almazov",
               description: "Кадровий артилерист, який став героєм Першої світової в лавах Російської імператорської армії та генералом в Армії УНР. Звитяжний уродженець Херсонщини. Учасник численних боїв, творець багатьох перемог у часи українських Визвольних змагань. Командир того самого зразкового «алмазівського» кінно-гірського гарматного дивізіону. Щирий побратим, який сповідував принцип «разом в перемогах, разом в труднощах». Благодійник, який із західної Волині намагався організувати допомогу жертвам Голодомору в центральній Україні."),
        
        
        HistoricalPerson(id: 7,
               title: "Юрій Дадак",
               aliasTitle: "Руф",
               activityTitle: "Поет, підприємець, військовий",
               imageBundle: "Yurіj-Dadak",
               description: "Людина, сталева у своїх помислах та своєму тілі. Особистість, цілісна в багатьох проявах. В цивільному житті — викладач, доцент університету, ведучий. Засновник бренду одягу «Ґwear» та літературно-просвітницького проєкту «Дух нації». Волонтер та поет, по-лицарськи відданий служінню українській національній справі. Доброволець у буремні часи російсько-української війни. З тих, хто будував Україну — вільну, непокірну, самостійну. Ту, яка не здається і не відступає."),
        
        HistoricalPerson(id: 4,
               title: "Юлія Здановська",
               aliasTitle: nil,
               activityTitle: "Математикиня, волонтерка",
               imageBundle: "Yulіya-Zdanovs'ka",
               description: "Молода математикиня, яка хотіла змінити українську систему освіти. Активна, яскрава, геніальна. Вона могла би так багато зробити для української науки. Але її вбила російська агресія. Юлія вела за собою людей і хотіла вдосконалити світ. На неї чекали світові виші й міжнародні компанії. Проте вона вирішила стати вчителькою для дітей у сільській громаді. З проєктом «Навчай для України / Teach For Ukraine» поїхала викладати математику та інформатику в школу на Дніпропетровщині. Прагнула свободи. Загинула за неї."),
        
        HistoricalPerson(id: 1,
               title: "Михайло Грушевський",
               aliasTitle: nil,
               activityTitle: "Історик, політик, Голова ЦР УНР",
               imageBundle: "Mihajlo-Grushevs'kij",
               description: "Батько української історії. Найпалкіший її дослідник. Понад дві тисячі праць. Монументальні 10 томів «Історії України-Руси», писані з перервами більше 30 років. Політик, творець живої історії як Голова Української Центральної Ради. Громадський діяч, академік з неабиякою працездатністю. Видатний організатор української науки. Автор промовистого кредо «Україна своє осягне», яке обстоював власними справами із вірою у майбутнє. Поборник ідеї самостійної та незалежної, для якого «іншої України» не було."),
        
        HistoricalPerson(id: 5,
               title: "Олександр Махов",
               aliasTitle: nil,
               activityTitle: "Журналіст, військовий",
               imageBundle: "Oleksandr-Mahov",
               description: "Талановитий воєнний кореспондент. Журналіст, для якого війна в Україні стала не просто репортажем, а особистою історією. Корінний луганець, який на собі відчув прихід «руского міра» роблячи репортажі з Донбасу про його жахіття. Коли збагнув, що настав час воювати, а не знімати, з солдата інформаційної війни став солдатом війни реальної. Пройшов найгарячіші її точки. В своєму останньому бою підірвав ворожий БМП. Боровся за те, щоб був вільним його рідний Луганськ, куди йому судилося повернутися лише в назві вулиці."),
        
        HistoricalPerson(id: 6,
               title: "Павло Лі",
               aliasTitle: nil,
               activityTitle: "Актор, ведучий, волонтер",
               imageBundle: "Pavlo-Lі",
               description: "Талановитий український актор. Митець, щиро закоханий у театр, кіно, телебачення, блогерство. З перших днів повномасштабного вторгнення Росії — волонтер в Ірпені на Київщині. Допомагав з евакуацією, координував збір і видачу гуманітарної допомоги. У важкий час був поруч із тими, хто цього потребував. Молода зірка, він став жертвою одного з тисяч воєнних злочинів росіян."),
        
        HistoricalPerson(id: 8,
               title: "Марія Примаченко",
               aliasTitle: nil,
               activityTitle: "Художниця, народна майстриня",
               imageBundle: "Marіya-Primachenko",
               description: "Геніальна художниця, яка творила у стилі наївного мистецтва. Авторка понад 3000 творів. Її яскравий дивосвіт химерних звірів та чудернацьких квітів упізнають одразу, а добро в її творчості перемагає зло. Лавреатка Державної премії України імені Тараса Шевченка. Мисткиня, чиї роботи розлетілися понад 30 країнами світу. Вона малювала всім на радість, щоб «люди жили, як квіти цвіли». Народна художниця України, чиї картини стали символом сміливості та мужності для українців.")
    ]
}
