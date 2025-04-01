import 'dart:io';

/// cohortsData : [{"id":1,"vehicle_id":1821689,"cohort":"Fair Returns LP LLC","active":1,"deleted_at":null,"created_at":"2022-12-30T17:32:34.000000Z","updated_at":"2022-12-30T17:32:34.000000Z","vehicles":[{"id":6,"vehicle_id":1919029,"vehicle_name":"2019 NISSAN SENTRA S SILVR","vin":"3N1AB7APXKY445778","make":"NISSAN","model":"SENTRA S SILVR","year":"2019","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":7,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":14193,"row_order":6,"note":null,"deleted_at":null,"created_at":"2023-02-28T07:58:53.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":7,"vehicle_id":1919031,"vehicle_name":"2022 MITSUBISHI MIRAGE ES SILVR","vin":"ML32AUHJ2NH002953","make":"MITSUBISHI","model":"MIRAGE ES SILVR","year":"2022","cohort_id":1,"earnings":800,"utilization_rate":0,"vehicle_status":7,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":12250,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-02-28T08:00:37.000000Z","updated_at":"2023-05-05T16:28:33.000000Z"},{"id":8,"vehicle_id":1927761,"vehicle_name":"2020 HYUNDAI ELANTRA SE GRAY","vin":"5NPD84LF4LH623887","make":"HYUNDAI","model":"ELANTRA SE GRAY","year":"2020","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":7,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":17270,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-02-28T08:01:25.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":9,"vehicle_id":2019187,"vehicle_name":"2018 NISSAN ROGUE S SILVR","vin":"5N1AT2MT4JC761637","make":"NISSAN","model":"ROGUE S SILVR","year":"2018","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":12250,"row_order":2,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-02-28T08:02:04.000000Z","updated_at":"2023-06-25T21:40:09.000000Z"},{"id":10,"vehicle_id":1910322,"vehicle_name":"2018 FORD ESCAPE SE BLACK","vin":"1FMCU0GD4JUB41847","make":"FORD","model":"ESCAPE SE BLACK","year":"2018","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":15625,"row_order":0,"note":"Complete","deleted_at":null,"created_at":"2023-02-28T08:03:15.000000Z","updated_at":"2023-04-30T21:50:50.000000Z"},{"id":11,"vehicle_id":1954133,"vehicle_name":"2019 KIA FORTE FE WHITE","vin":"3KPF24AD0KE059797","make":"KIA","model":"FORTE FE WHITE","year":"2019","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":13700,"row_order":0,"note":"Install Bouncie and insurance","deleted_at":null,"created_at":"2023-02-28T08:03:38.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":12,"vehicle_id":1906497,"vehicle_name":"2021 KIA RIO LX WHITE","vin":"3KPA24AD2ME386389","make":"KIA","model":"RIO LX WHITE","year":"2021","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":4,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":11500,"row_order":0,"note":"Registration","deleted_at":null,"created_at":"2023-02-28T08:04:29.000000Z","updated_at":"2023-06-25T21:41:54.000000Z"},{"id":14,"vehicle_id":1946279,"vehicle_name":"2021 TOYOTA COROLLA LE","vin":"5YFEPMAE1MP244657","make":"TOYOTA","model":"COROLLA LE","year":"2021","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":16150,"row_order":3,"note":"Do State Inspection","deleted_at":null,"created_at":"2023-03-02T20:31:54.000000Z","updated_at":"2023-05-10T16:53:36.000000Z"},{"id":15,"vehicle_id":2035600,"vehicle_name":"2022 VOLKSWAGEN PASSAT SE","vin":"1VWSA7A35NC008055","make":"VOLKSWAGEN","model":"PASSAT SE","year":"2022","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":17350,"row_order":1,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-03-02T20:32:54.000000Z","updated_at":"2023-06-25T21:43:08.000000Z"},{"id":16,"vehicle_id":2009739,"vehicle_name":"2020 NISSAN ALTIMA S","vin":"1N4BL4BV6LC238377","make":"NISSAN","model":"ALTIMA S","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":4,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":15000,"row_order":7,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-03-02T20:33:56.000000Z","updated_at":"2023-06-25T21:39:27.000000Z"},{"id":19,"vehicle_id":2014826,"vehicle_name":"2019 CHEVROLET SPARK LS","vin":"KL8CB6SA2KC751210","make":"CHEVROLET","model":"SPARK LS","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":11850,"row_order":4,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-03-06T18:58:05.000000Z","updated_at":"2023-06-25T21:37:56.000000Z"},{"id":20,"vehicle_id":2035615,"vehicle_name":"2021 HYUNDAI ELANTRA SE","vin":"5NPLL4AG8MH052993","make":"HYUNDAI","model":"ELANTRA SE","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":15625,"row_order":0,"note":"Waiting for car in copart auction","deleted_at":null,"created_at":"2023-03-07T00:07:39.000000Z","updated_at":"2023-06-02T13:09:13.000000Z"},{"id":22,"vehicle_id":2025070,"vehicle_name":"2020 CHEVROLET EQUINOX LT","vin":"2GNAXJEVXL6137380","make":"CHEVROLET","model":"EQUINOX LT","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":19375,"row_order":8,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-03-13T21:41:17.000000Z","updated_at":"2023-06-25T21:35:25.000000Z"},{"id":23,"vehicle_id":2062415,"vehicle_name":"2022 NISSAN ALTIMA","vin":"1N4BL4BV2NN321098","make":"NISSAN","model":"ALTIMA","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":18705,"row_order":9,"note":"Waiting for Aufar","deleted_at":null,"created_at":"2023-03-13T21:56:10.000000Z","updated_at":"2023-06-17T16:03:16.000000Z"},{"id":24,"vehicle_id":2081255,"vehicle_name":"2018 NISSAN ROGUE SPORT S","vin":"JN1BJ1CR2JW262027","make":"NISSAN","model":"ROGUE SPORT S","year":"2018","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":4,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":16725,"row_order":10,"note":"pay dispatcher on delivery","deleted_at":null,"created_at":"2023-03-13T21:58:57.000000Z","updated_at":"2023-07-02T17:30:22.000000Z"},{"id":25,"vehicle_id":12132145,"vehicle_name":"2019 HYUNDAI ELANTRA SE","vin":"KMHD74LF7KU768411","make":"HYUNDAI","model":"ELANTRA SE","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":13800,"row_order":11,"note":"Pay Aufar $950","deleted_at":null,"created_at":"2023-03-15T22:43:45.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":26,"vehicle_id":1442532621,"vehicle_name":"2021 NISSAN ALTIMA","vin":"1N4BL4BV4MN403591","make":"NISSAN","model":"ALTIMA","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":18640,"row_order":12,"note":null,"deleted_at":null,"created_at":"2023-03-21T18:14:34.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":27,"vehicle_id":2019181,"vehicle_name":"2019 FORD ESCAPE SEL","vin":"1FMCU9HD3KUB24431","make":"FORD","model":"ESCAPE SEL","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":21575,"row_order":5,"note":"Register car","deleted_at":null,"created_at":"2023-03-23T15:52:07.000000Z","updated_at":"2023-06-02T13:10:01.000000Z"},{"id":28,"vehicle_id":1997676,"vehicle_name":"2019 MITSUBISHI MIRAGE G4","vin":"2023ML32F3FJ2KHF16041","make":"MITSUBISHI","model":"MIRAGE G4","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":2,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":8375,"row_order":0,"note":"Paid Aufar $1300 add receipt","deleted_at":null,"created_at":"2023-03-27T20:15:32.000000Z","updated_at":"2023-05-05T16:28:05.000000Z"},{"id":29,"vehicle_id":2017215,"vehicle_name":"2020 CHEVROLET EQUINOX LS","vin":"2GNAXSEV4L6184362","make":"CHEVROLET","model":"EQUINOX LS","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":16175,"row_order":0,"note":"Registration pending","deleted_at":null,"created_at":"2023-04-04T14:24:57.000000Z","updated_at":"2023-06-25T21:36:14.000000Z"},{"id":30,"vehicle_id":2057663,"vehicle_name":"2019 KIA SORENTO L","vin":"5XYPG4A33KG465458","make":"KIA","model":"SORENTO L","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":21275,"row_order":0,"note":"AC fixed , fix over heating","deleted_at":null,"created_at":"2023-04-04T14:25:51.000000Z","updated_at":"2023-06-17T16:02:18.000000Z"},{"id":31,"vehicle_id":234,"vehicle_name":"2020 MAZDA 6 GRAND","vin":"JM1GL1WY5L1511176","make":"MAZDA","model":"6 GRAND","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":44364,"wholesale_amount":28450,"row_order":0,"note":"Pay Aufar $750 pick up check Adesa","deleted_at":null,"created_at":"2023-04-06T17:37:55.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":32,"vehicle_id":2047922,"vehicle_name":"2022 FORD ESCAPE SE","vin":"1FMCU9G66NUA46265","make":"FORD","model":"ESCAPE SE","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":29586,"wholesale_amount":26000,"row_order":0,"note":"Update the plate in NTTA & Turo","deleted_at":null,"created_at":"2023-04-06T17:43:22.000000Z","updated_at":"2023-06-25T21:32:56.000000Z"},{"id":33,"vehicle_id":1997714,"vehicle_name":"2017 NISSAN ROGUE SPORT","vin":"1FMCU9HD3KUB24432","make":"NISSAN","model":"ROGUE SPORT","year":"2017","cohort_id":1,"earnings":null,"utilization_rate":null,"vehicle_status":5,"active":1,"platform":"TURO","mileage":61497,"wholesale_amount":13500,"row_order":0,"note":"Install Bouncie and get insurance","deleted_at":null,"created_at":"2023-04-20T00:10:34.000000Z","updated_at":"2023-05-05T16:27:29.000000Z"},{"id":34,"vehicle_id":14141243,"vehicle_name":"2022 NISSAN ALTIMA","vin":"1N4BL4BV3NN351341","make":"NISSAN","model":"ALTIMA","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":26000,"wholesale_amount":21450,"row_order":0,"note":"Fix bumper & pay Aufar","deleted_at":null,"created_at":"2023-04-26T22:35:46.000000Z","updated_at":"2023-05-25T07:13:45.000000Z"},{"id":35,"vehicle_id":2068960,"vehicle_name":"2021 SUBARU LEGACY PREMIUM","vin":"4S3BWAF62M3019825","make":"SUBARU","model":"LEGACY PREMIUM","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":35871,"wholesale_amount":24550,"row_order":0,"note":"State Inspection & Registration","deleted_at":null,"created_at":"2023-04-26T22:37:37.000000Z","updated_at":"2023-07-08T15:42:30.000000Z"},{"id":36,"vehicle_id":124235425,"vehicle_name":"2021 NISSAN VERSA SV","vin":"3N1CN8EV9ML866261","make":"NISSAN","model":"VERSA SV","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":41457,"wholesale_amount":17100,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-05-01T22:29:02.000000Z","updated_at":"2023-05-25T07:14:11.000000Z"},{"id":37,"vehicle_id":2147483647,"vehicle_name":"2018 FORD FUSION","vin":"3FA6P0HDXJR227720","make":"FORD","model":"FUSION","year":"2018","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":53163,"wholesale_amount":14825,"row_order":0,"note":"Car will be delivered 05/26","deleted_at":null,"created_at":"2023-05-23T16:14:06.000000Z","updated_at":"2023-06-02T13:01:42.000000Z"},{"id":38,"vehicle_id":875,"vehicle_name":"2000 Fair Returns","vin":"FAIRRETURN2000","make":"Fair","model":"Returns","year":"2000","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"0","mileage":0,"wholesale_amount":0,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-05-25T14:47:08.000000Z","updated_at":"2023-05-25T14:59:03.000000Z"},{"id":39,"vehicle_id":214142124,"vehicle_name":"2020 MITSUBISHI OUTLANDER SPORT","vin":"JA4AP3AU8LU017512","make":"MITSUBISHI","model":"OUTLANDER SPORT","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":50988,"wholesale_amount":14425,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-06T23:53:31.000000Z","updated_at":"2023-06-06T23:53:46.000000Z"},{"id":40,"vehicle_id":27263626,"vehicle_name":"2020 CHEVROLET EQUINOX","vin":"2GNAXUEV6L6187372","make":"CHEVROLET","model":"EQUINOX","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":42825,"wholesale_amount":19050,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-17T00:53:05.000000Z","updated_at":"2023-06-17T00:53:45.000000Z"},{"id":41,"vehicle_id":17171616,"vehicle_name":"2022 NISSAN ALTIMA S WHITE","vin":"1N4BL4BV7NN313059","make":"NISSAN","model":"ALTIMA S WHITE","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":24263,"wholesale_amount":20375,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-17T01:06:28.000000Z","updated_at":"2023-07-18T22:03:07.000000Z"},{"id":43,"vehicle_id":1442323,"vehicle_name":"2022 NISSAN ALTIMA GRAY","vin":"1N4BL4DV7NN400196","make":"NISSAN","model":"ALTIMA GRAY","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":19135,"wholesale_amount":19850,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-25T20:35:39.000000Z","updated_at":"2023-07-18T22:01:49.000000Z"},{"id":44,"vehicle_id":2311,"vehicle_name":"2021 NISSAN VERSA SV","vin":"3N1CN8EV8ML924120","make":"NISSAN","model":"VERSA SV","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":23983,"wholesale_amount":17100,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-25T20:39:59.000000Z","updated_at":"2023-06-25T20:39:59.000000Z"},{"id":45,"vehicle_id":31313232,"vehicle_name":"2021 FORD EXPLORER","vin":"1FMSK8DH7MGB13969","make":"FORD","model":"EXPLORER","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Rent","mileage":44907,"wholesale_amount":24325,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-30T23:30:06.000000Z","updated_at":"2023-06-30T23:30:06.000000Z"},{"id":46,"vehicle_id":211312,"vehicle_name":"2022 TOYOTA COROLLA WHITE","vin":"5YFEPMAE2NP378725","make":"TOYOTA","model":"COROLLA WHITE","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":12999,"wholesale_amount":20975,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-08T18:08:37.000000Z","updated_at":"2023-07-18T22:02:32.000000Z"},{"id":47,"vehicle_id":234332,"vehicle_name":"2022 NISSAN ALTIMA S SILVER2","vin":"1N4BL4BV6NN398492","make":"NISSAN","model":"ALTIMA S SILVER2","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":25859,"wholesale_amount":20075,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-08T18:14:43.000000Z","updated_at":"2023-07-28T23:21:09.000000Z"},{"id":48,"vehicle_id":24637468,"vehicle_name":"2021 NISSAN SENTRA","vin":"3N1AB8CV5MY265824","make":"NISSAN","model":"SENTRA","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":40628,"wholesale_amount":19050,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-08T18:18:00.000000Z","updated_at":"2023-07-08T18:18:00.000000Z"},{"id":49,"vehicle_id":1112,"vehicle_name":"2019 FORD FUSION SE RED","vin":"3FA6P0HD7KR232956","make":"FORD","model":"FUSION SE RED","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":50081,"wholesale_amount":15625,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-13T19:49:01.000000Z","updated_at":"2023-07-13T19:49:01.000000Z"},{"id":50,"vehicle_id":134,"vehicle_name":"2022 TOYOTA COROLLA LE BLACK","vin":"JTDEPMAE5NJ191788","make":"TOYOTA","model":"COROLLA LE BLACK","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":35142,"wholesale_amount":19100,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-13T19:54:18.000000Z","updated_at":"2023-07-13T19:54:18.000000Z"}],"expense_to":[{"id":1,"cohort_id":1,"expense_to":"Fair Returns LP","status":1,"deleted_at":null,"created_at":"2023-07-30T21:57:02.000000Z","updated_at":"2023-07-30T21:57:02.000000Z"},{"id":3,"cohort_id":1,"expense_to":"Investor","status":1,"deleted_at":null,"created_at":"2023-07-31T18:54:51.000000Z","updated_at":"2023-07-31T18:54:51.000000Z"},{"id":4,"cohort_id":1,"expense_to":"Turo","status":1,"deleted_at":null,"created_at":"2023-07-31T18:56:02.000000Z","updated_at":"2023-07-31T18:56:02.000000Z"}]},{"id":3,"vehicle_id":1767554,"cohort":"Share Car","active":1,"deleted_at":null,"created_at":"2022-12-30T17:32:34.000000Z","updated_at":"2023-03-01T18:15:37.000000Z","vehicles":[{"id":2,"vehicle_id":1821689,"vehicle_name":"2020 MITSUBISHI Mirage hatchback","vin":"ML32A3HJ6LH008780","make":"MITSUBISHI","model":"Mirage hatchback","year":"2020","cohort_id":3,"earnings":null,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":null,"row_order":0,"note":null,"deleted_at":null,"created_at":"2022-12-30T15:47:57.000000Z","updated_at":"2023-07-28T23:22:59.000000Z"},{"id":3,"vehicle_id":1767554,"vehicle_name":"2018 TESLA Model 3","vin":"5YJ3E1EA0JF152479","make":"TESLA","model":"Model 3","year":"2018","cohort_id":3,"earnings":null,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":null,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-01-23T01:13:18.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"}],"expense_to":[]},{"id":5,"vehicle_id":2,"cohort":"Personal Car","active":1,"deleted_at":null,"created_at":"2022-12-30T17:32:34.000000Z","updated_at":"2023-03-01T18:14:55.000000Z","vehicles":[{"id":4,"vehicle_id":1701461,"vehicle_name":"2015 AUDI A6","vin":"WAUFGAFC1FN018609","make":"AUDI","model":"A6","year":"2015","cohort_id":5,"earnings":null,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":null,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-02-10T02:22:54.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":5,"vehicle_id":1751954,"vehicle_name":"2019 TOYOTA RAV4","vin":"2T3W1RFV0KC026841","make":"TOYOTA","model":"RAV4","year":"2019","cohort_id":5,"earnings":null,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":null,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-02-10T02:26:14.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"}],"expense_to":[{"id":2,"cohort_id":5,"expense_to":"FairPy","status":1,"deleted_at":null,"created_at":"2023-07-30T21:58:00.000000Z","updated_at":"2023-07-30T21:58:00.000000Z"}]},{"id":11,"vehicle_id":null,"cohort":"FairPY","active":1,"deleted_at":null,"created_at":"2023-03-03T12:39:33.000000Z","updated_at":"2023-03-14T17:41:29.000000Z","vehicles":[{"id":21,"vehicle_id":1234567890,"vehicle_name":"2001 FairPY Generic Misc Expense","vin":"1234","make":"FairPY","model":"Generic Misc Expense","year":"2001","cohort_id":11,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":null,"mileage":null,"wholesale_amount":null,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-03-08T01:23:21.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"}],"expense_to":[]},{"id":12,"vehicle_id":null,"cohort":"Fair Returns Fall 2023","active":1,"deleted_at":null,"created_at":"2023-07-28T21:14:04.000000Z","updated_at":"2023-07-28T21:14:04.000000Z","vehicles":[{"id":51,"vehicle_id":86546,"vehicle_name":"2022 TESLA MODEL 3 RED","vin":"5YJ3E1EA6NF188229","make":"TESLA","model":"MODEL 3 RED","year":"2022","cohort_id":12,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":21472,"wholesale_amount":30175,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-13T20:23:19.000000Z","updated_at":"2023-07-28T21:15:03.000000Z"},{"id":52,"vehicle_id":214214,"vehicle_name":"2021 TOYOTA COROLLA LE RED","vin":"5YFEPMAE0MP160586","make":"TOYOTA","model":"COROLLA LE RED","year":"2021","cohort_id":12,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"TURO","mileage":43407,"wholesale_amount":18150,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-28T21:03:55.000000Z","updated_at":"2023-07-28T21:17:12.000000Z"},{"id":53,"vehicle_id":1231214,"vehicle_name":"2021 TOYOTA CAMRY LE WHITE","vin":"4T1C11AKXMU455741","make":"TOYOTA","model":"CAMRY LE WHITE","year":"2021","cohort_id":12,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"TURO","mileage":47167,"wholesale_amount":20525,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-28T21:07:23.000000Z","updated_at":"2023-07-28T21:15:58.000000Z"},{"id":54,"vehicle_id":32414,"vehicle_name":"2019 HYUNDAI SONATA RED","vin":"5NPE34AF2KH787059","make":"HYUNDAI","model":"SONATA RED","year":"2019","cohort_id":12,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Rent","mileage":110,"wholesale_amount":8525,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-28T21:10:59.000000Z","updated_at":"2023-07-28T21:15:37.000000Z"}],"expense_to":[{"id":5,"cohort_id":12,"expense_to":"Fair Returns Fall 2023","status":1,"deleted_at":null,"created_at":"2023-07-31T18:57:57.000000Z","updated_at":"2023-07-31T18:57:57.000000Z"}]}]
/// expenseCategories : [{"id":48,"name":"Delivery","parent_id":null,"deleted_at":null,"created_at":"2023-06-08T15:23:24.000000Z","updated_at":"2023-06-08T15:23:24.000000Z","sub_categories":[{"id":49,"name":"Uber or Lyft Ride","parent_id":48,"deleted_at":null,"created_at":"2023-06-08T15:23:38.000000Z","updated_at":"2023-06-08T15:23:38.000000Z"},{"id":50,"name":"Ride to pick up car","parent_id":48,"deleted_at":null,"created_at":"2023-06-08T15:24:22.000000Z","updated_at":"2023-06-08T15:24:22.000000Z"}]},{"id":14,"name":"Incidentals","parent_id":null,"deleted_at":null,"created_at":"2023-02-14T00:33:19.000000Z","updated_at":"2023-02-14T00:33:19.000000Z","sub_categories":[{"id":15,"name":"Refueling","parent_id":14,"deleted_at":null,"created_at":"2023-02-14T00:33:42.000000Z","updated_at":"2023-02-14T00:33:42.000000Z"},{"id":16,"name":"Tolls","parent_id":14,"deleted_at":null,"created_at":"2023-02-14T00:33:57.000000Z","updated_at":"2023-02-14T00:33:57.000000Z"},{"id":17,"name":"Tickets","parent_id":14,"deleted_at":null,"created_at":"2023-02-14T00:34:21.000000Z","updated_at":"2023-02-14T00:34:21.000000Z"}]},{"id":4,"name":"Insurance","parent_id":null,"deleted_at":null,"created_at":"2023-02-13T21:17:05.000000Z","updated_at":"2023-02-13T21:17:05.000000Z","sub_categories":[{"id":13,"name":"LuLa","parent_id":4,"deleted_at":null,"created_at":"2023-02-14T00:32:59.000000Z","updated_at":"2023-02-14T00:32:59.000000Z"},{"id":46,"name":"Tracker monthly payment","parent_id":4,"deleted_at":null,"created_at":"2023-05-01T16:36:46.000000Z","updated_at":"2023-05-01T16:36:46.000000Z"}]},{"id":1,"name":"Maintainence","parent_id":null,"deleted_at":null,"created_at":"2023-02-13T21:15:42.000000Z","updated_at":"2023-02-13T21:15:42.000000Z","sub_categories":[{"id":11,"name":"Oil Change","parent_id":1,"deleted_at":null,"created_at":"2023-02-13T23:33:25.000000Z","updated_at":"2023-02-14T00:25:37.000000Z"},{"id":12,"name":"Car Wash","parent_id":1,"deleted_at":null,"created_at":"2023-02-14T00:22:18.000000Z","updated_at":"2023-02-14T00:22:18.000000Z"},{"id":32,"name":"Miscellaneous","parent_id":1,"deleted_at":null,"created_at":"2023-03-08T01:28:22.000000Z","updated_at":"2023-03-08T01:28:22.000000Z"}]},{"id":21,"name":"Post Purchase","parent_id":null,"deleted_at":null,"created_at":"2023-02-14T00:35:36.000000Z","updated_at":"2023-02-14T00:35:36.000000Z","sub_categories":[{"id":25,"name":"Transport from Auction","parent_id":21,"deleted_at":null,"created_at":"2023-02-28T04:37:41.000000Z","updated_at":"2023-02-28T04:37:41.000000Z"},{"id":26,"name":"Transport to Mechanic","parent_id":21,"deleted_at":null,"created_at":"2023-02-28T04:37:58.000000Z","updated_at":"2023-02-28T04:37:58.000000Z"},{"id":27,"name":"Parts","parent_id":21,"deleted_at":null,"created_at":"2023-02-28T04:38:32.000000Z","updated_at":"2023-02-28T04:38:32.000000Z"},{"id":28,"name":"Fuel","parent_id":21,"deleted_at":null,"created_at":"2023-02-28T04:38:40.000000Z","updated_at":"2023-02-28T04:38:40.000000Z"},{"id":30,"name":"Repair for Rental","parent_id":21,"deleted_at":null,"created_at":"2023-02-28T15:12:21.000000Z","updated_at":"2023-02-28T15:12:21.000000Z"},{"id":31,"name":"Car Cleaning","parent_id":21,"deleted_at":null,"created_at":"2023-02-28T18:29:34.000000Z","updated_at":"2023-02-28T18:29:34.000000Z"},{"id":37,"name":"Transport to Auction","parent_id":21,"deleted_at":null,"created_at":"2023-03-24T16:25:27.000000Z","updated_at":"2023-03-24T16:25:27.000000Z"},{"id":38,"name":"FairPY Sales Fee","parent_id":21,"deleted_at":null,"created_at":"2023-03-24T16:25:38.000000Z","updated_at":"2023-03-24T16:25:38.000000Z"},{"id":39,"name":"Wholesale Auction Fee","parent_id":21,"deleted_at":null,"created_at":"2023-03-24T16:25:56.000000Z","updated_at":"2023-03-24T16:25:56.000000Z"},{"id":42,"name":"State Inspection","parent_id":21,"deleted_at":null,"created_at":"2023-03-26T21:48:15.000000Z","updated_at":"2023-03-26T21:48:15.000000Z"},{"id":44,"name":"Registration & Sales Tax","parent_id":21,"deleted_at":null,"created_at":"2023-04-26T16:22:09.000000Z","updated_at":"2023-04-26T16:22:09.000000Z"},{"id":45,"name":"Repair for Sales","parent_id":21,"deleted_at":null,"created_at":"2023-04-26T16:23:02.000000Z","updated_at":"2023-04-26T16:23:02.000000Z"}]},{"id":20,"name":"Purchase","parent_id":null,"deleted_at":null,"created_at":"2023-02-14T00:35:23.000000Z","updated_at":"2023-02-14T00:35:23.000000Z","sub_categories":[{"id":22,"name":"Bid Price","parent_id":20,"deleted_at":null,"created_at":"2023-02-28T04:36:34.000000Z","updated_at":"2023-02-28T04:36:34.000000Z"},{"id":23,"name":"Auction Fee","parent_id":20,"deleted_at":null,"created_at":"2023-02-28T04:36:46.000000Z","updated_at":"2023-02-28T04:36:46.000000Z"},{"id":24,"name":"Auction Storage & Other Fee","parent_id":20,"deleted_at":null,"created_at":"2023-02-28T04:37:20.000000Z","updated_at":"2023-02-28T04:37:20.000000Z"},{"id":29,"name":"FairPY Fee","parent_id":20,"deleted_at":null,"created_at":"2023-02-28T04:40:10.000000Z","updated_at":"2023-02-28T04:40:10.000000Z"}]},{"id":40,"name":"Rental Setup","parent_id":null,"deleted_at":null,"created_at":"2023-03-26T21:47:35.000000Z","updated_at":"2023-03-26T21:47:35.000000Z","sub_categories":[{"id":41,"name":"State Inspection","parent_id":40,"deleted_at":null,"created_at":"2023-03-26T21:47:53.000000Z","updated_at":"2023-03-26T21:47:53.000000Z"}]},{"id":18,"name":"Repair","parent_id":null,"deleted_at":null,"created_at":"2023-02-14T00:34:57.000000Z","updated_at":"2023-02-14T00:34:57.000000Z","sub_categories":[{"id":51,"name":"Customer Accident","parent_id":18,"deleted_at":null,"created_at":"2023-06-19T16:25:24.000000Z","updated_at":"2023-06-19T16:25:24.000000Z"},{"id":52,"name":"Non Accident","parent_id":18,"deleted_at":null,"created_at":"2023-07-12T02:13:54.000000Z","updated_at":"2023-07-12T02:13:54.000000Z"}]},{"id":33,"name":"Wholesale","parent_id":null,"deleted_at":null,"created_at":"2023-03-23T19:49:52.000000Z","updated_at":"2023-03-23T19:49:52.000000Z","sub_categories":[{"id":34,"name":"Transport to Auction","parent_id":33,"deleted_at":null,"created_at":"2023-03-23T19:50:25.000000Z","updated_at":"2023-03-23T19:50:25.000000Z"},{"id":35,"name":"FairPY Sales Fee","parent_id":33,"deleted_at":null,"created_at":"2023-03-23T19:50:58.000000Z","updated_at":"2023-03-23T19:50:58.000000Z"},{"id":36,"name":"Auction Sales Fee","parent_id":33,"deleted_at":null,"created_at":"2023-03-23T19:52:46.000000Z","updated_at":"2023-03-23T19:52:46.000000Z"}]}]

