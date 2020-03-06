//
//  sharedData.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/24.
//  Copyright © 2019 OnOuchs. All rights reserved.
//

import UIKit
import JSSAlertView
import SwiftMessages
import Stripe

class sharedData: NSObject {

    public static var userData : UserData!
    
    public static var initialData : InitialData!
    
}

class apiNames : NSObject {
    public static let signUpUrl = "http://yardhouse.sociallead.ca/api/auth/signup"
    public static let logInUrl = "http://yardhouse.sociallead.ca/api/auth/login"
    public static let initialDataUrl = "http://yardhouse.sociallead.ca/api/getInitialData"
    public static let getRentalAvailableTime = "http://yardhouse.sociallead.ca/api/getRentalAvailableTime"
    public static let rentalCheckout = "http://yardhouse.sociallead.ca/api/rental/checkout"
    public static let lessonCheckout = "http://yardhouse.sociallead.ca/api/lesson/checkout"
    public static let getAvailableLessonCoaches = "http://yardhouse.sociallead.ca/api/lesson/getAvailableLessonCoaches"
    public static let getAvailableLessonTimes = "http://yardhouse.sociallead.ca/api/lesson/getAvailableLessonTimes"
    public static let saveDefaultCard = "http://yardhouse.sociallead.ca/api/user/saveDefaultCard"
    public static let saveCard = "http://yardhouse.sociallead.ca/api/user/saveCard"
    public static let updateAccount = "http://yardhouse.sociallead.ca/api/user/updateAccount"
    public static let campCheckout = "http://yardhouse.sociallead.ca/api/camp/checkout"
    public static let membershipCheckout = "http://yardhouse.sociallead.ca/api/membership/checkout"
    
}

class webClient : NSObject {
    
    func sendHTTPRequest( parameters : [String : Any],url: String , completionHandler: @escaping (_ error: String?, _ response: Any?) ->()) {
        // type:  VOD, LIVE, SERIES,
        let url_request: URL = URL(string: url )!
        let session = URLSession.shared
        var request = URLRequest(url: url_request)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass + to nsdata object
        } catch let error {
            completionHandler(error.localizedDescription, nil)
            return
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                completionHandler(error?.localizedDescription, nil)
                return
            }
            
