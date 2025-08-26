import { app } from "@azure/functions";
export async function cliforwarderQueue(message, context) {
    context.log('Service bus queue function processed message:', message);
}
app.serviceBusQueue('cliforwarderQueue', {
    connection: '',
    queueName: 'cli',
    handler: cliforwarderQueue
});
import { app } from "@azure/functions";
export async function cliforwarder(message, context) {
    context.log('Service bus topic function processed message:', message);
}
app.serviceBusTopic('cliforwarder', {
    connection: '',
    topicName: 'clitopic',
    subscriptionName: 'clitopic',
    handler: cliforwarder
});