class CreateExpenseFieldData {
  CreateExpenseFieldData({
      this.cohortsData, 
      this.expenseCategories,
    this.status,
    this.message,
  });

  CreateExpenseFieldData.fromJson(dynamic json) {

    cohortsData = json['cohortsData'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['cohortsData'] ?? {})]
        : List<Map<String, dynamic>>.from(json['cohortsData'] ?? []);
    expenseCategories = json['expenseCategories'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['expenseCategories'] ?? {})]
        : List<Map<String, dynamic>>.from(json['expenseCategories'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
    // if (json['cohortsData'] != null) {
    //   cohortsData = [];
    //   json['cohortsData'].forEach((v) {
    //     cohortsData?.add(CohortsData.fromJson(v));
    //   });
    // }
    // if (json['expenseCategories'] != null) {
    //   expenseCategories = [];
    //   json['expenseCategories'].forEach((v) {
    //     expenseCategories?.add(ExpenseCategories.fromJson(v));
    //   });
    // }
  }
  List<Map<String, dynamic>>? cohortsData;
  List<Map<String, dynamic>>? expenseCategories;
  int? status;
  String? message;

  /*Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cohortsData != null) {
      map['cohortsData'] = cohortsData?.map((v) => v.toJson()).toList();
    }
    if (expenseCategories != null) {
      map['expenseCategories'] = expenseCategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }*/

}

