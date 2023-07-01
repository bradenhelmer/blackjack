// index.js
// ~~~~~~~~
// Cloud function definitions.
const functions = require("firebase-functions");
const {initializeApp} = require('firebase-admin/app');
const { getFirestore, Timestamp, FieldValue } = require('firebase-admin/firestore');

initializeApp();
const db = getFirestore();
collectionName = 'Users';

exports.updateUserWinRate = functions.firestore
    .document('Users/{id}')
    .onUpdate(async (change, context) => {
        
        const newValue = change.after.data();
        if (gamesPlayed === 0){
            return;
        }
        const newWinRate = (newValue.gamesWon / newValue.gamesPlayed) * 100;

        const docRef = db.collection(collectionName).doc(newValue.id);
        const update = await docRef.update({winRate: newWinRate});
    });