            guard let data = data else {
                completionHandler("Server connection error.", nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, AnyObject> {
                    let jsonStatus = json["status"] as? String ?? ""
                    DispatchQueue.main.async {
                        
                        if jsonStatus == "" {
                            let error = json["error"] as? [String : Any] ?? [:]
                            var errorStr = ""
                            for (_, value) in error {
                                errorStr = (value as? [String] ?? []).first!
                            }
                            completionHandler(errorStr , nil )
                        }
                        else{
                            if (jsonStatus == "success")
                            {
                               completionHandler(nil, json)
                            }
                            else{
                                let message = "Something went wrong."
                                completionHandler(message, nil)
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
                completionHandler(error.localizedDescription, nil)
            }
        })
        task.resume()
        
    }
    
    func getInitialDataFromServer(token : String, completionHandler: @escaping (_ error: String?, _ response: Any?) ->()) {
           
        let url_request: URL = URL(string: apiNames.initialDataUrl )!
        let session = URLSession.shared
        var request = URLRequest(url: url_request)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
           
           let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
               
               guard error == nil else {
                   completionHandler(error?.localizedDescription, nil)
                   return
               }
               
               guard let data = data else {
                   completionHandler("Server connection error.", nil)
                   return
               }
               do {
                   if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                       completionHandler(nil , json)
                   }
                   else{
                        completionHandler("error" , nil)
                   }
               } catch let error {
                   completionHandler("error", nil)
                   print(error.localizedDescription)
               }
           })
           task.resume()
       }
    
    
    func getRentalAvailableTime( parameters : [String : Any] , token : String , completionHandler: @escaping (_ error: String?, _ response: [String]?) ->()) {
        // type:  VOD, LIVE, SERIES,
        let url_request: URL = URL(string: apiNames.getRentalAvailableTime )!
        let session = URLSession.shared
        var request = URLRequest(url: url_request)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass + to nsdata object
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                completionHandler(error?.localizedDescription, nil)
                return
            }
            
            guard let data = data else {
                completionHandler("Server connection error.", nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String] {
                    completionHandler(nil , json)
                }
            } catch let error {
                print(error.localizedDescription)
                completionHandler(error.localizedDescription, nil)
            }
        })
        task.resume()
        
    }
    
    func getLessonAvailableTime( parameters : [String : Any] , token : String , completionHandler: @escaping (_ error: String?, _ response: [String]?) ->()) {
        // type:  VOD, LIVE, SERIES,
        let url_request: URL = URL(string: apiNames.getAvailableLessonTimes )!
        let session = URLSession.shared
        var request = URLRequest(url: url_request)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass + to nsdata object
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                completionHandler(error?.localizedDescription, nil)
                return
            }
            
            guard let data = data else {
                completionHandler("Server connection error.", nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String] {
                    completionHandler(nil , json)
                }
            } catch let error {
                print(error.localizedDescription)
                completionHandler(error.localizedDescription, nil)
            }
        })
        task.resume()
        
    }
    
    func payCheck( parameters : [String : Any] , token : String , url : String, completionHandler: @escaping (_ error: String?, _ response: String?) ->()) {
        // type:  VOD, LIVE, SERIES,
        let url_request: URL = URL(string: url )!
        let session = URLSession.shared
        var request = URLRequest(url: url_request)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass + to nsdata object
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                completionHandler(error?.localizedDescription, nil)
                return
            }
            
            guard let data = data else {
                completionHandler("Server connection error.", nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                    let json_success = json["status"] as? String ?? ""
                    let stripe_customer_id = json["stripe_customer_id"] as? String ?? ""
                    if json_success == "success"{
                        completionHandler(nil , stripe_customer_id)
                    }
                    else{
                       completionHandler("Something went wrong" , nil)
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
                completionHandler(error.localizedDescription, nil)
            }
        })
        task.resume()
        
    }
    
    func getAvailableLessonCoaches ( parameters : [String : Any] , token : String , completionHandler: @escaping (_ error: String?, _ response: [[String : Any]]?) ->()) {
        // type:  VOD, LIVE, SERIES,
        let url_request: URL = URL(string: apiNames.getAvailableLessonCoaches )!
        let session = URLSession.shared
        var request = URLRequest(url: url_request)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass + to nsdata object
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                completionHandler(error?.localizedDescription, nil)
                return
            }
            
            guard let data = data else {
                completionHandler("Server connection error.", nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : Any]] {
                    completionHandler(nil , json)
                }
            } catch let error {
                print(error.localizedDescription)
                completionHandler(error.localizedDescription, nil)
            }
        })
        task.resume()
        
    }
    
    func saveDefaultCard( parameters : [String : Any] , token : String , url : String, completionHandler: @escaping (_ error: String?, _ response: String?) ->()) {
        // type:  VOD, LIVE, SERIES,
        let url_request: URL = URL(string: url )!
        let session = URLSession.shared
        var request = URLRequest(url: url_request)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass + to nsdata object
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                completionHandler(error?.localizedDescription, nil)
                return
            }
            
            guard let data = data else {
                completionHandler("Server connection error.", nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                    let json_success = json["status"] as? String ?? ""
                    if json_success == "success"{
                        completionHandler(nil , "success")
                    }
                    else{
                       completionHandler("Something went wrong" , nil)
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
                completionHandler(error.localizedDescription, nil)
            }
        })
        task.resume()
        
    }
    
    func updateAccount ( parameters : [String : Any] , token : String , url : String, completionHandler: @escaping (_ error: String?, _ response: String?) ->()) {
        // type:  VOD, LIVE, SERIES,
        let url_request: URL = URL(string: url )!
        let session = URLSession.shared
        var request = URLRequest(url: url_request)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass + to nsdata object
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                completionHandler(error?.localizedDescription, nil)
                return
            }
            
            guard let data = data else {
                completionHandler("Server connection error.", nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                    let json_success = json["status"] as? String ?? ""
                    if json_success == "success"{
                        completionHandler(nil , "success")
                    }
                    else{
                       completionHandler("Something went wrong" , nil)
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
                completionHandler(error.localizedDescription, nil)
            }
        })
        task.resume()
        
    }
    
}

 class Themes: NSObject
 {
    
    static let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    static let sharedInstance = Themes()
    let screenSize:CGRect = UIScreen.main.bounds
   
    let  codename:NSArray=["Afghanistan(+93)", "Albania(+355)","Algeria(+213)","American Samoa(+1684)","Andorra(+376)","Angola(+244)","Anguilla(+1264)","Antarctica(+672)","Antigua and Barbuda(+1268)","Argentina(+54)","Armenia(+374)","Aruba(+297)","Australia(+61)","Austria(+43)","Azerbaijan(+994)","Bahamas(+1242)","Bahrain(+973)","Bangladesh(+880)","Barbados(+1246)","Belarus(+375)","Belgium(+32)","Belize(+501)","Benin(+229)","Bermuda(+1441t6y)","Bhutan(+975)","Bolivia(+591)","Bosnia and Herzegovina(+387)","Botswana(+267)","Brazil(+55)","British Virgin Islands(+1284)","Brunei(+673)","Bulgaria(+359)","Burkina Faso(+226)","Burma (Myanmar)(+95)","Burundi(+257)","Cambodia(+855)","Cameroon(+237)","Canada(+1)","Cape Verde(+238)","Cayman Islands(+1345)","Central African Republic(+236)","Chad(+235)","Chile(+56)","China(+86)","Christmas Island(+61)","Cocos (Keeling) Islands(+61)","Colombia(+57)","Comoros(+269)","Cook Islands(+682)","Costa Rica(+506)","Croatia(+385)","Cuba(+53)","Cyprus(+357)","Czech Republic(+420)","Democratic Republic of the Congo(+243)","Denmark(+45)","Djibouti(+253)","Dominica(+1767)","Dominican Republic(+1809)","Ecuador(+593)","Egypt(+20)","El Salvador(+503)","Equatorial Guinea(+240)","Eritrea(+291)","Estonia(+372)","Ethiopia(+251)","Falkland Islands(+500)","Faroe Islands(+298)","Fiji(+679)","Finland(+358)","France (+33)","French Polynesia(+689)","Gabon(+241)","Gambia(+220)","Gaza Strip(+970)","Georgia(+995)","Germany(+49)","Ghana(+233)","Gibraltar(+350)","Greece(+30)","Greenland(+299)","Grenada(+1473)","Guam(+1671)","Guatemala(+502)","Guinea(+224)","Guinea-Bissau(+245)","Guyana(+592)","Haiti(+509)","Holy See (Vatican City)(+39)","Honduras(+504)","Hong Kong(+852)","Hungary(+36)","Iceland(+354)","India(+91)","Indonesia(+62)","Iran(+98)","Iraq(+964)","Ireland(+353)","Isle of Man(+44)","Israel(+972)","Italy(+39)","Ivory Coast(+225)","Jamaica(+1876)","Japan(+81)","Jordan(+962)","Kazakhstan(+7)","Kenya(+254)","Kiribati(+686)","Kosovo(+381)","Kuwait(+965)","Kyrgyzstan(+996)","Laos(+856)","Latvia(+371)","Lebanon(+961)","Lesotho(+266)","Liberia(+231)","Libya(+218)","Liechtenstein(+423)","Lithuania(+370)","Luxembourg(+352)","Macau(+853)","Macedonia(+389)","Madagascar(+261)","Malawi(+265)","Malaysia(+60)","Maldives(+960)","Mali(+223)","Malta(+356)","MarshallIslands(+692)","Mauritania(+222)","Mauritius(+230)","Mayotte(+262)","Mexico(+52)","Micronesia(+691)","Moldova(+373)","Monaco(+377)","Mongolia(+976)","Montenegro(+382)","Montserrat(+1664)","Morocco(+212)","Mozambique(+258)","Namibia(+264)","Nauru(+674)","Nepal(+977)","Netherlands(+31)","Netherlands Antilles(+599)","New Caledonia(+687)","New Zealand(+64)","Nicaragua(+505)","Niger(+227)","Nigeria(+234)","Niue(+683)","Norfolk Island(+672)","North Korea (+850)","Northern Mariana Islands(+1670)","Norway(+47)","Oman(+968)","Pakistan(+92)","Palau(+680)","Panama(+507)","Papua New Guinea(+675)","Paraguay(+595)","Peru(+51)","Philippines(+63)","Pitcairn Islands(+870)","Poland(+48)","Portugal(+351)","Puerto Rico(+1)","Qatar(+974)","Republic of the Congo(+242)","Romania(+40)","Russia(+7)","Rwanda(+250)","Saint Barthelemy(+590)","Saint Helena(+290)","Saint Kitts and Nevis(+1869)","Saint Lucia(+1758)","Saint Martin(+1599)","Saint Pierre and Miquelon(+508)","Saint Vincent and the Grenadines(+1784)","Samoa(+685)","San Marino(+378)","Sao Tome and Principe(+239)","Saudi Arabia(+966)","Senegal(+221)","Serbia(+381)","Seychelles(+248)","Sierra Leone(+232)","Singapore(+65)","Slovakia(+421)","Slovenia(+386)","Solomon Islands(+677)","Somalia(+252)","South Africa(+27)","South Korea(+82)","Spain(+34)","Sri Lanka(+94)","Sudan(+249)","Suriname(+597)","Swaziland(+268)","Sweden(+46)","Switzerland(+41)","Syria(+963)","Taiwan(+886)","Tajikistan(+992)","Tanzania(+255)","Thailand(+66)","Timor-Leste(+670)","Togo(+228)","Tokelau(+690)","Tonga(+676)","Trinidad and Tobago(+1868)","Tunisia(+216)","Turkey(+90)","Turkmenistan(+993)","Turks and Caicos Islands(+1649)","Tuvalu(+688)","Uganda(+256)","Ukraine(+380)","United Arab Emirates(+971)","United Kingdom(+44)","United States(+1)","Uruguay(+598)","US Virgin Islands(+1340)","Uzbekistan(+998)","Vanuatu(+678)","Venezuela(+58)","Vietnam(+84)","Wallis and Futuna(+681)","West Bank(970)","Yemen(+967)","Zambia(+260)","Zimbabwe(+263)"];
    let code:NSArray=["+93", "+355","+213","+1684","+376","+244","+1264","+672","+1268","+54","+374","+297","+61","+43","+994","+1242","+973","+880","+1246","+375","+32","+501","+229","+1441","+975","+591"," +387","+267","+55","+1284","+673","+359","+226","+95","+257","+855","+237","+1","+238","+1345","+236","+235","+56","+86","+61","+61","+57","+269","+682","+506","+385","+53","+357","+420","+243","+45","+253","+1767","+1809","+593","+20","+503","+240","+291","+372","+251"," +500","+298","+679","+358","+33","+689","+241","+220"," +970","+995","+49","+233","+350","+30","+299","+1473","+1671","+502","+224","+245","+592","+509","+39","+504","+852","+36","+354","+91","+62","+98","+964","+353","+44","+972","+39","+225","+1876","+81","+962","+7","+254","+686","+381","+965","+996","+856","+371","+961","+266","+231","+218","+423","+370","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+222","+230","+262","+52","+691","+373","+377","+976","+382","+1664","+212","+258","+264","+674","+977","+31","+599","+687","+64","+505","+227","+234","+683","+672","+850","+1670","+47","+968","+92","+680","+507","+675","+595","+51","+63","+870","+48","+351","+1","+974","+242","+40","+7","+250","+590","+290","+1869","+1758","+1599","+508","+1784","+685","+378","+239","+966","+221","+381","+248","+232","+65","+421","+386","+677","+252","+27","+82","+34","+94","+249","+597","+268","+46","+41","+963","+886","+992","+255","+66","+670","+228","+690","+676","+1868","+216","+90","+993","+1649","+688","+256","+380","+971","+44","+1","+598","+1340","+998","+678","+58","+84","+681","+970","+967","+260","+263"];
    let codeName_Only =
        ["AD","AE","AF","AG","AI","AL","AM","AO","AQ","AR","AS","AT","AU","AW","AX",
         "AZ","BA","BB","BD","BE","BF","BG","BH","BI","BJ","BL","BM","BN","BO","BQ",
         "BR","BS","BT","BV","BW","BY","BZ","CA","CC","CD","CF","CG","CH","CI","CK",
         "CL","CM","CN","CO","CR","CU","CV","CW","CX","CY","CZ","DE","DJ","DK","DM",
         "DO","DZ","EC","EE","EG","EH","ER","ES","ET","FI","FJ","FK","FM","FO","FR",
         "GA","GB","GD","GE","GF","GG","GH","GI","GL","GM","GN","GP","GQ","GR","GS",
         "GT","GU","GW","GY","HK","HM","HN","HR","HT","HU","ID","IE","IL","IM","IN",
         "IO","IQ","IR","IS","IT","JE","JM","JO","JP","KE","KG","KH","KI","KM","KN",
         "KP","KR","KW","KY","KZ","LA","LB","LC","LI","LK","LR","LS","LT","LU","LV",
         "LY","MA","MC","MD","ME","MF","MG","MH","MK","ML","MM","MN","MO","MP","MQ",
         "MR","MS","MT","MU","MV","MW","MX","MY","MZ","NA","NC","NE","NF","NG","NI",
         "NL","NO","NP","NR","NU","NZ","OM","PA","PE","PF","PG","PH","PK","PL","PM",
         "PN","PR","PS","PT","PW","PY","QA","RE","RO","RS","RU","RW","SA","SB","SC",
         "SD","SE","SG","SH","SI","SJ","SK","SL","SM","SN","SO","SR","SS","ST","SV",
         "SX","SY","SZ","TC","TD","TF","TG","TH","TJ","TK","TL","TM","TN","TO","TR",
         "TT","TV","TW","TZ","UA","UG","UM","US","UY","UZ","VA","VC","VE","VG","VI",
         "VN","VU","WF","WS","YE","YT","ZA","ZM","ZW","ZZ"]
    
    func getCountryList() -> (NSDictionary) {
        let dict = [
            "AF" : ["Afghanistan", "93"],
            "AX" : ["Aland Islands", "358"],
            "AL" : ["Albania", "355"],
            "DZ" : ["Algeria", "213"],
            "AS" : ["American Samoa", "1"],
            "AD" : ["Andorra", "376"],
            "AO" : ["Angola", "244"],
            "AI" : ["Anguilla", "1"],
            "AQ" : ["Antarctica", "672"],
            "AG" : ["Antigua and Barbuda", "1"],
            "AR" : ["Argentina", "54"],
            "AM" : ["Armenia", "374"],
            "AW" : ["Aruba", "297"],
            "AU" : ["Australia", "61"],
            "AT" : ["Austria", "43"],
            "AZ" : ["Azerbaijan", "994"],
            "BS" : ["Bahamas", "1"],
            "BH" : ["Bahrain", "973"],
            "BD" : ["Bangladesh", "880"],
            "BB" : ["Barbados", "1"],
            "BY" : ["Belarus", "375"],
            "BE" : ["Belgium", "32"],
            "BZ" : ["Belize", "501"],
            "BJ" : ["Benin", "229"],
            "BM" : ["Bermuda", "1"],
            "BT" : ["Bhutan", "975"],
            "BO" : ["Bolivia", "591"],
            "BA" : ["Bosnia and Herzegovina", "387"],
            "BW" : ["Botswana", "267"],
            "BV" : ["Bouvet Island", "47"],
            "BQ" : ["BQ", "599"],
            "BR" : ["Brazil", "55"],
            "IO" : ["British Indian Ocean Territory", "246"],
            "VG" : ["British Virgin Islands", "1"],
            "BN" : ["Brunei Darussalam", "673"],
            "BG" : ["Bulgaria", "359"],
            "BF" : ["Burkina Faso", "226"],
            "BI" : ["Burundi", "257"],
            "KH" : ["Cambodia", "855"],
            "CM" : ["Cameroon", "237"],
            "CA" : ["Canada", "1"],
            "CV" : ["Cape Verde", "238"],
            "KY" : ["Cayman Islands", "345"],
            "CF" : ["Central African Republic", "236"],
            "TD" : ["Chad", "235"],
            "CL" : ["Chile", "56"],
            "CN" : ["China", "86"],
            "CX" : ["Christmas Island", "61"],
            "CC" : ["Cocos (Keeling) Islands", "61"],
            "CO" : ["Colombia", "57"],
            "KM" : ["Comoros", "269"],
            "CG" : ["Congo (Brazzaville)", "242"],
            "CD" : ["Congo, Democratic Republic of the", "243"],
            "CK" : ["Cook Islands", "682"],
            "CR" : ["Costa Rica", "506"],
            "CI" : ["Côte d'Ivoire", "225"],
            "HR" : ["Croatia", "385"],
            "CU" : ["Cuba", "53"],
            "CW" : ["Curacao", "599"],
            "CY" : ["Cyprus", "537"],
            "CZ" : ["Czech Republic", "420"],
            "DK" : ["Denmark", "45"],
            "DJ" : ["Djibouti", "253"],
            "DM" : ["Dominica", "1"],
            "DO" : ["Dominican Republic", "1"],
            "EC" : ["Ecuador", "593"],
            "EG" : ["Egypt", "20"],
            "SV" : ["El Salvador", "503"],
            "GQ" : ["Equatorial Guinea", "240"],
            "ER" : ["Eritrea", "291"],
            "EE" : ["Estonia", "372"],
            "ET" : ["Ethiopia", "251"],
            "FK" : ["Falkland Islands (Malvinas)", "500"],
            "FO" : ["Faroe Islands", "298"],
            "FJ" : ["Fiji", "679"],
            "FI" : ["Finland", "358"],
            "FR" : ["France", "33"],
            "GF" : ["French Guiana", "594"],
            "PF" : ["French Polynesia", "689"],
            "TF" : ["French Southern Territories", "689"],
            "GA" : ["Gabon", "241"],
            "GM" : ["Gambia", "220"],
            "GE" : ["Georgia", "995"],
            "DE" : ["Germany", "49"],
            "GH" : ["Ghana", "233"],
            "GI" : ["Gibraltar", "350"],
            "GR" : ["Greece", "30"],
            "GL" : ["Greenland", "299"],
            "GD" : ["Grenada", "1"],
            "GP" : ["Guadeloupe", "590"],
            "GU" : ["Guam", "1"],
            "GT" : ["Guatemala", "502"],
            "GG" : ["Guernsey", "44"],
            "GN" : ["Guinea", "224"],
            "GW" : ["Guinea-Bissau", "245"],
            "GY" : ["Guyana", "595"],
            "HT" : ["Haiti", "509"],
            "VA" : ["Holy See (Vatican City State)", "379"],
            "HN" : ["Honduras", "504"],
            "HK" : ["Hong Kong, Special Administrative Region of China", "852"],
            "HU" : ["Hungary", "36"],
            "IS" : ["Iceland", "354"],
            "IN" : ["India", "91"],
            "ID" : ["Indonesia", "62"],
            "IR" : ["Iran, Islamic Republic of", "98"],
            "IQ" : ["Iraq", "964"],
            "IE" : ["Ireland", "353"],
            "IM" : ["Isle of Man", "44"],
            "IL" : ["Israel", "972"],
            "IT" : ["Italy", "39"],
            "JM" : ["Jamaica", "1"],
            "JP" : ["Japan", "81"],
            "JE" : ["Jersey", "44"],
            "JO" : ["Jordan", "962"],
            "KZ" : ["Kazakhstan", "77"],
            "KE" : ["Kenya", "254"],
            "KI" : ["Kiribati", "686"],
            "KP" : ["Korea, Democratic People's Republic of", "850"],
            "KR" : ["Korea, Republic of", "82"],
            "KW" : ["Kuwait", "965"],
            "KG" : ["Kyrgyzstan", "996"],
            "LA" : ["Lao PDR", "856"],
            "LV" : ["Latvia", "371"],
            "LB" : ["Lebanon", "961"],
            "LS" : ["Lesotho", "266"],
            "LR" : ["Liberia", "231"],
            "LY" : ["Libya", "218"],
            "LI" : ["Liechtenstein", "423"],
            "LT" : ["Lithuania", "370"],
            "LU" : ["Luxembourg", "352"],
            "MO" : ["Macao, Special Administrative Region of China", "853"],
            "MK" : ["Macedonia, Republic of", "389"],
            "MG" : ["Madagascar", "261"],
            "MW" : ["Malawi", "265"],
            "MY" : ["Malaysia", "60"],
            "MV" : ["Maldives", "960"],
            "ML" : ["Mali", "223"],
            "MT" : ["Malta", "356"],
            "MH" : ["Marshall Islands", "692"],
            "MQ" : ["Martinique", "596"],
            "MR" : ["Mauritania", "222"],
            "MU" : ["Mauritius", "230"],
            "YT" : ["Mayotte", "262"],
            "MX" : ["Mexico", "52"],
            "FM" : ["Micronesia, Federated States of", "691"],
            "MD" : ["Moldova", "373"],
            "MC" : ["Monaco", "377"],
            "MN" : ["Mongolia", "976"],
            "ME" : ["Montenegro", "382"],
            "MS" : ["Montserrat", "1"],
            "MA" : ["Morocco", "212"],
            "MZ" : ["Mozambique", "258"],
            "MM" : ["Myanmar", "95"],
            "NA" : ["Namibia", "264"],
            "NR" : ["Nauru", "674"],
            "NP" : ["Nepal", "977"],
            "NL" : ["Netherlands", "31"],
            "AN" : ["Netherlands Antilles", "599"],
            "NC" : ["New Caledonia", "687"],
            "NZ" : ["New Zealand", "64"],
            "NI" : ["Nicaragua", "505"],
            "NE" : ["Niger", "227"],
            "NG" : ["Nigeria", "234"],
            "NU" : ["Niue", "683"],
            "NF" : ["Norfolk Island", "672"],
            "MP" : ["Northern Mariana Islands", "1"],
            "NO" : ["Norway", "47"],
            "OM" : ["Oman", "968"],
            "PK" : ["Pakistan", "92"],
            "PW" : ["Palau", "680"],
            "PS" : ["Palestinian Territory, Occupied", "970"],
            "PA" : ["Panama", "507"],
            "PG" : ["Papua New Guinea", "675"],
            "PY" : ["Paraguay", "595"],
            "PE" : ["Peru", "51"],
            "PH" : ["Philippines", "63"],
            "PN" : ["Pitcairn", "872"],
            "PL" : ["Poland", "48"],
            "PT" : ["Portugal", "351"],
            "PR" : ["Puerto Rico", "1"],
            "QA" : ["Qatar", "974"],
            "RE" : ["Réunion", "262"],
            "RO" : ["Romania", "40"],
            "RU" : ["Russian Federation", "7"],
            "RW" : ["Rwanda", "250"],
            "SH" : ["Saint Helena", "290"],
            "KN" : ["Saint Kitts and Nevis", "1"],
            "LC" : ["Saint Lucia", "1"],
            "PM" : ["Saint Pierre and Miquelon", "508"],
            "VC" : ["Saint Vincent and Grenadines", "1"],
            "BL" : ["Saint-Barthélemy", "590"],
            "MF" : ["Saint-Martin (French part)", "590"],
            "WS" : ["Samoa", "685"],
            "SM" : ["San Marino", "378"],
            "ST" : ["Sao Tome and Principe", "239"],
            "SA" : ["Saudi Arabia", "966"],
            "SN" : ["Senegal", "221"],
            "RS" : ["Serbia", "381"],
            "SC" : ["Seychelles", "248"],
            "SL" : ["Sierra Leone", "232"],
            "SG" : ["Singapore", "65"],
            "SX" : ["Sint Maarten", "1"],
            "SK" : ["Slovakia", "421"],
            "SI" : ["Slovenia", "386"],
            "SB" : ["Solomon Islands", "677"],
            "SO" : ["Somalia", "252"],
            "ZA" : ["South Africa", "27"],
            "GS" : ["South Georgia and the South Sandwich Islands", "500"],
            "SS​" : ["South Sudan", "211"],
            "ES" : ["Spain", "34"],
            "LK" : ["Sri Lanka", "94"],
            "SD" : ["Sudan", "249"],
            "SR" : ["Suriname", "597"],
            "SJ" : ["Svalbard and Jan Mayen Islands", "47"],
            "SZ" : ["Swaziland", "268"],
            "SE" : ["Sweden", "46"],
            "CH" : ["Switzerland", "41"],
            "SY" : ["Syrian Arab Republic (Syria)", "963"],
            "TW" : ["Taiwan, Republic of China", "886"],
            "TJ" : ["Tajikistan", "992"],
            "TZ" : ["Tanzania, United Republic of", "255"],
            "TH" : ["Thailand", "66"],
            "TL" : ["Timor-Leste", "670"],
            "TG" : ["Togo", "228"],
            "TK" : ["Tokelau", "690"],
            "TO" : ["Tonga", "676"],
            "TT" : ["Trinidad and Tobago", "1"],
            "TN" : ["Tunisia", "216"],
            "TR" : ["Turkey", "90"],
            "TM" : ["Turkmenistan", "993"],
            "TC" : ["Turks and Caicos Islands", "1"],
            "TV" : ["Tuvalu", "688"],
            "UG" : ["Uganda", "256"],
            "UA" : ["Ukraine", "380"],
            "AE" : ["United Arab Emirates", "971"],
            "GB" : ["United Kingdom", "44"],
            "US" : ["United States of America", "1"],
            "UY" : ["Uruguay", "598"],
            "UZ" : ["Uzbekistan", "998"],
            "VU" : ["Vanuatu", "678"],
            "VE" : ["Venezuela (Bolivarian Republic of)", "58"],
            "VN" : ["Viet Nam", "84"],
            "VI" : ["Virgin Islands, US", "1"],
            "WF" : ["Wallis and Futuna Islands", "681"],
            "EH" : ["Western Sahara", "212"],
            "YE" : ["Yemen", "967"],
            "ZM" : ["Zambia", "260"],
            "ZW" : ["Zimbabwe", "263"]
        ]
        
        return dict as (NSDictionary)
    }
    
    func draw_Shadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat, scale:Bool , object:UIView,type:String,cornerRadius:CGFloat) -> AnyObject {
        
        object.layer.cornerRadius = cornerRadius
        object.layer.masksToBounds = false
        object.layer.shadowColor = color.cgColor
        object.layer.shadowOpacity = opacity
        object.layer.shadowOffset = offSet
        object.layer.shadowRadius = radius
        if  type == "full"{
            //        object.layer.shadowPath = UIBezierPath(rect:  object.bounds).cgPath
            object.layer.shouldRasterize = true
            object.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
            
        }
        else{
            
            
        }
        return object
    }