/// id : 48
/// name : "Delivery"
/// parent_id : null
/// deleted_at : null
/// created_at : "2023-06-08T15:23:24.000000Z"
/// updated_at : "2023-06-08T15:23:24.000000Z"
/// sub_categories : [{"id":49,"name":"Uber or Lyft Ride","parent_id":48,"deleted_at":null,"created_at":"2023-06-08T15:23:38.000000Z","updated_at":"2023-06-08T15:23:38.000000Z"},{"id":50,"name":"Ride to pick up car","parent_id":48,"deleted_at":null,"created_at":"2023-06-08T15:24:22.000000Z","updated_at":"2023-06-08T15:24:22.000000Z"}]

// class ExpenseCategories {
//   ExpenseCategories({
//       this.id,
//       this.isSelected,
//       this.name,
//       this.parentId,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.subCategories,});
//
//   ExpenseCategories.fromJson(dynamic json) {
//     id = json['id'];
//     isSelected = json['is_selected'];
//     name = json['name'];
//     parentId = json['parent_id'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     if (json['sub_categories'] != null) {
//       subCategories = [];
//       json['sub_categories'].forEach((v) {
//         subCategories?.add(SubCategories.fromJson(v));
//       });
//     }
//   }
//   int? id;
//   int? isSelected;
//   String? name;
//   dynamic parentId;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   List<SubCategories>? subCategories;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['parent_id'] = parentId;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     if (subCategories != null) {
//       map['sub_categories'] = subCategories?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }

