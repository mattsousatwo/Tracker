//
//  BreedList.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/8/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation


struct BreedList {
    
    /// Container of all dog breeds - to be filed in coredata
    lazy var dogBreedsA: [BreedName] = [affenpinscher, afganHound, airedaleTerrier, akbash, akita, alaskanKleeKai, alaskanMalamute, americanBullDog, americanCockerSpaniel, americanEskimoDog, americanFoxhound, americanHairlessTerrier, americanStaffordshireTerrier, americanWaterSpaniel, anatolianShepherd, australianCattleDog, australianKelpie, australianShepherd, australianTerrier,
        
        basenji, bassetHound, beagle, beardedCollie, bedlingtonTerrier, belgianShepherdManlionis, bedlingtonShepherdSheepdog, belgianShepherdTervuren, belgianShepherdDog, berneseMountainDog,
    bichonFrise, blackAndTanCoonhound, blackRussianTerrier, bloodhound, bluetickCoonhound, boerboel, borderCollie, borderTerrier, borzoi, bostonTerrier, bouvierDesFlandres, boxer, boykinSpaniel, briard, brittanySpaniel, brusselsGriffon, bullTerrier, bullmastiff,
    
        cairnTerrier, canaanDog, caneCorso, cardiganWelshCorgi, carolinaDog, caucasianShepherdDog, cavalierKingCharlesSpaniel, chesapeakeBayRetriever, chihuahua, chineseCrestedDog, chinook, chowChow, cirnecoDellEtna, clumberSpaniel, collie, cotonDeTulear, curlyCoatedRetriever,
        
        dachshund, dalmation, dandieDinmontTerrier, dobermanPinscher, dogoArgentino, dogueDeBordeaux, dutchShepherd,
        
        englishBulldog, englishCockerSpaniel, englishCoonhound, englishFoxhound, englishPointer, englishSetter, englishShepherd, englishSpringerSpaniel, englishToySpaniel, entlebucherMountainDog,
        
        fieldSpaniel, finnishLapphund, finnishSpitz, flatCoatedRetriever, frenchBulldog,
        
        germanPinscher, germanShepherdDog, germanShorthairedPointer, germanSpitz, germanWirehairedPointer, giantSchnauzer, goldenRetriever, goldendoodle, gordonSetter, greatDane, greatPyrenees, greaterSwissMountainDog, greyhound,
        
        hamiltonstovare, harrier, havanese, hovawart,
        
        ibizanHound, icelandicSheepdog, irishSetter, irishTerrier, irishWaterSpaniel, irishWolfhound, italianGreyhound,
        
        jackRusselTerrier, japaneseChin, jindo,
        
        kaiKen, karelianBearDog, keeshond, kerryBlueTerrier, kishu, komondor, kuvasz,
        
        labradorRetriever, lakelandTerrier, lancashireHeeler, largeMunsterlander, leonberger, lhasaApso, louisianaCatahoulaLeopardDog, lowchen, lurcher,
        
        maltese, manchesterTerrier, maremmaSheepdog, mastiff, miniatureBullTerrier, miniatureDachshund, miniaturePinscher, miniaturePoodle, miniatureSchnauzer, mountainCur,
        
        neapolitanMastiff, newfoundlandDog, norfolkTerrier, norwegianBuhund, norwegianElkhound, norwegianLundehund, norwichTerrier, novaScotiaDuckTollingRetriever,
        
        unknown,
        
        oldEnglishSheepdog, otterhound,
        
        papillon, parsonRussellTerrier, patterdaleTerrier, pekingese, pembrokeWelshCorgi, perroDePresaCanarioDog, peruvianIncaOrchid, pharaohHound, plottHound, polishLowlandSheepdog, pomeranian, poodle, portuguesePodengo, portugueseWaterDog, pug, puli, pumi, pyreneanShepherd,
        
        ratTerrier, redboneCoonhound, rhodesianRidgeback, rottweiler,
        
        saintBernard, saluki, samoyed, sarplaninac, schipperke, schnauzer, scottishDeerhound, scottishTerrier, sealyhamTerrier, sharPei, shetlandSheepdogSheltie, shibaInu, shihTzu, shollie, sibearianHusky, silkyTerrier, skyeTerrier, sloughi, smallMunsterlander, smoothFoxTerrier, spanishWaterDog, spinoneItaliano, staffordshireBullTerrier, sussexSpaniel, swedishVallhund,
        
        thaiRidgeback, tibetanMastiff, tibetanSpaniel, tibetanTerrier, tosa, toyFoxTerrier, toyManchesterTerrier, treeingTennesseeBrindle, treeingWalkerCoonhound,
        
        vizsla, weimaraner, welshSpringerSpaniel, welshTerrier, westHighlandWhiteTerrierWestie, wheatenTerrier, whippet, wireFoxTerrier, wirehairedPointingGriffon, xoloitzcuintiliMexicanHairless, yorkshireTerrier
    ]
    
    
    // MARK: A -
    lazy var affenpinscher = BreedName("Affenpinscher")
    lazy var afganHound = BreedName("Afgan Hound")
    lazy var airedaleTerrier = BreedName("Airedale Terrier")
    lazy var akbash = BreedName("Akbash")
    lazy var akita = BreedName("Akita")
    lazy var alaskanKleeKai = BreedName("Alaskan Klee Kai")
    lazy var alaskanMalamute = BreedName("Alaskan Malamute")
    lazy var americanBullDog = BreedName("American Bulldog")
    lazy var americanCockerSpaniel = BreedName("American Cocker Spaniel")
    lazy var americanEskimoDog = BreedName("American Eskimo Dog")
    lazy var americanFoxhound = BreedName("American Foxhound")
    lazy var americanHairlessTerrier = BreedName("American Hairless Terrier")
    lazy var americanStaffordshireTerrier = BreedName("American Staffordshire Terrier")
    lazy var americanWaterSpaniel = BreedName("American Water Spaniel")
    lazy var anatolianShepherd = BreedName("Anatolian Shepherd")
    lazy var australianCattleDog = BreedName("Australian Cattle Dog")
    lazy var australianKelpie = BreedName("Australian Kelpie")
    lazy var australianShepherd = BreedName("Australian Shepherd")
    lazy var australianTerrier = BreedName("Australian Terrier")
    
    
    
