import { AzureFunction, Context } from "@azure/functions";

const serviceBusQueueTrigger: AzureFunction = async function (context: Context, myQueueItem: any): Promise<void> {
  context.log('ServiceBus queue trigger function processed message:', myQueueItem);
};

export default serviceBusQueueTrigger;
