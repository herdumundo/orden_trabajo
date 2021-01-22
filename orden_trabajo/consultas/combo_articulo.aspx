<%@ Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="System.Data" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>
<% @Import Namespace="Newtonsoft.Json.Linq" %> 
<% @Import Namespace="Newtonsoft.Json" %> 
<%  
    SqlCommand rs;
    SqlDataReader dr;
    String id_maquina = Request.Params["id"];
    String maquina = id_maquina.ToString();
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
        
    String combo = "<OPTION value='-' selected>SUB CATEGORIA</OPTION>";
    rs = new SqlCommand("  select * from [@D_SUBCAT] where Code='"+maquina+"'", cnn);
    dr = rs.ExecuteReader();
    while (dr.Read())
    {
    combo = combo + "<OPTION value='"+dr["lineid"].ToString()+"'>"+dr["U_sub_Categoria"].ToString()+"</OPTION>";
    } dr.Close(); cnn.Close();
    JObject ob = new JObject();
    ob = new JObject();
    ob.Add("combo", combo);
    Response.Write(ob);
    Response.ContentType = "application/json; charset=utf-8";
    Response.End(); %> 