<%@ WebHandler Language="C#" Class="SimpleSessionStore" %>
using System;
using System.Web;
using System.Web.SessionState;

public class SimpleSessionStore : IHttpHandler, IRequiresSessionState
{
	public bool IsReusable
	{
		get { return false; }
	}

	public const string IdentifierForTemporaryJsonShopDataInSession = "Identifier_for_temporary_JSON_shop_data_in_Session";

	public void ProcessRequest(HttpContext context)
	{
		String output;

		try
		{
			if (context.Session != null)
			{
				//when post, try to save, else try to get
				if (context.Request.RequestType.ToLower() == "post")
				{
					string value = context.Request.Params["ValueToStore"];
					context.Session[IdentifierForTemporaryJsonShopDataInSession] = value;

					//return 0 to indicate success
					output = "0";
				}
				else
				{
					//return, whatever is stored
					output = (string)context.Session[IdentifierForTemporaryJsonShopDataInSession];
				}
			}
			else
			{
				output = "-2"; //no session exists
			}
		}
		catch (Exception ex)
		{
			output = "-1";
		}

		context.Response.AppendHeader("Access-Control-Allow-Origin", "*");
		context.Response.Write(output);
	}
}