/// id : 49
/// name : "Uber or Lyft Ride"
/// parent_id : 48
/// deleted_at : null
/// created_at : "2023-06-08T15:23:38.000000Z"
/// updated_at : "2023-06-08T15:23:38.000000Z"

// class SubCategories {
//   SubCategories({
//       this.id,
//       this.isSelected,
//       this.name,
//       this.expenseTo,
//       this.parentId,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,});
//
//   SubCategories.fromJson(dynamic json) {
//     id = json['id'];
//     isSelected = json['is_selected'];
//     name = json['name'];
//     expenseTo = json['expense_to'];
//     parentId = json['parent_id'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//
//   }
//   int? id;
//   int? isSelected;
//   String? name;
//   int? expenseTo;
//   int? parentId;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['parent_id'] = parentId;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
//
//
//
//
// }

/// id : 1
/// vehicle_id : 1821689
/// cohort : "Fair Returns LP LLC"
/// active : 1
/// deleted_at : null
/// created_at : "2022-12-30T17:32:34.000000Z"
/// updated_at : "2022-12-30T17:32:34.000000Z"
/// vehicles : [{"id":6,"vehicle_id":1919029,"vehicle_name":"2019 NISSAN SENTRA S SILVR","vin":"3N1AB7APXKY445778","make":"NISSAN","model":"SENTRA S SILVR","year":"2019","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":7,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":14193,"row_order":6,"note":null,"deleted_at":null,"created_at":"2023-02-28T07:58:53.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":7,"vehicle_id":1919031,"vehicle_name":"2022 MITSUBISHI MIRAGE ES SILVR","vin":"ML32AUHJ2NH002953","make":"MITSUBISHI","model":"MIRAGE ES SILVR","year":"2022","cohort_id":1,"earnings":800,"utilization_rate":0,"vehicle_status":7,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":12250,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-02-28T08:00:37.000000Z","updated_at":"2023-05-05T16:28:33.000000Z"},{"id":8,"vehicle_id":1927761,"vehicle_name":"2020 HYUNDAI ELANTRA SE GRAY","vin":"5NPD84LF4LH623887","make":"HYUNDAI","model":"ELANTRA SE GRAY","year":"2020","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":7,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":17270,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-02-28T08:01:25.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":9,"vehicle_id":2019187,"vehicle_name":"2018 NISSAN ROGUE S SILVR","vin":"5N1AT2MT4JC761637","make":"NISSAN","model":"ROGUE S SILVR","year":"2018","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":12250,"row_order":2,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-02-28T08:02:04.000000Z","updated_at":"2023-06-25T21:40:09.000000Z"},{"id":10,"vehicle_id":1910322,"vehicle_name":"2018 FORD ESCAPE SE BLACK","vin":"1FMCU0GD4JUB41847","make":"FORD","model":"ESCAPE SE BLACK","year":"2018","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":15625,"row_order":0,"note":"Complete","deleted_at":null,"created_at":"2023-02-28T08:03:15.000000Z","updated_at":"2023-04-30T21:50:50.000000Z"},{"id":11,"vehicle_id":1954133,"vehicle_name":"2019 KIA FORTE FE WHITE","vin":"3KPF24AD0KE059797","make":"KIA","model":"FORTE FE WHITE","year":"2019","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":13700,"row_order":0,"note":"Install Bouncie and insurance","deleted_at":null,"created_at":"2023-02-28T08:03:38.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":12,"vehicle_id":1906497,"vehicle_name":"2021 KIA RIO LX WHITE","vin":"3KPA24AD2ME386389","make":"KIA","model":"RIO LX WHITE","year":"2021","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":4,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":11500,"row_order":0,"note":"Registration","deleted_at":null,"created_at":"2023-02-28T08:04:29.000000Z","updated_at":"2023-06-25T21:41:54.000000Z"},{"id":14,"vehicle_id":1946279,"vehicle_name":"2021 TOYOTA COROLLA LE","vin":"5YFEPMAE1MP244657","make":"TOYOTA","model":"COROLLA LE","year":"2021","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":16150,"row_order":3,"note":"Do State Inspection","deleted_at":null,"created_at":"2023-03-02T20:31:54.000000Z","updated_at":"2023-05-10T16:53:36.000000Z"},{"id":15,"vehicle_id":2035600,"vehicle_name":"2022 VOLKSWAGEN PASSAT SE","vin":"1VWSA7A35NC008055","make":"VOLKSWAGEN","model":"PASSAT SE","year":"2022","cohort_id":1,"earnings":null,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":17350,"row_order":1,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-03-02T20:32:54.000000Z","updated_at":"2023-06-25T21:43:08.000000Z"},{"id":16,"vehicle_id":2009739,"vehicle_name":"2020 NISSAN ALTIMA S","vin":"1N4BL4BV6LC238377","make":"NISSAN","model":"ALTIMA S","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":4,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":15000,"row_order":7,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-03-02T20:33:56.000000Z","updated_at":"2023-06-25T21:39:27.000000Z"},{"id":19,"vehicle_id":2014826,"vehicle_name":"2019 CHEVROLET SPARK LS","vin":"KL8CB6SA2KC751210","make":"CHEVROLET","model":"SPARK LS","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":11850,"row_order":4,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-03-06T18:58:05.000000Z","updated_at":"2023-06-25T21:37:56.000000Z"},{"id":20,"vehicle_id":2035615,"vehicle_name":"2021 HYUNDAI ELANTRA SE","vin":"5NPLL4AG8MH052993","make":"HYUNDAI","model":"ELANTRA SE","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":5,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":15625,"row_order":0,"note":"Waiting for car in copart auction","deleted_at":null,"created_at":"2023-03-07T00:07:39.000000Z","updated_at":"2023-06-02T13:09:13.000000Z"},{"id":22,"vehicle_id":2025070,"vehicle_name":"2020 CHEVROLET EQUINOX LT","vin":"2GNAXJEVXL6137380","make":"CHEVROLET","model":"EQUINOX LT","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":19375,"row_order":8,"note":"Update Turo & NTTA","deleted_at":null,"created_at":"2023-03-13T21:41:17.000000Z","updated_at":"2023-06-25T21:35:25.000000Z"},{"id":23,"vehicle_id":2062415,"vehicle_name":"2022 NISSAN ALTIMA","vin":"1N4BL4BV2NN321098","make":"NISSAN","model":"ALTIMA","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":18705,"row_order":9,"note":"Waiting for Aufar","deleted_at":null,"created_at":"2023-03-13T21:56:10.000000Z","updated_at":"2023-06-17T16:03:16.000000Z"},{"id":24,"vehicle_id":2081255,"vehicle_name":"2018 NISSAN ROGUE SPORT S","vin":"JN1BJ1CR2JW262027","make":"NISSAN","model":"ROGUE SPORT S","year":"2018","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":4,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":16725,"row_order":10,"note":"pay dispatcher on delivery","deleted_at":null,"created_at":"2023-03-13T21:58:57.000000Z","updated_at":"2023-07-02T17:30:22.000000Z"},{"id":25,"vehicle_id":12132145,"vehicle_name":"2019 HYUNDAI ELANTRA SE","vin":"KMHD74LF7KU768411","make":"HYUNDAI","model":"ELANTRA SE","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":13800,"row_order":11,"note":"Pay Aufar $950","deleted_at":null,"created_at":"2023-03-15T22:43:45.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":26,"vehicle_id":1442532621,"vehicle_name":"2021 NISSAN ALTIMA","vin":"1N4BL4BV4MN403591","make":"NISSAN","model":"ALTIMA","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":18640,"row_order":12,"note":null,"deleted_at":null,"created_at":"2023-03-21T18:14:34.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":27,"vehicle_id":2019181,"vehicle_name":"2019 FORD ESCAPE SEL","vin":"1FMCU9HD3KUB24431","make":"FORD","model":"ESCAPE SEL","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":3,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":21575,"row_order":5,"note":"Register car","deleted_at":null,"created_at":"2023-03-23T15:52:07.000000Z","updated_at":"2023-06-02T13:10:01.000000Z"},{"id":28,"vehicle_id":1997676,"vehicle_name":"2019 MITSUBISHI MIRAGE G4","vin":"2023ML32F3FJ2KHF16041","make":"MITSUBISHI","model":"MIRAGE G4","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":2,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":8375,"row_order":0,"note":"Paid Aufar $1300 add receipt","deleted_at":null,"created_at":"2023-03-27T20:15:32.000000Z","updated_at":"2023-05-05T16:28:05.000000Z"},{"id":29,"vehicle_id":2017215,"vehicle_name":"2020 CHEVROLET EQUINOX LS","vin":"2GNAXSEV4L6184362","make":"CHEVROLET","model":"EQUINOX LS","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":null,"wholesale_amount":16175,"row_order":0,"note":"Registration pending","deleted_at":null,"created_at":"2023-04-04T14:24:57.000000Z","updated_at":"2023-06-25T21:36:14.000000Z"},{"id":30,"vehicle_id":2057663,"vehicle_name":"2019 KIA SORENTO L","vin":"5XYPG4A33KG465458","make":"KIA","model":"SORENTO L","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":null,"wholesale_amount":21275,"row_order":0,"note":"AC fixed , fix over heating","deleted_at":null,"created_at":"2023-04-04T14:25:51.000000Z","updated_at":"2023-06-17T16:02:18.000000Z"},{"id":31,"vehicle_id":234,"vehicle_name":"2020 MAZDA 6 GRAND","vin":"JM1GL1WY5L1511176","make":"MAZDA","model":"6 GRAND","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":44364,"wholesale_amount":28450,"row_order":0,"note":"Pay Aufar $750 pick up check Adesa","deleted_at":null,"created_at":"2023-04-06T17:37:55.000000Z","updated_at":"2023-04-24T14:58:18.000000Z"},{"id":32,"vehicle_id":2047922,"vehicle_name":"2022 FORD ESCAPE SE","vin":"1FMCU9G66NUA46265","make":"FORD","model":"ESCAPE SE","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":29586,"wholesale_amount":26000,"row_order":0,"note":"Update the plate in NTTA & Turo","deleted_at":null,"created_at":"2023-04-06T17:43:22.000000Z","updated_at":"2023-06-25T21:32:56.000000Z"},{"id":33,"vehicle_id":1997714,"vehicle_name":"2017 NISSAN ROGUE SPORT","vin":"1FMCU9HD3KUB24432","make":"NISSAN","model":"ROGUE SPORT","year":"2017","cohort_id":1,"earnings":null,"utilization_rate":null,"vehicle_status":5,"active":1,"platform":"TURO","mileage":61497,"wholesale_amount":13500,"row_order":0,"note":"Install Bouncie and get insurance","deleted_at":null,"created_at":"2023-04-20T00:10:34.000000Z","updated_at":"2023-05-05T16:27:29.000000Z"},{"id":34,"vehicle_id":14141243,"vehicle_name":"2022 NISSAN ALTIMA","vin":"1N4BL4BV3NN351341","make":"NISSAN","model":"ALTIMA","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":26000,"wholesale_amount":21450,"row_order":0,"note":"Fix bumper & pay Aufar","deleted_at":null,"created_at":"2023-04-26T22:35:46.000000Z","updated_at":"2023-05-25T07:13:45.000000Z"},{"id":35,"vehicle_id":2068960,"vehicle_name":"2021 SUBARU LEGACY PREMIUM","vin":"4S3BWAF62M3019825","make":"SUBARU","model":"LEGACY PREMIUM","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":35871,"wholesale_amount":24550,"row_order":0,"note":"State Inspection & Registration","deleted_at":null,"created_at":"2023-04-26T22:37:37.000000Z","updated_at":"2023-07-08T15:42:30.000000Z"},{"id":36,"vehicle_id":124235425,"vehicle_name":"2021 NISSAN VERSA SV","vin":"3N1CN8EV9ML866261","make":"NISSAN","model":"VERSA SV","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":41457,"wholesale_amount":17100,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-05-01T22:29:02.000000Z","updated_at":"2023-05-25T07:14:11.000000Z"},{"id":37,"vehicle_id":2147483647,"vehicle_name":"2018 FORD FUSION","vin":"3FA6P0HDXJR227720","make":"FORD","model":"FUSION","year":"2018","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":53163,"wholesale_amount":14825,"row_order":0,"note":"Car will be delivered 05/26","deleted_at":null,"created_at":"2023-05-23T16:14:06.000000Z","updated_at":"2023-06-02T13:01:42.000000Z"},{"id":38,"vehicle_id":875,"vehicle_name":"2000 Fair Returns","vin":"FAIRRETURN2000","make":"Fair","model":"Returns","year":"2000","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"0","mileage":0,"wholesale_amount":0,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-05-25T14:47:08.000000Z","updated_at":"2023-05-25T14:59:03.000000Z"},{"id":39,"vehicle_id":214142124,"vehicle_name":"2020 MITSUBISHI OUTLANDER SPORT","vin":"JA4AP3AU8LU017512","make":"MITSUBISHI","model":"OUTLANDER SPORT","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":50988,"wholesale_amount":14425,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-06T23:53:31.000000Z","updated_at":"2023-06-06T23:53:46.000000Z"},{"id":40,"vehicle_id":27263626,"vehicle_name":"2020 CHEVROLET EQUINOX","vin":"2GNAXUEV6L6187372","make":"CHEVROLET","model":"EQUINOX","year":"2020","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":42825,"wholesale_amount":19050,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-17T00:53:05.000000Z","updated_at":"2023-06-17T00:53:45.000000Z"},{"id":41,"vehicle_id":17171616,"vehicle_name":"2022 NISSAN ALTIMA S WHITE","vin":"1N4BL4BV7NN313059","make":"NISSAN","model":"ALTIMA S WHITE","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":24263,"wholesale_amount":20375,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-17T01:06:28.000000Z","updated_at":"2023-07-18T22:03:07.000000Z"},{"id":43,"vehicle_id":1442323,"vehicle_name":"2022 NISSAN ALTIMA GRAY","vin":"1N4BL4DV7NN400196","make":"NISSAN","model":"ALTIMA GRAY","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":19135,"wholesale_amount":19850,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-25T20:35:39.000000Z","updated_at":"2023-07-18T22:01:49.000000Z"},{"id":44,"vehicle_id":2311,"vehicle_name":"2021 NISSAN VERSA SV","vin":"3N1CN8EV8ML924120","make":"NISSAN","model":"VERSA SV","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":23983,"wholesale_amount":17100,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-25T20:39:59.000000Z","updated_at":"2023-06-25T20:39:59.000000Z"},{"id":45,"vehicle_id":31313232,"vehicle_name":"2021 FORD EXPLORER","vin":"1FMSK8DH7MGB13969","make":"FORD","model":"EXPLORER","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Rent","mileage":44907,"wholesale_amount":24325,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-06-30T23:30:06.000000Z","updated_at":"2023-06-30T23:30:06.000000Z"},{"id":46,"vehicle_id":211312,"vehicle_name":"2022 TOYOTA COROLLA WHITE","vin":"5YFEPMAE2NP378725","make":"TOYOTA","model":"COROLLA WHITE","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":12999,"wholesale_amount":20975,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-08T18:08:37.000000Z","updated_at":"2023-07-18T22:02:32.000000Z"},{"id":47,"vehicle_id":234332,"vehicle_name":"2022 NISSAN ALTIMA S SILVER2","vin":"1N4BL4BV6NN398492","make":"NISSAN","model":"ALTIMA S SILVER2","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":25859,"wholesale_amount":20075,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-08T18:14:43.000000Z","updated_at":"2023-07-28T23:21:09.000000Z"},{"id":48,"vehicle_id":24637468,"vehicle_name":"2021 NISSAN SENTRA","vin":"3N1AB8CV5MY265824","make":"NISSAN","model":"SENTRA","year":"2021","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":1,"platform":"Turo","mileage":40628,"wholesale_amount":19050,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-08T18:18:00.000000Z","updated_at":"2023-07-08T18:18:00.000000Z"},{"id":49,"vehicle_id":1112,"vehicle_name":"2019 FORD FUSION SE RED","vin":"3FA6P0HD7KR232956","make":"FORD","model":"FUSION SE RED","year":"2019","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":50081,"wholesale_amount":15625,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-13T19:49:01.000000Z","updated_at":"2023-07-13T19:49:01.000000Z"},{"id":50,"vehicle_id":134,"vehicle_name":"2022 TOYOTA COROLLA LE BLACK","vin":"JTDEPMAE5NJ191788","make":"TOYOTA","model":"COROLLA LE BLACK","year":"2022","cohort_id":1,"earnings":0,"utilization_rate":0,"vehicle_status":1,"active":0,"platform":"Turo","mileage":35142,"wholesale_amount":19100,"row_order":0,"note":null,"deleted_at":null,"created_at":"2023-07-13T19:54:18.000000Z","updated_at":"2023-07-13T19:54:18.000000Z"}]
/// expense_to : [{"id":1,"cohort_id":1,"expense_to":"Fair Returns LP","status":1,"deleted_at":null,"created_at":"2023-07-30T21:57:02.000000Z","updated_at":"2023-07-30T21:57:02.000000Z"},{"id":3,"cohort_id":1,"expense_to":"Investor","status":1,"deleted_at":null,"created_at":"2023-07-31T18:54:51.000000Z","updated_at":"2023-07-31T18:54:51.000000Z"},{"id":4,"cohort_id":1,"expense_to":"Turo","status":1,"deleted_at":null,"created_at":"2023-07-31T18:56:02.000000Z","updated_at":"2023-07-31T18:56:02.000000Z"}]