//    
//    func goNextVC(storyBoard : String , VCIdentifier : String , rootVC : UINavigationController){
//        
//        let str = UIStoryboard(name: storyBoard, bundle: nil)
//        let next = str.instantiateViewController(withIdentifier: VCIdentifier)
//        
//        rootVC.pushViewController(next, animated: true)
//    }

    func alertView(title:NSString,Message:NSString,ButtonTitle:NSString)
    {
        
        let alert:UIAlertView = UIAlertView()
        alert.title = "\(title)"
        alert.message = "\(Message)"
        alert.addButton(withTitle: "\(ButtonTitle)")
        alert.show()
        
    }
    
    //MARK:- added ragu
  
    

    func jssAlertView(viewController:UIViewController,title:String,text:String,buttonTxt:String?=nil,cancelButtonText:String?=nil,delay: Double?=nil,
                      iconImage:UIImage,timeLeft: UInt?=nil){
        
        let alert1 = JSSAlertView()
        alert1.show(viewController, title: title, text: text, noButtons: false, buttonText: buttonTxt, cancelButtonText: cancelButtonText, color: nil, iconImage: iconImage, delay: nil, timeLeft: timeLeft)
        
    }
    
    
    func showErrorpopup(Msg: String)
    {
        let success = MessageView.viewFromNib(layout: .messageView)
        success.configureTheme(.info)
        success.configureDropShadow()
        success.configureContent(body: Msg)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: successConfig, view: success)
    }
    
    func showAlert ( form :  MessageView.Layout , theme : Theme , title : String , body : String , position : SwiftMessages.PresentationStyle , level : UIWindow.Level ){
        let messageView = MessageView.viewFromNib(layout: form)
        messageView.configureTheme(theme)
        messageView.configureContent(title: title, body: body)
        messageView.button?.isHidden = true
        var messageConfig = SwiftMessages.defaultConfig
        messageConfig.presentationContext = .window(windowLevel: level)
        messageConfig.presentationStyle = position
        messageConfig.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: messageConfig, view: messageView)
    }
    
    
    func shownotificationBanner(Msg: String )
    {
        
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: "Something is horribly wrong!")
        error.button?.isHidden = true
        error.button?.setTitle("", for: .normal)
        
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        
        let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
        warning.configureContent(title: "Warning", body: "Consider yourself warned.")
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)

        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: "Success", body: "Something good happened!")
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .center
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)

        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: "Info", body: "This is a very lengthy and informative info message that wraps across multiple lines and grows in height as needed.")
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .bottom
        infoConfig.duration = .seconds(seconds: 0.25)

        let status = MessageView.viewFromNib(layout: .statusLine)
        status.backgroundView.backgroundColor = UIColor.purple
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: "A tiny line of text covering the status bar.")
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)

        let status2 = MessageView.viewFromNib(layout: .statusLine)
        status2.backgroundView.backgroundColor = UIColor.orange
        status2.bodyLabel?.textColor = UIColor.white
        status2.configureContent(body: "Switched to light status bar!")
        var status2Config = SwiftMessages.defaultConfig
        status2Config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        status2Config.preferredStatusBarStyle = .lightContent

        SwiftMessages.show(view: error)
        SwiftMessages.show(config: warningConfig, view: warning)
        SwiftMessages.show(config: successConfig, view: success)
        SwiftMessages.show(config: infoConfig, view: info)
        SwiftMessages.show(config: statusConfig, view: status)
        SwiftMessages.show(config: status2Config, view: status2)
        


    }
    
    
  

    func AddTopBorder(View:UIView,color:UIColor,width:CGFloat)
    {
        let border:CALayer = CALayer()
        border.backgroundColor = color.cgColor;
         border.frame = CGRect(x: 0, y: 0, width: View.frame.size.width, height: width)
        View.layer.addSublayer(border)
        
        
        
    }
    
    func AddBottomBorder(View:UIView,color:UIColor,width:CGFloat)
    {
        let border:CALayer = CALayer()
        border.backgroundColor = color.cgColor;
        border.frame = CGRect(x: 0, y: View.frame.size.height - width, width: View.frame.size.width, height: width)
        View.layer.addSublayer(border)
        
    }
    func AddTwoBorder(View:UIView,color:UIColor,width:CGFloat)
    {
        
        let topborder:CALayer = CALayer()
        topborder.backgroundColor = color.cgColor;
        topborder.frame = CGRect(x: 0, y: 0, width: View.frame.size.width, height: width)
        let bottomborder:CALayer = CALayer()
        bottomborder.backgroundColor = color.cgColor;
        bottomborder.frame = CGRect(x: 0, y: View.frame.size.height - width, width: View.frame.size.width, height: width)
        View.layer.addSublayer(topborder)
        View.layer.addSublayer(bottomborder)

         
    }
    func isValidPhNo(value: String) -> Bool {
        let num = "[0-9]{10}$";
        let test = NSPredicate(format: "SELF MATCHES %@", num)
        let result =  test.evaluate(with: value)
        return result
    }
  

    
    func rotateImage(image: UIImage) -> UIImage {
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy!
    }
    

     func CheckNullvalue(Passed_value:Any?) -> String {
         var Param:Any?=Passed_value
        if(Param == nil || Param is NSNull)
        {
            Param=""
        }
        else
        {
            Param = String(describing: Passed_value!)
        }
         return Param as! String
     }
    

    
    func Getto_id()->String
    {
        let user_id:String="5885deba742dac0fc8ae465e"
        
        return user_id
    }
    func saveCounrtyphone(countrycode: String) {
        UserDefaults.standard.set(countrycode, forKey: "countryphone")
        UserDefaults.standard.synchronize()
    }
