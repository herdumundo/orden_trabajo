<% @Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="System.Data" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>
<% @Import Namespace="Newtonsoft.Json.Linq" %> 
<% @Import Namespace="Newtonsoft.Json" %> 
<%  SqlCommand rs;
    SqlDataReader dr;
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
    String combo = "";

    String consulta = "select * from ocrd where U_rubro_prov is not null";

    rs = new SqlCommand(consulta, cnn);
    dr = rs.ExecuteReader();
    while (dr.Read())
    {
        combo = combo + "<OPTION  value='"+dr["cardcode"].ToString()+"'>"+dr["cardname"].ToString()+"</OPTION>";
    } dr.Close(); cnn.Close();
    JObject ob = new JObject();
    ob = new JObject();
    ob.Add("combo", combo);
    Response.Write(ob);
    Response.ContentType = "application/json; charset=utf-8";
    Response.End(); %>