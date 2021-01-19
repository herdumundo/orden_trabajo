<%@ Page Language="C#" AutoEventWireup="true"  %>

<% @Import Namespace="WebApplication1.boot" %>
 <%  
     Session.Abandon();
     Session.RemoveAll();
     Response.Redirect("login.aspx");
  %>