// class CohortsData {
//   CohortsData({
//       this.id,
//       this.vehicleId,
//       this.cohort,
//       this.active,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.isSelected,
//       this.vehicles,
//       this.expenseTo,});
//
//   CohortsData.fromJson(dynamic json) {
//     id = json['id'];
//     vehicleId = json['vehicle_id'];
//     cohort = json['cohort'];
//     active = json['active'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     isSelected = json['is_selected'];
//     if (json['vehicles'] != null) {
//       vehicles = [];
//       json['vehicles'].forEach((v) {
//         vehicles?.add(Vehicles.fromJson(v));
//       });
//     }
//     if (json['expense_to'] != null) {
//       expenseTo = [];
//       json['expense_to'].forEach((v) {
//         expenseTo?.add(ExpenseTo.fromJson(v));
//       });
//     }
//   }
//   int? id;
//   int? vehicleId;
//   String? cohort;
//   int? active;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   int? isSelected;
//   List<Vehicles>? vehicles;
//   List<ExpenseTo>? expenseTo;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['vehicle_id'] = vehicleId;
//     map['cohort'] = cohort;
//     map['active'] = active;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['is_selected'] = isSelected;
//     if (vehicles != null) {
//       map['vehicles'] = vehicles?.map((v) => v.toJson()).toList();
//     }
//     if (expenseTo != null) {
//       map['expense_to'] = expenseTo?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }

