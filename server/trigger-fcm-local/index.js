/**
 * Firebase Cloud Messaging (FCM) can be used to send messages to clients on iOS, Android and Web.
 *
 * This sample uses FCM to send two types of messages to clients that are subscribed to the `news`
 * topic. One type of message is a simple notification message (display message). The other is
 * a notification message (display notification) with platform specific customizations. For example,
 * a badge is added to messages that are sent to iOS devices.
 */
const https = require('https');
const { google } = require('googleapis');

const PROJECT_ID = 'appwrite-hackathon';
const HOST = 'fcm.googleapis.com';
const PATH = '/v1/projects/' + PROJECT_ID + '/messages:send';
const MESSAGING_SCOPE = 'https://www.googleapis.com/auth/firebase.messaging';
const SCOPES = [MESSAGING_SCOPE];

/**
 * Get a valid access token.
 */
// [START retrieve_access_token]
function getAccessToken() {
    return new Promise(function (resolve, reject) {
        const key = require('../trigger-fcm-local/service-account.json');
        const jwtClient = new google.auth.JWT(
            key.client_email,
            null,
            key.private_key,
            SCOPES,
            null
        );
        jwtClient.authorize(function (err, tokens) {
            if (err) {
                reject(err);
                return;
            }
            resolve(tokens.access_token);
        });
    });
}
// [END retrieve_access_token]

/**
 * Send HTTP request to FCM with given message.
 *
 * @param {object} fcmMessage will make up the body of the request.
 */
function sendFcmMessage(fcmMessage) {
    getAccessToken().then(function (accessToken) {
        const options = {
            hostname: HOST,
            path: PATH,
            method: 'POST',
            // [START use_access_token]
            headers: {
                'Authorization': 'Bearer ' + accessToken
            }
            // [END use_access_token]
        };

        const request = https.request(options, function (resp) {
            resp.setEncoding('utf8');
            resp.on('data', function (data) {
                console.log('Message sent to Firebase for delivery, response:');
                console.log(data);
            });
        });

        request.on('error', function (err) {
            console.log('Unable to send message to Firebase');
            console.log(err);
        });

        request.write(JSON.stringify(fcmMessage));
        request.end();
    });
}

/**
 * Construct a JSON object that will be used to customize
 * the messages sent to iOS and Android devices.
 */
function buildMobileMessage() {
    return {
        'message': {
            'token': 'd-EIgAVxTneFLGFEOlHluX:APA91bGpfGH9pILn71LdfssEoQODJ1wNif-d_Z0tIW02od79ARZnuGzzqo0F2x6FE-JI93NBgICRBnd_PgTsWl49w-Xt3-l98791No6U_qaVkAPQTXRbxDS2DY8Bw78B-w3cGccnhOZ7',
            'notification': {
                'title': 'New Login Detected',
                'body': 'Logged in web with your credentials'
            }
        }
    };
}

/**
 * Construct a JSON object that will be used to define the
 * common parts of a notification message that will be sent
 * to any app instance subscribed to the news topic.
 */
function buildWebMessage() {
    return {
        'message': {
            'token': 'd5hwSSibVKUSa2a5_8IfkC:APA91bEi330DI-VbHHFR_GPenvGjY-ydpB6sJeKVxftBEhfBzjTr5M-GfHu1SfcaVe1OCUrVjdcdgleI_SVtGSPnuqtM2XlXnVBVpODbaYmfilkjkUSrLvjaMafNPjVrgLOhREOaaSKu',
            'data': {
                'userToken': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiI2NDcxZmQzZWU0MDIxNWQzMjA3NCIsInNlc3Npb25JZCI6IjY0NzFmZDU2NWIyNmYzMWY4NjdmIiwiZXhwIjoxNjg1ODY5MTUyfQ.6pJrPChBX2Ka64mN7PQ8Idjpo8dGhuTwDX8H1Q6XwoY',
                'deviceToken': 'd-EIgAVxTneFLGFEOlHluX:APA91bGpfGH9pILn71LdfssEoQODJ1wNif-d_Z0tIW02od79ARZnuGzzqo0F2x6FE-JI93NBgICRBnd_PgTsWl49w-Xt3-l98791No6U_qaVkAPQTXRbxDS2DY8Bw78B-w3cGccnhOZ7'
            }
        }
    };
}

const messageFor = process.argv[2];
if (messageFor && messageFor == 'web') {
    const webMessage = buildWebMessage();
    console.log('FCM request body for web message:');
    console.log(JSON.stringify(webMessage, null, 2));
    sendFcmMessage(buildWebMessage());
} else if (messageFor && messageFor == 'mobile') {
    const mobileMessage = buildMobileMessage();
    console.log('FCM request body for mobile message:');
    console.log(JSON.stringify(mobileMessage, null, 2));
    sendFcmMessage(buildMobileMessage());
} else {
    console.log('Invalid command. Please use one of the following:\n'
        + 'node index.js web\n'
        + 'node index.js mobile');
}