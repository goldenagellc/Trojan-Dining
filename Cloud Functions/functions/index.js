// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database
const admin = require('firebase-admin');
admin.initializeApp();

// Web scraping libraries
const axios = require('axios');

// My code
const URLBuilder = require('./URLBuilder');
const WebScraper = require('./WebScraper');

// let url = URLBuilder.url(URLBuilder.Days.TODAY);
// console.log(url);
//
// let scraper = new WebScraper();
//
// axios.get(url)
//     .then(response => {
//
//         scraper.scrape(response.data);
//         let menu = scraper.menuBuilder.menu;
//
//         console.log(menu);
//         console.log(menu[0].dateText());
//         console.log(menu[0].shortName());
//         console.log(menu[0].halls[2].decodedName());
//
//     })
//     .catch(error => {
//         console.log(error);
//     });


// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
// exports.addMessage = functions.https.onRequest(async (req, res) => {
//     // Grab the text parameter.
//     const original = req.query.text;
//     // Push the new message into the Realtime Database using the Firebase Admin SDK.
//     const snapshot = await admin.database().ref('/messages').push({original: original});
//     // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
//     res.redirect(303, snapshot.ref.toString());
// });

// Listens for new messages added to /messages/:pushId/original and creates an
// uppercase version of the message to /messages/:pushId/uppercase
// exports.makeUppercase = functions.database.ref('/messages/{pushId}/original')
//     .onCreate((snapshot, context) => {
//         // Grab the current value of what was written to the Realtime Database.
//         const original = snapshot.val();
//         console.log('Uppercasing', context.params.pushId, original);
//         const uppercase = original.toUpperCase();
//         // You must return a Promise when performing asynchronous tasks inside a Functions such as
//         // writing to the Firebase Realtime Database.
//         // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
//         return snapshot.ref.parent.child('uppercase').set(uppercase);
//     });

// exports.scheduledFunctionCrontab = functions.pubsub.schedule('0 7 * * *')
// //     .timeZone('America/Los_Angeles')
// //     .onRun((context => {
// //         console.log('This should run every day at 7:00 AM Pacific Time');
// //         return null;
// //     }))

exports.dailyMenuScraping = functions.pubsub.schedule('1 0 * * *')
    .timeZone('America/Los_Angeles')
    .onRun((context => {

        let url = URLBuilder.url(URLBuilder.Days.TODAY);
        console.log("Menu URL: ".concat(url));

        let scraper = new WebScraper();

        return new Promise((resolve, reject) => {
            axios.get(url)
                .then(response => {
                    let promises = [];

                    // Scrape the raw HTML text to build menu data structure
                    scraper.scrape(response.data);
                    let menu = scraper.menuBuilder.menu;
                    console.log("Successfully scraped menu!");
                    console.log(menu);

                    // Save that menu to Firestore
                    let menuRef = admin.firestore().collection("Menu");
                    // example path: /Menu/
                    for (var i = 0; i < menu.length; i++) {
                        let meal = menu[i];

                        let dateRef = menuRef.doc(meal.dateText());
                        // example path: /Menu/January 12, 2020/
                        let mealRef = dateRef.collection(meal.shortName());
                        // example path: /Menu/January 12, 2020/Breakfast/

                        // let date = new Date(meal.dateText());
                        // let timestamp = new admin.firestore.Timestamp(date.getUTCSeconds(), 0);

                        for (var j = 0; j < meal.halls.length; j++) {
                            let hall = meal.halls[j];

                            let hallRef = mealRef.doc(hall.decodedName());
                            // example path: /Menu/January 12, 2020/Breakfast/Everybody's Kitchen/

                            let batch = admin.firestore().batch();

                            batch.set(hallRef, {
                                sections: hall.sects.map(x => x.shortName())
                            });

                            for (var k = 0; k < hall.sects.length; k++) {
                                let sect = hall.sects[k];

                                let sectRef = hallRef.collection(sect.shortName());
                                // example path: /Menu/January 12, 2020/Breakfast/Everybody's Kitchen/Hot Line FOODS/

                                for (var l = 0; l < sect.foods.length; l++) {
                                    let food = sect.foods[l];

                                    batch.set(sectRef.doc(), {
                                        name: food.name,
                                        section: sect.name,
                                        hall: hall.decodedName(),
                                        attributes: food.allergens
                                    });
                                    // example path: /Menu/January 12, 2020/Breakfast/Everybody's Kitchen/Hot Line FOODS/AutoGenFoodDocID/
                                }
                            }

                            promises.push(batch.commit());
                        }
                    }
                    // eslint-disable-next-line promise/no-nesting
                    Promise.all(promises)
                        .then(response => {
                            resolve();
                            return null;
                        })
                        .catch(error => {
                            console.log(error);
                            reject(error);
                            return null;
                        });
                    return null;
                })
                .catch(error => {
                    console.log(error);
                    reject(error);
                    return null;
                });
        })
    }));

exports.dailyPushNotification = functions.pubsub.schedule('0 5 * * *')
    .timeZone('America/Los_Angeles')
    .onRun((context => {

        /*https://firebase.google.com/docs/reference/admin/node/TopicMessage*/
        /*https://firebase.google.com/docs/reference/admin/node/admin.messaging.Aps.html*/
        /*https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html*/
        let message = {
            topic: 'NewMeals',
            // notification: {
            //     title: type: String,
            //     body: type: String
            // },
            apns: {
                // headers: {
                //     'apns-priority': '5'
                // },
                payload: {
                    aps: {
                        // alert: type: admin.messaging.ApsAlert,
                        // badge: type: Int,
                        // category: type: String,
                        contentAvailable: true,
                        // mutableContent: false,
                        // sound: type: admin.messaging.CriticalSound,
                        // threadId: type: String
                    }
                }
            },
            // data: {
            //     'key': 'value'
            // }
        };

        admin.messaging().send(message)
            .then((response) => {
                // Notification Delivery: successful
                return null;
            }).catch((error) => {
                // Notification Delivery: failed
            });
        return null;
    }));