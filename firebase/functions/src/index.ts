import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp()

const db = admin.firestore()

exports.changeLastMessage = functions.firestore
  .document('rooms/{roomId}/messages/{messageId}')
  .onWrite((change, context) => {
    const message = change.after.data()
    if (message) {
      return db.doc('rooms/' + context.params.roomId).update({
        lastMessages: [message],
      })
    } else {
      return null
    }
  });


exports.changeMessageSeen = functions.firestore
  .document('users/{userId}')
  .onUpdate((change, context) => {
    const user: any = change.after.data()
    if (user && user.isOnline) {
        functions.logger.log("Updating for: ", context.params.userId);
        const messages = db.collection('rooms/' + user.lastSeenRoom + '/messages').where('status', '==', 'delivered');
         messages.onSnapshot((result) => {
            functions.logger.log("Updating to seen: ", result.docs.length);
            result.docs.map(message => {
                if(message.get('authorId') != context.params.userId) {
                    message.ref.update({
                        status: 'seen'
                    });
                }
            });
            return true;
        });
        
        return true;
    } else {
      return null;
    }
  })


exports.changeMessageStatus = functions.firestore
  .document('rooms/{roomId}/messages/{messageId}')
  .onWrite(async (change, context) => {
    const message = change.after.data()
    if (message) {
      if (['delivered', 'seen', 'sent'].includes(message.status)) {
        return null
      } else {
        change.after.ref.update({
            status: 'delivered',
        });
        functions.logger.log('New message sending...:');
        const room = await db.collection('rooms').doc(context.params.roomId).get();
        functions.logger.log('Sending room:', room);
        const userId = room.get('userIds').filter((x: any) => x != message.authorId)[0] || null;
        if(userId != null) {
            const user = await db.collection('users').doc(userId).get();
            functions.logger.log('Sending to user id:', user.id);
            //if(!user.get('isOnline')) {
                const payload = {
                    topic : "/topics/"+user.id,
                    notification: {
                        title: 'New Message from You Pay',
                        body: message.text
                    },
                    data: {
                        type: 'message',
                        roomId: context.params.roomId,
                        userIds: JSON.stringify(room.get('userIds')),
                        metadata: JSON.stringify(room.get('metadata')),
                    }
                };
                
                admin.messaging().send(payload).then((response) => {
                    // Response is a message ID string.
                    functions.logger.log('Successfully sent message:', response+"/"+message.text);
                    return {success: true};
                }).catch((error) => {
                    return {error: error.code};
                });
            //} 
            // else {
            //     return change.after.ref.update({
            //         status: 'seen',
            //     });
            // }
        }
        return null;
      }
    } else {
      return null
    }
  });