    // MARK: B -
    lazy var basenji = BreedName("Basenji")
    lazy var bassetHound = BreedName("Basset Hound")
    lazy var beagle = BreedName("Beagle")
    lazy var beardedCollie = BreedName("Bearded Collie")
    lazy var beauceron = BreedName("Beauceron")
    lazy var bedlingtonTerrier = BreedName("Bedlington Terrier")
    lazy var belgianShepherdManlionis = BreedName("Belgian Shepherd / Manlinois")
    lazy var bedlingtonShepherdSheepdog = BreedName("Bedlington Shepherd / Sheepdog")
    lazy var belgianShepherdTervuren = BreedName("Belgian Shepherd / Tervuren")
    lazy var belgianShepherdDog = BreedName("Belgian Shepherd Dog")
    lazy var berneseMountainDog = BreedName("Bernese Mountain Dog")
    lazy var bichonFrise = BreedName("Bichon Frise")
    lazy var blackAndTanCoonhound = BreedName("Black & Tan Coonhound")
    lazy var blackRussianTerrier = BreedName("Black Russian Terrier")
    lazy var bloodhound = BreedName("Bloodhound")
    lazy var bluetickCoonhound = BreedName("Bluetick Coonhound")
    lazy var boerboel = BreedName("Boerboel")
    lazy var borderCollie = BreedName("Border Collie")
    lazy var borderTerrier = BreedName("Border Terrier")
    lazy var borzoi = BreedName("Borzoi")
    lazy var bostonTerrier = BreedName("Boston Terrier")
    lazy var bouvierDesFlandres = BreedName("Bouvier des Flandres")
    lazy var boxer = BreedName("Boxer")
    lazy var boykinSpaniel = BreedName("Boykin Spaniel")
    lazy var briard = BreedName("Briard")
    lazy var brittanySpaniel = BreedName("Brittany Spaniel")
    lazy var brusselsGriffon = BreedName("Brussels Griffon")
    lazy var bullTerrier = BreedName("Bull Terrier")
    lazy var bullmastiff = BreedName("Bullmastiff")
    // MARK: C -
    lazy var cairnTerrier = BreedName("Cairn Terrier")
    lazy var canaanDog = BreedName("Canaan Dog")
    lazy var caneCorso = BreedName("Cane Corso")
    lazy var cardiganWelshCorgi = BreedName("cardigan Welsh Corgi")
    lazy var carolinaDog = BreedName("Carolina Dog")
    lazy var caucasianShepherdDog = BreedName("Caucasian Shepherd Dog")
    lazy var cavalierKingCharlesSpaniel = BreedName("Cavalier King Charles Spaniel")
    lazy var chesapeakeBayRetriever = BreedName("Chesapeake Bay Retriever")
    lazy var chihuahua = BreedName("Chihuahua")
    lazy var chineseCrestedDog = BreedName("Chinese Crested Dog")
    lazy var chinook = BreedName("Chinook")
    lazy var chowChow = BreedName("Chow Chow")
    lazy var cirnecoDellEtna = BreedName("Cirneco dell'Etna")
    lazy var clumberSpaniel = BreedName("Clumber Spaniel")
    lazy var collie = BreedName("Collie")
    lazy var cotonDeTulear = BreedName("Coton de Tulear")
    lazy var curlyCoatedRetriever = BreedName("Curly Coated Retriever")
    // MARK: D-
    lazy var dachshund = BreedName("Dachshund")
    lazy var dalmation = BreedName("Dalmation")
    lazy var dandieDinmontTerrier = BreedName("Dandie Dinmont Terrier")
    lazy var dobermanPinscher = BreedName("Doberman Pinscher")
    lazy var dogoArgentino = BreedName("Dogo Argentino")
    lazy var dogueDeBordeaux = BreedName("Dogue de Bordeaux")
    lazy var dutchShepherd = BreedName("Dutch Shepherd")
    // MARK: E -
    lazy var englishBulldog = BreedName("English Bulldog")
    lazy var englishCockerSpaniel = BreedName("English Cocker Spaniel")
    lazy var englishCoonhound = BreedName("English Coonhound")
    lazy var englishFoxhound = BreedName("English Foxhound")
    lazy var englishPointer = BreedName("English Pointer")
    lazy var englishSetter = BreedName("English Setter")
    lazy var englishShepherd = BreedName("English Shepherd")
    lazy var englishSpringerSpaniel = BreedName("English Springer Spaniel")
    lazy var englishToySpaniel = BreedName("English Toy Spaniel")
    lazy var entlebucherMountainDog = BreedName("Entlebucher Mountain Dog")
    // MARK: F -
    lazy var fieldSpaniel = BreedName("Field Spaniel")
    lazy var finnishLapphund = BreedName("Finnish Lapphund")
    lazy var finnishSpitz = BreedName("Finnish Spitz")
    lazy var flatCoatedRetriever = BreedName("Flat Coated Retriever")
    lazy var frenchBulldog = BreedName("French Bulldog")
    // MARK: G -
    lazy var germanPinscher = BreedName("German Pinscher")
    lazy var germanShepherdDog = BreedName("German Shepherd Dog")
    lazy var germanShorthairedPointer = BreedName("German Shorthaired Pointer")
    lazy var germanSpitz = BreedName("German Spitz")
    lazy var germanWirehairedPointer = BreedName("German Wirehaired Pointer")
    lazy var giantSchnauzer = BreedName("Giant Schnauzer")
    lazy var glenOfImaalTerrier = BreedName("Glen of Imaal Terrier")
    lazy var goldenRetriever = BreedName("Golden Retriever")
    lazy var goldendoodle = BreedName("Goldendoodle")
    lazy var gordonSetter = BreedName("Gordon Setter")
    lazy var greatDane = BreedName("Great Dane")
    lazy var greatPyrenees = BreedName("Great Pyrenees")
    lazy var greaterSwissMountainDog = BreedName("Greater Swiss Mountain Dog")
    lazy var greyhound = BreedName("Greyhound")
    // MARK: H -
    lazy var hamiltonstovare = BreedName("Hamiltonstovare")
    lazy var harrier = BreedName("Harrier")
    lazy var havanese = BreedName("Havanese")
    lazy var hovawart = BreedName("Hovawart")
    // MARK: I -
    lazy var ibizanHound = BreedName("Ibizan Hound")
    lazy var icelandicSheepdog = BreedName("Icelandic Sheepdog")
    lazy var irishSetter = BreedName("Irish Setter")
    lazy var irishTerrier = BreedName("Irish Terrier")
    lazy var irishWaterSpaniel = BreedName("Irish Water Spaniel")
    lazy var irishWolfhound = BreedName("Irish Wolfhound")
    lazy var italianGreyhound = BreedName("Italian Greyhound")
    // MARK: J -
    lazy var jackRusselTerrier = BreedName("Jack Russel Terrier")
    lazy var japaneseChin = BreedName("Japanese Chin")
    lazy var jindo = BreedName("Jindo")
    // MARK: K -
    lazy var kaiKen = BreedName("Kai Ken")
    lazy var karelianBearDog = BreedName("Karelian Bear Dog")
    lazy var keeshond = BreedName("Keeshond")
    lazy var kerryBlueTerrier = BreedName("Kerry Blue Terrier")
    lazy var kishu = BreedName("Kishu")
    lazy var komondor = BreedName("Komondor")
    lazy var kuvasz = BreedName("Kuvasz")
    // MARK: L -
    lazy var labradorRetriever = BreedName("Labrador Retriever")
    lazy var lakelandTerrier = BreedName("Lakeland Terrier")
    lazy var lancashireHeeler = BreedName("Lancashire Heeler")
    lazy var largeMunsterlander = BreedName("Large Munsterlander")
    lazy var leonberger = BreedName("Leonberger")
    lazy var lhasaApso = BreedName("Lhasa Apso")
    lazy var louisianaCatahoulaLeopardDog = BreedName("Louisiana Catahoula Leopard Dog")
    lazy var lowchen = BreedName("Lowchen")
    lazy var lurcher = BreedName("Lurcher")
    // MARK: M -
    lazy var maltese = BreedName("Maltese")
    lazy var manchesterTerrier = BreedName("Manchester Terrier")
    lazy var maremmaSheepdog = BreedName("Maremma Sheepdog")
    lazy var mastiff = BreedName("Mastiff")
    lazy var miniatureBullTerrier = BreedName("Miniature Bull Terrier")
    lazy var miniatureDachshund = BreedName("Miniature Dachshund")
    lazy var miniaturePinscher = BreedName("Miniature Pinscher")
    lazy var miniaturePoodle = BreedName("Miniature Poodle")
    lazy var miniatureSchnauzer = BreedName("Miniature Schnauzer")
    lazy var mountainCur = BreedName("Mountain Cur")
    // MARK: N -
    lazy var neapolitanMastiff = BreedName("Neapolitan Mastiff")
    lazy var newfoundlandDog = BreedName("Newdoundland Dog")
    lazy var norfolkTerrier = BreedName("Norfolk Terrier")
    lazy var norwegianBuhund = BreedName("Norwegian Buhund")
    lazy var norwegianElkhound = BreedName("Norwegian Elkhound")
    lazy var norwegianLundehund = BreedName("Norwegian Lundehund")
    lazy var norwichTerrier = BreedName("Norwich Terrier")
    lazy var novaScotiaDuckTollingRetriever = BreedName("Nova Scotia Duck Tolling Retriever")
    // MARK: O -
    lazy var unknown = BreedName("Unknown")
    lazy var oldEnglishSheepdog = BreedName("Old English Sheepdog")
    lazy var otterhound = BreedName("Otterhound")
    // MARK: P -
    lazy var papillon = BreedName("Papillon")
    lazy var parsonRussellTerrier = BreedName("Parson Russell Terrier")
    lazy var patterdaleTerrier = BreedName("Patterdale Terrier")
    lazy var pekingese = BreedName("Pekingese")
    lazy var pembrokeWelshCorgi = BreedName("Pembroke Welsh Corgi")
    lazy var perroDePresaCanarioDog = BreedName("Perro de Presa Canario Dog")
    lazy var peruvianIncaOrchid = BreedName("Petit Basset Griddon Vendeen")
    lazy var pharaohHound = BreedName("Pharaoh Hound")
    lazy var plottHound = BreedName("Plott Hound")
    lazy var polishLowlandSheepdog = BreedName("Polish Lowland Sheepdog")
    lazy var pomeranian = BreedName("Pomeranian")
    lazy var poodle = BreedName("Poodle")
    lazy var portuguesePodengo = BreedName("Portuguese Podengo")
    lazy var portugueseWaterDog = BreedName("Portuguese Water Dog")
    lazy var pug = BreedName("Pug")
    lazy var puli = BreedName("Puli")
    lazy var pumi = BreedName("Pumi")
    lazy var pyreneanShepherd = BreedName("Pyrenean Shepherd")
    // MARK: R -
    lazy var ratTerrier = BreedName("Rat Terrier")
    lazy var redboneCoonhound = BreedName("Redbone Coonhound")
    lazy var rhodesianRidgeback = BreedName("Rhodesian Ridgeback")
    lazy var rottweiler = BreedName("Rottweiler")
    // MARK: S -
    lazy var saintBernard = BreedName("Saint Bernard")
    lazy var saluki = BreedName("Saluki")
    lazy var samoyed = BreedName("Samoyed")
    lazy var sarplaninac = BreedName("Sarplaninac")
    lazy var schipperke = BreedName("Schipperke")
    lazy var schnauzer = BreedName("Schnauzer")
    lazy var scottishDeerhound = BreedName("Scottish Deerhound")
    lazy var scottishTerrier = BreedName("Scottish Terrier")
    lazy var sealyhamTerrier = BreedName("Sealyham Terrier")
    lazy var sharPei = BreedName("Shar Pei")
    lazy var shetlandSheepdogSheltie = BreedName("Shetland Sheepdog / Sheltie")
    lazy var shibaInu = BreedName("Shiba Inu")
    lazy var shihTzu = BreedName("Shih Tzu")
    lazy var shollie = BreedName("Shollie")
    lazy var sibearianHusky = BreedName("Siberian Husky")
    lazy var silkyTerrier = BreedName("Silly Terrier")
    lazy var skyeTerrier = BreedName("Skye Terrier")
    lazy var sloughi = BreedName("Sloughi")
    lazy var smallMunsterlander = BreedName("Small Munsterlander")
    lazy var smoothFoxTerrier = BreedName("Smooth Fox Terrier")
    lazy var spanishWaterDog = BreedName("Spanish Water Dog")
    lazy var spinoneItaliano = BreedName("Spinone Italiano")
    lazy var staffordshireBullTerrier = BreedName("Staffordshire Bull Terrier")
    lazy var sussexSpaniel = BreedName("Sussex Spaniel")
    lazy var swedishVallhund = BreedName("Swedish Vallhund")
    // MARK: T -
    lazy var thaiRidgeback = BreedName("Thai Ridgeback")
    lazy var tibetanMastiff = BreedName("Tibetan Mastiff")
    lazy var tibetanSpaniel = BreedName("Tibetan Spaniel")
    lazy var tibetanTerrier = BreedName("Tibetan Terrier")
    lazy var tosa = BreedName("Tosa")
    lazy var toyFoxTerrier = BreedName("Toy Fox Terrier")
    lazy var toyManchesterTerrier = BreedName("Toy Manchester Terrier")
    lazy var treeingTennesseeBrindle = BreedName("Treeing Tennessee Brindle")
    lazy var treeingWalkerCoonhound = BreedName("Treeing Walker Coonhound")
    // MARK: V -
    lazy var vizsla = BreedName("Vizsla")
    // MARK: W -
    lazy var weimaraner = BreedName("Weimaraner")
    lazy var welshSpringerSpaniel = BreedName("Welsh Springer Spaniel")
    lazy var welshTerrier = BreedName("Welsh Terrier")
    lazy var westHighlandWhiteTerrierWestie = BreedName("West Highland White Terrier (Westie)")
    lazy var wheatenTerrier = BreedName("Wheaten Terrier")
    lazy var whippet = BreedName("Whippet")
    lazy var wireFoxTerrier = BreedName("Wire Fox Terrier")
    lazy var wirehairedPointingGriffon = BreedName("Wirehaired Pointing Griffon")
    // MARK: X -
    lazy var xoloitzcuintiliMexicanHairless = BreedName("Xoloitzcuintli (Mexican Hairless)")
    // MARK: Y -
    lazy var yorkshireTerrier = BreedName("Yorkshire Terrier")
    
        
}
