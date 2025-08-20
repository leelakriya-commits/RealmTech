import { AzureFunction, Context, HttpRequest } from "@azure/functions";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
  context.log('HTTP trigger processed a request.');

  const name = req.query.name || (req.body && req.body.name) || 'world';
  context.res = {
    status: 200,
    body: { message: `Hello, ${name}` }
  };
};

export default httpTrigger;