//    func ShowNotification(title:String,subtitle:String)
//    {
//        SWMessage.sharedInstance.showNotificationWithTitle(
//            "\(title)",
//            subtitle: "\(subtitle)",
//            type: .warning
//        )
//        SWMessage.sharedInstance.offsetHeightForMessage = -3
//
//
//    }
    func GetAppname()->String
    {
        var appname:String=self.CheckNullvalue(Passed_value: Bundle.main.infoDictionary!["CFBundleDisplayName"])
        return appname
    
    }
    
    // Time Calculations
    
    func getTime12Hour(value : Date) -> Date
    {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: value)
        let currentTime = dateFormatter.date(from: dateString)
        
        return currentTime!
        
    }
    
    func GetTimeFromDate(time : Date) ->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: time);
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
 }


class publicFunctions : NSObject {
    
    public func getDayString (intDay : Int ) -> String {
        
        switch intDay {
        case 0:
            return "Sunday"
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        default:
            return "Sunday"
        }
    }
    
    public func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString) // <-- here is ur string

        } catch let myJSONError {
            print(myJSONError)
        }

    }
    
    public func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    public func getDateString( date : Date , timeZone : String , dateformatter : String ) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateformatter
        formatter.timeZone = TimeZone.current
        //formatter.timeZone = TimeZone.init(identifier: timeZone)
        let str = formatter.string(from: date)
        
        return str
        
    }
    
    
    func addGradient(view : UIView , colors : [UIColor] , startPoint : CGPoint , endPoint : CGPoint , cornerRadius : CGFloat , left : CGFloat , right : CGFloat ){
        let gradientLayer = CAGradientLayer()
        var cgColors = [CGColor]()
        colors.forEach {
            cgColors.append($0.cgColor)
        }
        gradientLayer.colors = [colors.first?.cgColor , colors.first?.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - ( left + right ), height: view.bounds.height)
        gradientLayer.cornerRadius = 5
        
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addShadow(view : UIView ,cornerRadius : CGFloat , shadowColor : UIColor , shadowOffset : CGSize , shadowOpacity : Float){
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = cornerRadius
    }
    
    public func getTwodigitString ( dbl : Double ) -> String {
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        
        let str = formatter.string(from: dbl as NSNumber )!
        return str
        
    }
    
    public func parseInitialData( resultV : [String : Any] ) {
        
        let stripePublicKey = resultV["stripe_public_key"] as? String ?? ""
        
        let rental = resultV["rental"] as? [String : Any] ?? [:]
        
        let tags = rental["tags"] as? [[String: Any]] ?? []
        var tags_temp = [Tag]()
        for tag in tags{
            let id = tag["id"] as? Int ?? -1
            let name = tag["name"] as? String ?? ""
            let icon = tag["icon"] as? String ?? ""
            let created_at = tag["created_at"] as? String ?? ""
            let updated_at = tag["updated_at"] as? String ?? ""
            
            tags_temp.append(Tag.init(id: id, name: name, icon: icon, createdAt: created_at, updatedAt: updated_at))
        }
        
        let items = rental["items"] as? [[String: Any]] ?? []
        var item_temps = [RentalItem]()
        for item in items{
            
            let id = item["id"] as? Int ?? -1
            let name = item["name"] as? String ?? ""
            let description = item["description"] as? String ?? ""
            let rental_tags = item["rental_tags"] as? [String] ?? []
            let rental_providers = item["rental_providers"] as? [String] ?? []
            let has_time_related_price = item["has_time_related_price"] as? Int ?? -1
            let has_number_related_price = item["has_time_related_price"] as? Int ?? -1
            
            let time_options = item["time_options"] as? [[String : Any]] ?? []
            var time_options_temp = [Option]()
            for time_ in time_options {
                let label = time_["label"] as? String ?? ""
                let max = time_["max"] as? Int ?? -1
                if max == -1 {
                    let max_str = time_["max"] as? String ?? "0"
                    let max_int = Int(max_str)
                    time_options_temp.append(Option.init(label: label, max: max_int!))
                }
                else{
                   time_options_temp.append(Option.init(label: label, max: max))
                }
                
            }
            
            let number_options = item["number_options"] as? [[String : Any]] ?? []
            var number_options_temp = [Option]()
            for number_ in number_options {
                let label = number_["label"] as? String ?? ""
                let max = number_["max"] as? Int ?? -1
                number_options_temp.append(Option.init(label: label, max: max))
            }
            
            let price_options = item["price_options"] as? [Any] ?? []
            var price_options_temp = [[PriceOption]]()
            for i in price_options{
                let priceOptionArray = i as? [[String :Any]] ?? []
                var array_first = [PriceOption]()
                for j in priceOptionArray{
                   // let price = j["price"] as? Int ?? -1
                    
                    var price = j["price"] as? Double ?? -1.0
                    if price == -1 {
                        let str_price = j["price"] as? String ?? "-1"
                        price = Double(str_price)!
                    }
                    
                    let enabled = j["enabled"] as? Bool ?? false
                    array_first.append(PriceOption.init(price: Int(price), enabled: enabled))
                }
               
                price_options_temp.append(array_first)
            }
            
            let unique_price = item["unique_price"] as? JSONNull
            let created_at = item["created_at"] as? String ?? ""
            let updated_at = item["updated_at"] as? String ?? ""
            
            item_temps.append(RentalItem.init(id: id, name: name, itemDescription: description, rentalTags: rental_tags, rentalProviders: rental_providers, hasTimeRelatedPrice: has_time_related_price, hasNumberRelatedPrice: has_number_related_price, timeOptions: time_options_temp, numberOptions: number_options_temp, priceOptions: price_options_temp, uniquePrice: unique_price, createdAt: created_at, updatedAt: updated_at))
        }
        
        
        let lesson = resultV["lesson"] as? [String : Any] ?? [:]
        let lesson_tags = lesson["tags"] as? [[String: Any]] ?? []
        var lesson_tags_temp = [lessonTag]()
        for tag in lesson_tags{
            let id = tag["id"] as? Int ?? -1
            let name = tag["name"] as? String ?? ""
            let icon = tag["icon"] as? String ?? ""
            let created_at = tag["created_at"] as? String ?? ""
            let updated_at = tag["updated_at"] as? String ?? ""
         
         let coaches = tag["coaches"] as? [[String: Any]] ?? []
         let jsonData = try! JSONSerialization.data(withJSONObject: coaches, options: .prettyPrinted)
            
            
         var coaches_temp = [Coach]()
         for coach in coaches{
             
             let id_co = coach["id"] as? Int ?? -1
             let name_co = coach["name"] as? String ?? ""
             let email_co = coach["email"] as? String ?? ""
             let phone_co = coach["phone"] as? String ?? ""
             let profile_picture = coach["profile_picture"] as? String ?? ""
             let daily_hours = coach["daily_hours"] as? [[String: Any]] ?? []
             var daily_hours_temp = [DailyHour]()
             for i in daily_hours {
                 let day_title = i["day_title"] as? String ?? ""
                 let begin_time = i["begin_time"] as? String ?? ""
                 let end_time = i["end_time"] as? String ?? ""
                 daily_hours_temp.append(DailyHour.init(dayTitle: day_title, beginTime: begin_time, endTime: end_time))
             }
             let lesson_tags_co = coach["lesson_tags"] as? [String] ?? []
             let created_at_co = coach["created_at"] as? String ?? ""
             let updated_at_co = coach["updated_at"] as? String ?? ""
             
        
             coaches_temp.append(Coach.init(id: id_co, name: name_co, email: email_co, phone: phone_co, profilePicture: profile_picture, dailyHours: daily_hours_temp, lessonTags: lesson_tags_co, createdAt: created_at_co, updatedAt: updated_at_co))
         }
         
            
            lesson_tags_temp.append(lessonTag.init(id: id, name: name, icon: icon, createdAt: created_at, updatedAt: updated_at ,coaches: coaches_temp , coachesData : jsonData ))
        }
        
        let lesson_items = lesson["items"] as? [[String: Any]] ?? []
        var lesson_item_temps = [LessonItem]()
        for lesson_item in lesson_items {
            
            let id = lesson_item["id"] as? Int ?? -1
            let name = lesson_item["name"] as? String ?? ""
            let description = lesson_item["description"] as? String ?? ""
            
            let tags = lesson_item["tags"] as? [String] ?? []
            let providers = lesson_item["providers"] as? [String] ?? []
            let has_time_related_price = lesson_item["has_time_related_price"] as? Int ?? -1
            let unique_price = lesson_item["unique_price"] as? JSONNull
            let time_prices = lesson_item["time_price"] as? [[String : Any]] ?? []
            var time_price_temp = [TimePrice]()
            for time_price in time_prices{
                let label = time_price["label"] as? String ?? ""
                let max = time_price["max"] as? Int ?? -1
                var price = time_price["price"] as? Double ?? -1.0
                if price == -1 {
                    let str_price = time_price["price"] as? String ?? "-1"
                    price = Double(str_price)!
                }
                time_price_temp.append(TimePrice.init(label: label, max: max, price: price))
            }
            
            let created_at = lesson_item["created_at"] as? String ?? ""
            let updated_at = lesson_item["updated_at"] as? String ?? ""
            
            lesson_item_temps.append(LessonItem.init(id: id, name: name, itemDescription: description, tags: tags, providers: providers, hasTimeRelatedPrice: has_time_related_price, timePrice: time_price_temp, uniquePrice: unique_price, createdAt: created_at, updatedAt: updated_at))
            
        }
        
        let camps = resultV["camps"] as? [[String : Any]] ?? []
        var camps_temp = [Camp]()
        for icamp in camps {
            let id = icamp["id"] as? Int ?? -1
            let name = icamp["name"] as? String ?? ""
            let price = icamp["price"] as? Int ?? 0
            let max_player_number = icamp["max_player_number"] as? Int ?? 0
            let begin_date = icamp["begin_date"] as? String ?? ""
            let end_date = icamp["end_date"] as? String ?? ""
            let age = icamp["age"] as? String ?? ""
            let image = icamp["image"] as? String ?? ""
            let created_at = icamp["created_at"] as? String ?? ""
            let camp_description = icamp["description"] as? String ?? ""
            let updated_at = icamp["updated_at"] as? String ?? ""
            
            let camp_hours = icamp["camp_hours"] as? [[String : Any]] ?? []
            var temp_camp_hours = [CampHour]()
            for icamp_hour in camp_hours {
                let camp_day = icamp_hour["day"] as? Int ?? 0
                let start_time  = icamp_hour["start_time"] as? String ?? ""
                let end_time = icamp_hour["end_time"] as? String ?? ""
                temp_camp_hours.append(CampHour.init(day: camp_day, startTime: start_time, endTime: end_time))
            }
            camps_temp.append(Camp.init(id: id, name: name, price: price, maxPlayerNumber: max_player_number, beginDate: begin_date, endDate: end_date, age: age, campDescription: camp_description, campHours: temp_camp_hours, image: image, createdAt:created_at , updatedAt: updated_at))
        }
        
        // camps_temp
        
        let membership = resultV["membership"] as? [String : Any] ?? [:]
        let mvps = membership["mvps"] as? [[String : Any]] ?? []
        var mvps_temp = [MVP]()
        for imvp in mvps {
            let id = imvp["id"] as? Int ?? 0
            let price = imvp["price"] as? Int ?? 0
            let interval = imvp["interval"] as? Int ?? 0
            let duration = imvp["duration"] as? Int ?? 0
            let name = imvp["name"] as? String ?? ""
            let subscription_type = imvp["subscription_type"] as? String ?? ""
            let membership_kind = imvp["membership_kind"] as? String ?? ""
            let plan_id = imvp["plan_id"] as? String ?? ""
            let created_at = imvp["created_at"] as? String ?? ""
            let updated_at = imvp["updated_at"] as? String ?? ""
            mvps_temp.append(MVP.init(id: id, name: name, price: price, interval: interval, duration: duration, subscriptionType: subscription_type, membershipKind: membership_kind, planID: plan_id, createdAt: created_at, updatedAt: updated_at))
        }
        
        let platinums = membership["platinums"] as? [[String : Any]] ?? []
        var platinum_temp = [MVP]()
        for imvp in platinums {
            let id = imvp["id"] as? Int ?? 0
            let price = imvp["price"] as? Int ?? 0
            let interval = imvp["interval"] as? Int ?? 0
            let duration = imvp["duration"] as? Int ?? 0
            let name = imvp["name"] as? String ?? ""
            let subscription_type = imvp["subscription_type"] as? String ?? ""
            let membership_kind = imvp["membership_kind"] as? String ?? ""
            let plan_id = imvp["plan_id"] as? String ?? ""
            let created_at = imvp["created_at"] as? String ?? ""
            let updated_at = imvp["updated_at"] as? String ?? ""
            platinum_temp.append(MVP.init(id: id, name: name, price: price, interval: interval, duration: duration, subscriptionType: subscription_type, membershipKind: membership_kind, planID: plan_id, createdAt: created_at, updatedAt: updated_at))
        }
        
        let membership_temp = Membership.init(mvps: mvps_temp, platinums: platinum_temp)

        sharedData.initialData = InitialData.init(stripePublicKey: stripePublicKey, rental: Rental.init(tags: tags_temp, items: item_temps), lesson: Lesson.init(tags: lesson_tags_temp, items: lesson_item_temps) , camps: camps_temp , membership: membership_temp)
        
        STPPaymentConfiguration.shared().publishableKey = stripePublicKey
        
    }
    
    func returnCoachesArray ( result_t : [[String : Any]] ) -> [Coach] {
        let coaches = result_t
        let jsonData = try! JSONSerialization.data(withJSONObject: coaches, options: .prettyPrinted)
            
            
         var coaches_temp = [Coach]()
         for coach in coaches{
             
             let id_co = coach["id"] as? Int ?? -1
             let name_co = coach["name"] as? String ?? ""
             let email_co = coach["email"] as? String ?? ""
             let phone_co = coach["phone"] as? String ?? ""
             let profile_picture = coach["profile_picture"] as? String ?? ""
             let daily_hours = coach["daily_hours"] as? [[String: Any]] ?? []
             var daily_hours_temp = [DailyHour]()
             for i in daily_hours {
                 let day_title = i["day_title"] as? String ?? ""
                 let begin_time = i["begin_time"] as? String ?? ""
                 let end_time = i["end_time"] as? String ?? ""
                 daily_hours_temp.append(DailyHour.init(dayTitle: day_title, beginTime: begin_time, endTime: end_time))
             }
             let lesson_tags_co = coach["lesson_tags"] as? [String] ?? []
             let created_at_co = coach["created_at"] as? String ?? ""
             let updated_at_co = coach["updated_at"] as? String ?? ""
            
             coaches_temp.append(Coach.init(id: id_co, name: name_co, email: email_co, phone: phone_co, profilePicture: profile_picture, dailyHours: daily_hours_temp, lessonTags: lesson_tags_co, createdAt: created_at_co, updatedAt: updated_at_co))
         }
         return coaches_temp
    }
}

class appColors {
    
    public static let appBackgroundColor = UIColor.init(hexString: "#FAFAFF")!
    public static let appMainColor = UIColor.init(hexString: "#00AEEF")!
    public static let appMainColorForGradient = UIColor.init(hexString: "005778")!
    public static let appLabelColor = UIColor.init(hexString: "#0C233C")!
    
    
}
