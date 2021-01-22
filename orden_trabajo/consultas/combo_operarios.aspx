<% @Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="System.Data" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>
<% @Import Namespace="Newtonsoft.Json.Linq" %> 
<% @Import Namespace="Newtonsoft.Json" %> 
<%  SqlCommand rs;
    SqlDataReader dr;
    String conn = Global.conn;
    String tipo_registro = Request.Params["tipo_registro"];

    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
    String combo = "";

    String consulta = "select distinct  b.empid as id_empleado,(c.firstName +' '+c.lastName )as nombre, z.area  " +
                "from " +
                "ohtm a " +
                "inner join  htm1 b on a.teamID=b.teamID inner join ohem c on b.empID=c.empID " +
                "inner join grupomaehara.dbo.ot_usuario z on z.cod_usuario=b.empID  " +
                "where c.Active='Y' and  b.role='L'  and b.empid not in (40) order by 2";

    rs = new SqlCommand(consulta, cnn);
    dr = rs.ExecuteReader();
    if (tipo_registro.Equals("LOG"))
    {

        while (dr.Read())
        {
            combo = combo + "<OPTION id="+dr["area"].ToString()+" value='"+dr["id_empleado"].ToString()+"_"+dr["nombre"].ToString()+"'>"+dr["nombre"].ToString()+"</OPTION>";
        }
    }

    else
    {
         while (dr.Read())
        {
            combo = combo + "<OPTION id="+dr["area"].ToString()+" value='"+dr["id_empleado"].ToString()+"'>"+dr["nombre"].ToString()+"</OPTION>";
        }

    }

    dr.Close(); cnn.Close();
    JObject ob = new JObject();
    ob = new JObject();
    ob.Add("combo", combo);
    Response.Write(ob);
    Response.ContentType = "application/json; charset=utf-8";
    Response.End(); %>