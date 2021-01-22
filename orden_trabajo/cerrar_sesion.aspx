<%@ Page Language="C#" AutoEventWireup="true"  %>

<% @Import Namespace="WebApplication1" %>
 <%  
     Session.Abandon();
     Session.RemoveAll();
     Response.Redirect("login.aspx");
  %>