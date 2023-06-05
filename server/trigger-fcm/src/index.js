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
    const key = require('../trigger-fcm/resources/service-account.json');
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
function buildMobileMessage(receiverDeviceToken) {
  return {
    'message': {
      'token': receiverDeviceToken,
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
function buildWebMessage(receiverDeviceToken, userToken, senderDeviceToken) {
  return {
    'message': {
      'token': receiverDeviceToken,
      'data': {
        'userToken': userToken,
        'deviceToken': senderDeviceToken
      }
    }
  };
}

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status)' - function to return text response. Status code defaults to 200
    'json(obj, status)' - function to return JSON response. Status code defaults to 200

  If an error is thrown, a response with code 500 will be returned.
*/

module.exports = async function (req, res) {
  const payload = req.payload;

  res.json({
    payload: payload,
    messageFor: 'messageFor - ' + payload.messageFor,
    token: 'token - ' + payload.token,
    userToken: 'userToken - ' + payload.userToken,
    deviceToken: 'deviceToken - ' + payload.deviceToken,
  });

  // let messageFor = '', token = '', userToken = '', deviceToken = '';

  // try {
  //   const payload = req.payload;
  //   messageFor = payload.messageFor;
  //   if (messageFor && messageFor === 'web') {
  //     token = payload.token;
  //     userToken = payload.userToken;
  //     deviceToken = payload.deviceToken;
  //   } else {
  //     token = payload.token;
  //   }
  // } catch (err) {
  //   console.log(err);
  //   throw new Error('Payload is invalid.');
  // }

  // if (messageFor && messageFor === 'web') {
  //   const webMessage = buildWebMessage(token, userToken, deviceToken);

  //   console.log('FCM request body for web message:');
  //   console.log(JSON.stringify(webMessage, null, 2));

  //   sendFcmMessage(buildWebMessage());
  // } else if (messageFor && messageFor === 'mobile') {
  //   const mobileMessage = buildMobileMessage(token);

  //   console.log('FCM request body for mobile message:');
  //   console.log(JSON.stringify(mobileMessage, null, 2));

  //   sendFcmMessage(buildMobileMessage());
  // } else {
  //   console.log('Invalid messageFor received. Please use one of the following:\n'
  //     + 'web\n'
  //     + 'mobile');
  // }

  // if (messageFor === 'web' || messageFor === 'mobile') {
  //   res.send('Message send to ' + messageFor);
  // } else {
  //   res.send('Message failed to send to ' + messageFor);
  // }
};
