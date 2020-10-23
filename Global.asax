<%@ Application Language="VB" %>

<script runat="server">

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
		' Code that runs on application startup
		TurnOffDirectoryMonitoring()
    End Sub
    
    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs on application shutdown
    End Sub
        
	Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when an unhandled error occurs      
        ' Get the exception object.
        Dim exc As Exception = Server.GetLastError
        Dim errMessage As String = exc.Message
        
        If Not exc.InnerException Is Nothing Then
            errMessage += exc.InnerException.Message
        End If
        
        Dim friendlyErrorMessage As String = ""
        If errMessage.IndexOf("transport-level") > 0 Or errMessage.IndexOf("network-related") > 0 Then
            ' SQL Server error -> Mirroring: must restart AppDomain to refresh connection string.
            Server.ClearError()
            Insyma.Utility.CUWebApp.RestartAppDomain(True, "")
            
            Insyma.ContentUpdate.DevLog.Write("Application_Error_Restart", String.Format("{0} {1} {2}", errMessage, exc.Source, exc.StackTrace))
            
        ElseIf Insyma.ContentUpdate.UtilCommon.DisplayFriendlyErrorMessage(Insyma.ContentUpdate.Identity.Name, friendlyErrorMessage) Then
            
            Insyma.ContentUpdate.DevLog.Write("Application_Error_Friendly", String.Format("{0} {1} {2}", errMessage, exc.Source, exc.StackTrace))			  
            Response.Write(friendlyErrorMessage)
			  
            '' Clear the error from the server
            Server.ClearError()
        Else
            Insyma.ContentUpdate.DevLog.Write("Application_Error", String.Format("{0} {1} {2}", errMessage, exc.Source, exc.StackTrace))
        End If
      
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when a new session is started
	 	 
        If (Session("CUSessionState") Is Nothing) Then
            Dim _tSession As New Insyma.SessionState.CUSessionState
            Session.Add("CUSessionState", _tSession)
        End If

    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when a session ends. 
        ' Note: The Session_End event is raised only when the sessionstate mode
        ' is set to InProc in the Web.config file. If session mode is set to StateServer 
        ' or SQLServer, the event is not raised.
        Dim clsSessionState As CUSessionState=  CType(Session("CUSessionState"),CUSessionState)
        If (Not (Session("CUSessionState") Is Nothing)) Then
			clsSessionState.DeleteToken()
        End If

    End Sub
       


    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires upon attempting to authenticate the use
        Insyma.ContentUpdate.Security.CreatePrincipal()
    End Sub


    Protected Sub Application_BeginRequest(sender As Object, e As EventArgs)

'		' SPAM Schutz von [] eingebaut []
'		If (Request.Url.AbsoluteUri.IndexOf("tool") = -1 AndAlso Request.Url.AbsoluteUri.IndexOf(".axd") = -1 AndAlso Request.Url.AbsoluteUri.IndexOf("web") > -1 AndAlso Request.Url.AbsoluteUri.IndexOf("/mail/") = -1) Then
'			Response.Filter = New Insyma.Utils.LinkFilter(Response.Filter)
'		 End If



' 		' we guess at this point session is not already retrieved by application so we recreate cookie with the session id... 

		Try
			Dim session_param_name As String = "ASPSESSID"
			Dim session_cookie_name As String = "ASP.NET_SessionId"

			If HttpContext.Current.Request.Form(session_param_name) IsNot Nothing Then
				UpdateCookie(session_cookie_name, HttpContext.Current.Request.Form(session_param_name))
			ElseIf HttpContext.Current.Request.QueryString(session_param_name) IsNot Nothing Then
				UpdateCookie(session_cookie_name, HttpContext.Current.Request.QueryString(session_param_name))
			End If
		Catch
		End Try

		Try
			Dim auth_param_name As String = "AUTHID"
			Dim auth_cookie_name As String = FormsAuthentication.FormsCookieName

			If HttpContext.Current.Request.Form(auth_param_name) IsNot Nothing Then
				UpdateCookie(auth_cookie_name, HttpContext.Current.Request.Form(auth_param_name))
			ElseIf HttpContext.Current.Request.QueryString(auth_param_name) IsNot Nothing Then
				UpdateCookie(auth_cookie_name, HttpContext.Current.Request.QueryString(auth_param_name))

			End If
		Catch
		End Try
	End Sub

	Private Sub UpdateCookie(cookie_name As String, cookie_value As String)
		Dim cookie As HttpCookie = HttpContext.Current.Request.Cookies.[Get](cookie_name)
		If cookie Is Nothing Then
			cookie = New HttpCookie(cookie_name)
		End If
		cookie.Value = cookie_value
		HttpContext.Current.Request.Cookies.[Set](cookie)
	End Sub

	Private Sub TurnOffDirectoryMonitoring()
		Try
			Dim p As System.Reflection.PropertyInfo = GetType(System.Web.HttpRuntime).GetProperty("FileChangesMonitor", System.Reflection.BindingFlags.NonPublic Or System.Reflection.BindingFlags.Public Or System.Reflection.BindingFlags.Static)
			Dim o As Object = p.GetValue(Nothing, Nothing)

			Dim f As System.Reflection.FieldInfo = o.GetType.GetField("_dirMonSubdirs", System.Reflection.BindingFlags.Instance Or System.Reflection.BindingFlags.NonPublic Or System.Reflection.BindingFlags.IgnoreCase)

			Dim monitor As Object = f.GetValue(o)

			Dim mInfo As System.Reflection.MethodInfo() = monitor.GetType.GetMethods()

			Dim propIsMonitoring As System.Reflection.MethodInfo = monitor.GetType.GetMethod("IsMonitoring", System.Reflection.BindingFlags.Instance Or System.Reflection.BindingFlags.NonPublic)
			Dim bIsMonitoring As Boolean = propIsMonitoring.Invoke(monitor, Nothing)
			Dim m As System.Reflection.MethodInfo = monitor.GetType.GetMethod("StopMonitoring", System.Reflection.BindingFlags.Instance Or System.Reflection.BindingFlags.NonPublic)

			Dim objArray() As Object = {}
			m.Invoke(monitor, objArray)
			
			Insyma.ContentUpdate.DevLog.Write("TurnOffDirectoryMonitoring", "Success")
		Catch ex As Exception
			Insyma.ContentUpdate.DevLog.Write("TurnOffDirectoryMonitoring", ex.Message)
		End Try
	End Sub
</script>