/// id : 1
/// cohort_id : 1
/// expense_to : "Fair Returns LP"
/// status : 1
/// deleted_at : null
/// created_at : "2023-07-30T21:57:02.000000Z"
/// updated_at : "2023-07-30T21:57:02.000000Z"

// class ExpenseTo {
//   ExpenseTo({
//       this.id,
//       this.cohortId,
//       this.isSelected,
//       this.expenseTo,
//       this.status,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,});
//
//   ExpenseTo.fromJson(dynamic json) {
//     id = json['id'];
//     cohortId = json['cohort_id'];
//     isSelected = json['is_selected'];
//     expenseTo = json['expense_to'];
//     status = json['status'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   int? id;
//   int? cohortId;
//   int? isSelected;
//   String? expenseTo;
//   int? status;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['cohort_id'] = cohortId;
//     map['expense_to'] = expenseTo;
//     map['status'] = status;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }
//
// class Images {
//   Images({
//       this.id,
//       this.path});
//
//   Images.fromJson(dynamic json) {
//     id = json['id'];
//     path = json['path'];
//   }
//   int? id;
//   String? path;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['path'] = path;
//     return map;
//   }
//
// }

/// id : 6
/// vehicle_id : 1919029
/// vehicle_name : "2019 NISSAN SENTRA S SILVR"
/// vin : "3N1AB7APXKY445778"
/// make : "NISSAN"
/// model : "SENTRA S SILVR"
/// year : "2019"
/// cohort_id : 1
/// earnings : null
/// utilization_rate : 0
/// vehicle_status : 7
/// active : 0
/// platform : "Turo"
/// mileage : null
/// wholesale_amount : 14193
/// row_order : 6
/// note : null
/// deleted_at : null
/// created_at : "2023-02-28T07:58:53.000000Z"
/// updated_at : "2023-04-24T14:58:18.000000Z"

