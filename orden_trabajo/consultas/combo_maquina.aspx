<% @Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="System.Data" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>
<% @Import Namespace="Newtonsoft.Json.Linq" %> 
<% @Import Namespace="Newtonsoft.Json" %> 
<%  SqlCommand rs;
    SqlDataReader dr;
    String id_origen = Request.Params["id"];
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
    String combo = "<OPTION value='' selected  disabled>Maquina</OPTION>";
    rs = new SqlCommand(" select  * from orsc where u_origen_id='"+id_origen+"' or u_origen_id is null", cnn);
    dr = rs.ExecuteReader();
    while (dr.Read())
    {
    combo = combo + "<OPTION value='"+dr["rescode"].ToString()+"'>"+dr["rescode"].ToString()+"-"+dr["resname"].ToString()+"</OPTION>";
    } dr.Close(); cnn.Close();
    JObject ob = new JObject();
    ob = new JObject();
    ob.Add("combo", combo);
    Response.Write(ob);
    Response.ContentType = "application/json; charset=utf-8";
    Response.End(); %>