<%@ Application Codebehind="Global.asax.cs" Inherits="WSDocumentManager.Global" Language="C#" %>

<script runat="server">
	protected void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs      
        // Get the exception object.
        Exception exc = Server.GetLastError();

        if (exc.Message.IndexOf("transport-level", StringComparison.OrdinalIgnoreCase) > 0 || exc.Message.IndexOf("network-related", StringComparison.OrdinalIgnoreCase) > 0 || exc.Message.IndexOf("HttpUnhandledException", StringComparison.OrdinalIgnoreCase) > 0)
        {
            // SQL Server error -> Mirroring: must restart AppDomain to refresh connection string.
            Server.ClearError();
            Insyma.Utility.CUWebApp.RestartAppDomain(true, "");
        }

    }
</script>