// class Vehicles {
//   Vehicles({
//       this.id,
//       this.vehicleId,
//       this.vehicleName,
//       this.vin,
//       this.make,
//       this.model,
//       this.year,
//       this.cohortId,
//       this.isSelected,
//       this.earnings,
//       this.utilizationRate,
//       this.vehicleStatus,
//       this.active,
//       this.platform,
//       this.mileage,
//       this.wholesaleAmount,
//       this.rowOrder,
//       this.note,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.images,
//       this.isMultipleVehSelected
//   });
//
//   Vehicles.fromJson(dynamic json) {
//     id = json['id'];
//     vehicleId = json['vehicle_id'];
//     vehicleName = json['vehicle_name'];
//      vehicleNumber = json['vehicle_number'];
//     vin = json['vin'];
//     make = json['make'];
//     model = json['model'];
//     year = json['year'];
//     cohortId = json['cohort_id'];
//     earnings = json['earnings'];
//     utilizationRate = json['utilization_rate'];
//     vehicleStatus = json['vehicle_status'];
//     active = json['active'];
//     platform = json['platform'];
//     mileage = json['mileage'];
//     wholesaleAmount = json['wholesale_amount'];
//     rowOrder = json['row_order'];
//     note = json['note'];
//     isSelected = json['is_selected'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     isMultipleVehSelected = false;
//     if (json['images'] != null) {
//       images = [];
//       json['images'].forEach((v) {
//         images?.add(Images.fromJson(v));
//       });
//     }
//   }
//   int? id;
//   int? vehicleId;
//   String? vehicleName;
//     String? vehicleNumber;
//   String? vin;
//   String? make;
//   String? model;
//   String? year;
//   int? cohortId;
//   int? isSelected;
//   dynamic earnings;
//   int? utilizationRate;
//   int? vehicleStatus;
//   int? active;
//   String? platform;
//   dynamic mileage;
//   int? wholesaleAmount;
//   int? rowOrder;
//   dynamic note;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   bool? isMultipleVehSelected;
//   List<Images>? images;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['vehicle_id'] = vehicleId;
//     map['vehicle_name'] = vehicleName;
//        map['vehicle_number'] = vehicleNumber;
//     map['vin'] = vin;
//     map['make'] = make;
//     map['model'] = model;
//     map['year'] = year;
//     map['cohort_id'] = cohortId;
//     map['earnings'] = earnings;
//     map['utilization_rate'] = utilizationRate;
//     map['vehicle_status'] = vehicleStatus;
//     map['active'] = active;
//     map['platform'] = platform;
//     map['mileage'] = mileage;
//     map['wholesale_amount'] = wholesaleAmount;
//     map['row_order'] = rowOrder;
//     map['note'] = note;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['is_selected'] = isSelected;
//     if (images != null) {
//       map['images'] = images?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
// }

class CreateExpenseRequestParam{
  String? expenseDate = '';
  String? vehicleId = '';
  String? categoryId = '';
  String? subcategoryId = '';
  String? expenseAmount = '';
  String? expenseDescription = '';
  String? majorRepair = '';
  String? expenseTo = '';
  int? cohortId =0;
  String? vin = '';
  String? tagId = '';
  String? tagName = '';
  bool? isEdit = false;
  List<File>? imageFile = [];

  CreateExpenseRequestParam({
    this.expenseDate,
    this.vehicleId,
    this.categoryId,
    this.subcategoryId,
    this.expenseAmount,
    this.expenseDescription,
    this.majorRepair,
    this.expenseTo,
    this.cohortId,
    this.tagName,
    this.vin,
    this.tagId,
    this.imageFile,
    this.isEdit
  });
}