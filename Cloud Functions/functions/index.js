// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database
const admin = require('firebase-admin');
admin.initializeApp();

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

exports.scheduledFunctionCrontab = functions.pubsub.schedule('0 7 * * *')
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
    }))