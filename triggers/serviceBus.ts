import { ServiceBusClient } from "@azure/service-bus";
import { Order } from "../types";


const connection = process.env.ServiceBusConnection as string;
const topicName = process.env.SB_TOPIC_NAME || "clitopic";


let sbClient: ServiceBusClient | null = null;


export async function sendOrderMessage(order: Order) {
if (!connection) throw new Error("ServiceBusConnection not configured");
if (!sbClient) sbClient = new ServiceBusClient(connection);


const sender = sbClient.createSender(topicName);
try {
if (!order.createdAt) order.createdAt = new Date().toISOString();
await sender.sendMessages({ body: order, contentType: "application/json" });
} finally {
await sender.close();
}
}